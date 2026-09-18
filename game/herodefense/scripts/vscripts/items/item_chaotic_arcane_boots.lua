LinkLuaModifier("modifier_item_chaotic_arcane_boots", "items/item_chaotic_arcane_boots", LUA_MODIFIER_MOTION_NONE)
item_chaotic_arcane_boots = class({})

function item_chaotic_arcane_boots:GetIntrinsicModifierName()
    return "modifier_item_chaotic_arcane_boots"
end

---------------------------------------------------------------------
modifier_item_chaotic_arcane_boots = advanced_modifier({})

function modifier_item_chaotic_arcane_boots:IsHidden()return true end
function modifier_item_chaotic_arcane_boots:IsPurgable()return false end

function modifier_item_chaotic_arcane_boots:OnCreated()
    self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
    self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
end

function modifier_item_chaotic_arcane_boots:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_item_chaotic_arcane_boots:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_item_chaotic_arcane_boots:GetModifierMoveSpeedBonus_Constant()
    return self.bonus_move
end
function modifier_item_chaotic_arcane_boots:AdvancedGetModifierConstantManaRegen()
    return self.bonus_mana_regen
end
function modifier_item_chaotic_arcane_boots:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end
function modifier_item_chaotic_arcane_boots:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end



