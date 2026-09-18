function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end


	thisEntity:SetContextThink( "NPCThink", NPCThink, 1 )
end

function NPCThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- local nEnemiesRemoved = 0
	-- local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS +DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false )
	-- for i = 1, #enemies do
	-- 	local enemy = enemies[i]
	-- 	if enemy ~= nil then
	-- 		local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	-- 		if flDist < 300 then
	-- 			nEnemiesRemoved = nEnemiesRemoved + 1
	-- 			table.remove( enemies, i )
	-- 		end
	-- 	end
	-- end

	--寻找自身1000范围内最富有的英雄
	local heroes = GetAllRealHeroes()
	local target 
	for _, unit in ipairs(heroes) do
		if unit:IsAlive() and not unit:IsAttackImmune() then
			local flDist = ( unit:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist<=1000 then
				if target==nil then
					target = unit
				else
					if target:GetGold() < unit:GetGold() then
						target = unit
					end
	
				end
			end


		end
	end
	if target then
		thisEntity:MoveToTargetToAttack(target)
	end
	
	return 2.5
end


