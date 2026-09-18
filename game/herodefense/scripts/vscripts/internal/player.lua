


player = player or  class( { })

-- require('internal/timers')
function player:Init()
	self.playerHeroList = {}
end
function player:GetPlayerHero(nPlayerID)
	if not self.playerHeroList[nPlayerID] then
		local player = PlayerResource:GetPlayer(nPlayerID)
		if player then
			local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
			self.playerHeroList[nPlayerID] = playerHero
		end
   
		
	end
	return self.playerHeroList[nPlayerID]
end
function player:EachPlayer(func)
	local count = 0
	for n = 1, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS ), 1 do
		local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS , n)
		count = count +1
		if PlayerResource:IsValidPlayerID(playerID) then
			if func(count, playerID) == true then
				return
			end
		end
	end
	for n = 1, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS  ), 1 do
		local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS  , n)
		count = count +1
		if PlayerResource:IsValidPlayerID(playerID) then
			if func(count, playerID) == true then
				return
			end
		end
	end
end

function player:EachPlayerWithTeam(team,func)
	local count = 0
	for n = 1, PlayerResource:GetPlayerCountForTeam(team ), 1 do
		local playerID = PlayerResource:GetNthPlayerIDOnTeam(team , n)
		count = count +1
		if PlayerResource:IsValidPlayerID(playerID) then
			if func(count, playerID) == true then
				return
			end
		end
	end
end



--使用例子
-- player:EachPlayer(function(n, playerID)
-- 	for i = #self.PlayerMissing[playerID], 1, -1 do
-- 		local hUnit = self.PlayerMissing[playerID][i]
-- 		table.remove(self.PlayerMissing[playerID], i)
-- 		if IsValid(hUnit) then
-- 			-- hUnit:RemoveModifierByName("modifier_wave")
-- 			hUnit:SetWaveTag(false)
-- 			hUnit:ForceKill(false)
-- 		end
-- 	end
-- end)

function CDOTA_PlayerResource:IsActivated(nPlayerID)
	if not PlayerResource:IsValidPlayerID(nPlayerID) then
		return false
	end
	if PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_ABANDONED then
		return false
	end
	return true
end

-- function CDOTA_PlayerResource:GetSteamID(nPlayerID)
-- 	-- print("return")
-- 	if nPlayerID==0 then
-- 		return "76561198200656253"
-- 	end
-- 	return 0
-- end


-- function CDOTA_PlayerResource:GetSteamAccountID(playerId)
-- 	if nPlayerID==0 then
-- 		return "240390525"
-- 	end
-- 	return 0
-- end








