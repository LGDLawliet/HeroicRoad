local RuneSync = require("internal/rune_sync")
chaotic_era = chaotic_era or class({})
TOOLMOD_LEVEL = 3

-- 根据稀有度决定词条数量
Rarity_Special_Count = {
    1,  --普通符石的词条数
    1,  --罕见
    1,  --稀有
    2,  --神话
    3,  --不朽
    3,  -- 至宝

}

require("internal/chaotic_era/chaotic_era_server")
-- require("internal/chaotic_era/chaotic_era_spawner")
-- require("internal/chaotic_era/chaotic_era_shop")


CHAOTIC_ERA_ACTION_Save_Rune = "rune/save"
CHAOTIC_ERA_ACTION_Modify_Rune = "rune/edit"
CHAOTIC_ERA_ACTION_Delete_Rune = "rune/delete"
CHAOTIC_ERA_ACTION_Get_All_Rune = "rune/findBySteamId"

CHAOTIC_ERA_ACTION_EquipRune = "rune/equipRune"

function chaotic_era:init(bReload)
    

    
    if not bReload then

        self.playerHero = {}
        self.generalSpellList = {}
        self.player_spell_disableList = {}
        -- 生成总表
        for index, listName in ipairs(SpellShopKV) do
            local spellShopDataList = KeyValues[listName]
            for key, value in pairs(spellShopDataList) do
                -- if value.disableInChaoticEra and value.disableInChaoticEra==1 then
                --     print("存在不能出现的技能")
                -- else
                    self.generalSpellList[key] =  table.shallowCopy(value)
                -- end
               
            end
        end
    
        -- 需要移除这个用于换位的技能
        self.generalSpellList["for_swap_spells"] = nil 
    
    
        self.spellList_GenerateChance ={
            general = {}, --基本的生成次数
        }
        self.spellList_waitForSelected = {}
    
    
        self.runeData = {}
        self.runeEquip = {}  --如果正在装备一个符石，那么无法再次进行装备
    
        self.runeEquip__Nettable = {}  --网表用数据
    
    
    
    
        -- 乱纪元技能生成数
        self.ChaoticEra_GeneralAbility_GenerateCount = KeyValues.base_setting["Chaotic_Era_GeneralAbility_GenerateCount"].value
        self.Chaotic_Era_ChaoticAbility_GenerateCount = KeyValues.base_setting["Chaotic_Era_ChaoticAbility_GenerateCount"].value
    
    
        -- 阶技能最大可学习数
        self.Chaotic_Era_GeneralSpell_Count_Limit = KeyValues.base_setting["Chaotic_Era_GeneralSpell_Count_Limit"].value
    
    
    
    
    
        -- 分解奖励
        self.delBonus_exp = {
            KeyValues.base_setting["Rune_Del_return_1"].value1,
            KeyValues.base_setting["Rune_Del_return_2"].value1,
            KeyValues.base_setting["Rune_Del_return_3"].value1,
            KeyValues.base_setting["Rune_Del_return_4"].value1,
            KeyValues.base_setting["Rune_Del_return_5"].value1,
            KeyValues.base_setting["Rune_Del_return_6"].value1,
        }
        self.delBonus_aurum = {
            KeyValues.base_setting["Rune_Del_return_1"].value2,
            KeyValues.base_setting["Rune_Del_return_2"].value2,
            KeyValues.base_setting["Rune_Del_return_3"].value2,
            KeyValues.base_setting["Rune_Del_return_4"].value2,
            KeyValues.base_setting["Rune_Del_return_5"].value2,
            KeyValues.base_setting["Rune_Del_return_6"].value2,
        }
        self.BonusAttributesTable = {
            
            --伤害增加
            {
                1
            },
            --伤害减免
            {
                1
            },
            --基础攻击力
            {
                0.33
            },
            --天赋树1
            {
                40
            },
            --天赋树2
            {
                40
            },
            --天赋树3
            {
                40
            },
            --天赋树4
            {
                40
            },
            --天赋树5
            {
                40
            },
        }
        
        CustomNetTables:SetTableValue( "chaoticEraData", "bonusAttribute_cost", self.BonusAttributesTable )  --更新网表
    
    end
  

  
    CustomUIEvent("LearnChaoticEraSpell", Dynamic_Wrap(self, "_LearnChaoticEraSpell"), self)
    CustomUIEvent("GiveChaoticEraSpell", Dynamic_Wrap(self, "_GiveChaoticEraSpell"), self)
    CustomUIEvent("RerollAbility", Dynamic_Wrap(self, "_RerollAbility"), self)
    CustomUIEvent("GetChaoticEraRuneData", Dynamic_Wrap(self, "_GetChaoticEraRuneData"), self)
    CustomUIEvent("EquipTargetRune", Dynamic_Wrap(self, "_EquipTargetRune"), self)
    CustomUIEvent("ChangeRuneLockState", Dynamic_Wrap(self, "_ChangeRuneLockState"), self)
    CustomUIEvent("EditRuneBonusValue", Dynamic_Wrap(self, "_EditRuneBonusValue"), self)
    CustomUIEvent("DelRuneList", Dynamic_Wrap(self, "_DelRuneList"), self)
    CustomUIEvent("SendBonusAttributes_ChaoticEra", Dynamic_Wrap(self, "_SetBonusAttributes"), self)




 


   

end

