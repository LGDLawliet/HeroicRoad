LinkLuaModifier("modifier_item_chaotic_qingnan_sheet", "items/item_chaotic_qingnan_sheet", LUA_MODIFIER_MOTION_NONE)
item_chaotic_qingnan_sheet = class({})

function item_chaotic_qingnan_sheet:GetIntrinsicModifierName()
    return "modifier_item_chaotic_qingnan_sheet"
end

---------------------------------------------------------------------
modifier_item_chaotic_qingnan_sheet = advanced_modifier({})

function modifier_item_chaotic_qingnan_sheet:IsHidden()return true end
function modifier_item_chaotic_qingnan_sheet:IsPurgable()return false end

function modifier_item_chaotic_qingnan_sheet:OnCreated()
    self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
    self.bonus_cd = self:GetAbility():GetSpecialValueFor("bonus_cd")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
end

function modifier_item_chaotic_qingnan_sheet:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
    }
end

function modifier_item_chaotic_qingnan_sheet:AdvancedGetModifierManaBonus()
    return self.bonus_mana
end
function modifier_item_chaotic_qingnan_sheet:Advanced_GetModifierCooldownReduction()
    return self.bonus_cd
end
function modifier_item_chaotic_qingnan_sheet:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end



