LinkLuaModifier("modifier_item_chaotic_javelin", "items/item_chaotic_javelin.lua", LUA_MODIFIER_MOTION_NONE)
item_chaotic_javelin = class({})

function item_chaotic_javelin:GetIntrinsicModifierName()
    return "modifier_item_chaotic_javelin"
end

-------------------
modifier_item_chaotic_javelin = advanced_modifier({})

function modifier_item_chaotic_javelin:OnCreated(table)
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_attack_add = self:GetAbility():GetSpecialValueFor("bonus_attack_add")
end

function modifier_item_chaotic_javelin:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
function modifier_item_chaotic_javelin:IsHidden()
    return true
end

function modifier_item_chaotic_javelin:IsPurgable()
    return false
end

function modifier_item_chaotic_javelin:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end
function modifier_item_chaotic_javelin:GetModifierPreAttack_BonusDamagePostCrit()
    return self.bonus_attack_add
end