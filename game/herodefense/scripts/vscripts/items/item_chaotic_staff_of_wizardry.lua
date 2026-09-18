LinkLuaModifier("modifier_item_chaotic_staff_of_wizardry", "items/item_chaotic_staff_of_wizardry", LUA_MODIFIER_MOTION_NONE)
item_chaotic_staff_of_wizardry = class({})

function item_chaotic_staff_of_wizardry:GetIntrinsicModifierName()
    return "modifier_item_chaotic_staff_of_wizardry"
end


modifier_item_chaotic_staff_of_wizardry = advanced_modifier({})

function modifier_item_chaotic_staff_of_wizardry:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE
    }
end

function modifier_item_chaotic_staff_of_wizardry:IsHidden()
    return true
end
function modifier_item_chaotic_staff_of_wizardry:IsPurgable()
    return false
end

function modifier_item_chaotic_staff_of_wizardry:AdvancedGetModifierManaBonus()
    return self.bonus_mana
end
function modifier_item_chaotic_staff_of_wizardry:AdvancedGetModifierConstantManaRegen()
    return  self.bonus_mana_regen
end
function modifier_item_chaotic_staff_of_wizardry:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end
function modifier_item_chaotic_staff_of_wizardry:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end


function modifier_item_chaotic_staff_of_wizardry:OnCreated()
    self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
    self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
end
