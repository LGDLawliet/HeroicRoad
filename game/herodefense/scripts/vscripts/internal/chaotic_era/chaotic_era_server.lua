local RuneSync = require("internal/rune_sync")
local LocalArchive = require("internal/local_archive")

-- http-保存新符石
function chaotic_era:SaveNewRune(nPlayerID,encoded,callBack)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address..CHAOTIC_ERA_ACTION_Save_Rune)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    local player = PlayerResource:GetPlayer(nPlayerID)  
    -- print(encoded)   
    req:Send(function(res)
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("保存新符石通过")
                -- PrintTable(res_table)
                if callBack then
                    callBack(res_table.runeInfos)
                end

                
            else
                print("Error:合法性不通过")
            end
       else
            print("Server return with error", res.StatusCode, res.Body)
            print("Error:保存新符石失败 再次尝试")
            game_event:UpdateFailed(nPlayerID,encoded)  --信息更新失败反馈
            Timers:CreateTimer(2, function()
                self:SaveNewRune(nPlayerID,encoded,callBack)
            end)
       end

    end)

end



-- 刷新玩家的符石数据
function chaotic_era:GetPlayerRuneData(nPlayerID,callback)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address..CHAOTIC_ERA_ACTION_Get_All_Rune)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    local data ={
        token = _G.GAME_GLOBAL_KEY,  --合法性
        steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
        
    }
    local encoded = json.encode(data)
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    local player = PlayerResource:GetPlayer(nPlayerID)     
    req:Send(function(res)
        if res.StatusCode == 200 then
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                print("获取成功")
                -- DeepPrint(res_table)
                self.runeData[nPlayerID] = {}

                self.runeEquip__Nettable[nPlayerID] = {}

                local dataList = res_table.runeInfos
                print("符石")
                for _, data in ipairs(dataList) do

                    if not self.runeData[nPlayerID][data.correspondingSkill] then
                        self.runeData[nPlayerID][data.correspondingSkill] = {
                            on_Rune = nil,
                            runeSet = {

                            },
                        
                        }
                    end
                    local rune = {
                        specicaValue =  JSON:decode(data.specicaValue) or {},
                        particleType = data.particleType or 0,
                        runeType = data.runeType or 0,
                        isEquip = data.isEquip,
                        runeId = data.runeId,
                        modifyCount = data.modifyCount or 0,
                        correspondingSkill  = data.correspondingSkill  or "unknow",
                        rarity  = data.rarity  or 1,
                        locked = data.locked or 0,

                    }
                    self.runeData[nPlayerID][data.correspondingSkill].runeSet[data.runeId] = rune
                    if data.isEquip==1 then
                        -- 如果是装配了的符石 那就设置一下
                        self.runeData[nPlayerID][data.correspondingSkill].on_Rune =  data.runeId

                        self.runeEquip__Nettable[nPlayerID][data.correspondingSkill]= table.shallowCopy(rune)
                    end



                end
                print("重载符石数据完成")

                -- 上传已装备的符石到网表
                -- PrintTable(self.runeEquip__Nettable[nPlayerID])
                -- print("nPlayerID=",nPlayerID)
                
                RuneSync.PublishEquipment(nPlayerID, self.runeEquip__Nettable[nPlayerID])  --更新网表
                -- local key = CustomNetTables:GetTableValue( "RuneData", "playerRuneEquip")
                -- PrintTable(key)
                -- PrintTable(key[tostring(nPlayerID)])
                if callback then
                    callback()
                end

            else
                print("Error:合法性不通过")
            end
       else
            print("Server return with error", res.StatusCode, res.Body)
            -- CustomGameEventManager:Send_ServerToPlayer(player, "ShowCDKButton", {}) --强制刷新
            self:GetPlayerRuneData(nPlayerID,callback)
            print("Error:获取玩家符石数据失败 再次尝试 nPlayerID=",nPlayerID)
       end

    end)
end


