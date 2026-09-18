
Middle_true_form = class({})
LinkLuaModifier("modifier_Middle_true_form_transform_stun", "skills/Middle_true_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_true_form_transform", "skills/Middle_true_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_true_form", "skills/Middle_true_form", LUA_MODIFIER_MOTION_NONE)

function Middle_true_form:Precache( context )
	PrecacheResource( "model", "models/items/lone_druid/true_form/wizened_bear/wizened_bear.vmdl", context )
end

function Middle_true_form:OnSpellStart()
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
	caster.Form_MODIFIER_NAME = "modifier_Middle_true_form_transform"
	
	-- Play cast sound
	EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
	
	-- Add cast particle effects
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_true_form.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 3 , caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	-- Disable Lycan for the transform duration
	caster:AddNewModifier(caster, ability, "modifier_Middle_true_form_transform_stun", {duration = transformation_time})
	
	-- Wait the transformation time
	Timers:CreateTimer(transformation_time, function()
		-- Give Lycan transform buff

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		table.remove(units,1)
		local bonus_health = 0
		for _, unit in ipairs(units) do
			if unit:IsRealHero() then
				bonus_health = bonus_health + unit:GetMaxHealth()*0.1
			end
		end


		bonus_health = math.min(bonus_health,200000)
		local gain = caster:GetModifierDurationGainIndex(0.3)
		caster:AddNewModifier(caster, ability, "modifier_Middle_true_form_transform", {duration = duration*gain,bonus_health=bonus_health})
	end)	
end


modifier_Middle_true_form_transform_stun = class({})

function modifier_Middle_true_form_transform_stun:CheckState()	
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end
function modifier_Middle_true_form_transform_stun:IsHidden()
	return true
end

modifier_Middle_true_form_transform = advanced_modifier({})
function modifier_Middle_true_form_transform:IsHidden()	return false end
function modifier_Middle_true_form_transform:IsPurgable()	return false end
function modifier_Middle_true_form_transform:IsDebuff()	return false end



function modifier_Middle_true_form_transform:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_PROPERTY_MODEL_SCALE,


			MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		}
		
		return decFuncs	
end
function modifier_Middle_true_form_transform:GetModifierModelScale() 
    return 25
end


function modifier_Middle_true_form_transform:GetModifierModelChange()
	return "models/items/lone_druid/true_form/wizened_bear/wizened_bear.vmdl"
end

function modifier_Middle_true_form_transform:OnCreated(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = -self.ability:GetSpecialValueFor("bonus_attack_speed")	
	
	if IsServer() then
		self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")+keys.bonus_health
		self:SetStackCount(keys.bonus_health)
	end
  
end




function modifier_Middle_true_form_transform:Advanced_GetModifierAttackRangeOverride() 	return 200 end

--
function modifier_Middle_true_form_transform:GetModifierHealthBonus() 	return self.bonus_health end
function modifier_Middle_true_form_transform:Advanced_GetModifierPhysicalArmorBonus() 	return self.bonus_armor end
function modifier_Middle_true_form_transform:GetModifierBaseAttack_BonusDamage() 	return self.bonus_damage end
function modifier_Middle_true_form_transform:Advanced_GetModifierAttackSpeedPercentage() 	return self.bonus_attack_speed end

function modifier_Middle_true_form_transform:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
    }
end