chaotic_era_buffskill_18 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_18", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_18", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_18:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_18"
end
-----------------------------------------------------------
modifier_chaotic_era_buffskill_18 = advanced_modifier({})

function modifier_chaotic_era_buffskill_18:IsHidden() return true end
function modifier_chaotic_era_buffskill_18:IsPurgable() return false end
function modifier_chaotic_era_buffskill_18:IsPurgeException() return false end
function modifier_chaotic_era_buffskill_18:IsDebuff() return false end
function modifier_chaotic_era_buffskill_18:OnCreated()
    self.parent = self:GetParent()
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_chaotic_era_buffskill_18:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_chaotic_era_buffskill_18:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    local attacker = keys.attacker

    if CalculateDistance(self.parent, attacker) > self.radius then
        if self.parent:PassivesDisabled() then
            return -40
        end
        return -200
    end
end