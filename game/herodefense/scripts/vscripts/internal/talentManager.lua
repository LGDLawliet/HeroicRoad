print("talentManager load....")
talentManager = talentManager or class({})
-- require("internal/timers")
function talentManager:init(bReload)

    if not bReload then
        self.playerTalent = {} --记录玩家是否完成了天赋配置
        self.PlayerHeroTalent={}   --记录玩家选择的英雄有哪些天赋可以选
    end


    CustomUIEvent("SelectTelent", Dynamic_Wrap(self, "_SelectTelent"), self)
    CustomUIEvent("CheckPlayerTalent", Dynamic_Wrap(self, "_CheckPlayerTalent"), self)
    CustomUIEvent("CheckPlayerHeroTalent", Dynamic_Wrap(self, "_CheckPlayerHeroTalent"), self)
    CustomUIEvent("GetMarketTalentTable", Dynamic_Wrap(self, "_GetMarketTalentTable"), self)



    -- CustomGameEventManager:RegisterListener("SelectTelent", function(...)
    --     return self:_SelectTelent(...)
    -- end)
    -- -- print("init")
    -- CustomGameEventManager:RegisterListener("CheckPlayerTalent", function(...)
    --     return self:_CheckPlayerTalent(...)
    -- end)

    -- CustomGameEventManager:RegisterListener("CheckPlayerHeroTalent", function(...)
    --     return self:_CheckPlayerHeroTalent(...)
    -- end)

    -- CustomGameEventManager:RegisterListener("GetMarketTalentTable", function(...)
    --     return self:_GetMarketTalentTable(...)
    -- end)

    self.MarketTalentTable ={
        --"heroTalent_npc_dota_hero_doom_bringer_2", --测试中
        "heroTalent_npc_dota_hero_antimage_2",
        "heroTalent_npc_dota_hero_phantom_assassin_2",
        "heroTalent_npc_dota_hero_snapfire_2",
        "heroTalent_npc_dota_hero_lion_2",
        "heroTalent_npc_dota_hero_abyssal_underlord_2",
        "heroTalent_npc_dota_hero_bounty_hunter_2",
        "heroTalent_npc_dota_hero_pudge_2",
        "heroTalent_npc_dota_hero_necrolyte_2",
        "heroTalent_npc_dota_hero_zuus_2",
        "heroTalent_npc_dota_hero_wisp_2",
        "heroTalent_npc_dota_hero_warlock_2",
        "heroTalent_npc_dota_hero_witch_doctor_2",
        "heroTalent_npc_dota_hero_earthshaker_2",
        "heroTalent_npc_dota_hero_shadow_shaman_2",
        "heroTalent_npc_dota_hero_silencer_2",
        "heroTalent_npc_dota_hero_obsidian_destroyer_2",
        "heroTalent_npc_dota_hero_terrorblade_2",
        "heroTalent_npc_dota_hero_treant_2",
        "heroTalent_npc_dota_hero_undying_2",
        "heroTalent_npc_dota_hero_slark_2",
        "heroTalent_npc_dota_hero_legion_commander_2",
        "heroTalent_npc_dota_hero_mirana_2",
        "heroTalent_npc_dota_hero_nyx_assassin_2",
        "heroTalent_npc_dota_hero_magnataur_2",
        "heroTalent_npc_dota_hero_omniknight_2",
        "heroTalent_npc_dota_hero_tidehunter_2",
        "heroTalent_npc_dota_hero_kunkka_2",
        "heroTalent_npc_dota_hero_invoker_2",
        "heroTalent_npc_dota_hero_faceless_void_2",
        "heroTalent_npc_dota_hero_furion_2",
        "heroTalent_npc_dota_hero_storm_spirit_2",
        "heroTalent_npc_dota_hero_slardar_2",
        "heroTalent_npc_dota_hero_dragon_knight_2",
        "heroTalent_npc_dota_hero_luna_2",
        "heroTalent_npc_dota_hero_razor_2",
        "heroTalent_npc_dota_hero_viper_2",
        "heroTalent_npc_dota_hero_phantom_lancer_2",
        "heroTalent_npc_dota_hero_troll_warlord_2",
        "heroTalent_npc_dota_hero_naga_siren_2",
        "heroTalent_npc_dota_hero_sven_2",
        "heroTalent_npc_dota_hero_life_stealer_2",
        "heroTalent_npc_dota_hero_death_prophet_2",
        "heroTalent_npc_dota_hero_grimstroke_2",
        "heroTalent_npc_dota_hero_pangolier_2",
        "heroTalent_npc_dota_hero_dark_seer_2",
        "heroTalent_npc_dota_hero_venomancer_2",
        "heroTalent_npc_dota_hero_tiny_2",
        "heroTalent_npc_dota_hero_batrider_2",
        "heroTalent_npc_dota_hero_drow_ranger_2",
        "heroTalent_npc_dota_hero_tusk_2",
        "heroTalent_npc_dota_hero_queenofpain_2",
        "heroTalent_npc_dota_hero_bloodseeker_2",
        "heroTalent_npc_dota_hero_lich_2",
        "heroTalent_npc_dota_hero_gyrocopter_2",
        "heroTalent_npc_dota_hero_rubick_2",
        "heroTalent_npc_dota_hero_morphling_2",
        "heroTalent_npc_dota_hero_marci_2",
        "heroTalent_npc_dota_hero_monkey_king_2",
        "heroTalent_npc_dota_hero_broodmother_2",
        "heroTalent_npc_dota_hero_primal_beast_2",
        "heroTalent_npc_dota_hero_ember_spirit_2",
        "heroTalent_npc_dota_hero_oracle_2",
        "heroTalent_npc_dota_hero_leshrac_2",
        "heroTalent_npc_dota_hero_drow_ranger_3",
        "heroTalent_npc_dota_hero_juggernaut_2",
        "heroTalent_npc_dota_hero_chaos_knight_2",
        "heroTalent_npc_dota_hero_lycan_2",
        "heroTalent_npc_dota_hero_skeleton_king_2",
        "heroTalent_npc_dota_hero_nevermore_2",
        "heroTalent_npc_dota_hero_mars_2",
        "heroTalent_npc_dota_hero_night_stalker_2",
        "heroTalent_npc_dota_hero_juggernaut_3",
        "heroTalent_npc_dota_hero_bane_2",
        "heroTalent_npc_dota_hero_void_spirit_2",
        "heroTalent_npc_dota_hero_axe_2",
        "heroTalent_npc_dota_hero_lina_2",
        "heroTalent_npc_dota_hero_razor_3",
        "heroTalent_npc_dota_hero_skywrath_mage_2",
        "heroTalent_npc_dota_hero_sniper_2",
        "heroTalent_npc_dota_hero_templar_assassin_2",
        "heroTalent_npc_dota_hero_techies_2",
        "heroTalent_npc_dota_hero_enigma_2",
        
        "heroTalent_npc_dota_hero_magnataur_3",
        "heroTalent_npc_dota_hero_pugna_2",
        "heroTalent_npc_dota_hero_puck_2",
        "heroTalent_npc_dota_hero_templar_assassin_3",
        "heroTalent_npc_dota_hero_spectre_2",
        "heroTalent_npc_dota_hero_medusa_2",
        "heroTalent_npc_dota_hero_meepo_2",
        "heroTalent_npc_dota_hero_hoodwink_2",
        "heroTalent_npc_dota_hero_elder_titan_2",
        "heroTalent_npc_dota_hero_abaddon_2",
        "heroTalent_npc_dota_hero_weaver_2",
        "heroTalent_npc_dota_hero_chen_2",
        "heroTalent_npc_dota_hero_shredder_2",
        "heroTalent_npc_dota_hero_enchantress_2",
        "heroTalent_npc_dota_hero_dawnbreaker_2",
        "heroTalent_npc_dota_hero_sven_3",
        "heroTalent_npc_dota_hero_huskar_2",
        "heroTalent_npc_dota_hero_winter_wyvern_2",
        "heroTalent_npc_dota_hero_phantom_assassin_3",
        "heroTalent_npc_dota_hero_faceless_void_3",
        "heroTalent_npc_dota_hero_bounty_hunter_3",
        "heroTalent_npc_dota_hero_alchemist_2",
        "heroTalent_npc_dota_hero_ogre_magi_2",
        "heroTalent_npc_dota_hero_obsidian_destroyer_3",
        "heroTalent_npc_dota_hero_ursa_2",
        "heroTalent_npc_dota_hero_centaur_2",
        "heroTalent_npc_dota_hero_morphling_3",
        "heroTalent_npc_dota_hero_arc_warden_2",
        "heroTalent_npc_dota_hero_tinker_2",
        "heroTalent_npc_dota_hero_bristleback_2",
        "heroTalent_npc_dota_hero_spectre_3",
        "heroTalent_npc_dota_hero_windrunner_2",
        "heroTalent_npc_dota_hero_shadow_demon_2",
        "heroTalent_npc_dota_hero_kunkka_3",
        "heroTalent_npc_dota_hero_tinker_3",
        "heroTalent_npc_dota_hero_shredder_3",
        "heroTalent_npc_dota_hero_sniper_3",
        "heroTalent_npc_dota_hero_phoenix_2",
        "heroTalent_npc_dota_hero_venomancer_3",
        "heroTalent_npc_dota_hero_brewmaster_2",
        "heroTalent_npc_dota_hero_muerta_2",
        "heroTalent_npc_dota_hero_chen_3",
        "heroTalent_npc_dota_hero_wisp_3",
        "heroTalent_npc_dota_hero_abaddon_3",
        "heroTalent_npc_dota_hero_sven_4",
        "heroTalent_npc_dota_hero_phantom_assassin_4",
        "heroTalent_npc_dota_hero_dark_willow_2",
        "heroTalent_npc_dota_hero_necrolyte_3",
        "heroTalent_npc_dota_hero_dawnbreaker_3",
        -- "heroTalent_npc_dota_hero_wisp_4",
        -- "heroTalent_npc_dota_hero_wisp_5",
        "heroTalent_npc_dota_hero_marci_3",
        "heroTalent_npc_dota_hero_visage_2",
        "heroTalent_npc_dota_hero_zuus_3",
        "heroTalent_npc_dota_hero_storm_spirit_4",--蓝猫新天赋，购买
        "heroTalent_npc_dota_hero_undying_3",
        
       

        -- 2023 09 奖励 
        "heroTalent_npc_dota_hero_magnataur_4",
        "heroTalent_npc_dota_hero_brewmaster_3",

        -- 九月第一周新天赋
        "heroTalent_npc_dota_hero_storm_spirit_3",
        "heroTalent_npc_dota_hero_terrorblade_3",
        "heroTalent_npc_dota_hero_earthshaker_3",

        "heroTalent_npc_dota_hero_phoenix_3",

        -- 十月份奖励天赋
        "heroTalent_npc_dota_hero_tinker_4",
        "heroTalent_npc_dota_hero_faceless_void_4",

        -- 十一月奖励天赋
        "heroTalent_npc_dota_hero_kunkka_4",
        "heroTalent_npc_dota_hero_faceless_void_5",

        "heroTalent_npc_dota_hero_chaos_knight_3",
        "heroTalent_npc_dota_hero_phantom_assassin_5",
        "heroTalent_npc_dota_hero_axe_3",
        "heroTalent_npc_dota_hero_centaur_3",

         -- 十二月奖励天赋
        "heroTalent_npc_dota_hero_chaos_knight_4",
        "heroTalent_npc_dota_hero_medusa_3",

        -- 一月奖励天赋
        "heroTalent_npc_dota_hero_lone_druid_2",
        "heroTalent_npc_dota_hero_life_stealer_3",


        -- 二月奖励天赋
        "heroTalent_npc_dota_hero_invoker_3",
        "heroTalent_npc_dota_hero_morphling_4",

        "heroTalent_npc_dota_hero_juggernaut_4",
        "heroTalent_npc_dota_hero_snapfire_4",
        
  
        -- 三月奖励天赋
        "heroTalent_npc_dota_hero_enigma_3",
        "heroTalent_npc_dota_hero_hoodwink_3",
        
        -- 四月奖励天赋
        "heroTalent_npc_dota_hero_spirit_breaker_2",--白牛新天赋，榜1
        "heroTalent_npc_dota_hero_monkey_king_3",---猴子新天赋，前10
        
        --五月奖励天赋
        "heroTalent_npc_dota_hero_crystal_maiden_2",--冰女节律，榜一
        "heroTalent_npc_dota_hero_meepo_3",
        -- "heroTalent_npc_dota_hero_juggernaut_5", --剑圣登龙，前10
        
        
        --"heroTalent_npc_dota_hero_omniknight_3",--全能新天赋,没做完！
        --"heroTalent_npc_dota_hero_juggernaut_6"
        -- "heroTalent_npc_dota_hero_abyssal_underlord_3", 
        "heroTalent_npc_dota_hero_beastmaster_2",
        --七月奖励天赋
        "heroTalent_npc_dota_hero_treant_3",
        "heroTalent_npc_dota_hero_legion_commander_3",

        --八月奖励天赋
       -- "heroTalent_npc_dota_hero_elder_titan_3", 
        "heroTalent_npc_dota_hero_rubick_3",
        "heroTalent_npc_dota_hero_alchemist_3",  
        --九月天赋
        "heroTalent_npc_dota_hero_ogre_magi_3",
        "heroTalent_npc_dota_hero_axe_4",
        "heroTalent_npc_dota_hero_spectre_4",
        "heroTalent_npc_dota_hero_riki_2",
        --10月天赋
        "heroTalent_npc_dota_hero_abaddon_4",
        "heroTalent_npc_dota_hero_winter_wyvern_3",
        --11月
        "heroTalent_npc_dota_hero_ancient_apparition_2",
        "heroTalent_npc_dota_hero_techies_3",
        --12月传说月
        --{name = "heroTalent_npc_dota_hero_nevermore_3", cost = 3000},
        "heroTalent_npc_dota_hero_queenofpain_3",
        "heroTalent_npc_dota_hero_skeleton_king_3",
        "heroTalent_npc_dota_hero_viper_3",
        "heroTalent_npc_dota_hero_lich_3",
        --1月
        "heroTalent_npc_dota_hero_medusa_4",
        "heroTalent_npc_dota_hero_void_spirit_3",
        --2月--黑市进度
        "heroTalent_npc_dota_hero_jakiro_2",
        "heroTalent_npc_dota_hero_slardar_3",
        "heroTalent_npc_dota_hero_oracle_3",
        --3月
        "heroTalent_npc_dota_hero_phantom_lancer_3",
        "heroTalent_npc_dota_hero_lion_3",
        --4月
        "heroTalent_npc_dota_hero_marci_4",
        "heroTalent_npc_dota_hero_dazzle_2",
        --5月
        "heroTalent_npc_dota_hero_visage_3",
        "heroTalent_npc_dota_hero_terrorblade_4",
        --6月
        --"heroTalent_npc_dota_hero_slark_3",--传说
        "heroTalent_npc_dota_hero_elder_titan_4",
        "heroTalent_npc_dota_hero_axe_5", --卖钱
        --7月
        "heroTalent_npc_dota_hero_witch_doctor_3",
        "heroTalent_npc_dota_hero_slardar_4",
        "heroTalent_npc_dota_hero_jakiro_3",--卖钱
        --8月
        "heroTalent_npc_dota_hero_keeper_of_the_light_2",
        "heroTalent_npc_dota_hero_dragon_knight_3",
        "heroTalent_npc_dota_hero_silencer_3",--卖钱
        --9月
        "heroTalent_npc_dota_hero_pugna_3",
        "heroTalent_npc_dota_hero_juggernaut_6",
        --10月
        "heroTalent_npc_dota_hero_skeleton_king_4",
        "heroTalent_npc_dota_hero_primal_beast_3",
        --11
        "heroTalent_npc_dota_hero_sand_king_2",
        "heroTalent_npc_dota_hero_kez_2",
        --12
        -- "heroTalent_npc_dota_hero_rattletrap_2"
    }   

