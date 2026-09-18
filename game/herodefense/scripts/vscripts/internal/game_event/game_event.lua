require("internal/timers")

print("game_event load.....")
game_event = game_event or class({})
require("internal/game_event/update")
require("internal/game_event/unit_event")

function game_event:init(bReload)
  
    
    print("game_event init")
    --收到升级技能的请求

    if not bReload then
        self.loginProgress = {}
        self.bIsPause = false
		self.tPlayerLastUnPauseTime = {}
		self.tPlayerLastPauseTime = {}
    end

    CustomUIEvent("ReturnSpellBonus", Dynamic_Wrap(self, "_ReturnSpellBonus_lua"), self)

    CustomUIEvent("SelectDifficulty", Dynamic_Wrap(self, "_SelectDifficulty_lua"), self)

    CustomUIEvent("CustomBuffAlert", Dynamic_Wrap(self, "_CustomBuffAlert"), self)
    CustomUIEvent("CustomTogglePause", Dynamic_Wrap(self, "_CustomTogglePause"), self)

    -- CustomGameEventManager:RegisterListener("ReturnSpellBonus", function(...)
    --     return self:_ReturnSpellBonus_lua(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("SelectDifficulty", function(...)
    --     return self:_SelectDifficulty_lua(...)
    -- end)

    -- CustomGameEventManager:RegisterListener("CustomBuffAlert", function(...)
    --     return self:_CustomBuffAlert(...)
    -- end)


    ListenToGameEvent("entity_killed", Dynamic_Wrap(self,"OnGameMonsterKilled"), self)
    ListenToGameEvent("dota_on_hero_finish_spawn", Dynamic_Wrap(self,"OnHeroFinishSpawn"), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(self,"OnNpcSpawn"), self)

    if IsServer() then
        -- GameRules:GetGameModeEntity():SetContextThink(DoUniqueString(""), function()
        --     self:CheckPlayerAlive()
        --     return 1
        -- end, 0)
    end
    
end






--拿到本地化信息 发出技能书奖励提升
function game_event:_ReturnSpellBonus_lua(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local message = event_data.message
    GameRules:SendCustomMessage(message, 1, nPlayerID) --给出奖励提示

end


_G.FIST_Wave = true
function game_event:Go_next_wave()

    SetCurrentRound(_G.GAME_ROUND + 1)
    _G.GAME_MONSTER_TABLE = nil
    _G.GAME_MONSTER_TABLE = {}
    -- 如果是第一回合
    if _G.FIST_Wave then
        self:FirstWaveLogic()
    end
    self:ContestHeroUpdate()
    print("wave get ready......")
    GameRules:SendCustomMessage("DOTA_CUSTOM_Wave_Start_info1", 1, -1)
    Timers:CreateTimer(1, function()
        --在非工具模式下将移除表以节约资源
        --移除表操作位于CreatePortalSPawner(...)中
        self:SendWaveInfo()
        print("wave start")
        GameRules:SendCustomMessage("DOTA_CUSTOM_Wave_Start_info2", 1, -1)
        game_music:PlayStartMusic()
        self:PlayWaveMusic()

        -- local heroes = GetAllRealHeroes()
        Game_State:SetBattleState(true)  --设置当前状态——在战斗
        self:HeroWaveStartSetUp()
        print("_G.GAME_ROUN=".._G.GAME_ROUND)
        --关闭传送门
        self:OpenTPGate()
        WaveStart_ON()
    end)
    if _G.GAME_ROUND==19 then
        GameRules:GetGameModeEntity().CAddonTemplateGameMode:RecordDamage()    
    end
end


--第一回合
function game_event:FirstWaveLogic()
    _G.FIST_Wave = false
    -- 强制性添加天赋
    talentManager:OnFirstWaveStart()
    if  _G.GAME_ISLASTDAY then
        -- 如果是休息日 那么提示休息日
        if _G.GAME_CHANLLENGE_Contest_Type>=1  then  --有玩家没连接
            Notifications:TopToAll({ text = "#DOTA_CUSTOM_NO_CONTEST", duration = 4, style = { color = "red" } })
        end
        if _G.GAME_Reincarnation_Wave>=1 then
            Notifications:TopToAll({ text = "#DOTA_CUSTOM_NO_CONTEST2", duration = 4, style = { color = "red" } })
        end
    end
    --Notifications:TopToAll({ text = "新年活动开启中，结算经验和黄金增加20%，圣物经验和圣物掉落率增加30%", duration = 10, style = { color = "white" } ,class="Fix_NotificationLine"})
    --Notifications:TopToAll({ text = "12月传说月主题已开启！于常规模式挑战排行榜，赢取传说天赋！", duration = 10, style = { color = "white" } ,class="Fix_NotificationLine"})--劳动节活动

    -- 百相buff激活
    if _G.GAME_Reincarnation_Wave>=1 then  --触发百相
        fellOmen:CheckTypeAndCreateTable()
    end
end
-- 在挑战排行榜时 获取英雄的数据
function game_event:ContestHeroUpdate()
    --提前获取数据
    if _G.GAME_CHANLLENGE_Contest_Type==1 and _G.GAME_ROUND>=24 then
        player_database:UpdateHeroInfo()
    elseif _G.GAME_CHANLLENGE_Contest_Type==2 and _G.GAME_ROUND>=20 then
        player_database:UpdateHeroInfo()
    end
end
-- 播放回合信息 如果是黑夜关卡则进行切换
function game_event:SendWaveInfo()
    local gameWave_index = 1
    if IsInToolsMode() or _G.GAME_debugTesting then
        gameWave_index = _G.GAME_ROUND
    end

    if _G.GAME_ROUND>_G.GAME_END_WAVE and _G.GAME_END_WAVE_Trigger==true then
        -- print("无尽")
        local ID = 33
        ---自定义UI 提示关卡名
        local event_data = {
            encounter_difficulty = 3,
            encounter_name = _G.GAME_MAP_WAVE_Localize[_G.GAME_MAP_NAME]..ID,
            encounter_ROUND = _G.GAME_ROUND,
        }
        local count = _G.GAME_ENDLESS_WAVE_COUNT
        CustomGameEventManager:Send_ServerToAllClients("on_new_room_discovered", {event_data})
        CustomGameEventManager:Send_ServerToAllClients("ShowEndless", {count})
        -- for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        --     local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        --     if steamID ~= "0" then
        --         local player = PlayerResource:GetPlayer(nPlayerID)
        --         if player then
        --             CustomGameEventManager:Send_ServerToPlayer(player, "on_new_room_discovered", {event_data})
        --             CustomGameEventManager:Send_ServerToPlayer(player, "ShowEndless", {count})
        --         end

        --     end
    
        -- end
    else
        local ID = _G.GAME_Units[gameWave_index].waveID
        ---自定义UI 提示关卡名
        local event_data = {
            encounter_difficulty = _G.GAME_Units[gameWave_index].wave_class,
            encounter_name = _G.GAME_MAP_WAVE_Localize[_G.GAME_MAP_NAME]..ID,
            encounter_ROUND = _G.GAME_ROUND,
        }
        local event_data2 = {}
        if _G.GAME_ROUND<_G.GAME_END_WAVE then
            local ID_next = _G.GAME_Units[gameWave_index+1].waveID
            event_data2 = {
                encounter_name = _G.GAME_MAP_WAVE_Localize[_G.GAME_MAP_NAME]..ID_next,
            }
        end
        CustomGameEventManager:Send_ServerToAllClients( "on_new_room_discovered", {event_data})
        if _G.GAME_ROUND<_G.GAME_END_WAVE then
            CustomGameEventManager:Send_ServerToAllClients( "GetNextWaveName", {event_data2})
        else
            CustomGameEventManager:Send_ServerToAllClients( "HideNextWaveName", {})
        end
        -- for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        --     local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        --     if steamID ~= "0" then
        --         local player = PlayerResource:GetPlayer(nPlayerID)
        --         if player then
        --             CustomGameEventManager:Send_ServerToPlayer(player, "on_new_room_discovered", {event_data})
        --             if _G.GAME_ROUND<_G.GAME_END_WAVE then
        --                 CustomGameEventManager:Send_ServerToPlayer(player, "GetNextWaveName", {event_data2})
        --             else
    
        --                 CustomGameEventManager:Send_ServerToPlayer(player, "HideNextWaveName", {})
        --             end
        --         end

                
        --     end
    
        -- end

        -- 强制黑夜关卡
        local ID = _G.GAME_Units[gameWave_index].waveID
        if ID >910  then
            _G.GAME_CHANGING_NIGHT_WORLD_RULE = true
            GameRules:SetTimeOfDay(-1)
        else
            _G.GAME_CHANGING_NIGHT_WORLD_RULE = false
            -- GameRules:SetTimeOfDay(-1)
            GameRules:SetTimeOfDay(RandomFloat(0, 1))
        end

    end
end
-- 播放战斗回合的音乐
function game_event:PlayWaveMusic()
    Timers:CreateTimer(0.5, function()
        if _G.GAME_ROUND==4 or _G.GAME_ROUND==8 or _G.GAME_ROUND==10 or _G.GAME_ROUND==14 or _G.GAME_ROUND==18 or _G.GAME_ROUND>=20 then
            print("boss music")
            if _G.GAME_ROUND>=_G.GAME_END_WAVE then
                --播放最终boss音乐
                game_music:PlayLastBossMusic()
            else
                --播放boss音乐
                game_music:PlayBossMusic()
            end 
        else
            --播放战斗音乐
            game_music:PlayBattleMusic()
        end

   
    end)
end
-- 开始回合时设置英雄
function game_event:HeroWaveStartSetUp()
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        if hero:IsRealHero() and hero:IsOwnedByAnyPlayer() then
            -- hero:SetOrigin(Vector(-300,-1053,896))
            FindClearSpaceForUnit(hero, Vector(-300,-1053,896), true)
            PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
            hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位

            local particle = ParticleManager:CreateParticle("particles/econ/events/fall_2021/blink_dagger_fall_2021_end_lvl2.vpcf", PATTACH_POINT_FOLLOW, hero)
		    ParticleManager:SetParticleControl( particle, 0, hero:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle)
            hero:EmitSound("Hero_Antimage.Blink_out")
            --魔瓶补充
            local item = hero:FindItemInInventory("item_new_bottle")
            if item ~=nil then
                item:SetCurrentCharges(3)
            end
            -- 回蓝
            hero:SetMana(hero:GetMaxMana())
            --创建苦难
            challenge:OnWaveStart(hero)
            for i=0, hero:GetAbilityCount() - 1 do
                local Ability = hero:GetAbilityByIndex(i)
                if Ability ~= nil and Ability.RefreshOnWaveStart and Ability:RefreshOnWaveStart() then
                    Ability:EndCooldown()
                end
            end
            Timers:CreateTimer(0.5, function()
                PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
            end)
        end
    end

    game_event:FireWaveStart()

end
function game_event:OpenTPGate()
    if IsValid(_G.Game_Portal) then
        local modifier = _G.Game_Portal:FindModifierByName("modifier_GAME_Portal1")
        if modifier then
            modifier:OnGameStateChanged(1)
        end
        _G.Game_Portal:ForceKill(false)
    end
    --开启传送门
    local pos = _G.GAME_START_POINT[1][RandomInt(1, #_G.GAME_START_POINT[1])].Vector + RandomVector(300)
    _G.Game_Portal = CreateUnitByName( "npc_Portal",pos, true, nil, nil, DOTA_TEAM_GOODGUYS )
    if _G.Game_Portal then
        local newAbility = _G.Game_Portal:AddAbility("GAME_Portal2")
        newAbility:SetLevel(1)
        local modifier = _G.Game_Portal:FindModifierByName("modifier_GAME_Portal2")
        if modifier then
            modifier:OnGameStateChanged(2)
        end
    end
    
end

function game_event:EndWave_And_Create_Bonus()
     --判断是否最终boss结束了
    if _G.GAME_ROUND>=_G.GAME_END_WAVE and _G.GAME_END_WAVE_Trigger==false then --说明游戏胜利条件达成
        _G.GAME_SUCCESS = true     --游戏成功
        Game_State:SetBattleState(false)   --设置当前状态——不在战斗
        --开始执行游戏结算
        --计算玩家数
        local playernumber = 0
        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            
            local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
            if steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED then
                playernumber = playernumber + 1
            end
        end
        --玩家数量计算完毕      

        Game_State:SetGameEnd(true) --改成1就不会执行失败操作了
        if _G.GAME_LOGIN_SUCCESS_INDEX>=playernumber then
            game_event:GameEnd_bonus()  --仅当所有玩家都登录成功后启用奖励结算
            _G.GAME_GAME_ENDING = true
            Timers:CreateTimer(2, function()
                if _G.GAME_UPDATE_SUCCESS_INDEX==playernumber then --当信息全部储存完毕才结束游戏
                    if _G.GAME_CHANLLENGE_Contest_Type>=1 and  _G.GAME_Contest_send==false then --说明需要完成排行榜数据单没完成
                        print("等待排行榜数据完成")
                        return 0.5
                    end
                    Timers:CreateTimer(15, function()
                        GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )

                    end)
                else
                    return 0.5
                end
    
            end)
        else
            GameRules:SendCustomMessage("DOTA_CUSTOM_LoginFailed_all", 1, -1)
            -- GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )

        end
        
    else --说明还没胜利 执行下一波
        print("end")

        --产生计时器 当都踏板后进入下一波
        _G.Game_message = 0
        _G.Game_timer  = 0
        Timers:CreateTimer(15, function()

            if _G.GAME_IN  == 1  then
                if _G.GAME_PREPARE_INDEX>=GetPlayerCount() then
                    game_event:Go_next_wave()

                else
                    if _G.GAME_PREPARE_INDEX>=1 then
                        _G.Game_timer = _G.Game_timer + _G.GAME_PREPARE_INDEX
                        _G.Game_message = _G.Game_message + _G.GAME_PREPARE_INDEX
                        if _G.Game_timer>=60 then
                            game_event:Go_next_wave()
                            GameRules:SendCustomMessage("DOTA_CUSTOM_Wave_force_start", 1, -1)
                            print("next wave")

                            return nil
 
                        end
                        
                        
                        if _G.Game_message>=10 then
                            _G.Game_message = 0
                            GameRules:SendCustomMessage("DOTA_CUSTOM_Wave_force_start_count", 1, -1)
                            GameRules:SendCustomMessage(_G.Game_timer.."/60", 1, -1)
                        end
                        --print("wait for start")
                        return 1
                    end
                    --print("wait")
                    return 1
                end
              
            else
                --print("wait")
                return 1
            end
        end)
        --踏板逻辑结束

        --产生原石
        if _G.GAME_Reincarnation_Wave>=1 then --
            local chance = _G.GAME_ROUND*25
            if _G.GAME_ROUND==10 or _G.GAME_ROUND==20  then
                chance = 1000 * RandomInt(1, 6)
            end
            if _G.GAME_ROUND==25 then
                chance = 10000
            end
            skillshop:RollBonusCore(chance) 
            if  _G.GAME_Reincarnation_Wave>=16 and _G.GAME_ROUND==20 then
                uimanager:BonusCore()
            end


            
        end

        --播放回合结束音乐
        game_music:PlayEndMusic()
        Game_State:SetBattleState(false)   --设置当前状态——不在战斗
        Timers:CreateTimer(1, function()

            game_music:PlayRestMusic()


       
        end)


        --生成奖励等级
        local heroes = GetAllRealHeroes()
        local bounuslevel = (_G.GAME_ROUND-1) /3.5 +1
        bounuslevel = bounuslevel - bounuslevel%1
        bounuslevel = math.min(bounuslevel,6)
        -- print(bounuslevel)
        for  _, hero in pairs(heroes) do
            if hero:IsRealHero() and hero:IsOwnedByAnyPlayer() then
                --获取VIP表
                if not hero:IsAlive() then
                    print("i am back")
                    hero:RespawnHero(false,false)
                    game_music:PlayBackMusic()
                end
                RefreshAbility(hero)
                Timers:CreateTimer(2, function()  --防止没考虑的因素导致死亡
                    if not hero:IsAlive() then
                        print("i am back")
                        hero:RespawnHero(false,false)
                        game_music:PlayBackMusic()

                    end 
                    if not Game_State:IsInBattle() then
                        print("check alive")
                        return 1
                    end  
                end)
                local gold = _G.GAME_WAVE_GOLD_BONUS
                gold = gold +hero.Bonus_gold
                --苦难挑战的额外奖励
                for  _, hero_challenge in pairs(heroes) do
                    local tModifiers = hero_challenge:FindAllModifiers()
                    for _, hModifier in pairs(tModifiers) do
     
                        if hModifier.WaveEndGOLDBONUS2 ~= nil then
                            -- 结算回合金币奖励
                            local index = hModifier:WaveEndGOLDBONUS2() --触发状态结算
                            local bonus = index * GetBonusGoldIndex_ChallengeBoss()

                            gold = gold+ bonus
                        end
                    end
                end




                --赏金猎人金袋加成
                if hero:HasItemInInventory("item_hd_BountyHunters_gold_bag") then
                    gold = gold *1.05
                end
                --猎人之贮加成
                if hero:HasItemInInventory("item_hd_hunters_hoard") then
                    gold = gold *1.25
                end
                gold = gold *(1+ hero:GetGoldGainPercentage())

                --苦难挑战的额外奖励
                local tModifiers = hero:FindAllModifiers()
                for _, hModifier in pairs(tModifiers) do
 
                    if hModifier.WaveEndGOLDBONUS ~= nil then
                        local index = hModifier:WaveEndGOLDBONUS() --触发状态结算
                        gold = gold* index
                        print("WaveEndGOLDBONUS  INDEX = "..index)
                    end
                end



                --产生新的苦难
                if _G.GAME_DIFFICULTY>=4 then
                    SpawnChallenge(hero:GetPlayerID())
                end

                
                local fool_modifier = hero:FindModifierByName("modifier_fool_power")
                if fool_modifier then
                    gold = gold * 1.1
                      --傻力特权
                      if 50>=RandomInt(1, 100) then
                        hero:HeroLevelUp(true)
                    end
                end
                if hero:HasModifier("modifier_king_of_translation") then
                    gold = gold * 1.15
                    if  _G.GAME_ROUND%2==0 then
                        hero:HeroLevelUp(true)
                    end
                end
                if hero:HaveAchievement("idle_about_4") then
                    -- print("混子加成")
                    gold = gold *1.02
                end


                --贪婪的加成
                local ability = hero:FindAbilityByName("Primary_Greevils_Greed")
                if ability then
                    gold = gold * (1+ability:GetSpecialValueFor("bnous_gold_index")) + ability:GetSpecialValueFor("bnous_gold") 
                else
                    ability = hero:FindAbilityByName("Middle_Greevils_Greed")
                    if ability then
                        local bonus = math.min(800,(hero:GetGold()-hero:GetGold()%1000)/1000*40)
                        gold = gold * (1+ability:GetSpecialValueFor("bnous_gold_index")) + ability:GetSpecialValueFor("bnous_gold") +bonus
                    else
                        ability = hero:FindAbilityByName("Advanced_Greevils_Greed")
                        if ability then
                            local max_bonus = 800
                            local bonus_index = 40
                            --LV5解锁以金炼金
                            if ability.advanced_level>=5 then
                                max_bonus = max_bonus*1.4
                                bonus_index = bonus_index *1.5
                            end
                            --LV15解锁储蓄之伍
                            local exbonus = 0
                            if ability.advanced_level>=15  then
                                local richPeople = FindOtherRichestHero(hero)
                                if richPeople then
                                    -- print("你有一个富有的队友")
                                    exbonus = math.min(max_bonus,(richPeople:GetGold())/1000*bonus_index)
                                    local pfx = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_ti9_immortal/bh_ti9_immortal_jinada.vpcf", PATTACH_CUSTOMORIGIN, hero)
                                    ParticleManager:SetParticleControlEnt(pfx, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
                                    DestroyParticleByDelay(pfx,5)
                                end
                            end
                            local bonus = math.min(max_bonus,(hero:GetGold()-hero:GetGold()%1000)/1000*bonus_index)+exbonus
                            gold = gold * (1+ability:GetSpecialValueFor("bnous_gold_index")) + ability:GetSpecialValueFor("bnous_gold")  +bonus
                        end
                    end
                end

            




                hero:AddNewModifier(hero, nil, "modifier_hd_mute", {duration=5}) --暂时锁闭道具
                Timers:CreateTimer(1, function()
                    hero:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=3}) --提供无敌防止死亡

                    local pos = _G.GAME_START_POINT[1][RandomInt(1, #_G.GAME_START_POINT[1])].Vector + RandomVector(300)
                    FindClearSpaceForUnit(hero, pos, true)

                    -- hero:SetOrigin(_G.GAME_START_POINT[1][RandomInt(1, #_G.GAME_START_POINT[1])].Vector)
                    -- hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
                    -- print("id="..hero:GetPlayerID())
                    PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
                end)
                Timers:CreateTimer(3, function()
                    BonusItems:SpawnBonusItems(hero:GetPlayerID(),bounuslevel)  --分配装备奖励
                    
                    
                    PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
                    hero:HeroLevelUp(true)
                  
                    --单人玩家
                    if hero:FindModifierByName("modifier_wolf_power") then
                        if  _G.GAME_ROUND%2==0 then
                            hero:HeroLevelUp(true)
                        end
                        gold = gold *1.1
                    elseif hero:FindModifierByName("modifier_it_takes_two") then
                        gold = gold *1.08
                    end

                    
                    if _G.GAME_ROUND%3==0 then
                        hero:HeroLevelUp(true)
                    end
                    hero:ModifyGoldFiltered(gold,true,DOTA_ModifyGold_CreepKill )  --金币奖励
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,hero, gold, nil)
                    for  _, unit in pairs(heroes) do
                        if unit~=hero and unit:HasModifier("modifier_heroTalent_npc_dota_hero_alchemist") then
                            Timers:CreateTimer(RandomFloat(0.5, 3), function()
                                unit:ModifyGoldFiltered(gold*0.05,true,DOTA_ModifyGold_CreepKill )  --金币奖励
                                SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,unit, gold*0.05, nil)
                            end)
                        end
                    end
 

                
                end)
            end
        end
        _G.GAME_WAVE_GOLD_BONUS = _G.GAME_WAVE_GOLD_BONUS+50
            --关闭传送门
        if IsValid(_G.Game_Portal) then
            local modifier = _G.Game_Portal:FindModifierByName("modifier_GAME_Portal2")
            if modifier then
                modifier:OnGameStateChanged(1)
            end
            _G.Game_Portal:ForceKill(false)
        end
        --开启传送门
        _G.Game_Portal = CreateUnitByName( "npc_Portal",Vector(-300,-1053,896), true, nil, nil, DOTA_TEAM_GOODGUYS )
        if _G.Game_Portal then
            local newAbility = _G.Game_Portal:AddAbility("GAME_Portal1")
            newAbility:SetLevel(1)
            local modifier = _G.Game_Portal:FindModifierByName("modifier_GAME_Portal1")
            if modifier then
                modifier:OnGameStateChanged(2)
            end
        end
       
        for  _, hero in pairs(heroes) do
            --清除苦难挑战并恢复状态
            challenge:WaveEnd(hero)
        end



        self:WaveEndBonusInfo()
    end     
    _G.GAME_MONSTER_Triger_END_WAVE = false
    self:FireWaveEnd()
    
end
function RefreshAbility(hero)
    for i=0, 9 do
        local Ability = hero:GetItemInSlot(i)
        if Ability ~= nil    then
            if not Ability:IsCooldownReady() then
                Ability:EndCooldown()
            end
            -- Ability:RefreshCharges()
           
           

        end
        
       
        
    end
    for i=0, hero:GetAbilityCount() - 1 do
        local Ability = hero:GetAbilityByIndex(i)
        if Ability ~= nil  then
            local count = Ability:GetMaxAbilityCharges(Ability:GetLevel())
      
            if count>1 then
                -- Ability:SetCurrentAbilityCharges(count)
                Ability:RefreshCharges()
            end
           if not Ability:IsCooldownReady() then
            Ability:EndCooldown()

           end

           

        end
    end
end


function game_event:FireWaveEnd()
    if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_Wave_End] then
        local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_Wave_End]
        -- print("check01")
        for i = #tModifiers, 1, -1 do
            local hModifier = tModifiers[i]
            -- print("check1")
            if IsValid(hModifier) and hModifier.OnWaveEnd then
                -- print("check2")
                hModifier:OnWaveEnd()
            else
                table.remove(tModifiers, i)
            end
        end
    end
end

function game_event:FireWaveStart()
    if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_Wave_Start] then
        local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_Wave_Start]
        for i = #tModifiers, 1, -1 do
            local hModifier = tModifiers[i]
            if IsValid(hModifier) and hModifier.OnWaveStart then
                hModifier:OnWaveStart()
            else
                table.remove(tModifiers, i)
            end
        end
    end
end
function game_event:FireChaoticEraRoundChange(keys)
    if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ChaoticEraRoundChange] then
        local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ChaoticEraRoundChange]
        for i = #tModifiers, 1, -1 do
            local hModifier = tModifiers[i]
            if IsValid(hModifier) and hModifier.OnChaoticEraRoundChange then
                hModifier:OnChaoticEraRoundChange(keys)
            else
                table.remove(tModifiers, i)
            end
        end
    end
