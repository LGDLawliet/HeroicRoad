heroTalent_npc_dota_hero_queenofpain = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_queenofpain", "heroTalent/heroTalent_npc_dota_hero_queenofpain", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_queenofpain_effect", "heroTalent/heroTalent_npc_dota_hero_queenofpain", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_queenofpain:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_queenofpain"
end

-- function heroTalent_npc_dota_hero_queenofpain:GetCastRange()
-- 	local caster = self:GetCaster()
-- 	return 650 - caster:GetCastRangeBonus()

-- end

modifier_heroTalent_npc_dota_hero_queenofpain = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_queenofpain:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_queenofpain:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_queenofpain:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_queenofpain:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_queenofpain:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_queenofpain:Advanced_GetModifierIncomingDamage_Percentage()	
	if not self:GetParent():IsRealHero() then
		return 0
	end
	return 10 
end



function modifier_heroTalent_npc_dota_hero_queenofpain:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_queenofpain:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if not self:GetParent():IsRealHero() then
		return 0
	end
	return 28 
end

