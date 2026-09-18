LinkLuaModifier("modifier_item_chaotic_blade_of_alacrity", "items/item_chaotic_blade_of_alacrity.lua", LUA_MODIFIER_MOTION_NONE)

item_chaotic_blade_of_alacrity = class({})

function item_chaotic_blade_of_alacrity:GetIntrinsicModifierName()
    return "modifier_item_chaotic_blade_of_alacrity"
end

modifier_item_chaotic_blade_of_alacrity = advanced_modifier({})

function modifier_item_chaotic_blade_of_alacrity:IsHidden()return true end
function modifier_item_chaotic_blade_of_alacrity:IsPurgable()return false end

function modifier_item_chaotic_blade_of_alacrity:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_item_chaotic_blade_of_alacrity:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_item_chaotic_blade_of_alacrity:Advanced_GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_attack")
end
function modifier_item_chaotic_blade_of_alacrity:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
