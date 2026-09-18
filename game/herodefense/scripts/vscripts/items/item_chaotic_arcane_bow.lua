LinkLuaModifier("modifier_item_chaotic_arcane_bow", "items/item_chaotic_arcane_bow", LUA_MODIFIER_MOTION_NONE)
item_chaotic_arcane_bow = class({})

function item_chaotic_arcane_bow:GetIntrinsicModifierName()
    return "modifier_item_chaotic_arcane_bow"
end

---------------------------------------------------------------------
modifier_item_chaotic_arcane_bow = advanced_modifier({})

function modifier_item_chaotic_arcane_bow:IsHidden()return true end
function modifier_item_chaotic_arcane_bow:IsPurgable()return false end

function modifier_item_chaotic_arcane_bow:OnCreated()
    self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_item_chaotic_arcane_bow:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
end

function modifier_item_chaotic_arcane_bow:Advanced_GetModifierPreAttack_BonusDamage()
    return self.bonus_attack
end
function modifier_item_chaotic_arcane_bow:Advanced_GetModifierAttackRangeBonus()
    if self:GetParent():IsRangedAttacker() then
        return self.bonus_attack_range
    end
    return 0
end


