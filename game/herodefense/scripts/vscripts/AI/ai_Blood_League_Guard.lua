
--------------------------------------------------------------------------------
require("internal/timers")
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_Howl" )

	thisEntity:SetContextThink( "AIThink",AIThink, 0.5 )

	if _G.GAME_KING_WOLF_POS then
		Timers:CreateTimer(2, function()
			-- print("tp")
			thisEntity:SetOrigin(_G.GAME_KING_WOLF_POS)
			thisEntity:AddNewModifier(nil, nil, "modifier_phased", {duration=1.5}) --提供相位，防止卡位
		end)
	end
end

--------------------------------------------------------------------------------

function AIThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 3000,
	 DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	local hAttackTarget = nil
	local hApproachTarget = nil
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy:GetUnitName() == "npc_monster_wave_14_1" then
			if hEnemy ~= nil and hEnemy:IsAlive() then --and hEnemy:GetUnitName() ~= "npc_dota_friendly_bristleback_son" 
				local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
				if flDist > 800 then
					hApproachTarget = hEnemy
				end
			end
		end
	end

	if hAttackTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end
	local buffs = thisEntity:FindAllModifiersByName("modifier_creeps_spell_Howl_buff")
	if  #buffs == 0 then
		return SpellAbility1()
	end



	return 0.5
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
function SpellAbility1()
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = Ability1:entindex(),
			Queue = false,
		})
	end)
	
	return 2
end
