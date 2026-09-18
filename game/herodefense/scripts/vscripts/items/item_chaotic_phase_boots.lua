LinkLuaModifier("modifier_item_chaotic_phase_boots", "items/item_chaotic_phase_boots", LUA_MODIFIER_MOTION_NONE)
item_chaotic_phase_boots = class({})


function item_chaotic_phase_boots:GetIntrinsicModifierName()
    return "modifier_item_chaotic_phase_boots"
end

modifier_item_chaotic_phase_boots = advanced_modifier({})


function modifier_item_chaotic_phase_boots:IsHidden()
    return true
end
function modifier_item_chaotic_phase_boots:IsPurgable()
    return false
end

function modifier_item_chaotic_phase_boots:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end
function modifier_item_chaotic_phase_boots:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_chaotic_phase_boots:Advanced_GetModifierPreAttack_BonusDamage()
    return self.bonus_attack
end
function modifier_item_chaotic_phase_boots:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_chaotic_phase_boots:GetModifierMoveSpeedBonus_Constant()
    return self.bonus_move
end

function modifier_item_chaotic_phase_boots:OnCreated()
    self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
end