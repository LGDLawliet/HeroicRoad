

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_light_strike_array" )
	Ability2 = thisEntity:FindAbilityByName( "creeps_spell_dragon_slave" )
	Ability3 = thisEntity:FindAbilityByName( "creeps_spell_laguna_blade" )
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
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_ANY_ORDER, false )


    if Ability1 ~= nil and Ability1:IsFullyCastable() and enemies[1] ~= nil then
        return SpellAbility1(enemies[1])
	end

	local modifier1 = thisEntity:FindModifierByName("modifier_fire_link_partten_2")
	
	if modifier1 then
		if Ability2 ~= nil and Ability2:IsFullyCastable() and enemies[1] ~= nil then
			return SpellAbility2(enemies[1])
		end
	end
	local modifier2 = thisEntity:FindModifierByName("modifier_fire_link_partten_3")
	if modifier2 then
		if Ability2 ~= nil and Ability3:IsFullyCastable() and enemies[1] ~= nil then
			return SpellAbility3(enemies[1])
		end
	end
    -- if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
    --     return ult(enemies[1])
	-- end
    
	return 0.1+RandomFloat(0.0,0.1)
end

function SpellAbility1(enemy)
	local vTargetPos = enemy:GetOrigin()
	local vLeadingOffset = Vector(0,0,0)
	if enemy:IsMoving() then
		vLeadingOffset = enemy:GetForwardVector() * RandomInt( 100, 300 )
	end
	vTargetPos = enemy:GetOrigin() + vLeadingOffset
	Timers:CreateTimer(RandomFloat(0.0,0.2), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetPos,
			AbilityIndex = Ability1:entindex(),
			Queue = false,
		})
	end)
	
	return 0.1
end

function SpellAbility2(enemy)
	local vTargetPos = enemy:GetOrigin()
	local vLeadingOffset = Vector(0,0,0)
	if enemy:IsMoving() then
		vLeadingOffset = enemy:GetForwardVector() * RandomInt( 100, 300 )
	end
	vTargetPos = enemy:GetOrigin() + vLeadingOffset
	Timers:CreateTimer(RandomFloat(0.0,0.2), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetPos,
			AbilityIndex = Ability2:entindex(),
			Queue = false,
		})
	end)
	
	return 0.1
end



function SpellAbility3(enemy)
	local vTargetPos = enemy:GetOrigin()
	local vLeadingOffset = Vector(0,0,0)
	if enemy:IsMoving() then
		vLeadingOffset = enemy:GetForwardVector() * RandomInt( 100, 300 )
	end
	vTargetPos = enemy:GetOrigin() + vLeadingOffset
	Timers:CreateTimer(RandomFloat(0.0,0.2), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetPos,
			AbilityIndex = Ability3:entindex(),
			Queue = false,
		})
	end)
	
	return 0.1
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