end


function game_event:FireChaoticEraMonsterSpawn(keys)
    if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ChaoticEraMonsterSpawn] then
        local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ChaoticEraMonsterSpawn]
        for i = #tModifiers, 1, -1 do
            local hModifier = tModifiers[i]
            if IsValid(hModifier) and hModifier.AdvancedOnChaoticEraMonsterSpawn then
                hModifier:AdvancedOnChaoticEraMonsterSpawn(keys)
            else
                table.remove(tModifiers, i)
            end
        end
    end
end


function game_event:GiftBonusBase(playerid,gold,exp,spells,code)
    local nPlayerID = playerid

    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local player = PlayerResource:GetPlayer(nPlayerID)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellmap then
        return
    end
    local bitIndex = spellmap[nPlayerID].playerinfo.giftBit
    if bit.band( bitIndex, code ) == code then
        return 0
    end
    if not  _G.GAME_CAN_BUY[playerid] then
        Notifications:Top(nPlayerID, { text = "#buy_failed_Order_not_completed", duration = 4, style = { color = "red" } })
        EmitSoundOnClient("General.Cancel", player)
        return
    end

    _G.GAME_CAN_BUY[playerid] = false --修改为购买中
    
    spellmap[nPlayerID].playerinfo.giftBit = (spellmap[nPlayerID].playerinfo.giftBit +code)


    local bonus_gold = gold
    local bonus_exp = exp
    if steamID ~= "0" then
        -- print("开始生成技能奖励")
        
        -- local index = 0
        local index = nPlayerID
        local spellstable = spellmap[nPlayerID].spells  --属于这个玩家的技能表

        --生成空表
        self.newspellstable = {}
        --根据地图名给出属于该地图的技能奖励
        local map_name = GetMapName()  

        for i = 1,spells, 1 do
            local bonus_spell_name =  self:SpawnBonusSpellWithMapname(map_name,self.newspellstable,spellstable)
        end



        local newData ={}

        newData.playerInfo = {}
        newData.playerInfo.steamId = steamID 
        newData.playerInfo.giftBit = spellmap[nPlayerID].playerinfo.giftBit
        local steamName = PlayerResource:GetSteamAccountID(nPlayerID)
        newData.playerInfo.steamName = steamName
        -- newData.playerInfo.vip = "1"

        local infotable = spellmap[index].playerinfo  --属于这个玩家的技能表

        local viptable = spellmap[index].vip  --属于这个玩家的VIP


        if viptable["Shop_king_of_bug"] then  
            --生成额外奖励
            bonus_gold = bonus_gold * 1.1
            bonus_exp = bonus_exp *1.1
        end
        bonus_gold = bonus_gold -bonus_gold%1  --取整数
        local gold = infotable.gold + bonus_gold  
        -- local gold = "60"
        newData.playerInfo.gold = tostring(gold)  --设置新金币


        local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
        local max_xp = spellsXPTable[25]   --最高等级的经验值
        print("max_xp ="..max_xp)




        --处理经验
        -- if viptable["Shop_Fast_learning"] then  --额外经验
        --     --生成额外奖励
        --     bonus_exp = bonus_exp * 1.2
        -- end
        bonus_exp = bonus_exp-bonus_exp%1  --整数化

        -- newData.playerInfo.platinum ="500"  --测试白金
        --将技能储存到表里
        newData.playerSpellsList = {}
        for i, value in ipairs(self.newspellstable) do
            local newtable = {}
            newtable.steamId = steamID 
            newtable.spellName = value.name
            local spell_exp = value.exp
            if spell_exp>max_xp then  --当技能经验超过最大值转化为可靠经验
                bonus_exp = bonus_exp + (spell_exp-max_xp)
                spell_exp = max_xp
                value.exp = max_xp
            end
            newtable.exp = spell_exp
            table.insert(newData.playerSpellsList, newtable)
        end

        -- 处理可靠经验
        -- print(bonus_exp)
        local exp = infotable.reliableExp + bonus_exp
        newData.playerInfo.reliableExp = tostring(exp)

        --提示信息 用于奖励提示
        local message_info = {
            reliableExp = bonus_exp,
            gold = bonus_gold,
        }

        newData.token = _G.GAME_GLOBAL_KEY
        player_database:UpdateUserData_with_steamID_giftBonus(nPlayerID,newData,self.newspellstable,message_info)

    end  
