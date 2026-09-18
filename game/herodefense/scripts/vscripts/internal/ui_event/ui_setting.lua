

PLAYER_NEED = 1  --需要确认的玩家数
PLAYER_YES = 0  --确认变更的玩家数


function uimanager:_ChangeTimeScale(eventSourceIndex, event_data)
  
    local sendInfo_PlayerID = event_data.player_id
    local scale = math.floor(event_data.scale *100)/100
    self:ChegeTimeScaleOrder(sendInfo_PlayerID,scale)

end
function uimanager:ChegeTimeScaleOrder(sendInfo_PlayerID,scale)
    if scale==_G.GAME_TIME_SCALE then
        --无需改变
        return
    end
    _G.GAME_TIME_SCALE_SAVE = scale
    PLAYER_NEED = 0
    PLAYER_YES = 0
    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        if steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED then
            PLAYER_NEED = PLAYER_NEED + 1
            if nPlayerID~=sendInfo_PlayerID then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "CheckTimeScaleChange", {})
            end
            
        end
    end
    --减掉自己
    PLAYER_NEED = PLAYER_NEED - 1
    if PLAYER_NEED<=0 then
        --说明是单人玩家 直接变更即可
        self:ChangeTimeScale()
        return
    end

end
function uimanager:_SendTimeScalechangeInfo_FeedBack(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local state =  event_data.change
    
    local Targetplayer = PlayerResource:GetPlayer(nPlayerID)
    if not Targetplayer then
        return
    end
    local TargetPlayerHero = Targetplayer:GetAssignedHero() --被复活者
    if not TargetPlayerHero then
        return
    end
    if state==1 then
        PLAYER_YES = PLAYER_YES + 1
        if PLAYER_YES>=PLAYER_NEED then
            local gameEvent = {}
            gameEvent["player_id"] = nPlayerID
            gameEvent["teamnumber"] = -1
            gameEvent["message"] = "#DOTA_HUD_Change_Time_Scale_Yes_show"
            FireGameEvent( "dota_combat_event_message", gameEvent )
            self:ChangeTimeScale()
        end
    else
        local gameEvent = {}
        gameEvent["player_id"] = nPlayerID
        gameEvent["teamnumber"] = -1
        gameEvent["message"] = "#DOTA_HUD_Change_Time_Scale_NO_show"
        FireGameEvent( "dota_combat_event_message", gameEvent )
        CustomGameEventManager:Send_ServerToAllClients("CloseAllTimeScaleRequest", {})
    end
  
end









function uimanager:ChangeTimeScale()
    _G.GAME_TIME_SCALE = _G.GAME_TIME_SCALE_SAVE
    Convars:SetFloat("host_timescale", GAME_TIME_SCALE)

    local gameEvent = {}
    gameEvent["teamnumber"] = -1
    gameEvent["locstring_value"] = tostring(math.floor(_G.GAME_TIME_SCALE_SAVE*100))
    gameEvent["message"] = "#DOTA_HUD_Change_Time_Scale_change_info"
    FireGameEvent( "dota_combat_event_message", gameEvent )
end
