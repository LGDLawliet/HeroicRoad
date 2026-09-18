item_hd_trident = class({})
-- LinkLuaModifier("modifier_item_hd_trident_arua", "items/item_hd_trident", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_trident_arua_effect", "items/item_hd_trident", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trident", "items/item_hd_trident", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_trident:GetIntrinsicModifierName()
	return "modifier_item_hd_trident"
end





modifier_item_hd_trident = advanced_modifier({})

function modifier_item_hd_trident:IsDebuff() return false end
function modifier_item_hd_trident:IsHidden() return true end
function modifier_item_hd_trident:IsPurgable() return false end


function modifier_item_hd_trident:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_status_resistance")
	self.bonus_StatusNegativeGain = self.ability:GetSpecialValueFor("bonus_StatusNegativeGain")
	self.bonus_StatusGain = self.ability:GetSpecialValueFor("bonus_StatusGain")
end



function modifier_item_hd_trident:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	

	}
end


function modifier_item_hd_trident:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_trident:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_trident:GetModifierBonusStats_Agility()	return self.bonus_agi end


-- advanced_modifier
function modifier_item_hd_trident:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain,
		advanced_MODIFIER_PROPERTY_StatusResistance,
    }
end
function modifier_item_hd_trident:Advanced_GetModifier_DurationGain(keys)
	return self.bonus_StatusGain
end

function modifier_item_hd_trident:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.bonus_StatusNegativeGain
end

function modifier_item_hd_trident:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

