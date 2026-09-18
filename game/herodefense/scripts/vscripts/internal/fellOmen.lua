print("FellOmen load....")
fellOmen = fellOmen or class({})
require("internal/timers")
LinkLuaModifier( "modifier_thinker_INVULNERABLE", "modifier/modifier_thinker_INVULNERABLE", LUA_MODIFIER_MOTION_NONE )





function fellOmen:init(bReload)
    if not bReload then
        --Type1 怪出生时添加状态
        Add_Buff_When_Born = 1
        Add_Buff_To_Heroes_When_Game_Start = 2
        Add_Buff_And_Create_unit = 3
        _G.GAME_FELLOMEN_Born_Buff = {}
        _G.GAME_FELLOMEN_Game_Start_Buff = {}
        _G.GAME_FELLOMEN_Thinker_Buff = {}
        -- _G.GAME_Reincarnation_Wave = 1  --在addon_game_mode中
        -- _G.FIST_Wave = true             --在addon_game_mode中 首次进入战斗后变为false
        _G.GAME_BAN_CHANCE_Good = 1
        _G.GAME_BAN_CHANCE_Bad = 1
        _G.Current_Bad_FellOmen = 0   --噩相数
        _G.Current_Good_FellOmen = 0  --利相数
        -- _G.GAME_UNLOCK_CHANCE = 2 --每名玩家最多可解锁奥义数  （无用）
        --全部的信息汇总
        _G.GAME_FELLOMEN = {
            bad = {

            },

            good = {

            }
        }
        self.FellOmen_Info = {
            FellOmen_Bad_1 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_2 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_3 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_4 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_5 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_6 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_7 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_8 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Bad_9 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_10 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_11 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_12 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_13 = {
                type = Add_Buff_When_Born,
            },
    
            FellOmen_Bad_14 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_15 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_16 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_17 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_18 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_19 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Bad_20 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Bad_21 = {
                type = Add_Buff_And_Create_unit,
            },
    
            
            ----------------分界线
            FellOmen_Good_1 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_2 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_3 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_4 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_5 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_6 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_7 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_8 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_9 = {
                type = Add_Buff_When_Born,
            },
            FellOmen_Good_10 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_11 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_12 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_13 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_14 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
            FellOmen_Good_15 = {
                type = Add_Buff_To_Heroes_When_Game_Start,
            },
        }
        for i, value in pairs(self.FellOmen_Info) do
    
            local modifier_name = "modifier_"..i
            -- print("link.."..modifier_name)
            LinkLuaModifier(modifier_name, "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE)
            -- modifier_name = modifier_name.."_show"
            -- LinkLuaModifier(modifier_name, "modifier/modifier_challenge_show", LUA_MODIFIER_MOTION_NONE)
        end
    end

    

    
    CustomUIEvent("GetFellomen", Dynamic_Wrap(self, "_GetFellomen"), self)
    CustomUIEvent("TryBanFellOmen", Dynamic_Wrap(self, "_TryBanFellOmen"), self)
    CustomUIEvent("GetBonusAttributesCost", Dynamic_Wrap(self, "_GetBonusAttributesCost"), self)
    CustomUIEvent("SendBonusAttributes", Dynamic_Wrap(self, "_SetBonusAttributes"), self)


    -- if IsServer() then
    --     CustomGameEventManager:RegisterListener("GetFellomen", function(...)
    --         return self:_GetFellomen(...)
    --     end)
        
    --     CustomGameEventManager:RegisterListener("TryBanFellOmen", function(...)
    --         return self:_TryBanFellOmen(...)
    --     end)
    --     CustomGameEventManager:RegisterListener("GetBonusAttributesCost", function(...)
    --         return self:_GetBonusAttributesCost(...)
    --     end)
    
    --     CustomGameEventManager:RegisterListener("SendBonusAttributes", function(...)
    --         return self:_SetBonusAttributes(...)
    --     end)
    -- end

    
end

BonusAttributesTable = {
    --力量
    {
        1
    },
    --敏捷
    {
        1
    },
    --智力
    {
        1
    },
    --生命值
    {
        0.02
    },
    --魔法
    {
        0.025
    },
    --防御
    {
        2
    },
    --基础攻击力
    {
        0.3
    },
    --技能伤害
    {
        1
    },
    --技能点
    {
        0,
        8,
        18,
        30,
        45,
        65,
        100,
    },

}

--设置百相属性设置
function fellOmen:_SetBonusAttributes(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local data = event_data.attributes
    local totalCost = 0
    if self.Game_Player_Bonus_Attributes[nPlayerID].setting==true then
        print("Error:重复提交数据")
        return
    end
    --计算总数是否对得上
	for key, value in pairs(data) do
        local cost = 0
        -- print('key='..key.."  value="..value)
        -- print(BonusAttributesTable[tonumber(key)])
        -- print(BonusAttributesTable[tonumber(key)][1])
        -- print(value)
        if tonumber(key)==9 then
            cost =BonusAttributesTable[tonumber(key)][value+1] 
        else

            cost = BonusAttributesTable[tonumber(key)][1] *value
        end
        cost = math.ceil(cost)
        -- print(cost)
        totalCost = totalCost  + cost
    end

    --给一个加1是防止数据交互时小数出现问题
    if totalCost>(self.bonusAttributesPoint+self:CheckAchievementBonus(nPlayerID)+1) then
        print("error:数据不合法")
        return
    end
    local playerHero = player:GetAssignedHero()
    if not playerHero:IsAlive() then
        SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Bonus_Attributes_failed_die","General.Cancel")
        return
    end

    self.Game_Player_Bonus_Attributes[nPlayerID].setting = true  --设置为完成
	CustomGameEventManager:Send_ServerToPlayer(player, "SettingFnished", {}) 
    local gameEvent = {}
    gameEvent["player_id"] = nPlayerID
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#DOTA_HUD_FellOmen_Send_Bonus_Attributes_success"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    -- print("data[1]="..data["1"])
    local modifierTable = {
        str = data["1"],
        agi = data["2"],
        int = data["3"],
        health = data["4"],
        mana = data["5"],
        armor = data["6"],
        attack_damage = data["7"],
        spell_damage = data["8"],
        ability_point = data["9"],

    }
    -- local NetTable_key = tostring(nPlayerID).."_bonus_attribute"
    -- CustomNetTables:SetTableValue( "fellOmenInfo", NetTable_key, {value=modifierTable } )  --更新网表
    playerHero:AddNewModifier(playerHero, nil, "modifier_fellOmen_bonus_attributes", modifierTable)  --添加buff


end

--JS初始化（与玩家重新连接时）会触发这个事件
--js初始化后会发送一次请求取消耗表 这个时候如果已经产生了属性点也一并发送
function fellOmen:_GetBonusAttributesCost(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    CustomGameEventManager:Send_ServerToPlayer(player, "SetBonusAttributesCost",BonusAttributesTable)
    if self.bonusAttributesPoint and self.bonusAttributesPoint>0 then
        local bonusTable = self.Game_Player_Bonus_Attributes[nPlayerID]
        if bonusTable then
            if bonusTable.setting==true then
                return
            end
            --传送可用点数给客户端
            --仅当没设置好初始属性点时
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "TriggerBonuisPoint", {self.bonusAttributesPoint+self:CheckAchievementBonus(nPlayerID)})  
        end
    end
end


--Js获取百相信息
function fellOmen:_GetFellomen(eventSourceIndex, event_data)
		-- self:CheckTypeAndCreateTable()
		local nPlayerID = event_data.player_id
		local player = PlayerResource:GetPlayer(nPlayerID)
		local spellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
		if not spellMap then
			return
		end
		--反馈百相
		CustomGameEventManager:Send_ServerToPlayer(player, "GetFellomen_feedback", _G.GAME_FELLOMEN)
	
	   
end



function fellOmen:_TryBanFellOmen(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local banFellOmenName = event_data.fellOmen
    local isBad = event_data.badFellOmen
    -- print(fellOmenName)
    -- print(isBad)
    -- print(_G.GAME_BAN_CHANCE_Bad)
    -- print(_G.GAME_BAN_CHANCE_Good)
    if not _G.FIST_Wave then
        SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Ban_failed_into_battle","General.Cancel")
        return
    end
    if isBad==1 or isBad=="1" then

        if _G.GAME_BAN_CHANCE_Bad<=0 then
            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Ban_failed_No_Chance","General.Cancel")
            -- print("Eoor:没有足够的禁止机会")
            return
        end
        if _G.Current_Bad_FellOmen<=1 then
            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Ban_failed_toomuch","General.Cancel")
            return
        end
		local fellOmenTable = _G.GAME_FELLOMEN.bad
        -- PrintTable(_G.GAME_FELLOMEN.bad)
        for key, value in pairs(fellOmenTable) do
            local fellOmen_Name_IN_Table = value[1]
            if tostring(fellOmen_Name_IN_Table)==tostring(banFellOmenName) then
                --如此便找到了要移除的词条
                local level = value[2]+2 --获取等级 并获得额外的2点
                table.remove(_G.GAME_FELLOMEN.bad,key)  --移除这个词条
                local count = 0  --防止错误死循环加的停止措施
                while level>0 do
                    for key, value in pairs(_G.GAME_FELLOMEN.bad) do --遍历表重新分配等级
                        value[2] = value[2] + 1
                        -- PrintTable(value)
                        local NetTable_key = "modifier_"..value[1]
                        CustomNetTables:SetTableValue( "fellOmenInfo", NetTable_key, {level =value[2] } )  --更新网表
                        level = level -1
                        if level<=0 then
                            break
                        end
                    end
                    count = count + 1
                    if count>=500 then
                        break
                    end
                end
				local gameEvent = {}
                gameEvent["player_id"] = nPlayerID
                gameEvent["teamnumber"] = -1
                gameEvent["ability_name"] = fellOmen_Name_IN_Table
                gameEvent["message"] = "#DOTA_HUD_Player_Ban_Info"
                FireGameEvent( "dota_combat_event_message", gameEvent )
                --重新反馈百相到所有客户端进行更新
                _G.GAME_BAN_CHANCE_Bad = _G.GAME_BAN_CHANCE_Bad - 1
                _G.Current_Bad_FellOmen = _G.Current_Bad_FellOmen - 1
                CustomGameEventManager:Send_ServerToAllClients("GetFellomen_feedback", _G.GAME_FELLOMEN)
                break  --取到了即可停止运行
			end
       
        end
    else

        if _G.GAME_BAN_CHANCE_Good<=0 then

            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Ban_failed_No_Chance","General.Cancel")
            -- print("Eoor:没有足够的禁止机会")
            return
        end
        if _G.Current_Good_FellOmen<=1 then
            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Ban_failed_toomuch","General.Cancel")
            return
        end
        local fellOmenTable = _G.GAME_FELLOMEN.good
        -- PrintTable(_G.GAME_FELLOMEN.bad)
        for key, value in pairs(fellOmenTable) do
            local fellOmen_Name_IN_Table = value[1]
            if tostring(fellOmen_Name_IN_Table)==tostring(banFellOmenName) then
                --如此便找到了要移除的词条
                local level = value[2]+1 --获取等级 并获得额外的1点
                table.remove(_G.GAME_FELLOMEN.good,key)  --移除这个词条
                local count = 0  --防止错误死循环加的停止措施
                while level>0 do
                    for key, value in pairs(_G.GAME_FELLOMEN.good) do --遍历一下表重新分配等级
                        value[2] = value[2] + 1
                        -- PrintTable(value)
                        local NetTable_key = "modifier_"..value[1]
                        CustomNetTables:SetTableValue( "fellOmenInfo", NetTable_key, {level =value[2] } )  --更新网表
                        level = level -1
                        if level<=0 then
                            break
                        end
                    end
                    count = count + 1
                    if count>=500 then
                        break
                    end
                end
				local gameEvent = {}
                gameEvent["player_id"] = nPlayerID
                gameEvent["teamnumber"] = -1
                gameEvent["ability_name"] = fellOmen_Name_IN_Table
                gameEvent["message"] = "#DOTA_HUD_Player_Ban_Info"
                FireGameEvent( "dota_combat_event_message", gameEvent )
				--重新反馈百相到所有客户端进行更新
                _G.GAME_BAN_CHANCE_Good = _G.GAME_BAN_CHANCE_Good - 1
                _G.Current_Good_FellOmen = _G.Current_Good_FellOmen -1
                CustomGameEventManager:Send_ServerToAllClients("GetFellomen_feedback", _G.GAME_FELLOMEN)
                break  --取到了即可停止运行
                
            end
       
        end
    end

end


--根据轮回层数与服务器数据生成相
--触发于难度选择后(只触发一次)
function fellOmen:CreateFellOmen()
    local waves = _G.GAME_Reincarnation_Wave        --获取波数
    _G.Game_bonus_chance = math.min(_G.Game_bonus_chance+waves/20,10)  --每20层增加一个最大奖励值
    _G.Current_Bad_FellOmen =    math.floor(waves/One_FellOmen)         --相数 对应debuff数
    _G.Current_Good_FellOmen =     math.floor(waves/(OneHalf_FellOmen))    -- 1.5相数  对应buff数
	--根据相数计算负面状态
    local current_count = One_FellOmen       --当前的层数 每半相获得一层等级
    for i = 1,  _G.Current_Bad_FellOmen, 1 do
        local name = "FellOmen_Bad_".._G.debuffs[i]    --获取debuff索引 并生成名字
        local level = math.floor((waves-current_count)/(Half_FellOmen))  --获取额外半相数 生成等级
        table.insert(_G.GAME_FELLOMEN.bad,{name,level})
        current_count = current_count + One_FellOmen

        local NetTable_key = "modifier_"..name
        CustomNetTables:SetTableValue( "fellOmenInfo", NetTable_key, {level =level } )  --更新网表
    end

    current_count = OneHalf_FellOmen
    for i = 1, _G.Current_Good_FellOmen, 1 do
        local name = "FellOmen_Good_".._G.buffs[i]    --获取buff索引 并生成名字
        local level = math.floor((waves-current_count)/(Half_FellOmen))  --获取额外半相数 生成等级
        table.insert(_G.GAME_FELLOMEN.good,{name,level})
        current_count = current_count + OneHalf_FellOmen
        
        local NetTable_key = "modifier_"..name
        CustomNetTables:SetTableValue( "fellOmenInfo", NetTable_key, {level =level } )  --更新网表
    end
    self.bonusAttributesPoint = _G.GAME_Reincarnation_Wave *2 + 5 --可用的自由分配点数
    local bonus = self:CheckRankingBonus()
    if bonus then
        self.bonusAttributesPoint = self.bonusAttributesPoint + bonus
    end
    self.Game_Player_Bonus_Attributes = {

    }
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
   
    local bonusBan = 0
    local count = 0
    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        
        -- CustomNetTables:SetTableValue( "playerSpellLevelInfo", tostring(nPlayerID), {adavanced = 5} )  --初始化网表
        if steamID ~= "0" then
            self.Game_Player_Bonus_Attributes[nPlayerID] = {
                setting = false, --这个状态为还设置属性值
            }  
         

            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "TriggerBonuisPoint", {self.bonusAttributesPoint+self:CheckAchievementBonus(nPlayerID)})  --传送可用点数给客户端
            count = count + 1

            --处理特权
            local viptable = map[nPlayerID].vip  --属于这个玩家的VIP
            if viptable["Shop_ban_fellOmen"] then
                bonusBan = 1
            end
        end

    end
    _G.GAME_BAN_CHANCE_Good = _G.GAME_BAN_CHANCE_Good+bonusBan
    _G.GAME_BAN_CHANCE_Bad = _G.GAME_BAN_CHANCE_Bad+bonusBan

    local NetTable_key = "fellOmenPlayerNumber"
    CustomNetTables:SetTableValue( "common", NetTable_key, {value=count } )  --更新网表
end


--TOP1的奖励属性点
function fellOmen:CheckRankingBonus()
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        if steamID ~= "0"then
            local targetMap = map[nPlayerID]
            local ranking = targetMap.playerinfo.ranking
            if  ranking and ranking<=1  then
               return 5
            end
        end
    end
    return 0 
end
-- 内卷之神的奖励
function fellOmen:CheckAchievementBonus(nPlayerID)
    if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID(nPlayerID)),"king_of_involution_2") then
        return 4
    end
    return 0 
