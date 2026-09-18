LinkLuaModifier("modifier_item_chaotic_sange", "items/item_chaotic_sange", LUA_MODIFIER_MOTION_NONE)
item_chaotic_sange = class({})

function item_chaotic_sange:GetIntrinsicModifierName()
    return "modifier_item_chaotic_sange"
end

---------------------------------------------------------------------
modifier_item_chaotic_sange = advanced_modifier({})

function modifier_item_chaotic_sange:IsHidden()return true end
function modifier_item_chaotic_sange:IsPurgable()return false end

function modifier_item_chaotic_sange:OnCreated()
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_hp_regen = self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

function modifier_item_chaotic_sange:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function modifier_item_chaotic_sange:Advanced_GetModifierBonusStats_Strength()
    return self.bonus_str
end
function modifier_item_chaotic_sange:AdvancedGetModifierConstantHealthRegenPercentage()
    return  self.bonus_hp_regen
end

