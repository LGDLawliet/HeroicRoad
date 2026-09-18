item_chaotic_possessed_mask = class({})

LinkLuaModifier("modifier_item_chaotic_possessed_mask", "items/item_chaotic_possessed_mask", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_possessed_mask:GetIntrinsicModifierName()
	return "modifier_item_chaotic_possessed_mask"
end



modifier_item_chaotic_possessed_mask = advanced_modifier({})

function modifier_item_chaotic_possessed_mask:IsDebuff() return false end
function modifier_item_chaotic_possessed_mask:IsHidden() return true end
function modifier_item_chaotic_possessed_mask:IsPurgable() return false end


function modifier_item_chaotic_possessed_mask:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")
end



function modifier_item_chaotic_possessed_mask:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
	}
end


function modifier_item_chaotic_possessed_mask:Advanced_GetModifier_LifeSteal_AttackDamage()return self.bonus_life_steal end
