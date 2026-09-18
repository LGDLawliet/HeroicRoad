item_chaotic_belt = class({})

LinkLuaModifier("modifier_item_chaotic_belt", "items/item_chaotic_belt", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_belt:GetIntrinsicModifierName()
	return "modifier_item_chaotic_belt"
end



modifier_item_chaotic_belt = advanced_modifier({})

function modifier_item_chaotic_belt:IsDebuff() return false end
function modifier_item_chaotic_belt:IsHidden() return true end
function modifier_item_chaotic_belt:IsPurgable() return false end


function modifier_item_chaotic_belt:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_hp = self.ability:GetSpecialValueFor("bonus_hp")
end



function modifier_item_chaotic_belt:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end


function modifier_item_chaotic_belt:AdvancedGetModifierHealthBonus()return self.bonus_hp end
