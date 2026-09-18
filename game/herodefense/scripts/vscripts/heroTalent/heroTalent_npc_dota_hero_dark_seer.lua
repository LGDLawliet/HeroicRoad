heroTalent_npc_dota_hero_dark_seer = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dark_seer", "heroTalent/heroTalent_npc_dota_hero_dark_seer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dark_seer_effect", "heroTalent/heroTalent_npc_dota_hero_dark_seer", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_dark_seer:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_dark_seer"
end



modifier_heroTalent_npc_dota_hero_dark_seer = class({})

function modifier_heroTalent_npc_dota_hero_dark_seer:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_dark_seer:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dark_seer:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dark_seer:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dark_seer:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_dark_seer:IsAura()
	return true
end

function modifier_heroTalent_npc_dota_hero_dark_seer:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_dark_seer_effect" end
function modifier_heroTalent_npc_dota_hero_dark_seer:GetAuraRadius()	return -1  end
function modifier_heroTalent_npc_dota_hero_dark_seer:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_dark_seer:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end

function modifier_heroTalent_npc_dota_hero_dark_seer:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end



modifier_heroTalent_npc_dota_hero_dark_seer_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dark_seer_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_dark_seer_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dark_seer_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dark_seer_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_heroTalent_npc_dota_hero_dark_seer_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_dark_seer_effect:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
end
function modifier_heroTalent_npc_dota_hero_dark_seer_effect:Advanced_GetModifierHealAMP_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
end