end




_G.GAME_Reincarnation_Wave = 0  --无尽轮回次数
--词条产生系数
_G.GAME_CHANLLENGE_GAIN_INDEX = 0
_G.Selected_Difficulty_index = 0
function game_event:_SelectDifficulty_lua(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)

    -- 如果已经选择了难度 那就返回
    if _G.GAME_DIFFICULTY>=1 then
        return
    end
    --由此获取到了技能列表
    particleManager:SetUpParticles()  --配置特效
    
    _G.GAME_DIFFICULTY = tonumber(event_data.difficulty)  --修改游戏难度
    _G.Selected_Difficulty_index = _G.GAME_DIFFICULTY
    uimanager:SendWaveUi(player)
    local difficulty = _G.GAME_DIFFICULTY
    uimanager:PlayDifficultyParticle(difficulty)
    SetMonsterSpawnSpeed(difficulty)
    _G.Game_Mode.game_shop_type = Game_Shop_Type_Normal


    if difficulty==9 then
        self:FellOmenSetup()
        self:StartAliveChecking_General()
        talentManager:SpawnTalent() --生成天赋
    elseif difficulty==10 then
        self:ChaosEraSetup()
        -- 乱纪元延后生成天赋
        talentManager:SpawnTalent() --生成天赋
    else
        --修改游戏最终波数
        self:CheckGeneralGmaeMod(difficulty)
        self:StartAliveChecking_General()
        talentManager:SpawnTalent() --生成天赋

    end

    challenge:OnDifficultySelected()

    CustomNetTables:SetTableValue( "game_config", "hd_game_mode", _G.Game_Mode )

    ClientDataSYN("GAME_CHANLLENGE_DIFFICULTY",GetChallengeDifficulty())
    ClientDataSYN("GAME_DIFFICULTY",GAME_DIFFICULTY)
    
