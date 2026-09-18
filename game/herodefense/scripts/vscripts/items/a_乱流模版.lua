LinkLuaModifier("modifier_itemAAA", "items/itemAAA", LUA_MODIFIER_MOTION_NONE)
itemAAA = class({})

function itemAAA:GetIntrinsicModifierName()
    return "modifier_itemAAA"
end

---------------------------------------------------------------------
modifier_itemAAA = advanced_modifier({})

function modifier_itemAAA:IsHidden()return true end
function modifier_itemAAA:IsPurgable()return false end

function modifier_itemAAA:OnCreated()
    self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
    self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
end

function modifier_itemAAA:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_itemAAA:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE
    }
end

function modifier_itemAAA:AdvancedGetModifierManaBonus()
    return self.bonus_mana
end
function modifier_itemAAA:AdvancedGetModifierConstantManaRegen()
    return  self.bonus_mana_regen
end
function modifier_itemAAA:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end
function modifier_itemAAA:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end



