local LocalArchive = require("internal/local_archive")

require("internal/json")
require('internal/timers')



if not player_database then
    player_database = class({})
end
PlayerData={}

function player_database:Init()
    self.cameraZ = {}
    self.cameraZchange = {}
    CustomGameEventManager:RegisterListener("CheckCameraZ", function(...)
        return self:_CheckCameraZ(...)
    end)

    CustomGameEventManager:RegisterListener("UpdateCameraZ", function(...)
        return self:_UpdateCameraZ(...)
    end)
end

function player_database:_CheckCameraZ(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID) 
    if player and self.cameraZ[nPlayerID] then
        CustomGameEventManager:Send_ServerToPlayer(player, "UpdateCameraDistanceEvent_feedback", {value = self.cameraZ[nPlayerID]})
    end
end
function player_database:_UpdateCameraZ(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID) 
    if player and self.cameraZ[nPlayerID] then
        self.cameraZ[nPlayerID] = event_data.cameraZ
        self.cameraZchange[nPlayerID] = true
    end
   
end


-- This URL only names local routes; LocalArchive performs no HTTP requests.
_G.GAME_server_address = "http://local-archive/"

function player_database:login_with_steamID(nPlayerID,spellMap,callback)
    --login
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local url =  _G.GAME_server_address.."user/login"
    local req = LocalArchive.CreateRequest("POST", url)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    local newData = {}
    newData.steamId = steamID
    newData.season = "-1"

    newData.token = _G.GAME_GLOBAL_KEY
    local encoded = json.encode(newData)


    req:SetHTTPRequestRawPostBody("application/json",encoded)          
    req:Send(function(res)
        -- DeepPrintTable(res)
        -- PrintTable(res.Request)
        -- print(res.Request:getResponseHeader('Date'))
        -- print("-------")
        if res.StatusCode == 200 then


            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            if not res_table then
                print("有人出错了")
                -- 未知原因登录错误
                local a = steamID
                local b = "login error"
                self:SendCustomData(a,b)
                self:login_with_steamID(nPlayerID,spellMap)  --再次尝试登录
                return
            end
            local rtnCode = res_table["rtnCode"]
            print("login rtnCode=="..rtnCode)
            -- PrintTable(res_table)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then

                --检验成功
    
                local res_table = JSON:decode(res.Body)
                local playersSpells = res_table["playerSpellsList"]
                local playerinfo = res_table["playerInfo"]
                local privilegeInfos = res_table["privilegeRecordList"]
                local seasonRannking = res_table["seasonRankings"]
                local specialEffectRecords = res_table["specialEffectRecords"]
                -- print(res.Body)
                -- print("--------------------------------------")
                -- PrintTable(res_table)
                local customData =  res_table["customizeList"]
                local dataList = customDataManager:InitCustomData(nPlayerID,customData)

                -- PrintTable(customData)
                -- print(res.getResponseHeader('Date'))
                -- print("--------------------------------------")
                spellMap[nPlayerID].playerinfo.vip = playerinfo.vip
                spellMap[nPlayerID].playerinfo.firstGameTime = playerinfo.firstGameTime
                spellMap[nPlayerID].playerinfo.giftBit = playerinfo.giftBit or 0
                spellMap[nPlayerID].playerinfo.reliableExp = playerinfo.reliableExp or 0  --可靠经验
                spellMap[nPlayerID].playerinfo.gold = playerinfo.gold or 0  --金币
                spellMap[nPlayerID].playerinfo.platinum = playerinfo.platinum or  0 --白金
                spellMap[nPlayerID].playerinfo.difficultyWave = playerinfo.wave or  0 --轮回层数
                spellMap[nPlayerID].playerinfo.core1 =tonumber( playerinfo.core1) or 0  --阿哈利姆三原石
                spellMap[nPlayerID].playerinfo.core2 = tonumber( playerinfo.core2) or 0
                spellMap[nPlayerID].playerinfo.core3 =tonumber( playerinfo.core3) or 0

                if playersSpells then
                    for _, value in pairs(playersSpells) do
                        spellMap[nPlayerID].spells[value.spellName]=value.exp
                    end
                end
                -- PrintTable(privilegeInfos,nil,nil)
                if privilegeInfos then
                    for _, value in pairs(privilegeInfos) do
                        local date = value.endDate
                        local serverTime = GameRules:GetGameModeEntity().CAddonTemplateGameMode.serverTime
                        local res = Comparison_time(date,serverTime)
                        --该特权成立
                        if res==true then
                            --更新到特权表里
                            spellMap[nPlayerID].vip[value.privilegeName] ={
                                endday = value.endDate
                            }
                            
                        end
    
                    end
                end
                
                if seasonRannking then
                    for key, value in pairs(seasonRannking) do
                        -- print(value.rank)
                        if not spellMap[nPlayerID].playerinfo.ranking  then
                            spellMap[nPlayerID].playerinfo.ranking  = value.rank
                        else
                            if value.rank<= spellMap[nPlayerID].playerinfo.ranking then
                                spellMap[nPlayerID].playerinfo.ranking = value.rank
                            end
                        end
                    end
                end

                if specialEffectRecords then
                    for _, info in ipairs(specialEffectRecords) do
                        -- local type = info.effectType
                        local name = info.effectName
        
                        local pos = particleManager:GetTablePos(spellMap[nPlayerID],name)
                        pos.ParticleSet[name] = info.endDate
                        if info.isEquip==1 then
                            pos.on_Particle = name
                        end
                    end
                end
                
                self.cameraZ[nPlayerID] = tonumber( playerinfo.cameraZ)
                if callback then
                    callback()
                end

            else
                print("return failed because of the wrong code")
            end

        else
            print("Server return with error", res.StatusCode, res.Body)
            GameRules:SendCustomMessage("DOTA_CUSTOM_LoginFailed", DOTA_TEAM_GOODGUYS, nPlayerID)
            Timers:CreateTimer(2, function()
                self:login_with_steamID(nPlayerID,spellMap,callback)  --再次尝试登录
            end)

        end
    end)
end

--更新玩家数据(用于游戏结算)

function player_database:UpdateUserData_with_steamID(nPlayerID,encoded,newspellstable,message_info)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    req:SetHTTPRequestRawPostBody("application/json",encoded)     


    -- print("更新数据")


    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- print("通过")
                if IsInToolsMode() then
                    self:login_with_steamID(nPlayerID,GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap)  --更新该玩家数据（仅当工具模式时 正常玩家局不需要更新）
                end
                if  _G.Check_Settlement_Request[nPlayerID] then
                    _G.Check_Settlement_Request[nPlayerID].base =true
                end
                Timers:CreateTimer(1, function()
                    if game_event:CheckSettlementState(nPlayerID) then
                        -- 全部结算好后再显示
                        local gameEvent = {}
                        gameEvent["player_id"] = nPlayerID
                        gameEvent["teamnumber"] = -1
                        gameEvent["message"] = "#DOTA_CUSTOM_UpdateSuccess"
                        FireGameEvent( "dota_combat_event_message", gameEvent )
                        _G.GAME_UPDATE_SUCCESS_INDEX = _G.GAME_UPDATE_SUCCESS_INDEX + 1  --储存成功的玩家加1 用于游戏结算
                        
                        if newspellstable or newspellstable then
                            local player = PlayerResource:GetPlayer(nPlayerID) 
                            CustomGameEventManager:Send_ServerToPlayer(player, "SetBonus", {sMessage=newspellstable,playerinfo = message_info})  --给出奖励提示
                        end
                    else
                        local gameEvent = {}
                        gameEvent["player_id"] = nPlayerID
                        gameEvent["teamnumber"] = -1
                        gameEvent["message"] = "#DOTA_CUSTOM_Update_wait"
                        FireGameEvent( "dota_combat_event_message", gameEvent ) 
                        return 1
                    end
                end)

                

            else
                print("return failed because of the wrong code")
            end

       else
           print("Server return with error", res.StatusCode, res.Body)
           game_event:UpdateFailed(nPlayerID,encoded)  --信息更新失败反馈
           Timers:CreateTimer(5, function()
            self:UpdateUserData_with_steamID(nPlayerID,encoded,newspellstable,message_info)  --再次尝试更新
        end)
           
       end

    end)

end


--用于领取礼包
function player_database:UpdateUserData_with_steamID_giftBonus(nPlayerID,newData,newspellstable,message_info)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    local encoded = json.encode(newData)
    req:SetHTTPRequestRawPostBody("application/json",encoded)     

    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- print("通过")
                -- PrintTable(newData)
                _G.GAME_CAN_BUY[nPlayerID] = true --修改为购买成功
                local playerinfo  = newData.playerInfo
                local playersSpells = newData.playerSpellsList
                local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
                map.playerinfo.giftBit = playerinfo.giftBit or map.playerinfo.giftBit
                map.playerinfo.reliableExp = playerinfo.reliableExp or  map.playerinfo.reliableExp  --可靠经验
                map.playerinfo.gold = playerinfo.gold or map.playerinfo.gold  --金币
                map.playerinfo.platinum = playerinfo.platinum or   map.playerinfo.platinum --白金
                if playersSpells then
                    for _, value in pairs(playersSpells) do
                        map.spells[value.spellName]=value.exp
                    end
                end

                -- self:login_with_steamID_giftBonus(nPlayerID,GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap)  
                GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateSuccess_gift", DOTA_TEAM_GOODGUYS, nPlayerID)
                if newspellstable then
                    local player = PlayerResource:GetPlayer(nPlayerID) 
                    CustomGameEventManager:Send_ServerToPlayer(player, "SetBonus", {sMessage=newspellstable,playerinfo = message_info})  --给出奖励提示
                end

            else
                GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateFail_gift", DOTA_TEAM_GOODGUYS, nPlayerID)
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
           GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateFail_gift", DOTA_TEAM_GOODGUYS, nPlayerID)
           Timers:CreateTimer(5, function()
            self:UpdateUserData_with_steamID_giftBonus(nPlayerID,newData,newspellstable,message_info)  --再次尝试更新
        end)
           
       end

    end)

end


