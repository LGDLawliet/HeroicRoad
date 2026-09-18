
luna_challenge_Lunar_Blessing = class({})

LinkLuaModifier("modifier_luna_challenge_Lunar_Blessing_passive", "creeps_spell/luna_challenge_Lunar_Blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_luna_challenge_Lunar_Blessing_effect", "creeps_spell/luna_challenge_Lunar_Blessing", LUA_MODIFIER_MOTION_NONE)


function luna_challenge_Lunar_Blessing:GetIntrinsicModifierName() return "modifier_luna_challenge_Lunar_Blessing_passive" end

modifier_luna_challenge_Lunar_Blessing_passive = class({})

function modifier_luna_challenge_Lunar_Blessing_passive:IsHidden() return true end
function modifier_luna_challenge_Lunar_Blessing_passive:IsAura() return true end
function modifier_luna_challenge_Lunar_Blessing_passive:GetAuraDuration() return 0.5 end
function modifier_luna_challenge_Lunar_Blessing_passive:GetModifierAura() return "modifier_luna_challenge_Lunar_Blessing_effect" end
function modifier_luna_challenge_Lunar_Blessing_passive:GetAuraRadius() return 1000 end
function modifier_luna_challenge_Lunar_Blessing_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_luna_challenge_Lunar_Blessing_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_luna_challenge_Lunar_Blessing_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


modifier_luna_challenge_Lunar_Blessing_effect = class({})

function modifier_luna_challenge_Lunar_Blessing_effect:IsDebuff()			return false end
function modifier_luna_challenge_Lunar_Blessing_effect:IsHidden() 			return false end
function modifier_luna_challenge_Lunar_Blessing_effect:IsPurgable() 			return false end
function modifier_luna_challenge_Lunar_Blessing_effect:IsPurgeException() 	return false end
function modifier_luna_challenge_Lunar_Blessing_effect:OnCreated(table)
	self.bonus_damage = 0
	self:StartIntervalThink(0.5)
end
function modifier_luna_challenge_Lunar_Blessing_effect:OnIntervalThink()
	self.bonus_damage = self:GetCaster():GetDamageMax()*0.4
	self:StartIntervalThink(-1)
end

function modifier_luna_challenge_Lunar_Blessing_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,     


	}
end


function modifier_luna_challenge_Lunar_Blessing_effect:GetModifierPreAttack_BonusDamage()	
	if self:GetCaster():PassivesDisabled() then
		return self.bonus_damage*0.5
	end
	return self.bonus_damage  
end

