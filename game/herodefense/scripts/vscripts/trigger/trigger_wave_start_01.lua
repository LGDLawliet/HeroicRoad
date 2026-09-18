
---------------------------------------------------------------------------
-- Arrow Trap
---------------------------------------------------------------------------

function OnStartTouch( trigger )
	-- local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, thisEntity:GetAbsOrigin(), nil, 500, 
	-- DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	-- _G.GAME_PREPARE_INDEX = 0
	-- for _, unit in pairs(units) do
	-- 	if unit:IsRealHero() then
	-- 		_G.GAME_PREPARE_INDEX = _G.GAME_PREPARE_INDEX + 1
	-- 	end
	-- end
	_G.GAME_PREPARE_INDEX = _G.GAME_PREPARE_INDEX + 1
	print( _G.GAME_PREPARE_INDEX.." get ready" )

	local target = trigger.activator
	if not target or target.isThinker then
		return
	end

	if not target.default_teleport_particle then
		target:EmitSound("ui.weekend_tournament_team_icon_stamp")
		target.default_teleport_particle = ParticleManager:CreateParticle("particles/rebuild/general/teleport_default/effect_econ/events/fall_2021/teleport_start_fall_2021_lvl3.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControlEnt( target.default_teleport_particle, 0, target, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
	end

	
end



function OnEndTouch( trigger )
	_G.GAME_PREPARE_INDEX = _G.GAME_PREPARE_INDEX - 1
	print( _G.GAME_PREPARE_INDEX.." get ready" )
	-- print( " out" )
	local target = trigger.activator
	if not target or target.isThinker then
		return
	end

	if target.default_teleport_particle then
		ParticleManager:DestroyParticle(target.default_teleport_particle,false)
		target.default_teleport_particle = nil
		-- ParticleManager:SetParticleControlEnt( target.default_teleport_particle, 0, target, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
	end
end



function OnTrigger( trigger )
	
	print( "test" )
	print( "test" )
	print( "test" )
	print( "test" )
	print( "test" )
	print( "test" )
	print( "test" )

	-- print( " out" )
end


function ActiveTest( trigger )
	
	print( "ActiveTest" )
	print( "ActiveTest" )
	print( "ActiveTest" )
	print( "ActiveTest" )
	print( "ActiveTest" )
	print( "ActiveTest" )
	print( "ActiveTest" )
	print( "ActiveTest" )
	print( "ActiveTest" )

	-- print( " out" )
end