--更新符石到列表中
-- 会返回一个排序好的table 可用于结算页面展示
function chaotic_era:UpdateRuneData(nPlayerID,dataList)

    local returnList  ={}
    for _, data in ipairs(dataList) do
        if not self.runeData[nPlayerID][data.correspondingSkill] then
            self.runeData[nPlayerID][data.correspondingSkill] = {
                on_Rune = nil,
                runeSet = {

                },
            
            }
        end
        local rune = {
            specicaValue =  JSON:decode(data.specicaValue) or {},
            particleType = data.particleType or 0,
            runeType = data.runeType or 0,
            isEquip = data.isEquip,
            runeId = data.runeId,
            modifyCount = data.modifyCount or 0,
            correspondingSkill  = data.correspondingSkill  or "unknow",
            rarity  = data.rarity  or 1,
            locked = data.locked or 0,

        }
        self.runeData[nPlayerID][data.correspondingSkill].runeSet[data.runeId] = rune

        table.insert(returnList,rune)

    end
    print("更新符石数据完成")
    return returnList
end

-- 装配目标符石
-- function chaotic_era:EquipTargetRune(nPlayerID,encoded,targetRuneOverrideData,sourceRuneOverrideData)
function chaotic_era:EquipTargetRune(nPlayerID,encoded,runeId,correspondingSkill)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address..CHAOTIC_ERA_ACTION_EquipRune)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    req:SetHTTPRequestRawPostBody("application/json",encoded)     
    local player = PlayerResource:GetPlayer(nPlayerID)     
    req:Send(function(res)
        self:SetPlayerEquiping(nPlayerID,false) 
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- 需要覆盖一下原来的数据
                SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_1","General.Cancel")
                -- local spell_name = targetRuneOverrideData.correspondingSkill
                -- self.runeData[nPlayerID][spell_name].on_Rune = targetRuneOverrideData.runeId
                -- self.runeData[nPlayerID][spell_name].runeSet[targetRuneOverrideData.runeId].isEquip = 1
                -- if sourceRuneOverrideData then
                --     self.runeData[nPlayerID][spell_name].runeSet[sourceRuneOverrideData.runeId].isEquip = 0
                -- end
                self.runeData[nPlayerID][correspondingSkill].on_Rune =runeId
                -- self.runeData[nPlayerID][correspondingSkill]
                for key, value in pairs(self.runeData[nPlayerID][correspondingSkill].runeSet) do
                    value.isEquip = 0
                end
                self.runeData[nPlayerID][correspondingSkill].runeSet[runeId].isEquip = 1


                -- 刷新一下js的数据
                self:UpdateRuneJsData(nPlayerID)
                if IsInToolsMode() then
                    self.runeData[nPlayerID][correspondingSkill].on_Rune =  runeId
                    local rune = self.runeData[nPlayerID][correspondingSkill].runeSet[runeId]
                    self.runeEquip__Nettable[nPlayerID][correspondingSkill]= table.shallowCopy(rune)
                    RuneSync.PublishEquipment(nPlayerID, self.runeEquip__Nettable[nPlayerID])  --更新网表
                end
                -- self.runeData[nPlayerID][spell_name].runeSet[runeId]
            else
                print("Error:合法性不通过")
            end
       else
            print("Server return with error", res.StatusCode, res.Body)
            -- CustomGameEventManager:Send_ServerToPlayer(player, "ShowCDKButton", {}) --强制刷新
            -- self:SaveNewRune(nPlayerID,encoded)
            print("Error:修改符石失败")
            SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_2","General.Cancel")
            
       end

    end)

end









