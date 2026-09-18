require("internal/timers")
require("internal/playertables")

uimanager = uimanager or  class({})

print("uimanager load....")
-- 技能不计入数量计算
require("internal/ui_event/buyBack")
require("internal/ui_event/ui_setting")
require("internal/ui_event/spells_ui")
require("internal/ui_event/game_shop")
require("internal/ui_event/difficulty_select")
require("internal/ui_event/talent_tree")

function uimanager:init(bReload)
    
    CustomUIEvent("Getplayerdata", Dynamic_Wrap(self, "_Getplayerdata"), self)
    CustomUIEvent("UpgradePlayerSpell", Dynamic_Wrap(self, "_UpgradePlayerSpell"), self)
    CustomUIEvent("UpgradePlayerSpell_lv5", Dynamic_Wrap(self, "_UpgradePlayerSpell_lv5"), self)
    CustomUIEvent("Buy_GOODS_Confirm_to_lua", Dynamic_Wrap(self, "_Buy_GOODS_Confirm_to_lua"), self)
    CustomUIEvent("Create_DPS", Dynamic_Wrap(self, "_Create_DPS"), self)
    CustomUIEvent("UpdateGameWave", Dynamic_Wrap(self, "_UpdateGameWave"), self)
    CustomUIEvent("CheckAlive", Dynamic_Wrap(self, "_CheckAlive"), self)
    CustomUIEvent("BuyBackHero", Dynamic_Wrap(self, "_BuyBackHero"), self)
    CustomUIEvent("BuyBackClosest", Dynamic_Wrap(self, "_BuyBackClosest"), self)
    CustomUIEvent("GetPlayerInfoDate", Dynamic_Wrap(self, "_GetPlayerInfoDate"), self)
    CustomUIEvent("GetPlayerVIPInfoDate", Dynamic_Wrap(self, "_GetPlayerVIPInfoDate"), self)
    CustomUIEvent("CheckDifficulty", Dynamic_Wrap(self, "_CheckDifficulty"), self)
    CustomUIEvent("CheckPlayerBonus", Dynamic_Wrap(self, "_CheckPlayerBonus"), self)
    CustomUIEvent("GetPlayerBonus", Dynamic_Wrap(self, "_GetPlayerBonus"), self)
    CustomUIEvent("CheckGameInfo", Dynamic_Wrap(self, "_CheckGameInfo"), self)
    CustomUIEvent("GetFreeSpells", Dynamic_Wrap(self, "_GetFreeSpells"), self)
    CustomUIEvent("GetTeamDataByID", Dynamic_Wrap(self, "_GetTeamDataByID"), self)
    CustomUIEvent("TryGetCore", Dynamic_Wrap(self, "_TryGetCore"), self)
    CustomUIEvent("SendHiddenInfo", Dynamic_Wrap(self, "_SendHiddenInfo"), self)
    CustomUIEvent("CheckWave", Dynamic_Wrap(self, "_CheckWave"), self)
    CustomUIEvent("ChangeTimeScale", Dynamic_Wrap(self, "_ChangeTimeScale"), self)
    CustomUIEvent("SendTimeScalechangeInfo", Dynamic_Wrap(self, "_SendTimeScalechangeInfo_FeedBack"), self)
    CustomUIEvent("CheckGameLoadingBG", Dynamic_Wrap(self, "_CheckGameLoadingBG"), self)
    CustomUIEvent("SpellModifySend", Dynamic_Wrap(self, "_SpellModifySend"), self)
    CustomUIEvent("TryBuyItem_GameShop", Dynamic_Wrap(self, "_TryBuyItem_GameShop"), self)
    CustomUIEvent("CheckTalentTree", Dynamic_Wrap(self, "_CheckTalentTree"), self)
    CustomUIEvent("TalentTreeReady", Dynamic_Wrap(self, "_TalentTreeReady"), self)

    
    
       
end

