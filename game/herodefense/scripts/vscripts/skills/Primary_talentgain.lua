LinkLuaModifier( "modifier_Primary_talentgain", "skills/Primary_talentgain.lua", LUA_MODIFIER_MOTION_NONE )

Primary_talentgain = class({})

function Primary_talentgain:GetIntrinsicModifierName()
	return "modifier_Primary_talentgain"
end


modifier_Primary_talentgain = advanced_modifier({})

function modifier_Primary_talentgain:IsDebuff() 	return false end
function modifier_Primary_talentgain:IsHidden() 	return true end
function modifier_Primary_talentgain:IsPurgable() 		return false end
function modifier_Primary_talentgain:IsPurgeException() 	return false end
function modifier_Primary_talentgain:RemoveOnDeath() 	return false end
function modifier_Primary_talentgain:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.profic = self.ability:GetSpecialValueFor("profic")
	self.atb = self.ability:GetSpecialValueFor("atb")
end
function modifier_Primary_talentgain:OnRefresh()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.profic = self.ability:GetSpecialValueFor("profic")
	self.atb = self.ability:GetSpecialValueFor("atb")
end

function modifier_Primary_talentgain:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end
function modifier_Primary_talentgain:Advanced_GetModifier_TalentEffectGain()
	return self.profic
end
function modifier_Primary_talentgain:Advanced_GetModifierBonusStats_Strength()
	return self.atb
end
function modifier_Primary_talentgain:Advanced_GetModifierBonusStats_Agility()
	return self.atb
end
function modifier_Primary_talentgain:Advanced_GetModifierBonusStats_Intellect()
	return self.atb
end