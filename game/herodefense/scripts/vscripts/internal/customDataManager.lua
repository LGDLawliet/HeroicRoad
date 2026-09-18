
customDataManager = customDataManager or  class( { })

require('internal/timers')


function customDataManager:init(bReload)


    print("customDataManager init")
    if not bReload then
        self.customData = {}

        self.customData_ShouldSend = {} --记录自定义字段是否更新
        self.playerArtifactData = {}
    
    end
end




function customDataManager:InitCustomData(nPlayerID,dataTable)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    if not self.customData[steamID] then
        self.customData[steamID] = {}
    end
    if not self.customData_ShouldSend[steamID] then
        self.customData_ShouldSend[steamID] = {}
    end
    if not self.playerArtifactData[nPlayerID] then
        self.playerArtifactData[nPlayerID] = {}
    end
    if not dataTable then
        dataTable = {}
    end

    -- 将数组转化为表 更方便拿数据
    local dataList = {}
    for _, data in ipairs(dataTable) do
        dataList[data.customizeKey] = {
            valueOne = data.valueOne or nil,   
            valueTwo = data.valueTwo or nil,   
            customizeKey = data.customizeKey,  --领取的日期
            recordDate = data.recordDate,
            complete = data.complete,
        }
    end
    local dataAddress = self.customData[steamID]
    -- 进行配置

    -- 一般
    self:SetUpData("pass_diff_1",dataList,dataAddress)
    self:SetUpData("pass_diff_2",dataList,dataAddress)
    self:SetUpData("pass_diff_3",dataList,dataAddress)
    self:SetUpData("pass_diff_4",dataList,dataAddress)
    self:SetUpData("pass_diff_5",dataList,dataAddress)
    self:SetUpData("pass_diff_6",dataList,dataAddress)
    self:SetUpData("pass_diff_7",dataList,dataAddress)
    self:SetUpData("pass_diff_8",dataList,dataAddress)
 
    self:SetUpData("king_of_involution_1",dataList,dataAddress)
    self:SetUpData("king_of_involution_2",dataList,dataAddress)


    

    self:SetUpData("self_challenger_1",dataList,dataAddress)
    self:SetUpData("legend_talent_1",dataList,dataAddress)
    self:SetUpData("legend_talent_2",dataList,dataAddress)
    self:SetUpData("legend_talent_3",dataList,dataAddress)

    -- 击杀
    self:SetUpData("enemy_kill_1",dataList,dataAddress)
    self:SetUpData("enemy_kill_2",dataList,dataAddress)



    -- 特性
    self:SetUpData("summon_1",dataList,dataAddress)
    self:SetUpData("summon_2",dataList,dataAddress)
    self:SetUpData("summon_3",dataList,dataAddress)
    self:SetUpData("summon_4",dataList,dataAddress)


    self:SetUpData("idle_about_1",dataList,dataAddress)
    self:SetUpData("idle_about_2",dataList,dataAddress)
    self:SetUpData("idle_about_3",dataList,dataAddress)
    self:SetUpData("idle_about_4",dataList,dataAddress)

    self:SetUpData("core_collector_1",dataList,dataAddress)
    self:SetUpData("rich_guy_1",dataList,dataAddress)

    

    self:SetUpData("aurum_millionaire_1",dataList,dataAddress)
    self:SetUpData("exp_millionaire_1",dataList,dataAddress)
    self:SetUpData("platinum_millionaire_1",dataList,dataAddress)

    self:SetUpData("remain_uncorrupted_1",dataList,dataAddress)
    self:SetUpData("avatar_of_greed_1",dataList,dataAddress)
    self:SetUpData("the_strongest_spear_1",dataList,dataAddress)
    self:SetUpData("the_strongest_shield_1",dataList,dataAddress)
    self:SetUpData("the_strongest_heal_1",dataList,dataAddress)

  
    -- 特殊效果  乱纪元
    self:SetUpData_Str("artifact_best_backup",dataList,dataAddress)
    self:SetUpData("admission_notice_bonus",dataList,dataAddress)
    self:SetUpData("excessive_consumption_value",dataList,dataAddress)


    self:SetUpData_Str("personal_tutor",dataList,dataAddress)

    -- 乱纪元成就
    self:SetUpData("chaotic_era_1",dataList,dataAddress)
    self:SetUpData("chaotic_era_2",dataList,dataAddress)
    self:SetUpData("chaotic_era_3",dataList,dataAddress)
    self:SetUpData("chaotic_era_4",dataList,dataAddress)
    self:SetUpData("chaotic_era_5",dataList,dataAddress)

    self:SetUpData("chaotic_era_base_rune_1",dataList,dataAddress)
    self:SetUpData("chaotic_era_base_rune_2",dataList,dataAddress)
    self:SetUpData("chaotic_era_base_rune_3",dataList,dataAddress)

    self:SetUpData("chaotic_era_rune_1",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_2",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_3",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_4",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_5",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_6",dataList,dataAddress)

    self:SetUpData("chaotic_era_rune_single_get_1",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_single_get_2",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_single_get_3",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_single_get_4",dataList,dataAddress)

    
    self:SetUpData("chaotic_era_rune_killer_1",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_killer_2",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_killer_3",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_killer_4",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_killer_5",dataList,dataAddress)
    self:SetUpData("chaotic_era_rune_killer_6",dataList,dataAddress)


    
    -- 英雄
    self:SetUpData("Nirvana_1",dataList,dataAddress)
    self:SetUpData("Walrus_punch_1",dataList,dataAddress)
    self:SetUpData("Walrus_punch_2",dataList,dataAddress)
    self:SetUpData("lonely_hero_1",dataList,dataAddress)
    self:SetUpData("acceleration_mode_1",dataList,dataAddress)

    self:SetUpData("extremely_greed_1",dataList,dataAddress)
    self:SetUpData("golden_legend_1",dataList,dataAddress)  --血魔   金色传说-加成上限提升至500

    self:SetUpData("electrostatic_extractor_1",dataList,dataAddress)
    self:SetUpData("self_decline_1",dataList,dataAddress)
    self:SetUpData("genius_1",dataList,dataAddress)
    self:SetUpData("mobile_earthquake_source_1",dataList,dataAddress)
    self:SetUpData("monkey_king_power_1",dataList,dataAddress)
    self:SetUpData("wave_1",dataList,dataAddress)
    self:SetUpData("rip_tide_rush_1",dataList,dataAddress)
    self:SetUpData("binder_1",dataList,dataAddress)

    self:SetUpData("hero_time_1",dataList,dataAddress)  --亚巴顿   主人公-属性提升效果增加7%
    self:SetUpData("horse_trainer_1",dataList,dataAddress)  --亚巴顿   弼马温-伤害增加10%

    
    self:SetUpData("madness_1",dataList,dataAddress)  --血魔   狂乱-持续时间加2
    

    
    self:SetUpData("flame_resistance_1",dataList,dataAddress)  --蜘蛛   火焰抗性-不再会被烧毁

    self:SetUpData("24_hours_1",dataList,dataAddress)  --人马   24小时营业-退热程度降低


    self:SetUpData("precipitate_1",dataList,dataAddress)  --小黑   沉淀-速度加快


    self:SetUpData("disaster_surviver_1",dataList,dataAddress)  --宙斯   五雷轰顶-冷却减少

    self:SetUpData("gay_chain_1",dataList,dataAddress)  --小精灵   同性链-增加效率


    self:SetUpData("family_man_1",dataList,dataAddress)  --风行   家人侠-效率增加


    self:SetUpData("plane_shuttle_1",dataList,dataAddress)  --紫猫   位面穿梭者

    self:SetUpData("jedi_knight_1",dataList,dataAddress)  --圣堂刺客 绝地武士  


    self:SetUpData("phantom_hunter_1",dataList,dataAddress)  --幽鬼 幻影猎杀者  

 
    self:SetUpData("giant_1",dataList,dataAddress)  --小小 巨物  

    
    self:InitPlayerArtifactData(nPlayerID,dataList,dataAddress)
    

    
    
   
    
    dataList = nil
    dataTable = nil
    -- PrintTable(self.customData[nPlayerID][season])
    return self.customData[steamID]
end

function customDataManager:InitPlayerArtifactData(nPlayerID,dataList,dataAddress)
    for artifactName, value in pairs(KeyValues.palyer_artifactKV) do
        if value.IsDevFinish then
            self:SetUpDataArtifact(artifactName,dataList,dataAddress,nPlayerID) 
        end
    end

    CustomNetTables:SetTableValue( "chaoticEraData", "playerArtifact", self.playerArtifactData )  --更新网表

   
end




function customDataManager:SetUpData(name,dataList,dataAddress)
    dataList[name] = dataList[name] or {}  --防空值
    -- PrintTable(dataList[name])
    dataAddress[name] = {}
    local adress = dataAddress[name]
    adress.valueOne = tonumber(dataList[name].valueOne or 0)
    adress.valueTwo = tonumber(dataList[name].valueTwo or 0)
    adress.recordDate = dataList[name].recordDate or nil
    return true
end
function customDataManager:SetUpData_Str(name,dataList,dataAddress)
    dataList[name] = dataList[name] or {}  --防空值
    -- PrintTable(dataList[name])
    dataAddress[name] = {}
    local adress = dataAddress[name]
    adress.valueOne = dataList[name].valueOne or ""
    adress.valueTwo = dataList[name].valueTwo or ""
    adress.recordDate = dataList[name].recordDate or nil
    return true
end

function customDataManager:SetUpDataArtifact(name,dataList,dataAddress,nPlayerID)
    dataList[name] = dataList[name] or {}  --防空值

    -- PrintTable(dataList[name])
    dataAddress[name] = {}
    local adress = dataAddress[name]
    adress.valueOne = tonumber(dataList[name].valueOne or 0)
    adress.valueTwo = tonumber(dataList[name].valueTwo or 0)
    adress.recordDate = dataList[name].recordDate or nil
    adress.complete= dataList[name].complete or 0


    self.playerArtifactData[nPlayerID][name]= {
        valueOne = tonumber(dataList[name].valueOne or 0),
        valueTwo = tonumber(dataList[name].valueTwo or 0),
        recordDate = dataList[name].recordDate or nil,
        complete = dataList[name].complete or 0,
    }
    -- complete 为1就是解锁了
    -- valueOne 是当前经验


    return true
end
function customDataManager:GetPlayerCustomData(steamID)
    return  self.customData[steamID]
end

function customDataManager:GetTargetAchievementData(steamID,name)
    if not self.customData[steamID] then
        return nil
    end
    return  self.customData[steamID][name]
end

function customDataManager:IsAchievementUnlocked(steamID,name)
    if not self.customData[steamID] then
        return false
    end
    if not self.customData[steamID][name] then
        return false
    end
    return  self.customData[steamID][name].recordDate and true or false

end
function customDataManager:IsAchievementUnlockedWithUnit(unit,name)
    local steamID = tostring(PlayerResource:GetSteamID( unit:GetPlayerOwnerID()))
    if not self.customData[steamID] then
        return false
    end
    if not self.customData[steamID][name] then
        return false
    end
    return  self.customData[steamID][name].recordDate and true or false

end



function customDataManager:ModifySingleCustomData(steamID,name,valueOne,valueTwo)
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        if valueOne then
            target.valueOne = target.valueOne + valueOne
        end
        if valueTwo then
            target.valueTwo = target.valueTwo + valueTwo
        end
        self.customData_ShouldSend[steamID][name] = true
    end
end
function customDataManager:ModifySingleCustomDataV2(nPlayerID,name,valueOne,valueTwo)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        if valueOne then
            target.valueOne = target.valueOne + valueOne
        end
        if valueTwo then
            target.valueTwo = target.valueTwo + valueTwo
        end
        self.customData_ShouldSend[steamID][name] = true
    end
end

function customDataManager:ModifySingleCustomData_Override(nPlayerID,name,valueOne,valueTwo)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        if valueOne then
            target.valueOne = valueOne 
        end
        if valueTwo then
            target.valueTwo = valueTwo
        end
        self.customData_ShouldSend[steamID][name] = true
    end
end






function customDataManager:ModifySingleCustomData_AndSendData(nPlayerID,name,valueOne,valueTwo)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        if valueOne then
            target.valueOne = target.valueOne + valueOne
        end
        if valueTwo then
            target.valueTwo = target.valueTwo + valueTwo
        end
        -- self.customData_ShouldSend[steamID][name] = true
        -- 修改好直接传送
        if not target.recordDate then
            local newData = {}
            newData.token = _G.GAME_GLOBAL_KEY
            newData.customizeList  = {}
             -- 平均游戏时间数据必定变动
            local customizeData = {
                steamId = steamID,
                season = "-1",
                customizeKey = name,
                -- complete = 1,
                valueOne =  target.valueOne,
                valueTwo =  target.valueTwo,
            }
            table.insert(newData.customizeList,customizeData)
        
            local encoded = json.encode(newData)
            -- 发送数据
            player_database:SavePlayerCustomData_Special(nPlayerID,encoded)
        else
            print("已经领取过成就了 不传了")
        end
       
    end
end
function customDataManager:ModifySingleCustomData_Override_AndSendData(nPlayerID,name,valueOne,valueTwo)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    -- print("111111111111111")
    if target then
        if valueOne then
            target.valueOne = valueOne 
        end
        if valueTwo then
            target.valueTwo = valueTwo
        end
        -- self.customData_ShouldSend[steamID][name] = true
        -- 修改好直接传送
        if not target.recordDate then
            -- print("name=",name)
            local newData = {}
            newData.token = _G.GAME_GLOBAL_KEY
            newData.customizeList  = {}
            -- print("target.valueOne=",target.valueOne)
            
             -- 平均游戏时间数据必定变动
            local customizeData = {
                steamId = steamID,
                season = "-1",
                customizeKey = name,
                -- complete = 1,
                valueOne =  target.valueOne,
                valueTwo =  target.valueTwo,
            }
            table.insert(newData.customizeList,customizeData)
            PrintTable(customizeData)
            local encoded = json.encode(newData)
            -- 发送数据
            player_database:SavePlayerCustomData_Special(nPlayerID,encoded)
        else
            print("已经领取过成就了 不传了")
        end
       
    end
end

-- 增加神器经验（直接发送请求）
function customDataManager:ModifyPlayerArtifactExp(nPlayerID,name,valueOne,valueTwo)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        if valueOne then
            target.valueOne = target.valueOne + valueOne
        end
        if valueTwo then
            target.valueTwo = target.valueTwo + valueTwo
        end
        -- self.customData_ShouldSend[steamID][name] = true
        -- 修改好直接传送
   
        local newData = {}
        newData.token = _G.GAME_GLOBAL_KEY
        newData.customizeList  = {}
            -- 平均游戏时间数据必定变动
        local customizeData = {
            steamId = steamID,
            season = "-1",
            customizeKey = name,
            -- complete = 1,
            valueOne =  target.valueOne,
            valueTwo =  target.valueTwo,
        }
        table.insert(newData.customizeList,customizeData)
    
        local encoded = json.encode(newData)
        -- 发送数据
        player_database:SavePlayerCustomData_Special(nPlayerID,encoded)

        if self.playerArtifactData[nPlayerID][name] then
            
            if valueOne then
                self.playerArtifactData[nPlayerID][name].valueOne = self.playerArtifactData[nPlayerID][name].valueOne + valueOne
            end
            if valueTwo then
                self.playerArtifactData[nPlayerID][name].valueTwo = self.playerArtifactData[nPlayerID][name].valueTwo + valueTwo
            end
        end

        
        CustomNetTables:SetTableValue( "chaoticEraData", "playerArtifact", self.playerArtifactData )  --更新网表

     
       
    end
end

-- 游戏结算时的最终效果  
function customDataManager:ModifyPlayerArtifactExp_Final(nPlayerID,name,valueOne,valueTwo)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        if valueOne then
            target.valueOne = target.valueOne + valueOne
        end
        if valueTwo then
            target.valueTwo = target.valueTwo + valueTwo
        end
        self.customData_ShouldSend[steamID][name] = true
        -- 修改好直接传送
        local newData = {}
        newData.token = _G.GAME_GLOBAL_KEY
        newData.customizeList  = {}
        -- 平均游戏时间数据必定变动
        local customizeData = {
            steamId = steamID,
            season = "-1",
            customizeKey = name,
            -- complete = 1,
            valueOne =  target.valueOne,
            valueTwo =  target.valueTwo,
        }
        table.insert(newData.customizeList,customizeData)
        if self.playerArtifactData[nPlayerID][name] then
            if valueOne then
                self.playerArtifactData[nPlayerID][name].valueOne = self.playerArtifactData[nPlayerID][name].valueOne + valueOne
            end
            if valueTwo then
                self.playerArtifactData[nPlayerID][name].valueTwo = self.playerArtifactData[nPlayerID][name].valueTwo + valueTwo
            end
        end
        player_artifact:OnArtifactExpChance(nPlayerID,name)
        CustomNetTables:SetTableValue( "chaoticEraData", "playerArtifact", self.playerArtifactData )  --更新网表
    end
end

function customDataManager:IsArtifactUnlock(nPlayerID,name)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        if target.complete and target.complete==1  then
            return true
        end
      
    end
    return false
end
function customDataManager:GetCurrentArtifactExp(nPlayerID,name)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        return target.valueOne
    end
    return -1
end

-- 解锁圣物
function customDataManager:UnlockArtifact(nPlayerID,name)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        -- 修改好直接传送
        local newData = {}
        newData.token = _G.GAME_GLOBAL_KEY
        newData.customizeList  = {}
         -- 平均游戏时间数据必定变动
        local customizeData = {
            steamId = steamID,
            season = "-1",
            customizeKey = name,
            complete = 1,
            valueOne =  target.valueOne,
            valueTwo =  target.valueTwo,
        }
        table.insert(newData.customizeList,customizeData)
    
        local encoded = json.encode(newData)
        -- 发送数据
        player_database:SavePlayerCustomData_Special(nPlayerID,encoded)
        target.complete = 1
        self.playerArtifactData[nPlayerID][name]= {
            valueOne = target.valueOne or 0,
            valueTwo = target.valueTwo or 0,
            recordDate = target.recordDate or nil,
            complete = target.complete or 0,
        }
        CustomNetTables:SetTableValue( "chaoticEraData", "playerArtifact", self.playerArtifactData )  --更新网表

       
    end
end
-- 购买圣物
function customDataManager:BuyArtifact(nPlayerID,name,cost)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    -- print("name=",name,cost)
    if target then
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
        -- print("gooo")
        -- 修改好直接传送
        local newData = {}
        newData.token = _G.GAME_GLOBAL_KEY
        newData.customizeList  = {}
        newData.steamId = steamID
        newData.isEncourage=1
         -- 平均游戏时间数据必定变动
        local customizeData = {
            steamId = steamID,
            season = "-1",
            customizeKey = name,
            complete = 1,
            valueOne =  target.valueOne,
            valueTwo =  target.valueTwo,
        }
        table.insert(newData.customizeList,customizeData)

        local newDataTable = {}
        newData.platinum = spellmap.playerinfo.platinum - cost
        
        newDataTable.platinum = newData.platinum

        _G.GAME_CAN_BUY[nPlayerID] = false --修改为购买中
        print("tye buy")
    
        local encoded = json.encode(newData)
        -- 发送数据
        player_database:SavePlayerCustomData_BuyArtifact(nPlayerID,encoded,newDataTable,function ()
            target.complete = 1
            self.playerArtifactData[nPlayerID][name]= {
                valueOne = target.valueOne or 0,
                valueTwo = target.valueTwo or 0,
                recordDate = target.recordDate or nil,
                complete = target.complete or 0,
            }
            CustomNetTables:SetTableValue( "chaoticEraData", "playerArtifact", self.playerArtifactData )  --更新网表
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID) , "UpdatePlayerArfactPanel", {}) 
        end)


       
    end
