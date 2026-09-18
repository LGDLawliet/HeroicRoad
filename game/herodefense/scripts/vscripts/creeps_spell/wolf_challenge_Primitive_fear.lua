
wolf_challenge_Primitive_fear = class({})

LinkLuaModifier("modifier_wolf_challenge_Primitive_fear_passive", "creeps_spell/wolf_challenge_Primitive_fear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wolf_challenge_Primitive_fear_effect", "creeps_spell/wolf_challenge_Primitive_fear", LUA_MODIFIER_MOTION_NONE)


function wolf_challenge_Primitive_fear:GetIntrinsicModifierName() return "modifier_wolf_challenge_Primitive_fear_passive" end

modifier_wolf_challenge_Primitive_fear_passive = class({})

function modifier_wolf_challenge_Primitive_fear_passive:IsHidden() return true end
function modifier_wolf_challenge_Primitive_fear_passive:IsAura() return true end
function modifier_wolf_challenge_Primitive_fear_passive:GetAuraDuration() return 0.5 end
function modifier_wolf_challenge_Primitive_fear_passive:GetModifierAura() return "modifier_wolf_challenge_Primitive_fear_effect" end
function modifier_wolf_challenge_Primitive_fear_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or 700 end
function modifier_wolf_challenge_Primitive_fear_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_wolf_challenge_Primitive_fear_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_wolf_challenge_Primitive_fear_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_wolf_challenge_Primitive_fear_effect = advanced_modifier({})

function modifier_wolf_challenge_Primitive_fear_effect:IsDebuff()			return true end
function modifier_wolf_challenge_Primitive_fear_effect:IsHidden() 			return false end
function modifier_wolf_challenge_Primitive_fear_effect:IsPurgable() 			return false end
function modifier_wolf_challenge_Primitive_fear_effect:IsPurgeException() 	return false end


function modifier_wolf_challenge_Primitive_fear_effect:Advanced_GetModifierIncomingDamage_Percentage()	return 35 end



function modifier_wolf_challenge_Primitive_fear_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_wolf_challenge_Primitive_fear_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return -25
end


