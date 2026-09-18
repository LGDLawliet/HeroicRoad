item_chaotic_blitz_knuckles = class({})

LinkLuaModifier("modifier_item_chaotic_blitz_knuckles", "items/item_chaotic_blitz_knuckles", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_blitz_knuckles:GetIntrinsicModifierName()
	return "modifier_item_chaotic_blitz_knuckles"
end



modifier_item_chaotic_blitz_knuckles = advanced_modifier({})

function modifier_item_chaotic_blitz_knuckles:IsDebuff() return false end
function modifier_item_chaotic_blitz_knuckles:IsHidden() return true end
function modifier_item_chaotic_blitz_knuckles:IsPurgable() return false end


function modifier_item_chaotic_blitz_knuckles:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
end



function modifier_item_chaotic_blitz_knuckles:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end


function modifier_item_chaotic_blitz_knuckles:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end
