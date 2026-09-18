item_hd_staff_of_wizardry = class({})

LinkLuaModifier("modifier_item_hd_staff_of_wizardry", "items/item_hd_staff_of_wizardry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_staff_of_wizardry_active", "items/item_hd_staff_of_wizardry", LUA_MODIFIER_MOTION_NONE)



function item_hd_staff_of_wizardry:GetIntrinsicModifierName()
	return "modifier_item_hd_staff_of_wizardry"
end




modifier_item_hd_staff_of_wizardry = advanced_modifier({})

function modifier_item_hd_staff_of_wizardry:IsDebuff() return false end
function modifier_item_hd_staff_of_wizardry:IsHidden() return true end
function modifier_item_hd_staff_of_wizardry:IsPurgable() return false end



function modifier_item_hd_staff_of_wizardry:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.duration = self.ability:GetSpecialValueFor("duration")

end

function modifier_item_hd_staff_of_wizardry:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力

	}
end

function modifier_item_hd_staff_of_wizardry:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_item_hd_staff_of_wizardry:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_int end

function modifier_item_hd_staff_of_wizardry:OnAbilityExecuted(keys)
	if IsServer() and keys.unit == self:GetParent() and keys.ability:GetCooldown(keys.ability:GetLevel()) > 1 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_staff_of_wizardry_active", {duration = self.duration})
	end
end
------

modifier_item_hd_staff_of_wizardry_active = advanced_modifier({})

function modifier_item_hd_staff_of_wizardry_active:IsDebuff() return false end
function modifier_item_hd_staff_of_wizardry_active:IsHidden() return true end
function modifier_item_hd_staff_of_wizardry_active:IsPurgable() return false end
function modifier_item_hd_staff_of_wizardry_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.active = self.ability:GetSpecialValueFor("active")

end
function modifier_item_hd_staff_of_wizardry_active:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.active = self.ability:GetSpecialValueFor("active")

end
function modifier_item_hd_staff_of_wizardry_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,    
		advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE
	}
end
function modifier_item_hd_staff_of_wizardry_active:Advanced_GetModifierSpellAmplifyBonus()	return self.active end
function modifier_item_hd_staff_of_wizardry_active:Advanced_GetModifierHealAMP_Percentage()	return self.active end