LinkLuaModifier("modifier_item_chaotic_hood_of_defiance", "items/item_chaotic_hood_of_defiance", LUA_MODIFIER_MOTION_NONE)
item_chaotic_hood_of_defiance = class({})

function item_chaotic_hood_of_defiance:GetIntrinsicModifierName()
    return "modifier_item_chaotic_hood_of_defiance"
end

---------------------------------------------------------------------
modifier_item_chaotic_hood_of_defiance = advanced_modifier({})

function modifier_item_chaotic_hood_of_defiance:IsHidden()return true end
function modifier_item_chaotic_hood_of_defiance:IsPurgable()return false end

function modifier_item_chaotic_hood_of_defiance:OnCreated()
    self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
    self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
    self.bonus_magic_res = self:GetAbility():GetSpecialValueFor("bonus_magic_res")
end

function modifier_item_chaotic_hood_of_defiance:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_item_chaotic_hood_of_defiance:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS
    }
end

function modifier_item_chaotic_hood_of_defiance:GetModifierMagicalResistanceBonus()
    return self.bonus_magic_res
end
function modifier_item_chaotic_hood_of_defiance:Advanced_GetModifierIncomingDamage_Percentage()
    return  -self.incoming
end
function modifier_item_chaotic_hood_of_defiance:AdvancedGetModifierHealthBonus()
    return self.bonus_hp
end


