item_hd_demons_heart_01 = class({})
-- LinkLuaModifier("modifier_item_hd_demons_heart_01_arua", "items/item_hd_demons_heart_01", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_demons_heart_01_arua_effect", "items/item_hd_demons_heart_01", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_demons_heart_01", "items/item_hd_demons_heart_01", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_demons_heart_01_active", "items/item_hd_demons_heart_01", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_demons_heart_01_active_standby", "items/item_hd_demons_heart_01", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_demons_heart_01_active_debuff", "items/item_hd_demons_heart_01", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_demons_heart_01:GetIntrinsicModifierName()
	return "modifier_item_hd_demons_heart_01"
end





modifier_item_hd_demons_heart_01 = advanced_modifier({})

function modifier_item_hd_demons_heart_01:IsDebuff() return false end
function modifier_item_hd_demons_heart_01:IsHidden() return true end
function modifier_item_hd_demons_heart_01:IsPurgable() return false end

function modifier_item_hd_demons_heart_01:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self:StartIntervalThink(1)
end

function modifier_item_hd_demons_heart_01:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_tether") or self:GetCaster():FindAbilityByName("Middle_tether") or self:GetCaster():FindAbilityByName("Advanced_tether") or self:GetCaster():FindAbilityByName("Primary_tether_break") or self:GetCaster():FindAbilityByName("Middle_tether_break") or self:GetCaster():FindAbilityByName("Advanced_tether_break")	then
		self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification") + self.ability:GetSpecialValueFor("bonus_regeneration_amplification_extra")
	else
		self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	end
end



function modifier_item_hd_demons_heart_01:AdvancedGetModifierConstantHealthRegenAmpPercentage() 	return self.bonus_regeneration_amplification end


function modifier_item_hd_demons_heart_01:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
	}
	return funcs
end
