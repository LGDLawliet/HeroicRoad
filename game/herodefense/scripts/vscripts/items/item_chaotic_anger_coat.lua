LinkLuaModifier("modifier_item_chaotic_anger_coat", "items/item_chaotic_anger_coat", LUA_MODIFIER_MOTION_NONE)
item_chaotic_anger_coat = class({})

function item_chaotic_anger_coat:GetIntrinsicModifierName()
    return "modifier_item_chaotic_anger_coat"
end

---------------------------------------------------------------------
modifier_item_chaotic_anger_coat = advanced_modifier({})

function modifier_item_chaotic_anger_coat:IsHidden()return true end
function modifier_item_chaotic_anger_coat:IsPurgable()return false end

function modifier_item_chaotic_anger_coat:OnCreated()
    self.bonus_attack_speed_melee = self:GetAbility():GetSpecialValueFor("bonus_attack_speed_melee")
    self.bonus_armor_melee = self:GetAbility():GetSpecialValueFor("bonus_armor_melee")
end
function modifier_item_chaotic_anger_coat:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end
function modifier_item_chaotic_anger_coat:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_chaotic_anger_coat:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetParent():IsRangedAttacker() then
        return self.bonus_armor_melee
    end
    return 0
end
function modifier_item_chaotic_anger_coat:GetModifierAttackSpeedBonus_Constant()
    if not self:GetParent():IsRangedAttacker() then
        return self.bonus_attack_speed_melee
    end
    return 0
end



