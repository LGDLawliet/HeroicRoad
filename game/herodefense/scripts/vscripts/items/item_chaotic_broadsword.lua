item_chaotic_broadsword = class({})

LinkLuaModifier("modifier_item_chaotic_broadsword", "items/item_chaotic_broadsword", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_broadsword:GetIntrinsicModifierName()
	return "modifier_item_chaotic_broadsword"
end



modifier_item_chaotic_broadsword = advanced_modifier({})

function modifier_item_chaotic_broadsword:IsDebuff() return false end
function modifier_item_chaotic_broadsword:IsHidden() return true end
function modifier_item_chaotic_broadsword:IsPurgable() return false end


function modifier_item_chaotic_broadsword:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
end



function modifier_item_chaotic_broadsword:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end


function modifier_item_chaotic_broadsword:Advanced_GetModifierPreAttack_BonusDamage()return self.bonus_attack end
