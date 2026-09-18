heroTalent_npc_dota_hero_treant_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_treant_2", "heroTalent/heroTalent_npc_dota_hero_treant_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_treant_2_effect", "heroTalent/heroTalent_npc_dota_hero_treant_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
-- function heroTalent_npc_dota_hero_treant_2:GetIntrinsicModifierName()
-- 	return "modifier_heroTalent_npc_dota_hero_treant_2"
-- end


function heroTalent_npc_dota_hero_treant_2:GetCastRange()
	local caster = self:GetCaster()
	return 1700 - caster:GetCastRangeBonus()
end

function heroTalent_npc_dota_hero_treant_2:Spawn()
	if IsServer() then
		local heroes = GetAllRealHeroes()
		local caster = self:GetCaster()
		for _, unit in ipairs(heroes) do
			local newSpirit = CreateUnitByName("npc_dota_wisp_spirit", unit:GetOrigin(), false, caster, caster, caster:GetTeam())

			newSpirit:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_treant_2", {}) 
			-- local thinker = CreateModifierThinker(caster, self, "modifier_heroTalent_npc_dota_hero_treant_2", {}, unit:GetOrigin(), caster:GetTeamNumber(), false)
			newSpirit:SetParent(unit,"")
			-- print("ok")
		end
	end


end




modifier_heroTalent_npc_dota_hero_treant_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_treant_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_treant_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_treant_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_treant_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_treant_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_treant_2:CheckState()
	local state = {
		[MODIFIER_STATE_FORCED_FLYING_VISION]=true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
	}
	
	return state
end

-- function modifier_heroTalent_npc_dota_hero_treant_2:DeclareFunctions()
-- 	return {
		
-- 		MODIFIER_PROPERTY_BONUS_DAY_VISION,             
-- 		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,  
	
		

-- 	}
-- end



-- function modifier_heroTalent_npc_dota_hero_treant_2:GetBonusDayVision()	return 1700 end
-- function modifier_heroTalent_npc_dota_hero_treant_2:GetBonusNightVision()	return 1700 end
-- advanced_modifier
function modifier_heroTalent_npc_dota_hero_treant_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BONUS_DAY_VISION,
		advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION


    }
end



function modifier_heroTalent_npc_dota_hero_treant_2:Advanced_GetBonusDayVision()
	if IsInToolsMode() then
		return 12000
	end
	return 2500 
end
function modifier_heroTalent_npc_dota_hero_treant_2:Advanced_GetBonusNightVision()
	if IsInToolsMode() then
		return 12000
	end
	return 2500 
end






-- 