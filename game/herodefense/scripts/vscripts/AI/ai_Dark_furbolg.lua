

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	-- agrAbility = thisEntity:FindAbilityByName( "berserkers_call_datadriven" )
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	-- thisEntity:SetContextThink( "CallousFurbolgThink", CallousFurbolgThink, 1 )
	thisEntity:SetRenderColor(30,30,30)
end

function CallousFurbolgThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	-- local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    
    -- if agrAbility ~= nil and agrAbility:IsFullyCastable() and enemies[1] ~= nil then
    --     return agr()
	-- end
    
    -- if ultAbility ~= nil and ultAbility:IsFullyCastable() and enemies[1] ~= nil then
    --     return ult(enemies[1])
	-- end
    
	return 0.3+RandomFloat(0.0,0.3)
end

