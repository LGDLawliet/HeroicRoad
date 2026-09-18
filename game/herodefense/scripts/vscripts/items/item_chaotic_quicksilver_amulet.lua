LinkLuaModifier("modifier_item_chaotic_quicksilver_amulet", "items/item_chaotic_quicksilver_amulet.lua", LUA_MODIFIER_MOTION_NONE)

item_chaotic_quicksilver_amulet = class({})

function item_chaotic_quicksilver_amulet:GetIntrinsicModifierName()
    return "modifier_item_chaotic_quicksilver_amulet"
end

modifier_item_chaotic_quicksilver_amulet = advanced_modifier({})

function modifier_item_chaotic_quicksilver_amulet:IsHidden()
    return true
end

function modifier_item_chaotic_quicksilver_amulet:IsPurgable()
    return false
end

function modifier_item_chaotic_quicksilver_amulet:OnCreated()
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

function modifier_item_chaotic_quicksilver_amulet:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
    }
end

function modifier_item_chaotic_quicksilver_amulet:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end

function modifier_item_chaotic_quicksilver_amulet:GetModifierEvasion_Constant()
    return self.bonus_evasion
end
