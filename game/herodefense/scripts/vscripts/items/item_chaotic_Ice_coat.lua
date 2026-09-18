LinkLuaModifier("modifier_item_chaotic_Ice_coat", "items/item_chaotic_Ice_coat", LUA_MODIFIER_MOTION_NONE)
item_chaotic_Ice_coat = class({})

function item_chaotic_Ice_coat:GetIntrinsicModifierName()
    return "modifier_item_chaotic_Ice_coat"
end

---------------------------------------------------------------------
modifier_item_chaotic_Ice_coat = advanced_modifier({})

function modifier_item_chaotic_Ice_coat:IsHidden()return true end
function modifier_item_chaotic_Ice_coat:IsPurgable()return false end

function modifier_item_chaotic_Ice_coat:OnCreated()
    self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
    self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
end

function modifier_item_chaotic_Ice_coat:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_item_chaotic_Ice_coat:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_item_chaotic_Ice_coat:AdvancedGetModifierManaBonus()
    return self.bonus_mana
end
function modifier_item_chaotic_Ice_coat:AdvancedGetModifierHealthBonus()
    return  self.bonus_hp
end
function modifier_item_chaotic_Ice_coat:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.incoming
end
function modifier_item_chaotic_Ice_coat:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end