end

-- 游戏结束时结算自定义信息
function customDataManager:GameEndUpdateAllCustomData(nPlayerID)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local palyer = PlayerResource:GetPlayer(nPlayerID)
    if not palyer then
        return
    end
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
    local hero = palyer:GetAssignedHero() --英雄

    local caster
    local heroes = {}
    local heroList = GetAllRealHeroes()
    -- 获取所有玩家的英雄
    for _, unit in pairs(heroList) do
        if tostring(PlayerResource:GetSteamID(unit:GetPlayerOwnerID()))~="0" then
           table.insert(heroes,unit)
        end
    end

    for i=0, hero:GetAbilityCount() - 1 do
        local Ability = hero:GetAbilityByIndex(i)
        if Ability ~= nil then
            if Ability.OnCustomDataSettlement~= nil then
                Ability:OnCustomDataSettlement()
            end
        end
    end
    local modifier = hero:FindModifierByName("modifier_hero_custom_data_manager")
    if modifier then
        modifier:OnGameSettlement()
    end
    if _G.GAME_SUCCESS or _G.GAME_ENDLESS_WAVE_COUNT>=1 then
        -- 通关难度的自定义字段
        -- _G.Selected_Difficulty_index   
        local diff =  _G.Selected_Difficulty_index 
        if diff>=9 then
            -- 百相以及乱纪元难度不需要
        else
            local customKeyNmae = "pass_diff_"..diff
            self:ModifySingleCustomData(steamID,customKeyNmae,1,nil)
            if diff==8 then
                if  not _G.SPELL_UPGRADE_TO_ADVANCED[nPlayerID] and  GetPlayerCount()<=1 then
                    -- 自我挑战者
                    self:ModifySingleCustomData(steamID,"self_challenger_1",1,nil)
                end
            end
        end
    end

    local heroDamage = player_data_get_value(nPlayerID, "bossDamage") or 0
    local heroDamageReceive = player_data_get_value(nPlayerID, "damageTaken") or 0
    local healing = PlayerResource:GetHealing(nPlayerID) or 0
    if _G.GAME_ROUND>=15 then
        if GetPlayerCount()>=3 and not hero:HasAbility("heroTalent_npc_dota_hero_life_stealer") then
            if heroDamage<=10000 then
                self:ModifySingleCustomData(steamID,"idle_about_1",1,nil)
                self:ModifySingleCustomData(steamID,"idle_about_2",1,nil)
                self:ModifySingleCustomData(steamID,"idle_about_3",1,nil)
                self:ModifySingleCustomData(steamID,"idle_about_4",1,nil)
            end
        end
      

    
    end
    if _G.GAME_ROUND>=18 then
        if GetPlayerCount()>=1 then
            local bMaxDamage = true
            local bMaxDamageReceive = true
            local bMaxHeal = true
            for _, unit in ipairs(heroes) do
                if unit~=hero then
                    local id = unit:GetPlayerOwnerID()
                    if (player_data_get_value(id, "bossDamage") or 0 )>=heroDamage then
                        bMaxDamage = false
                    end
                    if (player_data_get_value(id, "damageTaken") or 0)>=heroDamageReceive then
                        bMaxDamageReceive = false
                    end
                    if (PlayerResource:GetHealing(id) or 0)>=healing then
                        bMaxHeal = false
                    end
                end
            end
            if healing<=100000 then
                bMaxHeal = false
            end
            if bMaxDamage then
                self:ModifySingleCustomData(steamID,"the_strongest_spear_1",1,nil)
            end
            if bMaxDamageReceive then
                self:ModifySingleCustomData(steamID,"the_strongest_shield_1",1,nil)
            end
            if bMaxHeal then
                self:ModifySingleCustomData(steamID,"the_strongest_heal_1",1,nil)
            end

        end
      

    
    end

    -- 检查原石数量
    if tonumber(spellmap.playerinfo.core1)>=500 and tonumber(spellmap.playerinfo.core2)>=500 and tonumber(spellmap.playerinfo.core3)>=500 then
        self:ModifySingleCustomData(steamID,"core_collector_1",1,nil)
    end
    -- 黄金大富豪
    if  tonumber(spellmap.playerinfo.gold)>=150000 then
        self:ModifySingleCustomData(steamID,"aurum_millionaire_1",1,nil)
    end
    -- 经验宝宝
    if tonumber(spellmap.playerinfo.reliableExp)>=12000000 then
        self:ModifySingleCustomData(steamID,"exp_millionaire_1",1,nil)
    end



