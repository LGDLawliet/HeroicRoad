chaotic_era_shop = chaotic_era_shop or class({})
print("chaotic_era_shop load....")

function chaotic_era_shop:init(bReload)
    

    if not bReload then
        self.playerItemList = {}
        self.baseConfig = {
            Chaotic_Era_Shop_ExpRequire = {
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value1,
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value2,
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value3,
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value4,
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value5,
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value6,
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value7,
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value8,
                KeyValues.base_setting["Chaotic_Era_Shop_ExpRequire"].value9,
            },
            chaoticEraShopMaxLevel_WithBonus = KeyValues.base_setting["Chaotic_Era_Shop_Max_Level"].value,
            chaoticEraShopMaxLevel = 9,
            max_charge = {
                evolution =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Evolution_max_charge"].value,
                upgrade =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Upgrade_max_charge"].value,
                sell =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Sell_max_charge"].value,
                buySpell =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_SpellChance_max_charge"].value,
                refreshTask =  KeyValues.base_setting["Chaotic_Era_RefreshTask_max_charge"].value,
                artifact =  KeyValues.base_setting["Chaotic_Era_Spell_Artifact_max_charge"].value,
            },
    
            DelayTask = {
                levelRequire =  KeyValues.base_setting["Chaotic_Era_Stop_TaskGenetate_LevelRequire"].value,
                delayTime = KeyValues.base_setting["Chaotic_Era_Stop_TaskGenetate_Time"].value,
                cooldown= KeyValues.base_setting["Chaotic_Era_Stop_TaskGenetate_CooldownTime"].value,
                cost = KeyValues.base_setting["Chaotic_Era_Stop_TaskGenetate_Cost"].value,
                timer = 0,
            },
            Chaotic_era_artifact_count = KeyValues.base_setting["Chaotic_era_artifact_genetate_count"].value,
    
          
            playerShop={}
        }
        

    
    -- 处理装备数据
        self.itemList = {}
        for item, value in pairs(KeyValues.game_shop_chaotic_era) do
            local type = value.type
            if not self.itemList[type] then
                self.itemList[type] = {}
            end
            local level = value.level
            if not self.itemList[type][level] then
                self.itemList[type][level] = {
                
                }
            end
            table.insert(self.itemList[type][level],{
                item_name = item,
                cost = value.cost
            })
        end
        -- 处理药水配置
        self.potion = {}
        for item, value in pairs(KeyValues.game_shop_chaotic_era_potion) do
            if value.weight then
                -- 没权重的不要
                local type = value.type
                if not self.potion[type] then
                    self.potion[type] = {}
                end
                local level = value.level
                if not self.potion[type][level] then
                    self.potion[type][level] = {
                    
                    }
                end
                table.insert(self.potion[type][level],{
                    item_name = item,
                    cost = value.cost,
                    weight = value.weight,
                })
            end

        end


        self.currentPlayerOwnerPotion = {} --背包储存的药水

        self.rerollChance = {}  --重随机会

    
        self.player_artifact = {}  --玩家神器
        self.player_artifact_waitForSelect = {}
        -- 初始化

    end

    CustomUIEvent("UpgradeChaoticEraShop", Dynamic_Wrap(self, "_UpgradeChaoticEraShop"), self)
    CustomUIEvent("RefreshChaoticEraShop", Dynamic_Wrap(self, "_RefreshChaoticEraShop"), self)
    CustomUIEvent("TryBuyItem_ChaoticEraShop", Dynamic_Wrap(self, "_TryBuyItem_ChaoticEraShop"), self)
    CustomUIEvent("UseChaoticEraPotion", Dynamic_Wrap(self, "_UseChaoticEraPotion"), self)
    CustomUIEvent("TryLockItem_ChaoticEraShop", Dynamic_Wrap(self, "_TryLockItem_ChaoticEraShop"), self)
    CustomUIEvent("RefreshChaoticEraTask", Dynamic_Wrap(self, "_RefreshChaoticEraTask"), self)
    CustomUIEvent("BuyGenerateSpell", Dynamic_Wrap(self, "_BuyGenerateSpell"), self)
    CustomUIEvent("BuyEvoluteionChance", Dynamic_Wrap(self, "_BuyEvoluteionChance"), self)
    CustomUIEvent("BuyUpgradeChance", Dynamic_Wrap(self, "_BuyUpgradeChance"), self)
    CustomUIEvent("BuySellChance", Dynamic_Wrap(self, "_BuySellChance"), self)
    CustomUIEvent("BuyArtifact", Dynamic_Wrap(self, "_BuyArtifact"), self)
    CustomUIEvent("PauseTaskProgress", Dynamic_Wrap(self, "_PauseTaskProgress"), self)
    CustomUIEvent("SelectTargetArtifact", Dynamic_Wrap(self, "_SelectTargetArtifact"), self)
    CustomUIEvent("OnArtifactClicked", Dynamic_Wrap(self, "_OnArtifactClicked"), self)




