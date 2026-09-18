chaotic_era_buffskill_14 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_14", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_14", LUA_MODIFIER_MOTION_NONE)

function chaotic_era_buffskill_14:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_14"
end

modifier_chaotic_era_buffskill_14 = advanced_modifier({})

function modifier_chaotic_era_buffskill_14:IsDebuff() return false end
function modifier_chaotic_era_buffskill_14:IsHidden() return false end
function modifier_chaotic_era_buffskill_14:IsPurgable() return false end

function modifier_chaotic_era_buffskill_14:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.incoming_2 = self.ability:GetSpecialValueFor("incoming_2")
end

function modifier_chaotic_era_buffskill_14:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_chaotic_era_buffskill_14:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    if IsElementDamage(keys) and not self.parent:PassivesDisabled() then
        return -self.incoming
    else
        if not IsElementDamage(keys) then
            return self.incoming_2
        end 
    end
end
