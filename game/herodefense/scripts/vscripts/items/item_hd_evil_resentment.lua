item_hd_evil_resentment = class({})

LinkLuaModifier("modifier_item_hd_evil_resentment", "items/item_hd_evil_resentment", LUA_MODIFIER_MOTION_NONE)

function item_hd_evil_resentment:GetIntrinsicModifierName()
	return "modifier_item_hd_evil_resentment"
end


modifier_item_hd_evil_resentment = advanced_modifier({})

function modifier_item_hd_evil_resentment:IsDebuff() return false end
function modifier_item_hd_evil_resentment:IsHidden() return true end
function modifier_item_hd_evil_resentment:IsPurgable() return false end

function modifier_item_hd_evil_resentment:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_incomingdamage_per = self.ability:GetSpecialValueFor("bonus_incomingdamage_per")
	self:StartIntervalThink(1)
end

function modifier_item_hd_evil_resentment:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_feast") or self:GetCaster():FindAbilityByName("Middle_feast") or self:GetCaster():FindAbilityByName("Advanced_feast") then
		self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage") +self.ability:GetSpecialValueFor("bonus_damage_extra")
	else
		self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_hd_evil_resentment:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_evil_resentment:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return self.bonus_incomingdamage_per 
end

function modifier_item_hd_evil_resentment:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end