end



function talentManager:SpawnTalent()
    local heroes = GetAllRealHeroes()
    self.Setup = true
    for _, unit in pairs(heroes) do
        local nPlayerID = unit:GetPlayerID()
        local player =PlayerResource:GetPlayer(nPlayerID)
        if nPlayerID then
            local defaultTelent = "heroTalent_"..unit:GetUnitName()  --默认天赋名
            -- local newAbility = unit:AddAbility(defaultTelent)
            --例如heroTalent_npc_dota_hero_antimage
            --增加的天赋名相同前缀 heroTalent_npc_dota_hero_antimage_2
            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
            local talentTable = spellmap.Particle.Talent.ParticleSet  --获取到所有天赋
            self.PlayerHeroTalent[nPlayerID] = {
                defaultTelent,
            }
            local nameLength = #defaultTelent
            for key, value in pairs(talentTable) do
                -- print(key)
                if string.sub(key,1,nameLength)==defaultTelent  then
                    --说明是同个英雄的天赋
                    if KeyValues.ability_bonus_info[key] and KeyValues.ability_bonus_info[key].IsChaoticEraOnly==1 and not Game_State:IsInChaoticEra()  then
                        goto continue
                    end
                    table.insert( self.PlayerHeroTalent[nPlayerID],key)
                    ::continue::
                end
            end
            -- print("完成")
            -- PrintTable(sendTable)
            --反馈技能表
            CustomGameEventManager:Send_ServerToPlayer(player, "TalentSpawnFinished", self.PlayerHeroTalent[nPlayerID])

        end
    end



