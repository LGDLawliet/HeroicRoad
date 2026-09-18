LinkLuaModifier("modifier_item_chaotic_arcane_hat", "items/item_chaotic_arcane_hat", LUA_MODIFIER_MOTION_NONE)
item_chaotic_arcane_hat = class({})

function item_chaotic_arcane_hat:GetIntrinsicModifierName()
    return "modifier_item_chaotic_arcane_hat"
end

---------------------------------------------------------------------
modifier_item_chaotic_arcane_hat = advanced_modifier({})

function modifier_item_chaotic_arcane_hat:IsHidden()return true end
function modifier_item_chaotic_arcane_hat:IsPurgable()return false end

function modifier_item_chaotic_arcane_hat:OnCreated()
    self.outgoing_add = self:GetAbility():GetSpecialValueFor("outgoing_add")
    self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
end

function modifier_item_chaotic_arcane_hat:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_item_chaotic_arcane_hat:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return  self.outgoing_add
end
function modifier_item_chaotic_arcane_hat:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end
function modifier_item_chaotic_arcane_hat:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end
