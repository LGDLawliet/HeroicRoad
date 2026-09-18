

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_callous" )
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	thisEntity:SetContextThink( "CallousFurbolgThink", CallousFurbolgThink, 1 )

end

function CallousFurbolgThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	


	if Ability1 ~= nil and Ability1:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_FARTHEST,false )
		for _, enemy in pairs(enemies) do
			local buffs = enemy:FindAllModifiersByName("modifier_creeps_spell_callous_effect")
			if  #buffs == 0 then
                return SpellAbility1(enemy)
            end
        end
	end
    
    -- if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
    --     return ult(enemies[1])
	-- end
    
	return 0.8+RandomFloat(0.0,0.8)
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
	
	return 5
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