end

-- 乱纪元模式下的天赋生成
function talentManager:SpawnTalent____ChaoticEraMod()
    local heroes = GetAllRealHeroes()
    self.Setup = true
    for _, unit in pairs(heroes) do
        local nPlayerID = unit:GetPlayerID()
        local player =PlayerResource:GetPlayer(nPlayerID)
        if nPlayerID then
            self.PlayerHeroTalent[nPlayerID] = {}
            local count = KeyValues.base_setting["Talent_count"].value
            for i = 1, count, 1 do
                local data = self:SpawnChaoticEraTalentList(nPlayerID, self.PlayerHeroTalent[nPlayerID],nil)
                if not data then
                    print("重大错误：in SpawnTalent____ChaoticEraMod")
                    break
                end
                local iRandom = RandomInt(1, data.totalWeight) --生成权重
                for _, value in ipairs(data.list) do
                    if iRandom<=value.weightRequire then
                        table.insert(self.PlayerHeroTalent[nPlayerID],value.name)
                        break
                    end
                end
        
            end

            --反馈技能表
            CustomGameEventManager:Send_ServerToPlayer(player, "TalentSpawnFinished", self.PlayerHeroTalent[nPlayerID])

        end
    end



end

function talentManager:SpawnChaoticEraTalentList(nPlayerID,currentList,type)

    -- local player =PlayerResource:GetPlayer(nPlayerID)
    local unit = player:GetPlayerHero(nPlayerID)
    if unit then
        local defaultTelent = "heroTalent_"..unit:GetUnitName()  --默认天赋名
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
        local talentTable = spellmap.Particle.Talent.ParticleSet  --获取到所有天赋

        local defaultWeight = KeyValues.base_setting["hero_talent_weight"].value
        local nameLength = #defaultTelent
        local list = {}
        local totalWeight = 0
        -- 先将基本天赋添加到表里
        if not IsInTable(defaultTelent,currentList) then
            totalWeight = totalWeight + defaultWeight
            local data = {
                name = defaultTelent,
                weightRequire = totalWeight,
            }
            table.insert(list,data)
        end

        for bonusName, value in pairs(talentTable) do
            if string.sub(bonusName,1,nameLength)==defaultTelent  then
                --说明是同个英雄的天赋
                if not IsInTable(bonusName,currentList) then
                    totalWeight = totalWeight + defaultWeight
                    local data = {
                        name = bonusName,
                        weightRequire = totalWeight,
                    }
                    table.insert(list,data)
                end
            end
		end
        local generalTalentList = KeyValues.chaotic_spell_talent
        for bonusName, value in pairs(generalTalentList) do
            if value.weight and value.weight>0  then
                if type and not type==value.type then
                    goto continue
                end
                if not IsInTable(bonusName,currentList) then
                    totalWeight = totalWeight + value.weight
                    local data = {
                        name = bonusName,
                        weightRequire = totalWeight,
                    }
                    table.insert(list,data)
                end

            end
            ::continue::
		end

        -- 最终得到了list
        return {
            list = list,
            totalWeight = totalWeight,
        }
    end
    return nil