end

-- 特殊数据直接进行保存
function customDataManager:Modify_king_of_involution(nPlayerID)
    self:ModifySingleCustomData_AndSendData(nPlayerID,"king_of_involution_1",1,nil)
    self:ModifySingleCustomData_AndSendData(nPlayerID,"king_of_involution_2",1,nil)
end

function customDataManager:CheckAllCustomData(nPlayerID)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))

    local newData = {}
    newData.token = _G.GAME_GLOBAL_KEY
    newData.customizeList  = {}
    local sendList = self.customData_ShouldSend[steamID]
    for name, value in pairs(sendList) do
        if value then
            local target = self:GetTargetAchievementData(steamID,name)
            if target and ((not target.recordDate) or (string.gmatch(name, "item_hd"))) then
                -- 说明没有领取奖励 可以更新这个东西了
                local dataUpdate = {
                    steamId = steamID,
                    season = "-1",
                    customizeKey = name,
                    valueOne =  target.valueOne,
                    valueTwo =  target.valueTwo,
                }
                table.insert(newData.customizeList,dataUpdate)
            else
                print("这个成就已经领取奖励了 直接跳过")
            end
        end
    end
    if #newData.customizeList<=0 then
        print("没有需要储存的数据")
        return nil
    end
    return newData
    

end

