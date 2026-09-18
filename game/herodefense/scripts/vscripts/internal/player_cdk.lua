player_cdk = player_cdk or class({})

function player_cdk:Init()
    CustomGameEventManager:RegisterListener("GetCDKbonus", function(...)
        return self:_GetCDKbonus(...)
    end)
end

function player_cdk:_GetCDKbonus(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)     
    if not player then
        return
    end
    
    -- if not shop:IsPlayerCanBuy(nPlayerID) then --检测玩家是否可以购买东西
    --     CustomGameEventManager:Send_ServerToPlayer(player, "ShowCDKButton", {}) --强制刷新
    --     return
    -- end
    -- shop:SetPlayerBuyState(nPlayerID,false)
    _G.GAME_CAN_BUY[nPlayerID] = false
    -- local particleList = event_data.particleList
    local cdk = event_data.data
    local newData = {}
    newData.token = _G.GAME_GLOBAL_KEY
    newData.cdKey = cdk
    newData.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))


    local encoded = json.encode(newData)
    print(encoded)
    player_database:GetCDKbonus(nPlayerID,encoded)
    
end