--更新玩家数据  升级技能用
--完成后会反馈给js
function player_database:UpgradeUserSpell_with_steamID(nPlayerID,encoded,reliableExp,spellname,exp)
    local player = PlayerResource:GetPlayer(nPlayerID) 
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")

    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    req:Send(function(res)
        if res.StatusCode == 200 then

            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
            spellmap.playerinfo.reliableExp = reliableExp  --可靠经验
            spellmap.spells[spellname]=exp  --修改经验

            -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateSuccess", DOTA_TEAM_GOODGUYS, nPlayerID)
            local player = PlayerResource:GetPlayer(nPlayerID) 
            Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_UpgradeSuccess", duration = 4, style = { color = "white" } })
            EmitSoundOnClient("ui.badge_levelup", player)
            CustomGameEventManager:Send_ServerToPlayer(player, "UpgradeSpellSuccess_feedback", {})

            _G.GAME_CAN_BUY[nPlayerID] = true
       else
            _G.GAME_CAN_BUY[nPlayerID] = true
            Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_Upgradefailed_new", duration = 4, style = { color = "red" } })
            print("Server return with error", res.StatusCode, res.Body)
            --    GameRules:SendCustomMessage("DOTA_CUSTOM_Upgradefailed", DOTA_TEAM_GOODGUYS, nPlayerID) --技能升级失败的提示
            CustomGameEventManager:Send_ServerToPlayer(player, "UpgradeSpellSuccess_feedback", {})
        --    CustomGameEventManager:Send_ServerToPlayer(player, "UpgradeSpellFailed_feedback", {})
       end

    end)

end 



--GET time
function player_database:GetBeiJingTime()
    -- local player = PlayerResource:GetPlayer(nPlayerID) 
    local req = LocalArchive.CreateRequest("GET", "http://api.m.taobao.com/rest/api3.do?api=mtop.common.getTimestamp")
    -- req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- req:SetHTTPRequestRawPostBody("application/json",encoded)     
    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)

            local res_table = JSON:decode(res.Body)
 
            local info = res_table["data"]

            -- PrintTable(info)
            
            local time = info.t/1000   
            time = time - time%1
            -- print(time)
            -- print(getTimeStamp(info.t))
            -- self:login_with_steamID_when_upgrade_spell(nPlayerID,GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap)  --更新该玩家数据
            -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpgradeSuccess", DOTA_TEAM_GOODGUYS, nPlayerID)
            
       else
           print("Server return with error", res.StatusCode, res.Body)
        --    GameRules:SendCustomMessage("DOTA_CUSTOM_Upgradefailed", DOTA_TEAM_GOODGUYS, nPlayerID) --技能升级失败的提示
        --    CustomGameEventManager:Send_ServerToPlayer(player, "UpgradeSpellFailed_feedback", {})
       end

    end)

end 






--获取黑市
function player_database:GetBlackMarket(PlayerShop)
    -- local player = PlayerResource:GetPlayer(nPlayerID) 

    -- print("get black market0")

    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."blackMarket/get")
    local encoded = '{"token":"'.._G.GAME_GLOBAL_KEY..'"   }'
    req:SetHTTPRequestRawPostBody("application/json",encoded)  

    req:Send(function(res)
        -- PrintTable(res)
        -- print("get black market2")

        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            if not res_table then
                Timers:CreateTimer(1, function()
                    self:GetBlackMarket(PlayerShop)
                end)
                return
            end
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            -- print("get black market3")

            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                --检验成功

                --设置服务器时间
                GameRules:GetGameModeEntity().CAddonTemplateGameMode.serverTime = res_table["sysTime"]
                local NetTable_key = "server_time"
                CustomNetTables:SetTableValue( "game_data", NetTable_key, {time =res_table["sysTime"] } )  --更新网表
                -- CustomNetTables:SetTableValue( "game_data", NetTable_key, {time ="2021-08-30 12:55:33" } )  --更新网表
                _G.GAME_GetServerTime=true  --设置获取成功

                
                if IsLastDay(res_table["sysTime"]) then
                    print("是最后一天闭馆")
                    _G.GAME_ISLASTDAY = true
                end


                --设置黑市列表
                local list= res_table["blackmarketresultList"]
                -- print()
                -- PrintTable(list)
                for _, value in pairs(list) do
                    -- PrintTable(value)
                    PlayerShop[4][value.spellname] = {
                        item_name=value.spellname,
                        cost_class = 1,
                        cost=value.gold,
                        bonus = 1,
                        goods_class = TYPE_BUY_Spell_Book,  
                    }
                end

                -- _G.GAME_FELLOMEN
                local buffTable = res_table["buffInfo"]
                if buffTable then
                    _G.debuffs = buffTable['debuff']
                    _G.buffs = buffTable['buff']
                else
                    _G.debuffs = {}
                    _G.buffs = {}

                end
                
                
                if IsInToolsMode() or _G.GAME_debugTesting then
                    -- _G.buffs[1] = 14
                    -- _G.debuffs[1] =21
                end


  
                local effectsList= res_table["effectBlackMarketResultList"]
                -- PrintTable(effectsList)
                for _, value in pairs(effectsList) do
                    -- PrintTable(value)
                    local cost_class = TYPE_COST_Platinum
                    if value.paymentType==0 or value.paymentType=="0" then
                        cost_class = TYPE_COST_Aurum
                    end
                    PlayerShop[4][value.effectName] = {
                        item_name=value.effectName,
                        cost_class = cost_class,
                        bonus = 36500, --天数
                        cost=value.money,
                        goods_class = TYPE_BUY_ParticleEffect,  
                        discount = value.discount or 0,
                    }
       
                end
                if IsInToolsMode() then
                    PlayerShop[4]["heroTalent_npc_dota_hero_alchemist_2"] = {
                        item_name="heroTalent_npc_dota_hero_alchemist_2",
                        cost_class = TYPE_COST_Aurum,
                        bonus = 36500, --天数
                        cost=200,
                        goods_class = TYPE_BUY_ParticleEffect,  
                        discount = 50,
                    }

                
                    PlayerShop[4]["sound_wheel_bobo_index_34"] = {
                        item_name="sound_wheel_bobo_index_34",
                        cost_class = TYPE_COST_Aurum,
                        bonus = 36500, --天数
                        cost=200,
                        goods_class = TYPE_BUY_ParticleEffect,  
                        discount = 50,
                    }
                    PlayerShop[4]["sound_wheel_bobo_index_32"] = {
                        item_name="sound_wheel_bobo_index_32",
                        cost_class = TYPE_COST_Aurum,
                        bonus = 36500, --天数
                        cost=200,
                        goods_class = TYPE_BUY_ParticleEffect,  
                        discount = 50,
                    } 
                    PlayerShop[4]["sound_wheel_bobo_index_33"] = {
                        item_name="sound_wheel_bobo_index_33",
                        cost_class = TYPE_COST_Aurum,
                        bonus = 36500, --天数
                        cost=200,
                        goods_class = TYPE_BUY_ParticleEffect,  
                        discount = 50,
                    } 
                    PlayerShop[4]["sound_wheel_bobo_index_31"] = {
                        item_name="sound_wheel_bobo_index_31",
                        cost_class = TYPE_COST_Aurum,
                        bonus = 36500, --天数
                        cost=200,
                        goods_class = TYPE_BUY_ParticleEffect,  
                        discount = 50,
                    } 
                    PlayerShop[4]["sound_wheel_bobo_index_30"] = {
                        item_name="sound_wheel_bobo_index_30",
                        cost_class = TYPE_COST_Aurum,
                        bonus = 36500, --天数
                        cost=200,
                        goods_class = TYPE_BUY_ParticleEffect,  
                        discount = 50,
                    } 
                    PlayerShop[4]["sound_wheel_bobo_index_29"] = {
                        item_name="sound_wheel_bobo_index_29",
                        cost_class = TYPE_COST_Aurum,
                        bonus = 36500, --天数
                        cost=200,
                        goods_class = TYPE_BUY_ParticleEffect,  
                        discount = 50,
                    } 

                    
                end
               

               

    
                Timers:CreateTimer(5, function()
                    CustomGameEventManager:Send_ServerToAllClients( "SetBlackMarket", { list=PlayerShop})
                    print("update market")
                    return 15
                end)
                
            else
                print("return failed because of the wrong code")
            end




            
       else

            -- print("get black market4")

           print("Server return with error", res.StatusCode, res.Body)
            Timers:CreateTimer(1, function()
                self:GetBlackMarket(PlayerShop)
            end)
        --    GameRules:SendCustomMessage("DOTA_CUSTOM_Upgradefailed", DOTA_TEAM_GOODGUYS, nPlayerID) --技能升级失败的提示
        --    CustomGameEventManager:Send_ServerToPlayer(player, "UpgradeSpellFailed_feedback", {})
       end

    end)

end 


--获取每周免费技能
function player_database:GetFreeSpell()
    -- local player = PlayerResource:GetPlayer(nPlayerID) 


    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."weeklyFreeSpells/get")
    local encoded = '{"token":"'.._G.GAME_GLOBAL_KEY..'"   }'
    req:SetHTTPRequestRawPostBody("application/json",encoded)  


    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            if not res_table then
                Timers:CreateTimer(1, function()
                    player_database:GetFreeSpell()
                end)
                return
            end
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                --检验成功
                -- --设置黑市列表
                local list= res_table["weeklyFreeSpellsResultList"]
                local freeSpellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.freeSpellMap
                for _, value in pairs(list) do
                    freeSpellMap[value.spellname] = true
                end
            else
                print("return failed because of the wrong code")
            end




            
       else
           print("获取周免 error", res.StatusCode, res.Body)
           
           Timers:CreateTimer(1, function()
                player_database:GetFreeSpell()
            end)
       end

    end)

end 

--购买技能
function player_database:Buy_New_Spell_with_steamID(nPlayerID,encoded,cost_class,later_gold,spellname)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
   
    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            -- PrintTable(res.Body)

            

            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
            if cost_class==1 then --金币
                spellmap.playerinfo.gold = later_gold  --金币
                
            elseif cost_class==2 then
                spellmap.playerinfo.platinum = later_gold --白金
            end

            
            spellmap.spells[spellname]=1  --修改经验
            _G.GAME_CAN_BUY[nPlayerID] = true

            local player = PlayerResource:GetPlayer(nPlayerID) 
            Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
            EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
            CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新


            
       else
           print("Server return with error", res.StatusCode, res.Body)
           _G.GAME_CAN_BUY[nPlayerID] = true
           self:BuySpellFailed(nPlayerID)  --信息更新失败反馈

           
       end

    end)