end
function chaotic_era_shop:Enable()
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap

    player:EachPlayer(function(n, playerID)
        local Targetplayer = PlayerResource:GetPlayer(playerID)
        if Targetplayer then
            
            self.currentPlayerOwnerPotion[playerID]  = {}
            self.baseConfig.playerShop[tostring(playerID)] = {
                currentExp = 0,
                currentLevel = 1,


                -- 升级商店消耗
                Chaotic_Era_Shop_UpgradeCost = KeyValues.base_setting["Chaotic_Era_Shop_UpgradeCost"].value,
                -- 商店可锁物品上限
                Chaotic_Era_Item_Lock_Max = KeyValues.base_setting["Chaotic_Era_Item_Lock_Max"].value,
                -- 商店刷新
                refreshShopCost =KeyValues.base_setting["Chaotic_Era_Shop_RefreshCost"].value,
                refreshShopCost_Step =KeyValues.base_setting["Chaotic_Era_Shop_RefreshCost_Bonus"].value,
                currentShopRefreshCount = 0, --商店刷新在升级商店时刷新

                -- 征召刷新

                refreshTaskCost =KeyValues.base_setting["Chaotic_Era_Task_RefreshCost"].value,
                refreshTaskCost_Step =KeyValues.base_setting["Chaotic_Era_Task_RefreshCost_Bonus"].value,
                currentTaskRefreshCount = 0, --征召不会刷新
                currentTaskRefreshCharge = 0, --征召机会 （刷新商店时几率获取）
                spell_RefreshTaskLevel = {},   --征召机会生成级别

                -- 购买技能
                currentbuySpellCharge = KeyValues.base_setting["Chaotic_Era_Init_Buy_Charge"].value,  
                currentBuyCount = 0,--已购买技能次数
                buySpellChange = KeyValues.base_setting["Chaotic_Era_Spell_SpellBuyChance"].value, --刷新商店几率获得购买机会
                buySpellCost =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_SpellChance_cost"].value,  --基础消耗
                buySpellCost_Step =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_SpellChance_cost"].value1, --每次购买额外消耗

                -- 升阶技能
                currentEvolutionCharge = KeyValues.base_setting["Chaotic_Era_Init_Evolution_Charge"].value,
                currentEvolutionCount = 0,
                currentEvolutionBuyCount =0, --购买次数
                spell_EvolutionLevel = {}, --升阶机会生成级别
                EvolutionCost =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Evolution_cost"].value,  --基础消耗
                EvolutionCost_Step =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Evolution_cost"].value1, --每次购买额外消耗
                EvolutionChargetOnUpgrade = {},  --升到对应等级时获得charge

                -- 升级技能
                currentUpgradeCharge = 0,
                currentUpgradeCount = 0,
                currentUpgradeBuyCount = 0,
                spell_GeneralSpell_UpgradeLevel = {},   --升级机会生成级别
                UpgradeCost =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Upgrade_cost"].value,  --基础消耗
                UpgradeCost_Step =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Upgrade_cost"].value1,  --每次购买额外消耗
    

                -- 出售技能
                currentSellCharge = KeyValues.base_setting["Chaotic_Era_Init_Sell_Charge"].value,
                currentSellCount = 0,
                currentSellBuyCount = 0,
                spell_GeneralSpell_SellLevel = {},   --出售机会生成级别
                SellCost =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Sell_cost"].value,  --基础消耗
                SellCost_Step =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Sell_cost"].value1,  --每次购买额外消耗
    

                -- 神器购买
                currentArtifactCharge =  KeyValues.base_setting["Chaotic_Era_Init_Spell_Artifact_Charge"].value,
                currentArtifactBuyCount = 0,
                spell_Genera_ArtifactLevel = {},   --升级机会生成级别
                ArtifactCost =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Artifact_cost"].value,  --基础消耗
                ArtifactCost_Step =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Artifact_cost"].value1,  --每次购买额外消耗
    


                -- 商店刷新个数
                itemGenerateCount = {
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value1,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value2,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value3,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value4,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value5,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value6,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value7,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value8,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value9,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value10,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value11,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value12,
                    KeyValues.base_setting["Chaotic_Era_Shop_RefreshCount"].value13,
                },
                -- 药剂生成种类数
                potionGenerateCount = {
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value1,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value2,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value3,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value4,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value5,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value6,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value7,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value8,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value9,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value10,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value11,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value12,
                    KeyValues.base_setting["Chaotic_era_PotionCount"].value13,
                },
                itemGenerateLevel = {}, --装备生成级别
                spellGenerateLevel = {}, --技能环技生成级别

                
                
                
                -- spell_SpellBuyLevel = {},   --购买机会生成级别
                

            }
            for i = 1, self.baseConfig.chaoticEraShopMaxLevel_WithBonus, 1 do
                self.baseConfig.playerShop[tostring(playerID)].itemGenerateLevel[i] = {
                    KeyValues.base_setting["Chaotic_Era_Shop_Level_"..i].value1,
                    KeyValues.base_setting["Chaotic_Era_Shop_Level_"..i].value2,
                    KeyValues.base_setting["Chaotic_Era_Shop_Level_"..i].value3,
                    KeyValues.base_setting["Chaotic_Era_Shop_Level_"..i].value4,
                    KeyValues.base_setting["Chaotic_Era_Shop_Level_"..i].value5,
                }
            end
            for i = 1, self.baseConfig.chaoticEraShopMaxLevel_WithBonus, 1 do
                self.baseConfig.playerShop[tostring(playerID)].spellGenerateLevel[i] = {
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value1,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value2,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value3,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value4,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value5,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value6,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value7,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value8,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value9,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value10,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value11,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value12,
                    KeyValues.base_setting["Chaotic_Era_Spell_Level_"..i].value13,
                }
            end


            for i = 1, self.baseConfig.chaoticEraShopMaxLevel_WithBonus, 1 do
                 -- 初始化刷新升阶机会
                table.insert(
                    self.baseConfig.playerShop[tostring(playerID)].spell_EvolutionLevel,
                    KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Evolution"]["value"..i]
                )
                table.insert(
                    self.baseConfig.playerShop[tostring(playerID)].EvolutionChargetOnUpgrade,
                    KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Evolution_OnUpgradeShop"]["value"..i]
                )
                -- 初始化升级机会
                table.insert(
                    self.baseConfig.playerShop[tostring(playerID)].spell_GeneralSpell_UpgradeLevel,
                    KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Upgrade"]["value"..i]
                )
                -- 初始化刷新征召机会
                table.insert(
                    self.baseConfig.playerShop[tostring(playerID)].spell_RefreshTaskLevel,
                    KeyValues.base_setting["Chaotic_Era_RefreshTask"]["value"..i]
                )
                -- 初始化出售机会
                table.insert(
                    self.baseConfig.playerShop[tostring(playerID)].spell_GeneralSpell_SellLevel,
                    KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Sell"]["value"..i]
                )
                -- 初始化神器购买
                table.insert(
                    self.baseConfig.playerShop[tostring(playerID)].spell_Genera_ArtifactLevel,
                    KeyValues.base_setting["Chaotic_Era_Spell_Artifact"]["value"..i]
                )
            end
            
            self:GenerateChaoticEraItem(playerID)
            self:OnShopRefreshed(playerID)


            self.rerollChance[playerID] = {
                freeReRollAbility = KeyValues.base_setting["freeReRollAbility"]["value"], --免费的技能重新随机机会  （有特权则2次）
                rerollAbilityCharge = KeyValues.base_setting["rerollAbilityCharge"]["value"],--一局内可重随技能机会（需要花费10黄金）  有会员可以10次
                
                rerollAurumCost = KeyValues.base_setting["rerollAurumCost"]["value"], --每次重新随机消耗10黄金
            }
 
            if map then
                local viptable = map[playerID].vip  --属于这个玩家的VIP
                if viptable["Shop_Refresh_Chaoticera_spell"] then
                    self.rerollChance[playerID].freeReRollAbility = self.rerollChance[playerID].freeReRollAbility +2
                    self.rerollChance[playerID].rerollAbilityCharge = self.rerollChance[playerID].rerollAbilityCharge +1
                end
            end
            if tonumber(tostring(PlayerResource:GetSteamID(playerID)))==76561198828335572 then
                self.rerollChance[playerID].freeReRollAbility = 9999
            end
            if tonumber(tostring(PlayerResource:GetSteamID(playerID)))==76561199144907040 then
                self.rerollChance[playerID].rerollAbilityCharge = 99
            end
            

            self.player_artifact[playerID] = {} --初始化
            self.player_artifact_waitForSelect[playerID] = {
                list = {},
                card_index = 0,
            }
            
           
          
    
            
            self:UpdateRerollChance(playerID)
            
        end
       
    end)
    chaotic_era:InitAttributeCount()



    -- PrintTable(self.itemList)
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )


