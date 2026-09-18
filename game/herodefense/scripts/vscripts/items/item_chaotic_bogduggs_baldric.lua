item_chaotic_bogduggs_baldric = class({})

LinkLuaModifier("modifier_item_chaotic_bogduggs_baldric", "items/item_chaotic_bogduggs_baldric", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_bogduggs_baldric:GetIntrinsicModifierName()
	return "modifier_item_chaotic_bogduggs_baldric"
end



modifier_item_chaotic_bogduggs_baldric = advanced_modifier({})

function modifier_item_chaotic_bogduggs_baldric:IsDebuff() return false end
function modifier_item_chaotic_bogduggs_baldric:IsHidden() return true end
function modifier_item_chaotic_bogduggs_baldric:IsPurgable() return false end


function modifier_item_chaotic_bogduggs_baldric:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
end



function modifier_item_chaotic_bogduggs_baldric:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end


function modifier_item_chaotic_bogduggs_baldric:Advanced_GetModifierPhysicalArmorBonus()return self.bonus_armor end
