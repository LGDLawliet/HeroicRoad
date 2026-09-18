creep_special_gain_nihility = class({})

LinkLuaModifier("modifier_creep_special_gain_nihility", "special_gain/creep_special_gain_nihility", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_nihility_buff", "special_gain/creep_special_gain_nihility", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_nihility:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_nihility"
end
------------
modifier_creep_special_gain_nihility = advanced_modifier({})

function modifier_creep_special_gain_nihility:IsDebuff() return false end
function modifier_creep_special_gain_nihility:IsHidden() return false end
function modifier_creep_special_gain_nihility:IsPurgable() return false end
function modifier_creep_special_gain_nihility:OnCreated(keys)
    self.ability = self:GetAbility()
	self.parent =self:GetParent()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self:StartIntervalThink(0.2)
end
function modifier_creep_special_gain_nihility:OnIntervalThink()
	
	if IsServer() then
		if self.ability:IsCooldownReady() then
			self.duration = self:GetAbility():GetSpecialValueFor("duration")
			local Gain = self.parent:GetModifierDurationGainIndex(1)
			if self:GetCaster():PassivesDisabled() then
				self.duration = math.max(self.duration - 0.5*self:GetAbility():GetSpecialValueFor("duration") , 0)
			end
			if self:GetCaster():IsSilenced() then
				self.duration = math.max(self.duration - 0.5*self:GetAbility():GetSpecialValueFor("duration") , 0)
			end

			self.parent:AddNewModifier(self.parent, self.ability, "modifier_creep_special_gain_nihility_buff", {duration =self.duration*Gain})
			self.ability:UseResources(true, true, true, true)
		end
	end
end



modifier_creep_special_gain_nihility_buff = advanced_modifier({})

function modifier_creep_special_gain_nihility_buff:IsDebuff()			return false end
function modifier_creep_special_gain_nihility_buff:IsHidden() 			return false end
function modifier_creep_special_gain_nihility_buff:IsPurgable() 		return false end
function modifier_creep_special_gain_nihility_buff:IsPurgeException() 	return false end
function modifier_creep_special_gain_nihility_buff:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
function modifier_creep_special_gain_nihility_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_nihility_buff:CheckState() return {[MODIFIER_STATE_ATTACK_IMMUNE] = true,} end

function modifier_creep_special_gain_nihility_buff:DeclareFunctions() 
	return {
	  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	} 
end

function modifier_creep_special_gain_nihility_buff:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_creep_special_gain_nihility_buff:GetModifierMagicalResistanceBonus() return -self:GetAbility():GetSpecialValueFor("magic_res_down") end






