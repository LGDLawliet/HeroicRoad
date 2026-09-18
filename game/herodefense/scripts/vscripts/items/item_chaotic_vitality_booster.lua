LinkLuaModifier("modifier_item_chaotic_vitality_booster", "items/item_chaotic_vitality_booster", LUA_MODIFIER_MOTION_NONE)
item_chaotic_vitality_booster = class({})

function item_chaotic_vitality_booster:GetIntrinsicModifierName()
    return "modifier_item_chaotic_vitality_booster"
end

---------------------------------------------------------------------
modifier_item_chaotic_vitality_booster = advanced_modifier({})

function modifier_item_chaotic_vitality_booster:IsHidden()return true end
function modifier_item_chaotic_vitality_booster:IsPurgable()return false end

function modifier_item_chaotic_vitality_booster:OnCreated()
    self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
    self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
end

function modifier_item_chaotic_vitality_booster:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_item_chaotic_vitality_booster:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_item_chaotic_vitality_booster:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.incoming
end
function modifier_item_chaotic_vitality_booster:AdvancedGetModifierHealthBonus()
    return  self.bonus_hp
end