end



-- 百相模式的配置
function game_event:FellOmenSetup()
    local wave = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[0].playerinfo.difficultyWave+1
    _G.GAME_DIFFICULTY = 4  --基础难度
    SetChallengeDifficulty(3) --试炼难度
    _G.GAME_Reincarnation_Wave = wave --无尽轮回难度
    _G.GAME_END_WAVE = 25  --结束回合
    _G.GAME_END_WAVE_Trigger = true --开启无尽
    _G.GAME_internal_index = 0.6 --刷怪间隔
    local heroes = GetAllRealHeroes()
    for _, unit in ipairs(heroes) do
        -- SpawnChallenge(unit:GetPlayerID())
        achievement:InitAchievementModifier(unit)
    end
    fellOmen:CreateFellOmen()

 
end


-- 乱纪元模式配置
function game_event:ChaosEraSetup()
    local wave = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[0].playerinfo.difficultyWave+1
    _G.GAME_DIFFICULTY = 4  --基础难度
    SetChallengeDifficulty(3) --试炼难度
    -- <TODO 乱纪元里怪没有词条>
    _G.GAME_Reincarnation_Wave = wave --无尽轮回难度
    _G.GAME_END_WAVE = 25  --结束回合
    -- _G.GAME_END_WAVE_Trigger = true --开启无尽
    Game_State:EnableChaoticEraMod()
    _G.GAME_internal_index = 0.6 --刷怪间隔
    local heroes = GetAllRealHeroes()

    -- 适用成就修饰器
    for _, unit in ipairs(heroes) do
        achievement:InitAchievementModifier(unit)
    end
    -- fellOmen:CreateFellOmen()



end


-- 普通模式的初始化
function game_event:CheckGeneralGmaeMod(difficulty)
    local heroes = GetAllRealHeroes()
    if difficulty>1 then
        _G.GAME_END_WAVE = 20  --难度1以外是20波
    else
        _G.GAME_END_WAVE = 10  --难度1是10波
    end
    if difficulty>=5 then
        SetChallengeDifficulty(_G.GAME_DIFFICULTY -4)  
        _G.GAME_DIFFICULTY = 4
        if difficulty==7 then
            _G.GAME_CHANLLENGE_Contest_Type= 1   --开启竞速排行榜
            _G.GAME_END_WAVE = 25
        elseif difficulty==8 then
            _G.GAME_CHANLLENGE_Contest_Type= 2   --开启无尽排行榜
            _G.GAME_END_WAVE_Trigger = true --开启无尽
        else
            --无尽1跟无尽2几率出现隐藏关卡
            if 20>=RandomInt(1, 100) then
                _G.GAME_END_WAVE = 25
            else
                -- 如果仍然没触发25回合 那么再检测VIP
                local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
                if spellmap then
                    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
                        if spellmap[nPlayerID] then
                            local viptable = spellmap[nPlayerID].vip  --属于这个玩家的VIP
                            if viptable then
                                if viptable["Shop_endless"] and 1>=RandomInt(1, 100) then --无尽500英雄
                                    _G.GAME_END_WAVE = 25
                                end
                            end
                        end
                    end
                end
            end
            if GetChallengeDifficulty()==2 then
                _G.GAME_END_WAVE_Trigger = true --开启无尽
            end
    
    
    
        end
    end

    if _G.GAME_CHANLLENGE_Contest_Type==0 then
        -- 说明不是竞赛
        for _, unit in ipairs(heroes) do
            achievement:InitAchievementModifier(unit)
        end
    end


end



