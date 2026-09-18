

-- local whiteList = {
--     "365218907", --好友位
--     "868069844", --长尾
--     "240390525", --樱小路
--     "1129080401", --混子
--     "158623402", --DIO 76561198118889130
--     "137330715", --复读机
--     "1069333874", --Nirvana
--     "86862668", --阿杰
--     "353885092",  --火鸡
--     "324420892",  --我
--     "298249262",  --UU  76561198258514990
--     "87852665", --卡扎克斯
--     "183996367", --这个世界太乱
--     "171803542", --平安喵塔 76561198132069270
--     "195636889", --菜鸡
--     "161713922", --MAO
--     "151062565", --寡人
--     "141379407", --黄毛哥
--     "199950202",  --羲 Beasts don't ban my lc
--     "842548078",--羲的朋友
--     "884619621", --老街阿怪
--     "164191566", --阿俊
--     "140038616", --cnm
--     "140162180", --cnm
--     "396799582", --村上栽树
--     "170141144", --理查德
--     "1086089083", --stop
--     "143822886", --星光最后的余烬  
--     "137263048", --Two Magic  
--     "223238259",--Two Magic
--     "126277419",--高富帅
--     "149983935", --情感僵尸
--     "885201966",--小号
--     "397416243", --Fumée
--     "114885508",
--     "153755765", --メ雪源づ
--     "134283817", --快乐浪
--     "360857981",--顺言 
--     "399571558", --Kirky
-- }

function uimanager:_CheckDifficulty(eventSourceIndex, event_data)
    -- print("checking!!!!")
    local spellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellMap or not spellMap[0] then
        
        Timers:CreateTimer(2, function()
            self:_CheckDifficulty(eventSourceIndex, event_data)
        
        end)
        return
    end

  
    if _G.GAME_DIFFICULTY==0 then
        local wave =  spellMap[0].playerinfo.difficultyWave
        if  GAME_LOGIN_SUCCESS_INDEX < GAME_PLAYER_number then
            GameRules:SendCustomMessage("#DOTA_CUSTOM_fail_login_info", 1, -1)
            GameRules:SendCustomMessage("GAME_LOGIN_SUCCESS_INDEX="..GAME_LOGIN_SUCCESS_INDEX, 1, -1)
            GameRules:SendCustomMessage("GAME_PLAYER_number="..GAME_PLAYER_number, 1, -1)
            return
        end
        local totalSpellsRequire = GetTotalSpellCanbeUnlock()*Chaotic_Era_Spell_Require_Index
        local haveNewPlayer = 0
        local shouldUnlockChaoticEra = 1
        if not Enable_Chaotic_Era then
            shouldUnlockChaoticEra = 0
        end

        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
            
            -- CustomNetTables:SetTableValue( "playerSpellLevelInfo", tostring(nPlayerID), {adavanced = 5} )  --初始化网表
            if steamID ~= "0" then
                local map = spellMap[nPlayerID]
        
                local spells = map.spells
                -- PrintTable(spells)
                if IsNewPlayer(spells) then
                    haveNewPlayer = 1
                end
                -- if GetSpellCount(spells)<20 then
                --     shouldUnlockChaoticEra = 0
                -- end
            end
    
        end
        -- for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        --     -- local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        --     if IsInTable(tostring(PlayerResource:GetSteamAccountID(nPlayerID)),whiteList) then
        --         shouldUnlockChaoticEra = 1
        --         print("白名单开启乱纪元")
        --         break
        --     end
        -- end


        

        



        local sendWindow = false
        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
            if steamID ~= "0" then
                local player = PlayerResource:GetPlayer(nPlayerID)
                if player and PlayerResource:IsActivated(nPlayerID) then
                    local data = {
                        index = -1,
                        wave = wave+1,
                        newPlayer = haveNewPlayer,
                        shouldUnlockChaoticEra = shouldUnlockChaoticEra,
                    }
                    CustomGameEventManager:Send_ServerToPlayer(player, "ShowDifficulty",data)
                    sendWindow = true
                    break
                end
              
            end
    
        end
        if not sendWindow then
            Timers:CreateTimer(2, function()
                self:_CheckDifficulty(eventSourceIndex, event_data)
            
            end)
        end

      
       
    end
  
end


function uimanager:SendWaveUi(player)
    local index = _G.GAME_DIFFICULTY
    local wave = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[0].playerinfo.difficultyWave+1
    local sendInfo = 0
    CustomGameEventManager:Send_ServerToAllClients("SetDifficultyInfo", {index=index,wave=wave,sendInfo=sendInfo})
    if not _G.GAME_Hide_select then
        sendInfo = 1
        CustomGameEventManager:Send_ServerToPlayer(player, "SetDifficultyInfo", {index=index,wave=wave,sendInfo=sendInfo}) 
    end
end


GAME_PARTICLES_DIFFICULTY_SELECT = {

    "particles/new_effect/difficulty_select/difficulty_selsect_3_screen_arcane_drop.vpcf",
    "particles/new_effect/difficulty_select/difficulty_selsect_1_screen_arcane_drop.vpcf",
    "particles/new_effect/difficulty_select/difficulty_selsect_6_screen_arcane_drop.vpcf",
    "particles/new_effect/difficulty_select/difficulty_selsect_7_screen_arcane_drop.vpcf",
    "particles/generic_gameplay/screen_arcane_drop.vpcf",
    "particles/new_effect/difficulty_select/difficulty_selsect_2_screen_arcane_drop.vpcf",
    "particles/new_effect/difficulty_select/difficulty_selsect_4_screen_arcane_drop.vpcf",
    "particles/new_effect/difficulty_select/difficulty_selsect_5_screen_arcane_drop.vpcf",
    "particles/new_effect/difficulty_select/difficulty_9/_arcane_drop.vpcf",
    "particles/new_effect/difficulty_select/difficulty_10/new_effect/difficulty_select/difficulty_9/_arcane_drop.vpcf",

}


GAME_SOUND_DIFFICULTY_SELECT = {

    "awolnation_01.music.ganked_med",
    "diretide_select_target_Stinger",
    "diretide_eventstart_Stinger",
    "terrorblade_arcana.stinger.buy_back",
    "valve_ti4.stinger.radiant_lose",
    "terrorblade_arcana.stinger.respawn",
    "valve_dota_001.stinger.dire_lose",
    "valve_ti7.stinger.radiant_lose",
    "shop_jbrice_01.stinger.radiant_lose",
    "awolnation_01.music.ganked_med",
}




function uimanager:PlayDifficultyParticle(difficulty)
    EmitGlobalSound("PauseMinigame.TI10.Selection")  --播放难度选择音效
    local heroes = GetAllRealHeroes()
    if #heroes>0 then
        local particle = ParticleManager:CreateParticle(GAME_PARTICLES_DIFFICULTY_SELECT[difficulty], PATTACH_POINT_FOLLOW, heroes[1])
        ParticleManager:SetParticleControl(particle, 0, heroes[1]:GetAbsOrigin())
        Timers:CreateTimer(1.8, function()
            ParticleManager:DestroyParticle(particle,false)  
            ParticleManager:ReleaseParticleIndex(particle)  
        end)
    end
    Timers:CreateTimer(0.4, function()
        EmitGlobalSound(GAME_SOUND_DIFFICULTY_SELECT[difficulty])  --播放难度选择音乐
	end)
end