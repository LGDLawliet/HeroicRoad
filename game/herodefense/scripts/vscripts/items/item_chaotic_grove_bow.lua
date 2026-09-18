LinkLuaModifier("modifier_item_chaotic_grove_bow", "items/item_chaotic_grove_bow.lua", LUA_MODIFIER_MOTION_NONE)
item_chaotic_grove_bow = class({})

function item_chaotic_grove_bow:GetIntrinsicModifierName()
    return "modifier_item_chaotic_grove_bow"
end

-------------------
modifier_item_chaotic_grove_bow = advanced_modifier({})

function modifier_item_chaotic_grove_bow:OnCreated(table)
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_item_chaotic_grove_bow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
function modifier_item_chaotic_grove_bow:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
end
function modifier_item_chaotic_grove_bow:IsHidden()
    return true
end

function modifier_item_chaotic_grove_bow:IsPurgable()
    return false
end

function modifier_item_chaotic_grove_bow:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end
function modifier_item_chaotic_grove_bow:Advanced_GetModifierAttackRangeBonus()
    if self:GetParent():IsRangedAttacker() then
        return self.bonus_attack_range
    end
    return 0
end
