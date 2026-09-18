

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_barr_thunder_attack" )
	Ability2 = thisEntity:FindAbilityByName( "creeps_spell_barr_thunder_attack_sword" )
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.5 )
end

function AIThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	


    if Ability1 ~= nil and Ability1:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, Ability1:GetCastRange(thisEntity:GetOrigin(), thisEntity),
	 	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_ANY_ORDER, false )
		if enemies[1] then
			return SpellAbility1(enemies[1])
		end
       
	end

	if Ability2 ~= nil and Ability2:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, Ability2:GetCastRange(thisEntity:GetOrigin(), thisEntity),
	 	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_ANY_ORDER, false )
		if enemies[1] then
			return SpellAbility2(enemies[1])
		end
       
	end
    
	return 0.3+RandomFloat(0.0,0.3)
end

function SpellAbility1(enemy)
	local vTargetPos = enemy:GetOrigin()
	local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 100, 300 )
	vTargetPos = enemy:GetOrigin() + vLeadingOffset
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = Ability1:entindex(),
		Queue = false,
	})
	
	return 0.2
end
function SpellAbility2(enemy)
	local vTargetPos = enemy:GetOrigin()
	local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 100, 300 )
	vTargetPos = enemy:GetOrigin() + vLeadingOffset
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = Ability2:entindex(),
		Queue = false,
	})
	
	return 0.2
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