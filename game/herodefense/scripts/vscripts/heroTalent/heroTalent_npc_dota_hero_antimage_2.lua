heroTalent_npc_dota_hero_antimage_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_antimage_2", "heroTalent/heroTalent_npc_dota_hero_antimage_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_antimage_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_antimage_2"
end


function heroTalent_npc_dota_hero_antimage_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", context )


end



modifier_heroTalent_npc_dota_hero_antimage_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_antimage_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_antimage_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_antimage_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_antimage_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_antimage_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_antimage_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE_PERCENTAGE
    }
end
function modifier_heroTalent_npc_dota_hero_antimage_2:Advanced_GetModifier_DefaultMoveCastRangePercentage(keys)
	return 50
end
