item_hd_eagle = class({})

LinkLuaModifier("modifier_item_hd_eagle", "items/item_hd_eagle", LUA_MODIFIER_MOTION_NONE)


function item_hd_eagle:GetIntrinsicModifierName()
	return "modifier_item_hd_eagle"
end



modifier_item_hd_eagle = advanced_modifier({})

function modifier_item_hd_eagle:IsDebuff() return false end
function modifier_item_hd_eagle:IsHidden() return true end
function modifier_item_hd_eagle:IsPurgable() return false end


function modifier_item_hd_eagle:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_vision = self.ability:GetSpecialValueFor("bonus_vision")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
end



function modifier_item_hd_eagle:ADDeclareFunctions()
	return {

		advanced_MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,              
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	
	}
end


function modifier_item_hd_eagle:Advanced_GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_eagle:Advanced_GetBonusVisionPercentage()	return self.bonus_vision end
