item_hd_blade_of_alacrity = class({})

LinkLuaModifier("modifier_item_hd_blade_of_alacrity", "items/item_hd_blade_of_alacrity", LUA_MODIFIER_MOTION_NONE)

function item_hd_blade_of_alacrity:GetIntrinsicModifierName()
	return "modifier_item_hd_blade_of_alacrity"
end
-------------

modifier_item_hd_blade_of_alacrity = advanced_modifier({})

function modifier_item_hd_blade_of_alacrity:IsDebuff() return false end
function modifier_item_hd_blade_of_alacrity:IsHidden() return true end
function modifier_item_hd_blade_of_alacrity:IsPurgable() return false end

function modifier_item_hd_blade_of_alacrity:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_attack_speed= self.ability:GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_hd_blade_of_alacrity:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

	}
end
function modifier_item_hd_blade_of_alacrity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       
	}
end
function modifier_item_hd_blade_of_alacrity:Advanced_GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_blade_of_alacrity:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