end


function talentManager:_CheckPlayerHeroTalent(eventSourceIndex, event_data)
    -- print("self.Setup")
    -- print(self.Setup)
    -- print(self.playerTalent[nPlayerID])
    local nPlayerID = event_data.player_id

   
    if not self.playerTalent[nPlayerID] and self.Setup then
        local player =PlayerResource:GetPlayer(nPlayerID)
        CustomGameEventManager:Send_ServerToPlayer(player, "TalentSpawnFinished", self.PlayerHeroTalent[nPlayerID])
    end
end

function talentManager:OnFirstWaveStart()
    if not IsInToolsMode() then
        local heroes = GetAllRealHeroes()
        for _, unit in pairs(heroes) do
            local nPlayerID = unit:GetPlayerID()
            local player =PlayerResource:GetPlayer(nPlayerID)
            if nPlayerID and player then
                if not self.playerTalent[nPlayerID] then
                    local defaultTelent = "heroTalent_"..unit:GetUnitName()  --默认天赋名
                    local event_data = {
        
                    }
                    event_data.player_id = nPlayerID
                    event_data.spellName = defaultTelent
                    self:_SelectTelent(nil, event_data)
                    CustomGameEventManager:Send_ServerToPlayer(player, "FroceClose", {})
                end
               
                
            end
        end
    end