end

function player_database:BuySpellFailed(nPlayerID)
    local player = PlayerResource:GetPlayer(nPlayerID) 
    Notifications:Top(nPlayerID, { text = "#buy_failed_BuySpellsFailed", duration = 4, style = { color = "red" } })
    EmitSoundOnClient("General.Cancel", player)
    -- GameRules:SendCustomMessage("DOTA_CUSTOM_BuySpellsFailed", 1, nPlayerID)

end


--购买特权物品
function player_database:BuyPrivilege_with_steamID(nPlayerID,encoded,cost_class,later_gold,target)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."trading/buyPrivilege")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    req:SetHTTPRequestRawPostBody("application/json",encoded)     
   
    req:Send(function(res)
        if res.StatusCode == 200 then

            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- print("通过")
                local info = res_table["privilegeRecord"]["endDate"]

            
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                -- print("nPlayerID=="..nPlayerID)
                if cost_class==1 then --金币
                    spellmap.playerinfo.gold = later_gold  --金币
                    
                elseif cost_class==2 then
                    spellmap.playerinfo.platinum = later_gold --白金
                end
    
                --更新到特权表里
                spellmap.vip[target] ={
                    endday = info
                }
    
                local player = PlayerResource:GetPlayer(nPlayerID) 
                Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                _G.GAME_CAN_BUY[nPlayerID] = true
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新

            else
                print("return failed because of the wrong code")
            end





            -- print("[STATS] Received "..res.Body)

            -- local res_table = JSON:decode(res.Body)
 
            -- local info = res_table["endDate"]

            
            -- local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
            -- print("nPlayerID=="..nPlayerID)
            -- if cost_class==1 then --金币
            --     spellmap.playerinfo.gold = later_gold  --金币
                
            -- elseif cost_class==2 then
            --     spellmap.playerinfo.platinum = later_gold --白金
            -- end

            -- --更新到特权表里
            -- spellmap.vip[target] ={
            --     endday = info
            -- }

            -- local player = PlayerResource:GetPlayer(nPlayerID) 
            -- Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
            -- EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
            -- _G.GAME_CAN_BUY[nPlayerID] = true
            -- CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新
            
       else
           print("Server return with error", res.StatusCode, res.Body)
           _G.GAME_CAN_BUY[nPlayerID] = true
        --    _G.GAME_CAN_BUY[nPlayerID] = true
        --    self:BuySpellFailed(nPlayerID)  --信息更新失败反馈

           
       end

    end)

end




-- 新版置换货币
function player_database:Currency_Exchange_with_steamID__New(nPlayerID,newData)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlementAdd")
    -- print("encoded=",encoded)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local encoded = json.encode(newData)
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
   
    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            -- PrintTable(res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
               
    
                spellmap.playerinfo.gold = spellmap.playerinfo.gold +  newData.playerInfo.gold
                spellmap.playerinfo.platinum = spellmap.playerinfo.platinum +  newData.playerInfo.platinum
                spellmap.playerinfo.reliableExp = spellmap.playerinfo.reliableExp +  newData.playerInfo.reliableExp
     
    
                local player = PlayerResource:GetPlayer(nPlayerID) 
                Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新
                _G.GAME_CAN_BUY[nPlayerID] = true

            else
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
           _G.GAME_CAN_BUY[nPlayerID] = true
           self:BuySpellFailed(nPlayerID)  --信息更新失败反馈

           
       end

    end)

end



--更新玩家数据（购买白金）
function player_database:login_with_steamID_buy_platinum(nPlayerID,spellMap)
    --login
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))

    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/login")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- req:SetHTTPRequestHeaderValue("token", _G.GAME_GLOBAL_KEY)
    local newData = {}
    newData.steamId = steamID
    newData.token = _G.GAME_GLOBAL_KEY
    local encoded = json.encode(newData)
    local player = PlayerResource:GetPlayer(nPlayerID) 
    req:SetHTTPRequestRawPostBody("application/json",encoded)          
    req:Send(function(res)
        if res.StatusCode == 200 then
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                --检验成功
                local res_table = JSON:decode(res.Body)
                local playerinfo = res_table["playerInfo"]
                local count = playerinfo.platinum - spellMap[nPlayerID].playerinfo.platinum
                
                spellMap[nPlayerID].playerinfo.platinum = playerinfo.platinum or  0 --白金
                
                _G.GAME_CAN_BUY[nPlayerID] = true --修改为购买成功
                Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新

                customDataManager:ModifySingleCustomData_AndSendData(nPlayerID,"platinum_millionaire_1",count,nil)
            else
                print("return failed because of the wrong code")
            end

        else
            print("Server return with error", res.StatusCode, res.Body)
            GameRules:SendCustomMessage("DOTA_CUSTOM_LoginFailed", DOTA_TEAM_GOODGUYS, nPlayerID)
            Timers:CreateTimer(5, function()
                self:login_with_steamID_buy_platinum(nPlayerID,spellMap)  --再次尝试登录
            end)

        end
    end)
end


--删除数据
function player_database:delAllData()


    local steamID = tostring(PlayerResource:GetSteamID(0))
    -- local steamID ="qwer"
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/delAll")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    local newData = {}
    newData.steamId = steamID
    newData.token = _G.GAME_GLOBAL_KEY
    local encoded = json.encode(newData)

    -- local player = PlayerResource:GetPlayer(nPlayerID) 
    -- local req = CreateHTTPRequestScriptVM("POST", "http://120.79.201.57:3031/rpg/delAll")
    -- local steamID = tostring(PlayerResource:GetSteamID(0))
    -- req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local encoded = '{"steamId": "'..steamID..'"}'

    req:SetHTTPRequestRawPostBody("application/json",encoded)
    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)      
       else
           print("Server return with error", res.StatusCode, res.Body)

       end

    end)

end 






--用于购买技能
function player_database:UpdateUserData_with_steamID_BuySpell(nPlayerID,encoded,sMessage,playerinfo,newData)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlementAdd")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local player = PlayerResource:GetPlayer(nPlayerID) 
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    req:Send(function(res)

        -- PrintTable(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
     
            local res_table = JSON:decode(res.Body)
            -- print(res_table)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                local spellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
                -- spellMap[nPlayerID].playerinfo.reliableExp = newData.playerInfo.reliableExp or 0  --可靠经验
                -- spellMap[nPlayerID].playerinfo.platinum = newData.playerInfo.platinum or  0 --白金


                spellMap[nPlayerID].playerinfo.reliableExp =  spellMap[nPlayerID].playerinfo.reliableExp + (newData.playerInfo.reliableExp or 0)  --可靠经验
                spellMap[nPlayerID].playerinfo.platinum = spellMap[nPlayerID].playerinfo.platinum  + (newData.playerInfo.platinum or 0 ) --白金



                local playersSpells = newData.playerSpellsList
                if playersSpells then
                    for _, value in pairs(playersSpells) do
                        spellMap[nPlayerID].spells[value.spellName]=value.exp
                    end
                end
                CustomGameEventManager:Send_ServerToPlayer(player, "SetBonus", {sMessage=sMessage,playerinfo = playerinfo})  --给出奖励提示
                _G.GAME_CAN_BUY[nPlayerID] = true --修改为购买成功
                -- GameRules:SendCustomMessage("DOTA_CUSTOM_LoginSuccess", DOTA_TEAM_GOODGUYS, nPlayerID)
                Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_LoginSuccess_buySpell", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新
                
            else
                print("return failed because of the wrong code")
            end
            
       else
           print("Server return with error", res.StatusCode, res.Body)
        --    GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateFail_gift", DOTA_TEAM_GOODGUYS, nPlayerID)
            Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_Fail_buySpell", duration = 4, style = { color = "red" } })
            EmitSoundOnClient("Cancel", player)
            Timers:CreateTimer(2, function()
                self:UpdateUserData_with_steamID_BuySpell(nPlayerID,encoded,sMessage,playerinfo,newData)  --再次尝试更新
            end)
           
       end

    end)

end


-- 用于乱纪元结算时获取技能书
function player_database:UpdateUserData_with_steamID_ChaoticGainSpells(nPlayerID,encoded,sMessage,playerinfo,newData)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlementAdd")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    local player = PlayerResource:GetPlayer(nPlayerID) 
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    req:Send(function(res)

        -- PrintTable(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            -- print(res_table)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                local spellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
                -- spellMap[nPlayerID].playerinfo.reliableExp = newData.playerInfo.reliableExp or 0  --可靠经验
                -- spellMap[nPlayerID].playerinfo.platinum = newData.playerInfo.platinum or  0 --白金

                spellMap[nPlayerID].playerinfo.reliableExp =  spellMap[nPlayerID].playerinfo.reliableExp + (newData.playerInfo.reliableExp or 0)  --可靠经验
                -- 不需要消耗白金，也无需更新
                -- spellMap[nPlayerID].playerinfo.platinum = spellMap[nPlayerID].playerinfo.platinum  + (newData.playerInfo.platinum or 0 ) --白金

                local playersSpells = newData.playerSpellsList
                if playersSpells then
                    for _, value in pairs(playersSpells) do
                        spellMap[nPlayerID].spells[value.spellName]=value.exp
                    end
                end
                -- 因为是通关结算，并不需要购买成功的提示
                -- CustomGameEventManager:Send_ServerToPlayer(player, "SetBonus", {sMessage=sMessage,playerinfo = playerinfo})  --给出奖励提示

                -- 存疑：这是干嘛的？
                _G.GAME_CAN_BUY[nPlayerID] = true --修改为购买成功
                -- GameRules:SendCustomMessage("DOTA_CUSTOM_LoginSuccess", DOTA_TEAM_GOODGUYS, nPlayerID)

                -- 因为是通关结算，并不需要购买成功的提示，结算的音效可以保留
                -- Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_LoginSuccess_buySpell", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新
            else
                print("return failed because of the wrong code")
            end

       else
            print("Server return with error", res.StatusCode, res.Body)
            -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateFail_gift", DOTA_TEAM_GOODGUYS, nPlayerID)
            -- 给出失败提示并重新尝试更新
            Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_Fail_ChaoticSkillbooks_gain", duration = 4, style = { color = "red" } })
            EmitSoundOnClient("Cancel", player)
            Timers:CreateTimer(2, function()
                self:UpdateUserData_with_steamID_BuySpell(nPlayerID,encoded,sMessage,playerinfo,newData)  --再次尝试更新
            end)
           
       end

    end)

end


function player_database:CheckBonus_with_steamID(nPlayerID)
    --login
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))

    print("check bonus")
    
    -- local steamID ="qwer"
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."rewards/findAvailableRewards")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    local newData = {}
    -- newData.steamId = steamID
    newData.dota2Id = PlayerResource:GetSteamAccountID(nPlayerID)
    -- newData.dota2Id = 324420892
    newData.token = _G.GAME_GLOBAL_KEY
    local encoded = json.encode(newData)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap  --获取到数据表
    if not spellmap then
        return
    end
    if not  spellmap[nPlayerID] then
        return
    end

    -- print(encoded)

    req:SetHTTPRequestRawPostBody("application/json",encoded)          
    req:Send(function(res)
        if res.StatusCode == 200 then


            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]

            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                --检验成功
    
                local res_table = JSON:decode(res.Body)
                -- PrintTable(res_table)
                local rewardsIssueRecords = res_table["rewardsIssueRecords"]
     
               
       
                
                if rewardsIssueRecords then
                    for i, rewardsIssueRecord in pairs(rewardsIssueRecords) do
                        local name = rewardsIssueRecord.rewardIntroduce
                        local id = rewardsIssueRecord.id
                        local platinum = rewardsIssueRecord.platinum
                        local gold = rewardsIssueRecord.gold
                        local exp = rewardsIssueRecord.reliableExp
                        -- 由于ID是唯一的 这里使用ID作为索引
                        spellmap[nPlayerID].bonus[id] ={
                            bonusName = name,
                            bonusId = id,
                            bonusPlatinum = platinum,
                            bonusGold = gold,
                            bonusExp = exp,
                        }
    
                    end
                end
                -- PrintTable(spellmap,nil,nil)
                local player = PlayerResource:GetPlayer(nPlayerID)
                --反馈奖励表
                CustomGameEventManager:Send_ServerToPlayer(player, "GetPlayerBonusInfo_feedback", spellmap[nPlayerID].bonus)


                
            else
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
                print("return failed because of the wrong code")
            end

        else
            Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
            print("Server return with error", res.StatusCode, res.Body)
        end
    end)