function customDataManager:ForceUnlockArtifactWithExp(nPlayerID,name,exp)
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local target = self:GetTargetAchievementData(steamID,name)
    if target then
        -- 修改好直接传送
        local newData = {}
        newData.token = _G.GAME_GLOBAL_KEY
        newData.customizeList  = {}
         -- 平均游戏时间数据必定变动
        local customizeData = {
            steamId = steamID,
            season = "-1",
            customizeKey = name,
            complete = 1,
            valueOne =  exp,
            valueTwo =  target.valueTwo,
        }
        table.insert(newData.customizeList,customizeData)
    
        local encoded = json.encode(newData)
        -- 发送数据
        player_database:SavePlayerCustomData_Special(nPlayerID,encoded)
        target.complete = 1
        target.valueOne = tonumber(exp)
        self.playerArtifactData[nPlayerID][name]= {
            valueOne = target.valueOne or 0,
            valueTwo = target.valueTwo or 0,
            recordDate = target.recordDate or nil,
            complete = target.complete or 0,
        }
        CustomNetTables:SetTableValue( "chaoticEraData", "playerArtifact", self.playerArtifactData )  --更新网表

    else
        print("Error：你传输了一个错误的圣物名")
       
    end
end



function customDataManager:SaveTestData(nPlayerID)

    local newData = {}
    newData.token = _G.GAME_GLOBAL_KEY
    newData.customizeList  = {}
     -- 平均游戏时间数据必定变动
    local customizeData = {
        steamId = tostring(PlayerResource:GetSteamID(nPlayerID)),
        season = "-1",
        customizeKey = "pass_diff_1",
        -- complete = 1,
        valueOne =  5,
        valueTwo =  0,
    }
    table.insert(newData.customizeList,customizeData)

    local encoded = json.encode(newData)
    -- 发送数据
    player_database:SavePlayerCustomData_Special(nPlayerID,encoded)