end










function talentManager:_SelectTelent(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    if not self.playerTalent[nPlayerID] then
        local player = PlayerResource:GetPlayer(nPlayerID)
        local playerHero = player:GetAssignedHero()
        if playerHero and not playerHero.talent then
            self.playerTalent[nPlayerID] = true
            local spellName = event_data.spellName

            local defaultTelent = "heroTalent_"..playerHero:GetUnitName()  --默认天赋名
 
            local nameLength = #defaultTelent
            if not string.sub(spellName,1,nameLength)==defaultTelent  then
                -- 同个英雄
                return
            end

            local newAbility = playerHero:AddAbility(spellName)
            if newAbility then
                newAbility:SetLevel(1)
                playerHero.talent = true
                -- print("type=".. newAbility:GetAbilityType())
                if  newAbility:IsPassive() then
                    PassiveAbilitySwap(playerHero,spellName) 
                end 
            end
            -- self.PlayerHeroTalent[nPlayerID] = nil
            -- local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
            -- spellmap.Particle.Talent.ParticleSet = {}  --移除这部分数据

        end
    end
  
  
end






function talentManager:_CheckPlayerTalent(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local spellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellMap then
        return
    end
    spellMap =spellMap[nPlayerID]
    if not spellMap then
        return
    end
    local talentTable = spellMap.Particle.Talent.ParticleSet  --获取到所有天赋
    local Talent = talentTable
    --反馈技能表
    CustomGameEventManager:Send_ServerToPlayer(player, "GetPlayerTalent_feedback", Talent)
    
end


function talentManager:_GetMarketTalentTable(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)

    if player  then
        local playerHero = player:GetAssignedHero()
        if playerHero then
            if playerHero:HasModifier("modifier_novice_player") then
                -- 是新手玩家
                return
            end
            -- 不是新手就可以把数据发过去
            CustomGameEventManager:Send_ServerToPlayer(player, "GetMarketTalentTable_feedback", self.MarketTalentTable)
        end
    end
end

-- 判断这个天赋是否在表里
function talentManager:CheckMarketRightful(name)
    if self.MarketTalentTable then
        if IsInTableTalent(name,self.MarketTalentTable) then
            return true
        end
    end
    return false
end

function IsInTableTalent(enemy,enemies)
    for i=1, #enemies do    
        if type(enemies[i]) == "table" then
            if enemy == enemies[i].name then
                return enemies[i].cost
            end
        else
            if enemy == enemies[i] then
                return 1200
            end
        end
    end
 return false
end






return talentManager
