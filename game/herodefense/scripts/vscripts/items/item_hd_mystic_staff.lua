item_hd_mystic_staff = class({})

LinkLuaModifier("modifier_item_hd_mystic_staff", "items/item_hd_mystic_staff", LUA_MODIFIER_MOTION_NONE)

function item_hd_mystic_staff:GetIntrinsicModifierName()
	return "modifier_item_hd_mystic_staff"
end
----------------------------------------
modifier_item_hd_mystic_staff = advanced_modifier({})

function modifier_item_hd_mystic_staff:IsDebuff() return false end
function modifier_item_hd_mystic_staff:IsHidden() return true end
function modifier_item_hd_mystic_staff:IsPurgable() return false end


function modifier_item_hd_mystic_staff:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_cast_range = self.ability:GetSpecialValueFor("bonus_cast_range")
end



function modifier_item_hd_mystic_staff:ADDeclareFunctions()
	return {

		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	}
end


function modifier_item_hd_mystic_staff:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_mystic_staff:Advanced_GetModifierCastRangeBonusStacking()	return self.bonus_cast_range end
