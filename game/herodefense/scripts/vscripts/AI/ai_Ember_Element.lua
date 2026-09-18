

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_Sleight_of_Fist" )
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
    
	

    if Ability1 ~= nil and Ability1:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200,
	 	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_FARTHEST, false )

		if enemies[1] then
			return SpellAbility1(enemies[1])
		end
        
	end



	-- --激活了能量源
	-- if _G.GAME_DIFFICULTY==4 then
	-- 	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 4000,
	-- 	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
	--    if #hEnemies == 0 then
	-- 	   return 1
	--    end
	--    local hAttackTarget = nil
	--    local hApproachTarget = nil
	--    for _, hEnemy in pairs( hEnemies ) do
	-- 	   if hEnemy:GetUnitName() == "npc_monster_wave_30_1" then
	-- 		   if hEnemy ~= nil and hEnemy:IsAlive() then --and hEnemy:GetUnitName() ~= "npc_dota_friendly_bristleback_son" 
	-- 			   local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	-- 			   if flDist > 2000 then
	-- 				   hApproachTarget = hEnemy
	-- 			   end
	-- 		   end
	-- 	   end
	--    end
	--    if hAttackTarget == nil and hApproachTarget ~= nil then
	-- 	   return Approach( hApproachTarget )
	--    end
	-- end
    
    -- if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
    --     return ult(enemies[1])
	-- end
    
	return 0.3+RandomFloat(0.0,0.3)
end

function SpellAbility1(enemy)
	local vTargetPos = enemy:GetOrigin()
	local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 200, 400 )
	vTargetPos = enemy:GetOrigin() + vLeadingOffset
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


function Approach(unit)
	--print( "ai_bandit_archer - Approach" )

	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})

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