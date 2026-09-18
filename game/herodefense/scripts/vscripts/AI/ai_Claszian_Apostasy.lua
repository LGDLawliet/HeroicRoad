
require("internal/timers")

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end


	Ability1 = thisEntity:FindAbilityByName( "creeps_Void_time_walk" )
	Ability2 = thisEntity:FindAbilityByName( "creeps_spell_time_dilation" )
	Ability4 = thisEntity:FindAbilityByName( "creeps_spell_Chronosphere" )
	Ability5 = thisEntity:FindAbilityByName( "creeps_spell_Time_Crack" )
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )

	thisEntity:SetContextThink( "AIThink", AIThink, 1 )
	local sound = {
		-- "faceless_void_fv_arc_level_02",
		-- "faceless_void_fv_arc_chronos_special_05",
		"faceless_void_fv_arc_cast_06",
	}
	Timers:CreateTimer(2, function()
		EmitGlobalSound(sound[RandomInt(1, #sound)])
	end)
end

function AIThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	if Ability1 ~= nil and Ability1:IsFullyCastable() then
        local buffs = thisEntity:FindAllModifiersByName("modifier_creeps_Void_time_walk_damage_counter")  --启用伤害回溯
		local heal = 0 
		for _, buff in pairs(buffs) do
			heal = heal + buff:GetStackCount() / 10
		end
		local need = thisEntity:GetMaxHealth()*0.05
		if thisEntity:PassivesDisabled() then
			need = need * 2
		end
		if heal>=need then
			return SpellAbility1()
		end
	end


	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_FARTHEST, false )


    if Ability2 ~= nil and Ability2:IsFullyCastable() and enemies[1] ~= nil then
        return SpellAbility2()
	end

	if thisEntity:HasModifier("modifier_creeps_spell_Wave51_debuff") or thisEntity:HasModifier("modifier_creeps_spell_Wave51_changing_to_3") then
		return 0.5
	end


	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 800,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_FARTHEST, false )
	if Ability4 ~= nil and Ability4:IsFullyCastable() and enemies[1] ~= nil then
        return SpellAbility4(enemies[1])
	end


	
	if thisEntity.pattern_3 then

		if Ability5 ~= nil and Ability5:IsFullyCastable() then

			return SpellAbility5()
		end

	end

    
    -- if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
    --     return ult(enemies[1])
	-- end


	
    
	return 0.3+RandomFloat(0.0,0.3)
end

function SpellAbility1()
	local target
	local unit = FinDWeakestEnemyHeroInRange( thisEntity, 2000,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS  )
	if unit and CalculateDistance(thisEntity,unit)>1000 then
		target = unit:GetOrigin() + Vector(RandomInt(-300, 300),RandomInt(-300, 300),0)
	else
		target = thisEntity:GetOrigin()+ Vector(RandomInt(-600, 600),RandomInt(-600, 600),0)
	end


	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = target,
			AbilityIndex = Ability1:entindex(),
			Queue = false,
		})
	end)
	
	return 1
end

function SpellAbility2()
	-- local vTargetPos = enemy:GetOrigin()
	-- local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 100, 300 )
	-- vTargetPos = enemy:GetOrigin() + vLeadingOffset
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = Ability2:entindex(),
			Queue = false,
		})
	end)
	
	return 1
end


function SpellAbility4(target)

	
	local target_pos = target:GetOrigin()

	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = target_pos,
			AbilityIndex = Ability4:entindex(),
			Queue = false,
		})
	end)
	
	return 1
end


function SpellAbility5()
	-- local vTargetPos = enemy:GetOrigin()
	-- local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 100, 300 )
	-- vTargetPos = enemy:GetOrigin() + vLeadingOffset
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = Ability5:entindex(),
			Queue = false,
		})
	end)
	
	return 1
end









-- function ult( enemy )
-- 	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
-- 		ExecuteOrderFromTable({
-- 			UnitIndex = thisEntity:entindex(),
-- 			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
-- 			AbilityIndex = ultAbility:entindex(),
-- 			TargetIndex = enemy:entindex(),
-- 			Queue = false,
-- 		})
-- 	end)

-- 	return 1
-- end

function OnEntityKilled( event )

	local hVictim = nil
	local hAttacker = nil
	-- PrintTable(event)
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end
	if hVictim == thisEntity then
		local Spell_sound = {
			"faceless_void_fv_arc_death_01",
			"faceless_void_fv_arc_death_02",
			"faceless_void_fv_arc_death_03",
			"faceless_void_fv_arc_death_04",
			"faceless_void_fv_arc_death_05",
			"faceless_void_fv_arc_death_06",
			"faceless_void_fv_arc_death_07",
			"faceless_void_fv_arc_death_08",
			"faceless_void_fv_arc_death_09",
			"faceless_void_fv_arc_death_10",
			"faceless_void_fv_arc_death_11",
			"faceless_void_fv_arc_death_12",
			"faceless_void_fv_arc_death_13",
			"faceless_void_fv_arc_death_14",
			"faceless_void_fv_arc_death_15",

		
		}
		
		
		EmitGlobalSound(Spell_sound[RandomInt(1, #Spell_sound)])
	end
	-- if hVictim:IsRealHero() and hAttacker==thisEntity then
	-- 	EmitGlobalSound(BALNOCK_Kill_SOUND[RandomInt(1, 8)])
	-- end


	

	

end