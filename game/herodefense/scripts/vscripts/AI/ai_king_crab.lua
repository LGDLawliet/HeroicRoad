

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName("creeps_spell_Deep_sea_frenzy")
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	thisEntity:SetContextThink( "AIThink", AIThink, 1 )
end

function AIThink()
	
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	if GameRules:IsGamePaused() == true then
		return 1
	end
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_ANY_ORDER, false )


    if Ability1 ~= nil and Ability1:IsFullyCastable() and enemies[1] ~= nil then
        return SpellAbility1()
	end


	-- end
    
	return 0.3+RandomFloat(0.0,0.3)
end

function SpellAbility1()
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = Ability1:entindex(),
			Queue = false,
		})
	end)
	
	return 8
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