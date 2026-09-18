LinkLuaModifier("modifier_item_chaotic_dragon_scale", "items/item_chaotic_dragon_scale", LUA_MODIFIER_MOTION_NONE)
item_chaotic_dragon_scale = class({})

function item_chaotic_dragon_scale:GetIntrinsicModifierName()
    return "modifier_item_chaotic_dragon_scale"
end

---------------------------------------------------------------------
modifier_item_chaotic_dragon_scale = advanced_modifier({})

function modifier_item_chaotic_dragon_scale:IsHidden()return true end
function modifier_item_chaotic_dragon_scale:IsPurgable()return false end

function modifier_item_chaotic_dragon_scale:OnCreated()
    self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
    self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_chaotic_dragon_scale:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_item_chaotic_dragon_scale:AdvancedGetModifierHealthBonus()
    return self.bonus_hp
end
function modifier_item_chaotic_dragon_scale:Advanced_GetModifierPhysicalArmorBonus()
    return  self.bonus_armor
end
function modifier_item_chaotic_dragon_scale:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.incoming
end


