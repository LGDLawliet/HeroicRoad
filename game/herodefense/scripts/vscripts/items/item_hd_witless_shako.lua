item_hd_witless_shako = class({})
-- LinkLuaModifier("modifier_item_hd_witless_shako_arua", "items/item_hd_witless_shako", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_witless_shako_arua_effect", "items/item_hd_witless_shako", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_witless_shako", "items/item_hd_witless_shako", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_witless_shako:GetIntrinsicModifierName()
	return "modifier_item_hd_witless_shako"
end






modifier_item_hd_witless_shako = advanced_modifier({})

function modifier_item_hd_witless_shako:IsDebuff() return false end
function modifier_item_hd_witless_shako:IsHidden() return true end
function modifier_item_hd_witless_shako:IsPurgable() return false end



function modifier_item_hd_witless_shako:OnCreated(keys)
    self.ability = self:GetAbility()

 


	self.bonus_health_per = self.ability:GetSpecialValueFor("bonus_health_per")
	self.bonus_mana_per = -self.ability:GetSpecialValueFor("bonus_mana_per")
	
end


function modifier_item_hd_witless_shako:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,

	}
end


function modifier_item_hd_witless_shako:AdvancedGetModifierExtraHealthPercentage()	return self.bonus_health_per end
function modifier_item_hd_witless_shako:GetModifierExtraManaPercentage()	return self.bonus_mana_per end



function modifier_item_hd_witless_shako:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end
