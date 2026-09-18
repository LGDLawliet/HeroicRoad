Advanced_Blade_Dance = class({})
--特效优化 √
LinkLuaModifier( "modifier_Advanced_Blade_Dance", "skills/Advanced_Blade_Dance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Blade_Dance_Dance_For_Young", "skills/Advanced_Blade_Dance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Blade_Dance_buff", "skills/Advanced_Blade_Dance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Blade_Dance_speed", "skills/Advanced_Blade_Dance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Blade_Dance_middle", "skills/Advanced_Blade_Dance", LUA_MODIFIER_MOTION_NONE )

function Advanced_Blade_Dance:GetIntrinsicModifierName()
	return "modifier_Advanced_Blade_Dance"
end
function Advanced_Blade_Dance:CheckKV(key)
	local table = {
		blade_dance_crit_mult = 1,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Blade_Dance:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/blade_dance/convict_crimson_jugger.vpcf", context )
end

function Advanced_Blade_Dance:UnlockFirstCore(key)
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Blade_Dance")
	if modifier then
		modifier:StartIntervalThink(1)
	else
		return false
	end
	return true
end
function Advanced_Blade_Dance:UnlockSecondCore(key)
	return true
end
function Advanced_Blade_Dance:UnlockThirdCore(key)
	return true
end

--------------------------------------------------------------------------
modifier_Advanced_Blade_Dance = advanced_modifier({})


function modifier_Advanced_Blade_Dance:IsHidden()
	return self:GetStackCount()<=0
end

function modifier_Advanced_Blade_Dance:IsPurgable() 		return false end
function modifier_Advanced_Blade_Dance:IsPurgeException() 	return false end
function modifier_Advanced_Blade_Dance:RemoveOnDeath()  return false end

function modifier_Advanced_Blade_Dance:OnCreated( kv )
	if IsServer() then
		self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
		self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
		self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
		self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

		self.current_target = self:GetParent()
	end
end

function modifier_Advanced_Blade_Dance:OnRefresh( kv )
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_Advanced_Blade_Dance:OnIntervalThink()
	if IsClient() or self:GetStackCount()>=120  or not Game_State:IsInBattle() or self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive() then
		return
	end
	local stack = self:GetStackCount()
	local stack_increment = 1
	local gain = stack/10
	gain = gain-gain%1
	stack_increment = stack_increment +gain
	self:SetStackCount(math.min(stack+stack_increment,120))
end
function modifier_Advanced_Blade_Dance:GetModifierBaseDamageOutgoing_Percentage() return self:GetStackCount()*8 end
function modifier_Advanced_Blade_Dance:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_Advanced_Blade_Dance:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_Advanced_Blade_Dance:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if keys.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if keys.attacker ~= self:GetParent() then
			return
		end

		local pct = self.crit_chance
		--新LV5
		if self:GetAbility().advanced_level >= 5 then
			pct = pct*1.25
		end
		local random = math.random
		if pct > random(0,100) then
			EmitSoundOn( "Hero_Juggernaut.BladeDance", keys.target )
			self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
			if self:GetAbility().advanced_level >= 5 then
				self.crit_mult = self.crit_mult*0.8
			end
			self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
			self.record = keys.record
			keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Blade_Dance_speed", {duration = self.duration})

			local middle_pct = self:GetAbility():GetSpecialValueFor("middle_chance")
			local middle_stack = self:GetAbility():GetSpecialValueFor("middle_stack")
			--新LV15
			if self:GetAbility().advanced_level >= 15 then
				middle_stack = 3
			end
			if middle_pct > random(0,100) and not self:GetParent():HasModifier("modifier_Advanced_Blade_Dance_middle") then
				keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Blade_Dance_middle", {duration = 3,stack = middle_stack})
			end
			return self.crit_mult
		end
	end
end



function modifier_Advanced_Blade_Dance:OnAttackLanded( params )
	if IsServer() then
		if params.attacker~=self:GetParent() then
			return
		end
		if params.attacker:PassivesDisabled() then
			return
		end

		local caster = self:GetParent()
		--奥义一拔刀效果
		if self:GetUnlock(1)==1 then
			local stack = self:GetStackCount()
			self:SetStackCount(stack*0.7)


			if self.record and self.record == params.record then
				self.record = nil
				local sound_cast = "Hero_Juggernaut.BladeDance"
				EmitSoundOn( sound_cast, params.target )
			end
			return
		end

		---------------
		self.advanced_level = self:GetAbility().advanced_level
		local duration = self:GetAbility():GetSpecialValueFor("active_duration")
		--新LV10
		if self.advanced_level>=10 then
			duration = 25
		end
		if self.current_target~=params.target and not caster:IsInSpecialAttack() then
			caster:AddNewModifier(caster,self:GetAbility(),"modifier_Advanced_Blade_Dance_buff",{duration = duration})
		end
		if self.advanced_level>=10 and self.current_target==params.target and not caster:IsInSpecialAttack() then
			local random = math.random
			if 2 > random(0,100) then
				caster:AddNewModifier(caster,self:GetAbility(),"modifier_Advanced_Blade_Dance_buff",{duration = duration})
			end
		end
		self.current_target = params.target
		--LV20
		if self.advanced_level>=20  and not caster:IsInSpecialAttack() then
			local random = math.random
			local chance = 8
			if self:GetUnlock(3)==3 then
				chance = 70
			end
			if chance > random(0,100) then
				local units = FindUnitsInRadius(caster:GetTeamNumber(), params.target:GetAbsOrigin(), nil, 300, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER , false)
				for _, unit in ipairs(units) do
					if unit~=params.target then
						local modifier_keys = {
							duration = 0.1,
							iSpecialAttack = 1,
							iDisableApplyModifier = 0,
							iDisableCleave =0,
							iDisableSplit = 0,
					
						}
						local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
						caster:PerformAttack(unit, false, true, true, false, true, false, true)
						if IsValid(attackEffectRecord) then
							attackEffectRecord:Destroy()
						end
						break
					end
				end
			end
		end

		if self:GetUnlock(2)==2 then
			local damage = params.damage
			if damage>=10 and self:GetCaster():GetRandomEffect(10,INT_TYPE,0.5)>=RandomInt(1, 100) then
		
				params.target:ModifyHealth(params.target:GetHealth() -damage*5,self:GetAbility(),false,0)
				local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/blade_dance/convict_crimson_jugger.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
				ParticleManager:SetParticleControl( effect_cast, 0, params.target:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex(effect_cast)
				params.target:EmitSound("DOTA_Item.AbyssalBlade.Activate")
			end

		end


		if self.record and self.record == params.record then
			self.record = nil
		end
	end
end

-----------------------------------------------------------------------
modifier_Advanced_Blade_Dance_buff = advanced_modifier({})


function modifier_Advanced_Blade_Dance_buff:IsHidden() return false end
function modifier_Advanced_Blade_Dance_buff:IsPurgable() return false end

function modifier_Advanced_Blade_Dance_buff:OnCreated(params)
	self.ability = self:GetAbility()
	self.speed = self.ability:GetSpecialValueFor("active_speed")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Blade_Dance_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		local max_count = self:GetAbility():GetSpecialValueFor("stack_max")
		if self:GetStackCount()>= max_count then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_Blade_Dance_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end


function modifier_Advanced_Blade_Dance_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
	return funcs
end
function modifier_Advanced_Blade_Dance_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifier_Advanced_Blade_Dance_buff:Advanced_GetModifierAttackSpeedPercentage() return self:GetStackCount()*self.speed end
function modifier_Advanced_Blade_Dance_buff:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount()*self.speed end


------------------------------------------
modifier_Advanced_Blade_Dance_speed = advanced_modifier({})

function modifier_Advanced_Blade_Dance_speed:IsHidden() return false end
function modifier_Advanced_Blade_Dance_speed:IsPurgable() 		return false end
function modifier_Advanced_Blade_Dance_speed:IsPurgeException() 	return false end

function modifier_Advanced_Blade_Dance_speed:OnCreated()
	self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if not IsServer() then
		return
	end
end

function modifier_Advanced_Blade_Dance_speed:OnRefresh()
	self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if not IsServer() then
		return
	end
end

function modifier_Advanced_Blade_Dance_speed:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_Advanced_Blade_Dance_speed:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

------------------------------------------
modifier_Advanced_Blade_Dance_middle = advanced_modifier({})

function modifier_Advanced_Blade_Dance_middle:IsHidden() return true end
function modifier_Advanced_Blade_Dance_middle:IsPurgable() 		return false end
function modifier_Advanced_Blade_Dance_middle:IsPurgeException() 	return false end

function modifier_Advanced_Blade_Dance_middle:OnCreated(keys)
	self.attack_speed = 700
	if not IsServer() then
		return
	end
	self.stack = keys.stack
	self:SetStackCount(self.stack)
end

function modifier_Advanced_Blade_Dance_middle:OnRefresh(keys)
	self.attack_speed = 700
	if not IsServer() then
		return
	end
	self.stack = keys.stack
	self:SetStackCount(self.stack)
end

function modifier_Advanced_Blade_Dance_middle:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_Advanced_Blade_Dance_middle:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_Advanced_Blade_Dance_middle:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	}
end

function modifier_Advanced_Blade_Dance_middle:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.attacker:IsInSpecialAttack() then
		return
	end
	self:SetStackCount(self:GetStackCount()-1)
	if self:GetStackCount() <= 0 then
		self:SafeDestroy()
	end
end


--让周围友军跟随攻击，就这么删掉太可惜了
			--if self.advanced_level>=15 and self:GetCaster():GetRandomEffect(50,INT_TYPE,0.5) >=RandomInt(1, 100) and self:GetAbility():IsCooldownReady() then
			--	local units = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 500, 
			--	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_NONE, FIND_CLOSEST, false)
			--	for _, unit in ipairs(units) do
			--		if unit~=caster then
			--			local modifier_keys = {
			---				duration = 0.1,
			--				iSpecialAttack = 1,
			--				iDisableApplyModifier = 0,
			--				iDisableCleave =1,
			--				iDisableSplit = 1,
			--		
			--			}
			--			local attackEffectRecord = unit:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
						
			--			unit:PerformAttack(params.target, false, true, true, false, true, false, true)
			--			if IsValid(attackEffectRecord) then
			--				attackEffectRecord:Destroy()
			--			end
			--			self:GetAbility():StartCooldown(0.1)
			--			break
			--		end
			--	end
			--end