LinkLuaModifier("modifier_item_chaotic_pheromone", "items/item_chaotic_pheromone", LUA_MODIFIER_MOTION_NONE)
item_chaotic_pheromone = class({})

function item_chaotic_pheromone:GetIntrinsicModifierName()
    return "modifier_item_chaotic_pheromone"
end

---------------------------------------------------------------------
modifier_item_chaotic_pheromone = advanced_modifier({})

function modifier_item_chaotic_pheromone:IsHidden()return true end
function modifier_item_chaotic_pheromone:IsPurgable()return false end

function modifier_item_chaotic_pheromone:OnCreated()
    self.outgoing_add = self:GetAbility():GetSpecialValueFor("outgoing_add")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_chaotic_pheromone:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_item_chaotic_pheromone:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_item_chaotic_pheromone:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end
function modifier_item_chaotic_pheromone:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return  self.outgoing_add
end