end

--下面方法在首次进入战斗回合时触发
--根据相的类型放入对应的表中 并生成全局buff
One_FellOmen = 8  --   一相
Half_FellOmen = 4 --   半相
OneHalf_FellOmen = 12  -- 1.5相
function fellOmen:CheckTypeAndCreateTable()
    --检测噩相
    local badFellOmen = _G.GAME_FELLOMEN.bad
    for key, value in pairs(badFellOmen) do
        local fellOmen_Name = value[1]
        if self.FellOmen_Info[fellOmen_Name].type==Add_Buff_When_Born then
            table.insert(_G.GAME_FELLOMEN_Born_Buff,value)
        elseif self.FellOmen_Info[fellOmen_Name].type==Add_Buff_To_Heroes_When_Game_Start then
            table.insert(_G.GAME_FELLOMEN_Game_Start_Buff,value)
        elseif self.FellOmen_Info[fellOmen_Name].type==Add_Buff_And_Create_unit then
            table.insert(_G.GAME_FELLOMEN_Thinker_Buff,value)
            
        end


    end
	--检测利相
    local badFellOmen = _G.GAME_FELLOMEN.good
    for key, value in pairs(badFellOmen) do
        local fellOmen_Name = value[1]
        if self.FellOmen_Info[fellOmen_Name].type==Add_Buff_When_Born then
            table.insert(_G.GAME_FELLOMEN_Born_Buff,value)
        elseif self.FellOmen_Info[fellOmen_Name].type==Add_Buff_To_Heroes_When_Game_Start then
            table.insert(_G.GAME_FELLOMEN_Game_Start_Buff,value)
        end
    end
    --设置添加状态所使用的技能
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            self.ability = hero:FindAbilityByName("Default_Move")
            break
        end
    end
    self:AddGlobalBuffToHero() --触发全局buff
