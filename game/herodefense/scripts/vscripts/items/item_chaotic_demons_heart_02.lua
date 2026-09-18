LinkLuaModifier("modifier_item_chaotic_demons_heart_02", "items/item_chaotic_demons_heart_02", LUA_MODIFIER_MOTION_NONE)
item_chaotic_demons_heart_02 = class({})

function item_chaotic_demons_heart_02:GetIntrinsicModifierName()
    return "modifier_item_chaotic_demons_heart_02"
end

---------------------------------------------------------------------
modifier_item_chaotic_demons_heart_02 = advanced_modifier({})

function modifier_item_chaotic_demons_heart_02:IsHidden()return true end
function modifier_item_chaotic_demons_heart_02:IsPurgable()return false end

function modifier_item_chaotic_demons_heart_02:OnCreated()
    self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
    self.bonus_hp_regen = self:GetAbility():GetSpecialValueFor("bonus_hp_regen")

end

function modifier_item_chaotic_demons_heart_02:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function modifier_item_chaotic_demons_heart_02:AdvancedGetModifierHealthBonus()
    return self.bonus_hp
end
function modifier_item_chaotic_demons_heart_02:AdvancedGetModifierConstantHealthRegenPercentage()
    return  self.bonus_hp_regen
end



