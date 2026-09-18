LinkLuaModifier("modifier_item_chaotic_Kaya", "items/item_chaotic_Kaya", LUA_MODIFIER_MOTION_NONE)
item_chaotic_Kaya = class({})

function item_chaotic_Kaya:GetIntrinsicModifierName()
    return "modifier_item_chaotic_Kaya"
end

---------------------------------------------------------------------
modifier_item_chaotic_Kaya = advanced_modifier({})

function modifier_item_chaotic_Kaya:IsHidden()return true end
function modifier_item_chaotic_Kaya:IsPurgable()return false end

function modifier_item_chaotic_Kaya:OnCreated()
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.bonus_lostmana_regen = self:GetAbility():GetSpecialValueFor("bonus_lostmana_regen")*0.01
    self:StartIntervalThink(1)
end

function modifier_item_chaotic_Kaya:OnIntervalThink()
    self.regen = self.bonus_lostmana_regen*(self:GetParent():GetMaxMana()-self:GetParent():GetMana())
end

function modifier_item_chaotic_Kaya:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_item_chaotic_Kaya:Advanced_GetModifierBonusStats_Intellect()
    return self.bonus_int
end
function modifier_item_chaotic_Kaya:AdvancedGetModifierConstantManaRegen()
    return  self.regen
end


