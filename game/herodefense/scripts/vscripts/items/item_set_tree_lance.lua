item_set_tree_lance = class({})
LinkLuaModifier("modifier_item_set_tree_lance", "items/item_set_tree_lance", LUA_MODIFIER_MOTION_NONE)

function item_set_tree_lance:GetIntrinsicModifierName()
	return "modifier_item_set_tree_lance"
end

modifier_item_set_tree_lance = advanced_modifier({})

function modifier_item_set_tree_lance:IsDebuff() return false end
function modifier_item_set_tree_lance:IsHidden() return true end
function modifier_item_set_tree_lance:IsPurgable() return false end

function modifier_item_set_tree_lance:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_hp = self.ability:GetSpecialValueFor("bonus_hp")
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
    self.day_str = self.ability:GetSpecialValueFor("day_str")
end

function modifier_item_set_tree_lance:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_item_set_tree_lance:Advanced_GetModifierBonusStats_Strength()
    local time = GameRules:GetTimeOfDay()
	if time>=0.25 and time <=0.75 then
        return self.bonus_str + self.day_str
    end
    return self.bonus_str 
end

function modifier_item_set_tree_lance:AdvancedGetModifierHealthBonus()	return self.bonus_hp end