--因苦难增加的奖励
_G.GAME_BONUS_EXP = 0
_G.GAME_BONUS_GOLD = 0
_G.GAME_BONUS_BOOK = 0
--游戏结束奖励结算
--全局仅发起一次 即当游戏结束的时候
--对象为所有存在的玩家
--成功/失败为_G.GAME_SUCCESS = false
-- 难度为 _G.GAME_DIFFICULTY
--当前波数为_G.GAME_ROUND 
--GetMapName获取地图名
_G.Check_Settlement_Request={}
function game_event:GameEnd_bonus()
    if _G.GAME_debugTesting then
        return
    end
    if IsClient() then
        print("客户端")
        return
    end
    -- GameRules:SendCustomMessage("DOTA_HUD_CANT_SEE_INFO", 1, -1)
    if  _G.GAME_ISLASTDAY then
        _G.GAME_CHANLLENGE_Contest_Type = 0
    end

    --处理排行榜
    if _G.GAME_CHANLLENGE_Contest_Type==1 then
        print("竞速排名")
        --竞速模式需要完成所有关卡
        if _G.GAME_SUCCESS == true then --判断游戏是否成功
            --如果服务器不稳定上传失败了需要重新上传 因此在这里提前获取数据
            _G.GAME_Contest_send = false
            local time = GameRules:GetGameTime() - _G.GAME_pre_gameTime --去掉选人的时间
            player_database:SendSpeedContestInfo(time) 
        end
    elseif _G.GAME_CHANLLENGE_Contest_Type==2 then
        print("无尽排名")
        if _G.GAME_ENDLESS_WAVE_COUNT>=1 then --击杀大于1只无尽怪即可开启
            _G.GAME_Contest_send = false
            --如果服务器不稳定上传失败了需要重新上传 因此在这里提前获取数据
            player_database:SendEndLessContestInfo(_G.GAME_ENDLESS_WAVE_COUNT)
        end
    end



    EmitGlobalSound("custom_victory")
    local finished_wave = _G.GAME_ROUND 
    _G.GAME_UPDATE_SUCCESS_INDEX = 0
    if _G.GAME_SUCCESS == false then --游戏失败时会减少一波
        finished_wave  = finished_wave -1
    end
    local baseBonus = self:CalculateBaseBonus(finished_wave)
    local bonus_exp = baseBonus.bonus_exp
    local bonus_gold = baseBonus.bonus_gold
    local baseSpellBookBonus = self:CalculateBaseSpellBookBonus(finished_wave)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        local player = PlayerResource:GetPlayer(nPlayerID)
        -- 结算经验和黄金
        local player_exp = bonus_exp 
        local player_gold = bonus_gold 
        if player and steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED  then
            print("开始生成技能奖励")
            local playerHero = player:GetAssignedHero()
            local modifier = playerHero:FindModifierByName("modifier_FellOmen_Good_13")
            if modifier then
                local fellOmen_bonus = modifier.bonus
                player_exp = player_exp * fellOmen_bonus
                player_gold = player_gold * fellOmen_bonus
            end
            local legend = playerHero:FindModifierByName("modifier_heroTalent_npc_dota_hero_nevermore_3") or playerHero:FindModifierByName("modifier_heroTalent_npc_dota_hero_slark_3")
            if legend then
                local legend_bonus = legend.bonus
                player_exp = player_exp * legend_bonus
                player_gold = player_gold * legend_bonus
            end
            --现在拿到位置了
            local spellstable = spellmap[nPlayerID].spells  --属于这个玩家的技能表
            --生成空表
            self.newspellstable = {}

            local heroBonusSpellCount = baseSpellBookBonus
            if playerHero:HasModifier("modifier_item_hd_galaxy_compass") then
                heroBonusSpellCount = heroBonusSpellCount + 1
                -- self:SpawnBonusSpellRandom(self.newspellstable,spellstable)
            end
            --BOSS技能书
            if #_G.BOSS_Defeated>=1 then
                local index =GetBonusIndex_Difficulty_BossSpellBook()* GetBonusIndex_ChallengeDifficulty_BossSpellBook()
                index = index * _G.GAME_BOSS_SPELL_INDEX * _G.GAME_BOSS_SPELL_INDEX_2
                for _, boss_name in ipairs(_G.BOSS_Defeated) do
                    if Spells_library[boss_name] and 3.5*index>=RandomFloat(1,100) then
                        self:SpawnBonusSpellWithMapname(boss_name,self.newspellstable,spellstable)
                    end
                end
            end

      

            for i = 1, heroBonusSpellCount, 1 do
                self:SpawnBonusSpellRandom(self.newspellstable,spellstable)
            end

            --标记位  需要修改playerinfo 为 playerInfo
            local newData = {}
            newData.playerInfo = {}
            newData.playerInfo.steamId = steamID 
            local steamName = PlayerResource:GetSteamAccountID(nPlayerID)
            newData.playerInfo.steamName = steamName
            -- 更新镜头高度
            if player_database.cameraZchange[nPlayerID] then
                newData.playerInfo.cameraZ = player_database.cameraZ[nPlayerID]
            end
            -- newData.playerInfo.vip = "1"

            local infotable = spellmap[nPlayerID].playerinfo  --属于这个玩家的技能表
            local viptable = spellmap[nPlayerID].vip  --属于这个玩家的VIP
            --处理金币奖励
            if viptable["Shop_Alchemy"] then  --额外金币
                --生成额外奖励
                player_gold = player_gold * 1.2
            end
            local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
            local max_xp = spellsXPTable[25]   --最高等级的经验值
            print("max_xp ="..max_xp)
            --处理经验
            if viptable["Shop_Fast_learning"] then  --额外经验
                --生成额外奖励
                player_exp = player_exp * 1.2
 
            end
            --新手玩家系数影响 _G.GAME_BONUS_INDEX，这里指的是新手本人线性提高40%奖励
            local bonus_index = _G.GAME_BONUS_INDEX
            if playerHero:HasModifier("modifier_novice_player") then
                bonus_index = bonus_index +0.4
            end
            player_gold = player_gold *bonus_index
            player_exp = player_exp *bonus_index
            player_gold =player_gold * _G.GAME_END_BONUS_INDEX_EVENT
            player_exp =player_exp * _G.GAME_END_BONUS_INDEX_EVENT
            player_exp = player_exp-player_exp%1  --整数化
            player_gold = player_gold -player_gold%1  --取整数
            local gold = infotable.gold + player_gold  
            gold = math.max(gold,0)
            newData.playerInfo.gold = tostring(gold)  --设置新金币
            -- newData.playerInfo.platinum ="500"  --测试白金
            --将技能储存到表里
            newData.playerSpellsList = {}
            for i, value in ipairs(self.newspellstable) do
                local newtable = {}
                newtable.steamId = steamID 
                newtable.spellName = value.name
                local spell_exp = value.exp
                if spell_exp>max_xp then  --当技能经验超过最大值转化为可靠经验
                    player_exp = player_exp + (spell_exp-max_xp)
                    spell_exp = max_xp
                    value.exp = max_xp
                end
                newtable.exp = spell_exp
                table.insert(newData.playerSpellsList, newtable)
            end
            -- 处理可靠经验
            local exp = infotable.reliableExp + player_exp
            newData.playerInfo.reliableExp = tostring(exp)
            --百相层数增加
            if not _G.GAME_ISLASTDAY and _G.GAME_Reincarnation_Wave>=1 and finished_wave>=25 then  --需要完成所有回合（除了无尽）
                print("已完成所有回合 轮回加一")
                local next_wave = math.min(infotable.difficultyWave+2,_G.GAME_Reincarnation_Wave)
                next_wave = math.max(next_wave,infotable.difficultyWave) 
                next_wave = math.min(next_wave,100)  --目前只开放到100
                newData.playerInfo.wave = next_wave  --加一取小
            end
            --提示信息 用于奖励提示
            local message_info = {
                reliableExp = player_exp,
                gold = player_gold,
            }
            newData.token = _G.GAME_GLOBAL_KEY
            _G.Check_Settlement_Request[nPlayerID] = {
                base = false,          --基础数据
                customData = false,          --自定义数据
            }
            customDataManager:GameEndUpdateAllCustomData(nPlayerID) --进行数据更新
            local customDataList = customDataManager:CheckAllCustomData(nPlayerID)
            if customDataList then
                local customData_encoded = json.encode(customDataList)
                -- 发送数据
                player_database:SavePlayerCustomData(nPlayerID,customData_encoded,function ()
                    _G.Check_Settlement_Request[nPlayerID].customData = true
                end)
            else
                _G.Check_Settlement_Request[nPlayerID].customData =true
            end
            --转换格式 发送数据包
            local encoded = json.encode(newData)
            player_database:UpdateUserData_with_steamID(nPlayerID,encoded,self.newspellstable,message_info)
        end   
    end

    player_database:UpdateAllPlayerParticleState()
end

function game_event:CheckSettlementState(nPlayerID)
    if not Check_Settlement_Request[nPlayerID] then
        print("Error:请求不存在")
        return false
    end
    if not Check_Settlement_Request[nPlayerID].base then
        return false
    end
    if not Check_Settlement_Request[nPlayerID].customData then
        return false
    end
    return true

    
end

function game_event:CheckGameEnd(playernumber)
    if _G.GAME_UPDATE_SUCCESS_INDEX==playernumber then --当信息全部储存完毕才结束游戏
        if _G.GAME_CHANLLENGE_Contest_Type>=1 and  _G.GAME_Contest_send==false then --说明需要完成排行榜数据单没完成
            print("等待排行榜数据完成")
            return false
        end
        Timers:CreateTimer(8, function()
            if GAME_ENDLESS_WAVE_COUNT>0 then
                GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
            else
                GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
            end       
        end)
    else
        return false
    end
end

--游戏结算失败，给出提示
function game_event:UpdateFailed(nPlayerID,encoded)
    
    -- GameRules:SendCustomMessage("DOTA_CUSTOM_UpdateFailed", 1, nPlayerID)


    local gameEvent = {}
    gameEvent["player_id"] = nPlayerID
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#DOTA_CUSTOM_UpdateFailed2"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    local gameEvent = {}
    gameEvent["player_id"] = nPlayerID
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#DOTA_CUSTOM_UpdateFailed3"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    -- GameRules:SendCustomMessage(encoded, 1, nPlayerID)
    -- print(encoded)
end

function game_event:OnPlayerReceiveBonusReward(nPlayerID,id)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap  --获取到数据表
    -- spellmap[nPlayerID].bonus[id] ={
    --     bonusName = name,
    --     bonusId = id,
    --     bonusPlatinum = platinum,
    --     bonusGold = gold,
    --     bonusExp = exp,
    -- } 
    if spellmap[nPlayerID].bonus[tonumber(id)].bonusName=="Shop_bonus_info_contestBonus_9" then
        -- 领取到了内卷之王奖励
        customDataManager:Modify_king_of_involution(nPlayerID)
    end


end
--生成奖励插入传入的表
--形参 地图名  玩家的当前技能表
--保存用技能表为self.newspellstable
--其实不传表也可以的 不过都写完了就不改了
--技能表的结构是这样的
-- spells_table = {
--     {
--         name = "xxx",
--         exp = 0,
--     },
--     {
--         name = "xxx2",
--         exp = 0,
--     }
-- }
-- 随机生成结算技能书
function game_event:SpawnBonusSpellWithMapname(Mapname,newspellstable,spellstable)
    local Spells_library_length = #Spells_library[Mapname]
    local bonus_spell_name = Spells_library[Mapname][RandomInt(1, Spells_library_length)]--给出第一张技能书
    --先看一下表里有没有这个技能了 有就说明此前已产生过奖励 再加一次经验即可
    for i, value in ipairs(newspellstable) do
        if value.name==bonus_spell_name then
            newspellstable[i].exp = newspellstable[i].exp + 1500
            -- PrintTable(newspellstable)
            return bonus_spell_name  --加完返回 下面不用执行了
        end
    end


    -- print("bonus_spell_name=="..bonus_spell_name)
    if spellstable[bonus_spell_name] then --说明有这个技能了
        local bonus_spell = {}
        bonus_spell.name= bonus_spell_name
        bonus_spell.exp = tonumber(spellstable[bonus_spell_name] ) + 1500  --奖励500经验并生成新的
        table.insert(newspellstable, bonus_spell)  --插入表  
    else
        local bonus_spell = {}
        bonus_spell.name= bonus_spell_name
        bonus_spell.exp = 1  --新技能解锁每经验值
        table.insert(newspellstable, bonus_spell)  --插入表  
    end
    -- PrintTable(newspellstable)
    return bonus_spell_name
end


