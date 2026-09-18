
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
end



function OnEndTouch( trigger )
	_G.GAME_PREPARE_INDEX = _G.GAME_PREPARE_INDEX - 1
	print( _G.GAME_PREPARE_INDEX.." get ready" )
	-- print( " out" )
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