-- 重铸符石的词条数值
function chaotic_era:EditTargetRuneSpecialBonusValue(nPlayerID,encoded,targetRuneOverrideData,currentSelectSpecialName,costTyle,cost,bChangeLock)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address..CHAOTIC_ERA_ACTION_Modify_Rune)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    req:SetHTTPRequestRawPostBody("application/json",encoded)        
    -- if IsInToolsMode() then
    --     PrintLinkedConsoleMessage("runeInfo", encoded)
    -- end  
    req:Send(function(res)
        -- self:SetPlayerEquiping(nPlayerID,false) 
        _G.GAME_CAN_BUY[nPlayerID] = true
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- 需要覆盖一下原来的数据
                -- SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_1","General.Cancel")
                local spell_name = targetRuneOverrideData.correspondingSkill
                self.runeData[nPlayerID][spell_name].on_Rune = targetRuneOverrideData.runeId
                self.runeData[nPlayerID][spell_name].runeSet[targetRuneOverrideData.runeId].specicaValue = JSON:decode(targetRuneOverrideData.specicaValue)
                self.runeData[nPlayerID][spell_name].runeSet[targetRuneOverrideData.runeId].modifyCount = targetRuneOverrideData.modifyCount
                self.runeData[nPlayerID][spell_name].runeSet[targetRuneOverrideData.runeId].locked = targetRuneOverrideData.locked
                -- 更新货币
                local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
                if costTyle==1 then
                    map.playerinfo.reliableExp = tonumber(map.playerinfo.reliableExp) - cost
                elseif costTyle==2 then
                    map.playerinfo.gold = tonumber(map.playerinfo.gold) - cost
                elseif costTyle==3 then
                    map.playerinfo.platinum = tonumber(map.playerinfo.platinum) - cost
                end

                -- 刷新一下js的数据
                local data = self.runeData[nPlayerID] or {}
                local player = PlayerResource:GetPlayer(nPlayerID) 

                -- 更新数据
                uimanager:UpdateBasePlayerData(nPlayerID)
                local editKeys={
                    correspondingSkill = targetRuneOverrideData.correspondingSkill,
                    runeId = targetRuneOverrideData.runeId,
                    currentSelectSpecialName=currentSelectSpecialName,
                }
                -- PrintTable(editKeys)
                if bChangeLock then
                    Notifications:Top(nPlayerID, { text = "#HUD_Rune_Edit_2_Ok", duration = 3, style = { color = "white" } })
                else
                    Notifications:Top(nPlayerID, { text = "#HUD_Rune_Edit_1_Ok", duration = 3, style = { color = "white" } })
                end
                self:UpdateRuneJsData(nPlayerID, function()
                    CustomGameEventManager:Send_ServerToPlayer(player, "OpenRuneEditWindow_BonusValue", editKeys)
                end)

                
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)


                -- self.runeData[nPlayerID][spell_name].runeSet[runeId]
            else
                print("Error:合法性不通过")
            end
       else
            print("Server return with error", res.StatusCode, res.Body)

            print("Error:修改符石失败")
            SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_2","General.Cancel")
            
       end

    end)

end





-- 分解目标符石
function chaotic_era:DeleteRuneList(nPlayerID,encoded,playerInfo,delIdList)
    local req = LocalArchive.CreateRequest("POST", _G.GAME_server_address..CHAOTIC_ERA_ACTION_Delete_Rune)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")

    req:SetHTTPRequestRawPostBody("application/json",encoded)      
    -- if IsInToolsMode() then
    --     PrintLinkedConsoleMessage("runeInfo", encoded)
    -- end  
    req:Send(function(res)
        -- self:SetPlayerEquiping(nPlayerID,false) 
        _G.GAME_CAN_BUY[nPlayerID] = true
        if res.StatusCode == 200 then
            print("[STATS] Received "..res.Body)
            local res_table = JSON:decode(res.Body)
            local rtnCode = res_table["rtnCode"]
            --合法性检验
            if rtnCode==200 or rtnCode == "200" then
                -- 需要覆盖一下原来的数据
                local dataTable = self.runeData[nPlayerID]
                for id, value in pairs(delIdList) do
                    if dataTable[value.spellName].runeSet[tonumber(id)] then
                        dataTable[value.spellName].runeSet[tonumber(id)]  = nil
                    end
                end


                -- 更新货币
                local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
                if playerInfo.reliableExp then
                    map.playerinfo.reliableExp = tonumber(map.playerinfo.reliableExp) +playerInfo.reliableExp
                end
                if playerInfo.gold then
                    map.playerinfo.gold = tonumber(map.playerinfo.gold) +playerInfo.gold
                end

                -- 刷新一下js的数据
                local data = self.runeData[nPlayerID] or {}
                local player = PlayerResource:GetPlayer(nPlayerID) 
                -- 更新数据
                uimanager:UpdateBasePlayerData(nPlayerID)
                self:UpdateRuneJsData(nPlayerID)
              
                Notifications:Top(nPlayerID, { text = "#HUD_Rune_Del_Ok", duration = 3, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)


                -- self.runeData[nPlayerID][spell_name].runeSet[runeId]
            else
                print("Error:合法性不通过")
            end
       else
            print("Server return with error", res.StatusCode, res.Body)

            print("Error:修改符石失败")
            SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_2","General.Cancel")
            
       end

    end)

end

