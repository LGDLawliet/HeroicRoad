--特效优化 √
Advanced_Dual_Breath = class({})

LinkLuaModifier("modifier_Advanced_Dual_Breath_debuff", "skills/Advanced_Dual_Breath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Dual_Breath_debuff2", "skills/Advanced_Dual_Breath", LUA_MODIFIER_MOTION_NONE)
function Advanced_Dual_Breath:IsHiddenWhenStolen() 		return false end
function Advanced_Dual_Breath:IsRefreshable() 			return true  end
function Advanced_Dual_Breath:IsStealable() 				return true  end
function Advanced_Dual_Breath:IsNetherWardStealable() 	return true end
function Advanced_Dual_Breath:GetCastRange()   return self:GetSpecialValueFor("Project_range") end 
require('internal/timers')   --计时器功能

function Advanced_Dual_Breath:CheckKV(key)
	local table = {

		damage_per_second =3,
		intelligence_index = 0.02,
		move_slow = 2,
		attack_speed_slow = 1,
		duration = 0.1,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Dual_Breath:UnlockFirstCore(key)
	return true
end
function Advanced_Dual_Breath:UnlockSecondCore(key)
	return true
end
function Advanced_Dual_Breath:UnlockThirdCore(key)
	return true
end


function Advanced_Dual_Breath:GetBehavior()

	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_POINT +DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
		
	end

	return self.BaseClass.GetBehavior(self)
end


function Advanced_Dual_Breath:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	-- local direction = (pos - caster:GetAbsOrigin()):Normalized()
	-- direction.z = 0
	self:CreateLinearProjectile(caster:GetForwardVector())
	if self:GetAutoCastState() then
		local count = math.floor(caster:GetIntellect(false)/100)
		for i = 1, count, 1 do
			Timers:CreateTimer(i*0.2, function()
				if not self:IsNull() then 
					if caster:GetMana()>=800 then
						caster:SpendMana( 800, self )
						self:CreateLinearProjectile(caster:GetForwardVector())
					end
				end
			end)
		end
	end
	
end

function Advanced_Dual_Breath:CreateLinearProjectile(dir)
	local caster = self:GetCaster()
	-- local pos = self:GetCursorPosition()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	caster:EmitSound("Hero_Jakiro.DualBreath.Cast")
	local distance = math.max(self:GetSpecialValueFor("Project_range") + caster:GetCastRangeBonus() ,100)
	local speed = self:GetSpecialValueFor("Project_speed")
	local info = 
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("Project_radius"),
		fEndRadius = self:GetSpecialValueFor("Project_radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity =dir * speed,
		bProvidesVision = false,
		--ExtraData = {sound = sound:entindex()},
	}
	ProjectileManager:CreateLinearProjectile(info)
	local info2 = 
	{
		Ability = nil,
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_ice.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("Project_radius"),
		fEndRadius = self:GetSpecialValueFor("Project_radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = dir * speed,
		bProvidesVision = false,
		ExtraData = {no_modifier = 1},
	}
	ProjectileManager:CreateLinearProjectile(info2)
end
function Advanced_Dual_Breath:OnProjectileHit_ExtraData(target, location, keys)
	if not target or not IsServer() then
		return
	end
	if keys.no_modifier then
		return
	end
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	--local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)

	duration =  duration
	if self.unlock1 then
		duration = math.max(duration,12)
	end
	target:AddNewModifier(caster, self, "modifier_Advanced_Dual_Breath_debuff", {duration =duration })
	if self.unlock3 and 1==RandomInt(1, 2) then
		local ability1 = caster:FindAbilityByName("Advanced_Liquid_Frost")
		if ability1 then
			ability1:AddDebuff(caster,target,true)
		end
		local ability2 = caster:FindAbilityByName("Advanced_Liquid_Fire")
		if ability2 then
			ability2:AddDebuff(caster,target,true):Trigger()
		end
	end

end

modifier_Advanced_Dual_Breath_debuff = class({})

function modifier_Advanced_Dual_Breath_debuff:IsDebuff()			return true end
function modifier_Advanced_Dual_Breath_debuff:IsHidden() 			return false end
function modifier_Advanced_Dual_Breath_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Dual_Breath_debuff:IsPurgable() 		
	if IsServer() and self:GetAbility().unlock1 then
		return false		
	end	
	return true 
end
function modifier_Advanced_Dual_Breath_debuff:IsPurgeException() 
	if IsServer() and self:GetAbility().unlock1 then
		return false		
	end		
	return true 
end
function modifier_Advanced_Dual_Breath_debuff:RemoveOnDeath() return false end
-- function modifier_Advanced_Dual_Breath_debuff:GetAttributes() 
-- 	if IsServer() and self:GetAbility().unlock2 then
-- 		return MODIFIER_ATTRIBUTE_MULTIPLE
-- 	end
-- end
function modifier_Advanced_Dual_Breath_debuff:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	 MODIFIER_EVENT_ON_DEATH,
	} end

