LinkLuaModifier( "modifier_creep_special_fear_alone", "special_gain/creep_special_fear_alone", LUA_MODIFIER_MOTION_NONE )

creep_special_fear_alone = class({})

function creep_special_fear_alone:GetIntrinsicModifierName()
	return "modifier_creep_special_fear_alone"
end
---------------------------------------------------------------------
modifier_creep_special_fear_alone = advanced_modifier({})

function modifier_creep_special_fear_alone:IsHidden() return false end
function modifier_creep_special_fear_alone:IsDebuff() return false end
function modifier_creep_special_fear_alone:IsPurgable() return false end

function modifier_creep_special_fear_alone:OnCreated(params)
	self.move_down = self:GetAbility():GetSpecialValueFor("move_down")
	self.incoming_down = self:GetAbility():GetSpecialValueFor("incoming_down")
	self.outgoing_up = self:GetAbility():GetSpecialValueFor("outgoing_up")
	self.noman_incoming_down = self:GetAbility():GetSpecialValueFor("noman_incoming_down")
	self.noman_outgoing_up = self:GetAbility():GetSpecialValueFor("noman_outgoing_up")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_creep_special_fear_alone:OnIntervalThink()
	self.i = 0
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		local modifier = unit:HasModifier("modifier_creep_special_fear_alone")
		if not modifier then
			self.i = self.i + 1
		end
	end
	self:SetStackCount(self.i)
end

function modifier_creep_special_fear_alone:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end
function modifier_creep_special_fear_alone:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_creep_special_fear_alone:CheckState()
	return{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_creep_special_fear_alone:Advanced_GetModifierIncomingDamage_Percentage()
	if self:GetStackCount() > 0 then
		return -self.incoming_down
	end
	return self.noman_incoming_down
end

function modifier_creep_special_fear_alone:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	if self:GetStackCount() > 0 then
		return self.outgoing_up
	end
	return -self.noman_outgoing_up
end
function modifier_creep_special_fear_alone:GetModifierMoveSpeedBonus_Percentage()
	return -self.move_down
end