_G.Game_Hide_contest_info = false
_G.GAME_Hide_select = false
function uimanager:_SendHiddenInfo(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local isHiden = event_data.hidden
    if isHiden==1 then
        _G.Game_Hide_contest_info = true
        _G.GAME_Hide_select = true
        local gameEvent = {}
        gameEvent["player_id"] = nPlayerID
        gameEvent["teamnumber"] = -1
        gameEvent["message"] = "#DOTA_HUD_Yes_show"
        FireGameEvent( "dota_combat_event_message", gameEvent )
    else
        _G.GAME_Hide_select = true
        local gameEvent = {}
        gameEvent["player_id"] = nPlayerID
        gameEvent["teamnumber"] = -1
        gameEvent["message"] = "#DOTA_HUD_No_show"
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end
    
end




--获取玩家的数据表 包含更新作用 获取完返回给js
function uimanager:_Getplayerdata(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    self:UpdateBasePlayerData(nPlayerID)
   
end
function uimanager:UpdateBasePlayerData(nPlayerID)
    if not GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap then
        return
    end
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
    local player = PlayerResource:GetPlayer(nPlayerID)
    local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表

   
    --反馈技能表
    CustomGameEventManager:Send_ServerToPlayer(player, "Getplayerdata_feedback", { spellmap=spellmap,spellsXPTable=spellsXPTable})
end


--获取玩家的个人信息
function uimanager:_GetPlayerInfoDate(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellmap then
        return
    end
    local firstGameTime = spellmap[nPlayerID].playerinfo.firstGameTime 
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local dota2ID = PlayerResource:GetSteamAccountID(nPlayerID)
    local playerName = PlayerResource:GetPlayerName(nPlayerID)
    local feedbackData = {
        firstGameTime=firstGameTime,
        steamID = steamID,
        dota2ID =dota2ID,
        playerName = playerName,
        core1 = spellmap[nPlayerID].playerinfo.core1,
        core2 = spellmap[nPlayerID].playerinfo.core2,
        core3 = spellmap[nPlayerID].playerinfo.core3,
    }

    --反馈技能表
    CustomGameEventManager:Send_ServerToPlayer(player, "GetplayerInfo_feedback", feedbackData)
   
end


--特权
function uimanager:_GetPlayerVIPInfoDate(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    local spellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellMap then
        return
    end
    
    local vipTable = spellMap[nPlayerID].vip

    

    --反馈技能表
    CustomGameEventManager:Send_ServerToPlayer(player, "GetPlayerVIPInfo_feedback", vipTable)
   
end


--获取玩家的数据表 包含更新作用 获取完返回给js
function uimanager:_UpgradePlayerSpell(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local spellname = event_data.spell_name
    local player = PlayerResource:GetPlayer(nPlayerID) 
    local exp = event_data.spell_exp  --修改完的技能经验
    -- local reliableExp = event_data.upgrade_after_exp  --修改后的可靠经验
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
    local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
    PrintTable(spellmap)
    local now_reliableexp = spellmap.playerinfo.reliableExp  --拿到当前的可靠经验
    local now_spell_exp = tonumber(spellmap.spells[spellname])         --拿到当前的技能经验值
    local spell_level = 0
    for _, value in pairs(spellsXPTable) do
        if now_spell_exp>=value then
            spell_level = spell_level +1
        else
            break
        end    
    end
    --拿到等级
    if spell_level==25 then  --一般满级的技能不会传过来 但以防万一
        GameRules:SendCustomMessage("DOTA_CUSTOM_Upgradefailed_data_error", DOTA_TEAM_GOODGUYS, nPlayerID) --满级的技能不能升级
        CustomGameEventManager:Send_ServerToPlayer(player, "UpgradeSpellFailed_feedback", {})
        --失败处理
    else --处理升级
        local reliableExp_cost = spellsXPTable[spell_level+1]-now_spell_exp  --需要的经验值消耗
        local reliableExp = now_reliableexp -  reliableExp_cost  --传到后端的值
        local exp = spellsXPTable[spell_level+1]                 --升级后的经验值
        self:TryUpgradespell(nPlayerID,spellname,exp,reliableExp)
        return
    end
   
end




function uimanager:_UpgradePlayerSpell_lv5(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local spellname = event_data.spell_name
    local player = PlayerResource:GetPlayer(nPlayerID) 
    -- local reliableExp = event_data.upgrade_after_exp  --修改后的可靠经验
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
    local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
    local now_reliableexp = tonumber(spellmap.playerinfo.reliableExp)  --拿到当前的可靠经验
    local now_spell_exp = tonumber(spellmap.spells[spellname])         --拿到当前的技能经验值
    local spell_level = 0
    for _, value in pairs(spellsXPTable) do
        if now_spell_exp>=value then
            spell_level = spell_level +1
        else
            break
        end    
    end
    --拿到等级
    if spell_level==25 then  --一般满级的技能不会传过来 但以防万一
        GameRules:SendCustomMessage("DOTA_CUSTOM_Upgradefailed_data_error", DOTA_TEAM_GOODGUYS, nPlayerID) --满级的技能不能升级
        CustomGameEventManager:Send_ServerToPlayer(player, "UpgradeSpellFailed_feedback", {})
        --失败处理
    else --处理升级
        local next_level = spell_level+1
        local reliableExp_cost = spellsXPTable[next_level]-now_spell_exp  --需要的经验值消耗
        local reliableExp = now_reliableexp -  reliableExp_cost  --传到后端的值
        local exp = spellsXPTable[next_level]                 --升级后的经验值

        for i = 1, 4, 1 do
            next_level = next_level + 1
            if next_level>25 then
                break
            end
            local need_cost = tonumber(spellsXPTable[next_level])-now_spell_exp
            if now_reliableexp>=need_cost then
                --可以通过
                reliableExp_cost = need_cost
                reliableExp = now_reliableexp -  reliableExp_cost
                exp = spellsXPTable[next_level]   
            else
                break
            end
            print("额外升1级")
        end
      



        self:TryUpgradespell(nPlayerID,spellname,exp,reliableExp)
        return
    end
   
end





function uimanager:TryUpgradespell(nPlayerID,spellname,exp,reliableExp)

    if _G.GAME_GAME_ENDING then
        return
    end
    if _G.GAME_CAN_BUY[nPlayerID]==false then --互斥操作 当前无法购买物品
        Notifications:Top(nPlayerID, { text = "#buy_failed_Order_not_completed", duration = 4, style = { color = "red" } })
        EmitSoundOnClient("General.Cancel", player)
        return
    end
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    if steamID ~= "0" then
        local newData = {}

        newData.playerInfo = {}
        newData.playerInfo.steamId = steamID 
        newData.playerInfo.reliableExp = reliableExp  --可靠经验
        --将技能储存到表里
        newData.playerSpellsList = {}
        local newtable = {}
        newtable.steamId = steamID 
        newtable.spellName = spellname
        newtable.exp = exp
        table.insert(newData.playerSpellsList, newtable)
        --转换格式 发送数据包
        newData.token = _G.GAME_GLOBAL_KEY  --合法性
        _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
        local encoded = json.encode(newData)
        -- print(encoded)
        

        player_database:UpgradeUserSpell_with_steamID(nPlayerID,encoded,reliableExp,spellname,exp)
        -- print("server return callback with "..callback_index)
    end   
end




--获取玩家的数据表 包含更新作用 获取完返回给js
function uimanager:_Buy_GOODS_Confirm_to_lua(eventSourceIndex, event_data)

    if _G.GAME_GAME_ENDING then
        return
    end
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not map  then
        return
    end
    

    local nPlayerID = event_data.player_id
    local spellname = event_data.spell_name
    local player = PlayerResource:GetPlayer(nPlayerID) 
    local type = event_data.type+1  --消费类型 用于定位这件物品位于Player_shop 中的位置、

    if not map[nPlayerID] then
        return
    end
    
    if _G.GAME_CAN_BUY[nPlayerID]==false then --互斥操作 当前无法购买物品
        Notifications:Top(nPlayerID, { text = "#buy_failed_Order_not_completed", duration = 4, style = { color = "red" } })
        EmitSoundOnClient("General.Cancel", player)
        return
    end


    -- 直接购买天赋
    if type==1000 then
         -- 说明是直接购买特效
         -- 先去查找一下是否合法
        if talentManager:CheckMarketRightful(spellname) then
            -- 说明找到了 
            local cost = 1200
            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
            local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
            local pos = particleManager:GetTablePos(spellmap,spellname)
            if pos.ParticleSet[spellname] then
                local endday =  pos.ParticleSet[spellname]
                local date = "2099-01-01 00:00:00"
                local res = Comparison_time(endday,date)
                if res==true then --永久无需重复购买
                    Notifications:Top(nPlayerID, { text = "#particle_buy_failed_forever", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                    return
                end
            end
            if now_platinum>=cost  then --满足条件 尝试购买
                print("now_platinum="..now_platinum)
                local later_platinum = now_platinum-cost  --修改后的白金
                print("later_platinum="..later_platinum)
                -- local later_exp = spellmap.playerinfo.reliableExp    --修改后经验
                -- local later_gold = spellmap.playerinfo.gold        --修改后金币
                local newData = {}
                newData = {}
                newData.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                newData.specialEffectName = spellname
                local particleType = particleManager:GetParticleTypeIndex( spellname)
                if particleType==-1  then
                    print("Error:购买特效类型错误")
                    return
                end
                newData.specialEffectType = particleType
                newData.addDay = 36500
                newData.token = _G.GAME_GLOBAL_KEY  --合法性
                newData.platinum = tostring(later_platinum)
                -- newData.gold = tostring(later_platinum)
                newData.token = _G.GAME_GLOBAL_KEY  --合法性
                --转换格式 发送数据包
                local encoded = json.encode(newData)
                _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                player_database:BuyParticleEffect_with_steamID(nPlayerID,encoded,later_platinum,nil)  

                print("tye buy")
                
            else --白金不足以购买
                Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                EmitSoundOnClient("General.Cancel", player)
            end
        end
        return
    end
    -- 直接抽符石
    if event_data.type==7 then
        local cost =500
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
        local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
        -- print("gggggggg")
        if now_platinum>=cost  then --满足条件 尝试购买
            local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
            local data ={
                token = _G.GAME_GLOBAL_KEY,  --合法性
                runeInfos={},
                playerInfo ={
                    steamId = steamID,
                    platinum=-cost,
                    reliableExp = 0,
                    gold = 0,
                }
            }
            local count = 5
            local level4_count = 0
            local level5_count = 0
            for i = 1, count, 1 do
                if 20>=RandomInt(1, 100) then
                    level5_count = level5_count + 1
                end
                -- else
                --     level4_count = level4_count + 1
                -- end
            end
            level5_count = math.max(level5_count,1)
            level4_count = count - level5_count
            for i = 1, level4_count, 1 do
                local name = spellname
                chaotic_era:CreateRune__WithName(data,nPlayerID,4,name)
            end
            for i = 1, level5_count, 1 do
                local name = spellname
                chaotic_era:CreateRune__WithName(data,nPlayerID,5,name)
            end
            
            
            local encoded = json.encode(data)
            _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
            print("tye buy")

            chaotic_era:SaveNewRune(nPlayerID,encoded,function (runeInfos)
                -- updateFinish(runeInfos)
                local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
                map.playerinfo.platinum = tonumber(map.playerinfo.platinum) -cost
                _G.GAME_CAN_BUY[nPlayerID] = true
                local player = PlayerResource:GetPlayer(nPlayerID) 
                Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
                EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                local runeList = chaotic_era:UpdateRuneData(nPlayerID,runeInfos)
                local data = {
                    sMessage={},
                    playerinfo = {
                        reliableExp = 0,
                        gold = 0,
                    },
                    runeList = runeList,
                }

            
                CustomGameEventManager:Send_ServerToPlayer(player, "SetBonus", data)  --给出奖励提示
                CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新
                -- CustomGameEventManager:Send_ServerToPlayer(player, "BuyRuneFeedback", {}) --强制刷新


            end)


            -- player_database:BuyParticleEffect_with_steamID(nPlayerID,encoded,later_platinum,nil)  

            
            
        else --白金不足以购买
            Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
            EmitSoundOnClient("General.Cancel", player)
        end
        return
    end

    -- 购买圣物
    if event_data.type==8 then
        local cost =  KeyValues.palyer_artifactKV[spellname].PlatinumCost
        if cost and cost>0 then
            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
            local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金

            if now_platinum>=cost  then --满足条件 尝试购买
                -- print("aaaaaaaaaaa")
                customDataManager:BuyArtifact(nPlayerID,spellname,cost)
                
            else --白金不足以购买
                Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                EmitSoundOnClient("General.Cancel", player)
            end
        end
    
        return
    end


    local goods = GameRules:GetGameModeEntity().CAddonTemplateGameMode.PlayerShop[type][spellname]  --拿到商店内容
    -- print(type)
    -- print(spellname)
    -- local goods = GameRules:GetGameModeEntity().CAddonTemplateGameMode.PlayerShop[type]
    -- PrintTable(goods)
    if event_data.type==3  then  --处理黑市

      
        
        if goods.goods_class==TYPE_BUY_ParticleEffect then
            if   goods.cost_class==TYPE_COST_Platinum then--白金消费
                local cost =goods.cost--（花费）
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金

                local pos = particleManager:GetTablePos(spellmap,goods.item_name)

                if pos.ParticleSet[goods.item_name] then
                    local endday =  pos.ParticleSet[goods.item_name]

                    local date = "2099-01-01 00:00:00"
                    local res = Comparison_time(endday,date)
                    if res==true then --永久无需重复购买
                        Notifications:Top(nPlayerID, { text = "#particle_buy_failed_forever", duration = 4, style = { color = "red" } })
                        EmitSoundOnClient("General.Cancel", player)
                        return

                    end
                end
        
                if now_platinum>=cost  then --满足条件 尝试购买
                    local later_platinum = now_platinum-cost  --修改后的白金
                    -- local later_exp = spellmap.playerinfo.reliableExp    --修改后经验
                    -- local later_gold = spellmap.playerinfo.gold        --修改后金币
                    local newData = {}
                    newData = {}
                    newData.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                    newData.specialEffectName = goods.item_name
                    local particleType = particleManager:GetParticleTypeIndex( goods.item_name)
                    if particleType==-1  then
                        print("Error:购买特效类型错误")
                        return
                    end
                    newData.specialEffectType = particleType
                    newData.addDay = goods.bonus or 36500
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    newData.platinum = tostring(later_platinum)
                    -- newData.gold = tostring(later_platinum)
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    --转换格式 发送数据包
                    local encoded = json.encode(newData)
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:BuyParticleEffect_with_steamID(nPlayerID,encoded,later_platinum,nil)  

                    print("tye buy")
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
            elseif   goods.cost_class==TYPE_COST_Aurum then--黄金消费
                local cost =goods.cost--（花费）
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_gold = tonumber(spellmap.playerinfo.gold)  --拿到当前的金币

                local pos = particleManager:GetTablePos(spellmap,goods.item_name)

                if pos.ParticleSet[goods.item_name] then
                    local endday =  pos.ParticleSet[goods.item_name]

                    local date = "2099-01-01 00:00:00"
                    local res = Comparison_time(endday,date)
                    if res==true then --永久无需重复购买
                        Notifications:Top(nPlayerID, { text = "#particle_buy_failed_forever", duration = 4, style = { color = "red" } })
                        EmitSoundOnClient("General.Cancel", player)
                        return

                    end
                end
        
                if now_gold>=cost  then --满足条件 尝试购买
                    -- local later_platinum = now_platinum-cost  --修改后的白金
                    -- local later_exp = spellmap.playerinfo.reliableExp    --修改后经验
                    local later_gold = now_gold-cost       --修改后金币
                    local newData = {}
                    newData = {}
                    newData.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                    newData.specialEffectName = goods.item_name
                    local particleType = particleManager:GetParticleTypeIndex( goods.item_name)
                    if particleType==-1  then
                        print("Error:购买特效类型错误")
                        return
                    end
                    newData.specialEffectType = particleType
                    newData.addDay = goods.bonus or 36500
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    -- newData.platinum = tostring(later_platinum)
                    newData.gold = tostring(later_gold)
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    --转换格式 发送数据包
                    local encoded = json.encode(newData)
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:BuyParticleEffect_with_steamID(nPlayerID,encoded,nil,later_gold)  

                    -- print("tye buy")
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Black_Market_spell_buy_failed_not_enough_good", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
            end

        -- 购买技能书
        elseif goods.goods_class==TYPE_BUY_Spell_Book then
            if   goods.cost_class==1 then--金币消费
                local cost =goods.cost--（金币花费）
                -- spellname（技能名）
    
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
            
                if spellmap.spells[spellname] then  --说明这个技能已经解锁了
                    -- print("buy failed because already learned")
                    Notifications:Top(nPlayerID, { text = "#Black_Market_spell_buy_failed_mastered", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
    
                else
                    local now_gold = tonumber(spellmap.playerinfo.gold)  --拿到当前的金币
                    if now_gold>=cost  then --满足条件 尝试购买
                        local later_gold = now_gold-cost  --修改后的金币
    
                        local newData = {}
                        newData.playerInfo = {}
                        newData.playerInfo.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                        newData.playerInfo.gold = tostring(later_gold)
    
                        
                        newData.playerSpellsList = {}
                        local newtable = {}
                        newtable.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
                        newtable.spellName = spellname
                        newtable.exp = 0
                        table.insert(newData.playerSpellsList, newtable)
                        newData.token = _G.GAME_GLOBAL_KEY  --合法性
    
                        --转换格式 发送数据包
                        local encoded = json.encode(newData)
                        _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
        
                        player_database:Buy_New_Spell_with_steamID(nPlayerID,encoded,goods.cost_class,later_gold,spellname)  --额外传入金币与技能名 当购买成功后可以直接修改数据 不需要重新登陆
    
                        print("tye buy")
                        
                    else --金币不足以购买技能书
                        Notifications:Top(nPlayerID, { text = "#Black_Market_spell_buy_failed_not_enough_good", duration = 4, style = { color = "red" } })
                        EmitSoundOnClient("General.Cancel", player)
                    end
    
                    
                end
                
            end
        end

       


--------------------------------------------------------------------
        return --返回便可以不处理其他操作了
    end

    if event_data.type==1  then  --处理特权商品

        if   goods.cost_class==2 then--白金消费
            local cost =goods.cost--（花费）
            local target = goods.item_name  --由于永久跟30天不是一个名 需要获取一次
            -- spellname（技能名）

            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表


        
           
            if spellmap.vip[target] then  --说明这项特权已经激活

                 --判断是否是永久特权
                local endday = spellmap.vip[target].endday
                local date = "2099-01-01 00:00:00"
                local res = Comparison_time(endday,date)
                if res==true then --永久特权无需重复购买
                    Notifications:Top(nPlayerID, { text = "#vip_buy_failed_forever", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                else
                    local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
                    if now_platinum>=cost  then --满足条件 尝试购买
                        local later_platinum = now_platinum-cost  --修改后的白金

                        local newData = {}
                        -- newData.playerInfo = {}
                        -- newData.playerInfo.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                        -- newData.playerInfo.platinum = tostring(later_platinum)
    

                        newData.privilegeName = target
                        newData.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
                        newData.addDay = goods.addday
                        newData.platinum = tostring(later_platinum)
    

                        newData.token = _G.GAME_GLOBAL_KEY  --合法性
                        --转换格式 发送数据包
                        local encoded = json.encode(newData)
                        _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                        player_database:BuyPrivilege_with_steamID(nPlayerID,encoded,goods.cost_class,later_platinum,target)  --额外传入金币与技能名 当购买成功后可以直接修改数据 不需要重新登陆
    
                        print("tye buy")
                        
                    else --白金不足以购买技能书
                        Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                        EmitSoundOnClient("General.Cancel", player)
                    end
                end
                
                

            else
                local now_platinum = spellmap.playerinfo.platinum  --拿到当前的白金
                if now_platinum>=cost  then --满足条件 尝试购买
                    local later_platinum = now_platinum-cost  --修改后的白金

                    local newData = {}
                    -- newData.playerInfo = {}
                    -- newData.playerInfo.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                    -- newData.playerInfo.platinum = tostring(later_platinum)


                    newData.privilegeName = target
                    newData.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
                    newData.addDay = goods.addday
                    newData.platinum = tostring(later_platinum)
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    --转换格式 发送数据包
                    local encoded = json.encode(newData)
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:BuyPrivilege_with_steamID(nPlayerID,encoded,goods.cost_class,later_platinum,target)  --额外传入金币与技能名 当购买成功后可以直接修改数据 不需要重新登陆

                    print("tye buy")
                    
                else --白金不足以购买技能书
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end

                
            end
            
        end

        
    end



    if event_data.type==2  then  --处理特殊技能

        if not goods then
            -- 找不到默认是100白金
            goods = {
                item_name= spellname,
                cost_class = 2,
                cost=100,
            }
        end
        if   goods.cost_class==2 then--白金消费
            local cost =goods.cost--（花费）
            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
            if not spellmap then
                return
            end

        
            if spellmap.spells[spellname] then  --说明这个技能已经解锁了
                -- print("buy failed because already learned")
                Notifications:Top(nPlayerID, { text = "#Black_Market_spell_buy_failed_mastered", duration = 4, style = { color = "red" } })
                EmitSoundOnClient("General.Cancel", player)

            else
                local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
                if now_platinum>=cost  then --满足条件 尝试购买
                    local later_platinum = now_platinum-cost  --修改后的白金

                    local newData = {}

                    newData.playerInfo = {}
                    newData.playerInfo.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                    newData.playerInfo.platinum = tostring(later_platinum)

                    newData.playerSpellsList = {}
                    local newtable = {}
                    newtable.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
                    newtable.spellName = spellname
                    newtable.exp = 0
                    table.insert(newData.playerSpellsList, newtable)
                    
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    --转换格式 发送数据包
                    local encoded = json.encode(newData)
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:Buy_New_Spell_with_steamID(nPlayerID,encoded,goods.cost_class,later_platinum,spellname)  --额外传入金币与技能名 当购买成功后可以直接修改数据 不需要重新登陆

                    print("tye buy")
                    
                else --白金不足以购买技能书
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end

                
            end
            
        end

        
    end

    -- print("event_data.type=",event_data.type)
    -- print("goods.goods_class=",goods.goods_class)
    if event_data.type==4  then  --处理其他商品

        --白金换可靠经验
        if goods.goods_class==TYPE_BUY_EXP then

            if   goods.cost_class==2 then--白金消费
                local cost =goods.cost--（花费）
                -- spellname（技能名）
    
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
                if now_platinum>=cost  then --满足条件 尝试购买
                    local newData = {
                        token = _G.GAME_GLOBAL_KEY,  --合法性
                        playerInfo = {
                            steamId =  tostring(PlayerResource:GetSteamID(nPlayerID)),
                            platinum = -cost,
                            reliableExp = goods.bonus,
                            gold = 0,
                        }
                    }
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:Currency_Exchange_with_steamID__New(nPlayerID,newData)  

                    print("tye buy")
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
    
         

           
                
            end


            if   goods.cost_class==1 then--金币消费
                local cost =goods.cost--（花费）
                -- spellname（技能名）
    
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_gold = tonumber(spellmap.playerinfo.gold)  --拿到当前的金币
                if now_gold>=cost  then --满足条件 尝试购买
                    local newData = {
                        token = _G.GAME_GLOBAL_KEY,  --合法性
                        playerInfo = {
                            steamId =  tostring(PlayerResource:GetSteamID(nPlayerID)),
                            platinum = 0,
                            reliableExp = goods.bonus,
                            gold = -cost,
                        }
                    }
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:Currency_Exchange_with_steamID__New(nPlayerID,newData)  









                    print("tye buy")
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Black_Market_spell_buy_failed_not_enough_good", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
    
         

           
                
            end
        

        --购买技能书
        elseif goods.goods_class==TYPE_BUY_Spell_Book then  
            if   goods.cost_class==2 then--白金消费
                local cost =goods.cost--（花费）

    
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                if not spellmap then
                    return
                end
                local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
                if now_platinum>=cost  then --满足条件 尝试购买
                    -- local later_platinum = now_platinum-cost  --修改后的白金
                    -- local later_exp = spellmap.playerinfo.reliableExp  + goods.bonus  --修改后经验值
                    -- local later_gold = spellmap.playerinfo.gold               
                    game_event:BuySpellBonus(nPlayerID,goods.bonus,cost)
                    print("tye buy")
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
    
         

           
                
            end
        elseif goods.goods_class==TYPE_BUY_Aurum then
            if   goods.cost_class==2 then--白金消费
                local cost =goods.cost--（花费）
                -- spellname（技能名）
    
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
                if now_platinum>=cost  then --满足条件 尝试购买
                    local newData = {
                        token = _G.GAME_GLOBAL_KEY,  --合法性
                        playerInfo = {
                            steamId =  tostring(PlayerResource:GetSteamID(nPlayerID)),
                            platinum = -cost,
                            reliableExp = 0,
                            gold = goods.bonus,
                        }
                    }
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:Currency_Exchange_with_steamID__New(nPlayerID,newData)  


                    print("tye buy")
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
    
         

           
                
            end
        elseif goods.goods_class==TYPE_BUY_CORE then
            if   goods.cost_class==TYPE_COST_Platinum then--白金消费
                local cost =goods.cost--（花费）
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
                if now_platinum>=cost  then --满足条件 尝试购买
                    local later_platinum = now_platinum-cost  --修改后的白金
                    local later_exp = spellmap.playerinfo.reliableExp    --修改后经验
                    -- local later_gold = spellmap.playerinfo.gold  + goods.bonus         --修改后金币
                    local bonus_count = goods.bonus  --原石数量
                    local coreID = RandomInt(1, 3)
                   

  
                    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                    local currentNumber = 0
                    --取得当前的原石数量
                    local coreTarget = "core"..coreID
                    currentNumber = spellmap.playerinfo[coreTarget]
                    local newData = {}
                    newData.playerInfo = {}
                    newData.playerInfo.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                    newData.playerInfo[coreTarget] = currentNumber+bonus_count
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    newData.playerInfo.platinum = tostring(later_platinum)
                    newData.playerInfo.reliableExp = tostring(later_exp)
                    -- newData.playerInfo.gold = tostring(later_gold)
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    --转换格式 发送数据包
                    local encoded = json.encode(newData)
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:PlayerBuyCore(nPlayerID,encoded,coreTarget,bonus_count,later_platinum,later_exp)  

                    print("tye buy")
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
    
         

           
                
            elseif  goods.cost_class==TYPE_COST_EXP then
                local cost =goods.cost--（花费）
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_reliableExp= tonumber(spellmap.playerinfo.reliableExp)  --拿到当前的经验
                if now_reliableExp>=cost  then --满足条件 尝试购买
                    local later_platinum = tonumber(spellmap.playerinfo.platinum) --修改后的白金
                    local later_exp = now_reliableExp - cost    --修改后经验
                    -- local later_gold = spellmap.playerinfo.gold  + goods.bonus         --修改后金币
                    local bonus_count = goods.bonus  --原石数量
                    local coreID = RandomInt(1, 3)
                   

  
                    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                    local currentNumber = 0
                    --取得当前的原石数量
                    local coreTarget = "core"..coreID
                    currentNumber = spellmap.playerinfo[coreTarget]
                    local newData = {}
                    newData.playerInfo = {}
                    newData.playerInfo.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                    newData.playerInfo[coreTarget] = currentNumber+bonus_count
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    newData.playerInfo.platinum = tostring(later_platinum)
                    newData.playerInfo.reliableExp = tostring(later_exp)
                    -- newData.playerInfo.gold = tostring(later_gold)
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    --转换格式 发送数据包
                    local encoded = json.encode(newData)
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:PlayerBuyCore(nPlayerID,encoded,coreTarget,bonus_count,later_platinum,later_exp)  

                    print("tye buy")
                    
                else --经验不足以购买
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_exp", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
            end
        elseif goods.goods_class==TYPE_BUY_ParticleEffect then
            if   goods.cost_class==TYPE_COST_Platinum then--白金消费
                local cost =goods.cost--（花费）
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金

                local pos = particleManager:GetTablePos(spellmap,goods.item_name)

                if pos.ParticleSet[goods.item_name] then
                    local endday =  pos.ParticleSet[goods.item_name]

                    local date = "2099-01-01 00:00:00"
                    local res = Comparison_time(endday,date)
                    if res==true then --永久无需重复购买
                        Notifications:Top(nPlayerID, { text = "#particle_buy_failed_forever", duration = 4, style = { color = "red" } })
                        EmitSoundOnClient("General.Cancel", player)
                        return

                    end
                end
          
                if now_platinum>=cost  then --满足条件 尝试购买
                    local later_platinum = now_platinum-cost  --修改后的白金
                    -- local later_exp = spellmap.playerinfo.reliableExp    --修改后经验
                    -- local later_gold = spellmap.playerinfo.gold        --修改后金币
                    local newData = {}
                    newData = {}
                    newData.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
                    newData.specialEffectName = goods.item_name
                    local particleType = particleManager:GetParticleTypeIndex( goods.item_name)
                    if particleType==-1  then
                        print("Error:购买特效类型错误")
                        return
                    end
                    newData.specialEffectType = particleType
                    newData.addDay = goods.bonus or 36500
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    newData.platinum = tostring(later_platinum)
                    -- newData.gold = tostring(later_platinum)
                    newData.token = _G.GAME_GLOBAL_KEY  --合法性
                    --转换格式 发送数据包
                    local encoded = json.encode(newData)
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    player_database:BuyParticleEffect_with_steamID(nPlayerID,encoded,later_platinum,nil)  

                    print("tye buy")
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
            end
        elseif goods.goods_class==TYPE_BUY_Rune then
            -- print("goods.cost_class=",goods.cost_class)
            if   goods.cost_class==TYPE_COST_Platinum then--白金消费
                -- print("bbaaccc")
                local cost =goods.cost--（花费）
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                local now_platinum = tonumber(spellmap.playerinfo.platinum)  --拿到当前的白金
                -- print("gggggggg")
                if now_platinum>=cost  then --满足条件 尝试购买
                    -- local later_platinum = now_platinum-cost  --修改后的白金
                    -- local later_exp = spellmap.playerinfo.reliableExp    --修改后经验
                    -- local later_gold = spellmap.playerinfo.gold        --修改后金币
                    -- print("cost=",cost)
                    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
                    local data ={
                        token = _G.GAME_GLOBAL_KEY,  --合法性
                        runeInfos={},
                        playerInfo ={
                            steamId = steamID,
                            platinum=-cost,
                            reliableExp = 0,
                            gold = 0,
                        }
                    }
                    local count = tonumber(goods.bonus)
                    local currentRarity = 5
                    local spell_level = tonumber(goods.level)
                    local level3_count = 0
                    local level4_count = 0
                    local level5_count = 0
                    for i = 1, count, 1 do
                        if goods.level5_chance>=RandomInt(1, 100) then
                            level5_count = level5_count + 1
                        end
                    end
                    level5_count = math.max(level5_count,goods.level5_min)
                    for i = 1, count-level5_count, 1 do
                        if goods.level4_chance>=RandomInt(1, 100) then
                            level4_count = level4_count + 1
                        else
                            level3_count = level3_count + 1
                        end
                    end

                    for i = 1, level3_count, 1 do
                        local name = chaotic_era:GetRandomSpellNameWithLevel(spell_level,false,false)
                        chaotic_era:CreateRune__WithName(data,nPlayerID,3,name)
                    end
                    for i = 1, level4_count, 1 do
                        local name = chaotic_era:GetRandomSpellNameWithLevel(spell_level,false,false)
                        chaotic_era:CreateRune__WithName(data,nPlayerID,4,name)
                    end
                    for i = 1, level5_count, 1 do
                        local name = chaotic_era:GetRandomSpellNameWithLevel(spell_level,false,false)
                        chaotic_era:CreateRune__WithName(data,nPlayerID,5,name)
                    end
                    
                   
                    local encoded = json.encode(data)
                    _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
                    print("tye buy")

                    chaotic_era:SaveNewRune(nPlayerID,encoded,function (runeInfos)
                        -- updateFinish(runeInfos)
                        local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
                        map.playerinfo.platinum = tonumber(map.playerinfo.platinum) -cost
                        _G.GAME_CAN_BUY[nPlayerID] = true
                        local player = PlayerResource:GetPlayer(nPlayerID) 
                        Notifications:Top(nPlayerID, { text = "#buy_BuySpellsSuccessed", duration = 4, style = { color = "white" } })
                        EmitSoundOnClient("DOTAMusic_PLUS_ONE", player)
                        local runeList = chaotic_era:UpdateRuneData(nPlayerID,runeInfos)
                        local data = {
                            sMessage={},
                            playerinfo = {
                                reliableExp = 0,
                                gold = 0,
                            },
                            runeList = runeList,
                        }

                    
                        CustomGameEventManager:Send_ServerToPlayer(player, "SetBonus", data)  --给出奖励提示
                        CustomGameEventManager:Send_ServerToPlayer(player, "BuySpellSuccessFeedback", {}) --强制刷新


                    end)


                    -- player_database:BuyParticleEffect_with_steamID(nPlayerID,encoded,later_platinum,nil)  

                    
                    
                else --白金不足以购买
                    Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
                    EmitSoundOnClient("General.Cancel", player)
                end
            end
        end



        
    end


end

--创建dps
function uimanager:_Create_DPS(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id

    local player = PlayerResource:GetPlayer(nPlayerID) 

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        if steamID ~= "0" then
            CustomGameEventManager:Send_ServerToPlayer(player, "game_begin", {name = PlayerResource:GetSelectedHeroName(nPlayerID), id = nPlayerID})

        end
    end
   
end





function uimanager:_UpdateGameWave(eventSourceIndex, event_data)
    -- print("更新一下")
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local gameWave_index = 1
    if IsInToolsMode() then
        gameWave_index = _G.GAME_ROUND
    end
    if _G.GAME_ROUND<math.max(_G.GAME_END_WAVE,10) then
        -- local ID_next = _G.GAME_Units[gameWave_index].waveID
        -- if _G.GAME_ROUND==0 then --第一波不应为哥布林提示 修复这个问题
            ID_next = _G.GAME_Units[1].waveID
        -- end
        
        event_data2 = {
            encounter_name = _G.GAME_MAP_WAVE_Localize[_G.GAME_MAP_NAME]..ID_next,
        }
    end

    if _G.GAME_ROUND<math.max(_G.GAME_END_WAVE,10) then
        CustomGameEventManager:Send_ServerToPlayer(player, "GetNextWaveName", {event_data2})
    else
        CustomGameEventManager:Send_ServerToPlayer(player, "HideNextWaveName", {})
    end


   
end






-- 检查玩家是否有奖励
function uimanager:_CheckPlayerBonus(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
  

    player_database:CheckBonus_with_steamID(nPlayerID)
   
end



function uimanager:_GetPlayerBonus(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local bonusID  =event_data.bonusID
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap  

    -- PrintTable(spellmap[nPlayerID].bonus)
    if spellmap[nPlayerID].bonus[tonumber(bonusID)] then
        player_database:GetReward_with_steamID(nPlayerID,bonusID) 
    end
   
end


--获取玩家的数据表 包含更新作用 获取完返回给js
function uimanager:_GetFreeSpells(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local freeSpellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.freeSpellMap  --获取到数据表

    --反馈技能表
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "GetFreeSpellFeedback", { spellmap=freeSpellMap})
   
end



_G.Game_Get_GAMEInfo = false

--获取排行榜数据
function uimanager:_CheckGameInfo(eventSourceIndex, event_data)
    if not _G.Game_Get_GAMEInfo then
        _G.Game_Get_GAMEInfo = true
        player_database:GetContestInfo()
    elseif player_database.gameInfo then
        CustomGameEventManager:Send_ServerToAllClients("GetGameInfoFeedBack", {player_database.gameInfo})
    end
   
end

_G.Game_GettTeamData = {

}

--获取特定队伍游戏数据
function uimanager:_GetTeamDataByID(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local teamID = event_data.teamID
    if not _G.Game_GettTeamData[teamID] then
        _G.Game_GettTeamData[teamID] = true
        player_database:GetTeamDataByID(nPlayerID,teamID)
    elseif player_database.gameTeamData[teamID] then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "GetTeamDataFeedBack", { player_database.gameTeamData[teamID]})
    end
   
end

Cost_Table = {
    7000,
    13000,
    19000,
}

_G.CORE_CHANCE = 3 --全局可购买次数
_G.CORE_current_count = 0
--尝试购买原石
function uimanager:_TryGetCore(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local coreID = tonumber(event_data.coreID)
    local Core_Cost = Cost_Table[math.min(_G.CORE_current_count+1,3)]

    local player = PlayerResource:GetPlayer(nPlayerID)
    if  GetWhitelist(nPlayerID) then
        local playerHero = player:GetAssignedHero() --拿到英雄
        if playerHero then
            if coreID== 1 then
                playerHero:AddItemByName("item_hd_the_first_core")
            elseif coreID== 2 then
                playerHero:AddItemByName("item_hd_the_second_core")
            else
                playerHero:AddItemByName("item_hd_the_third_core")
            end
            return

        end

    end
    if _G.GAME_CAN_BUY[nPlayerID]==false then --互斥操作 当前无法购买物品
        Notifications:Top(nPlayerID, { text = "#buy_failed_Order_not_completed", duration = 4, style = { color = "red" } })
        EmitSoundOnClient("General.Cancel", player)
        return
    end
    if _G.GAME_CHANLLENGE_Contest_Type>=1 then
        SendCustomErrorToPlayer(nPlayerID,"Market_Core_buy_failed_difficulty","General.Cancel")
        return
    end

    if player and PlayerResource:HasSelectedHero(nPlayerID) then
        local playerHero = player:GetAssignedHero() --拿到英雄
        --检查是否在乱纪元模式下，是的话就没有必要继续了
        if Game_State:IsInChaoticEra() then
            SendCustomErrorToPlayer(nPlayerID,"Market_Core_buy_failed_in_chaotic_era","General.Cancel")
            return
        end
        --不是乱纪元模式，检查购买次数是否剩余
        local chance = _G.CORE_CHANCE
        if _G.CORE_CHANCE_bonus then
            chance = chance + _G.CORE_CHANCE_bonus
        end
        if _G.CORE_current_count>=chance then --没有剩余购买次数
            SendCustomErrorToPlayer(nPlayerID,"Market_Core_buy_failed_no_core_chance","General.Cancel")
            return
        end
        --先查看是否有足够的原石
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
        local currentNumber = 0
        if coreID>3 or coreID<1 then
            print("Error:ID不合法")
            return
        end
        --取得当前的原石数量
        local coreTarget = "core"..coreID
        currentNumber = spellmap.playerinfo[coreTarget]

        if currentNumber>=1  then --满足条件 尝试购买
            --接着判断消耗金额
            if playerHero:GetGold()<Core_Cost then
                SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
                --金币不足
                return
            end
            --通过 发送请求
            local later_core_number = currentNumber-1  --修改后的原石数量

            local newData = {}

            newData.playerInfo = {}
            newData.playerInfo.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
            newData.playerInfo[coreTarget] = later_core_number
            newData.token = _G.GAME_GLOBAL_KEY  --合法性
            --转换格式 发送数据包
            local encoded = json.encode(newData)
            _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
            player_database:SendGetAghanimCore(nPlayerID,encoded,playerHero,coreTarget,Core_Cost)  --额外传入金币与技能名 当购买成功后可以直接修改数据 不需要重新登陆
            -- print("tye buy")
            
        else --原石不足
            SendCustomErrorToPlayer(nPlayerID,"Market_Core_buy_failed_no_core","General.Cancel")
            -- Notifications:Top(nPlayerID, { text = "#Market_spell_buy_failed_not_enough_platinum", duration = 4, style = { color = "red" } })
            -- EmitSoundOnClient("General.Cancel", player)
        end

    end
   
end




function uimanager:BonusCore()
    --计算完毕 开始选择幸运玩家
    local bonusTable = {}
    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        local player = PlayerResource:GetPlayer(nPlayerID)
        if player and steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED  and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_DISCONNECTED   then
            --如果该名玩家在游戏内
            table.insert(bonusTable,nPlayerID)
        end
    end
    if #bonusTable<=0 then
        print("Error:没有任何玩家？")
        return
    end
    local target = bonusTable[RandomInt(1, #bonusTable)] --幸运玩家产生了
    local player = PlayerResource:GetPlayer(target)
    local unit = player:GetAssignedHero() --拿到英雄
    local gameEvent = {}
    local coreID = "core"..RandomInt(1, 3)
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
  
    gameEvent["player_id"] = target
    gameEvent["teamnumber"] = -1
    
    gameEvent["message"] = "#DOTA_HUD_PLAYER_GET_CORE_in_game"..RandomInt(1, 4)
    FireGameEvent( "dota_combat_event_message", gameEvent )
end

function uimanager:_CheckWave(eventSourceIndex, event_data)
    if _G.GAME_DIFFICULTY<=0 then
        return
    end
    local nPlayerID = event_data.player_id
    local sendInfo = 0
    if not _G.GAME_Hide_select then
        sendInfo = 1
    end
    local index = GetChallengeDifficulty()+_G.GAME_DIFFICULTY
    if _G.GAME_CHANLLENGE_Contest_Type>=2 then
        index = index +1
    end
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    if _G.GAME_Reincarnation_Wave>=1 then
        CustomGameEventManager:Send_ServerToPlayer(player, "SetDifficultyInfo", {  index = 9,wave=_G.GAME_Reincarnation_Wave,sendInfo = sendInfo})
    else
        CustomGameEventManager:Send_ServerToPlayer(player, "SetDifficultyInfo", {  index = index,sendInfo=sendInfo})
    end

    if _G.GAME_ROUND<_G.GAME_END_WAVE then
        local gameWave_index = 1
        if IsInToolsMode() or _G.GAME_debugTesting then
            gameWave_index = _G.GAME_ROUND
        end
        local ID_next = _G.GAME_Units[gameWave_index+1].waveID
        local event_data2 = {
            encounter_name = _G.GAME_MAP_WAVE_Localize[_G.GAME_MAP_NAME]..ID_next,
        }
        CustomGameEventManager:Send_ServerToPlayer(player, "GetNextWaveName", {event_data2})
    else

        CustomGameEventManager:Send_ServerToPlayer(player, "HideNextWaveName", {})
    end

    local event_data = {
        encounter_ROUND = _G.GAME_ROUND,
    }

    CustomGameEventManager:Send_ServerToPlayer(player, "setWave", {event_data})

end











function uimanager:CloseGameLoadingBG()
    CustomGameEventManager:Send_ServerToAllClients("CloseLoadingBG", {})
end

function uimanager:SendLoginProgress()
    local playerCount = GetPlayerCount()
    local loginCount = GetLoginPlayerCount()
    local data = {
        playerCount =playerCount,
        loginCount = loginCount,
        finish_all = 0,
    }
    -- if playerCount<=loginCount then
    --     -- Convars:SetFloat("host_timescale", 1) 
    -- end
    -- CustomGameEventManager:Send_ServerToAllClients("UpdateLoginProgress", {data})
    if IsAllPlayerLoginFinish() then
        data.finish_all = 1

        -- Timers:CreateTimer(0.5, function()
        --     print("close all")
        --     CustomGameEventManager:Send_ServerToAllClients("CloseLoadingBG", {})
        -- end)
    end

    CustomNetTables:SetTableValue( "game_config", "player_login", data )


end

function uimanager:_CheckGameLoadingBG(eventSourceIndex, event_data)
    if not IsAllPlayerLoginFinish() then
       return 
    end
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "CloseLoadingBG", {})

end




return uimanager