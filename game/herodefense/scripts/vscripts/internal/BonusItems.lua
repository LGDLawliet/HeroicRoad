require("internal/timers")

BonusItems = BonusItems or class({})

print("BonusItems load....")
-- 技能不计入数量计算



function BonusItems:init(bReload)

    if not bReload then
        _G.Game_BONUS_ITEMS ={

        }
    end
    
 
    

    CustomUIEvent("BossRewardChosen", Dynamic_Wrap(self, "_BossRewardChosen_lua"), self)
	CustomUIEvent("CheckPendingBossReward", Dynamic_Wrap(self, "_CheckPendingBossReward"), self)
    CustomUIEvent("TryReRollItem", Dynamic_Wrap(self, "_TryReRollItem"), self)
    CustomUIEvent("GetItemList", Dynamic_Wrap(self, "_GetItemList"), self)
    CustomUIEvent("TryGetItemFromItemList", Dynamic_Wrap(self, "_TryGetItemFromItemList"), self)
    CustomUIEvent("ShouldGetItemList", Dynamic_Wrap(self, "_ShouldGetItemList"), self)

    -- CustomGameEventManager:RegisterListener("BossRewardChosen", function(...)
    --     return self:_BossRewardChosen_lua(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("CheckPendingBossReward", function(...)
    --     return self:_CheckPendingBossReward(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("TryReRollItem", function(...)
    --     return self:_TryReRollItem(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("GetItemList", function(...)
    --     return self:_GetItemList(...)
    -- end)

    -- CustomGameEventManager:RegisterListener("TryGetItemFromItemList", function(...)
    --     return self:_TryGetItemFromItemList(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("ShouldGetItemList", function(...)
    --     return self:_ShouldGetItemList(...)
    -- end)
    
end





--备注
--道具生成等级
--产生等级= (当前回合-1) /3.5 +1
-- 梯队       1             2               3                    4                     5              6
-- 梯队1     100%           65%             15%                  0%                    0%             0%
-- 梯队2      0%            35%             60%                  30%                   10%            0%
-- 梯队3      0%            0%              25%                  50%                   40%            20%
-- 梯队4      0%            0%              0%                   20%                   30%            35%
-- 梯队5      0%            0%              0%                   0%                    20%            45%

WAVE_Bonus_Items_Level_Chance = {
    {
        100,
        0,
        0,
        0,
        0,
        0,
    },

    {
        65,
        35,
        0,
        0,
        0,
        0
    },
    {
        15,
        60,
        25,
        0,
        0,
        0
    },
    {
        0,
        30,
        50,
        20,
        0,
        0
    },
    {
        0,
        10,
        40,
        30,
        20,
        0
    },
    {
        0,
        0,
        20,
        35,
        45,
        0
    },

}




--根据WAVE_Bonus_Items_Level_Chance与给出的奖励等级返还道具等级
function GiveRandomItemWithLevel(level)
    local bonus_level = WAVE_Bonus_Items_Level_Chance[level]  --level 1-6
    local random_index = RandomInt(1, 100)
    local now_index = 0

    -- print("bonus_level ="..#bonus_level)
    -- PrintTable(bonus_level)
    for i = 1, #bonus_level-1, 1 do
        now_index = now_index+bonus_level[i]
        if now_index>=random_index and random_index<=now_index+bonus_level[i+1] then
            print("return level with "..i)
            return i
        end
    end
    
end


--道具奖励生成
--基于当前波数 每5波一个梯队
function BonusItems:SpawnBonusItems(nPlayerID,level)
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    local items = {}
    local level_string = "level"
    local radndomselect = {
        "physical_weapon",
        "magical_weapon",
        "armor",
        "subsidiarity",
        "special",
    }
    local selectd = radndomselect[RandomInt(1, 5)]
    local random_bonus_level =""
    random_bonus_level = level_string..GiveRandomItemWithLevel(level)
    local itemData = {
        itemName = WAVE_Bonus_Items.physical_weapon[random_bonus_level][RandomInt(1, table.getn(WAVE_Bonus_Items.physical_weapon[random_bonus_level]))],
        itemType ="physical_weapon"
    }
    table.insert(items,itemData)--物理

    random_bonus_level = level_string..GiveRandomItemWithLevel(level)
    local itemData = {
        itemName = WAVE_Bonus_Items.magical_weapon[random_bonus_level][RandomInt(1, table.getn(WAVE_Bonus_Items.magical_weapon[random_bonus_level]))],
        itemType ="magical_weapon"
    }
    table.insert(items,itemData) --魔法

    random_bonus_level = level_string..GiveRandomItemWithLevel(level)
    local itemData = {
        itemName = WAVE_Bonus_Items.armor[random_bonus_level][RandomInt(1, table.getn(WAVE_Bonus_Items.armor[random_bonus_level]))],
        itemType ="armor"
    }
    table.insert(items,itemData)            --防御

    random_bonus_level = level_string..GiveRandomItemWithLevel(level)
    local itemData = {
        itemName = WAVE_Bonus_Items.subsidiarity[random_bonus_level][RandomInt(1, table.getn(WAVE_Bonus_Items.subsidiarity[random_bonus_level]))],
        itemType ="subsidiarity"
    }
    table.insert(items,itemData) --辅助


    local _level = GiveRandomItemWithLevel(level)
    random_bonus_level = level_string.._level

    local itemData = {
        itemName = WAVE_Bonus_Items.special[random_bonus_level][RandomInt(1, table.getn(WAVE_Bonus_Items.special[random_bonus_level]))],
        itemType ="special"
    }
    if 5>=RandomInt(1, 100) then
        -- 有几率变为箱子
        itemData = {
            itemName = "item_hd_Treasure".._level.."_oblation",
            itemType ="special"
        }
    end
    table.insert(items,itemData)  --特殊

    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    local viptable = spellmap[nPlayerID].vip  --属于这个玩家的VIP
    --冶金术额外的道具奖励
    --nPlayerID
    if viptable["Shop_Metallurgy"] then
        --生成额外奖励
        -- print("bonus item")
        random_bonus_level = level_string..GiveRandomItemWithLevel(level)
        local itemData = {
            itemName = WAVE_Bonus_Items[selectd][random_bonus_level][RandomInt(1, table.getn(WAVE_Bonus_Items[selectd][random_bonus_level]))],
            itemType =selectd
        }
        table.insert(items,itemData)  --额外的随机
    end
    local playerHero = player:GetAssignedHero()
    if playerHero then
        local modifier = playerHero:FindModifierByName("modifier_FellOmen_Good_12")
        if modifier then
            local chance = modifier.bonus
            if chance>=RandomInt(1, 100) then
                random_bonus_level = level_string..GiveRandomItemWithLevel(level)
                local itemData = {
                    itemName = WAVE_Bonus_Items[selectd][random_bonus_level][RandomInt(1, table.getn(WAVE_Bonus_Items[selectd][random_bonus_level]))],
                    itemType =selectd
                }
                table.insert(items,itemData)  --额外的随机
            end
        end
    end


    _G.Game_BONUS_ITEMS[nPlayerID] = {
        item = items,
        level = level,
    }



    -- PrintTable(items)
    CustomGameEventManager:Send_ServerToPlayer(player, "showBossRewards", { item =  items,level = level,chance = _G.Game_Item_ReRoll_chance[nPlayerID]})

end



function BonusItems:_CheckPendingBossReward(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    if _G.Game_BONUS_ITEMS[nPlayerID] then

        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "showBossRewards", { item =  _G.Game_BONUS_ITEMS[nPlayerID].item,level = _G.Game_BONUS_ITEMS[nPlayerID].level,chance = _G.Game_Item_ReRoll_chance[nPlayerID]})
    end

end


function BonusItems:_TryReRollItem(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    if _G.Game_BONUS_ITEMS[nPlayerID] then
        local chance = _G.Game_Item_ReRoll_chance[nPlayerID]
        
        if chance>0 then
            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
            if spellmap then
               local gold = tonumber(spellmap.playerinfo.gold)
               local cost = 10
               if gold>=cost then
                -- print("_G.Game_BONUS_ITEMS[nPlayerID].level=".._G.Game_BONUS_ITEMS[nPlayerID].level)
                    CAddonTemplateGameMode:ReRollItemByGold(nPlayerID,cost,_G.Game_BONUS_ITEMS[nPlayerID].level)
               else
                
                Notifications:Top(nPlayerID, { text = "#Spells_Menu_Insufficient_CP", duration = 2, style = { color = "red" } })
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "showBossRewards", { item =  _G.Game_BONUS_ITEMS[nPlayerID].item,level = _G.Game_BONUS_ITEMS[nPlayerID].level,chance=chance})
               end
            end
        else
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "showBossRewards", { item =  _G.Game_BONUS_ITEMS[nPlayerID].item,level = _G.Game_BONUS_ITEMS[nPlayerID].level,chance = chance})
        end
        -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "showBossRewards", { item =  _G.Game_BONUS_ITEMS[nPlayerID].item,level = _G.Game_BONUS_ITEMS[nPlayerID].level})
    end

end




--道具奖励选择
function BonusItems:_BossRewardChosen_lua(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if event_data.itemtype == "class" then
        local playerHero = player:GetAssignedHero()
        local item = playerHero:AddItemByName(event_data.itemname)
        return
    end

    if not player or not _G.Game_BONUS_ITEMS[nPlayerID] then  --已经选择过道具了
        return
    end

    -- PrintTable(_G.Game_BONUS_ITEMS[nPlayerID])
    local itemName
    local itemType
    -- for key, itemData in pairs(_G.Game_BONUS_ITEMS[nPlayerID]) do
    --     print("key="..key)
    --     print(_G.Game_BONUS_ITEMS[nPlayerID][key])
    --     -- print(itemData)
    --     -- print(itemData.itemName)
    --     -- print(event_data.itemname)
    --     -- if itemData.itemName==event_data.itemname then
    --     --     itemName = itemData.itemName
    --     --     itemType = itemData.itemType
    --     -- end
    -- end

    for _, itemData in ipairs(_G.Game_BONUS_ITEMS[nPlayerID].item) do
        -- print(itemData.itemName)
        -- print(event_data.itemname)
        if itemData.itemName==event_data.itemname then
            itemName = itemData.itemName
            itemType = itemData.itemType
            break
        end
    end
    if not itemName then
        return
    end
    -- print(itemName)
    -- print(itemType)

    _G.Game_BONUS_ITEMS[nPlayerID] = nil
    local playerHero = player:GetAssignedHero()
    local item = playerHero:AddItemByName(itemName)
    if item then
        item.itemType = itemType
    end

    -- print("player "..event_data.player_id.." get item: "..event_data.itemname)
    -- if item then
    --     print("cost == "..item:GetCost())
    -- end
end

function BonusItems:_GetItemList(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "SendItemList", WAVE_Bonus_Items)

end






function CAddonTemplateGameMode:ReRollItemByGold(playerid,gold,level)
    local nPlayerID = playerid
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    -- local player = PlayerResource:GetPlayer(nPlayerID)
    -- local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    -- local bonus_gold = gold
    if steamID ~= "0" then
        -- local index = nPlayerID
        -- local newData ={}
        -- newData.playerInfo = {}
        -- newData.playerInfo.steamId = steamID 
        -- local steamName = PlayerResource:GetSteamAccountID(nPlayerID)
        -- newData.playerInfo.steamName = steamName
        -- local infotable = spellmap[index].playerinfo  --属于这个玩家的表
        -- bonus_gold = bonus_gold -bonus_gold%1  --取整数
        -- local gold = infotable.gold - bonus_gold  
        -- newData.playerInfo.gold = tostring(gold)  --设置新金币
        -- newData.token = _G.GAME_GLOBAL_KEY
        -- local encoded = json.encode(newData)
        -- player_database:UpdateUserData_with_steamID_ReRollItems(nPlayerID,encoded,level,gold)




        -- 先重随机再扣除
        _G.Game_Item_ReRoll_chance[nPlayerID] = _G.Game_Item_ReRoll_chance[nPlayerID] - 1
        BonusItems:SpawnBonusItems(nPlayerID,level)
        local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
        map.playerinfo.gold = map.playerinfo.gold - gold


        local newData ={
            token= _G.GAME_GLOBAL_KEY,
            playerInfo = {
                steamId = tostring(PlayerResource:GetSteamID(nPlayerID)),
                steamName = PlayerResource:GetSteamAccountID(nPlayerID),
                gold =-gold,
            }
        }
        local encoded = json.encode(newData)
        player_database:UpdateUserData_with_steamID_ReRoll(encoded)

    end  
end


function BonusItems:_TryGetItemFromItemList(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then 
        return
    end
    local level = event_data.level
    local playerHero = player:GetAssignedHero()
    local pass = false

    local targetModifier = "modifier_item_hd_Treasure"..level.."_oblation"
    local modifier = playerHero:FindModifierByName(targetModifier)
    if modifier and modifier:OnCost()  then
        pass = true
        if modifier:GetStackCount()<=0 then
            modifier:SafeDestroy()
        end
        -- return
    end
    if not pass and GetWhitelist(nPlayerID) then
        pass = true
    end
   
    if pass then
        local item = playerHero:AddItemByName(event_data.itemname)
        if item then
            item.itemType = event_data.item_type
        end
    end


end


function BonusItems:_ShouldGetItemList(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)

    if player  then
        local playerHero = player:GetAssignedHero()
        if playerHero then
            -- if playerHero:HasModifier("modifier_novice_player") then
            --     -- 是新手玩家
            --     return
            -- end
            if tostring(PlayerResource:GetSteamID(nPlayerID))=="76561198284686620" then
                -- 暂时只给我自己发
                CustomGameEventManager:Send_ServerToPlayer(player, "ShouldGetItemList_feedback",{true})
            end
           
        end
    end
end


return BonusItems