end
function GetLevel(name)
    return CustomNetTables:GetTableValue( "fellOmenInfo", name).level
end

--Type:Add_Buff_When_Born 
--怪物生成时
--由于有的状态为几率添加 且部分不需要修饰器 所以用调用方法实现
function fellOmen:MonsterSpawn(unit,min_index,max_index)
    if _G.GAME_ROUND== 9 or _G.GAME_ROUND==19 then
        return
    end
    -- PrintTable(_G.GAME_FELLOMEN.bad)
    local badFellOmen = GAME_FELLOMEN_Born_Buff
    -- local unit_index = unit:entindex()
    -- print("unit_index="..unit_index)
    for key, value in pairs(badFellOmen) do
        local name = value[1]       --buff名
        local level = value[2]      --buff等级
        if self[name] then
            self[name](self,unit,min_index,max_index,level)
        else
            print("Error:没这个函数")
        end
    end
    if max_index>=1 then
        unit:AddNewModifier(unit, self.ability, "modifier_fellOmen_powerUp", {})
    end

end

--Type:Add_Buff_To_Heroes_When_Game_Start
--为所有英雄添加的buff
function fellOmen:AddGlobalBuffToHero()
    local heroes = GetAllRealHeroes()
    local goodFellOmen = GAME_FELLOMEN_Game_Start_Buff  --百相buff

	for  _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            local ability = hero:FindAbilityByName("Default_Move")
            for key, value in pairs(goodFellOmen) do
                local name = value[1]       --buff名
                local level = value[2]      --buff等级
                if self[name] then
                    self[name](self,hero,ability,level)
                else
                    print("Error:没这个函数")
                end
            end
        end
    end
    -- 设置thinker百相
    for key, value in pairs(GAME_FELLOMEN_Thinker_Buff) do
        local name = value[1]       --buff名
        local level = value[2]      --buff等级
        if self[name] then
            self[name](self,level)
        else
            print("Error:没这个函数")
        end
    end

    table.insert(_G.GAME_FELLOMEN_Thinker_Buff,value)
