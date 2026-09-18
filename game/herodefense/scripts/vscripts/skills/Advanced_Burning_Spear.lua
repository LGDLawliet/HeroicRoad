
Advanced_Burning_Spear = class({})

LinkLuaModifier("modifier_Advanced_Burning_Spear", "skills/Advanced_Burning_Spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Burning_Spear_orb", "skills/Advanced_Burning_Spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Burning_Spear_debuff", "skills/Advanced_Burning_Spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Burning_Spear_unlock1", "skills/Advanced_Burning_Spear", LUA_MODIFIER_MOTION_NONE)


--check kv
function Advanced_Burning_Spear:CheckKV(key)
	local table = {
		atb_damage  	= 0.02,
	}
	local value = table[key] or -1
	return value
end
function Advanced_Burning_Spear:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Burning_Spear_unlock1",{})
	return true
end
function Advanced_Burning_Spear:UnlockSecondCore(key)
	return true
end
function Advanced_Burning_Spear:UnlockThirdCore(key)
	return true
end
function Advanced_Burning_Spear:GetIntrinsicModifierName() return "modifier_Advanced_Burning_Spear_orb" end
function Advanced_Burning_Spear:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear.vpcf", context )
    PrecacheResource( "particle", "particlesecon/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf", context )
end
function Advanced_Burning_Spear:GetHealthCost(iLevel)
	return self:GetCaster():GetHealth()*self:GetSpecialValueFor("hp_cost_pct")*0.01 --待办事项1：火矛生命值消耗最大生命值→固定值+当前生命值，且不再成长
end

function Advanced_Burning_Spear:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange() 
end

function Advanced_Burning_Spear:OnSpellStart(orbTarget)
	local caster = self:GetCaster()
	local target = orbTarget or  self:GetCursorTarget()
	if not target then --待办事项3：对远程修正：扣血效果将在到达时且敌人存活时生效
		return
	end
    
	local damage = self:GetCaster():HDGetPrimaryStatValue()*self:GetSpecialValueFor("atb_damage") + self:GetSpecialValueFor("damage")--待办事项4：火矛消耗生命值伤害→固定值+主属性
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear.vpcf",
		iMoveSpeed = 1500,
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
		ExtraData = {
			damage = damage,
		}  
	}
	ProjectileManager:CreateTrackingProjectile(info)
end


function Advanced_Burning_Spear:OnProjectileHit_ExtraData(target, location, kv)
	if not target or not target:IsAlive() then
		return
	end
	local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

	self:UseResources(true, true, true, true)
	local modifier = target:FindModifierByName("modifier_Advanced_Burning_Spear_debuff")
    if modifier then
		local duration_amplify = self:GetSpecialValueFor("duration_amplify")
		if self:GetSpecialValueFor("advanced_level")>=5 then
			duration_amplify = duration_amplify + 0.1
		end
        duration = duration +math.min(self:GetSpecialValueFor("max_bonus_duration"),duration_amplify * modifier:GetStackCount())
    end
    target:AddNewModifier(caster, self, "modifier_Advanced_Burning_Spear_debuff", {duration = duration,buff_duration = duration,damage=kv.damage})

end


function Advanced_Burning_Spear:AddKillCount(target)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Burning_Spear_unlock1",{})
end


modifier_Advanced_Burning_Spear_debuff = advanced_modifier({})

function modifier_Advanced_Burning_Spear_debuff:IsDebuff()			return true end
function modifier_Advanced_Burning_Spear_debuff:IsHidden() 			return false end
function modifier_Advanced_Burning_Spear_debuff:IsPurgable() 		return false end
function modifier_Advanced_Burning_Spear_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Burning_Spear_debuff:GetEffectName() return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf"  end
--GetEffectAttachType
function modifier_Advanced_Burning_Spear_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW  end
function modifier_Advanced_Burning_Spear_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.interval = 0.5
		self.tData = {}
		self.damage = keys.damage
		table.insert(self.tData, { 
			dieTime = GameRules:GetGameTime()+keys.buff_duration,
			buff_duration = keys.buff_duration,
			damage = keys.damage
		})
		self:IncrementStackCount()
		self:StartIntervalThink(self.interval)

		
    end
end
function modifier_Advanced_Burning_Spear_debuff:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, { 
			dieTime = GameRules:GetGameTime()+keys.buff_duration,
			buff_duration = keys.buff_duration,
			damage = keys.damage
		})
		self.damage = self.damage + keys.damage
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Burning_Spear_debuff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				if self:GetAbility().unlock3 and 50>=RandomInt(1, 100) then
					self.tData[i].dieTime = self.tData[i].dieTime + self.tData[i].buff_duration
					self:SetDuration(math.max(self:GetRemainingTime(),self.tData[i].buff_duration), true)
				else
					self.damage = self.damage - self.tData[i].damage 
					table.remove(self.tData, i)
					self:DecrementStackCount()
				end
				
			end
		end
		self:PlayEffect()

	end
