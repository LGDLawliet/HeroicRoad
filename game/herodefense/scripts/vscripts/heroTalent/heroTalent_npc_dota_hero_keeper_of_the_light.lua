--
heroTalent_npc_dota_hero_keeper_of_the_light = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_keeper_of_the_light", "heroTalent/heroTalent_npc_dota_hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_keeper_of_the_light:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_keeper_of_the_light"
end



modifier_heroTalent_npc_dota_hero_keeper_of_the_light = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:GetEffectName() return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_CastPoint
    }
end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:Advanced_GetModifierCastRangeBonusStacking(keys)
    return 350
end

function modifier_heroTalent_npc_dota_hero_keeper_of_the_light:Advanced_GetModifier_CastPoint() return 40 end




