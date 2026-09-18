chaotic_era_buffskill_15 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_15", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_15", LUA_MODIFIER_MOTION_NONE)

function chaotic_era_buffskill_15:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_15"
end

modifier_chaotic_era_buffskill_15 = advanced_modifier({})

function modifier_chaotic_era_buffskill_15:IsDebuff() return false end
function modifier_chaotic_era_buffskill_15:IsHidden() return false end
function modifier_chaotic_era_buffskill_15:IsPurgable() return false end

function modifier_chaotic_era_buffskill_15:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.status = self.ability:GetSpecialValueFor("status")
end

function modifier_chaotic_era_buffskill_15:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_StatusResistance
	}
	return funcs
end

function modifier_chaotic_era_buffskill_15:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    local incoming = self.incoming

    if self.parent:PassivesDisabled() then
        incoming = incoming + 20
    end

    if IsPoisonDamage(keys) then
        return incoming
    end
end

function modifier_chaotic_era_buffskill_15:Advanced_GetModifier_StatusResistance(keys)
    return self.status
end
