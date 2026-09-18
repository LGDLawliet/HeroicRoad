print("我爱你1")
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ogre_magi_3", "heroTalent/heroTalent_npc_dota_hero_ogre_magi_3.lua", LUA_MODIFIER_MOTION_NONE )
print("我爱你2")
require("internal.ui_event.boss_entry")
--Abilities
-- if heroTalent_npc_dota_hero_ogre_magi_3 == nil then
-- 	heroTalent_npc_dota_hero_ogre_magi_3 = class({})
-- end
local testmode = true
heroTalent_npc_dota_hero_ogre_magi_3 = class({})
print("我爱你3")
-- function heroTalent_npc_dota_hero_ogre_magi_3:GetIntrinsicModifierName()
-- 	return "modifier_heroTalent_npc_dota_hero_ogre_magi_3"
-- end
function heroTalent_npc_dota_hero_ogre_magi_3:OnSpellStart()
	local caster = self:GetCaster()
	local playerid = caster:GetPlayerID()
	local cursorPosition = self:GetCursorPosition()
	local casterPosition = caster:GetAbsOrigin()
	local abilityNum = caster:GetAbilityCount()
	local abilityCount = 0
	local abilityTable = {}
	for i=0,abilityNum-1 do
		local ability = caster:GetAbilityByIndex(i)
		if ability and ability:IsFullyCastable() and not ability:IsPassive() and ability ~= self then
			table.insert(abilityTable,ability)
		end
	end
	if #abilityTable <= 2 then
		GameRules:SendCustomMessage("你技能不够你放什么,信不信我让你飞起来?", 1, caster:GetPlayerID())
		return
	end
	-- --储存部分--
	-- for i=0,abilityCount-1 do
	-- 	local ability = caster:GetAbilityByIndex(i)
	-- 	if ability:IsFullyCastable() then
	-- 		table.insert(abilityTable,ability)
	-- 	end
	-- end
	local randomnum = math.random(1,#abilityTable)
	local castAbility = abilityTable[randomnum]
	table.remove(abilityTable,randomnum)
	local behavior = castAbility:GetBehaviorInt()
	local range
	local newPositon = cursorPosition
	--点释放类技能--
	if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
		range = castAbility:GetCastRange(caster:GetAbsOrigin(),caster)
		if (cursorPosition-casterPosition):Length2D() >= range then
			local ratio = range/(cursorPosition-casterPosition):Length2D()	--如果释放的点在技能施放范围外，则将释放点移动到技能施放范围边缘 下面同
			newPositon = cursorPosition:Lerp(casterPosition,1-ratio)
			caster:CastAbilityOnPosition(newPositon, castAbility, playerid)
		else
			caster:CastAbilityOnPosition(newPositon, castAbility, playerid)
		end
	end
	--无目标技能--
	if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
		caster:CastAbilityNoTarget(castAbility, playerid)
	end
	--目标技能--
	if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
		range = castAbility:GetCastRange(caster:GetAbsOrigin(),caster)
		local enemies
		if (cursorPosition-casterPosition):Length2D() >= range then
			local ratio = range/(cursorPosition-casterPosition):Length2D()
			newPositon = cursorPosition:Lerp(casterPosition,1-ratio)
		end

		enemies = FindUnitsInRadius( caster:GetTeamNumber(),
		newPositon,
		nil,
		castAbility:GetAOERadius() or 100,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS,
		FIND_CLOSEST,
		false)
		if #enemies > 0 then
			caster:CastAbilityOnTarget(enemies[1], castAbility, playerid)
		else
			GameRules:SendCustomMessage("你人搁哪呢,你看我让不让你飞起来就完事了（没有找到目标）", 1, caster:GetPlayerID())
			return
		end
		
	end
	local messages = {
		"那我问你,那我问你",
		"你是男的是女的",
		"你你你头顶是不是尖的",
		"你头顶怎么尖尖的",
	}
	GameRules:SendCustomMessage(messages[math.random(#messages)], 1, caster:GetPlayerID())
	castAbility:EndCooldown()
	local ability = abilityTable[math.random(1,#abilityTable)]
	ability:StartCooldown(castAbility:GetCooldown(castAbility:GetLevel())*0.5)
end
---------------------------------------------------------------------
--Modifiers
if modifier_heroTalent_npc_dota_hero_ogre_magi_3 == nil then
	modifier_heroTalent_npc_dota_hero_ogre_magi_3 = advanced_modifier({})
end
function modifier_heroTalent_npc_dota_hero_ogre_magi_3:OnCreated(params)
	if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_ogre_magi_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_ogre_magi_3:OnDestroy()
	if IsServer() then
	end
end

function modifier_heroTalent_npc_dota_hero_ogre_magi_3:DeclareFunctions()
	return {
	}
end

