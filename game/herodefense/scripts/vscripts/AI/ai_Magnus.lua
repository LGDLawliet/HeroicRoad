require("internal/timers")
Kill_SOUND = {
    "magnataur_magn_skewer_14",
	"magnataur_magn_kill_07",
	"magnataur_magn_kill_10",
	"magnataur_magn_kill_13",
	"magnataur_magn_kill_14",
	


}
center = Vector(-300,-1053,896)

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_shockwave" )
	Ability2 = thisEntity:FindAbilityByName( "creeps_spell_skewer" )
	Ability3 = thisEntity:FindAbilityByName( "creeps_spell_reverse_polarity" )
	Ability4 = thisEntity:FindAbilityByName( "creeps_spell_reverse_polarity_rebuild" )


	thisEntity:SetContextThink( "AIThink", AIThink, 1 )
	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )
	Timers:CreateTimer(2, function()
		EmitGlobalSound("magnataur_magn_spawn_06")
	end)

end

function AIThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
	if thisEntity:FindModifierByName("modifier_creeps_spell_reverse_polarity_rebuild") then
		return 0.1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_CLOSEST, false )
	if Ability1 ~= nil and Ability1:IsFullyCastable() and enemies[1] ~= nil then
		return SpellAbility1(enemies[1])
	end


	enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_CLOSEST, false )
	if Ability2 ~= nil and Ability2:IsFullyCastable() and enemies[1] ~= nil then
		return SpellAbility2()
	end


	if thisEntity.pattern_2 then
		if Ability3 ~= nil and Ability3:IsFullyCastable() then
			local unit = FinDWeakestEnemyInRange( thisEntity, 2000,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS  )
			if unit and CalculateDistance(thisEntity,unit)>1000 then
				return SpellAbility3(unit)
			end


		end

	end
    

	if thisEntity.pattern_3 then
		if Ability4 ~= nil and Ability4:IsFullyCastable() then
			return SpellAbility4()
		end

	end



    
    
	return 0.3+RandomFloat(0.0,0.3)
end

-- function SpellAbility1(enemy)
-- 	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
-- 		ExecuteOrderFromTable({
-- 			UnitIndex = thisEntity:entindex(),
-- 			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
-- 			TargetIndex = enemy:entindex(),
-- 			AbilityIndex = Ability1:entindex(),
-- 			Queue = false,
-- 		})
-- 	end)
	
-- 	return 2
-- end

function SpellAbility1(enemy)
	local vTargetPos = enemy:GetOrigin()
	-- local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 0, 300 )
	-- vTargetPos = enemy:GetOrigin() + vLeadingOffset
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetPos,
			AbilityIndex = Ability1:entindex(),
			Queue = false,
		})
	end)
	
	return 2
end
function SpellAbility2()
	local vTargetPos = thisEntity:GetOrigin()
	local vLeadingOffset = thisEntity:GetForwardVector() * 2000
	vTargetPos = vTargetPos + vLeadingOffset
	if CalculateDistance(thisEntity,center)>2200 then
		vTargetPos =center
	end
	
	Timers:CreateTimer(RandomFloat(0.0,0.1), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetPos,
			AbilityIndex = Ability2:entindex(),
			Queue = false,
		})
	end)
	
	return 2
end


function SpellAbility3(enemy)
	local vTargetPos = enemy:GetOrigin()
	-- local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 0, 300 )
	-- vTargetPos = enemy:GetOrigin() + vLeadingOffset
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetPos,
			AbilityIndex = Ability3:entindex(),
			Queue = false,
		})
	end)
	
	return 2
end




function SpellAbility4()
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = Ability4:entindex(),
			Queue = false,
		})
	end)
	-- print("555")
	
	return 2
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

		-- EmitGlobalSound("magnataur_magn_death_11")
		thisEntity:EmitSound("magnataur_magn_death_11")
	elseif hAttacker == thisEntity and hVictim:IsRealHero() then
		-- EmitGlobalSound(Kill_SOUND[RandomInt(1, #Kill_SOUND)])
		thisEntity:EmitSound(Kill_SOUND[RandomInt(1, #Kill_SOUND)])
		
	end



	

	

end