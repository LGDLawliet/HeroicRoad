LinkLuaModifier("modifier_item_chaotic_medallion_of_courage", "items/item_chaotic_medallion_of_courage", LUA_MODIFIER_MOTION_NONE)
item_chaotic_medallion_of_courage = class({})

function item_chaotic_medallion_of_courage:GetIntrinsicModifierName()
    return "modifier_item_chaotic_medallion_of_courage"
end

---------------------------------------------------------------------
modifier_item_chaotic_medallion_of_courage = advanced_modifier({})

function modifier_item_chaotic_medallion_of_courage:IsHidden()return true end
function modifier_item_chaotic_medallion_of_courage:IsPurgable()return false end

function modifier_item_chaotic_medallion_of_courage:OnCreated()
    self.bonus_attack_melee = self:GetAbility():GetSpecialValueFor("bonus_attack_melee")
    self.bonus_armor_melee = self:GetAbility():GetSpecialValueFor("bonus_armor_melee")
end

function modifier_item_chaotic_medallion_of_courage:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_item_chaotic_medallion_of_courage:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetParent():IsRangedAttacker() then
        return self.bonus_armor_melee
    end
    return 0
end
function modifier_item_chaotic_medallion_of_courage:Advanced_GetModifierPreAttack_BonusDamage()
    if not self:GetParent():IsRangedAttacker() then
        return self.bonus_attack_melee
    end
    return 0
end



