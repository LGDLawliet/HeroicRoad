item_hd_star_calling_cloak = class({})

LinkLuaModifier("modifier_item_hd_star_calling_cloak", "items/item_hd_star_calling_cloak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_star_calling_cloak_effect", "items/item_hd_star_calling_cloak", LUA_MODIFIER_MOTION_NONE)

function item_hd_star_calling_cloak:GetIntrinsicModifierName()
	return "modifier_item_hd_star_calling_cloak"
end

modifier_item_hd_star_calling_cloak = advanced_modifier({})

function modifier_item_hd_star_calling_cloak:IsDebuff() return false end
function modifier_item_hd_star_calling_cloak:IsHidden() return true end
function modifier_item_hd_star_calling_cloak:IsPurgable() return false end

function modifier_item_hd_star_calling_cloak:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.cost_down = self.ability:GetSpecialValueFor("cost_down")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.hp_down = self.ability:GetSpecialValueFor("hp_down")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_hd_star_calling_cloak:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, 
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
end
function modifier_item_hd_star_calling_cloak:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,   
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE    
	}
end
function modifier_item_hd_star_calling_cloak:GetModifierPercentageManacost()	return self.cost_down end
function modifier_item_hd_star_calling_cloak:GetModifierExtraManaPercentage()	return self.bonus_mana end
function modifier_item_hd_star_calling_cloak:AdvancedGetModifierExtraHealthPercentage()	return -self.hp_down end

function modifier_item_hd_star_calling_cloak:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAlive() then
		return
	end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_star_calling_cloak_effect", {duration = self.duration})
	self:GetAbility():UseResources(true, true, true, true)
end
------------------------------------------------------------------


modifier_item_hd_star_calling_cloak_effect = advanced_modifier({})

function modifier_item_hd_star_calling_cloak_effect:IsDebuff() return false end
function modifier_item_hd_star_calling_cloak_effect:IsHidden() return true end
function modifier_item_hd_star_calling_cloak_effect:IsPurgable() return false end

function modifier_item_hd_star_calling_cloak_effect:OnCreated(table)
	self.mp_regen = self:GetAbility():GetSpecialValueFor("mp_regen")*self:GetCaster():GetMaxMana()*0.01
end

function modifier_item_hd_star_calling_cloak_effect:OnRefresh(table)
	self.mp_regen = self:GetAbility():GetSpecialValueFor("mp_regen")*self:GetCaster():GetMaxMana()*0.01
end

function modifier_item_hd_star_calling_cloak_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT    
	}
end
function modifier_item_hd_star_calling_cloak_effect:AdvancedGetModifierConstantManaRegen()	return self.mp_regen end