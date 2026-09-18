
underlord_challenge_Atrophy_Aura = class({})

LinkLuaModifier("modifier_underlord_challenge_Atrophy_Aura_passive", "creeps_spell/underlord_challenge_Atrophy_Aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_underlord_challenge_Atrophy_Aura_effect", "creeps_spell/underlord_challenge_Atrophy_Aura", LUA_MODIFIER_MOTION_NONE)


function underlord_challenge_Atrophy_Aura:GetIntrinsicModifierName() return "modifier_underlord_challenge_Atrophy_Aura_passive" end

modifier_underlord_challenge_Atrophy_Aura_passive = class({})

function modifier_underlord_challenge_Atrophy_Aura_passive:IsHidden() return true end
function modifier_underlord_challenge_Atrophy_Aura_passive:IsAura() return true end
function modifier_underlord_challenge_Atrophy_Aura_passive:GetAuraDuration() return 0.5 end
function modifier_underlord_challenge_Atrophy_Aura_passive:GetModifierAura() return "modifier_underlord_challenge_Atrophy_Aura_effect" end
function modifier_underlord_challenge_Atrophy_Aura_passive:GetAuraRadius() return 700 end
function modifier_underlord_challenge_Atrophy_Aura_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_underlord_challenge_Atrophy_Aura_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_underlord_challenge_Atrophy_Aura_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_underlord_challenge_Atrophy_Aura_passive:GetAuraEntityReject(hEntity)

-- 	if hEntity:GetUnitName()=="npc_monster_challenge_004" then
-- 		return true
-- 	end
-- 	return false
-- end

function modifier_underlord_challenge_Atrophy_Aura_passive:OnCreated(keys)
	if IsServer() then
		self:GetParent():AddActivityModifier('loadout')
	end
end
modifier_underlord_challenge_Atrophy_Aura_effect = class({})

function modifier_underlord_challenge_Atrophy_Aura_effect:IsDebuff()			return true end
function modifier_underlord_challenge_Atrophy_Aura_effect:IsHidden() 			return false end
function modifier_underlord_challenge_Atrophy_Aura_effect:IsPurgable() 			return false end
function modifier_underlord_challenge_Atrophy_Aura_effect:IsPurgeException() 	return false end
function modifier_underlord_challenge_Atrophy_Aura_effect:OnCreated(table)
	if IsServer() then
		self.bonus_damage = -self:GetParent():GetAverageTrueAttackDamage(nil)*0.2
	end
end


function modifier_underlord_challenge_Atrophy_Aura_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,     


	}
end


function modifier_underlord_challenge_Atrophy_Aura_effect:GetModifierBaseAttack_BonusDamage()	
	if IsClient() then
		return
	end
	local caster = self:GetCaster()

	if not caster or caster:PassivesDisabled() then
		return 0
	end
	return self.bonus_damage  
end