end

-- 购买商店经验
function chaotic_era_shop:_UpgradeChaoticEraShop(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id

    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)]
    if dataTable then
        local data = dataTable
        if self.baseConfig.chaoticEraShopMaxLevel<=data.currentLevel then
            -- 最大等级
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_LevelMax","General.Cancel")
            return
        end
        local cost = data.Chaotic_Era_Shop_UpgradeCost

        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end
        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        
        data.currentExp = data.currentExp + 1

        if data.currentExp>=self.baseConfig.Chaotic_Era_Shop_ExpRequire[data.currentLevel] then
            data.currentExp = 0
            data.currentLevel = data.currentLevel + 1
            self:OnShopUpgradeLevel(nPlayerID)
        else
            EmitClientSound(nPlayerID,"Shop_Upgrade_Progress")
        end
        
  
        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )


        
    end

end

-- 升级商店
function chaotic_era_shop:UpgradePlayerShop(nPlayerID)
    local data = self.baseConfig.playerShop[tostring(nPlayerID)]
    if self.baseConfig.chaoticEraShopMaxLevel<=data.currentLevel then
        -- 最大等级
        return
    end
    data.currentExp = data.currentExp + 1
    
    if data.currentExp>=self.baseConfig.Chaotic_Era_Shop_ExpRequire[data.currentLevel] then
        data.currentExp = 0
        data.currentLevel = data.currentLevel + 1
        self:OnShopUpgradeLevel(nPlayerID)
    else
        EmitClientSound(nPlayerID,"Shop_Upgrade_Progress")
    end
    

    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )
end
function chaotic_era_shop:OnShopUpgradeLevel(nPlayerID)
    local data = self.baseConfig.playerShop[tostring(nPlayerID)]
    data.currentShopRefreshCount = 0 --重置刷新次数
    if data.EvolutionChargetOnUpgrade[data.currentLevel]==1 then
        -- 到达指定等级时获得升阶charge
        if data.currentEvolutionCharge<self.baseConfig.max_charge.evolution  then
            -- 说明还没到最大值
            data.currentEvolutionCharge = data.currentEvolutionCharge + 1
        end
    end
    -- 商店升级时刷新物品
    self:GenerateChaoticEraItem(nPlayerID)
    self:OnShopRefreshed(nPlayerID)


    EmitClientSound(nPlayerID,"Shop_Upgrade")
    local gameEvent = {}
    gameEvent["player_id"] = nPlayerID
    gameEvent["teamnumber"] = -1
    gameEvent["locstring_value"] = tostring(data.currentLevel)
    gameEvent["message"] = "#HUD_ChaoticEra_ShopUpgrade"
    FireGameEvent( "dota_combat_event_message", gameEvent )
end

-- 获取商店等级
function chaotic_era_shop:GetPlayerShopLevel(nPlayerID,bHasBonus)

    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local level = self.baseConfig.playerShop[tostring(nPlayerID)].currentLevel
        -- GetGloabal_ChaoticEra__ShopLevel(hUnit)
        local hero = player:GetPlayerHero(nPlayerID)
        if hero and bHasBonus then
            level = level + GetGloabal_ChaoticEra__ShopLevel(hero)
        end
        return math.min(level,self.baseConfig.chaoticEraShopMaxLevel_WithBonus)
    end
    return 1
end



-- refreshShopCost =KeyValues.base_setting["Chaotic_Era_Shop_RefreshCost"].value,
-- 
-- refreshShopCost_Step =KeyValues.base_setting["Chaotic_Era_Shop_RefreshCost_Bonus"].value,
-- currentShopRefreshCount = 0,
-- 刷新商城
function chaotic_era_shop:_RefreshChaoticEraShop(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id

    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local data = self.baseConfig.playerShop[tostring(nPlayerID)]
        local cost = data.refreshShopCost + data.refreshShopCost_Step * data.currentShopRefreshCount
        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end
        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        
        data.currentShopRefreshCount =  data.currentShopRefreshCount  + 1 

        self:GenerateChaoticEraItem(nPlayerID)
        self:OnShopRefreshed(nPlayerID)

        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )


        
    end

end




-- 商店刷新时候处理特供
function chaotic_era_shop:OnShopRefreshed(nPlayerID)
    local shopLevel = self:GetPlayerShopLevel(nPlayerID,true)
    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)]
    if true then
        -- 获取刷新征召机会
        local chance = dataTable.spell_RefreshTaskLevel[shopLevel]
        if dataTable.currentTaskRefreshCharge<self.baseConfig.max_charge.refreshTask  then
            -- 说明还没到最大值
            if chance>=RandomInt(1, 100) then
                dataTable.currentTaskRefreshCharge = dataTable.currentTaskRefreshCharge + 1
            end
        end
    end



    if true then
        -- 获取购买技能机会
        local chance = dataTable.buySpellChange
        if dataTable.currentbuySpellCharge<self.baseConfig.max_charge.buySpell  then
            -- 说明还没到最大值
            if chance>=RandomInt(1, 100) then
                dataTable.currentbuySpellCharge = dataTable.currentbuySpellCharge + 1
            end
        end



    end

    if true then
        -- 获取升阶机会
        local chance = dataTable.spell_EvolutionLevel[shopLevel]
        if dataTable.currentEvolutionCharge<self.baseConfig.max_charge.evolution  then
            -- 说明还没到最大值
            if chance>=RandomInt(1, 100) then
                dataTable.currentEvolutionCharge = dataTable.currentEvolutionCharge + 1
            end
        end
   
    end

    if true then
        -- 获得升级机会
        local chance = dataTable.spell_GeneralSpell_UpgradeLevel[shopLevel]
        if dataTable.currentUpgradeCharge<self.baseConfig.max_charge.upgrade  then
            -- 说明还没到最大值
            if chance>=RandomInt(1, 100) then
                dataTable.currentUpgradeCharge = dataTable.currentUpgradeCharge + 1
            end
        end

        -- currentUpgradeCharge = 0,
        -- currentUpgradeCount = 0,
        -- currentUpgradeBuyCount = 0,
        -- spell_GeneralSpell_UpgradeLevel = {},   --升级机会生成级别
        -- UpgradeCost =  KeyValues.base_setting["Chaotic_Era_Spell_GeneralSpell_Upgrade_cost"].value,  --基础消耗


    end

    if true then

        -- 获得出售机会
        local chance = dataTable.spell_GeneralSpell_SellLevel[shopLevel]
        if dataTable.currentSellCharge<self.baseConfig.max_charge.sell  then
            -- 说明还没到最大值
            if chance>=RandomInt(1, 100) then
                dataTable.currentSellCharge = dataTable.currentSellCharge + 1
            end
        end

    end
    if true then
        -- 获得购买神器机会
        local chance = dataTable.spell_Genera_ArtifactLevel[shopLevel]
        if dataTable.currentArtifactCharge<self.baseConfig.max_charge.artifact  then
            -- 说明还没到最大值
            if chance>=RandomInt(1, 100) then
                dataTable.currentArtifactCharge = dataTable.currentArtifactCharge + 1
            end
        end
    end


    
