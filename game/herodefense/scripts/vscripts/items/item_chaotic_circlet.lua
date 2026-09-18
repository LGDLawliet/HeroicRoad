item_chaotic_circlet = class({})

LinkLuaModifier("modifier_item_chaotic_circlet", "items/item_chaotic_circlet", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_circlet:GetIntrinsicModifierName()
	return "modifier_item_chaotic_circlet"
end



modifier_item_chaotic_circlet = advanced_modifier({})

function modifier_item_chaotic_circlet:IsDebuff() return false end
function modifier_item_chaotic_circlet:IsHidden() return true end
function modifier_item_chaotic_circlet:IsPurgable() return false end


function modifier_item_chaotic_circlet:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
end



function modifier_item_chaotic_circlet:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end


function modifier_item_chaotic_circlet:Advanced_GetModifierBonusStats_Strength()return self.bonus_atb end
function modifier_item_chaotic_circlet:Advanced_GetModifierBonusStats_Agility()return self.bonus_atb end
function modifier_item_chaotic_circlet:Advanced_GetModifierBonusStats_Intellect()return self.bonus_atb end