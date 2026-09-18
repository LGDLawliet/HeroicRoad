LinkLuaModifier("modifier_item_chaotic_mekansm", "items/item_chaotic_mekansm", LUA_MODIFIER_MOTION_NONE)
item_chaotic_mekansm = class({})

function item_chaotic_mekansm:GetIntrinsicModifierName()
    return "modifier_item_chaotic_mekansm"
end

---------------------------------------------------------------------
modifier_item_chaotic_mekansm = advanced_modifier({})

function modifier_item_chaotic_mekansm:IsHidden()return true end
function modifier_item_chaotic_mekansm:IsPurgable()return false end

function modifier_item_chaotic_mekansm:OnCreated()
    self.bonus_cd = self:GetAbility():GetSpecialValueFor("bonus_cd")
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
end

function modifier_item_chaotic_mekansm:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION

    }
end

function modifier_item_chaotic_mekansm:Advanced_GetModifierCooldownReduction()
    return self.bonus_cd
end
function modifier_item_chaotic_mekansm:AdvancedGetModifierConstantManaRegen()
    return  self.bonus_mana_regen
end
function modifier_item_chaotic_mekansm:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end