end

-- 载入乱纪元的加成
function customDataManager:InitChaoticEraBonusEffect()
    -- if customDataManager:IsAchievementUnlocked(steamID,"platinum_millionaire_1") then
    --     unit:InitAchievement("exp_millionaire_1")
    --     local modifierHeroLight = unit:FindModifierByName("modifier_hero_light")
    --     if modifierHeroLight then
    --         modifierHeroLight:attach_particle_platinum_millionaire()
    --     end
    -- end
    -- print("111111111111111111111")
    local heroes = GetAllRealHeroes()
    local accountID = {}
    for _, unit in ipairs(heroes) do
        table.insert(accountID,  tostring(PlayerResource:GetSteamAccountID(unit:GetPlayerOwnerID())))
    end
    for _, unit in ipairs(heroes) do
        -- print("000000000000000000")

        local nPlayerID = unit:GetPlayerOwnerID()
        local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        if not self.customData[steamID] then
            self.customData[steamID] = {}
        end
        local dataAddress = self.customData[steamID]
        -- print("22222222222")
        if dataAddress then
            local target = self:GetTargetAchievementData(steamID,"artifact_best_backup")
            if target then
                if not (target.valueOne=="0" or target.valueOne==0) then
                    local idList = json.decode(target.valueOne)
                    -- print("idlist")
                    -- PrintTable(idList)
                    if idList then
                       if self:CheckIDInGame(idList) then
                        -- print("查询到有一名玩家在游戏内")
                        unit:AddNewModifier(unit, nil, "modifier_best_backup_bonus", {})
                        -- break
                       end
                    end
                    -- 重置
                    customDataManager:ModifySingleCustomData_Override_AndSendData(nPlayerID,"artifact_best_backup","0",nil)
                end
            end
            local  personal_tutor = self:GetTargetAchievementData(steamID,"personal_tutor")
            if personal_tutor then
                -- print("aaaaaaaaaaaaaaaa")
                if tonumber(personal_tutor.valueTwo) and tonumber(personal_tutor.valueTwo)>0 then
                    local idList = {}
                    local id = json.decode(personal_tutor.valueOne)
                    table.insert(idList,id)
                    if idList then
                       if self:CheckIDInGame(idList) then
                        -- print("查询到有一名玩家在游戏内")
                        unit:AddNewModifier(unit, nil, "modifier_personal_tutor", {stack =tonumber(personal_tutor.valueTwo)-1 })
                        -- break
                       end
                    end
                    -- 减少
                    print("减少")
                    customDataManager:ModifySingleCustomData_Override_AndSendData(nPlayerID,"personal_tutor",personal_tutor.valueOne,tonumber(personal_tutor.valueTwo)-1)
                end
            end

            local  excessive_consumption_value = self:GetTargetAchievementData(steamID,"excessive_consumption_value")
            if excessive_consumption_value then
                if tonumber(excessive_consumption_value.valueOne) and math.floor(tonumber(excessive_consumption_value.valueOne))>0 then
                    unit:AddNewModifier(unit, nil, "modifier_excessive_consumption_debuff", {stack =tonumber(excessive_consumption_value.valueOne) })
                end
            end
            
            local admission_notice_bonus = self:GetTargetAchievementData(steamID,"admission_notice_bonus")
            if admission_notice_bonus then
                if admission_notice_bonus.valueOne>0 then
                    unit:AddNewModifier(unit, nil, "modifier_admission_notice_buff", {stack = admission_notice_bonus.valueOne})
                end
            end
        end
    end
