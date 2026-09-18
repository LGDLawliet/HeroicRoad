
Primary_repel = class({})
LinkLuaModifier("modifier_Primary_repel", "skills/Primary_repel", LUA_MODIFIER_MOTION_NONE)



function Primary_repel:IsHiddenWhenStolen()	return false end




function Primary_repel:OnSpellStart()
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


end

function Primary_repel:Repel(caster, ability, target, duration)
	-- Ability properties
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local modifier_repel = "modifier_Primary_repel"


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
modifier_Primary_repel = advanced_modifier({})

function modifier_Primary_repel:IsHidden() return false end
function modifier_Primary_repel:IsPurgable() return true end
function modifier_Primary_repel:IsDebuff() return false end

function modifier_Primary_repel:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_res")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_regen")


end



function modifier_Primary_repel:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量


	}
end


function modifier_Primary_repel:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Primary_repel:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end

function modifier_Primary_repel:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
end

function modifier_Primary_repel:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Primary_repel:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_StatusResistance,

    }
end


function modifier_Primary_repel:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