function chaotic_era:_LearnChaoticEraSpell(eventSourceIndex, event_data)
    local nPlayerID = event_data.PlayerID
    local abilityName = event_data.spellName

    local hero = player:GetPlayerHero(nPlayerID)
    if IsValid(hero) then
        -- DeepPrint(self.spellList_waitForSelected[nPlayerID])
        local maxSlotNumber = skillshop:GetMaxSpellCount(hero)
        if not hero:IsAlive() then
            SendCustomErrorToPlayer(hero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_1","General.Cancel")
            -- hero:EmitSound("General.Cancel")
            return
        end
        if skillshop:GetPlayerAbilityNumber(hero) >= maxSlotNumber and abilityName~="for_swap_spells" then
            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Spells_Menu_Not_Enough_Slot","General.Cancel")
            return
        end

        local abilityKV = skillshop:FindAbilityShopKV(abilityName)
        if abilityKV  then
            -- 如果是阶技能再判断
            if skillshop:GetPlayerGeneralAbilityNumber(hero) >= self.Chaotic_Era_GeneralSpell_Count_Limit and abilityName~="for_swap_spells" then
                SendCustomErrorToPlayer(nPlayerID,"HUD_Not_Enough_Slot_General","General.Cancel")
                return
            end
        end
        -- Chaotic_Era_Buy_Spell_gold_return = KeyValues.base_setting["Chaotic_Era_Buy_Spell_gold_return"].value,

 
  
        if self.spellList_waitForSelected[nPlayerID] then
            for _, spellName in ipairs(self.spellList_waitForSelected[nPlayerID]) do
                if spellName==abilityName then
                    self.spellList_waitForSelected[nPlayerID] = nil
                    local abilityKeyId = "spellList_waitForSelected"..nPlayerID
                    CustomNetTables:SetTableValue( "chaoticEraData", abilityKeyId, {} )  --更新网表
                    self:LearnChaoticEraSpell(hero,abilityName)
                    return
                end
            end
            print("Error: 未能找到对应的技能,",abilityName)
            DeepPrint(self.spellList_waitForSelected[nPlayerID])

        else
            print("Error: 重复学习 结束流程")
            return
        end
    end
end

function chaotic_era:_GiveChaoticEraSpell(eventSourceIndex, event_data)
    local nPlayerID = event_data.PlayerID
    local hero = player:GetPlayerHero(nPlayerID)
    if IsValid(hero) then
        if self.spellList_waitForSelected[nPlayerID] then
            self.spellList_waitForSelected[nPlayerID] = nil
            local gold_return = KeyValues.base_setting["Chaotic_Era_Buy_Spell_gold_return"].value
            -- local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
          
            -- playerHero:ModifyGoldFiltered(gold_return,true,DOTA_ModifyGold_PurchaseItem)  --消耗金币

            hero:ModifyGoldFiltered(gold_return,true,DOTA_ModifyGold_CreepKill )  --金币奖励
            SendOverheadEventMessage(hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,hero, gold_return, nil)
        
            local abilityKeyId = "spellList_waitForSelected"..nPlayerID
            CustomNetTables:SetTableValue( "chaoticEraData", abilityKeyId, {} )  --更新网表

        end
    end
end

function chaotic_era:_RerollAbility(eventSourceIndex, event_data)
    local nPlayerID = event_data.PlayerID
    local hero = player:GetPlayerHero(nPlayerID)
    if IsValid(hero) then
        if self.spellList_waitForSelected[nPlayerID] then
            -- 检测一下剩余机会
            if chaotic_era_shop.rerollChance[nPlayerID].freeReRollAbility>=1 then
                -- 如果有免费激活 那么直接重随
                chaotic_era_shop.rerollChance[nPlayerID].freeReRollAbility = chaotic_era_shop.rerollChance[nPlayerID].freeReRollAbility - 1
                chaotic_era_shop:UpdateRerollChance(nPlayerID)
                self.spellList_waitForSelected[nPlayerID] = nil
                self:GenerateSpellList_Genaral(nPlayerID) --重新随机（注意未来如果做了有类别的技能生成 那么需要更改一下这里）
            else
                -- 如果没有免费激活 那么尝试
                if chaotic_era_shop.rerollChance[nPlayerID].rerollAbilityCharge>=1 then
                    local aurumCost = chaotic_era_shop.rerollChance[nPlayerID].rerollAurumCost
                    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
                    local now_gold = tonumber(map.playerinfo.gold)  --拿到当前的黄金
                    if now_gold>=aurumCost then
                        self.spellList_waitForSelected[nPlayerID] = nil
                        self:GenerateSpellList_Genaral(nPlayerID) --重新随机（注意未来如果做了有类别的技能生成 那么需要更改一下这里）
                        -- 直接消耗 然后再请求 失败了也无所谓
                        map.playerinfo.gold = map.playerinfo.gold - aurumCost
                        chaotic_era_shop.rerollChance[nPlayerID].rerollAbilityCharge = chaotic_era_shop.rerollChance[nPlayerID].rerollAbilityCharge - 1
                        chaotic_era_shop:UpdateRerollChance(nPlayerID)

                        

                        local newData ={
                            token= _G.GAME_GLOBAL_KEY,
                            playerInfo = {
                                steamId = tostring(PlayerResource:GetSteamID(nPlayerID)),
                                steamName = PlayerResource:GetSteamAccountID(nPlayerID),
                                gold =-aurumCost,
                            }
                        }
                        local encoded = json.encode(newData)
                        player_database:UpdateUserData_with_steamID_ReRoll(encoded)
                        
                    else
                        SendCustomErrorToPlayer(nPlayerID,"Black_Market_spell_buy_failed_not_enough_good","General.Cancel")
                        return
                    end

                else
                    SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_ChaoticEraSpellsLis_reroll_Error_1","General.Cancel")
                    return
                end

            end
            
            

        end
    end
end



function chaotic_era:InitAttributeCount()
    local count = KeyValues.base_setting["Chaotic_Era_Bonus_Attribute_Count"].value
    self.bonus_attribute = {}
    local heroes = GetAllRealHeroes()
    for _, unit in ipairs(heroes) do
        local nPlayerID = unit:GetPlayerOwnerID()
        self.bonus_attribute[nPlayerID]  ={
            count = count + customDataManager:GetChaoticEraBonusCount(unit),
            setting = false,
        }
        -- if tostring(PlayerResource:GetSteamID(nPlayerID))=="76561198828335572" then
        --     self.bonus_attribute[nPlayerID].count = 71
        -- end
    end
    CustomNetTables:SetTableValue( "chaoticEraData", "bonusAttribute", self.bonus_attribute )  --更新网表
end


function chaotic_era:_SetBonusAttributes(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local data = event_data.attributes
    local totalCost = 0
    if not  self.bonus_attribute then
        return
    end
    if not  self.bonus_attribute[nPlayerID] then
        return
    end
    if self.bonus_attribute[nPlayerID].setting==true then
        print("Error:重复提交数据")
        return
    end
    --计算总数是否对得上
	for key, value in pairs(data) do
        local cost = 0
        cost = BonusAttributesTable[tonumber(key)][1] *value
        cost = math.ceil(cost)
        -- print(cost)
        totalCost = totalCost  + cost
    end
    print(totalCost)
    print(self.bonus_attribute[nPlayerID].count)

    --给一个加1是防止数据交互时小数出现问题
        --尝试修复中尝试修复中尝试修复中尝试修复中尝试修复中尝试修复中尝试修复中
    --if totalCost>self.bonus_attribute[nPlayerID].count then
      --  print("error:数据不合法")
        --return
    --end
    local playerHero = player:GetAssignedHero()
    if not playerHero:IsAlive() then
        SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Bonus_Attributes_failed_die","General.Cancel")
        return
    end

    self.bonus_attribute[nPlayerID].setting = true  --设置为完成
	
    local gameEvent = {}
    gameEvent["player_id"] = nPlayerID
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#DOTA_HUD_FellOmen_Send_Bonus_Attributes_success"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    -- print("data[1]="..data["1"])
    local modifierTable = {
        outgoing = data["1"],
        incoming = data["2"],
        attack = data["3"],
        talent_1 = data["4"],
        talent_2 = data["5"],
        talent_3 = data["6"],
        talent_4 = data["7"],
        talent_5 = data["8"],

    }
    -- local NetTable_key = tostring(nPlayerID).."_bonus_attribute"
    -- CustomNetTables:SetTableValue( "fellOmenInfo", NetTable_key, {value=modifierTable } )  --更新网表
    playerHero:AddNewModifier(playerHero, nil, "modifier_chaotic_bonus_attributes", modifierTable)  --添加buff
    CustomNetTables:SetTableValue( "chaoticEraData", "bonusAttribute", self.bonus_attribute )  --更新网表
    if modifierTable.talent_1 == 1 then
        playerHero:AddNewModifier(playerHero, nil, "modifier_chaotic_bonus_attributes_talent_1", {})
    end
    if modifierTable.talent_2 == 1 then
        playerHero:AddNewModifier(playerHero, nil, "modifier_chaotic_bonus_attributes_talent_2", {})
    end
    if modifierTable.talent_3 == 1 then
        playerHero:AddNewModifier(playerHero, nil, "modifier_chaotic_bonus_attributes_talent_3", {})
    end
    if modifierTable.talent_4 == 1 then
        playerHero:AddNewModifier(playerHero, nil, "modifier_chaotic_bonus_attributes_talent_4", {})
    end
    if modifierTable.talent_5 == 1 then
        playerHero:AddNewModifier(playerHero, nil, "modifier_chaotic_bonus_attributes_talent_5", {})
    end

end



-- 学习一个乱纪元技能
function chaotic_era:LearnChaoticEraSpell(unit,abilityName)
    -- 判断是阶技能还算环技能
    local abilityKV = skillshop:FindAbilityShopKV(abilityName)
    if abilityKV  then
        local ability_1_Name =abilityName
        local ability_2_Name = abilityKV.level2_id
        local ability_3_Name = abilityKV.level3_id
        if unit:HasAbility(ability_1_Name) or unit:HasAbility(ability_2_Name) or unit:HasAbility(ability_3_Name) then
            SendCustomErrorToPlayer(unit:GetPlayerOwnerID(),"DOTA_HUD_Spells_Menu_Not_Sell","General.Cancel")
            return
        end


        print("学习阶技能",abilityName)
        --那么这是个阶技能
        local newAbility = unit:AddAbility(abilityName)
		
		newAbility:SetLevel(1)
		--被动技能自动靠后
		if newAbility:IsPassive() then
			PassiveAbilitySwap(unit,abilityName) 
		end
        newAbility.chaoticEraData = {
            ability_type = ABILITY_TYPE_GENERAL_SHOP,
        }
        newAbility.level1_id = abilityName
        newAbility.level2_id = abilityKV.level2_id
        newAbility.level3_id = abilityKV.level3_id
        newAbility.classlevel = 1
        newAbility.to_level2_cost = abilityKV.to_level2_cost
        newAbility.to_level3_cost = abilityKV.to_level3_cost
        newAbility.upgrade_cost = abilityKV.upgrade_cost
        newAbility.totalcost = abilityKV.upgrade_cost

        if unit:HasModifier("modifier_heroTalent_npc_dota_hero_enchantress") then
            newAbility.to_level2_cost = newAbility.to_level2_cost * 0.8
            newAbility.to_level3_cost =  newAbility.to_level3_cost * 0.8
            newAbility.upgrade_cost =  newAbility.upgrade_cost * 0.8
        end

        local associatedAbility_entity

        local associatedAbilities = abilityKV.associated_spells

        if associatedAbilities then  --如果有副技能 再添加几个信息
            associatedAbility_entity = unit:AddAbility(associatedAbilities)
            if need_to_swap_hideAbility[associatedAbilities] == true then  --说明这是一个需要隐藏的技能 放到后面去
                PassiveAbilitySwapHiden(unit,associatedAbilities)
            end
            associatedAbility_entity.subSpell = true --用于判断副技能
            associatedAbility_entity:SetLevel(1)
            newAbility.now_associatedAbility = associatedAbilities                     --现在的副技能
            newAbility.level2_associatedAbility = abilityKV.level2_associated_spells  --中阶的副技能
            newAbility.level3_associatedAbility = abilityKV.level3_associated_spells  --高阶的副技能

        end


        local gameEvent = {}
        gameEvent["player_id"] = unit:GetPlayerOwnerID()
        gameEvent["teamnumber"] = -1
        gameEvent["ability_name"] = abilityName
        gameEvent["message"] = "#Spells_Menu_PurchaseNewAbility"
        FireGameEvent( "dota_combat_event_message", gameEvent )

                    
        local keys = {
            unit = unit,
            ability = newAbility,
            associatedAbility = associatedAbility_entity,
            cost = 0,
            bIsGeneralSpell = true,
            bIsChaoticEraSpell = false,
            bIsTalent = false,
            isUpgrade = false,
            IsEvolve = false,
            isBuy = true,
        }
        FireSpellLearnEvent(keys)


    else
        -- 说明是环技能
        print("学习环技能",abilityName)
        local newAbility = unit:AddAbility(abilityName)
		newAbility:SetLevel(1)
		--被动技能自动靠后
		if newAbility:IsPassive() then
			PassiveAbilitySwap(unit,abilityName) 
		end
        newAbility.chaoticEraData = {
            ability_type = ABILITY_TYPE_CHAOTIC_ERA_SPECIAL,
        }

        local gameEvent = {}
        gameEvent["player_id"] = unit:GetPlayerOwnerID()
        gameEvent["teamnumber"] = -1
        gameEvent["ability_name"] = abilityName
        gameEvent["message"] = "#Spells_Menu_PurchaseNewAbility"
        FireGameEvent( "dota_combat_event_message", gameEvent )

        local keys = {
            unit = unit,
            ability = newAbility,
            -- associatedAbility = associatedAbility_entity,
            cost = 0,
            bIsGeneralSpell = false,
            bIsChaoticEraSpell = true,
            bIsTalent = false,
            isUpgrade = false,
            IsEvolve = false,
            isBuy = true,
        }
        FireSpellLearnEvent(keys)
    end
end



-- 单位是否拥有相同类别的技能
function chaotic_era:CheckHeroHasShopSpell(unit,bonusName)
    local kv = self.generalSpellList[bonusName]
    if kv then
        if unit:HasAbility(bonusName) or unit:HasAbility(kv.level2_id) or unit:HasAbility(kv.level3_id) then
            return true
        end
    end
    local nPlayerID = unit:GetPlayerOwnerID()
    if not self.player_spell_disableList[nPlayerID] then
        self.player_spell_disableList[nPlayerID] = {} 
    end
    -- print("bonusName=",bonusName,nPlayerID)
    if self.player_spell_disableList[nPlayerID][bonusName] then
        -- print("disable=",bonusName)
        return true
    end
    return false
end



function chaotic_era:InSertDisableAbility(nPlayerID,abilityName)
    if not self.player_spell_disableList[nPlayerID] then
        self.player_spell_disableList[nPlayerID] = {}
    end
    -- print("insert=",abilityName)
    self.player_spell_disableList[nPlayerID][abilityName] = true
    return 
end






-- 生成一组可选技能组  通用（将从所有可选技能中随机生成） 包含一组环阶技能
function chaotic_era:GenerateSpellList_Genaral(nPlayerID, classlevel)
    if self.spellList_waitForSelected[nPlayerID] then
        -- 已存在一个待选择的技能列表
        -- 延迟一段时间后再次尝试即可
        Timers:CreateTimer(1, function()
			self:GenerateSpellList_Genaral(nPlayerID, classlevel)
		end)
        return
    end
    -- local hero = player:GetPlayerHero(nPlayerID)
    local returnList = {}
    if classlevel then
        if classlevel == 0 then
            --传回classlevel==0时，基于当前商店等级生成
            returnList = self:GenerateSpell_FromChaoticSpell(returnList,nPlayerID)
        elseif classlevel == -1 then
            --传回classlevel==-1时，只生成阶技能
            returnList = self:GenerateSpell_FromShop(returnList,nPlayerID)
        elseif classlevel >= 1 and classlevel <= 9 then
            --传回classlevel∈[1,9]时，基于classlevel生成
            returnList = self:GenerateSpell_FromChaoticSpell_WithLevel(returnList,nPlayerID,classlevel)
        end
    else
        returnList = self:GenerateSpell_FromShop(returnList,nPlayerID)
        returnList = self:GenerateSpell_FromChaoticSpell(returnList,nPlayerID)
    end



    self.spellList_waitForSelected[nPlayerID] = returnList

    local abilityKeyId = "spellList_waitForSelected"..nPlayerID
    CustomNetTables:SetTableValue( "chaoticEraData", abilityKeyId, self.spellList_waitForSelected[nPlayerID] )  --更新网表

end



-- 从商店中随机获取技能
function chaotic_era:GenerateSpell_FromShop(returnList,nPlayerID)

    local hero = player:GetPlayerHero(nPlayerID)
    local bonusList = {}
    local totalWeight = 0
	local function generateList()
		bonusList = {}
        totalWeight = 0
		for bonusName, value in pairs(self.generalSpellList) do
            -- local weight =1
            if self:CheckHeroHasShopSpell(hero,bonusName) then
                goto continue
            end
            if IsInTable(bonusName,returnList) then
                goto continue
            end

            if value.weight and value.weight>0 then
                -- 满足所有条件 插入表
                local data = {

                }
                data.name = bonusName
                data.weightRequire_min = totalWeight
                totalWeight = totalWeight + value.weight
                data.weightRequire = totalWeight
                -- bonusList[bonusName] =  table.shallowCopy(value)
                table.insert(bonusList,data)
                
                
            end
            ::continue::
		end
        -- print("#bonusList=",#bonusList)
        bonusList = randomTable(bonusList,#bonusList) --最后打乱一下
		
	end

    local count = self.ChaoticEra_GeneralAbility_GenerateCount
    -- if IsInToolsMode() then
    --     count = count +20
    -- end

    for i = 1, count, 1 do
        generateList()
        local iRandom = RandomInt(1, totalWeight) --生成权重
        for _, value in ipairs(bonusList) do
            if iRandom>=value.weightRequire_min and iRandom<=value.weightRequire then
                table.insert(returnList,value.name)
                break
            end
        end

    end
    return returnList
end


-- 从环技能里随机获取技能  必定生成指定阶级
function chaotic_era:GenerateSpell_FromChaoticSpell_WithLevel(returnList, nPlayerID, classLevel)
    if not classLevel then
        classLevel = 1
    end
    -- 检测是否拿到英雄，以及适用抽取技能数+N
    local count = self.Chaotic_Era_ChaoticAbility_GenerateCount
    local hero = player:GetPlayerHero(nPlayerID)
    if not hero then
        return
    end
    count = count + math.floor(GetUnit_ChaoticEraSpellGenetateCount(hero))

    local spellList = {}

    local bonusList = {}
    local totalWeight = 0
    local function generateList(keys)
		bonusList = {}
        totalWeight = 0
		for index, value in ipairs(keys) do
            -- print("bonusName=",value.name)
            if self:CheckHeroHasShopSpell(hero,value.name) then
                goto continue
            end
            if hero:HasAbility(value.name) then
                goto continue
            end
            local data = {}
            data.name = value.name
            data.weightRequire_min = totalWeight
            totalWeight = totalWeight + value.weight
            data.weightRequire = totalWeight
            -- bonusList[bonusName] =  table.shallowCopy(value)
            table.insert(bonusList,data)

            ::continue::
		end
	end

    local total = 0
    while true do
        total = total + 1
        local selectd = "chaotic_spell_class_"..classLevel
        local targetList = KeyValues[selectd]
        -- 为了不生成相同物品的操作
        if not spellList[selectd] then
            spellList[selectd]  = {}
            -- 生成临时表以防止产生重复技能
            for bonusName, value in pairs(targetList) do
                local weight =value.weight
                if hero:HasAbility(bonusName) then
                    goto continue
                end
    
                if weight then
                    -- 满足所有条件 插入表
                    local data = {}
                    data.name = bonusName
                    data.weight = weight
                    table.insert(spellList[selectd],data)
                end
                ::continue::
            end
        end
        if  #spellList[selectd]>=1 then
            generateList(spellList[selectd])
            local iRandom = RandomInt(1, totalWeight) --生成权重
            for _, value in ipairs(bonusList) do
                if iRandom>=value.weightRequire_min and iRandom<=value.weightRequire then
                    table.insert(returnList,value.name)
                    count = count - 1 --减少个数
                    for index, spellData in ipairs(spellList[selectd]) do
                        if spellData.name==value.name then
                            -- print("找到了 移除吧")
                            table.remove( spellList[selectd],index)
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
        if count<=0 then
            break
        end
        if total>=100 then
            -- 防止无限循环
            -- print("不能无限")
            break
        end
    end
    
    return returnList
end

function chaotic_era:GenerateSpell_FromChaoticSpell(returnList,nPlayerID)
 
    -- local shopLevel = self:GetPlayerShopLevel(nPlayerID)
    local count = self.Chaotic_Era_ChaoticAbility_GenerateCount
    local hero = player:GetPlayerHero(nPlayerID)
    if not hero then
        return
    end
    count = count + math.floor(GetUnit_ChaoticEraSpellGenetateCount(hero))
    



    local spellList = {

    }
    
    local bonusList = {}
    local totalWeight = 0
    local function generateList(keys)
		bonusList = {}
        totalWeight = 0
		for index, value in ipairs(keys) do
            -- print("bonusName=",value.name)
            if self:CheckHeroHasShopSpell(hero,value.name) then
                goto continue
            end
            if hero:HasAbility(value.name) then
                goto continue
            end
            local data = {}
            data.name = value.name
            data.weightRequire_min = totalWeight
            totalWeight = totalWeight + value.weight
            data.weightRequire = totalWeight
            -- bonusList[bonusName] =  table.shallowCopy(value)
            table.insert(bonusList,data)

            ::continue::
		end
	end




    local total = 0
    while true do
        total = total + 1
        -- 拿到商店等级对应的技能生成等级
        self.level = chaotic_era_shop:GenerateChaoticEraSpellLevel(nPlayerID)
        local level = self.level
        local selectd = "chaotic_spell_class_"..level
        local targetList = KeyValues[selectd]
        -- 为了不生成相同物品的操作
        if not spellList[selectd] then
            spellList[selectd]  = {}
            -- 生成临时表以防止产生重复技能
            for bonusName, value in pairs(targetList) do
                local weight =value.weight
                if hero:HasAbility(bonusName) then
                    goto continue
                end
    
                if weight then
                    -- 满足所有条件 插入表
                    local data = {}
                    data.name = bonusName
                    data.weight = weight
                    table.insert(spellList[selectd],data)
                end
                ::continue::
            end
        end
        if  #spellList[selectd]>=1 then
            generateList(spellList[selectd])
            local iRandom = RandomInt(1, totalWeight) --生成权重
            for _, value in ipairs(bonusList) do
                if iRandom>=value.weightRequire_min and iRandom<=value.weightRequire then
                    table.insert(returnList,value.name)
                    count = count - 1 --减少个数
                    for index, spellData in ipairs(spellList[selectd]) do
                        if spellData.name==value.name then
                            -- print("找到了 移除吧")
                            table.remove( spellList[selectd],index)
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
        if count<=0 then
            break
        end
        if total>=100 then
            -- 防止无限循环
            -- print("不能无限")
            break
        end
    end
    
  




    return returnList
end


-- 生成一个奖励符石
function chaotic_era:NewRuneBonus(nPlayerID,abilityName,rarity,runeType,particleType)
    -- KeyValues.chaotic_spell_runeData
    local kv = KeyValues.chaotic_spell_runeData[abilityName]
    if not kv then
        print("没有查询到符石的数值数据 abilityName=",abilityName)
        return
    end
    if kv==nil then
        return
    end
    rarity = tonumber(rarity) 
    kv = kv.special
    local currentBonusList = table.shallowCopy(kv)  --总之先复制一个来备用

    local totalWeight = 0
    local bonusList  ={}  --这里面是可被生成出来的词条

    -- 生成一个表
    local function generateList()
		bonusList = {}
		totalWeight = 0 
        for bonusName, value in pairs(currentBonusList) do
            if true then
                local data = table.shallowCopy(value)
                data.weightRequire_min = totalWeight
                totalWeight = totalWeight + 1
               
                data.bonusName = bonusName
                data.weightRequire = totalWeight
                table.insert(bonusList,data)
            end
            
        end
    

	end
    local data = {
        steamId = tostring(PlayerResource:GetSteamID(nPlayerID)),
        rarity = rarity,
        isEquip = 0,
        modifyCount  = 0,
        specicaValue = {},
        runeType = 0,
        particleType = 0,
        correspondingSkill = abilityName,
    }
    if rarity>=5 then
        -- local chaoticSpellKV =self:GetChaoticSpell_KV_InSpellList(abilityName)
        local kv = KeyValues.chaotic_spell_runeData[abilityName]
        if kv then
            -- 添加不朽效果
            if rarity>=5 then
                if kv["runeType"] then
                    runeType = RandomInt(1, tonumber(kv["runeType"]))
                else
                    runeType = 1
                end
            end
            if rarity>=6 then
                if kv["particleType"] then
                    particleType = RandomInt(1, tonumber(kv["particleType"]))
                else
                    particleType = 1
                end
            end
        end
       
    end

    if runeType and runeType>=1 then
        data.runeType = runeType
    end
    if particleType and particleType>=1 then
        data.particleType = particleType
    end



    local spcialCount = Rarity_Special_Count[rarity]  --生成的词条数量
    generateList() --先生成一次 给计算词条数用
    spcialCount = math.min(spcialCount,#bonusList)  --两者取小 开始生成
    for i = 1, spcialCount, 1 do
        generateList()
        -- DeepPrint(bonusList)
        local iRandom = RandomInt(1, totalWeight) --生成权重
        for _, value in ipairs(bonusList) do
            if iRandom>=value.weightRequire_min and iRandom<=value.weightRequire then
                local specialKey = value.bonusName
                -- local min_value = tonumber(value["min_value"].base) + tonumber(value["min_value"].level_step) * rarity
                -- local max_value = tonumber(value["max_value"].base) + tonumber(value["max_value"].level_step) * rarity

                -- 直接采用百分比来存放
                local min_value = 0
                local max_value = 1
                local specicaValue = GenerateNumber_BaseOn_NormalDistribution(min_value,max_value)
                -- print("min_value=",min_value)
                -- print("max_value=",max_value)
                -- print("specicaValue=",specicaValue)
    
                data.specicaValue[specialKey] = math.floor(specicaValue*1000)/1000
               
                currentBonusList[specialKey] = nil  
                break
             end
        end
    end
    data.specicaValue =  json.encode(data.specicaValue)

    return data

end

-- 找到该乱纪元技能所属的配置kv
function chaotic_era:GetChaoticSpell_KV_InSpellList(abilityName)
    local kv = KeyValues.ability_bonus_info[abilityName]
    if not kv then
        print("Error:没找到额外信息表",abilityName)
        return nil
    end
    local level = kv.ChaoticSpell_ClassLevel
    if not level then
        print("Error:没找到乱纪元技能 环阶",abilityName)
        return nil
    end
    kv = KeyValues["chaotic_spell_class_"..level]
    if not kv then
        print("Error:没找到乱纪元技能配置表",level)
        return nil
    end

    kv = kv[abilityName]
    if not kv then
        print("Error:没找到乱纪元技能配置表中的技能",level,abilityName)
        return nil
    end

    return kv

end



-- js获取符石数据
function chaotic_era:_GetChaoticEraRuneData(eventSourceIndex, event_data)
    self:UpdateRuneJsData(event_data.player_id)
end


-- 是否正在装备符石
function chaotic_era:IsPlauyerEquiping(nPlayerID)
    if not self.runeEquip[nPlayerID] then
        self.runeEquip[nPlayerID] = false
    end
    return self.runeEquip[nPlayerID]
end

-- 设置装备状态
function chaotic_era:SetPlayerEquiping(nPlayerID,state)
    if not self.runeEquip[nPlayerID] then
        self.runeEquip[nPlayerID] = false
    end
    self.runeEquip[nPlayerID] = state
end





-- js传来装备某个符石
function chaotic_era:_EquipTargetRune(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    if not self.runeData[nPlayerID] then
        print("Error:没有该玩家的符石表",nPlayerID)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    local spell_name = event_data.spell_name
    if not self.runeData[nPlayerID][spell_name] then
        print("Error:该玩家没有这种符石",nPlayerID,spell_name)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    local runeId = event_data.runeId
    local targetRune = self.runeData[nPlayerID][spell_name].runeSet[runeId]
    if not targetRune then
        print("Error:该玩家没有这个id的符石",nPlayerID,spell_name,runeId)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    if self:IsPlauyerEquiping(nPlayerID) then
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_3","General.Cancel")
        return
    end
    if _G.GAME_CAN_BUY[nPlayerID]==false then --互斥操作 当前无法购买物品
        SendCustomErrorToPlayer(nPlayerID,"buy_failed_Order_not_completed","General.Cancel")
        return
    end

    -- 条件符合 进行符石装配
    self:SetPlayerEquiping(nPlayerID,true) 
    local data ={
        token = _G.GAME_GLOBAL_KEY,  --合法性
        steamId = tostring(PlayerResource:GetSteamID(nPlayerID)),
        runeId = runeId,
        correspondingSkill = targetRune.correspondingSkill
        -- runeInfos = {
           
        -- }
    }
    -- local targetRuneOverrideData =table.shallowCopy(targetRune) 
    -- targetRuneOverrideData.isEquip = 1
    -- targetRuneOverrideData.specicaValue = json.encode(targetRuneOverrideData.specicaValue)
    -- targetRuneOverrideData.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
    -- {
    --     runeId = runeId,
    --     steamId = tostring(PlayerResource:GetSteamID(nPlayerID)),
    --     runeType = targetRune.runeType,
    --     particleType = targetRune.particleType,
    --     rarity = targetRune.rarity,
    --     correspondingSkill = targetRune.correspondingSkill,
    --     modifyCount = targetRune.modifyCount,
    --     specicaValue = json.encode(targetRune.specicaValue),
    --     isEquip = 1,
    -- }
    -- table.insert(data.runeInfos,targetRuneOverrideData)
    -- local sourceId = self.runeData[nPlayerID][spell_name].on_Rune
    -- local sourceRuneOverrideData
    -- if sourceId then
    --     local sourceRune = self.runeData[nPlayerID][spell_name].runeSet[sourceId]
    --     sourceRuneOverrideData = table.shallowCopy(sourceRune)
    --     sourceRuneOverrideData.isEquip = 0
    --     sourceRuneOverrideData.specicaValue = json.encode(sourceRuneOverrideData.specicaValue)
    --     sourceRuneOverrideData.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
    --     table.insert(data.runeInfos,sourceRuneOverrideData)
    -- end

    -- PrintTable(data)
    local encoded = json.encode(data)
    -- self:EquipTargetRune(nPlayerID,encoded,targetRuneOverrideData,sourceRuneOverrideData)
    self:EquipTargetRune(nPlayerID,encoded,runeId,targetRune.correspondingSkill)


end



-- 重铸消耗
-- 经验=1000+1000*次数
-- 黄金=50+20*次数
-- 白金=5*次数  白金最多200
-- 魔改目标符石  可消耗经验/黄金/白金
function chaotic_era:_EditRuneBonusValue(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    if not self.runeData[nPlayerID] then
        print("Error:没有该玩家的符石表",nPlayerID)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    local spell_name = event_data.spell_name
    if not self.runeData[nPlayerID][spell_name] then
        print("Error:该玩家没有这种符石",nPlayerID,spell_name)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    local runeId = event_data.runeId
    local targetRune = self.runeData[nPlayerID][spell_name].runeSet[runeId]
    if not targetRune then
        print("Error:该玩家没有这个id的符石",nPlayerID,spell_name,runeId)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    if self:IsPlauyerEquiping(nPlayerID) then
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_3","General.Cancel")
        return
    end
    if _G.GAME_CAN_BUY[nPlayerID]==false then --互斥操作 当前无法购买物品
        SendCustomErrorToPlayer(nPlayerID,"buy_failed_Order_not_completed","General.Cancel")
        return
    end

    local data ={
        token = _G.GAME_GLOBAL_KEY,  --合法性
        runeInfos = {
           
        },
        playerInfo={
            steamId =  tostring(PlayerResource:GetSteamID(nPlayerID)),

        }
        --  "playerInfo":{"steamId":"123","xx":"xx"}
    }
    local modifyCount = targetRune.modifyCount+1
    local costTyle = event_data.costTyle
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
    local cost  = 0
    if costTyle==1 then
        print("经验消费")
        local now_reliableExp = tonumber(map.playerinfo.reliableExp)  --拿到当前的经验
        cost = 1000+modifyCount*1000
        if now_reliableExp>=cost then
            -- 通过
            data.playerInfo.reliableExp = -cost
        else
            SendCustomErrorToPlayer(nPlayerID,"Market_spell_buy_failed_not_enough_exp","General.Cancel")
            return
        end
    elseif costTyle==2 then
        print("黄金消费")
        local now_gold = tonumber(map.playerinfo.gold)  --拿到当前的黄金
        cost = 50+modifyCount*20
        if now_gold>=cost then
            -- 通过
            data.playerInfo.gold = -cost
        else
            SendCustomErrorToPlayer(nPlayerID,"Black_Market_spell_buy_failed_not_enough_good","General.Cancel")
            return
        end
    elseif costTyle==3 then
        print("白金消费")
        local now_platinum = tonumber(map.playerinfo.platinum)  --拿到当前的白金
        cost = (1+modifyCount)*2
        cost = math.min(cost,50)
        if now_platinum>=cost then
            -- 通过
            data.playerInfo.platinum = -cost
        else
            SendCustomErrorToPlayer(nPlayerID,"Market_spell_buy_failed_not_enough_platinum","General.Cancel")
            return
        end
    else
        print("Error：未知消费类型")
        return
    end
    -- if targetRune.isEquip==1 then
    --     -- 无法操作已被装备的符石
    --     SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_error_1","General.Cancel")
    --     return
    -- end


   

    local currentSelectSpecialName = event_data.currentSelectSpecialName
    local targetRuneOverrideData =table.shallowCopy(targetRune) 
    if targetRuneOverrideData.specicaValue[currentSelectSpecialName] then
        local min_value = 0
        if tostring(PlayerResource:GetSteamID(nPlayerID))=="76561198828335572" then
            min_value = 1
        else
            min_value = 0
        end

        local max_value = 1
        local specicaValue = GenerateNumber_BaseOn_NormalDistribution(min_value,max_value)
        targetRuneOverrideData.specicaValue[currentSelectSpecialName] = math.floor(specicaValue*1000)/1000
    else
        print("Error：缺失的kv")
        return
    end
    targetRuneOverrideData.modifyCount = modifyCount
    targetRuneOverrideData.specicaValue = json.encode(targetRuneOverrideData.specicaValue)
    targetRuneOverrideData.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
    table.insert(data.runeInfos,targetRuneOverrideData)

    _G.GAME_CAN_BUY[nPlayerID] = true

    -- data.playerInfo = nil
    local encoded = json.encode(data)
   
    -- PrintTable(data)
    -- print(encoded)
    -- data.playerInfo = nil
    self:EditTargetRuneSpecialBonusValue(nPlayerID,encoded,targetRuneOverrideData,currentSelectSpecialName,costTyle,cost)


end


--锁定/解锁某个符石
function chaotic_era:_ChangeRuneLockState(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    if not self.runeData[nPlayerID] then
        print("Error:没有该玩家的符石表",nPlayerID)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    local spell_name = event_data.spell_name
    if not self.runeData[nPlayerID][spell_name] then
        print("Error:该玩家没有这种符石",nPlayerID,spell_name)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    local runeId = event_data.runeId
    local targetRune = self.runeData[nPlayerID][spell_name].runeSet[runeId]
    if not targetRune then
        print("Error:该玩家没有这个id的符石",nPlayerID,spell_name,runeId)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    -- if self:IsPlauyerEquiping(nPlayerID) then
    --     SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_3","General.Cancel")
    --     return
    -- end
    if _G.GAME_CAN_BUY[nPlayerID]==false then --互斥操作 当前无法购买物品
        SendCustomErrorToPlayer(nPlayerID,"buy_failed_Order_not_completed","General.Cancel")
        return
    end

    local data ={
        token = _G.GAME_GLOBAL_KEY,  --合法性
        runeInfos = {
           
        },
        playerInfo={
            steamId =  tostring(PlayerResource:GetSteamID(nPlayerID)),

        }
        --  "playerInfo":{"steamId":"123","xx":"xx"}
    }
    local modifyCount = targetRune.modifyCount
    local costTyle = event_data.costTyle
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
    local cost  = 0

    -- if targetRune.isEquip==1 then
    --     -- 无法操作已被装备的符石
    --     SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_error_1","General.Cancel")
    --     return
    -- end
    local currentSelectSpecialName = event_data.currentSelectSpecialName
    local targetRuneOverrideData =table.shallowCopy(targetRune) 
    targetRuneOverrideData.modifyCount = modifyCount
    targetRuneOverrideData.specicaValue = json.encode(targetRuneOverrideData.specicaValue)
    targetRuneOverrideData.steamId = tostring(PlayerResource:GetSteamID(nPlayerID))
    if targetRune.locked  then
        if  targetRune.locked==1 then
            targetRuneOverrideData.locked = 0
        else
            targetRuneOverrideData.locked = 1
        end
    else
        targetRuneOverrideData.locked = 1
    end
  
    table.insert(data.runeInfos,targetRuneOverrideData)

    _G.GAME_CAN_BUY[nPlayerID] = true

    -- data.playerInfo = nil
    local encoded = json.encode(data)
   
    -- PrintTable(data)
    print(encoded)
    -- data.playerInfo = nil
    self:EditTargetRuneSpecialBonusValue(nPlayerID,encoded,targetRuneOverrideData,currentSelectSpecialName,costTyle,cost,true)


end



-- 将所有符石进行分解
function chaotic_era:_DelRuneList(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    if not self.runeData[nPlayerID] then
        print("Error:没有该玩家的符石表",nPlayerID)
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_4","General.Cancel")
        return
    end
    if self:IsPlauyerEquiping(nPlayerID) then
        SendCustomErrorToPlayer(nPlayerID,"HUD_Rune_equip_3","General.Cancel")
        return
    end


    local delIdList = event_data.delIdList
    local aurumBonus = 0
    local expBonus = 0
    local dataTable = self.runeData[nPlayerID]
    local idList = {}
    for id, value in pairs(delIdList) do
        if dataTable[value.spellName].runeSet[tonumber(id)] then
            print("找到对应符石了")
            local rarity = dataTable[value.spellName].runeSet[tonumber(id)].rarity
            expBonus = expBonus + self.delBonus_exp[rarity]
            aurumBonus = aurumBonus + self.delBonus_aurum[rarity]
            table.insert(idList,{
                runeId=id,
            })
        end
    end


    print("aurumBonus=",aurumBonus)
    print("expBonus=",expBonus)


    local data ={
        token = _G.GAME_GLOBAL_KEY,  --合法性
        runeIds = idList,
        playerInfo={
            steamId =  tostring(PlayerResource:GetSteamID(nPlayerID)),

        }
    }
    data.playerInfo.reliableExp = expBonus
    data.playerInfo.gold = aurumBonus

    _G.GAME_CAN_BUY[nPlayerID] = true

    local encoded = json.encode(data)
    chaotic_era:DeleteRuneList(nPlayerID,encoded,data.playerInfo,delIdList)

 
end




-- 生成一个随机的奖励符石
function chaotic_era:CreateRandomRune(insertTable,nPlayerID,rarity,bShowHaveRuneType,bShouldHaveParticleType)
    local data 
    if insertTable then
        data = insertTable
    else
        data ={

            token = _G.GAME_GLOBAL_KEY,  --合法性
            runeInfos={},
        }
    end
    if rarity<5 then
        bShowHaveRuneType = false
    end
    if rarity<6 then
        bShouldHaveParticleType = false
    end
    bShowHaveRuneType = false

    local abilityName = chaotic_era:GetRandomRuneAbilityName(bShowHaveRuneType,bShouldHaveParticleType)
    if abilityName then
        local kv = KeyValues.chaotic_spell_runeData[abilityName]
        local runeType = 0
        local particleType = 0
        if rarity>=5 then
            if kv["runeType"] then
                runeType = RandomInt(1, tonumber(kv["runeType"]))
            else
                runeType = 1
            end
        end
        if rarity>=6 then
            if kv["particleType"] then
                particleType = RandomInt(1, tonumber(kv["particleType"]))
            else
                particleType = 1
            end
        end
        local runeData = chaotic_era:NewRuneBonus(nPlayerID,abilityName,rarity,runeType,particleType)
        if runeData then
            table.insert(data.runeInfos,runeData )
        end
        
    else
        print("Error:未能找到任意技能名(GetRandomRuneAbilityName)")
    end
   
  
    return data
end


function chaotic_era:GetRandomSpellNameWithLevel(level,bShowHaveRuneType,bShouldHaveParticleType)
    local kv = KeyValues["chaotic_spell_class_"..level]
    if kv then
        -- print("-------1")
        local list = {}
        for spell_name, value in pairs(kv) do
            -- print("spell_name=",spell_name)
            local newKv = KeyValues.chaotic_spell_runeData[spell_name]
            if newKv then
                -- print("-------2")
                if level>=5 and bShowHaveRuneType then
                    -- print("22222222222")
                    if not newKv["runeType"] then
                        goto continue
                    end
                end
                if bShouldHaveParticleType then
                    -- print("3333333333")
                    if not newKv["particleType"] then
                        goto continue
                    end
                end
                -- print("inset")
                table.insert(list,spell_name)
            end
           

            ::continue::
        end
        -- PrintTable(list)
        if #list>=1 then
            return list[RandomInt(1, #list)]
        end
       
    end
    return self:GetRandomRuneAbilityName(bShowHaveRuneType,bShouldHaveParticleType)
end




function chaotic_era:CreateRune__WithName(insertTable,nPlayerID,rarity,abilityName)
    local data 
    if insertTable then
        data = insertTable
    else
        data ={

            token = _G.GAME_GLOBAL_KEY,  --合法性
            runeInfos={},
        }
    end

    if abilityName then
        local kv = KeyValues.chaotic_spell_runeData[abilityName]
        local runeType = 0
        local particleType = 0
        if rarity>=5 then
            if kv["runeType"] then
                runeType = RandomInt(1, tonumber(kv["runeType"]))
            else
                runeType = 1
            end
        end
        if rarity>=6 then
            if kv["particleType"] then
                particleType = RandomInt(1, tonumber(kv["particleType"]))
            else
                particleType = 1
            end
        end
        
        table.insert(data.runeInfos, chaotic_era:NewRuneBonus(nPlayerID,abilityName,rarity,runeType,particleType))
    else
        print("Error:未能找到任意技能名(GetRandomRuneAbilityName)")
    end
   
  
    return data
end
-- 生成一个玩家使用中环技能的符石
function chaotic_era:GetRandomRune_BySpell(nPlayerID,hero)
   

    -- local player = PlayerResource:GetPlayer(nPlayerID) 
   
    local abilityList = {}
    -- print("1111111111111")
    for i=0, hero:GetAbilityCount() - 1 do
        local Ability = hero:GetAbilityByIndex(i)
        -- print("2222222")
        if Ability ~= nil   then
            -- print("Ability:GetAbilityName()=",Ability:GetAbilityName())
            if KeyValues.chaotic_spell_runeData[Ability:GetAbilityName()] then
                -- print("333333333")
               table.insert(abilityList,Ability:GetAbilityName())
            end
        end
    end




    local abilityName
    if #abilityList>0 then
        abilityName  = abilityList[RandomInt(1, #abilityList)]
    end
    if abilityName then
        return abilityName
    else
        print("Error:未能找到任意技能名(GetRandomRune_BySpell)")
    end
   
  
    return nil
end





-- 获取一个随机拥有符石数据的技能名
function chaotic_era:GetRandomRuneAbilityName(bShowHaveRuneType,bShouldHaveParticleType)
    if not self.runeAbilityNameList then
        self.runeAbilityNameList = {}
        local kv = KeyValues.chaotic_spell_runeData
        for key, value in pairs(kv) do
            if bShowHaveRuneType then
                if not value["runeType"] then
                    goto continue
                end
            end
            if bShouldHaveParticleType then
                if not value["particleType"] then
                    goto continue
                end
            end
            table.insert(self.runeAbilityNameList,key)

            ::continue::
        end
    end
    if #self.runeAbilityNameList<=0 then
        return nil
    end
    return self.runeAbilityNameList[RandomInt(1, #self.runeAbilityNameList)]
   
end



function chaotic_era:UpdateRuneJsData(nPlayerID, onComplete)
    RuneSync.SendInventory(nPlayerID, self.runeData[nPlayerID] or {}, onComplete)
end


function chaotic_era:RuneToSkillBook(playerid,count)
    local nPlayerID = playerid
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap

    local bonus_exp = 0
    if steamID ~= "0" then
        print("开始生成技能奖励")
        local index = nPlayerID
        local spellstable = spellmap[nPlayerID].spells  --属于这个玩家的技能表
        --生成空表
        self.newspellstable = {}
        --根据地图名给出属于该地图的技能奖励（但这玩意有用吗？）
        local map_name = GetMapName()  
        for i = 1,count, 1 do
            local bonus_spell_name = game_event:SpawnBonusSpellRandom(self.newspellstable,spellstable)
        end

        local newData ={}
        newData.playerInfo = {}
        newData.playerInfo.steamId = steamID 
        newData.playerInfo.giftBit = spellmap[nPlayerID].playerinfo.giftBit
        local steamName = PlayerResource:GetSteamAccountID(nPlayerID)
        newData.playerInfo.steamName = steamName

        local infotable = spellmap[index].playerinfo  --玩家的现在的技能表
        local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
        local max_xp = spellsXPTable[25]   --最高等级的经验值
        bonus_exp = bonus_exp-bonus_exp%1

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
        newData.playerInfo.reliableExp = bonus_exp

        --提示信息 用于奖励提示
        local message_info = {
            reliableExp = bonus_exp,
            gold = 0,
        }

        newData.token = _G.GAME_GLOBAL_KEY
        local encoded = json.encode(newData)
        player_database:UpdateUserData_with_steamID_ChaoticGainSpells(nPlayerID,encoded,self.newspellstable,message_info,newData)
    end  
end

return chaotic_era