

challenge = challenge or class({})
print("challenge load....", IsServer())

require("internal/timers")
function challenge:init(bReload)
    

    
    if not bReload then
    
        -- KeyValues.challenge_info
        self.Challenge_Info = {}
        self.challengeSelectList = {} --玩家的苦难表
        self:InitChallenge_Info()
    end


    CustomUIEvent("Checkchallenge", Dynamic_Wrap(self, "_Checkchallenge"), self)
    CustomUIEvent("TargetSelected", Dynamic_Wrap(self, "_TargetSelected"), self)
    -- LOCAL_DEBUG_TOOLS_CHALLENGE_LISTENER
    CustomUIEvent("TryReRollChallenge", Dynamic_Wrap(self, "_TryReRollChallenge"), self)
 

    -- CustomGameEventManager:RegisterListener("Checkchallenge", function(...)
    --     return self:_Checkchallenge(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("TargetSelected", function(...)
    --     return self:_TargetSelected(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("TargetSelected_Debug", function(...)
    --     return self:_TargetSelected_Debug(...)
    -- end)

    
    -- CustomGameEventManager:RegisterListener("TryReRollChallenge", function(...)
    --     return self:_TryReRollChallenge(...)

    -- end)

 
    
end






LOGIC_TYPE = {
    Apply_Modifier_Self = 1,
    Apply_Modifier_All_Heroes =2,
    Apply_Modifier_All_Heroes_Special = 3,
    Apply_Modifier_Enemy = 4,
}


function challenge:InitChallenge_Info()
    local challengeList = KeyValues.challenge_info
    for key, value in pairs(challengeList) do
        for i = 1, 5, 1 do
            local keyName = "level"..i
            if value[keyName] and  value[keyName]>=1 then
                local challengeName = key.."_"..i
                self.Challenge_Info[challengeName] = {
                    type = LOGIC_TYPE[value.type],
                    bonus =  GetValueWithLevel(value.bonus, i)
                }
            end
           

        end
    end

    -- DeepPrint( self.Challenge_Info)

end


function challenge:GetChallengeInfo(challengeName)
    local table = self.Challenge_Info[challengeName]
    return table
end






function GetValueWithLevel(specialValue, level)
    if type(specialValue) == "string" then
        local value = {}
        for token in specialValue:gmatch("%S+") do
            table.insert(value, token)
        end
        return value[math.min(level, #value)]
    else
        return specialValue
    end
end

function challenge:OnDifficultySelected()
    if Game_State:IsInChaoticEra() then
        return
    end
    local heroes = GetAllRealHeroes()
    if _G.GAME_DIFFICULTY>=4 then
        -- local heroes = GetAllRealHeroes()
        for _, unit in ipairs(heroes) do
            SpawnChallenge(unit:GetPlayerID())
        end
    end

end

-- 初始化特定玩家的苦难表
function challenge:InitChallengeListForPlayer(nPlayerID)
    if  self.challengeSelectList[nPlayerID] then
        return  self.challengeSelectList[nPlayerID]
    end
    -- 难度1到难度5
    self.challengeSelectList[nPlayerID] ={
        {},
        {},
        {},
        {},
        {},
    }
    -- <TODO:应用权重表>
    local challengeList = KeyValues.challenge_info
    for i = 1, 5, 1 do
        -- local totalWeight = 0  --总权重
        local keyName = "level"..i
        for key, value in pairs(challengeList) do
            if value[keyName] and  value[keyName]>=1 then
                local challengeName = key.."_"..i

                -- totalWeight = totalWeight + value.weight
                self.challengeSelectList[nPlayerID][i][challengeName] = {
                    weight = value.weight,
                    wave_require = value.wave_require or -1,
                    -- weightRequire = totalWeight  
                }
            end
        end
    end



end

-- 生成苦难
function challenge:SpawnSingleChallengeForPlayer(nPlayerID,level)
    if not self.challengeSelectList[nPlayerID] then
        self:InitChallengeListForPlayer(nPlayerID) 
    end

    local bonusList = {}
    local totalWeight = 0 
    local wave = GetCurrentRound()
    for bonusName, value in pairs(self.challengeSelectList[nPlayerID][level]) do
        -- 需要满足到达回合需求 且在等级要求区间内

        if wave>=value.wave_require  then
            if value.weight and value.weight>0 then
                -- 满足所有条件 插入表
                local data = table.shallowCopy(value)
                data.name = bonusName
                totalWeight = totalWeight + value.weight
                data.weightRequire = totalWeight
                -- bonusList[bonusName] =  table.shallowCopy(value)
                table.insert(bonusList,data)
                
                -- bonusList[bonusName].weightRequire = totalWeight  --生成时使用
            end
        end
        
    end

    local iRandom = RandomInt(1, totalWeight) --生成权重
    for _, value in ipairs(bonusList) do
        if iRandom<=value.weightRequire then
            return value.name
            
        end
    end

    -- for bonusName, value in pairs(bonusList) do
    --     local iRandom = RandomInt(1, totalWeight) --生成权重
    --     if iRandom<=value.weightRequire then
    --         return bonusName
            
    --     end
    -- end
end


--类型
--type1  给自己加modifier
--type2  给所有友方英雄加modifier
--type3  给所有英雄加modifer 自身单独一个modifier结算

--type3  给敌人加buff
--type3  条件行为
--type4  产生精英怪

-- Challenge_Table = {
--     --难度1
--     {
--         "ChallengeInfo_001_1",
--         "ChallengeInfo_002_1",
--         "ChallengeInfo_003_1",
--         "ChallengeInfo_004_1",
--         "ChallengeInfo_005_1",
--         "ChallengeInfo_006_1",
--         "ChallengeInfo_007_1",
--         "ChallengeInfo_008_1",
--         "ChallengeInfo_009_1",
--         "ChallengeInfo_010_1",
--         "ChallengeInfo_011_1",
--         "ChallengeInfo_012_1",
--         "ChallengeInfo_013_1",
--         "ChallengeInfo_014_1",
--         "ChallengeInfo_015_1",
--         "ChallengeInfo_016_1",
--         "ChallengeInfo_017_1",
--         "ChallengeInfo_018_1",
--         "ChallengeInfo_019_1",
--         "ChallengeInfo_020_1",
--         "ChallengeInfo_021_1",
--         "ChallengeInfo_022_1",
--         "ChallengeInfo_023_1",
--         "ChallengeInfo_024_1",
--         "ChallengeInfo_025_1",
--         "ChallengeInfo_026_1",
--         "ChallengeInfo_027_1",
--         "ChallengeInfo_028_1",
--         "ChallengeInfo_029_1",
--         "ChallengeInfo_030_1",
--         "ChallengeInfo_031_1",
--         "ChallengeInfo_032_1",
--         "ChallengeInfo_033_1",
--         "ChallengeInfo_034_1",
--         "ChallengeInfo_035_1",
--         -- "ChallengeInfo_036_1",
--         "ChallengeInfo_037_1",
--         "ChallengeInfo_038_1",
--         "ChallengeInfo_039_1",
--         "ChallengeInfo_040_1",
--         "ChallengeInfo_041_1",
--         "ChallengeInfo_042_1",
--         "ChallengeInfo_043_1",
--         "ChallengeInfo_044_1",
--         "ChallengeInfo_045_1", 
--         "ChallengeInfo_046_1", 
--     },
--     --难度2
--     {
--         "ChallengeInfo_001_2",
--         "ChallengeInfo_002_2",
--         "ChallengeInfo_003_2",
--         "ChallengeInfo_004_2",
--         "ChallengeInfo_005_2",
--         "ChallengeInfo_006_2",
--         "ChallengeInfo_007_2",
--         "ChallengeInfo_008_2",
--         "ChallengeInfo_009_2",
--         "ChallengeInfo_010_2",
--         "ChallengeInfo_011_2",
--         "ChallengeInfo_012_2",
--         "ChallengeInfo_013_2",
--         "ChallengeInfo_014_2",
--         "ChallengeInfo_015_2",
--         "ChallengeInfo_016_2",
--         "ChallengeInfo_017_2",
--         "ChallengeInfo_018_2",
--         "ChallengeInfo_019_2",
--         "ChallengeInfo_020_2",
--         "ChallengeInfo_021_2",
--         "ChallengeInfo_022_2",
--         "ChallengeInfo_023_2",
--         "ChallengeInfo_024_2",
--         "ChallengeInfo_025_2",
--         "ChallengeInfo_026_2",
--         "ChallengeInfo_027_2",
--         "ChallengeInfo_028_2",
--         "ChallengeInfo_029_2",
--         "ChallengeInfo_030_2",
--         "ChallengeInfo_031_2",
--         "ChallengeInfo_032_2",
--         "ChallengeInfo_033_2",
--         "ChallengeInfo_034_2",
--         "ChallengeInfo_035_2",
--         -- "ChallengeInfo_036_2",
--         "ChallengeInfo_037_2",
--         "ChallengeInfo_038_2",
--         "ChallengeInfo_039_2",
--         "ChallengeInfo_040_2",
--         "ChallengeInfo_041_2",
--         "ChallengeInfo_042_2",
--         "ChallengeInfo_043_2",
--         "ChallengeInfo_044_2",
--         "ChallengeInfo_045_2",
--         "ChallengeInfo_046_2",
--     },
--     --难度3
--     {
--         "ChallengeInfo_001_3",
--         "ChallengeInfo_002_3",
--         "ChallengeInfo_003_3",
--         "ChallengeInfo_004_3",
--         "ChallengeInfo_005_3",
--         "ChallengeInfo_006_3",
--         "ChallengeInfo_007_3",
--         "ChallengeInfo_008_3",
--         "ChallengeInfo_009_3",
--         "ChallengeInfo_010_3",
--         "ChallengeInfo_011_3",
--         "ChallengeInfo_012_3",
--         "ChallengeInfo_013_3",
--         "ChallengeInfo_014_3",
--         "ChallengeInfo_015_3",
--         "ChallengeInfo_016_3",
--         "ChallengeInfo_017_3",
--         "ChallengeInfo_018_3",
--         "ChallengeInfo_019_3",
--         "ChallengeInfo_020_3",
--         "ChallengeInfo_021_3",
--         "ChallengeInfo_022_3",
--         "ChallengeInfo_023_3",
--         "ChallengeInfo_024_3",
--         "ChallengeInfo_025_3",
--         "ChallengeInfo_026_3",
--         "ChallengeInfo_027_3",
--         "ChallengeInfo_028_3",
--         "ChallengeInfo_029_3",
--         "ChallengeInfo_030_3",
--         "ChallengeInfo_031_3",
--         "ChallengeInfo_032_3",
--         "ChallengeInfo_033_3",
--         "ChallengeInfo_034_3",
--         "ChallengeInfo_035_3",
--         -- "ChallengeInfo_036_3",
--         "ChallengeInfo_037_3",
--         "ChallengeInfo_038_3",
--         "ChallengeInfo_039_3",
--         "ChallengeInfo_040_3",
--         "ChallengeInfo_041_3",
--         "ChallengeInfo_042_3",
--         "ChallengeInfo_043_3",
--         "ChallengeInfo_044_3",
--         "ChallengeInfo_045_3",
--         "ChallengeInfo_046_3",
--     },
--     --难度4
--     {
--         "ChallengeInfo_001_4",
--         "ChallengeInfo_002_4",
--         "ChallengeInfo_003_4",
--         "ChallengeInfo_004_4",
--         "ChallengeInfo_005_4",
--         "ChallengeInfo_006_4",
--         "ChallengeInfo_007_4",
--         "ChallengeInfo_008_4",
--         "ChallengeInfo_009_4",
--         "ChallengeInfo_010_4",
--         "ChallengeInfo_011_4",
--         "ChallengeInfo_012_4",
--         "ChallengeInfo_013_4",
--         "ChallengeInfo_014_4",
--         "ChallengeInfo_015_4",
--         "ChallengeInfo_016_4",
--         "ChallengeInfo_017_4",
--         "ChallengeInfo_018_4",
--         "ChallengeInfo_019_4",
--         "ChallengeInfo_020_4",
--         "ChallengeInfo_021_4",
--         "ChallengeInfo_022_4",
--         "ChallengeInfo_023_4",
--         "ChallengeInfo_024_4",
--         "ChallengeInfo_025_4",
--         "ChallengeInfo_026_4",
--         "ChallengeInfo_027_4",
--         "ChallengeInfo_028_4",
--         "ChallengeInfo_029_4",
--         "ChallengeInfo_030_4",
--         "ChallengeInfo_031_4",
--         "ChallengeInfo_032_4",
--         "ChallengeInfo_033_4",
--         "ChallengeInfo_034_4",
--         "ChallengeInfo_035_4",
--         -- "ChallengeInfo_036_4",
--         "ChallengeInfo_037_4",
--         "ChallengeInfo_038_4",
--         "ChallengeInfo_039_4",
--         "ChallengeInfo_040_4",
--         "ChallengeInfo_041_4",
--         "ChallengeInfo_042_4",
--         "ChallengeInfo_043_4",
--         "ChallengeInfo_044_4",
--         "ChallengeInfo_045_4",
--         "ChallengeInfo_046_4",
--     },
--     --难度5
--     {
--         "ChallengeInfo_001_5",
--         "ChallengeInfo_002_5",
--         "ChallengeInfo_003_5",
--         "ChallengeInfo_004_5",
--         "ChallengeInfo_005_5",
--         "ChallengeInfo_006_5",
--         "ChallengeInfo_007_5",
--         "ChallengeInfo_008_5",
--         "ChallengeInfo_009_5",
--         "ChallengeInfo_010_5",
--         "ChallengeInfo_011_5",
--         "ChallengeInfo_012_5",
--         "ChallengeInfo_013_5",
--         "ChallengeInfo_014_5",
--         "ChallengeInfo_015_5",
--         "ChallengeInfo_016_5",
--         "ChallengeInfo_017_5",
--         "ChallengeInfo_018_5",
--         "ChallengeInfo_019_5",
--         "ChallengeInfo_020_5",
--         "ChallengeInfo_021_5",
--         "ChallengeInfo_022_5",
--         "ChallengeInfo_023_5",
--         "ChallengeInfo_024_5",
--         "ChallengeInfo_025_5",
--         "ChallengeInfo_026_5",
--         "ChallengeInfo_027_5",
--         "ChallengeInfo_028_5",
--         "ChallengeInfo_029_5",
--         "ChallengeInfo_030_5",
--         "ChallengeInfo_031_5",
--         "ChallengeInfo_032_5",
--         "ChallengeInfo_033_5",
--         "ChallengeInfo_034_5",
--         "ChallengeInfo_035_5",
--         -- "ChallengeInfo_036_5",
--         "ChallengeInfo_037_5",
--         "ChallengeInfo_038_5",
--         "ChallengeInfo_039_5",
--         "ChallengeInfo_040_5",
--         "ChallengeInfo_041_5",
--         "ChallengeInfo_042_5",
--         "ChallengeInfo_043_5",
--         "ChallengeInfo_044_5",
--         "ChallengeInfo_045_5",
--         "ChallengeInfo_046_5",
--     },
  

-- }




if IsClient() then
    return
end


function challenge:_Checkchallenge(eventSourceIndex, event_data)
    if _G.GAME_DIFFICULTY<4 then
        return
    end
    local nPlayerID = event_data.player_id
    -- local player = PlayerResource:GetPlayer(nPlayerID)
    local cost = {}
    local bonus = {}
    local Challenge = Plyaer_Challenge_Table[nPlayerID]
    if not Challenge then
        return
    end
    for i = 1, 5, 1 do
        if Challenge[i] then
            table.insert(bonus,self:GetChallengeInfo(Challenge[i]).bonus)
        end
        
    end

    local chance = _G.Game_Challenge_ReRoll_chance[nPlayerID]
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "ShowChallenge", {  item =  Challenge,item_bonus=bonus,chance= chance})

end


--储存玩家的挑战列表，当玩家重连时重新显示
Plyaer_Challenge_Table = {
    {},
    {},
    {},
    {},
    {},
}
--储存玩家当前选择的试炼
_G.Player_Challenge_Select = {

}

--创建目标玩家的苦难列表
function SpawnChallenge(nPlayerID,pass)
    --奖励回合与最终回合结束不触发
    if _G.GAME_ROUND==9 or _G.GAME_ROUND==19 or _G.GAME_ROUND>=_G.GAME_END_WAVE then
        if not pass then
            return
        end
        
    end


    if not challenge.challengeSelectList[nPlayerID] then
        challenge:InitChallengeListForPlayer(nPlayerID)
    end

    
    local Challenge = {}
    -- local cost = {}
    local bonus = {}

    --产生五个随机的苦难
    for i = 1, 5, 1 do
        -- local target = Challenge_Table[i][RandomInt(1,#Challenge_Table[i] )]
        local target = challenge:SpawnSingleChallengeForPlayer(nPlayerID,i)
        table.insert(Challenge,target)
        table.insert(bonus,challenge:GetChallengeInfo(target).bonus)

        
    end
    Plyaer_Challenge_Table[nPlayerID] = Challenge --把生成的表储存起来

    local chance = _G.Game_Challenge_ReRoll_chance[nPlayerID]
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "ShowChallenge", { item =  Challenge,item_bonus=bonus,chance=chance})

end

--重新生成苦难
function ReSpawnChallenge(nPlayerID)
    --奖励回合与最终回合结束不触发
    -- if _G.GAME_ROUND==9 or _G.GAME_ROUND==19 or _G.GAME_ROUND>=_G.GAME_END_WAVE then
    --     return
    -- end
    
    local Challenge = {}
    -- local cost = {}
    local bonus = {}

    --产生五个随机的苦难
    for i = 1, 5, 1 do
        -- local target = Challenge_Table[i][RandomInt(1,#Challenge_Table[i] )]
        local target = challenge:SpawnSingleChallengeForPlayer(nPlayerID,i)
        table.insert(Challenge,target)
        table.insert(bonus,challenge:GetChallengeInfo(target).bonus)
    end








    Plyaer_Challenge_Table[nPlayerID] = Challenge --把生成的表储存起来

    local chance = _G.Game_Challenge_ReRoll_chance[nPlayerID]
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "ShowChallengeReroll", { item =  Challenge,item_bonus=bonus,chance=chance})

end





--玩家选择了一个苦难
function challenge:_TargetSelected(eventSourceIndex,event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if Game_State:IsInBattle() then
        Notifications:Top(nPlayerID, { text = "#Challenge_select_failed", duration = 4, style = { color = "red" } })
        EmitSoundOnClient("General.Cancel", player) 
        
    else
        local location_index= event_data.location_index
        local challenge_name = Plyaer_Challenge_Table[nPlayerID][location_index+1]

    
        _G.Player_Challenge_Select[nPlayerID] =challenge_name  --储存选择信息
  
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        
        if playerHero.currentShowCM then
            playerHero.currentShowCM:SafeDestroy()
            -- playerHero.currentShowCM = nil
        end

        local modifier = playerHero:AddNewModifier(playerHero, nil, "modifier_"..challenge_name.."_show", {})
        playerHero.currentShowCM = modifier
        CustomGameEventManager:Send_ServerToAllClients("ChallengeSelectUI", {name = PlayerResource:GetSelectedHeroName(nPlayerID), challenge_name = challenge_name,nPlayerID=nPlayerID,index = location_index})
        CustomGameEventManager:Send_ServerToPlayer(player, "ChallengeSelectSucess", { index = location_index})
    end
end

-- Debug 工具选择了苦难
-- LOCAL_DEBUG_TOOLS_CHALLENGE_HANDLER

function challenge:WaveEnd(hero)

    --苦难挑战结算
    --大部分结算都在此
    local tModifiers = hero:FindAllModifiers()
    -- print("查找buff")
    for _, hModifier in pairs(tModifiers) do
 
        if hModifier.OnChallengeWaveEnd ~= nil then
            -- print("触发结算")
            hModifier:OnChallengeWaveEnd() --触发状态结算

        end
    end


    --刷新状态
    -- hero:SetHealth(hero:GetMaxHealth())
    hero:ModifyHealth(hero:GetMaxHealth(),nil,false,0)
    hero:SetMana(hero:GetMaxMana())

    --奖励回合与最终回合结束不触发
    if _G.GAME_ROUND==9 or _G.GAME_ROUND==19 or _G.GAME_ROUND>=_G.GAME_END_WAVE then
        return
    end
    local nPlayerID = hero:GetPlayerID()
    local player = PlayerResource:GetPlayer(nPlayerID)
    _G.Player_Challenge_Select = {

    }
    CustomGameEventManager:Send_ServerToPlayer(player, "ChallengeSelectClear", {})
end



function challenge:_TryReRollChallenge(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local chance = _G.Game_Challenge_ReRoll_chance[nPlayerID]
        
    if chance>0 then
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
        if spellmap then
           local gold = tonumber(spellmap.playerinfo.gold)
           local cost = 10
            if gold>=cost then
                CAddonTemplateGameMode:ReRollChallengeByGold(nPlayerID,cost)
            else
                Notifications:Top(nPlayerID, { text = "#Spells_Menu_Insufficient_CP", duration = 2, style = { color = "red" } })
                challenge:reShowChallenge(nPlayerID)
            end
        end
        -- _G.Game_Item_ReRoll_chance[nPlayerID] = chance - 1
        -- BonusItems:SpawnBonusItems(nPlayerID,level)
    else
        challenge:reShowChallenge(nPlayerID)
    end

end



function challenge:reShowChallenge(nPlayerID)
    local bonus = {}
    local Challenge = Plyaer_Challenge_Table[nPlayerID]
    for i = 1, 5, 1 do
        table.insert(bonus,self:GetChallengeInfo(Challenge[i]).bonus)
    end

    
    local chance = _G.Game_Challenge_ReRoll_chance[nPlayerID]
    -- PrintTable(Challenge)

    -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "ShowChallenge", {  item =  Challenge,item_cost=cost,item_bonus=bonus})
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "ShowChallengeReroll", {  item =  Challenge,item_bonus=bonus,chance= chance})
    -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "SetDifficultyInfo", {  index = index})
end




function CAddonTemplateGameMode:ReRollChallengeByGold(playerid,gold)
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
        -- player_database:UpdateUserData_with_steamID_ReRollChallenge(nPlayerID,encoded,gold)
        gold = math.floor(gold)
        -- 先重随再扣除
        _G.Game_Challenge_ReRoll_chance[nPlayerID] = _G.Game_Challenge_ReRoll_chance[nPlayerID] - 1
        ReSpawnChallenge(nPlayerID)
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







LinkLuaModifier( "modifier_thinker_INVULNERABLE", "modifier/modifier_thinker_INVULNERABLE", LUA_MODIFIER_MOTION_NONE )


function challenge:OnWaveStart(hero)
    if Game_State:IsInChaoticEra() then
        -- 乱纪元没有苦难
        return
    end
    --奖励回合与最终回合不触发
    if _G.GAME_ROUND==9 or _G.GAME_ROUND==19 or _G.GAME_ROUND>=_G.GAME_END_WAVE then
        return
    end

    local nPlayerID = hero:GetPlayerID()
    local challengeName = _G.Player_Challenge_Select[nPlayerID]
    local player = PlayerResource:GetPlayer(nPlayerID)
    if challengeName then
        --处理苦难
        local ability = hero:FindAbilityByName("Default_Move")
        if ability and self:GetChallengeInfo(challengeName) then
            local gameEvent = {}
            gameEvent["player_id"] = hero:GetPlayerOwnerID()
            gameEvent["teamnumber"] = -1
            gameEvent["message"] = "#Player_Challenge"..RandomInt(1, 5)
            FireGameEvent( "dota_combat_event_message", gameEvent )
            local type = self:GetChallengeInfo(challengeName).type
            local switch = {
                [1] = function ()
                    local modifier_name = "modifier_"..challengeName
                    print("challenge="..modifier_name)
                    hero:AddNewModifier(hero, ability, modifier_name, {})
                end,


                [2] = function ()
                    local heroes = GetAllRealHeroes()
                    local modifier_name = "modifier_"..challengeName
                    print("challenge="..modifier_name)
                    for _, unit in ipairs(heroes) do
                        unit:AddNewModifier(unit, ability, modifier_name, {})
                    end
                end,

                [3] = function ()
                    local unit = CreateUnitByName("npc_fallenSky_unit", Vector(0,0,0), true, nil, nil, DOTA_MONSTER_TEAM_NUMBER)
                    unit:AddNewModifier(unit, nil, "modifier_thinker_INVULNERABLE", {})
                    local modifier_name = "modifier_"..challengeName
                    local modifier = hero:AddNewModifier(hero, ability, modifier_name, {})
                    modifier.caster = unit
                end,


                
            }
            local test = switch[type]
            if test then
                local result = test()
            end


            -- ChallengeInfo_009_4
            local string_list =  Split(challengeName, "_")
            local event_data = {
                unit = hero:entindex(),  
                difficulty =tonumber(string_list[3]),
                challengeName = challengeName,
            }
            FireGameEvent( "dota_hd_challenge_init", event_data )

            
        else
            print("error, cant find challenge from challenge_info")
        end
        
    end



end



-- function challenge:DebugToolSpawnChallenge()
--     -- local target = challenge:SpawnSingleChallengeForPlayer(nPlayerID,i)
--     return self:InitChallengeListForPlayer(1)
-- end






return challenge