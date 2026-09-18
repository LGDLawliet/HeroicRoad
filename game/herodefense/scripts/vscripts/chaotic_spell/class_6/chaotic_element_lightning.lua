LinkLuaModifier( "modifier_chaotic_element_lightning", "chaotic_spell/class_6/chaotic_element_lightning.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_element_lightning = class({})

function chaotic_element_lightning:GetIntrinsicModifierName()
	return "modifier_chaotic_element_lightning"
end
---------------------------------------------------------------------


modifier_chaotic_element_lightning = advanced_modifier({})
function modifier_chaotic_element_lightning:IsHidden() return true end
function modifier_chaotic_element_lightning:IsPurgable() return false end
function modifier_chaotic_element_lightning:OnCreated(params)
	self.outgoing_lightning = self:GetAbility():GetSpecialValueFor("outgoing_lightning")
	self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_cast_speed = self:GetAbility():GetSpecialValueFor("bonus_cast_speed")

end

function modifier_chaotic_element_lightning:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_CastPoint,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
	}
end

function modifier_chaotic_element_lightning:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_chaotic_element_lightning:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if not IsLightningDamage(keys) then return end
	return self.outgoing_lightning
end
function modifier_chaotic_element_lightning:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_move
end
function modifier_chaotic_element_lightning:Advanced_GetModifier_CastPoint()
	return self.bonus_cast_speed
end
function modifier_chaotic_element_lightning:Advanced_GetModifierAttackSpeedPercentage()
	return self.bonus_attack_speed
end