end





-- 刷新征召
function chaotic_era_shop:_RefreshChaoticEraTask(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id

    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local data = self.baseConfig.playerShop[tostring(nPlayerID)]
        local cost = data.refreshTaskCost + data.refreshTaskCost_Step * data.currentTaskRefreshCount

        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end
        if not chaotic_era_spawner:CheckTaskCanBeReroll() then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Task","General.Cancel")
            return
        end
        if data.currentTaskRefreshCharge<=0 then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Item","General.Cancel")
            return
        end



        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        
        data.currentTaskRefreshCount =  data.currentTaskRefreshCount  + 1 
        data.currentTaskRefreshCharge = data.currentTaskRefreshCharge - 1
        chaotic_era_spawner:GenetateTask(true)
        local gameEvent = {}
        gameEvent["player_id"] = nPlayerID
        gameEvent["teamnumber"] = -1
        gameEvent["message"] = "#HUD_ChaoticEra_PlayerRefreshTask"
        FireGameEvent( "dota_combat_event_message", gameEvent )
     
  
        EmitClientSound(nPlayerID,"Shop_Refresh_Task")

        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )
    end
end

-- 购买技能
function chaotic_era_shop:_BuyGenerateSpell(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id

    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local data = self.baseConfig.playerShop[tostring(nPlayerID)]
        local cost = data.buySpellCost + data.buySpellCost_Step * data.currentBuyCount



        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end

        if data.currentbuySpellCharge<=0 then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Item","General.Cancel")
            return
        end



        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        
        data.currentBuyCount =  data.currentBuyCount  + 1 
        data.currentbuySpellCharge = data.currentbuySpellCharge - 1
   

        chaotic_era:GenerateSpellList_Genaral(nPlayerID)
  
        EmitClientSound(nPlayerID,"ui.abilitydraft_open")

        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )
        CustomGameEventManager:Send_ServerToPlayer(player, "CloaseChaoticEraShop", data)
        
        
    end

end

-- 修改商店生成环技能权重最小几率 用于神器（废话少说）
function chaotic_era_shop:ModifySpellLevelMinChance(playerID,level,chance)
    for i = 1, self.baseConfig.chaoticEraShopMaxLevel_WithBonus, 1 do
        self.baseConfig.playerShop[tostring(playerID)].spellGenerateLevel[i][level] = math.max(
            self.baseConfig.playerShop[tostring(playerID)].spellGenerateLevel[i][level],
            chance
        )
    end
end



-- 购买升阶机会
function chaotic_era_shop:_BuyEvoluteionChance(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id

    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local data = self.baseConfig.playerShop[tostring(nPlayerID)]
        local cost = data.EvolutionCost + data.EvolutionCost_Step * data.currentEvolutionBuyCount



        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end

        if data.currentEvolutionCharge<=0 then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Item","General.Cancel")
            return
        end



        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        
        data.currentEvolutionCount =  data.currentEvolutionCount  + 1 
        data.currentEvolutionCharge = data.currentEvolutionCharge - 1
        data.currentEvolutionBuyCount = data.currentEvolutionBuyCount + 1



        EmitClientSound(nPlayerID,"Shop_Buy_Evalution_Count")
        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )

    end
end
function chaotic_era_shop:AddEvoluteionChance(nPlayerID)
    local data = self.baseConfig.playerShop[tostring(nPlayerID)]
    local player = PlayerResource:GetPlayer(nPlayerID) 
    data.currentEvolutionCount =  data.currentEvolutionCount  + 1 
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )
end


function chaotic_era_shop:TryBuyEvoluteionChance(nPlayerID)
    local data = self.baseConfig.playerShop[tostring(nPlayerID)]
    local cost = data.EvolutionCost + data.EvolutionCost_Step * data.currentEvolutionBuyCount



    local player = PlayerResource:GetPlayer(nPlayerID) 
    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
    local currentGold = playerHero:GetGold()
    if currentGold<cost then
        return false
    end

    if data.currentEvolutionCharge<=0 then
        return false
    end
    playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
    data.currentEvolutionCount =  data.currentEvolutionCount  + 1 
    data.currentEvolutionCharge = data.currentEvolutionCharge - 1
    data.currentEvolutionBuyCount = data.currentEvolutionBuyCount + 1
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )
    return true
end

-- 购买升级机会
function chaotic_era_shop:_BuyUpgradeChance(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id

    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local data = self.baseConfig.playerShop[tostring(nPlayerID)]
        local cost = data.UpgradeCost + data.UpgradeCost_Step * data.currentUpgradeBuyCount


        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end

        if data.currentUpgradeCharge<=0 then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Item","General.Cancel")
            return
        end



        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        
        data.currentUpgradeCount =  data.currentUpgradeCount  + 2
        data.currentUpgradeCharge = data.currentUpgradeCharge - 1
        data.currentUpgradeBuyCount = data.currentUpgradeBuyCount + 1



        EmitClientSound(nPlayerID,"Shop_Buy_Evalution_Count")
        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )

    end
end
function chaotic_era_shop:TryBuyUpgradeChance(nPlayerID)
    local data = self.baseConfig.playerShop[tostring(nPlayerID)]
    local cost = data.UpgradeCost + data.UpgradeCost_Step * data.currentUpgradeBuyCount
    local player = PlayerResource:GetPlayer(nPlayerID) 
    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
    local currentGold = playerHero:GetGold()
    if currentGold<cost then
        return false
    end
    if data.currentUpgradeCharge<=0 then
        return false
    end
    playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
    data.currentUpgradeCount =  data.currentUpgradeCount  + 2
    data.currentUpgradeCharge = data.currentUpgradeCharge - 1
    data.currentUpgradeBuyCount = data.currentUpgradeBuyCount + 1
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )

    print("ok")
    return true
