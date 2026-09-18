
require("internal/timers")

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "underlord_challenge_Firestorm" )
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	thisEntity:SetContextThink( "AIThink", AIThink, 1 )
	Timers:CreateTimer(0.05, function()
		if thisEntity.challenge_level then
			local level = thisEntity.challenge_level
			local unit = thisEntity
			unit:SetBaseDamageMax(70+12*_G.GAME_ROUND*level)
			unit:SetBaseDamageMin(70+12*_G.GAME_ROUND*level)
			SetCreatureHealth(unit, 2700+750*_G.GAME_ROUND*level, true)
			unit:SetPhysicalArmorBaseValue(10+level*5)
		elseif thisEntity.endlessLevel then
			local level = thisEntity.endlessLevel
			local unit = thisEntity
			unit:SetBaseDamageMax(3000+1400*level*(1+level*0.04))
			unit:SetBaseDamageMin(3000+1400*level*(1+level*0.04))
			SetCreatureHealth(unit, 45000+55000*level*(1+level*0.04), true)
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
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 500,
	 	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_ANY_ORDER, false )
		if enemies[1] then
			return SpellAbility1(enemies[1])
		end
        
	end
    
    -- if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
    --     return ult(enemies[1])
	-- end
    
	return 0.3+RandomFloat(0.0,0.3)
end
function SpellAbility1(enemy)
	local vTargetPos = enemy:GetOrigin()
	-- local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 0, 300 )
	vTargetPos = enemy:GetOrigin() 
	Timers:CreateTimer(RandomFloat(0.0,0.3), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetPos,
			AbilityIndex = Ability1:entindex(),
			Queue = false,
		})
	end)
	
	return 0.3
end