end











-- 已废弃使用
--用于重新随机道具
function player_database:UpdateUserData_with_steamID_ReRollItems(nPlayerID,encoded,level,gold)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    req:SetHTTPRequestRawPostBody("application/json",encoded)     

    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- print("通过")
                _G.Game_Item_ReRoll_chance[nPlayerID] = _G.Game_Item_ReRoll_chance[nPlayerID] - 1
                BonusItems:SpawnBonusItems(nPlayerID,level)
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                spellmap.playerinfo.gold = gold  --可靠经验

               
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_ReRollItemDone", duration = 2, style = { color = "white" } })
                -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateSuccess_gift", DOTA_TEAM_GOODGUYS, nPlayerID)

            else
                -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateFail_gift", DOTA_TEAM_GOODGUYS, nPlayerID)
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_ReRollItemFail2", duration = 2, style = { color = "red" } })
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "showBossRewards", { item =  _G.Game_BONUS_ITEMS[nPlayerID].item,level = _G.Game_BONUS_ITEMS[nPlayerID].level,chance = _G.Game_Item_ReRoll_chance[nPlayerID]})
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
           Notifications:Top(nPlayerID, { text = "#DOTA_HUD_ReRollItemFail", duration = 2, style = { color = "red" } })
           CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "showBossRewards", { item =  _G.Game_BONUS_ITEMS[nPlayerID].item,level = _G.Game_BONUS_ITEMS[nPlayerID].level,chance = _G.Game_Item_ReRoll_chance[nPlayerID]})

           
       end

    end)

end






-- 已废弃使用
--用于重新随机苦难
function player_database:UpdateUserData_with_steamID_ReRollChallenge(nPlayerID,encoded,gold)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    req:SetHTTPRequestRawPostBody("application/json",encoded)     

    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- print("通过")
                _G.Game_Challenge_ReRoll_chance[nPlayerID] = _G.Game_Challenge_ReRoll_chance[nPlayerID] - 1
                ReSpawnChallenge(nPlayerID)
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_ReRollItemDone", duration = 2, style = { color = "white" } })
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                spellmap.playerinfo.gold = gold  --可靠经验
                
                
                local player = PlayerResource:GetPlayer(nPlayerID) 
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                
                
                -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateSuccess_gift", DOTA_TEAM_GOODGUYS, nPlayerID)

            else
                -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateFail_gift", DOTA_TEAM_GOODGUYS, nPlayerID)
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_ReRollItemFail2", duration = 2, style = { color = "red" } })
                challenge:reShowChallenge(nPlayerID)
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
           Notifications:Top(nPlayerID, { text = "#DOTA_HUD_ReRollItemFail", duration = 2, style = { color = "red" } })
           challenge:reShowChallenge(nPlayerID)

           
       end

    end)

end



function player_database:GetReward_with_steamID(nPlayerID,id)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."rewards/receiveRewardsByIdAndDota2Ids")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
  
    local newData = {}
    -- newData.steamId = steamID
    newData.dota2Id = PlayerResource:GetSteamAccountID(nPlayerID)
    -- newData.dota2Id = PlayerResource:GetSteamAccountID(nPlayerID)
    newData.token = _G.GAME_GLOBAL_KEY
    newData.ids = {id}
    local encoded = json.encode(newData)
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            local playerinfo = res_table["playerInfo"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- print("通过")
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap  --获取到数据表
                spellmap[nPlayerID].playerinfo.reliableExp = playerinfo.reliableExp or 0  --可靠经验
                spellmap[nPlayerID].playerinfo.gold = playerinfo.gold or 0  --金币
                spellmap[nPlayerID].playerinfo.platinum = playerinfo.platinum or  0 --白金
                -- _G.Game_Challenge_ReRoll_chance[nPlayerID] = _G.Game_Challenge_ReRoll_chance[nPlayerID] - 1
                -- local player = PlayerResource:GetPlayer(nPlayerID) 
                local player = PlayerResource:GetPlayer(nPlayerID)
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                game_event:OnPlayerReceiveBonusReward(nPlayerID,id)
                spellmap[nPlayerID].bonus[tonumber(id)] = nil
                player_database:CheckBonus_with_steamID(nPlayerID)
                -- ReSpawnChallenge(nPlayerID)
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_Get_Bonus_success", duration = 2, style = { color = "white" } })
                -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateSuccess_gift", DOTA_TEAM_GOODGUYS, nPlayerID)

            else
                -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateFail_gift", DOTA_TEAM_GOODGUYS, nPlayerID)
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
                -- challenge:reShowChallenge(nPlayerID)
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
           Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
        --    challenge:reShowChallenge(nPlayerID)

           
       end

    end)

end









-- Reroll用  失败会不断请求 但是即使失败也无所谓 
-- 仅用于小数值消耗 如果服务器卡了等太久会出问题 因此先本地扣 再去不断请求  
--由于现在是增量改变 因此无所谓
function player_database:UpdateUserData_with_steamID_ReRoll(encoded)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlementAdd")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    req:Send(function(res)
        if res.StatusCode == 200 then
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("后端成功扣除了")
            else
                print("return failed because of the wrong code")
            end
       else
           print("Server return with error", res.StatusCode, res.Body)
           Timers:CreateTimer(5, function()
            self:UpdateUserData_with_steamID_ReRoll(encoded)
        end)
       end

    end)

end




















function player_database:UpdateHeroInfo()
    if not self.playerSpellsData then
        self.playerSpellsData = {}
    end
    if not self.playerItemsData then
        self.playerItemsData = {}
    end
    if not self.playerSpellCountRecord then
        self.playerSpellCountRecord = {}
    end
    if not self.playerItemCountRecord then
        self.playerItemCountRecord = {}
    end

    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        local spellCount = 0
        local itemCount = 0
        
        local spellList = {}
        --获取技能
        for i=1, 11 do  
            local Ability = hero:GetAbilityByIndex(i)
            if Ability  and not Ability.subSpell then
                spellCount = spellCount + 1
                local spellName = Ability:GetAbilityName()
                if spellName~="unit_state" then
                    if string.sub(spellName,1,9)=="Advanced_" then --如果是高阶技能那么获取高阶等级
                        spellLevel = Ability.advanced_level
                    end
                    local spellInfo = {
                        n = spellName,
                        l = spellLevel,
                    }
                    table.insert(spellList,spellInfo)  --插入表中
                end
                local spellLevel = Ability:GetLevel()
               
            end
        end
        if not self.playerSpellCountRecord[hero] then
            self.playerSpellCountRecord[hero] = 0
        end
        -- 如果技能数量减少了2个1以上 则不更新
        if (self.playerSpellCountRecord[hero]-2)<=spellCount then
            -- 说明可以刷新数据
            self.playerSpellsData[hero] = "'"..json.encode(spellList).."'"
            self.playerSpellCountRecord[hero] = spellCount
            print("技能数据更新")
        else
            print("玩家可能在删除技能数据")
        end
       

        --技能获取完毕
        local itemsList = {}
        --获取道具
        for i=0, 8 do
            local Ability = hero:GetItemInSlot(i)
            if Ability then
                itemCount = itemCount + 1
                local spellName = Ability:GetAbilityName()
                table.insert(itemsList,spellName)  --插入表中
            end
        end
        if not self.playerItemCountRecord[hero] then
            self.playerItemCountRecord[hero] = 0
        end
        -- 如果技能数量减少了2个1以上 则不更新
        if (self.playerItemCountRecord[hero]-2)<=itemCount then
            -- 说明可以刷新数据
            self.playerItemsData[hero] ="'"..json.encode(itemsList).."'"
            self.playerItemCountRecord[hero] = itemCount
            print("道具数据更新")
        else
            print("玩家可能在删除道具数据")
        end
        -- self.playerItemsData[hero] ="'"..json.encode(itemsList).."'"
    end