end

-- 购买出售机会
function chaotic_era_shop:_BuySellChance(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id

    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local data = self.baseConfig.playerShop[tostring(nPlayerID)]
        local cost = data.SellCost + data.SellCost_Step * data.currentSellBuyCount


        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end

        if data.currentSellCharge<=0 then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Item","General.Cancel")
            return
        end



        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        
        data.currentSellCount =  data.currentSellCount  + 1 
        data.currentSellCharge = data.currentSellCharge - 1
        data.currentSellBuyCount = data.currentSellBuyCount + 1



        EmitClientSound(nPlayerID,"Shop_Buy_Evalution_Count")
        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )

    end
end

function chaotic_era_shop:TryBuySellChance(nPlayerID)
    local data = self.baseConfig.playerShop[tostring(nPlayerID)]
    local cost = data.SellCost + data.SellCost_Step * data.currentSellBuyCount


    local player = PlayerResource:GetPlayer(nPlayerID) 
    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
    local currentGold = playerHero:GetGold()
    if currentGold<cost then
        return false
    end

    if data.currentSellCharge<=0 then
        return false
    end
    playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
    data.currentSellCount =  data.currentSellCount  + 1 
    data.currentSellCharge = data.currentSellCharge - 1
    data.currentSellBuyCount = data.currentSellBuyCount + 1
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )
    return true
end


-- 购买神器
function chaotic_era_shop:_BuyArtifact(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id
    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local data = self.baseConfig.playerShop[tostring(nPlayerID)]
        local cost = data.ArtifactCost + data.ArtifactCost_Step * data.currentArtifactBuyCount


        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end

        if data.currentArtifactCharge<=0 then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Item","General.Cancel")
            return
        end
        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        data.currentArtifactCharge = data.currentArtifactCharge - 1
        data.currentArtifactBuyCount = data.currentArtifactBuyCount + 1


        self:GenetateArtifactForPlayer(nPlayerID,false)
        EmitClientSound(nPlayerID,"Shop_Buy_Evalution_Count")
        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )

    end
end

-- 检测升阶点数
function chaotic_era_shop:CheckEvolutionChange(nPlayerID)
    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)]
    if dataTable.currentEvolutionCount>=1 then
        return true
    else
        return false
    end
end
-- 消耗乱纪元升阶点数
function chaotic_era_shop:GeneralSpellEvolute(nPlayerID)
    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)]
    dataTable.currentEvolutionCount = dataTable.currentEvolutionCount - 1
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )

end
-- 检测升级点数
function chaotic_era_shop:CheckUpgradeChange(nPlayerID)
    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)]
    if dataTable.currentUpgradeCount>=1 then
        return true
    else
        return false
    end
end
-- 消耗乱纪元升级点数
function chaotic_era_shop:GeneralSpellUpgrade(nPlayerID)
    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)]
    dataTable.currentUpgradeCount = dataTable.currentUpgradeCount - 1
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )

end

-- 检测出售机会
function chaotic_era_shop:CheckSellChange(nPlayerID)
    -- if true then
    --     return true
    -- end
    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)]
    if dataTable.currentSellCount>=1 then
        return true
    else
        return false
    end
end
-- 消耗乱纪元出售点数
function chaotic_era_shop:GeneralSpellSell(nPlayerID)
    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)]
    dataTable.currentSellCount = dataTable.currentSellCount - 1
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )

end