end

function customDataManager:GetTargetData(steamID,targetName)
    local target = self:GetTargetAchievementData(steamID,targetName)
    return target
end




-- 在此id列表中存在当局玩家
function customDataManager:CheckIDInGame(idList)
    local heroes = GetAllRealHeroes()
    local accountID = {}
    for _, unit in ipairs(heroes) do
        table.insert(accountID,  tostring(PlayerResource:GetSteamAccountID(unit:GetPlayerOwnerID())))
    end
    -- print("accountID")
    -- PrintTable(accountID)
    -- print("idList")
    -- PrintTable(idList)
    for _, id in ipairs(accountID) do
        if IsInTable(id,idList) then
            return true
        end
    end
    return false
end


-- 获取乱纪元模式额外的点数
function customDataManager:GetChaoticEraBonusCount(unit)
    local count  = 0
    local steamID = tostring(PlayerResource:GetSteamID( unit:GetPlayerOwnerID()))
    if not self.customData[steamID] then
        return 0
    end
    local dataTable = {
        chaotic_era_1 = 1,
        chaotic_era_2 = 2,
        chaotic_era_3 = 2,
        chaotic_era_4 = 2,
        chaotic_era_5 = 5,

        chaotic_era_base_rune_1 = 2,
        chaotic_era_base_rune_2 = 2,
        chaotic_era_base_rune_3 = 3,

        chaotic_era_rune_1 = 1,
        chaotic_era_rune_2 = 2,
        chaotic_era_rune_3 = 2,
        chaotic_era_rune_4 = 2,
        chaotic_era_rune_5 = 3,
        chaotic_era_rune_6 = 7,


        chaotic_era_rune_single_get_1 = 1,
        chaotic_era_rune_single_get_2 = 2,
        chaotic_era_rune_single_get_3 = 2,
        chaotic_era_rune_single_get_4 = 5,

        chaotic_era_rune_killer_1 = 1,
        chaotic_era_rune_killer_2 = 2,
        chaotic_era_rune_killer_3 = 2,
        chaotic_era_rune_killer_4 = 2,
        chaotic_era_rune_killer_5 = 3,
        chaotic_era_rune_killer_6 = 7,
    }

    for name, value in pairs(dataTable) do
        if customDataManager:IsAchievementUnlocked(steamID,name) then
            count = count + value
        end
    end


    if customDataManager:IsAchievementUnlocked(steamID,"chaotic_era_4") then
        unit:AddNewModifier(unit, nil, "modifier_word_step_to_the_top", {})
    end
    -- if customDataManager:IsAchievementUnlocked(steamID,"chaotic_era_base_rune_3") then
    --     unit:AddNewModifier(unit, nil, "modifier_take_gold", {})
    -- end
    if customDataManager:IsAchievementUnlocked(steamID,"chaotic_era_rune_4") then
        unit:AddNewModifier(unit, nil, "modifier_word_bulky", {})
    end
    if customDataManager:IsAchievementUnlocked(steamID,"chaotic_era_rune_killer_4") then
        unit:AddNewModifier(unit, nil, "modifier_artifact_barracks", {})
    end
    -- if customDataManager:IsAchievementUnlocked(steamID,"chaotic_era_rune_single_get_4") then
    --     unit:AddNewModifier(unit, nil, "modifier_the_more_the_better", {})
    -- end
    return count
end


return customDataManager