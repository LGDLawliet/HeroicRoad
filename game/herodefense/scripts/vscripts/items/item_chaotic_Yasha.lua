LinkLuaModifier("modifier_item_chaotic_Yasha", "items/item_chaotic_Yasha.lua", LUA_MODIFIER_MOTION_NONE)

item_chaotic_Yasha = class({})

function item_chaotic_Yasha:GetIntrinsicModifierName()
    return "modifier_item_chaotic_Yasha"
end

modifier_item_chaotic_Yasha = advanced_modifier({})

function modifier_item_chaotic_Yasha:IsHidden()
    return true
end
function modifier_item_chaotic_Yasha:IsPurgable()
    return false
end

function modifier_item_chaotic_Yasha:OnCreated()
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_chaotic_Yasha:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
function modifier_item_chaotic_Yasha:ADDeclareFunctions()
    return {

        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end
function modifier_item_chaotic_Yasha:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end

function modifier_item_chaotic_Yasha:Advanced_GetModifierBonusStats_Agility()
    return self.bonus_agi
end
