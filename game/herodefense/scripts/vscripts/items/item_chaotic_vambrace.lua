LinkLuaModifier("modifier_item_chaotic_vambrace", "items/item_chaotic_vambrace.lua", LUA_MODIFIER_MOTION_NONE)

item_chaotic_vambrace = class({})

function item_chaotic_vambrace:GetIntrinsicModifierName()
    return "modifier_item_chaotic_vambrace"
end

modifier_item_chaotic_vambrace = advanced_modifier({})

function modifier_item_chaotic_vambrace:IsHidden()
    return true
end

function modifier_item_chaotic_vambrace:IsPurgable()
    return false
end

function modifier_item_chaotic_vambrace:OnCreated()
    self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_atb")
    self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing_add")
end

function modifier_item_chaotic_vambrace:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_item_chaotic_vambrace:Advanced_GetModifierBonusStats_Strength()
    return self.bonus_all_stats
end

function modifier_item_chaotic_vambrace:Advanced_GetModifierBonusStats_Agility()
    return self.bonus_all_stats
end

function modifier_item_chaotic_vambrace:Advanced_GetModifierBonusStats_Intellect()
    return self.bonus_all_stats
end

function modifier_item_chaotic_vambrace:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self.outgoing
end
