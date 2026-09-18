LinkLuaModifier("modifier_item_chaotic_precious_egg", "items/item_chaotic_precious_egg", LUA_MODIFIER_MOTION_NONE)
item_chaotic_precious_egg = class({})

function item_chaotic_precious_egg:GetIntrinsicModifierName()
    return "modifier_item_chaotic_precious_egg"
end

---------------------------------------------------------------------
modifier_item_chaotic_precious_egg = advanced_modifier({})

function modifier_item_chaotic_precious_egg:IsHidden()return true end
function modifier_item_chaotic_precious_egg:IsPurgable()return false end

function modifier_item_chaotic_precious_egg:OnCreated()
    self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
    self.outgoing_add = self:GetAbility():GetSpecialValueFor("outgoing_add")
    self.bonus_losthp_regen = self:GetAbility():GetSpecialValueFor("bonus_losthp_regen")*0.01
    self:StartIntervalThink(1)
end

function modifier_item_chaotic_precious_egg:OnIntervalThink()
    self.regen = self.bonus_losthp_regen*(self:GetParent():GetMaxHealth()-self:GetParent():GetHealth())
end

function modifier_item_chaotic_precious_egg:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end

function modifier_item_chaotic_precious_egg:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.incoming
end
function modifier_item_chaotic_precious_egg:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return  self.outgoing_add
end
function modifier_item_chaotic_precious_egg:AdvancedGetModifierConstantHealthRegen()
    return  self.regen
end