function modifier_Advanced_Dual_Breath_debuff:GetModifierMoveSpeedBonus_Constant() return (0 - self.basic_move_slow-self:GetStackCount()*4*self.slow_gain) end
function modifier_Advanced_Dual_Breath_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self.basic_attack_speed_slow-2*self:GetStackCount()*self.slow_gain) end

function modifier_Advanced_Dual_Breath_debuff:OnCreated()
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.basic_move_slow =ability:GetSpecialValueFor("move_slow")
	self.basic_attack_speed_slow =ability:GetSpecialValueFor("attack_speed_slow")
	self.basic_dmg = ability:GetSpecialValueFor("damage_per_second") + self:GetCaster():GetIntellect(false)*(ability:GetSpecialValueFor("intelligence_index"))
	self.health_damage_index = ability:GetSpecialValueFor("damage_base_health")
	--LV5解锁极热+
	if self.advanced_level >=5 then
		self.health_damage_index = 2.5
	end
	self.slow_gain = 1
	--LV10解锁极寒+
	if self.advanced_level >=10 then
		self.slow_gain = 2
	end


	if IsServer() then
		self:StartIntervalThink(ability:GetSpecialValueFor("damage_interval"))
	end
end
function modifier_Advanced_Dual_Breath_debuff:OnDeath(keys)

	if IsServer() then
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end
		local time = self:GetRemainingTime()
		local parent = self:GetParent()
		--LV20解锁液态
		if keys.unit==parent and  time>=2 and self.advanced_level>=20 then
			local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil,  350,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  		 	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
			for _, unit in pairs(units) do
			   if unit~=parent then
				-- print(time)
				local modifier = unit:FindModifierByName("modifier_Advanced_Dual_Breath_debuff")
				if modifier then
					modifier:SetDuration(modifier:GetRemainingTime()+time, true)
				else
					unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Dual_Breath_debuff", {duration =time })
				end
				break
				   
			   end

		   end
		end
	end
end

function modifier_Advanced_Dual_Breath_debuff:OnIntervalThink()
	if self:GetParent():IsMagicImmune() then
		return
	end
	if not self:GetParent():IsAlive() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	self:SetStackCount(self:GetStackCount()+1)

	
	
	local bonus_damage = parent:GetHealth() * self.health_damage_index*0.01
	local max_bonus = caster:GetMaxMana() * ability:GetSpecialValueFor("max_bonus_damage_index")
	if bonus_damage> max_bonus then
		bonus_damage = max_bonus
	end
	local dmg = self.basic_dmg + bonus_damage
	local damage_type = ability:GetAbilityDamageType()
	ApplyDamage({
		victim = parent,
		attacker = caster,
		ability = ability,
		damage = dmg,
		damage_type = damage_type,
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, parent, dmg, nil)



	--LV15解锁冰火双重天
	if self.advanced_level >=15 then
		if 50 >=RandomInt(1, 100) then

			--local StatusResistance = parent:GetHDStatusResistanceIndex(1)
			parent:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Dual_Breath_debuff2", {duration = 0.5 })
		else
			self:SetDuration(self:GetRemainingTime(), true)

		end
		
	end


end





modifier_Advanced_Dual_Breath_debuff2 = class({})

function modifier_Advanced_Dual_Breath_debuff2:IsDebuff() return true end
function modifier_Advanced_Dual_Breath_debuff2:IsHidden() return false end
function modifier_Advanced_Dual_Breath_debuff2:IsPurgable() return true end
-- function modifier_Advanced_Dual_Breath_debuff2:IsPurgeException() return true end
function modifier_Advanced_Dual_Breath_debuff2:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_Advanced_Dual_Breath_debuff2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



function modifier_Advanced_Dual_Breath_debuff2:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	
	return state
end
