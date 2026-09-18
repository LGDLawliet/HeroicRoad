
wolf_challenge_assimilation = class({})

LinkLuaModifier("modifier_wolf_challenge_assimilation_passive", "creeps_spell/wolf_challenge_assimilation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wolf_challenge_assimilation_effect", "creeps_spell/wolf_challenge_assimilation", LUA_MODIFIER_MOTION_NONE)


function wolf_challenge_assimilation:GetIntrinsicModifierName() return "modifier_wolf_challenge_assimilation_passive" end

modifier_wolf_challenge_assimilation_passive = advanced_modifier({})

function modifier_wolf_challenge_assimilation_passive:IsHidden() return true end
function modifier_wolf_challenge_assimilation_passive:IsAura() return true end
function modifier_wolf_challenge_assimilation_passive:GetAuraDuration() return 0.5 end
function modifier_wolf_challenge_assimilation_passive:GetModifierAura() return "modifier_wolf_challenge_assimilation_effect" end
function modifier_wolf_challenge_assimilation_passive:GetAuraRadius() return 500 end
function modifier_wolf_challenge_assimilation_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_wolf_challenge_assimilation_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_wolf_challenge_assimilation_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_wolf_challenge_assimilation_passive:GetAuraEntityReject(hEntity)

	if hEntity:GetUnitName()=="npc_monster_challenge_004" then
		return true
	end
	return false
end
modifier_wolf_challenge_assimilation_effect = advanced_modifier({})

function modifier_wolf_challenge_assimilation_effect:IsDebuff()			return false end
function modifier_wolf_challenge_assimilation_effect:IsHidden() 			return true end
function modifier_wolf_challenge_assimilation_effect:IsPurgable() 			return false end
function modifier_wolf_challenge_assimilation_effect:IsPurgeException() 	return false end



function modifier_wolf_challenge_assimilation_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		MODIFIER_PROPERTY_MODEL_CHANGE,

	}
end


function modifier_wolf_challenge_assimilation_effect:GetModifierMoveSpeedBonus_Percentage()	return 50 end
function modifier_wolf_challenge_assimilation_effect:Advanced_GetModifierAttackSpeedPercentage()	return 50 end

function modifier_wolf_challenge_assimilation_effect:GetModifierModelChange()
	local name = self:GetParent():GetUnitName()
	local table = {
		npc_monster_challenge_001 = true,
		npc_monster_challenge_002 = true,
		npc_monster_challenge_003 = true,
		npc_monster_challenge_005 = true,
		npc_monster_wave_10_1 = true,
		npc_monster_wave_31_1 = true,
		npc_monster_wave_31_1_clone = true,
		npc_monster_wave_10_1_clone = true,
		npc_hd_Brain_worm = true,
		npc_hd_Brain_worm_clone = true,

	}
	if table[name] then
		return  self:GetParent():GetModelName()
	end

	return "models/items/lycan/wolves/blood_moon_hunter_wolves/blood_moon_hunter_wolves.vmdl"

end


function modifier_wolf_challenge_assimilation_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end

