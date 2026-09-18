-- _G.BOSS_Defeated
function game_event:OnGameMonsterKilled( keys )
    local unit = EntIndexToHScript(keys.entindex_killed)
    
    ----------------英雄死亡播放音乐
    if unit:IsRealHero() and unit:IsTempestDouble() == false then
        if unit:IsReincarnating() == false then
          
            game_music:PlayDeathMusic()
            unit:SetTimeUntilRespawn(-1)
       
        end
    end
    --死亡的单位不在刷怪表里就不执行了
    if not IsInTable(unit,_G.GAME_MONSTER_TABLE) then
        return
    end
    --减少怪物量
    if IsInTable(unit,_G.GAME_MONSTER_TABLE) then
        _G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number - 1
        if _G.GAME_ROUND==10 or _G.GAME_ROUND==20 or _G.GAME_ROUND==25 then
            local name = unit:GetUnitName()
            table.insert(_G.BOSS_Defeated,name) 
        end
        local name = string.sub(unit:GetUnitName(),1,21)
        if name=="npc_monster_challenge" then
            local event_data = {
                unit =unit:entindex(),  
                attacker = keys.entindex_attacker,  
            }
            FireGameEvent( "dota_on_Challenge_boss_die", event_data )
        end
    end
    --提示怪物数量
    print(#_G.GAME_MONSTER_TABLE)
    print("------------")
    print(_G.GAME_MONSTER_TABLE_number)
    --为了预防BUG 需要多一个互斥操作
    --波数结束操作
    -- if _G.GAME_MONSTER_TABLE_number == 0   and _G.GAME_MONSTER_Triger == 0 then
    if _G.GAME_MONSTER_TABLE_number == 0   and _G.GAME_MONSTER_Triger == 0 and Myspawner:CheckAliveToEndGame()==0 then
        -- _G.GAME_MONSTER_Triger = 1
        -- game_event:EndWave_And_Create_Bonus()    
        game_event:EndWave_And_Create_Bonus()

        if _G.GAME_ROUND==19 then
            GameRules:GetGameModeEntity().CAddonTemplateGameMode:ReSetDamageTable()    
        end 
    end 
end



--英雄首次出现时候删除所有技能
function game_event:OnHeroFinishSpawn( keys )
    local unit = EntIndexToHScript(keys.heroindex)
    print("set up")
    if unit.spellsetup==nil then
        unit.spellsetup = 1
        for i=0,unit:GetAbilityCount() - 1 do
			local ability = unit:GetAbilityByIndex(i)
			if ability then
				unit:RemoveAbilityByHandle(ability)
			end
		end
        print("finished")
    end
    if tonumber(tostring(PlayerResource:GetSteamID(unit:GetPlayerOwnerID())))==76561198284686620 then
        -- print("diaoyong")
        CustomUI:DynamicHud_Create(unit:GetPlayerOwnerID(),"Mytext_button","file://{resources}/layout/custom_game/Mytext_button.xml",nil)
        CustomUI:DynamicHud_Create(unit:GetPlayerOwnerID(),"Mytext_button2","file://{resources}/layout/custom_game/Mytext_button2.xml",nil)
        -- _G.GAME_CAN_TEST = true
    end
    if _G.GAME_IN~=1 then
        game_music:PlayRestMusic()
        -- EmitGlobalSound("greevil_mega_spawn_Stinger")
    
    end
    _G.GAME_IN = 1
    --添加到玩家表用于检测游戏失败
    local bottle = unit:AddItemByName("item_new_bottle")
    bottle:SetSellable(false)
    table.insert(_G.GAME_HERO_GROUP,unit)
    unit:HeroLevelUp(false)
    unit:HeroLevelUp(false)

    --测试增加等级
    -- if IsInToolsMode() or _G.GAME_debugTesting then
    --     for i = 1, 15, 1 do
    --         unit:HeroLevelUp(false)
    --     end
    -- end
    PlayerResource:SetCameraTarget(unit:GetPlayerID(), unit)
    Timers:CreateTimer(1, function()
        PlayerResource:SetCameraTarget(unit:GetPlayerID(), nil)
        local newAbility = unit:AddAbility("Default_Move")
        newAbility:SetLevel(1)
        if IsInToolsMode() then
            CheckToolSpell(unit)
        end
       


    end)


    
end




--对创建的单位进行一些初始设置
function game_event:OnNpcSpawn( keys )
    local unit = EntIndexToHScript(keys.entindex)
    if  unit.setupFnished then
        if unit:IsRealHero() then
            unit:RemoveModifierByName("modifier_fountain_invulnerability")
        end
        return
    end
    -- if not unit:IsRealHero() then
    --     return
    -- end
    --初始化单位属性


    unit:UpdateOriginModel()

    --值得一提的是 无论是治疗还是吸血都是用heal()实现的，每个逻辑里都有单独的处理
    --但是 吸血不会受到治疗增强影响  同样治疗也不会受到吸血增强影响
    --但是它们共同会受到no_heal的影响（参考冰魂大）


    unit.Bonus_gold = 0       --额外的基础金币奖励

    unit.IsRanger = unit:IsRangedAttacker()  --记录初始的攻击类型
    unit.RangerFrom = 0   --记录当前转化为远程状态的状态数（状态添加时+1 销毁时-1）
    unit.Form_MODIFIER_NAME = ""   --记录当前变形的修饰器



    -- unit:AddNewModifier(unit, nil, "modifier_unit_status_Resistance", {})  --用于显示状态抗性

    if unit:GetTeamNumber()==3 or unit:GetTeamNumber() ==1 then
        local delay = 100
        if _G.GAME_ROUND==10 or _G.GAME_ROUND==20 then
            delay = 200
        end
        Timers:CreateTimer(delay, function()
            if unit and not unit:IsNull() and  unit:IsAlive() then
                
                unit:AddNewModifier(unit, nil, "modifier_creeps_power", {})  --野怪狂暴
            end
        end)
        -- if unit:GetHealth()>=100 then
        --     unit:AddNewModifier(unit, nil, "modifier_debug_2", {duration = 0.02})
        -- end


    end

    if unit:IsRealHero()  then
        local playerID = unit:GetPlayerID()
        _G.Game_Item_ReRoll_chance[playerID] = 4
        _G.Game_Challenge_ReRoll_chance[playerID] = 6
 
        unit:AddNewModifier(unit, nil, "modifier_hero_light", {})   --附带一些特殊功能
        unit:AddNewModifier(unit, nil, "modifier_hero_custom_data_manager", {})   --自定义字段管理器
        unit:AddNewModifier(unit, nil, "modifier_hero_achievement_bonus", {})   --成就奖励

        
        unit:GameTimer(10, function()
        --初始化特权
        --获取VIP表
       
        
        local player =PlayerResource:GetPlayer(playerID)
        -- CustomNetTables:SetTableValue( "player", tostring(playerID), {player =player } )  --更新网表
       

        if playerID then
            
            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
            --如果未能链接到服务器 游戏结束
            if not spellmap or not spellmap[playerID] or not _G.GAME_LOGIN[playerID] then
                
                if not IsInToolsMode() then
                    GameRules:SendCustomMessage("no_spell_map", 1, -1)
                    GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
                end
                print("有玩家尚未连接至服务器")
            
                return
            end

            local map = spellmap[playerID]
            
            local spells = map.spells
            -- PrintTable(spells)，这里是全队可叠加的奖励参数+15%
            if IsNewPlayer(spells) then
                _G.GAME_BONUS_INDEX = _G.GAME_BONUS_INDEX +0.15
                unit:AddNewModifier(unit, nil, "modifier_novice_player", {}) 
            end
            if GetSpellCount(spells)<=5 then
                -- 及其新的玩家
                unit:AddNewModifier(unit, nil, "modifier_novice_player_particle", {duration = -1}) 
                -- particles/newplayer/move_to_arrow/effect_goal.vpcf
            end


            




            local viptable = map.vip  --属于这个玩家的VIP

            --傻力特权
            if viptable["Shop_fool"] then
                unit:AddNewModifier(unit, nil, "modifier_fool_power", {}) 
            end
            if viptable["Shop_king_of_translation"] then
                unit:AddNewModifier(unit, nil, "modifier_king_of_translation", {}) 
            end
            --睡王特权
            if viptable["Shop_king_of_sleeping"] then
                unit:AddNewModifier(unit, nil, "modifier_Sleeping_king", {}) 
            end
            if viptable["Shop_king_of_challenge"] then
                unit:AddNewModifier(unit, nil, "modifier_Shop_king_of_challenge"..RandomInt(1, 3), {}) 
            end
            if viptable["Shop_old_player"] then  --内测玩家
                if not unit.oldalready then
                    unit:AddItemByName("item_hd_Treasure1")
                    unit.oldalready = true
                end
            end 

            if viptable["Shop_first_N8"] then  --巅峰造极
                unit:AddNewModifier(unit, nil, "modifier_Shop_first_N8", {}) 
            end
            if viptable["Shop_king_of_bug"] then  --BUG统御者
                unit:AddNewModifier(unit, nil, "modifier_Shop_king_of_bug", {}) 
            end
            if viptable["Shop_Novice_tutor"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_Novice_tutor", {}) 
            end
            if viptable["Shop_Publicity_Ambassador"] then 
                unit:AddNewModifier(unit, nil, "modifier_Shop_Publicity_Ambassador", {}) 
            end
            if viptable["Shop_noob"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_noob", {}) 
            end
            if viptable["Shop_noob2"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_noob2", {}) 
            end
            if viptable["Shop_Dove_of_peace"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_Dove_of_peace", {}) 
            end
            if viptable["Shop_adviser"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_adviser", {}) 
            end
            if viptable["Shop_tool"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_tool", {}) 
            end
            if viptable["Shop_The_blessing_of_good_luck"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_The_blessing_of_good_luck", {}) 
            end
            if viptable["Shop_water"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_water", {}) 
            end
            if viptable["Shop_Bullshit"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_Bullshit", {}) 
            end
            if viptable["Shop_Athenas_blessing"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_Athenas_blessing", {}) 
            end   
            if viptable["Shop_sendBug_man"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_sendBug_man", {}) 
            end   
            if viptable["Shop_sendBug_man_2"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_sendBug_man_2", {}) 
            end   
            if viptable["Shop_sendBug_man_3"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_sendBug_man_3", {}) 
            end   
            if viptable["Shop_sendBug_man_4"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_sendBug_man_4", {}) 
            end   
            if viptable["Shop_sendBug_man_5"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_sendBug_man_5", {}) 
            end   
            if viptable["Shop_artifact_bonus_exp_2"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_artifact_bonus_exp_2", {}) 
            end   
            if viptable["Shop_artifact_bonus_exp_3"] then  
                unit:AddNewModifier(unit, nil, "modifier_Shop_artifact_bonus_exp_3", {}) 
            end
        end
        -- 没选难度则3秒后重新判定
        if _G.Selected_Difficulty_index and _G.Selected_Difficulty_index<=0 then
			return 3
		end
        print("选择难度参数为=",_G.Selected_Difficulty_index)
        if Game_State:IsInChaoticEra() then
            -- 乱纪元buff
            if GetPlayerCount()==1 then
                unit:AddNewModifier(unit, nil, "modifier_chaotic_players_1", {})  
            elseif GetPlayerCount()==2 then
                unit:AddNewModifier(unit, nil, "modifier_chaotic_players_2", {}) 
            elseif GetPlayerCount()==3 then
                unit:AddNewModifier(unit, nil,"modifier_chaotic_players_3", {}) 
            elseif GetPlayerCount()==4 then
                unit:AddNewModifier(unit, nil,"modifier_chaotic_players_4", {}) 
            elseif GetPlayerCount()==5 then
                unit:AddNewModifier(unit, nil,"modifier_chaotic_players_5", {}) 
            end 
            unit:AddNewModifier(unit, nil, "modifier_boss_rune", {})
            unit:AddNewModifier(unit, nil, "modifier_chaotic_spell_amp", {})
            --print("添加boss_rune完成")

        else
            -- 常规模式buff
            if GetPlayerCount()==1 then
                unit:AddNewModifier(unit, nil, "modifier_wolf_power", {})  
            elseif GetPlayerCount()==2 then
                unit:AddNewModifier(unit, nil, "modifier_it_takes_two", {}) 
            elseif GetPlayerCount()==3 then
                unit:AddNewModifier(unit, nil, "modifier_Trine", {}) 
            end
            unit:AddNewModifier(unit, nil, "modifier_hd_endless_tired", {})
        end
        -- unit:AddItemByName("item_act3_choice")--第三赛季
        unit:AddNewModifier(unit, nil, "modifier_chinese_event_guoqing_2025", {})--常驻圈圈
        
        if not self.act4_check then
            ShrineSystem:init()
            self.act4_check = true
        end
        if _G.Selected_Difficulty_index ~= 7 and _G.Selected_Difficulty_index ~= 8 then
            
        end
     end)
     unit.setupFnished = true

    end
    

    Timers:CreateTimer(0, function()

        if unit and not unit:IsNull() then
            -- print("unit=",unit)
            -- print(unit:GetUnitName())
            -- print(unit:GetClassname())
            -- if unit:GetUnitName()=="" then
            --     print("return")
            --     return
            -- end
            -- print("111111111111111")
   
            if unit:GetClassname()=="npc_dota_base" and not unit:GetUnitName()=="npc_dota_wisp_spirit" then
                -- print("22222222222")
                return
            end
            -- if unit:GetUnitName()~="npc_dota_thinker" then
            --     print("return 2")
            --     return
            -- end
            local ability = unit:AddAbility("unit_state")
            if ability then
                -- print("333333333")
                if unit:GetUnitName()~="npc_dota_thinker" and unit:GetTeamNumber()==DOTA_TEAM_GOODGUYS  then
                    PassiveAbilitySwap(unit,"unit_state")  
                    unit:SwapAbilities("unit_state", "unit_state", false, false)
                end

            end

            if unit:IsRealHero() then
                unit:SetStashEnabled(false)
            end
        end

    end)

    


    

    


end
