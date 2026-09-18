
Advanced_true_form = class({})
LinkLuaModifier("modifier_Advanced_true_form_transform_stun", "skills/Advanced_true_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_true_form_transform", "skills/Advanced_true_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_true_form_debuff", "skills/Advanced_true_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_true_form_unlock2", "skills/Advanced_true_form", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_true_form_transform_unlock2_active", "skills/Advanced_true_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_true_form_unlock3_thinker_arua_effect", "skills/Advanced_true_form", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_true_form_unlock3_thinker", "skills/Advanced_true_form", LUA_MODIFIER_MOTION_NONE)


function  Advanced_true_form:CheckKV(key)
	local table = {
		duration=0.5,
		bonus_armor=0.7,
		bonus_health=60,
		bonus_damage=10,

	}
	local value = table[key] or -1
	return value

end
function Advanced_true_form:UnlockFirstCore(key)
	return true
end
function Advanced_true_form:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_true_form_unlock2",{})
	return true
end
function Advanced_true_form:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_counterspell_unlock3",{})
	return true
end

function Advanced_true_form:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/true_form/unlock3/effect_ring.vpcf", context )
	PrecacheResource( "model", "models/items/lone_druid/true_form/wizened_bear/wizened_bear.vmdl", context )

end


function Advanced_true_form:GetCastRange(vLocation, hTarget)

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local radius = 1000
	--LV5解锁森林之王+
	if advanced_level>=5 then
		radius = 1500
	end
	return radius
end

function Advanced_true_form:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local transformation_time = 1.2
	local duration = ability:GetSpecialValueFor("duration")
	
	-- Start transformation gesture
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)



	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Advanced_true_form_transform"
	
	-- Play cast sound
	EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
	
	-- Add cast particle effects
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_true_form.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 3 , caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	-- Disable Lycan for the transform duration
	caster:AddNewModifier(caster, ability, "modifier_Advanced_true_form_transform_stun", {duration = transformation_time})
	
	-- Wait the transformation time
	Timers:CreateTimer(transformation_time, function()
		-- Give Lycan transform buff
		local radius = 1000
		local bonus_health_indx = 0.1
		--LV5解锁森林之王+
		if self.advanced_level>=5 then
			radius = 1500
			bonus_health_indx = 0.15
		end

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		table.remove(units,1)
		local bonus_health = 0
		local bonus_damage = 0
		for _, unit in ipairs(units) do
			if unit:IsRealHero() then
				bonus_health = bonus_health + unit:GetMaxHealth()*bonus_health_indx
				--LV20解锁森林之王++
				if self.advanced_level>=20 then
					bonus_damage= bonus_damage + unit:GetDamageMax()*0.2
				end
			end
		end



		bonus_health = math.min(bonus_health,200000)
		local gain = caster:GetModifierDurationGainIndex(0.3)
		caster:AddNewModifier(caster, ability, "modifier_Advanced_true_form_transform", {duration = duration*gain,bonus_health=bonus_health,bonus_damage=bonus_damage})

		if self.unlock3 then
			CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_true_form_unlock3_thinker", 
			{}, -- kv
			caster:GetOrigin(),
			caster:GetTeamNumber(),
			false
		)
		end
		
	end)	
end


modifier_Advanced_true_form_transform_stun = class({})

function modifier_Advanced_true_form_transform_stun:CheckState()	
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end
function modifier_Advanced_true_form_transform_stun:IsHidden()
	return true
end