function game_event:SpawnBonusSpellRandom(newspellstable,spellstable )

    -- bossSpell
    local spellList = Spells_library.camp_defense
    if 2>=RandomFloat(1, 100) then
        spellList = Spells_library.bossSpell
    end
    local bonus_spell_name =spellList[RandomInt(1, #spellList)]--给出第一张技能书
    --先看一下表里有没有这个技能了 有就说明此前已产生过奖励 再加一次经验即可
    for i, value in ipairs(newspellstable) do
        if value.name==bonus_spell_name then
            newspellstable[i].exp = newspellstable[i].exp + 1500
            -- PrintTable(newspellstable)
            return bonus_spell_name  --加完返回 下面不用执行了
        end
    end
    -- print("bonus_spell_name=="..bonus_spell_name)
    if spellstable[bonus_spell_name] then --说明有这个技能了
        local bonus_spell = {}
        bonus_spell.name= bonus_spell_name
        bonus_spell.exp = tonumber(spellstable[bonus_spell_name] ) + 1500  --奖励500经验并生成新的
        table.insert(newspellstable, bonus_spell)  --插入表  
    else
        local bonus_spell = {}
        bonus_spell.name= bonus_spell_name
        bonus_spell.exp = 1  --新技能解锁每经验值
        table.insert(newspellstable, bonus_spell)  --插入表  
    end
    -- PrintTable(newspellstable)
    return bonus_spell_name
end






function game_event:GetPlayerData(nPlayerID,spellMap,callback)
    player_database:login_with_steamID(nPlayerID,spellMap,callback)
end

function game_event:BuySpellBonus(playerid,count,platinumCost)
    local nPlayerID = playerid
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    -- local player = PlayerResource:GetPlayer(nPlayerID)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap


    local bonus_exp = 0
    if steamID ~= "0" then
        print("开始生成技能奖励 购买技能")
        
        -- local index = 0
        local index = nPlayerID
        local spellstable = spellmap[nPlayerID].spells  --属于这个玩家的技能表

        --生成空表
        self.newspellstable = {}
        --根据地图名给出属于该地图的技能奖励
        local map_name = GetMapName()  

        for i = 1,count, 1 do
            local bonus_spell_name =  self:SpawnBonusSpellRandom(self.newspellstable,spellstable)
        end



        local newData ={}

        newData.playerInfo = {}
        newData.playerInfo.steamId = steamID 
        newData.playerInfo.giftBit = spellmap[nPlayerID].playerinfo.giftBit
        local steamName = PlayerResource:GetSteamAccountID(nPlayerID)
        newData.playerInfo.steamName = steamName
        -- newData.playerInfo.vip = "1"

        local infotable = spellmap[index].playerinfo  --属于这个玩家的技能表



        local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
        local max_xp = spellsXPTable[25]   --最高等级的经验值
        print("max_xp ="..max_xp)



        bonus_exp = bonus_exp-bonus_exp%1  --整数化

        -- newData.playerInfo.platinum ="500"  --测试白金
        -- local spells = {}
        --将技能储存到表里
        newData.playerSpellsList = {}
        for i, value in ipairs(self.newspellstable) do
            local newtable = {}
            newtable.steamId = steamID 
            newtable.spellName = value.name
            local spell_exp = value.exp
            if spell_exp>max_xp then  --当技能经验超过最大值转化为可靠经验
                bonus_exp = bonus_exp + (spell_exp-max_xp)
                spell_exp = max_xp
                value.exp = max_xp
            end
            newtable.exp = spell_exp

            -- local spellInfo = {
            --     spellName = value.name,
            --     exp = spell_exp,
            -- }

            -- table.insert(spellInfo, newtable)
            table.insert(newData.playerSpellsList, newtable)
        end

        -- 处理可靠经验
        -- print(bonus_exp)
        -- local exp = infotable.reliableExp + bonus_exp
        -- newData.playerInfo.reliableExp = tostring(exp)
        -- newData.playerInfo.platinum = later_platinum

        newData.playerInfo.reliableExp = bonus_exp
        newData.playerInfo.platinum = -platinumCost
        
        
        --提示信息 用于奖励提示
        local message_info = {
            reliableExp = bonus_exp,
            gold = 0,
        }

        newData.token = _G.GAME_GLOBAL_KEY
        -- CustomGameEventManager:Send_ServerToPlayer(player, "SetBonus", {sMessage=self.newspellstable,playerinfo = message_info})  --给出奖励提示
        local encoded = json.encode(newData)
        player_database:UpdateUserData_with_steamID_BuySpell(nPlayerID,encoded,self.newspellstable,message_info,newData)

    end  
end

-- 计算基础奖励
function game_event:CalculateBaseBonus(finished_wave)
    local bonus_exp = 0
    local bonus_gold = 0
    --计算金币奖励
    --每3波增加1金币
    bonus_gold = finished_wave/3
    bonus_gold  = bonus_gold -bonus_gold %1 
    --难度奖励与经验值计算放一起
    --计算可靠经验奖励与金币奖励
    if finished_wave>0 then --过了第一波才有奖励
        --波数加成
        for i = 1, finished_wave, 1 do
            if i<=5 then
                bonus_exp = bonus_exp + 10
            elseif i<=10 then
                bonus_exp = bonus_exp + 20
            elseif i<=15 then
                bonus_exp = bonus_exp + 30
            elseif i<=20 then
                bonus_exp = bonus_exp + 50
            end
            if i%10==0 then bonus_exp = bonus_exp + 200 end --boss关额外奖励
        end
        --难度加成
        if _G.GAME_DIFFICULTY==2 then 
            bonus_exp = bonus_exp*1.3    
            bonus_gold = bonus_gold *1.2
        else
            if _G.GAME_DIFFICULTY==3 then
                bonus_exp = bonus_exp*1.7
                bonus_gold = bonus_gold*1.5
            else
                if _G.GAME_DIFFICULTY==4 then
                    bonus_exp = bonus_exp*2
                    bonus_gold = bonus_gold*1.8
                end
            end
        end
        local index = GetBonusIndex_Challenge()
        bonus_exp = bonus_exp +_G.GAME_BONUS_EXP*index
        bonus_gold = bonus_gold + _G.GAME_BONUS_GOLD*index
        -- 先计算完苦难的量
        if finished_wave>20 then
            local bonus_wave = (finished_wave-20)
            bonus_exp = bonus_exp+bonus_wave*400
            bonus_gold = bonus_gold+bonus_wave*6
        end
        --试炼难度加成
        local challengeDifIndex = GetBonusIndex_ChallengeDifficulty()
        bonus_exp = bonus_exp * challengeDifIndex
        bonus_gold = bonus_gold*challengeDifIndex
    end

    -- 无尽奖励
    local count = _G.GAME_ENDLESS_WAVE_COUNT
    bonus_exp = bonus_exp +math.min(28*count*(1+count*0.01),15000)
    bonus_gold = bonus_gold +math.min(0.3*count*(1+count*0.01),120)

    -- bonus_exp = bonus_exp +math.min(18*count*(1+count*0.01),20000)
    -- bonus_gold = bonus_gold +math.min(0.25*count*(1+count*0.01),150)


    --[[无尽奖励改 joker
    local count = _G.GAME_ENDLESS_WAVE_COUNT
    bonus_exp = bonus_exp +math.min(28*count,30000)
    bonus_gold = bonus_gold +math.min(0.3*count,300)]]

    --百相的额外奖励
    if _G.GAME_Reincarnation_Wave>=1 then
        local gain = 1+0.015*_G.GAME_Reincarnation_Wave
        bonus_exp = bonus_exp * gain
        bonus_gold = bonus_gold * gain
    end


    local data = {
        bonus_gold =bonus_gold,
        bonus_exp = bonus_exp,
    }
    return data
end
-- 计算技能书奖励
function game_event:CalculateBaseSpellBookBonus(finished_wave)
    local bookCount = 0
    if finished_wave >=10 then  --击败了10波boss
        bookCount = bookCount + 1
    end
    if finished_wave >=20 then  --击败了20波boss
        bookCount = bookCount + 1
        if _G.GAME_DIFFICULTY==4 then --难4额外奖励
            bookCount = bookCount + 1
        end
    end
    --苦难挑战的额外奖励
    if _G.GAME_BONUS_BOOK>0 then
        local bonus_book =  _G.GAME_BONUS_BOOK
        bonus_book = bonus_book * GetBonusIndex_Challenge__SpellBook() * GetBonusIndex_ChallengeDifficulty_SpellBook()
        bonus_book =  bonus_book-bonus_book%1
        if bonus_book>=1 then
            for i = 1, math.floor(bonus_book), 1 do
                print("bonus book go")
                bookCount = bookCount + 1
            end 
        end
        bonus_book = _G.GAME_BONUS_BOOK%1*100
        -- print("bonus_book="..bonus_book)
        if bonus_book>=RandomInt(1, 100) then
            bookCount = bookCount + 1
        end
        
    end
    return bookCount
end


--用于回合结束时给出一些奖励提示
function game_event:WaveEndBonusInfo()
    local wave = _G.GAME_ROUND
    local new_bonus_book = 0
    if wave ==10 then  --击败了10波boss
        new_bonus_book = new_bonus_book + 1
    end
    if wave ==20 then  --击败了20波boss
        new_bonus_book = new_bonus_book + 1
        if _G.GAME_DIFFICULTY==4 then --难4额外奖励
            new_bonus_book = new_bonus_book + 1
        end
    end
    local bonus_from_challenge = 0
    if _G.GAME_BONUS_BOOK>0 then
        local bonus_book =  _G.GAME_BONUS_BOOK
        local index = GetBonusIndex_Challenge__SpellBook() * GetBonusIndex_ChallengeDifficulty_SpellBook()
        bonus_book = bonus_book * index
        bonus_book =  bonus_book-bonus_book%1
        if bonus_book>=1 then
            for i = 1, math.floor(bonus_book), 1 do
                bonus_from_challenge = bonus_from_challenge + 1
            end 
        end
    end
    if not self.current_bonus_book then
        self.current_bonus_book = 0
    end
    new_bonus_book = new_bonus_book - self.current_bonus_book+bonus_from_challenge
    self.current_bonus_book = bonus_from_challenge
    -- 仅在有新奖励时给出提示
    -- print("check spell="..new_bonus_book)
    if new_bonus_book>0 then
        -- print("go")
        local gameEvent = {}
        -- gameEvent["player_id"] = nPlayerID
        gameEvent["teamnumber"] = -1
        gameEvent["value1"] = new_bonus_book
        gameEvent["message"] = "#DOTA_HUD_SpellBook_Dropped"
        FireGameEvent( "dota_combat_event_message", gameEvent )
        
    end
    local data = self:CalculateBaseBonus(wave)
    if not self.current_bonus_exp then
        self.current_bonus_exp = 0
    end
    if not self.current_bonus_aurum then
        self.current_bonus_aurum = 0
    end
    if data.bonus_exp-self.current_bonus_exp>=1 then
        local bonus = math.floor(data.bonus_exp - self.current_bonus_exp)
        self.current_bonus_exp = self.current_bonus_exp + bonus
        local gameEvent = {}
        -- gameEvent["player_id"] = nPlayerID
        gameEvent["teamnumber"] = -1
        gameEvent["value1"] = bonus
        gameEvent["message"] = "#DOTA_HUD_exp_Dropped"
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end

    if data.bonus_gold-self.current_bonus_aurum>=1 then
        local bonus = math.floor(data.bonus_gold - self.current_bonus_aurum)
        self.current_bonus_aurum = self.current_bonus_aurum + bonus
        local gameEvent = {}
        -- gameEvent["player_id"] = nPlayerID
        gameEvent["teamnumber"] = -1
        gameEvent["value1"] = bonus
        gameEvent["message"] = "#DOTA_HUD_aurum_Dropped"
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end




end


-- 特殊修饰器
-- Special_AlertList = {
--     "modifier_unit_cooldownReduction",
-- }

function game_event:_CustomTogglePause(eventSourceIndex, event_data)

    local iPlayerID = event_data.PlayerID
    self.bIsPause = not self.bIsPause
    PauseGame(self.bIsPause)


end

function game_event:_CustomBuffAlert(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if player then

        local playerHero = player:GetAssignedHero() --拿到英雄
        local queryUnit = event_data.queryUnit
        local buffSerial = event_data.buffSerial
        local buffIndex = event_data.buffIndex
        local unit = EntIndexToHScript(queryUnit)
        -- local buff = EntIndexToHScript(buffSerial)
        -- print(unit);
        -- print(buff);
        if unit  then

            local alertType = 0
            if IsEnemy(unit,playerHero) then
                alertType = 1
            end

            local hModifier
            local caster
			local modifiers = unit:FindAllModifiers()
            if #modifiers>= buffIndex then
                if event_data.buffName and event_data.buffName == modifiers[buffIndex]:GetName() then
                    -- 处理特殊逻辑
                    hModifier = modifiers[buffIndex]
                    caster = hModifier:GetCaster()
                    if self["SpecialAlert_"..event_data.buffName] then
                        self["SpecialAlert_"..event_data.buffName](self,hModifier,alertType,event_data)
                        return
                    else
                        print("Error:没这个函数")
                    end
                    
                    
                end
            end

            if caster then
                caster= caster:entindex()
            else
                caster = -1
            end


            local data = {
                caller = nPlayerID,
                queryUnit = queryUnit,
                buffSerial = buffSerial,
                -- buffIndex =  event_data.buffIndex,
                alertType = alertType,
                caster = caster,
                
            }
            print("send")
            CustomGameEventManager:Send_ServerToAllClients("AlertBuff_JS", data)
        end
    end




end



function game_event:SpecialAlert_modifier_unit_cooldownReduction(hModifier,alertType,event_data)
    local queryUnit = event_data.queryUnit
    local buffSerial = event_data.buffSerial
    local nPlayerID = event_data.player_id
    -- local buffIndex = event_data.buffIndex
    -- local unit = EntIndexToHScript(queryUnit)
    local data = {
        caller = nPlayerID,
        queryUnit = queryUnit,
        buffSerial = buffSerial,
        -- buffIndex =  event_data.buffIndex,
        alertType = alertType,
        disableStack = 1,
        valueData = {
            
            specialType = 1,
            value = math.floor(hModifier:GetModifierPercentageCooldown())
        },

    }
    print("send")
    CustomGameEventManager:Send_ServerToAllClients("AlertBuff_JS_special", data)
end


-- function game_event:CheckPlayerLoginProgress(nPlayerID)



-- end
--技能奖励池
_G.Spells_library = {
    --营地守卫战地图技能奖励
    camp_defense = {
        "Advanced_Celestial_Hammer",
        "Advanced_Solar_Guardian",
        "Advanced_Luminosity",
        "Advanced_Starbreaker",
        "Advanced_Gods_Rebuke",
        "Advanced_Spear",
        "Advanced_Bulwark",
        "Advanced_Heart_Stopper_Aura",
        "Advanced_Spectral_Dagger",
        "Advanced_Desolate",
        "Advanced_Haunt",
        "Advanced_Dispersion",
        "Advanced_Berserkers_Call",
        "Advanced_Culling_Blade",
        "Advanced_Counter_Helix",
        "Advanced_Battle_Hunger",
        "Advanced_Reapers_Scythe",
        "Advanced_Ghost_Shroud",
        "Advanced_Death_Pulse",
        "Advanced_Poison_Nova",
        "Advanced_Poison_Sting",
        "Advanced_Plague_Ward",
        "Advanced_Venomous_Gale",
        "Advanced_Epicenter",
        "Advanced_Sand_Storm",
        "Advanced_Caustic_Finale",
        "Advanced_Burrow_Strike",
        "Advanced_God_Strength",
        "Advanced_Warcry",
        "Advanced_Storm_Bolt",
        "Advanced_Great_Cleave",
        "Advanced_Viscous_Nasal_Goo",
        "Advanced_Bristle_Back",
        "Advanced_Warpath",
        -- "Advanced_Void_time_walk",
        -- "Advanced_Chronosphere",
        -- "Advanced_Time_Drain",
        -- "Advanced_Time_Lock",
        "Advanced_Stifling_Dagger",
        "Advanced_Phantom_Strike",
        "Advanced_Coup_De_Grace",
        "Advanced_Blur",
        "Advanced_Blood_Lust",
        "Advanced_Blood_Sacrifice",
        "Advanced_Ice_Vortex",
        "Advanced_Chilling_Touch",
        "Advanced_Windrun",
        "Advanced_Powershot",
        "Advanced_Focus_Fire",
        "Advanced_Poison_Touch",
        "Advanced_Shallow_Grave",
        "Advanced_Shadow_Wave",
        "Advanced_Bad_Juju",
        "Advanced_Dual_Breath",
        "Advanced_Ice_Path",
        "Advanced_Liquid_Fire",
        "Advanced_Macropyre",
        "Advanced_Liquid_Frost",
        "Advanced_Malefice",
        "Advanced_Midnight_Pulse",
        "Advanced_Demonic_Conversion",
        "Advanced_Black_Hole",
        "Advanced_Nether_Blast",
        "Advanced_Decrepify",
        "Advanced_Nether_Ward",
        "Advanced_Life_Drain",
        "Advanced_Arc_Lightning",
        "Advanced_Static_Field",
        "Advanced_Lightning_Bolt",
        "Advanced_Thundergods_Wrath",
        "Advanced_Acid_Sparay",
        "Advanced_Greevils_Greed",
        "Advanced_Unstable_Concoction",
        "Advanced_Chemical_Rage",
        "Advanced_Blade_Fury",
        "Advanced_Blade_Dance",
        "Advanced_Omni_Slash",
        "Advanced_mist_coil",
        "Advanced_aphotic_shield",
        "Advanced_borrowed_time",
        "Advanced_frostmourne",
        "Advanced_overcharge",
        "Advanced_tether",
        "Advanced_spirits",
        "Advanced_fortunes_end",
        "Advanced_purifying_flame",
        "Advanced_fates_edict",
        "Advanced_false_promise",
        "Advanced_dragon_blood",
        "Advanced_kraken_shell",
        "Advanced_reactive_armor",
        "Advanced_shapeshift",
        "Advanced_elder_dragon_form",
        "Advanced_true_form",
        "Advanced_chaos_form",
        "Advanced_counterspell",
        "Advanced_metamorphosis",
        "Advanced_reincarnation",
        "Advanced_summon_wolves",
        "Advanced_rage",
        "Advanced_feast",
        "Advanced_enrage",
        "Advanced_take_aim",
        "Advanced_mana_shield",
        "Advanced_magic_blessing",
        "Advanced_split_shot",
        "Advanced_berserkers_blood",
        "Advanced_purification",
        "Advanced_repel",
        "Advanced_earth_spike",
        "Advanced_unleash",
        "Advanced_aether_remnant",
        "Advanced_dissimilate",
        "Advanced_astral_step",
        "Advanced_hoof_stomp",
        "Advanced_return",
        "Advanced_summon_Dave_Chisnall",
        "Advanced_Soul_Link",
        "Advanced_infest",
        "Advanced_Inner_Beast",
        "Advanced_Anchor_Smash",
        "Advanced_overpower",
        "Advanced_Arcane_Aura",
        "Advanced_split_earth",
        "Advanced_frost_arrows",
        "Advanced_marksmanship",
        "Advanced_frost_armor",
        "Advanced_lightning_storm",
        "Advanced_pulse_nova",
        "Advanced_Dragons_Lighting",
        "Advanced_unrivaled",
        "Advanced_Chaotic_Offering",
        "Advanced_Body_of_Effulgent_Beryl",
        "Advanced_Vengeance_Aura",
        "Advanced_aftershock",
        "Advanced_Chakra",
        "Advanced_hunter_in_the_night",
        "Advanced_stroke_of_fate",
        "Advanced_quadruple_chop",
        "Advanced_Einherjar",
        "Advanced_laser",
        "Advanced_Voodoo_Restoration",
        "Advanced_Chaos_Meteor",
        "Advanced_Vampiric_Spirit",
        "Advanced_gravity",
        "Advanced_astral_imprisonment",
        "Advanced_summon_water_element",
        "Advanced_Eldwurm_soul_Aethrak",
        "Advanced_summon_healing_ward",
        "Advanced_summon_earth_element",
        "Advanced_summons_undead_jack_the_ripper",
        "Advanced_Eldwurm_soul_Vahdrak",
        "Advanced_Eldwurm_soul_Uldorak",
        "Advanced_summons_ward_Aghanim_the_Wisest",
        "Advanced_Rot",
        "Advanced_Blood_grudge_Dagger",
        "Advanced_cook",
        "Advanced_clock_and_dagger",
        "Advanced_necromastery",
        "Advanced_Corrosive_Skin",
        -- "Advanced_empower",--不加入
        "Advanced_hyakkiyakou",
        "Advanced_fear_arua",
        "Advanced_water_prison",
        "Advanced_summon_Slime",
        "Advanced_bash_of_the_deep",
        "Advanced_Boundless_Strike",
        "Advanced_assassinate",
        "Advanced_corrosive_haze",
        "Advanced_invincible_army",
        "Advanced_chaos_strike",
        -- "Advanced_Electrostatic_Armor", --不加入
        -- "Advanced_Thunderstrike",  --不加入
        -- "Advanced_Acid_bomb",  --不加入

        "Advanced_cold_embrace",
        "Advanced_howl",
        "Advanced_lunar_blessing",
        "Advanced_Bloodrage",
        "Advanced_double_edge",
        "Advanced_enchant_totem",
        "Advanced_finger_of_death",
        "Advanced_brain_sap",
        "Advanced_summon_Forge_Spirit",
        "Advanced_lucent_beam",
        "Advanced_onslaught",
        "Advanced_arcane_bolt",
        "Advanced_Holy_Light_Shield",
        "Advanced_Eldwurm_soul_Byssrak",
        "Advanced_Eldwurm_soul_Lirrak",
        "Advanced_Eldwurm_soul_Indrak",
        "Advanced_Arcane_Replacement",
        "Advanced_ancient_seal",
        "Advanced_acorn_shot",
        "Advanced_whirling_death",
        "Advanced_timber_chain",
        "Advanced_infernal_blade",
        "Advanced_Sharpshooter",
        "Advanced_summon_demon_dark_rift",
        "Advanced_mystic_flare",
        "Advanced_shield_crash",
        "Advanced_bulldoze",
        "Advanced_Refraction",
        "Advanced_morph",
        "Advanced_summon_wind_element",
        "Advanced_presence_of_the_dark_lord",
        "Advanced_Moment_of_Courage",
        "Advanced_Tidebringer",
        "Advanced_summon_immortal_sarcophagus",
        "Advanced_Doom",
        "Advanced_heat_seeking_missile",
        "Advanced_Overload",
        "Advanced_uproar",
        "Advanced_pierce_the_veil",
        "Advanced_headshot",
        "Advanced_summon_humanoid_cave_troll",
        "Advanced_greater_bash",
        --"Advanced_fiery_soul",赤魂，不加入
        --"Advanced_light_strike_array",光击阵，不加入
        "Advanced_Burning_Spear",
        "Advanced_trace_on",
        "Advanced_Nightmare",
        "Advanced_Ghost_Purimn",
        "Advanced_Ghost_Saya",
        "Advanced_Ghost_Rocha",
        "Advanced_vaccum",
        "Advanced_moon_glaive",
        "Advanced_arcane_supremacy",
        "Advanced_curse",
        "Advanced_elder_dragon_form_ice",
        "Advanced_seahit",
        "Advanced_eye_of_the_storm",
    },

    --雷夫兽boss
    npc_monster_wave_10_1 = {
        "Advanced_Electrostatic_Armor",
        "Advanced_Thunderstrike",
    },
    --马格纳斯boss
    npc_monster_wave_31_1={
        "Advanced_shockwave",
        "Advanced_reverse_polarity",
        "Advanced_empower",
    },
    --小鹿boss
    npc_monster_wave_20_1={
        "Advanced_Impetus",  --黑
        "Advanced_Nature_Attendants",--黑
        "Advanced_Untouchable",--黑
    },
    --莉娜boss
    npc_hd_lina={
        "Advanced_dragon_slave",--黑
        "Advanced_laguna_blade",--黑
        "Advanced_light_strike_array",
        "Advanced_fiery_soul",
    },
    --斯莱瑞克
    npc_hd_fire_dragon={
        "Advanced_Eldwurm_soul_Slyrak",
    },
    

    --脑虫boss
    npc_hd_Brain_worm={
        "Advanced_Acid_bomb",--黑
    },

    --超维逆族
    npc_hd_Claszian_Apostasy={
        "Advanced_Chronosphere",--黑
        "Advanced_Time_Drain",--黑
        "Advanced_Time_Lock",--黑
        "Advanced_Void_time_walk",--黑
        "Advanced_Anti_time",--黑
    },

    ----绝境战·影魔
    npc_hd_Supreme_Nevermore={

    },

    bossSpell = {
        "Advanced_Electrostatic_Armor",
        "Advanced_Thunderstrike",
        "Advanced_shockwave",
        "Advanced_reverse_polarity",
        "Advanced_empower",
        "Advanced_Impetus",  --黑
        "Advanced_Nature_Attendants",--黑
        "Advanced_Untouchable",--黑
        "Advanced_dragon_slave",--黑
        "Advanced_laguna_blade",--黑
        "Advanced_light_strike_array",
        "Advanced_fiery_soul",
        "Advanced_Eldwurm_soul_Slyrak",
        "Advanced_Acid_bomb",--黑
        "Advanced_Chronosphere",--黑
        "Advanced_Time_Drain",--黑
        "Advanced_Time_Lock",--黑
        "Advanced_Void_time_walk",--黑
        "Advanced_Anti_time"--黑
    }
}


function GetTotalSpellCanbeUnlock()
    return #_G.Spells_library.camp_defense
end







-- 开始计时器来检测正常游戏模式下英雄是否全部死亡
-- 
function game_event:StartAliveChecking_General()
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("CheckAlive"), function()
        --print("checking")
        -- self:CheckPlayerAlive()
        Timers:CreateTimer(0.06, function()
            self:CheckPlayerAlive()
        end)
        return 1
    end, 0)
end







-- 检测游戏失败（当玩家都死亡时）
function game_event:CheckPlayerAlive()
    if  GameRules:IsGamePaused() then
        return 0.5
    end

    if _G.GAME_ROUND==20 and #_G.GAME_HERO_GROUP>1 and not _G.GAME_THE_LAST_ONE then
        local hero
        local alive = 0
        for _, unit in pairs(_G.GAME_HERO_GROUP) do
            if unit:IsAlive() then
                alive = alive +1
                hero = unit
            end
        end
        if hero and alive==1 then
            _G.GAME_THE_LAST_ONE = true
            hero:AddNewModifier(hero, nil, "modifier_the_last_hero", {duration = 120})
            EmitGlobalSound("custom_the_last_one")
        end
        
    end
    if _G.GAME_ENDLESSMODE_overtime == 0 then
        for _, unit in pairs(_G.GAME_HERO_GROUP) do
            if unit:IsAlive() then
                _G.GAME_FAIL_TIME = 0  --倒计时五秒
                return 1
            end
        end
    end
    --G.GAME_ENDLESSMODE_overtime == 1 时设置倒计时_G.GAME_FAIL_TIME =5
    if _G.GAME_ENDLESSMODE_overtime == 1 then
        _G.GAME_FAIL_TIME = 6
        print("_G.GAME_FAIL_TIME:".._G.GAME_FAIL_TIME)
    end
    -- 倒计时五秒后
    if _G.GAME_FAIL_TIME >=5 and not Game_State:IsGameEnd() and _G.GAME_IN  == 1  then

        --如果是奖励回合全员死亡 杀死奖励关的怪物 并结束当前回合

        if _G.GAME_ROUND==9 or _G.GAME_ROUND==19 then
            -- print("22222222222222")
            local units = FindUnitsInRadius(
            0,	-- int, your team number
            Vector(0,0,0),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            3000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            0,	-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
            )
            for _, unit in pairs(units) do
                if unit:GetUnitName()=="npc_monster_wave_9_1" or unit:GetUnitName()=="npc_monster_wave_19_1"  then
                    -- unit:ForceKill(true)
                    local modifier = unit:FindModifierByName("modifier_kill")
                    if modifier then
                        modifier:SetDuration(0.1, true)
                    end
	                -- unit:Kill(nil,nil)
                    -- print("kill!!!!")
                    -- unit:ModifyHealth(0,nil,true,0)
                    return 0.5
                end
            end
            return 0.5
        end
        -- 尝试触发黑洞第一奥义
        for _, unit in pairs(_G.GAME_HERO_GROUP) do
            local modifier = unit:FindModifierByName("modifier_Advanced_Black_Hole_unlock1")
            if modifier then
                modifier:OnEndTrigger()
                return 1
            end
        end
        -- 结束游戏 万策皆尽
        print("End the game")
        GameRules:SendCustomMessage("DOTA_CUSTOM_start_end_bonus", 1, -1)
        local event_data = { 
            wave =  _G.GAME_ROUND,  
        }
        FireGameEvent( "dota_on_game_fail", event_data )

        --计算玩家数
        local playernumber = 0
        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
            if steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED then
                playernumber = playernumber + 1
            end
        end
        --玩家数量计算完毕
        Game_State:SetGameEnd(true)

        if _G.GAME_LOGIN_SUCCESS_INDEX>=playernumber then

            game_event:GameEnd_bonus()  --仅当所有玩家都登录成功后启用奖励结算
            _G.GAME_GAME_ENDING = true

            Timers:CreateTimer(2, function()
                if not game_event:CheckGameEnd(playernumber) then
                    return 0.5
                end
            end)
        else
            GameRules:SendCustomMessage("DOTA_CUSTOM_LoginFailed_all", 1, -1)
            GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
        end
    end
    
    _G.GAME_FAIL_TIME = _G.GAME_FAIL_TIME + 1
    print("time:".._G.GAME_FAIL_TIME)
	return 1
end







return game_event