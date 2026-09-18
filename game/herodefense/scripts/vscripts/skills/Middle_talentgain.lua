LinkLuaModifier( "modifier_Middle_talentgain", "skills/Middle_talentgain.lua", LUA_MODIFIER_MOTION_NONE )

Middle_talentgain = class({})

function Middle_talentgain:GetIntrinsicModifierName()
	return "modifier_Middle_talentgain"
end


modifier_Middle_talentgain = advanced_modifier({})

function modifier_Middle_talentgain:IsDebuff() 	return false end
function modifier_Middle_talentgain:IsHidden() 	return true end
function modifier_Middle_talentgain:IsPurgable() 		return false end
function modifier_Middle_talentgain:IsPurgeException() 	return false end
function modifier_Middle_talentgain:RemoveOnDeath() 	return false end
function modifier_Middle_talentgain:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.profic = self.ability:GetSpecialValueFor("profic")
	self.atb = self.ability:GetSpecialValueFor("atb")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end
function modifier_Middle_talentgain:OnRefresh()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.profic = self.ability:GetSpecialValueFor("profic")
	self.atb = self.ability:GetSpecialValueFor("atb")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_Middle_talentgain:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end
function modifier_Middle_talentgain:Advanced_GetModifier_TalentEffectGain()
	return self.profic
end
function modifier_Middle_talentgain:Advanced_GetModifierBonusStats_Strength()
	return self.atb
end
function modifier_Middle_talentgain:Advanced_GetModifierBonusStats_Agility()
	return self.atb
end
function modifier_Middle_talentgain:Advanced_GetModifierBonusStats_Intellect()
	return self.atb
end
function modifier_Middle_talentgain:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return 0 end
	local ability = keys.inflictor
	if ability and string.find(ability:GetAbilityName(), "heroTalent_npc_dota_hero_") then
		print("伤害来源为"..ability:GetAbilityName().."增伤生效")
		return self.outgoing
	end
end