modifier_Advanced_true_form_transform = advanced_modifier({})
function modifier_Advanced_true_form_transform:IsHidden()	return false end
function modifier_Advanced_true_form_transform:IsPurgable()	return false end
function modifier_Advanced_true_form_transform:IsDebuff()	return false end
function modifier_Advanced_true_form_transform:IsAura() return true end
function modifier_Advanced_true_form_transform:GetAuraDuration() return 0.5 end
function modifier_Advanced_true_form_transform:GetModifierAura() return "modifier_Advanced_true_form_debuff" end
function modifier_Advanced_true_form_transform:GetAuraRadius() return 1500 end
function modifier_Advanced_true_form_transform:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_true_form_transform:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_true_form_transform:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_Advanced_true_form_transform:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,


		}
		-- if self:GetAbility():GetUnlock(1)==1 then
		-- 	table.insert(decFuncs,MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
		-- end
		
		return decFuncs	
end
function modifier_Advanced_true_form_transform:GetModifierModelScale() 
    return self.ModelScale
end

-- function modifier_Advanced_true_form_transform:GetModifierTotalDamageOutgoing_Percentage() 
--     if IsServer() then
-- 		return math.min((self:GetParent():GetModelScale()) *40,200)
-- 	end
-- end

function modifier_Advanced_true_form_transform:GetModifierModelChange()
	return "models/items/lone_druid/true_form/wizened_bear/wizened_bear.vmdl"
end

function modifier_Advanced_true_form_transform:OnCreated(keys)
	self.ability = self:GetAbility()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")


	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	
	self.bonus_attack_speed = -self.ability:GetSpecialValueFor("bonus_attack_speed")	
	self.ModelScale = 25
	self.AttackRange = 200
	--LV15解锁巨大化
	if self.advanced_level>=15 then
		self.ModelScale = 55
		self.AttackRange = 400

		
	end
	
	if IsServer() then
		self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")+keys.bonus_health 
		self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")+ keys.bonus_damage
		-- print(self.bonus_damage)
		-- print(keys.bonus_damage)
		self:SetStackCount(keys.bonus_health)
		-- print(self:GetParent():GetModelScale())
		
	end
  
end



function modifier_Advanced_true_form_transform:Advanced_GetModifierAttackRangeOverride() 	return self.AttackRange end

--
function modifier_Advanced_true_form_transform: GetModifierHealthBonus() 	return self.bonus_health end
function modifier_Advanced_true_form_transform:Advanced_GetModifierPhysicalArmorBonus() 	return self.bonus_armor end
function modifier_Advanced_true_form_transform:GetModifierBaseAttack_BonusDamage() 	return self.bonus_damage end
function modifier_Advanced_true_form_transform:Advanced_GetModifierAttackSpeedPercentage() 	return self.bonus_attack_speed end



-- advanced_modifier
function modifier_Advanced_true_form_transform:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
		
    }
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_StatusResistance)
	end
	if self:GetAbility():GetUnlock(1)==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	end

	return funcs

end
function modifier_Advanced_true_form_transform:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		return math.min((self:GetParent():GetModelScale()) *40,200)
	end
end

function modifier_Advanced_true_form_transform:Advanced_GetModifier_StatusResistance(keys)
	return 50
end



modifier_Advanced_true_form_debuff = advanced_modifier({})

function modifier_Advanced_true_form_debuff:IsDebuff() return true end
function modifier_Advanced_true_form_debuff:IsHidden() return false end
function modifier_Advanced_true_form_debuff:IsPurgable() return false end
-- function modifier_Advanced_true_form_debuff:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
	

-- 	}
-- end
function modifier_Advanced_true_form_debuff:OnCreated(table)
	if IsServer() then
		self.bonus_damage = -15
		--LV10解锁战场支配+
		if self:GetAbility().advanced_level>=10 then
			self.bonus_damage = -22
		end
	end
end
-- function modifier_Advanced_true_form_debuff:GetModifierTotalDamageOutgoing_Percentage()return self.bonus_damage end


-- advanced_modifier
function modifier_Advanced_true_form_debuff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }


	return funcs

end
function modifier_Advanced_true_form_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.bonus_damage
end


modifier_Advanced_true_form_unlock2 = class({})

function modifier_Advanced_true_form_unlock2:IsDebuff()			return false end
function modifier_Advanced_true_form_unlock2:IsHidden() 			return true end
function modifier_Advanced_true_form_unlock2:IsPurgable() 		return false end
function modifier_Advanced_true_form_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_true_form_unlock2:AllowIllusionDuplicate() return false end
function modifier_Advanced_true_form_unlock2:RemoveOnDeath() return false end

function modifier_Advanced_true_form_unlock2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		unit:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_true_form_transform_unlock2_active", {})
	end
end




modifier_Advanced_true_form_transform_unlock2_active = advanced_modifier({})
function modifier_Advanced_true_form_transform_unlock2_active:IsHidden()	return false end
function modifier_Advanced_true_form_transform_unlock2_active:IsPurgable()	return false end
function modifier_Advanced_true_form_transform_unlock2_active:IsDebuff()	return false end


function modifier_Advanced_true_form_transform_unlock2_active:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,

		}

		
		return decFuncs	
end