end

function modifier_Advanced_Burning_Spear_debuff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if not ability then
			return
		end
		-- print("22222222222222")
		local parent =  self:GetParent()
		if not parent:IsAlive() and ability:GetSpecialValueFor("advanced_level")>=15 then
			local stack = self:GetStackCount()
			-- print("333333333")
			if stack>=1 then
				if ability.unlock1 then
					ability:AddKillCount()
				end
		
				local caster = self:GetCaster()
				local units = FindUnitsInRadius(
					caster:GetTeamNumber(),	-- int, your team number
					parent:GetAbsOrigin(),	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
					DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
					FIND_CLOSEST,	-- int, order filter
					false	-- bool, can grow cache
				)
				-- print("4444444444")
	
				for _, unit in ipairs(units) do
					-- print("55555555555")
					for i = #self.tData, 1, -1 do
						local dieTime = self.tData[i].dieTime
						local duration = dieTime - GameRules:GetGameTime()
						unit:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Burning_Spear_debuff", {duration = duration,buff_duration = duration,damage=self.tData[i].damage})
					end
					break
				end
	
				
			end
		end
	end
end

function modifier_Advanced_Burning_Spear_debuff:PlayEffect()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local dmg = self.damage
	if dmg<=0 then
		return
	end
	local damage = ApplyDamage({
		victim = self:GetParent(), 
		attacker = self:GetCaster(), 
		damage = dmg *self.interval, 
		damage_type = self:GetAbility():GetAbilityDamageType(), 
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, 
		hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_FIRE_DAMAGE,
		ability = self:GetAbility()
	})
end


function modifier_Advanced_Burning_Spear_debuff:ADDeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
		self.bonus_damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_enhence")
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
    return funcs
end
function modifier_Advanced_Burning_Spear_debuff:Advanced_GetModifierIncomingDamage_Percentage()	
    return self.bonus_damage_per_stack * self:GetStackCount()
end
function modifier_Advanced_Burning_Spear_debuff:OnDeath(keys)
	local caster = self:GetCaster()
	local heal = (caster:GetMaxHealth()-caster:GetHealth())*self:GetAbility():GetSpecialValueFor("hplose_heal")*0.01
	if keys.attacker == caster then
        keys.attacker:Heal(heal, self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, heal, nil)
    end
end


modifier_Advanced_Burning_Spear_orb = advanced_modifier({})

function modifier_Advanced_Burning_Spear_orb:IsDebuff()			return false end
function modifier_Advanced_Burning_Spear_orb:IsHidden() 			return true end
function modifier_Advanced_Burning_Spear_orb:IsPurgable() 		return false end
function modifier_Advanced_Burning_Spear_orb:IsPurgeException() 	return false end

function modifier_Advanced_Burning_Spear_orb:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	}
end

function modifier_Advanced_Burning_Spear_orb:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return 0
	end
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local attacker = keys.attacker
    if attacker:FindModifierByName("modifier_Advanced_Burning_Spear_debuff") then
		
        if ability.unlock2 then
            return -95
        end
		if self:GetParent():GetHealthPercent()<=20 then
			return -self:GetAbility():GetSpecialValueFor("incoming_active")
		end
		if self:GetAbility():GetAutoCastState() then
			return -self:GetAbility():GetSpecialValueFor("incoming_down")
		end
		
    end
    return 0
end

function modifier_Advanced_Burning_Spear_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if keys.attacker ~= parent or parent:IsSilenced() or parent:IsIllusion() or not ability:GetAutoCastState() then
		return
	end
	if not ability:IsFullyCastable() then
		return
	end
	if not parent:IsApplyModifier() then
		return
	end
	if not IsEnemy(keys.target,parent) then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
    ability:OnSpellStart(keys.target)
end





modifier_Advanced_Burning_Spear_unlock1 = advanced_modifier({})

function modifier_Advanced_Burning_Spear_unlock1:IsDebuff()			return false end
function modifier_Advanced_Burning_Spear_unlock1:IsHidden() 			return false end
function modifier_Advanced_Burning_Spear_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Burning_Spear_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Burning_Spear_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Burning_Spear_unlock1:OnCreated(keys)
	self.bonus_health_per_stack = 100
end
function modifier_Advanced_Burning_Spear_unlock1:OnRefresh()
	
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Burning_Spear_unlock1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_Advanced_Burning_Spear_unlock1:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierHealthBonus()
	end
end


function modifier_Advanced_Burning_Spear_unlock1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end
function modifier_Advanced_Burning_Spear_unlock1:AdvancedGetModifierHealthBonus(keys)
	return self.bonus_health_per_stack * self:GetStackCount()
end