-- 延迟生成
function chaotic_era_shop:_PauseTaskProgress(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id

    if self.baseConfig.playerShop[tostring(nPlayerID)] then
        local data = self.baseConfig.playerShop[tostring(nPlayerID)]
        local cost = self.baseConfig.DelayTask.cost

        local player = PlayerResource:GetPlayer(nPlayerID) 
        local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
        local currentGold = playerHero:GetGold()
        if currentGold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end
        if data.currentLevel< self.baseConfig.DelayTask.levelRequire then
            -- 等级不足
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Level","General.Cancel")
            return
        end
        if not Game_State:IsInBattle() then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_In_Battle","General.Cancel")
            return
        end
        local currentTime = GameRules:GetGameTime()
        if  self.baseConfig.DelayTask.timer>=currentTime then
            SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_In_Cooldown","General.Cancel")
            return
        end


        -- chaotic_era_spawner:DelaySpawner(self.baseConfig.DelayTask.delayTime)
        chaotic_era_spawner:PhaseChaoticEra(self.baseConfig.DelayTask.delayTime)
        self.baseConfig.DelayTask.timer = currentTime + self.baseConfig.DelayTask.cooldown


        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
        
        -- chaotic_era_spawner:GenetateTask()

        -- local gameEvent = {}
        -- gameEvent["player_id"] = nPlayerID
        -- gameEvent["teamnumber"] = -1
        -- gameEvent["message"] = "#HUD_ChaoticEra_PlayerStopTask"
        -- FireGameEvent( "dota_combat_event_message", gameEvent )
     
  
        -- EmitClientSound(nPlayerID,"Shop_StopTaskProgress")

        CustomNetTables:SetTableValue( "game_config", "chaoticEra_ShopConfig", self.baseConfig )


        
    end

end


-- 为玩家生成一组可购买的装备
function chaotic_era_shop:GenerateChaoticEraItem(nPlayerID)

    local dataTable = self.baseConfig.playerShop[tostring(nPlayerID)].itemGenerateCount
    local potionTable = self.baseConfig.playerShop[tostring(nPlayerID)].potionGenerateCount
    
    local shopLevel = self:GetPlayerShopLevel(nPlayerID,true)
    local count = dataTable[math.min(#dataTable,shopLevel)] --生成个数
    local potionCount = potionTable[math.min(#potionTable,shopLevel)] --生成个数
    local hero = player:GetPlayerHero(nPlayerID)
    if not hero then
        return
    end
    count = count + math.floor(GetUnit_ChaoticEraItemGenetateCount(hero))




    if not self.playerItemList[nPlayerID] then
        self.playerItemList[nPlayerID] = {}
    end

    -- 处理锁定的道具 将被锁定
    local list = {}
    for index, value in ipairs(self.playerItemList[nPlayerID]) do
        if value.lock==1 and value.enable>=1 then
            table.insert(list,table.shallowCopy(value))
        end
      
    end
    -- 将装备表初始化后 将锁定的装备插入
    self.playerItemList[nPlayerID] = {}
    for index, value in ipairs(list) do
        table.insert(self.playerItemList[nPlayerID],table.shallowCopy(value))
    end

    -- 根据商店等级得到生成等级  药剂等级跟装备等级公用同个生成等级
    local generateLevel = self.baseConfig.playerShop[tostring(nPlayerID)].itemGenerateLevel[shopLevel]
    local function GenetateLevel(generateLevel)
        local totoalWeight = 0
        local data = {}
        for index, value in ipairs(generateLevel) do
            totoalWeight = totoalWeight + value
            table.insert(data,{
                require = totoalWeight,
                level = index,
            })
        end
        local randomIndex = RandomInt(1, totoalWeight)
        for index, value in ipairs(data) do
            if randomIndex<=value.require then
                return value.level
            end
        end
        return 1

    end

    local radndomselect = {
        "physical_weapon",
        "magical_weapon",
        "armor",
        "subsidiarity",
        "special",
    }

    local itemList = {
        physical_weapon = {},
        magical_weapon = {},
        armor = {},
        subsidiarity = {},
        special = {},
    }
    

    local total = 0
    while true do
        total = total + 1
        local level = GenetateLevel(generateLevel)
        local selectd = radndomselect[RandomInt(1, 5)]

        -- 为了不生成相同物品的操作
        if not itemList[selectd][level] then
            itemList[selectd][level] = table.shallowCopy(self.itemList[selectd][level])
        end
        if  #itemList[selectd][level]>=1 then
            local index =RandomInt(1, #itemList[selectd][level])

            local itemData = itemList[selectd][level][index]
            local data = {
                item_name = itemData.item_name,
                cost = itemData.cost,
                type = selectd,
                level = level,
                enable = 1,
                lock = 0,
            }
            table.insert( self.playerItemList[nPlayerID],data)
            table.remove(itemList[selectd][level],index)
            count = count - 1
        else
            -- 某项装备全部没了那就只能再来一起了
            -- count = count + 1
        end
        if count<=0 then
            break
        end
        if total>=100 then
            -- 防止无限循环
            break
        end
     
    end

    local additionalItem = GetChaoticEraAdditionalShopIitem(hero,{})
    -- print("ooooooooo")
    if additionalItem then
        for index, itemData in ipairs(additionalItem) do
            if itemData.item_name then
                local data = {
                    item_name = itemData.item_name,
                    cost = itemData.cost or 0,
                    type = itemData.selectd or "special",
                    level = itemData.level or 1,
                    enable = 1,
                    lock = 0,
                }
                table.insert( self.playerItemList[nPlayerID],data)
            end
        end
    end




    -- 装备生成完毕

    local potionList = {}
    
    local bonusList = {}
    local totalWeight = 0
    local function generateList(keys)
		bonusList = {}
        totalWeight = 0
		for index, value in ipairs(keys) do
            local data = {}
            data.item_name = value.item_name
            local cost = value.cost * hero:GetPotionCostIndex(1)
            -- print("cost=",cost)
            data.cost = math.floor(cost)
            data.weightRequire_min = totalWeight
            totalWeight = totalWeight + value.weight
            data.weightRequire = totalWeight
            -- bonusList[bonusName] =  table.shallowCopy(value)
            table.insert(bonusList,data)

            ::continue::
		end
	end

-- self.potion

    local potionRadndomselect = {}
    for key, value in pairs(self.potion) do
        table.insert(potionRadndomselect,key)
    end

    -- PrintTable(potionRadndomselect)

    local total = 0
    while true do
        total = total + 1
        local level = GenetateLevel(generateLevel)
        -- print("level=",level)
        local selectd = potionRadndomselect[RandomInt(1, #potionRadndomselect)]
        local targetList = self.potion[selectd][level]
        if not targetList then
            -- body
            goto bottom;
        end
        -- PrintTable(targetList)
        -- 为了不生成相同物品的操作
        if not potionList[selectd] then
            potionList[selectd] = {}
        end
        if not potionList[selectd][level] then
            potionList[selectd][level]  = {}
            -- 生成临时表以防止产生重复药剂
            -- print("开始生成")
            for bonusName, value in pairs(targetList) do
                local weight =value.weight
                if weight then
                    -- 满足所有条件 插入表
                    local data = {}
                    data.item_name = value.item_name
                    data.cost = value.cost
                    data.weight = weight
                    table.insert(potionList[selectd][level],data)
                end
                ::continue::
            end
        end
        if  #potionList[selectd][level]>=1 then
            generateList(potionList[selectd][level])
            local iRandom = RandomInt(1, totalWeight) --生成权重
            for _, itemData in ipairs(bonusList) do
                if iRandom>=itemData.weightRequire_min and iRandom<=itemData.weightRequire then
                    local data = {
                        item_name = itemData.item_name,
                        cost = itemData.cost,
                        type = selectd,
                        level = level,
                        enable = 1,
                        lock = 0,
                        isPotion = 1,
                        count = KeyValues.game_shop_chaotic_era_potion[itemData.item_name].count,
                    }
                    
                    table.insert(self.playerItemList[nPlayerID],data)
                    potionCount = potionCount - 1 --减少个数
                    for index, spellData in ipairs(potionList[selectd][level]) do
                        if spellData.item_name==itemData.item_name then
                            table.remove( potionList[selectd][level],index)
                            break
                        end
                    end
                    break
                end
            end

  
        else
            -- 某项装备全部没了那就只能再来一起了
            -- print("已消耗完毕 重新生成一次吧")
        end

        ::bottom::
        if potionCount<=0 then
            break
        end
        if total>=100 then
            -- 防止无限循环
            -- print("不能无限")
            break
        end
    end
    
  

    -- 生成药剂

   

    -- PrintTable(self.playerItemList[nPlayerID])

    EmitClientSound(nPlayerID,"Shop_Refesh")



    CustomNetTables:SetTableValue( "game_config", "chaoticEra_playerShopItem", self.playerItemList )

end

-- 尝试购买装备
function chaotic_era_shop:_TryBuyItem_ChaoticEraShop(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id

    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then  
        return
    end
    local itemName = event_data.itemname
    if self.playerItemList[nPlayerID] then
        for index, value in ipairs(self.playerItemList[nPlayerID]) do
            if value.item_name==itemName then
                if value.enable>0 then
                    local cost = value.cost
                    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
                    local currentGold = playerHero:GetGold()



                    if currentGold<cost then
                        -- 金币不足
                        SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
                        return
                    end

                    local tParams = {
                        cost = cost,
                        itemName = itemName,
                    }
            
                    local reduction = 1-GetShopPriceReduction(playerHero,tParams)*0.01
                    cost = math.floor(cost *reduction)


                    playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币
            
                    local playerHero = player:GetAssignedHero()

                    value.enable = value.enable - 1
                    if value.enable <=0 and value.lock==1 then
                        value.lock = 0
                    end
                    if value.isPotion then
                        -- 添加药剂到药剂背包
                        local dataList = self.currentPlayerOwnerPotion[nPlayerID]
                        -- 先找到有没有这个药剂 有就改数量就行了
                        local pass = false
                        for i = 1, #dataList do
                            if dataList[i].item_name==value.item_name then
                                dataList[i].count = dataList[i].count + value.count
                                pass = true
                                break
                            end
                        end
                        if not pass then
                            local data = {
                                item_name = value.item_name,
                                type = value.selectd,
                                level = value.level,
                                count = value.count
                            }
                            table.insert(dataList,data)
                        end

                        self:UpdatePlayerPotionBag()
                       


                    else
                        -- 普通道具
                        local item = playerHero:AddItemByName(itemName)
                        if item then
                            item.itemType = value.type
                        end
                    end

                    EmitClientSound(nPlayerID,"General.Buy")
                    CustomNetTables:SetTableValue( "game_config", "chaoticEra_playerShopItem", self.playerItemList )
                    return
                end
               
            end
        end
    end

    SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Item","General.Cancel")
    return

end


-- 使用药剂
function chaotic_era_shop:_UseChaoticEraPotion(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id

    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then  
        return
    end
    local PotionName = event_data.item_name
    if self.currentPlayerOwnerPotion[nPlayerID] then
        for index, value in ipairs(self.currentPlayerOwnerPotion[nPlayerID]) do
            if value.item_name==PotionName then
                -- PrintTable(value)
                if value.count<=0 then
                    --没药剂了
                    SendCustomErrorToPlayer(nPlayerID,"HUD_Potion_Error_1","General.Cancel")
                    return
                else
                    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
                    if not playerHero:IsAlive() then
                        SendCustomErrorToPlayer(nPlayerID,"HUD_Potion_Error_2","General.Cancel")
                        return
                    end
                    value.count = value.count-1
                    self:UpdatePlayerPotionBag()
                    local modifierName = "modifier_"..value.item_name
                    local kv = KeyValues.game_shop_chaotic_era_potion[value.item_name]
                    if kv then
                        if kv.removeOnReuse and kv.removeOnReuse==1 then
                            print("remove modifier")
                            playerHero:RemoveModifierByName(modifierName)
                        end
                    else
                        print("找不到kv potionName=",value.item_name)
                        return
                    end
                    -- 需要延迟一下  不然属性更新不及时
                    playerHero:GameTimer(0.03, function()
                        playerHero:AddNewModifier(playerHero, nil, modifierName, {duration = 10})
                    end)

                   
	
                end

                return
                
   
               
            end
        end
    end

    SendCustomErrorToPlayer(nPlayerID,"HUD_Potion_Error_1","General.Cancel")
    return

end



function chaotic_era_shop:UpdatePlayerPotionBag()
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_playerPotionBag", self.currentPlayerOwnerPotion )
end





function chaotic_era_shop:_TryLockItem_ChaoticEraShop(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id

    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then  
        return
    end
    local itemName = event_data.itemname
    if self.playerItemList[nPlayerID] then
        for index, value in ipairs(self.playerItemList[nPlayerID]) do
            if value.item_name==itemName then
                if value.enable==0 then
                    SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Enough_Item","General.Cancel")
                    return
                end

                if value.lock==0 then
                    -- 检测是否达到最大上限 Chaotic_Era_Item_Lock_Max
                    local count = 0
                    for index, runeData in ipairs(self.playerItemList[nPlayerID]) do
                        if runeData.lock==1 then
                            count = count + 1
                        end
                    end
                    if count>=self.baseConfig.playerShop[tostring(nPlayerID)].Chaotic_Era_Item_Lock_Max then
                        SendCustomErrorToPlayer(nPlayerID,"HUD_Lock_Max","General.Cancel")
                        return
                    end
                    value.lock = 1
                else
                    value.lock = 0
                end


                CustomNetTables:SetTableValue( "game_config", "chaoticEra_playerShopItem", self.playerItemList )
            end
        end
    end

end


-- 生成一次乱纪元技能等级
function chaotic_era_shop:GenerateChaoticEraSpellLevel(nPlayerID)


    local shopLevel = self:GetPlayerShopLevel(nPlayerID,true)

    -- 根据商店等级得到生成等级
    local generateLevel = self.baseConfig.playerShop[tostring(nPlayerID)].spellGenerateLevel[shopLevel]
    
    local function GenetateLevel(generateLevel)
        local totoalWeight = 0
        local data = {}
        for index, value in ipairs(generateLevel) do
            totoalWeight = totoalWeight + value
            table.insert(data,{
                require = totoalWeight,
                level = index,
            })
        end
        local randomIndex = RandomInt(1, totoalWeight)
        for index, value in ipairs(data) do
            if randomIndex<=value.require then
                return value.level
            end
        end
        return 1

    end

    return GenetateLevel(generateLevel)
    



end






-- 更新重新随机的机会
function chaotic_era_shop:UpdateRerollChance(nPlayerID)
    if self.rerollChance[nPlayerID] then
        local key = "chaoticEra_spellReroll_"..nPlayerID
        CustomNetTables:SetTableValue( "game_config", key, self.rerollChance[nPlayerID] )
    end
end




-- 生成一组可选择的神器
function chaotic_era_shop:GenetateArtifactForPlayer(nPlayerID,bForceRefresh)

	if bForceRefresh then
		self.player_artifact_waitForSelect[nPlayerID].list  = {

		}
	end
	if #self.player_artifact_waitForSelect[nPlayerID].list>=1 then
        -- 延迟一段时间后再次尝试即可
        Timers:CreateTimer(1, function()
			self:GenetateArtifactForPlayer(nPlayerID,bForceRefresh)
		end)
        return
    end
    self.player_artifact_waitForSelect[nPlayerID].card_index =self.player_artifact_waitForSelect[nPlayerID].card_index+1
    -- 开始生成
    local kvList = table.shallowCopy(KeyValues.artifact)  --总之先复制一个来备用
    
    local hero = player:GetPlayerHero(nPlayerID)
    if not hero then
        return
    end

    local abilityList = {
        ice = 0,
        fire = 0,
        lighting = 0,
        holy = 0,
        dark = 0,
    }
    for i=0, hero:GetAbilityCount() - 1 do
        local Ability = hero:GetAbilityByIndex(i)
        if Ability ~= nil then
            if Ability:IsIceSpell() then
                abilityList.ice = abilityList.ice + 1
            end
            if Ability:IsFireSpell() then
                abilityList.fire = abilityList.fire + 1
            end
            if Ability:IsLightningSpell() then
                abilityList.lighting = abilityList.lighting + 1
            end
            if Ability:IsHolySpell() then
                abilityList.holy = abilityList.holy + 1
            end
            if Ability:IsDarkSpell() then
                abilityList.dark = abilityList.dark + 1
            end
            local chaoticSpellType = Ability:GetChaoticSpellType()
            if not abilityList[chaoticSpellType] then
                abilityList[chaoticSpellType]  = 0
            end
            abilityList[chaoticSpellType] = abilityList[chaoticSpellType]  + 1
        end
    end


    local bonusList = {}
    local totalWeight = 0
    local playerCount = GetPlayerCount()
	local function generateList()
		bonusList = {}
        totalWeight = 0
		for id, value in pairs(kvList) do
			-- print("checking")
			if value.wave_require and value.wave_require>chaotic_era_spawner:GetCurrentWave() then
				goto continue
			end
            if value.wave_require_max and value.wave_require_max<chaotic_era_spawner:GetCurrentWave() then
                goto continue
            end
            if value.player_count_require and value.player_count_require>playerCount then
                goto continue
            end
            if value.OnlyRanger and value.OnlyRanger==1 and not hero:IsRangedAttacker() then
                goto continue
            end
            if value.OnlyMelee and value.OnlyMelee==1 and hero:IsRangedAttacker() then
                goto continue
            end
            if value.RequireIce and value.RequireIce==1 and abilityList.ice<=0 then
                goto continue
            end
            if value.RequireFire and value.RequireFire==1 and abilityList.fire<=0 then
                goto continue
            end
            if value.RequireLightning and value.RequireLightning==1 and abilityList.lighting<=0 then
                goto continue
            end
            if value.RequireHoly and value.RequireHoly==1 and abilityList.holy<=0 then
                goto continue
            end
            if value.RequireDark and value.RequireDark==1 and abilityList.dark<=0 then
                goto continue
            end
            if value.RequireEvocation and value.RequireEvocation==1 and abilityList["HUD_Evocation_spell"]<=0 then
                 goto continue
            end


            if IsInTable(id,self.player_artifact[nPlayerID]) then
                goto continue;
            end
            -- 如果已选择过那也不要
            if value.weight then
				-- print("插入")
                -- 满足所有条件 插入表
                local data = {
                }
                data.id = id
                data.weightRequire_min = totalWeight
                totalWeight = totalWeight + value.weight
                data.weightRequire = totalWeight
                table.insert(bonusList,data)
            end
            ::continue::
		end
		-- PrintTable(bonusList)
	end


    local generateCount = self.baseConfig.Chaotic_era_artifact_count
    for i = 1, generateCount, 1 do
		-- print("step 1")
		generateList()
        local iRandom = RandomInt(1, totalWeight) --生成权重
        for _, value in ipairs(bonusList) do
            if iRandom>=value.weightRequire_min and iRandom<=value.weightRequire then
				table.insert(self.player_artifact_waitForSelect[nPlayerID].list,value.id)
                kvList[value.id] = nil
				
                break
            end
        end

	end
    local keyID = "chaotic_era_artifact_"..nPlayerID
    CustomNetTables:SetTableValue( "chaoticEraData", keyID, self.player_artifact_waitForSelect[nPlayerID] )

end

-- 选择神器
function chaotic_era_shop:_SelectTargetArtifact(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id
	local target_name = event_data.name
    local hero = player:GetPlayerHero(nPlayerID)
    if not hero:IsAlive() then
        SendCustomErrorToPlayer(hero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_1","General.Cancel")
        return
    end

    -- PrintTable(self.player_artifact_waitForSelect[nPlayerID])
    -- PrintTable(self.player_artifact_waitForSelect[nPlayerID].list)
	for _, value in ipairs(self.player_artifact_waitForSelect[nPlayerID].list) do
		if value==target_name then
			-- print("选择ok")
            self.player_artifact_waitForSelect[nPlayerID].list = {}

            table.insert(self.player_artifact[nPlayerID],value)
            local name =target_name
            local logic_type= KeyValues.artifact[name].type
            

			

			local gameEvent = {}
            gameEvent["player_id"] = nPlayerID
            gameEvent["teamnumber"] = -1
			gameEvent["locstring_value"] = "#"..name
			gameEvent["message"] = "#New_Artifact_Init"
            FireGameEvent( "dota_combat_event_message", gameEvent )

            -- print("logic_type=",logic_type)
            if logic_type=="self_buff" then
                
                hero:AddNewModifier(hero, nil, "modifier_"..name, {})
                
            elseif logic_type=="dummy_buff" then
                MODIFIER_GLOBAL_DUMMY:AddNewModifier(MODIFIER_GLOBAL_DUMMY, nil, "modifier_"..name, {})
            end
		end
	end

    local keyID = "chaotic_era_artifact_"..nPlayerID
    CustomNetTables:SetTableValue( "chaoticEraData", keyID, self.player_artifact_waitForSelect[nPlayerID] )
    CustomNetTables:SetTableValue( "game_config", "chaoticEra_artifact", self.player_artifact )

end


-- 神器被点击
function chaotic_era_shop:_OnArtifactClicked(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id
	local target_name = event_data.name
    local hero = player:GetPlayerHero(nPlayerID)
    print("event_data.bAltDown=",event_data.bAltDown)
    if event_data.bAltDown==1 then
        -- "HUD_Alert_Artifact_1" "<font color='%sColor1'>%sPlayer1</font> 拥有神器:<font color='%sColor2'>%sArtifactName</font>"
        local data = {
            caller = nPlayerID,
            text = "#HUD_Alert_Artifact_1",
            keys = {
                sPlayer1 = {
                    text=hero:GetUnitName(),
                    bLocalize = 1,
                },
                sColor1 = {
                    text="#a7d1e9",
                    bLocalize = 0,
                },
                sColor2 = {
                    text="#caa7e9",
                    bLocalize = 0,
                },
                sArtifactName = {
                    text=event_data.artifactName,
                    bLocalize = 1,
                }
            },
        }
 
        CustomGameEventManager:Send_ServerToAllClients("CustomAlert_JS", data)
    end

end


return chaotic_era_shop