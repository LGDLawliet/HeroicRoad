item_hd_broom_handle = class({})
LinkLuaModifier("modifier_item_hd_broom_handle", "items/item_hd_broom_handle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_broom_handle_active", "items/item_hd_broom_handle", LUA_MODIFIER_MOTION_NONE)


function item_hd_broom_handle:GetIntrinsicModifierName()
	return "modifier_item_hd_broom_handle"
end


modifier_item_hd_broom_handle = advanced_modifier({})

function modifier_item_hd_broom_handle:IsDebuff() return false end
function modifier_item_hd_broom_handle:IsHidden() return true end
function modifier_item_hd_broom_handle:IsPurgable() return false end


function modifier_item_hd_broom_handle:OnCreated(keys)
	self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	self:StartIntervalThink(1)
end

function modifier_item_hd_broom_handle:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_Great_Cleave") or self:GetCaster():FindAbilityByName("Middle_Great_Cleave") or self:GetCaster():FindAbilityByName("Advanced_Great_Cleave") then
		self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage") + self.ability:GetSpecialValueFor("bonus_damage_extra")
		self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor") + self.ability:GetSpecialValueFor("bonus_armor_extra")
	else
		self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
		self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	end
end

function modifier_item_hd_broom_handle:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,           --护甲
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,             --攻击距离
	}
end

function modifier_item_hd_broom_handle:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_broom_handle:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and 0 or self.bonus_attack_range end
function modifier_item_hd_broom_handle:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor end






