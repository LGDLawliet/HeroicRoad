Primary_Bad_Juju = class({})

LinkLuaModifier("modifier_Primary_Bad_Juju_passive", "skills/Primary_Bad_Juju", LUA_MODIFIER_MOTION_NONE)


function Primary_Bad_Juju:GetIntrinsicModifierName() return "modifier_Primary_Bad_Juju_passive" end

modifier_Primary_Bad_Juju_passive = advanced_modifier({})

function modifier_Primary_Bad_Juju_passive:IsDebuff()			return false end
function modifier_Primary_Bad_Juju_passive:IsHidden() 			return true end
function modifier_Primary_Bad_Juju_passive:IsPurgable() 		return false end
function modifier_Primary_Bad_Juju_passive:IsPurgeException() 	return false end
function modifier_Primary_Bad_Juju_passive:AllowIllusionDuplicate() return false end
-- function modifier_Primary_Bad_Juju_passive:DeclareFunctions() return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
-- function modifier_Primary_Bad_Juju_passive:GetModifierPercentageCooldown() return (self:GetAbility():GetSpecialValueFor("cooldown_reduction")) end
--减少冷却

function modifier_Primary_Bad_Juju_passive:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_Primary_Bad_Juju_passive:Advanced_GetModifierCooldownReduction(keys)
    return self:GetAbility():GetSpecialValueFor("cooldown_reduction")
end