function modifier_Advanced_true_form_transform_unlock2_active:OnCreated(keys)
	self.ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level


	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")*0.5
	
	self.bonus_attack_speed = -self.ability:GetSpecialValueFor("bonus_attack_speed")	*0.5
	if IsServer() then
		-- self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")*0.5
		self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")*0.5

		-- self:SetStackCount(keys.bonus_health)

		
	end
  
end




function modifier_Advanced_true_form_transform_unlock2_active:AdvancedGetModifierExtraHealthPercentage() 	return 20 end
function modifier_Advanced_true_form_transform_unlock2_active:Advanced_GetModifierPhysicalArmorBonus() 	return self.bonus_armor end
function modifier_Advanced_true_form_transform_unlock2_active:GetModifierBaseAttack_BonusDamage() 	return self.bonus_damage end
function modifier_Advanced_true_form_transform_unlock2_active:Advanced_GetModifierAttackSpeedPercentage() 	return self.bonus_attack_speed end

function modifier_Advanced_true_form_transform_unlock2_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
    }
end

modifier_Advanced_true_form_unlock3_thinker= modifier_Advanced_true_form_unlock3_thinker or class({})

function modifier_Advanced_true_form_unlock3_thinker:IsHidden()		return true end
function modifier_Advanced_true_form_unlock3_thinker:IsPurgable()		return false end
function modifier_Advanced_true_form_unlock3_thinker:RemoveOnDeath()	return false end
function modifier_Advanced_true_form_unlock3_thinker:IsAura() return true end
function modifier_Advanced_true_form_unlock3_thinker:GetAuraDuration() return 0.01 end
function modifier_Advanced_true_form_unlock3_thinker:GetModifierAura() return "modifier_Advanced_true_form_unlock3_thinker_arua_effect" end
function modifier_Advanced_true_form_unlock3_thinker:GetAuraRadius() return 1000 end
function modifier_Advanced_true_form_unlock3_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_Advanced_true_form_unlock3_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_true_form_unlock3_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_true_form_unlock3_thinker:GetAuraEntityReject(hEntity)

	if hEntity:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() then
		return false
	end
	return true
end
function modifier_Advanced_true_form_unlock3_thinker:OnCreated(keys)
	if IsServer() then
		local particle_cast = "particles/rebuild/spell/true_form/unlock3/effect_ring.vpcf"
		self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetParent() )
		local pos = self:GetParent():GetOrigin()
		ParticleManager:SetParticleControl( self.effect_cast, 0, pos )
		ParticleManager:SetParticleControl( self.effect_cast, 10, Vector( 1000, 0, 0 ) )

		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_true_form_unlock3_thinker:OnDestroy()
	if IsServer() then
		if self.effect_cast then
			ParticleManager:DestroyParticle(self.effect_cast,false)
			ParticleManager:ReleaseParticleIndex(self.effect_cast)
		end
		if self:GetParent() and not self:GetParent():IsNull() then
			UTIL_Remove( self:GetParent() )
		end
		
	end
end





modifier_Advanced_true_form_unlock3_thinker_arua_effect= modifier_Advanced_true_form_unlock3_thinker_arua_effect or advanced_modifier({})
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:IsDebuff() return false end
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:IsHidden()		return false end
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:IsPurgable()		return false end
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:RemoveOnDeath()	return false end
-- function modifier_Advanced_true_form_unlock3_thinker_arua_effect:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
-- 	}
-- end
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:OnCreated(keys)
	if IsServer() then
		if self:GetParent()==self:GetCaster() then
			self.time = GameRules:GetGameTime()
			self:StartIntervalThink(0.06)
		end
	end
end
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:OnIntervalThink()
	local parent  = self:GetParent()
	local modifier = parent:FindModifierByName("modifier_Advanced_true_form_transform")
	if not modifier then
		self:SafeDestroy()
		return
	end
	local time = GameRules:GetGameTime()-self.time
	self.time = GameRules:GetGameTime()
	modifier:SetDuration(modifier:GetRemainingTime()+time,true)
end
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:OnDestroy(table)
	if IsServer() then
		if self:GetParent()==self:GetCaster() then
			if self:GetAuraOwner() and not self:GetAuraOwner():IsNull() then
				UTIL_Remove( self:GetAuraOwner() )
			end
			
		end
	end
end
-- function modifier_Advanced_true_form_unlock3_thinker_arua_effect:GetModifierTotalDamageOutgoing_Percentage()return 45 end


-- advanced_modifier
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }


	return funcs

end
function modifier_Advanced_true_form_unlock3_thinker_arua_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 45
end