end





---------比赛成绩

--竞速类型
function player_database:SendSpeedContestInfo(time)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."matchRecord/saveMatchRecord")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")


    local teamType = 1  --竞速
    local hide = 0
    if _G.Game_Hide_contest_info then
        hide = 1
    end
    local newData = {}
    newData.token = _G.GAME_GLOBAL_KEY
    newData.individualMatchRecords = {}
    local heroes = GetAllRealHeroes()
    local teamNOP = #heroes                                         --队伍人数
    local passTime = time +_G.GAME_pre_exDieTime*40                       --使用的时间
    for  _, hero in pairs(heroes) do
        local palyerInfo = {}
        local playerID = hero:GetPlayerOwnerID()                     --玩家ID
        palyerInfo.dota2Id = PlayerResource:GetSteamAccountID(playerID)     --DOTA2 ID
        -- palyerInfo.dota2Id = RandomInt(564151, 475451210)    --测试DOTA2 ID
        palyerInfo.teamType = teamType
        palyerInfo.teamNOP = teamNOP     
        palyerInfo.passTime = passTime
        palyerInfo.isHidden = hide
          --获取技能
        local spellList = {}
        if self.playerSpellsData and self.playerSpellsData[hero] then
            palyerInfo.skill = self.playerSpellsData[hero]

        else
            for i=1, 11 do  
                local Ability = hero:GetAbilityByIndex(i)
                if Ability  and not Ability.subSpell then
                    local spellName = Ability:GetAbilityName()
                    local spellLevel = Ability:GetLevel()
                    if spellName~="unit_state" then
                        if string.sub(spellName,1,9)=="Advanced_" then --如果是高阶技能那么获取高阶等级
                            spellLevel = Ability.advanced_level
                        end
                        local spellInfo = {
                            n = spellName,
                            l = spellLevel,
                        }
                        table.insert(spellList,spellInfo)  --插入表中
                    end
                end
            end
            palyerInfo.skill ="'"..json.encode(spellList).."'"
        end
      



        
        --------------------------------------------------
        --技能获取完毕
        local itemsList = {}
        --获取道具
        if self.playerItemsData and self.playerItemsData[hero] then
            palyerInfo.items = self.playerItemsData[hero]

        else
            for i=0, 8 do
                local Ability = hero:GetItemInSlot(i)
               if Ability then
                    local spellName = Ability:GetAbilityName()
                    table.insert(itemsList,spellName)  --插入表中
               end
            end
            palyerInfo.items ="'"..json.encode(itemsList).."'"
        end

        palyerInfo.hero = hero:GetLevel()..","..string.sub(hero:GetUnitName(),15,50)
        palyerInfo.occupation = "0"
        table.insert(newData.individualMatchRecords,palyerInfo)
    end
   

    local encoded = json.encode(newData)
    -- print(encoded)
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]

            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("通过")
                _G.GAME_Contest_send = true
            else
                -- Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
           Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_Fail_send_contestInfo", duration = 4, style = { color = "red" } })
           EmitSoundOnClient("Cancel", player)
            Timers:CreateTimer(5, function()
                self:SendSpeedContestInfo(time)
            end)
           
       end

    end)

end



--无尽类型
function player_database:SendEndLessContestInfo(count)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."matchRecord/saveMatchRecord")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")


    local teamType = 2  --无尽
    local hide = 0
    if _G.Game_Hide_contest_info then
        hide = 1
    end
    local newData = {}
    newData.token = _G.GAME_GLOBAL_KEY
    newData.individualMatchRecords = {}
    local heroes = GetAllRealHeroes()
    local teamNOP = #heroes                                         --队伍人数
    -- local passTime = GameRules:GetGameTime()                        --使用的时间
    local passRound = math.max(count -_G.GAME_pre_exDieTime*5 ,0)                  --击杀的数量
    for  _, hero in pairs(heroes) do
        local palyerInfo = {}
        local playerID = hero:GetPlayerOwnerID()                     --玩家ID
        palyerInfo.dota2Id = PlayerResource:GetSteamAccountID(playerID)     --DOTA2 ID
        -- palyerInfo.dota2Id = RandomInt(564151, 47545120)    --测试DOTA2 ID
        palyerInfo.teamType = teamType
        palyerInfo.teamNOP = teamNOP     
        -- palyerInfo.passTime = passTime
        palyerInfo.passRound = passRound
        palyerInfo.isHidden = hide
        
        local spellList = {}
        --获取技能
        if self.playerSpellsData and self.playerSpellsData[hero] then
            palyerInfo.skill = self.playerSpellsData[hero]


        else
            for i=1, 11 do  
                local Ability = hero:GetAbilityByIndex(i)
                if Ability  and not Ability.subSpell then
                    local spellName = Ability:GetAbilityName()
                    local spellLevel = Ability:GetLevel()
                    if spellName~="unit_state" then
                        if string.sub(spellName,1,9)=="Advanced_" then --如果是高阶技能那么获取高阶等级
                            spellLevel = Ability.advanced_level
                        end
                        local spellInfo = {
                            n = spellName,
                            l = spellLevel,
                        }
                        table.insert(spellList,spellInfo)  --插入表中
                    end
                end
            end
            palyerInfo.skill ="'"..json.encode(spellList).."'"
        end
        -- for i=1, 13 do  
        --     local Ability = hero:GetAbilityByIndex(i)

        --     if Ability and not Ability.subSpell  then
        --         local spellName = Ability:GetAbilityName()
        --         local spellLevel = Ability:GetLevel()
        --         if string.sub(spellName,1,9)=="Advanced_" then --如果是高阶技能那么获取高阶等级
        --             spellLevel = Ability.advanced_level
        --         end
        --         local spellInfo = {
        --             n = spellName,
        --             l = spellLevel,
        --         }
        --         table.insert(spellList,spellInfo)  --插入表中
        --     end
        -- end
        -- palyerInfo.skill ="'"..json.encode(spellList).."'"
        --------------------------------------------------
        --技能获取完毕
        local itemsList = {}
        --获取道具
        if self.playerItemsData and self.playerItemsData[hero] then
            palyerInfo.items = self.playerItemsData[hero]

        else
            for i=0, 8 do
                local Ability = hero:GetItemInSlot(i)
               if Ability then
                    local spellName = Ability:GetAbilityName()
                    table.insert(itemsList,spellName)  --插入表中
               end
            end
            palyerInfo.items ="'"..json.encode(itemsList).."'"
        end
        -- for i=0, 5 do
        --     local Ability = hero:GetItemInSlot(i)
        --    if Ability then
        --         local spellName = Ability:GetAbilityName()
        --         table.insert(itemsList,spellName)  --插入表中
        --    end
        -- end
        -- palyerInfo.items ="'"..json.encode(itemsList).."'"

        palyerInfo.hero = hero:GetLevel()..","..string.sub(hero:GetUnitName(),15,50)
        palyerInfo.occupation = "0"
        table.insert(newData.individualMatchRecords,palyerInfo)
    end

    local encoded = json.encode(newData)
    -- print(encoded)
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]

            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("通过")
                _G.GAME_Contest_send = true
            else
                -- Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
        --    Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
        Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_Fail_send_contestInfo", duration = 4, style = { color = "red" } })
        EmitSoundOnClient("Cancel", player)
         Timers:CreateTimer(5, function()
             self:SendEndLessContestInfo(count)
         end)

           
       end

    end)

end








--获取比赛记录
function player_database:GetContestInfo()
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."matchRecord/findMatchRecord")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")


  
    local newData = {}
    newData.token = _G.GAME_GLOBAL_KEY
    newData.dota2Ids = {}
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do

        local playerID = hero:GetPlayerOwnerID()                     --玩家ID
        table.insert(newData.dota2Ids,PlayerResource:GetSteamAccountID(playerID))
    end
    -- table.insert(newData.dota2Ids,"184828736")
    local encoded = json.encode(newData)
    -- print(encoded)
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            

            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("通过")
                
                res_table = res_table["resMap"]
                
                -- PrintTable(res_table)
                self.gameTeamData = {}  --特定队伍的游戏数据在这里创建
                self.gameInfo = {
                    playerinfo = {
                  
                    },
                    speedInfo = {

                    },
                    endLessInfo = {

                    },
                }
                --遍历数据处理
                for key, value in pairs(res_table) do
                    local char = string.sub(key,1,1)
                    -- print(key)
                    -- print(value)
                    if char=="E" then  --无尽排行数据
                        local index = tonumber(string.sub(key,2,2))
                        -- print("index"..index)
                        self.gameInfo.endLessInfo[index] = value
                        -- table.insert(self.gameInfo.endLessInfo,index,value)
                    elseif char=="S" then  --竞速排行数据
                        local index = tonumber(string.sub(key,2,2))
                        -- print("index"..index)
                        self.gameInfo.speedInfo[index] = value
                        -- table.insert(self.gameInfo.speedInfo,index,value)
                    else 
                        table.insert(self.gameInfo.playerinfo,value)
                    end
                end
                -- PrintTable(self.gameInfo.speedInfo)
                --数据处理完毕后将这个数据扔给js即可
                --由于是有人获取排行榜就获取所有人的数据 需要发送到所有客户端
                CustomGameEventManager:Send_ServerToAllClients("GetGameInfoFeedBack", {self.gameInfo})
        

            else
                -- Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
        --    Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
 

           
       end

    end)

end





