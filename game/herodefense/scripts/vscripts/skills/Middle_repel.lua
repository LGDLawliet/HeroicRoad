
Middle_repel = class({})
LinkLuaModifier("modifier_Middle_repel", "skills/Middle_repel", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能

function Middle_repel:IsHiddenWhenStolen()	return false end




function Middle_repel:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget() 
	local target_cast_response = "omniknight_omni_ability_repel_0"..math.random(1,6)
	local self_cast_response = {"omniknight_omni_ability_repel_01", "omniknight_omni_ability_repel_05", "omniknight_omni_ability_repel_06"}
	local sound_cast = "Hero_Omniknight.Repel"    

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")    

	-- Target cast responses
	if target ~= caster then
		EmitSoundOn(target_cast_response, caster)
	else
		-- Self cast responses
		EmitSoundOn(self_cast_response[math.random(1, #self_cast_response)], caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)    

	-- Repel the target
	
	self:Repel(caster, ability, target, duration)

	-- #6 Talent: Repel affects nearby allies briefly
	-- if caster:HasTalent("special_bonus_imba_omniknight_6") then
	-- 	-- Talent values
	-- 	local radius = caster:FindTalentValue("special_bonus_imba_omniknight_6", "radius")
	-- 	local talent_duration = caster:FindTalentValue("special_bonus_imba_omniknight_6", "duration")

	-- 	-- Find all nearby allies
	-- 	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
	-- 									 target:GetAbsOrigin(),
	-- 									 nil,
	-- 									 radius,
	-- 									 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	-- 									 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	-- 									 DOTA_UNIT_TARGET_FLAG_NONE,
	-- 									 FIND_ANY_ORDER,
	-- 									 false)

	-- 	-- Repel all allies except the target
	-- 	for _, ally in pairs(allies) do
	-- 		if ally ~= target then
	-- 			--Repel(caster, ability, ally, talent_duration)
	-- 			-- Lets make it just last for whole duration cause no one gets this thing otherwise
	-- 			Repel(caster, ability, ally, duration)
	-- 		end
	-- 	end
	-- end
end

function Middle_repel:Repel(caster, ability, target, duration)
	-- Ability properties
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local modifier_repel = "modifier_Middle_repel"


	-- Add particle effect
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())

	-- Apply a strong dispel on target
	target:Purge(false, true, false, true, true)

	-- Give target Repel buff and Degen Aura buffs
	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, ability, modifier_repel, {duration = duration*gain})

end


-- Repel modifier
modifier_Middle_repel = advanced_modifier({})

function modifier_Middle_repel:IsHidden() return false end
function modifier_Middle_repel:IsPurgable() return true end
function modifier_Middle_repel:IsDebuff() return false end

function modifier_Middle_repel:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_res = self.ability:GetSpecialValueFor("bonus_res")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_regen")

	

end



function modifier_Middle_repel:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件

	}
end




function modifier_Middle_repel:OnTakeDamage(keys)
	if IsServer() then   
		-- local attacker = keys.attacker

		local unit = keys.unit

		-- if not keys.inflictor then return end
		if unit~=self:GetParent() then	return end

		if keys.damage<=100 then return	end
		if not unit:IsAlive() then
			return
		end
		if not unit:IsRealHero() then
			return
		end

	
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


		local heal = math.min(unit:GetStrength(),keys.damage*0.5)
		local ability = self:GetAbility()
		Timers:CreateTimer(0.2, function()
			if not ability or ability:IsNull() then
				return
			end
			HealWithGain(heal,unit,unit,ability,nil,0,0)
		end)
 
    end 
end



function modifier_Middle_repel:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Middle_repel:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end

function modifier_Middle_repel:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
end

function modifier_Middle_repel:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_Middle_repel:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_StatusResistance

    }
end




function modifier_Middle_repel:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_res
end

