
require("internal/timers")

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "slark_challenge_pounce" )
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	thisEntity:SetContextThink( "AIThink", AIThink, 1 )
	Timers:CreateTimer(0.05, function()
		if thisEntity.challenge_level then
			local level = thisEntity.challenge_level
			local unit = thisEntity
			unit:SetBaseDamageMax(45+6*_G.GAME_ROUND*level)
			unit:SetBaseDamageMin(45+6*_G.GAME_ROUND*level)
			SetCreatureHealth(unit, 2700+750*_G.GAME_ROUND*level, true)
			unit:SetPhysicalArmorBaseValue(5+level*4)
		elseif thisEntity.endlessLevel then
			local level = thisEntity.endlessLevel
			local unit = thisEntity
			unit:SetBaseDamageMax(1500+700*level*(1+level*0.04))
			unit:SetBaseDamageMin(1500+700*level*(1+level*0.04))
			SetCreatureHealth(unit, 45000+45000*level*(1+level*0.04), true)
			unit:SetPhysicalArmorBaseValue(10+level*2)
		else
			return 0.01
		end
	end)
end

function AIThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	-- local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500,
	--  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false )
	-- --注意，这里搜寻包含了魔免单位
	



    if Ability1 ~= nil and Ability1:IsFullyCastable() then
		local unit = FinDWeakestEnemyInRange( thisEntity, 1500,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS  )
		if unit then
			if CalculateDistance(thisEntity,unit)>300 then
				return SpellAbility1(unit)
			end
		end

		
        
	end
    
    -- if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
    --     return ult(enemies[1])
	-- end
    
	return 0.3+RandomFloat(0.0,0.3)
end

function SpellAbility1(enemy)
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = enemy:entindex(),
			AbilityIndex = Ability1:entindex(),
			Queue = false,
		})
	end)
	
	return 2
end