--获取特定队伍的详细游戏局数据
function player_database:GetTeamDataByID(nPlayerID,teamID)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."matchRecord/findByTeamId")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")


  
    local newData = {}
    newData.token = _G.GAME_GLOBAL_KEY
    newData.teamId = teamID
    local encoded = json.encode(newData)

    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]

            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- print("通过")
                -- PrintTable(res_table)
                local data = res_table["individualMatchRecords"]
                -- PrintTable(data)
                --记录数据
                -- self.gameTeamData[teamID] = res_table["individualMatchRecords"]
                self.gameTeamData[teamID] = {}
                local isHiden = false
                for _, value in ipairs(data) do
                    local hide = value.isHidden or 0
                    if not IsInToolsMode() then
                        if hide==1 or hide == "1" then
                            isHiden = true
                            break
                        end
                    end
                   
                    local newTable = {}
                    newTable.dota2ID = value.dota2ID
                    newTable.hero = value.hero
    
                    local skill = string.gsub(value.skill, "'", "")   --把单引号杀死
                    local item = string.gsub(value.items, "'", "")   --把单引号杀死
                    -- newTable.items = JSON:decode(value.items)
                    -- newTable.skill = JSON:decode(value.skill)
       
                    newTable.items = JSON:decode(item)
                    newTable.skill = JSON:decode(skill)
  
                    newTable.rank = value.rank
                    newTable.passTime = value.passTime
                    newTable.teamID = value.teamID
                    newTable.teamNOP = value.teamNOP
                    newTable.teamName = value.teamName
                    newTable.teamType = value.teamType
                    newTable.updateTime = value.updateTime
                    table.insert(self.gameTeamData[teamID],newTable)
                end
                if isHiden then
                    self.gameTeamData[teamID] = nil
                    _G.Game_GettTeamData[teamID] =nil
                    SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_CANT_SEE_INFO","General.Cancel")
                    return
                end
                --传递数据
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "GetTeamDataFeedBack", { self.gameTeamData[teamID]})

            else
                -- Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
        --    Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
 

           
       end

    end)
end


-- if __debug_trace_back_original__ ==nil then
--     __debug_trace_back_original__ = debug.traceback
-- end
-- local error_messageList = {}
-- debug.traceback = function (thread,message,level)
--     local trace 
--     if thread==nil and message ==nil and level ==nil then
--         trace = __debug_trace_back_original__()
--     else
--         trace = __debug_trace_back_original__(thread,message,level)
--     end

--     -- error_messageList
--     local data = tostring(trace)
--     if IsInTable(data,error_messageList) then
--         print("重复数据")
--         return trace
--     end
--     table.insert(error_messageList,data)



--     -- GameRules:SendCustomMessage(tostring(trace), 0, 0)
--     -- print("aaa")
--     local req = CreateHTTPRequestScriptVM("POST", _G.GAME_server_address.."error/saveErrorData")
--     req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
--     local newData = {}
--     newData.token = _G.GAME_GLOBAL_KEY
--     newData.errorMsg = tostring(trace)
--     local encoded = json.encode(newData)

--     req:SetHTTPRequestRawPostBody("application/json",encoded) 
--     req:Send(function(res) end)
--     return trace
-- end




function player_database:SendCustomData(a,b)
    if not self.customDataRecord then
        self.customDataRecord = {}
    end
    if not self.customDataRecord[a] then
        self.customDataRecord[a] = {}
    end
    if not self.customDataRecord[a][b] then
        self.customDataRecord[a][b] = true
        print("next")
    else
        -- print("重复信息")
        return
    end
    print("send")
    local customData = {
        modifier = a,
        name = b,
    }
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."error/saveErrorData")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    local newData = {}
    newData.token = _G.GAME_GLOBAL_KEY
    newData.errorMsg =json.encode(customData)
    local encoded = json.encode(newData)
    print(encoded)
    req:SetHTTPRequestRawPostBody("application/json",encoded) 

    req:Send(function(res)
        print("receive")
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            -- PrintTable(res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
              

            else
                print("return failed because of the wrong code")
            end



            
       else
           print("Server return with error", res.StatusCode, res.Body)
       end

    end)
end



--金币锻造原石
--为了防止中途获取新原石导致数量错误，先扣除后再发送，如果失败了加回去
function player_database:SendGetAghanimCore(nPlayerID,encoded,unit,coreID,goldCost)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")

    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local player = PlayerResource:GetPlayer(nPlayerID)
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
    spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID]-1
    unit:ModifyGoldFiltered(-goldCost,true,DOTA_ModifyGold_PurchaseItem  ) 
    _G.CORE_current_count = _G.CORE_current_count + 1 
    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            -- PrintTable(res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                local gameEvent = {}
                if coreID== "core1" then
                    unit:AddItemByName("item_hd_the_first_core")
                    gameEvent["ability_name"] = "item_hd_the_first_core"
                elseif coreID== "core2" then
                    unit:AddItemByName("item_hd_the_second_core")
                    gameEvent["ability_name"] = "item_hd_the_second_core"
                else
                    unit:AddItemByName("item_hd_the_third_core")
                    gameEvent["ability_name"] = "item_hd_the_third_core"
                end
              
                gameEvent["player_id"] = nPlayerID
                gameEvent["teamnumber"] = -1
                
                gameEvent["message"] = "#DOTA_HUD_PLAYER_GET_CORE"
                FireGameEvent( "dota_combat_event_message", gameEvent )
                -- EmitSoundOnClient("DOTAMusic_PLUS_ONE", PlayerResource:GetPlayer(nPlayerID))
                EmitSoundOnClient("DOTAMusic_PLUS_ONE2", player)
                CustomGameEventManager:Send_ServerToPlayer(player, "GetCoreFeedBack", {}) --强制刷新
                _G.GAME_CAN_BUY[nPlayerID] = true

            else
                --没能获取成功加回去
                _G.CORE_current_count = _G.CORE_current_count - 1
                unit:ModifyGoldFiltered(goldCost,true,DOTA_ModifyGold_PurchaseItem ) 
                spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID] + 1
                print("return failed because of the wrong code")
            end



            
       else
            --没能获取成功加回去
            _G.CORE_current_count = _G.CORE_current_count - 1
            unit:ModifyGoldFiltered(goldCost,true,DOTA_ModifyGold_PurchaseItem ) 
            spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID] + 1
           print("Server return with error", res.StatusCode, res.Body)
           _G.GAME_CAN_BUY[nPlayerID] = true
            --    self:BuySpellFailed(nPlayerID)  --信息更新失败反馈
            Notifications:Top(nPlayerID, { text = "#Market_Core_buy_failed_server", duration = 2, style = { color = "red" } })

           
       end

    end)

end




-- stinger_loot
BonusMusitc={
    "Loot_Drop_Sfx",
    "Loot_Drop_Stinger_Uncommon",
    "Loot_Drop_Stinger_Rare",
    "ui_aghs_blessing_purchase",
    "Loot_Drop_Stinger_Legendary",
    "Loot_Drop_Stinger_Ancient",
    "Loot_Drop_Stinger_Immortal",
}

function player_database:SendGetAghanimCoreBonus(nPlayerID,encoded,coreID,count)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")

    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    -- local player = PlayerResource:GetPlayer(nPlayerID)
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
    -- print(coreID)
    spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID]+count

    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            -- PrintTable(res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                local gameEvent = {}
                if coreID== "core1" then
 
                    gameEvent["ability_name"] = "item_hd_the_first_core"
                elseif coreID== "core2" then
                    gameEvent["ability_name"] = "item_hd_the_second_core"
                else
    
                    gameEvent["ability_name"] = "item_hd_the_third_core"
                end
            
                gameEvent["player_id"] = nPlayerID
                gameEvent["teamnumber"] = -1
                gameEvent["locstring_value"] = tostring(count)
                gameEvent["message"] = "#DOTA_HUD_PLAYER_GET_CORE_BONUS"..RandomInt(1, 10)

                local musitc_index = RandomInt(1, #BonusMusitc)
                print("idnex="..musitc_index)
                EmitGlobalSound(BonusMusitc[musitc_index])
                FireGameEvent( "dota_combat_event_message", gameEvent )
                -- CustomGameEventManager:Send_ServerToPlayer(player, "GetCoreFeedBack", {}) --强制刷新
            else
                --没能获取成功减回去
                spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID]  - count
                print("return failed because of the wrong code")
            end



            
       else
            --没能获取成功减回去
            spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID] - count
           print("Server return with error", res.StatusCode, res.Body)
           Timers:CreateTimer(5, function()
            self:SendGetAghanimCoreBonus(nPlayerID,encoded,coreID,count)
        end)
        
       end

    end)

end


function player_database:BuyParticleEffect_with_steamID(nPlayerID,encoded,later_platinum,later_gold)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."trading/buySpecialEffect")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    req:SetHTTPRequestRawPostBody("application/json",encoded)     
   
    req:Send(function(res)
        if res.StatusCode == 200 then

            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- print("通过")
                local info = res_table["specialEffectRecord"]

            
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                if later_platinum then
                    spellmap.playerinfo.platinum = later_platinum --白金
                end
                if later_gold then
                    spellmap.playerinfo.gold = later_gold --白金
                end
                local targetPos = spellmap.Particle
                -- local type = info.effectType
                local name = info.effectName
                local pos = particleManager:GetTablePos(spellmap,name)
                -- if string.sub(name,1,7)=="ability" then --技能类型
                --     targetPos = targetPos.SpellParticle
                --     local abilityName = particleManager:GetSpellParticleSpellName(name)
                --     --为空创建默认
                --     if not targetPos[abilityName] then
                --         targetPos[abilityName]  ={
                --             on_Particle =  "ability_particle_0",
                --             ParticleSet = {}
                --         }
                --     end
                --     targetPos = targetPos[abilityName].ParticleSet
                --     print("放技能里")
                -- elseif type==2001 then
                --     targetPos = targetPos.Attach.ParticleSet
                --     print("放Attach里")
                -- elseif type==2002 then
                --     targetPos = targetPos.MeleeAttack.ParticleSet
                --     print("放MeleeAttack里")
                -- elseif type==2003 then
                --     targetPos = targetPos.RangeAttack.ParticleSet
                --     print("放RangeAttack里")
                -- end
 
                pos.ParticleSet[name] = info.endDate
                -- PrintTable(targetPos)
              
                local player = PlayerResource:GetPlayer(nPlayerID) 
                Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                _G.GAME_CAN_BUY[nPlayerID] = true
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新

            else
                print("return failed because of the wrong code")
            end

            
       else
           print("Server return with error", res.StatusCode, res.Body)
           _G.GAME_CAN_BUY[nPlayerID] = true
        --    _G.GAME_CAN_BUY[nPlayerID] = true
        --    self:BuySpellFailed(nPlayerID)  --信息更新失败反馈

           
       end

    end)

