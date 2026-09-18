item_hd_oblivion_staff = class({})

LinkLuaModifier("modifier_item_hd_oblivion_staff", "items/item_hd_oblivion_staff", LUA_MODIFIER_MOTION_NONE)

-- require('internal/timers')   --计时器功能
function item_hd_oblivion_staff:GetIntrinsicModifierName()
	return "modifier_item_hd_oblivion_staff"
end



modifier_item_hd_oblivion_staff = advanced_modifier({})

function modifier_item_hd_oblivion_staff:IsDebuff() return false end
function modifier_item_hd_oblivion_staff:IsHidden() return true end
function modifier_item_hd_oblivion_staff:IsPurgable() return false end




function modifier_item_hd_oblivion_staff:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	self.bonus_mana_regen = self.ability:GetSpecialValueFor("bonus_mana_regen")

	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")

end

function modifier_item_hd_oblivion_staff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end
function modifier_item_hd_oblivion_staff:ADDeclareFunctions()
	return {

		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, 

	}
end

function modifier_item_hd_oblivion_staff:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_oblivion_staff:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end
function modifier_item_hd_oblivion_staff:AdvancedGetModifierConstantManaRegen() return self.bonus_mana_regen end
