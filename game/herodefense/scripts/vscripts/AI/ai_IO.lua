
require("internal/timers")
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_Tether" )
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.2 )
	thisEntity:SetTeam(DOTA_TEAM_GOODGUYS)
	Egg_sound:TryPlayEggSoundOfWave25()
	Timers:CreateTimer(0.5, function()
		thisEntity:SetOrigin(Vector(-300,-1053,896))
		thisEntity:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
	end)
end

function AIThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 500, 
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 
	DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST,false )
	local buffs1 = thisEntity:FindAllModifiersByName("modifier_creeps_spell_Tether_spell")
	if #buffs1 ~=0 then
		return 3
	end


	if Ability1 ~= nil and Ability1:IsFullyCastable() then
		for _, enemy in pairs(enemies) do
			local buffs = enemy:FindAllModifiersByName("modifier_creeps_spell_Tether_effect")
			if  #buffs == 0  and enemy~=thisEntity then
                return SpellAbility1(enemy)
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