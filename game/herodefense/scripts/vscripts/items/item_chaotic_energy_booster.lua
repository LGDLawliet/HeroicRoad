item_chaotic_energy_booster = class({})

LinkLuaModifier("modifier_item_chaotic_energy_booster", "items/item_chaotic_energy_booster", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_energy_booster:GetIntrinsicModifierName()
	return "modifier_item_chaotic_energy_booster"
end



modifier_item_chaotic_energy_booster = advanced_modifier({})

function modifier_item_chaotic_energy_booster:IsDebuff() return false end
function modifier_item_chaotic_energy_booster:IsHidden() return true end
function modifier_item_chaotic_energy_booster:IsPurgable() return false end


function modifier_item_chaotic_energy_booster:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
end



function modifier_item_chaotic_energy_booster:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MANA_BONUS,
	}
end


function modifier_item_chaotic_energy_booster:AdvancedGetModifierManaBonus()return self.bonus_mana end