end





function player_database:PlayerBuyCore(nPlayerID,encoded,coreID,count,later_platinum,later_exp)  
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/settlement")

    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    -- local player = PlayerResource:GetPlayer(nPlayerID)
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
    print(coreID)
    spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID]+count

    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            -- PrintTable(res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                spellmap.playerinfo.platinum = later_platinum  --白金
                spellmap.playerinfo.reliableExp = later_exp  --可靠经验
                local player = PlayerResource:GetPlayer(nPlayerID) 
                Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新货币面板
                _G.GAME_CAN_BUY[nPlayerID] = true

                CustomGameEventManager:Send_ServerToPlayer(player, "GetCoreFeedBack", {}) --强制刷新原石面板
                local gameEvent = {}
                if coreID== "core1" then
                    gameEvent["ability_name"] = "item_hd_the_first_core"
                elseif coreID== "core2" then
                    gameEvent["ability_name"] = "item_hd_the_second_core"
                else
    
                    gameEvent["ability_name"] = "item_hd_the_third_core"
                end
                gameEvent["player_id"] = nPlayerID
                gameEvent["teamnumber"] = -1
                gameEvent["locstring_value"] = tostring(count)
                gameEvent["message"] = "#DOTA_HUD_PLAYER_GET_CORE_BONUS"..RandomInt(1, 10)
                FireGameEvent( "dota_combat_event_message", gameEvent )
 
            else
                --没能获取成功减回去
                spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID]  - count
                print("return failed because of the wrong code")
            end



            
       else
            --没能获取成功减回去
            spellmap.playerinfo[coreID] = spellmap.playerinfo[coreID] - count
           print("Server return with error", res.StatusCode, res.Body)
           _G.GAME_CAN_BUY[nPlayerID] = true
           self:BuySpellFailed(nPlayerID)  --信息更新失败反馈
        
       end

    end)

end


function player_database:RefreshEffectMarket()
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."specialEffect/refresh")
    local encoded = '{"token":"'.._G.GAME_GLOBAL_KEY..'"   }'
    req:SetHTTPRequestRawPostBody("application/json",encoded)  
    req:Send(function(res)
        -- PrintTable(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("ok")
            else
                print("return failed because of the wrong code")
            end
       else
           print("Server return with error", res.StatusCode, res.Body)

       end

    end)

end
function player_database:RefreshBlackMarket()
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."blackMarket/refresh")
    local encoded = '{"token":"'.._G.GAME_GLOBAL_KEY..'"   }'
    req:SetHTTPRequestRawPostBody("application/json",encoded)  
    req:Send(function(res)
        -- PrintTable(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("ok")
            else
                print("return failed because of the wrong code")
            end
       else
           print("Server return with error", res.StatusCode, res.Body)

       end

    end)

end

function player_database:UpdateAllPlayerParticleState()

    local targetTable = particleManager.particleChange
    local should_send = false
    local newData = {
        token = _G.GAME_GLOBAL_KEY,
        specialEffectRecordList = {},
    }



    for key, value in pairs(targetTable) do
        should_send = true
        local nPlayerID = key
        local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        for _, value_inside in pairs(value) do
            table.insert(newData.specialEffectRecordList,
            {
                steamId = steamID,
                effectType = value_inside.type,
                effectName= value_inside.name,
            })
        end

    end

    -- PrintTable(newData)
    
    if should_send then
        local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."specialEffect/useEffect")
        req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
        local encoded = json.encode(newData)
        print(encoded)
        req:SetHTTPRequestRawPostBody("application/json",encoded)     
    
        req:Send(function(res)
            if res.StatusCode == 200 then

                print("success")
                --do nothing
                
            else
                print("Server return with error", res.StatusCode, res.Body)  
            end

        end)
        particleManager.particleChange = {}
    end






end

function player_database:sendEffect(top,name)  
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."specialEffect/sendEffect")
    -- local effectName = "attach_particle_103"
    local newData ={
        token = _G.GAME_GLOBAL_KEY,

        addDay = 36500,
        rank = top,

    }

    local effectType = particleManager:GetParticleTypeIndex(name)
    if effectType==-1 then
        return
    end
    newData.effectName = name
    newData.effectType = effectType
    local encoded = json.encode(newData)
    -- print(encoded)
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        -- PrintTable(res)
        if res.StatusCode == 200 then
            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
           
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("ok")
            else
                print("return failed because of the wrong code")
            end




            
       else
           print("Server return with error", res.StatusCode, res.Body)

       end

    end)
end


function player_database:GetPlayerLastSeasonBestRank()

end








-- 储存自定义数据
function player_database:SavePlayerCustomData_GetBonus(nPlayerID,encoded,newDataTable,data,type,targetList)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."customize/saveOrUpdate")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            print("rtnCode="..rtnCode)
            if rtnCode==200 or rtnCode == "200" or rtnCode==2000 or rtnCode=="2000" then
                print("储存玩家自定义数据成功")
                _G.GAME_CAN_BUY[nPlayerID] = true   
                -- 根据newDataTable重新设置货币
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                if newDataTable.reliableExp then
                    spellmap.playerinfo.reliableExp  = newDataTable.reliableExp 
                end
                if newDataTable.gold then
                    spellmap.playerinfo.gold  = newDataTable.gold 
                end
                if newDataTable.platinum then
                    spellmap.playerinfo.platinum  = newDataTable.platinum 
                end
                if newDataTable.core1 then
                    
                    local gameEvent = {}
                    gameEvent["ability_name"] = "item_hd_the_first_core"
                    gameEvent["player_id"] = nPlayerID
                    gameEvent["teamnumber"] = -1
                    gameEvent["locstring_value"] = tostring(newDataTable.core1 -spellmap.playerinfo.core1)
                    gameEvent["message"] = "#DOTA_HUD_PLAYER_GET_CORE_BONUS"..RandomInt(1, 10)
                    FireGameEvent( "dota_combat_event_message", gameEvent )
                    spellmap.playerinfo.core1  = tonumber(newDataTable.core1 )
                end
                if newDataTable.core2 then
                    
                    local gameEvent = {}
                    gameEvent["ability_name"] = "item_hd_the_second_core"
                    gameEvent["player_id"] = nPlayerID
                    gameEvent["teamnumber"] = -1
                    gameEvent["locstring_value"] = tostring(newDataTable.core2 -spellmap.playerinfo.core2)
                    gameEvent["message"] = "#DOTA_HUD_PLAYER_GET_CORE_BONUS"..RandomInt(1, 10)
                    FireGameEvent( "dota_combat_event_message", gameEvent )
                    spellmap.playerinfo.core2  =  tonumber(newDataTable.core2 )
                end
                if newDataTable.core3 then
                    
                    local gameEvent = {}
                    gameEvent["ability_name"] = "item_hd_the_third_core"
                    gameEvent["player_id"] = nPlayerID
                    gameEvent["teamnumber"] = -1
                    gameEvent["locstring_value"] = tostring(newDataTable.core3 -spellmap.playerinfo.core3)
                    gameEvent["message"] = "#DOTA_HUD_PLAYER_GET_CORE_BONUS"..RandomInt(1, 10)
                    FireGameEvent( "dota_combat_event_message", gameEvent )
                    spellmap.playerinfo.core3  =  tonumber(newDataTable.core3 )
                end
                data.recordDate = "1"


                local player = PlayerResource:GetPlayer(nPlayerID)
                achievement:RefreshAchievementList(nPlayerID,type)


                -- EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                -- Notifications:Top(nPlayerID, { text = "#DOTA_HUD_Get_Bonus_success", duration = 2, style = { color = "white" } })

                -- targetList
                -- 使用List广播你解锁成就的信息
                local dota2ID = PlayerResource:GetSteamAccountID(nPlayerID)
                local data = {
                    dota2ID = dota2ID,
                    list = targetList,
                    sound = game_music:GetAchievementSound(),
                }

                CustomGameEventManager:Send_ServerToAllClients("PlayerAchievementReceive", data)
            else
                print("return failed because of the wrong code")
            end
        else
            print("Server return with error", res.StatusCode, res.Body)
            -- 让玩家重新领取即可
            _G.GAME_CAN_BUY[nPlayerID] = true 
            Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
  
        end
    end)
end


function player_database:SavePlayerCustomData(nPlayerID,encoded,callback)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."customize/saveOrUpdate")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            local res_table = JSON:decode(res.Body)
            if not res_table then
                if callback then
                    callback()
                end
                return
            end
            local rtnCode = res_table["rtnCode"]
            print("rtnCode="..rtnCode)
            if rtnCode==200 or rtnCode == "200" or rtnCode==2000 or rtnCode=="2000" then
                print("储存玩家自定义数据成功")
                -- if  _G.Check_Settlement_Request[nPlayerID] then
                --     _G.Check_Settlement_Request[nPlayerID].customData =true
                -- end
                if callback then
                    callback()
                end
            else
                print("return failed because of the wrong code")
            end
        else
            print("Server return with error", res.StatusCode, res.Body)
            -- 让玩家重新领取即可
            -- _G.GAME_CAN_BUY[nPlayerID] = true 
            Timers:CreateTimer(1, function()
                self:SavePlayerCustomData(nPlayerID,encoded,callback)  --再次尝试结算
            end)
        end
    end)
end

function player_database:SavePlayerCustomData_Special(nPlayerID,encoded)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."customize/saveOrUpdate")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            if rtnCode==200 or rtnCode == "200" or rtnCode==2000 or rtnCode=="2000" then
                print("储存玩家自定义数据成功")
            else
                print("return failed because of the wrong code")
            end
        else
            print("Server return with error", res.StatusCode, res.Body)
            Timers:CreateTimer(1, function()
                self:SavePlayerCustomData_Special(nPlayerID,encoded)  --再次尝试结算
            end)
        end
    end)
end

