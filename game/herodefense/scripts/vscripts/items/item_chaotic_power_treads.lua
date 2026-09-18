LinkLuaModifier("modifier_item_chaotic_power_treads", "items/item_chaotic_power_treads.lua", LUA_MODIFIER_MOTION_NONE)

item_chaotic_power_treads = class({})

function item_chaotic_power_treads:GetIntrinsicModifierName()
    return "modifier_item_chaotic_power_treads"
end

modifier_item_chaotic_power_treads = advanced_modifier({})

function modifier_item_chaotic_power_treads:IsHidden()
    return true
end

function modifier_item_chaotic_power_treads:IsPurgable()
    return false
end

function modifier_item_chaotic_power_treads:OnCreated()
    self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_atb")
    self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
end

function modifier_item_chaotic_power_treads:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_item_chaotic_power_treads:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_item_chaotic_power_treads:Advanced_GetModifierBonusStats_Strength()
    return self.bonus_all_stats
end

function modifier_item_chaotic_power_treads:Advanced_GetModifierBonusStats_Agility()
    return self.bonus_all_stats
end

function modifier_item_chaotic_power_treads:Advanced_GetModifierBonusStats_Intellect()
    return self.bonus_all_stats
end

function modifier_item_chaotic_power_treads:GetModifierMoveSpeedBonus_Constant()
    return self.bonus_move
end
