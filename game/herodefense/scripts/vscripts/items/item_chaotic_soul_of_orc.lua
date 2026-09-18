LinkLuaModifier("modifier_item_chaotic_soul_of_orc", "items/item_chaotic_soul_of_orc", LUA_MODIFIER_MOTION_NONE)
item_chaotic_soul_of_orc = class({})

function item_chaotic_soul_of_orc:GetIntrinsicModifierName()
    return "modifier_item_chaotic_soul_of_orc"
end

---------------------------------------------------------------------
modifier_item_chaotic_soul_of_orc = advanced_modifier({})

function modifier_item_chaotic_soul_of_orc:IsHidden()return true end
function modifier_item_chaotic_soul_of_orc:IsPurgable()return false end

function modifier_item_chaotic_soul_of_orc:OnCreated()
    self.outgoing_add = self:GetAbility():GetSpecialValueFor("outgoing_add")
    self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
end

function modifier_item_chaotic_soul_of_orc:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_item_chaotic_soul_of_orc:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return  self.outgoing_add
end
function modifier_item_chaotic_soul_of_orc:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end
function modifier_item_chaotic_soul_of_orc:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end



