chaotic_era_buffskill_16 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_16", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_16", LUA_MODIFIER_MOTION_NONE)

function chaotic_era_buffskill_16:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_16"
end

modifier_chaotic_era_buffskill_16 = advanced_modifier({})

function modifier_chaotic_era_buffskill_16:IsDebuff() return false end
function modifier_chaotic_era_buffskill_16:IsHidden() return false end
function modifier_chaotic_era_buffskill_16:IsPurgable() return false end

function modifier_chaotic_era_buffskill_16:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.cd = self.ability:GetSpecialValueFor("cd")
end

function modifier_chaotic_era_buffskill_16:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_16:Advanced_GetModifierCooldownReduction(keys)
    return self.cd
end
