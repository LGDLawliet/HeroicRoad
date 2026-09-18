require("internal/timers")



function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_breathe_fire" )
	Ability2 = thisEntity:FindAbilityByName( "creeps_spell_source_fire" )



	thisEntity:SetContextThink( "AIThink", AIThink, 1 )
	-- thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )
	Timers:CreateTimer(2, function()
		EmitGlobalSound("custom_lina_combustion")  
		Timers:CreateTimer(2.5, function()
			 EmitGlobalSound("custom_Slyrak_fire_dragon_common_enemy")  
		 end)
	end)

end

function AIThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
	if thisEntity:FindModifierByName("modifier_creeps_spell_dracarys") then
		return 0.1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 800,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_ANY_ORDER, false )
	if Ability1 ~= nil and Ability1:IsFullyCastable() and enemies[1] ~= nil then
		return SpellAbility1(enemies[1])
	end





	if thisEntity.pattern_3 then
		if Ability2 ~= nil and Ability2:IsFullyCastable() and enemies[1] ~= nil then
			return SpellAbility2(enemies[1])
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




function SpellAbility2(enemy)
	local vTargetPos = enemy:GetOrigin()
	-- local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 0, 300 )
	-- vTargetPos = enemy:GetOrigin() + vLeadingOffset
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
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

