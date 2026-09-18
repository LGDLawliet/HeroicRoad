LinkLuaModifier("modifier_item_chaotic_shadow_amulet", "items/item_chaotic_shadow_amulet.lua", LUA_MODIFIER_MOTION_NONE)

item_chaotic_shadow_amulet = class({})

function item_chaotic_shadow_amulet:GetIntrinsicModifierName()
    return "modifier_item_chaotic_shadow_amulet"
end

modifier_item_chaotic_shadow_amulet = advanced_modifier({})

function modifier_item_chaotic_shadow_amulet:IsHidden()
    return true
end

function modifier_item_chaotic_shadow_amulet:IsPurgable()
    return false
end

function modifier_item_chaotic_shadow_amulet:OnCreated()
    self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_atb")
    self.outgoing_mult = self:GetAbility():GetSpecialValueFor("outgoing_mult")
end

function modifier_item_chaotic_shadow_amulet:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end

function modifier_item_chaotic_shadow_amulet:Advanced_GetModifierBonusStats_Strength()
    return self.bonus_all_stats
end

function modifier_item_chaotic_shadow_amulet:Advanced_GetModifierBonusStats_Agility()
    return self.bonus_all_stats
end

function modifier_item_chaotic_shadow_amulet:Advanced_GetModifierBonusStats_Intellect()
    return self.bonus_all_stats
end

function modifier_item_chaotic_shadow_amulet:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self.outgoing_mult
end