end


function fellOmen:FellOmen_Bad_1(unit,min_index,max_index,level)
    -- local unit = EntIndexToHScript(unit_index)
    -- unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_1", {level=level})
    local bonus = 0.3
    local bonus_stack = 0.05
    local index =1+ bonus + bonus_stack* level
    unit:SetBaseDamageMax(unit:GetBaseDamageMax()*index)
    unit:SetBaseDamageMin(unit:GetBaseDamageMin()*index)
end

function fellOmen:FellOmen_Bad_2(unit,min_index,max_index,level)
    -- local unit = EntIndexToHScript(unit_index)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_2", {level=level})
end

function fellOmen:FellOmen_Bad_3(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_3", {level=level})
end


function fellOmen:FellOmen_Bad_4(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_4", {level=level})
end

function fellOmen:FellOmen_Bad_5(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_5", {level=level})
end

function fellOmen:FellOmen_Bad_6(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_6", {level=level})
end


function fellOmen:FellOmen_Bad_7(unit,min_index,max_index,level)
    if min_index>=1000 or max_index>=1000 then
        return
    end
	unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_7", {level=level})
end



function fellOmen:FellOmen_Bad_8(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Bad_8", {level=level})
end


function fellOmen:FellOmen_Bad_9(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_9", {level=level})
end


function fellOmen:FellOmen_Bad_10(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_10", {level=level})
end

function fellOmen:FellOmen_Bad_11(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_11", {level=level})
end

function fellOmen:FellOmen_Bad_12(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_12", {level=level})
end



function fellOmen:FellOmen_Bad_13(unit,min_index,max_index,level)
    if min_index>=1000 or max_index>=1000 then
        return
    end
	unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_13", {level=level})
end

function fellOmen:FellOmen_Bad_14(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_14", {level=level})
end

function fellOmen:FellOmen_Bad_15(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_15", {level=level})
end
function fellOmen:FellOmen_Bad_16(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_16", {level=level})
end
function fellOmen:FellOmen_Bad_17(unit,min_index,max_index,level)
    if min_index>=1000 or max_index>=1000 then
        return
    end
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_17", {level=level})
end

function fellOmen:FellOmen_Bad_18(unit,min_index,max_index,level)
    if min_index>=1000 or max_index>=1000 then
        unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_18", {level=level,index=0.3})
        return
    end
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_18", {level=level,index=1})
end


function fellOmen:FellOmen_Bad_19(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Bad_19", {level=level})
end

function fellOmen:FellOmen_Bad_20(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Bad_20", {level=level})
end

function fellOmen:FellOmen_Bad_21(level)
    local unit = CreateUnitByName("npc_fallenSky_unit", Vector(5000,5000,5000), false, nil, nil, DOTA_MONSTER_TEAM_NUMBER)
    unit:AddNewModifier(unit, nil, "modifier_thinker_INVULNERABLE", {})
    local ability = unit:AddAbility("creeps_spell_fellomen_bad_21")
    ability:SetLevel(1)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Bad_21", {level=level})
end

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

function fellOmen:FellOmen_Good_1(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_1", {level=level})
end
function fellOmen:FellOmen_Good_2(unit,ability,level)

    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_2", {level=level})
end
function fellOmen:FellOmen_Good_3(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_3", {level=level})
end
function fellOmen:FellOmen_Good_4(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_4", {level=level})
end
function fellOmen:FellOmen_Good_5(unit,ability,level)

    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_5", {level=level})
end
function fellOmen:FellOmen_Good_6(unit,ability,level)

    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_6", {level=level})
end
function fellOmen:FellOmen_Good_7(unit,ability,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Good_7", {level=level})
end

function fellOmen:FellOmen_Good_8(unit,ability,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Good_8", {level=level})
end


function fellOmen:FellOmen_Good_9(unit,min_index,max_index,level)
    unit:AddNewModifier(unit, self.ability, "modifier_FellOmen_Good_9", {level=level})
end

function fellOmen:FellOmen_Good_10(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_10", {level=level})
end

function fellOmen:FellOmen_Good_11(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_11", {level=level})
end


function fellOmen:FellOmen_Good_12(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_12", {level=level})
end

function fellOmen:FellOmen_Good_13(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_13", {level=level})
end


function fellOmen:FellOmen_Good_14(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_14", {level=level})
end

function fellOmen:FellOmen_Good_15(unit,ability,level)
    unit:AddNewModifier(unit, ability, "modifier_FellOmen_Good_15", {level=level})
end



return fellOmen