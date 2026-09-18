

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end


	thisEntity:SetContextThink( "CallousFurbolgThink", CallousFurbolgThink, 1 )
end




function CallousFurbolgThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	_G.GAME_KING_WOLF_POS = thisEntity:GetAbsOrigin()
    
	return 0.3+RandomFloat(0.0,0.3)
end