function player_database:SavePlayerCustomData_BuyArtifact(nPlayerID,encoded,newDataTable,callback)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."customize/saveOrUpdate")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    req:SetHTTPRequestRawPostBody("application/json",encoded) 
    req:Send(function(res)
        if res.StatusCode == 200 then
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            print("rtnCode="..rtnCode)
            if rtnCode==200 or rtnCode == "200" or rtnCode==2000 or rtnCode=="2000" then
                print("储存玩家自定义数据成功")
                _G.GAME_CAN_BUY[nPlayerID] = true   
                -- 根据newDataTable重新设置货币
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                if newDataTable.reliableExp then
                    spellmap.playerinfo.reliableExp  = newDataTable.reliableExp 
                end
                if newDataTable.gold then
                    spellmap.playerinfo.gold  = newDataTable.gold 
                end
                if newDataTable.platinum then
                    spellmap.playerinfo.platinum  = newDataTable.platinum 
                end
                Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                if callback then
                    callback()
                end

            else
                print("return failed because of the wrong code")
            end
        else
            print("Server return with error", res.StatusCode, res.Body)
            -- 让玩家重新领取即可
            _G.GAME_CAN_BUY[nPlayerID] = true 
            Notifications:Top(nPlayerID, { text = "#DOTA_HUD_server_login_fail", duration = 2, style = { color = "red" } })
  
        end
    end)
end




function player_database:GetChaoticEraData_with_steamID(nPlayerID,spellMap)
    --login
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."user/login")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    local newData = {}
    newData.steamId = steamID
    newData.season = "-1"

    newData.token = _G.GAME_GLOBAL_KEY
    local encoded = json.encode(newData)


    req:SetHTTPRequestRawPostBody("application/json",encoded)          
    req:Send(function(res)
        -- DeepPrintTable(res)
        -- PrintTable(res.Request)
        -- print(res.Request:getResponseHeader('Date'))
        -- print("-------")
        if res.StatusCode == 200 then


            -- print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            -- PrintTable(res_table)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                --检验成功
    
                local res_table = JSON:decode(res.Body)
                local playersSpells = res_table["playerSpellsList"]
                local playerinfo = res_table["playerInfo"]
                local privilegeInfos = res_table["privilegeRecordList"]
                local seasonRannking = res_table["seasonRankings"]
                local specialEffectRecords = res_table["specialEffectRecords"]
                -- print(res.Body)
                -- print("--------------------------------------")
                -- PrintTable(res_table)
                local customData =  res_table["customizeList"]
                local dataList = customDataManager:InitCustomData(nPlayerID,customData)
                -- PrintTable(customData)
                -- print(res.getResponseHeader('Date'))
                -- print("--------------------------------------")
                spellMap[nPlayerID].playerinfo.vip = playerinfo.vip
                spellMap[nPlayerID].playerinfo.firstGameTime = playerinfo.firstGameTime
                spellMap[nPlayerID].playerinfo.giftBit = playerinfo.giftBit or 0
                spellMap[nPlayerID].playerinfo.reliableExp = playerinfo.reliableExp or 0  --可靠经验
                spellMap[nPlayerID].playerinfo.gold = playerinfo.gold or 0  --金币
                spellMap[nPlayerID].playerinfo.platinum = playerinfo.platinum or  0 --白金
                spellMap[nPlayerID].playerinfo.difficultyWave = playerinfo.wave or  0 --轮回层数
                spellMap[nPlayerID].playerinfo.core1 =tonumber( playerinfo.core1) or 0  --阿哈利姆三原石
                spellMap[nPlayerID].playerinfo.core2 = tonumber( playerinfo.core2) or 0
                spellMap[nPlayerID].playerinfo.core3 =tonumber( playerinfo.core3) or 0

                if playersSpells then
                    for _, value in pairs(playersSpells) do
                        spellMap[nPlayerID].spells[value.spellName]=value.exp
                    end
                end
                -- PrintTable(privilegeInfos,nil,nil)
                if privilegeInfos then
                    for _, value in pairs(privilegeInfos) do
                        local date = value.endDate
                        local serverTime = GameRules:GetGameModeEntity().CAddonTemplateGameMode.serverTime
                        local res = Comparison_time(date,serverTime)
                        --该特权成立
                        if res==true then
                            --更新到特权表里
                            spellMap[nPlayerID].vip[value.privilegeName] ={
                                endday = value.endDate
                            }
                            
                        end
    
                    end
                end
                GameRules:SendCustomMessage("DOTA_CUSTOM_LoginSuccess", DOTA_TEAM_GOODGUYS, nPlayerID)
                _G.GAME_CAN_BUY[nPlayerID] = true   --设置更新数据成功
                _G.GAME_LOGIN[nPlayerID] = true --登录成功
                _G.GAME_LOGIN_SUCCESS_INDEX = _G.GAME_LOGIN_SUCCESS_INDEX + 1 --更新成功登录玩家数
                
                if not seasonRannking then
                    return
                end
                for key, value in pairs(seasonRannking) do
                    -- print(value.rank)
                    if not spellMap[nPlayerID].playerinfo.ranking  then
                        spellMap[nPlayerID].playerinfo.ranking  = value.rank
                    else
                        if value.rank<= spellMap[nPlayerID].playerinfo.ranking then
                            spellMap[nPlayerID].playerinfo.ranking = value.rank
                        end
                    end
                end
                
                for _, info in ipairs(specialEffectRecords) do
                    -- local type = info.effectType
                    local name = info.effectName
    
                    local pos = particleManager:GetTablePos(spellMap[nPlayerID],name)
                    pos.ParticleSet[name] = info.endDate
                    if info.isEquip==1 then
                        pos.on_Particle = name
                    end
                end

                uimanager:SendLoginProgress()
                self.cameraZ[nPlayerID] = tonumber( playerinfo.cameraZ)




            else
                print("return failed because of the wrong code")
            end

        else
            print("Server return with error", res.StatusCode, res.Body)
            GameRules:SendCustomMessage("DOTA_CUSTOM_LoginFailed", DOTA_TEAM_GOODGUYS, nPlayerID)
            Timers:CreateTimer(2, function()
                self:GetChaoticEraData_with_steamID(nPlayerID,spellMap)  --再次尝试登录
            end)

        end
    end)
end












--用于领取礼包
function player_database:CreateCDK(nPlayerID,newData)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."cdKey/createCdKey")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    local encoded = json.encode(newData)
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    -- print("encoded=",encoded)
    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("创建CDK成功")
            else
                print("return failed because of the wrong code")
            end
       else
            print("Server return with error", res.StatusCode, res.Body)
       end

    end)

end

function player_database:GetCDKbonus(nPlayerID,encoded)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address.."cdKey/useCdKey")
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    local player = PlayerResource:GetPlayer(nPlayerID)     

    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            -- print("rtnCode=="..rtnCode)
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("通过")
                local cdkData = res_table["cdKeyInfo"]
                local updateInfo = res_table["updateInfo"]


                local cdKey = cdkData.cdKey
                local cdKeyEffectList =  cdkData.cdKeyEffectList
       
                local specialEffectRecordList = updateInfo.specialEffectRecordList



                local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]





                map.playerinfo.gold = map.playerinfo.gold  + (cdKey.gold or 0 ) --黄金
                map.playerinfo.platinum = map.playerinfo.platinum + (cdKey.platinum or 0 ) --白金
                map.playerinfo.reliableExp = map.playerinfo.reliableExp + (cdKey.reliableExp or 0 ) --可靠经验
                -- PrintTable(specialEffectRecordList)
                local particleCount = 0
                if #specialEffectRecordList>0 then
                       
                    local spellmap =  map  --获取到数据表
                    for index, value in ipairs(specialEffectRecordList) do
                        local name = value.effectName
                        local pos = particleManager:GetTablePos(spellmap,name)
                        pos.ParticleSet[name] = value.endDate
                        particleCount = particleCount + 1
                    end

                    local sound_list = spellmap.Particle.SoundWheel.ParticleSet  --获取到所有语音
                    CustomGameEventManager:Send_ServerToPlayer(player, "GetPlayerSoundWheel_feedback", sound_list)
                    

                end



                local player = PlayerResource:GetPlayer(nPlayerID) 
                Notifications:Top(nPlayerID, { text = "#DOTA_CUSTOM_UpdateSuccess_gift", duration = 4, style = { color = "white" } })
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新
                CustomGameEventManager:Send_ServerToPlayer(player, "EmitLocalSound", {sound_name = "HD_PLUS_ONE"}) --强制刷新

                local gameEvent = {}
                gameEvent["player_id"] = nPlayerID
                gameEvent["teamnumber"] =-1
                gameEvent["int_value"] = cdKey.platinum or 0
                gameEvent["int_value2"] = cdKey.gold or 0
                gameEvent["locstring_value2"] = cdKey.reliableExp or 0
                gameEvent["message"] = "#HUD_Get_Gift"
                if particleCount>0 then
                    gameEvent["message"] = "#HUD_Get_Gift_2"
                    gameEvent["locstring_value"] = particleCount
                end
               
                FireGameEvent( "dota_combat_event_message", gameEvent )


                -- cdKeyEffectList
                _G.GAME_CAN_BUY[nPlayerID] = true 
                -- HUD_Get_Gift_2
                -- print("领取CDK成功")
                CustomGameEventManager:Send_ServerToPlayer(player, "ShowCDKButton", {}) --强制刷新

            else
                SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_CDK_Fail_"..rtnCode,"General.Cancel")
                _G.GAME_CAN_BUY[nPlayerID] = true   --设置更新数据成功
                CustomGameEventManager:Send_ServerToPlayer(player, "ShowCDKButton", {}) --强制刷新

            end



            
       else
            CustomGameEventManager:Send_ServerToPlayer(player, "ShowCDKButton", {}) --强制刷新

            print("Server return with error", res.StatusCode, res.Body)
       end

    end)

end



-- 更新网表  暂时没有作用
function player_database:UpdatePlayerResource__NetTable(nPlayerID)
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
    if map then
        -- 这里的数据仅用于前端数据展示
        local data = {
            aurum = map.playerinfo.gold,
            platinum = map.playerinfo.platinum,
            reliableExp = map.playerinfo.reliableExp,

        }
        CustomNetTables:SetTableValue( "game_data", "playerResource_"..nPlayerID, data  ) 

    end


end