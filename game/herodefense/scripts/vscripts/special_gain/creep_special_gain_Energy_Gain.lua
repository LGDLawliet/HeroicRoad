creep_special_gain_Energy_Gain = class({})

LinkLuaModifier("modifier_creep_special_gain_Energy_Gain", "special_gain/creep_special_gain_Energy_Gain", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Energy_Gain:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Energy_Gain"
end

--require('internal/timers')   --计时器功能
modifier_creep_special_gain_Energy_Gain = advanced_modifier({})

function modifier_creep_special_gain_Energy_Gain:IsDebuff() return false end
function modifier_creep_special_gain_Energy_Gain:IsHidden() return false end
function modifier_creep_special_gain_Energy_Gain:IsPurgable() return false end
function modifier_creep_special_gain_Energy_Gain:GetEffectName() return "particles/new_effect/creep_gain_effect/energy_gain_body_ambient.vpcf" end
function modifier_creep_special_gain_Energy_Gain:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_Energy_Gain:OnCreated(keys)
	self.each_incoming_up = self:GetAbility():GetSpecialValueFor("each_incoming_up")
	self.bonus_hp_max = self:GetAbility():GetSpecialValueFor("bonus_hp_max")
end

function modifier_creep_special_gain_Energy_Gain:Advanced_GetModifierIncomingDamage_Percentage() 	return self:GetStackCount()*self.each_incoming_up end
function modifier_creep_special_gain_Energy_Gain:AdvancedGetModifierExtraHealthPercentage()	return self.bonus_hp_max end
function modifier_creep_special_gain_Energy_Gain:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
	return funcs
end
function modifier_creep_special_gain_Energy_Gain:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end
function modifier_creep_special_gain_Energy_Gain:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if self:GetParent() ~= keys.unit then
		return
	end
	
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
    end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then 
		return
	end

	self:SetStackCount(self:GetStackCount() + 1)
end
function modifier_creep_special_gain_Energy_Gain:OnTooltip(keys)
	return self.each_incoming_up * self:GetStackCount()
end