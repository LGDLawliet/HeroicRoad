
require("internal/timers")

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "nevermore_challenge_Shadowraze" )
	thisEntity:SetContextThink( "AIThink", AIThink, 1 )
	-- Timers:CreateTimer(0.05, function()
	-- 	local level = 4
	-- 	local unit = thisEntity
	-- 	unit:SetBaseDamageMax(30+4*_G.GAME_ROUND*level)
	-- 	unit:SetBaseDamageMin(30+4*_G.GAME_ROUND*level)
	-- 	SetCreatureHealth(unit, 1000+500*_G.GAME_ROUND*level, true)
	-- 	unit:SetPhysicalArmorBaseValue(6+level*2.5)
	-- 	unit:SetBaseMagicalResistanceValue(30+level*4)
	-- 	return 0.01
    -- end)
end

function AIThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    if Ability1 ~= nil and Ability1:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500,
		 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if enemies[1] ~= nil then
			return SpellAbility1(enemies[1])
		end
        
	end
	return 0.3+RandomFloat(0.0,0.3)
end



function SpellAbility1(enemy)
	local vTargetPos = enemy:GetOrigin()
	local vLeadingOffset = enemy:GetForwardVector() * RandomInt( 0, 300 )
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

