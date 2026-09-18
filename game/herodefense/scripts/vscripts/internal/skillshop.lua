require("internal/timers")

skillshop = skillshop or class({})

print("skillshop load....")
-- 技能不计入数量计算
local hideAbility = {
    ["Primary_Converge"] = true,
    ["Primary_Unstable_Concoction_Throw"] = true,
    ["Primary_tether_break"] = true,
    ["Middle_Converge"] = true,
    ["Middle_Unstable_Concoction_Throw"] = true,
    ["Middle_tether_break"] = true,
    ["Advanced_Converge"] = true,
    ["Advanced_Unstable_Concoction_Throw"] = true,
    ["Advanced_tether_break"] = true,
    ["unit_state"] = true,
    };



    
_G.need_to_swap_hideAbility = {
    ["Primary_Converge"] = true,
    ["Primary_Unstable_Concoction_Throw"] = true,
    ["Primary_tether_break"] = true,
    ["Middle_Converge"] = true,
    ["Middle_Unstable_Concoction_Throw"] = true,
    ["Middle_tether_break"] = true,
    ["Advanced_Converge"] = true,
    ["Advanced_Unstable_Concoction_Throw"] = true,
    ["Advanced_tether_break"] = true,
  

};

--获取当前技能数量 忽略上表的不计数
function skillshop:GetPlayerAbilityNumber(playerHero)
    local abilityNumber = 0
    for i = 0, playerHero:GetAbilityCount() - 1 do
        local ability = playerHero:GetAbilityByIndex(i)
        if ability ~= nil then
            local abilityName = ability:GetAbilityName()
            if need_to_swap_hideAbility[abilityName] ~= true 
            and hideAbility[abilityName] ~= true 
            and not string.match(abilityName, "special_bonus_") 
            and not string.match(abilityName, "custom_bonus_") 
            and not string.match(abilityName, "attack_triggers") 
            and not string.match(abilityName, "heroTalent")  
            then
                abilityNumber = abilityNumber + 1
            end

        end
    end
    return abilityNumber
end

function skillshop:GetPlayerGeneralAbilityNumber(playerHero)
    local abilityNumber = 0
    for i = 0, playerHero:GetAbilityCount() - 1 do
        local ability = playerHero:GetAbilityByIndex(i)
        if ability ~= nil then
            local abilityName = ability:GetAbilityName()
            if need_to_swap_hideAbility[abilityName] ~= true and hideAbility[abilityName] ~= true then
                if  string.match(abilityName, "Primary_") or string.match(abilityName, "Middle_") or string.match(abilityName, "Advanced_")  then
                    abilityNumber = abilityNumber + 1
                end
            end

            -- local abilityKV = skillshop:FindAbilityShopKV(abilityName)
          
            

        end
    end
    return abilityNumber
end




function skillshop:GetMaxSpellCount(playerHero)
    local maxSlotNumber = 8
    --获取增大技能数量的modifier
    if playerHero:HasModifier("modifier_heroTalent_npc_dota_hero_invoker") or _G.Fortunes_end_unlock3 then
        maxSlotNumber = maxSlotNumber + 1
    end
    if playerHero:HasModifier("modifier_item_hd_rubick_cube_active") then
        maxSlotNumber = maxSlotNumber + 1
    end
    return maxSlotNumber
end

function skillshop:init(bReload)
    
    CustomUIEvent("spells_menu_buy_spell", Dynamic_Wrap(self, "_SpellsMenuBuySpell"), self)
    CustomUIEvent("spells_menu_get_player_spells", Dynamic_Wrap(self, "_SpellsMenuGetSpells"), self)
    CustomUIEvent("spells_menu_get_player_spells_by_classlevel", Dynamic_Wrap(self, "_SpellsMenuGetSpells_by_classlevel"), self)  --调用获取可升阶的技能列表
    CustomUIEvent("Sellspells_menu_get_player_spells_by_classlevel", Dynamic_Wrap(self, "_SellSpellsMenuGetSpells_by_classlevel"), self) --调用获取可以出售的技能列表
    CustomUIEvent("spells_menu_Upgrade_player_spells", Dynamic_Wrap(self, "_SpellsMenuUpgradeAbilities"), self)  --收到升级技能的请求
    CustomUIEvent("spells_menu_Upgrade_player_spells_max", Dynamic_Wrap(self, "_SpellsMenuUpgradeAbilities_lv5"), self)
    CustomUIEvent("spells_menu_sell_player_spells", Dynamic_Wrap(self, "_SpellsMenuSellAbilities"), self)
    CustomUIEvent("spells_menu_swap_player_spells", Dynamic_Wrap(self, "_SpellsMenuSwapAbilitiesPosition"), self)
    CustomUIEvent("UnlockSpellMystery", Dynamic_Wrap(self, "_UnlockSpellMystery"), self)
    CustomUIEvent("AbilityNoteOnUiLoad", Dynamic_Wrap(self, "_AbilityNoteOnUiLoad"), self)



    ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( skillshop, "OnPlayerLearnSpell" ), self )  --监听聊天信息输入
end


function skillshop:OnPlayerLearnSpell(keys)
    local nPlayerID = keys.PlayerID
    local player = PlayerResource:GetPlayer(nPlayerID)
    if player and PlayerResource:HasSelectedHero(nPlayerID) then
        local playerHero = player:GetAssignedHero()
        self:HeroUpgradeAbility(nPlayerID,playerHero)

    end
end

-- UI重载时需要去获取一下
function skillshop:_AbilityNoteOnUiLoad(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if player and PlayerResource:HasSelectedHero(nPlayerID) then
        local playerHero = player:GetAssignedHero()
        self:HeroUpgradeAbility(nPlayerID,playerHero)
    end
end


function skillshop:HeroUpgradeAbility(nPlayerID,playerHero)
    Timers:CreateTimer(0.06, function()
        local data = self:CheckSpellUpdgrate(nPlayerID,playerHero)
        if data then
            local NetTable_key = "playerUpgrade_"..nPlayerID
            CustomNetTables:SetTableValue( "game_data", NetTable_key, data )
            -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "OnSpellLearn", { player_abilities = data })
        else
            -- CustomNetTables:SetTableValue( "game_data", NetTable_key, {} )
            print("没有数据")
        end
    end)

   
end
function skillshop:CheckSpellUpdgrate(nPlayerID,playerHero)
    local maxAbilities = playerHero:GetAbilityCount() - 1

    local playerAbilities = {}
    local abilitiesCost = {}
    local nextAbilityName = {}

    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    local playerSteamID= tostring(PlayerResource:GetSteamID(nPlayerID))
    local index = nPlayerID
    if spellmap[index].steamID~=playerSteamID then
        return  
    end
    local spellstable = spellmap[index].spells
    local spellxpmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable
    local freeSpellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.freeSpellMap
    for ability_id = 0, maxAbilities do
        local ability = playerHero:GetAbilityByIndex(ability_id)
        -- Make sure it is not a talent and there is level
        if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
        -- if ability and not ability:IsAttributeBonus() then
            local ability_level = ability.classlevel

            if ability_level then
                ---低阶且满级的情况下
                if ability_level==1 and ability:GetLevel()==5 then
                     local abilityName = ability:GetAbilityName()
                     local cost = ability.to_level2_cost
                     table.insert(abilitiesCost, cost)
                     table.insert(playerAbilities, abilityName)
                     table.insert(nextAbilityName, ability.level2_id)
                end
                ---中阶且满级的情况下
                if ability_level==2 and ability:GetLevel()==3 then
                    -- 需要你解锁了高阶技能书
                   
                    --现在我们拿到了位置后就该判断是不是有这个技能书了
                    local spellsname = ability.level3_id
                    local freeSpellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.freeSpellMap
                    local pass = true
                    if not spellstable[spellsname] and not _G.GAME_debugTesting then  --表里没有这个技能 那就直接返回吧
                        if not freeSpellMap[spellsname] then
                            pass = false
                            return   
                        end
                        
                    end
                    if pass then
                        local abilityName = ability:GetAbilityName()
                        local cost = ability.to_level3_cost
                        table.insert(abilitiesCost, cost)
                        table.insert(playerAbilities, abilityName)
                        table.insert(nextAbilityName, ability.level3_id)
                    end


                end
                --高阶
                if ability_level==3 and ability.advanced_level<25 then
                    local spellsname = ability:GetAbilityName()
                    local nowxp = tonumber(spellstable[spellsname] ) --目前的经验值
                    local need_xp = spellxpmap[ability.advanced_level+1]
                    local pass = true
                    if (not nowxp or need_xp>nowxp ) and not _G.GAME_debugTesting then  --经验不足以升级
                        if not freeSpellMap[spellsname] or ability.advanced_level>=10 then  --如果没有免费技能效果 或者超过10级
                            pass = false
                            return
                        end
                  
                    end
                    if pass then
                        local cost = ability.upgrade_cost
                        table.insert(abilitiesCost, cost)
                        local abilityName = ability:GetAbilityName()
                        table.insert(playerAbilities, abilityName)
                        table.insert(nextAbilityName, abilityName)
                    end


                  

                end
            end
            
        end
    end
    local abilitytable = {}
    table.insert(abilitytable, playerAbilities)  --技能
    table.insert(abilitytable, abilitiesCost)  --花费
    table.insert(abilitytable, nextAbilityName)  --下一个技能

    return abilitytable
end







function skillshop:_SpellsMenuGetSpells(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local playerAbilities = self:_GetPlayerSpells(nPlayerID)

    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_get_player_spells_feedback", { player_abilities = playerAbilities })
end

-- 获取技能
function skillshop:_GetPlayerSpells(nPlayerID)
    local player = PlayerResource:GetPlayer(nPlayerID)
    if player and PlayerResource:HasSelectedHero(nPlayerID) then
        local playerHero = player:GetAssignedHero()
        if not playerHero then
            return {}
        end
        local maxAbilities = playerHero:GetAbilityCount() - 1

        local playerAbilities = {}

        for ability_id = 0, maxAbilities do
            local ability = playerHero:GetAbilityByIndex(ability_id)
            -- Make sure it is not a talent and there is level
            if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
            -- if ability and not ability:IsAttributeBonus() then
                local abilityName = ability:GetAbilityName()
                table.insert(playerAbilities, abilityName)
            end
        end
        return playerAbilities
    end

    return {}
end


-- 出售技能
function skillshop:_SellAbilities(eventSourceIndex, SellAbilityName)
    local nPlayerID = event_data.player_id
    local abilityName = event_data.SellAbilityName
    local abilityCost = event_data.cost
    local associatedAbilities = event_data.associated_spells
    local associatedLearnables = event_data.associated_learnables

    if PlayerResource:HasSelectedHero(nPlayerID) then
        local player = PlayerResource:GetPlayer(nPlayerID)
        local playerHero = player:GetAssignedHero()


        if playerHero:HasAbility(abilityName) then

            local existingAbility = playerHero:FindAbilityByName(abilityName)

            playerHero:RemoveAbilityByHandle(existingAbility)
            if associatedAbilities then
                -- Remove associated abilities
                for _, associatedAbilityName in pairs(associatedAbilities) do
                    playerHero:RemoveAbility(associatedAbilityName)
                end
            end
            if associatedLearnables then
                -- Remove associated learnables
                for _, associatedLearnableName in pairs(associatedLearnables) do
                    -- refund points
                    local learnableAbility = playerHero:FindAbilityByName(associatedLearnableName)
                    playerHero:RemoveAbilityByHandle(learnableAbility)
                end
            end
            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Spells_Menu_Successful_Refund","General.Cancel")
            CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_spell_feedback", { }) -- Close the menu
        end
    end
end

function skillshop:_SpellsMenuSwapAbilitiesPosition(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local firstAbilityName = event_data.first_ability_name
    local secondAbilityName = event_data.second_ability_name
    local player = PlayerResource:GetPlayer(nPlayerID)
    local playerHero = player:GetAssignedHero()
    playerHero:EmitSound("Hero_VengefulSpirit.NetherSwap")
    self:_SwapAbilitiesPosition(nPlayerID, firstAbilityName, secondAbilityName)
    

    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_swap_player_spells_feedback", { })

    self:HeroUpgradeAbility(nPlayerID,playerHero)
end

function skillshop:_SwapAbilitiesPosition(nPlayerID, firstAbilityName, secondAbilityName)
    local player = PlayerResource:GetPlayer(nPlayerID)
    local playerHero = player:GetAssignedHero()
    local firstAbility = playerHero:FindAbilityByName(firstAbilityName)
    local secondAbility = playerHero:FindAbilityByName(secondAbilityName)
    --不能切换位移技
    if firstAbilityName == "Default_Move" or secondAbilityName == "Default_Move"  then
        return
    end

    if firstAbility and secondAbility then
        playerHero:SwapAbilities(firstAbilityName, secondAbilityName, not firstAbility:IsHidden(), not secondAbility:IsHidden())
        if firstAbility:IsHidden() then
            --print("V社给你隐藏了，但我给你整回来了诶嘿"..firstAbilityName)
            firstAbility:SetHidden(false)
        end
        if secondAbility:IsHidden() then
            --print("V社给你隐藏了，但我给你整回来了诶嘿"..secondAbilityName)
            secondAbility:SetHidden(false)
        end
        -- 这个东西会导致卡死
        -- CustomGameEventManager:Send_ServerToPlayer(player, "dota_ability_changed", { entityIndex = playerHero })
    end
end


_G.SpellShopKV = {
    "spell_shop_physical",
    "spell_shop_magical",
    "spell_shop_summon",
    "spell_shop_defense",
    "spell_shop_assist",
    "spell_shop_other",

}

-- 购买技能
function skillshop:_SpellsMenuBuySpell(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    


    local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

    
    if not hero then
        return
    end

    if _G.Selected_Difficulty_index<=0 then
        SendCustomErrorToPlayer(hero:GetPlayerOwnerID(),"HUD_LERAN_SPELL_FAIL_Before_DifficultySelected","General.Cancel")      
        return
    end
    --这里是禁止在乱纪元模式下直接购买技能
    if Game_State:IsInChaoticEra() and event_data.spellName~="for_swap_spells" then
        SendCustomErrorToPlayer(hero:GetPlayerOwnerID(),"HUD_LERAN_SPELL_FAIL_Chaotic_Era","General.Cancel")      
        return
    end
    if not event_data.spellclass then
        print("Error：未知的技能类型00 event_data.spellclass=")
        return
    end

    local targetType = SpellShopKV[event_data.spellclass+1]
    if not targetType then
        print("Error：未知的技能类型 event_data.spellclass=",event_data.spellclass)
        return
    end
    local abilityKV = KeyValues[targetType][event_data.spellName]
    if not abilityKV then
        print("Error：未知的技能 event_data.spellName=",event_data.spellName)
        return
    end

    local abilityCost = abilityKV.cost
    

	local heroname = PlayerResource:GetSelectedHeroName(nPlayerID)
    local gold = hero:GetGold()
	-- if abilityCost >= gold then
	-- 	return
	-- end
    local abilityName = event_data.spellName

	
 

    if PlayerResource:HasSelectedHero(nPlayerID) then
        local player = PlayerResource:GetPlayer(nPlayerID)
        local playerHero = player:GetAssignedHero()

        local ability_1_Name =abilityName
        local ability_2_Name = abilityKV.level2_id
        local ability_3_Name = abilityKV.level3_id
        local haveability = false

        if playerHero:HasAbility(ability_1_Name) or playerHero:HasAbility(ability_2_Name) or playerHero:HasAbility(ability_3_Name) then
            haveability = true  --说明已经有这个类的技能了
        end

        if haveability == true then   --删除技能

            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Spells_Menu_Not_Sell","General.Cancel")
            hero:EmitSound("General.Cancel")
            return
        else   --判断金币

            -- 最大技能槽
            local maxSlotNumber = skillshop:GetMaxSpellCount(playerHero)

            print("your max spell:"..maxSlotNumber)
            print("your now spell:"..skillshop:GetPlayerAbilityNumber(playerHero))
            if not playerHero:IsAlive() then
                SendCustomErrorToPlayer(playerHero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_1","General.Cancel")
                playerHero:EmitSound("General.Cancel")
                return
            end
            if skillshop:GetPlayerAbilityNumber(playerHero) >= maxSlotNumber and ability_1_Name~="for_swap_spells" then
                SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Spells_Menu_Not_Enough_Slot","General.Cancel")
            else

                if gold >= abilityCost and hero:IsAlive() then  --学习技能
                    
           
                        local newAbility = playerHero:AddAbility(abilityName)

                        CustomGameEventManager:Send_ServerToPlayer(player, "dota_player_learned_ability", { player = player, abilityname = abilityName })
                        hero:ModifyGoldFiltered(-abilityCost,true,DOTA_ModifyGold_PurchaseItem)  --金币奖励
        
                        newAbility:SetLevel(1)
                        --被动技能自动靠后
                        if newAbility:IsPassive() then
                            PassiveAbilitySwap(playerHero,abilityName) 
                        end
         
                        local level2_cost = abilityKV.to_level2_cost
                        local level3_cost = abilityKV.to_level3_cost
                        local upgrade_cost = abilityKV.upgrade_cost
                        if playerHero:HasModifier("modifier_heroTalent_npc_dota_hero_enchantress") then
                            level2_cost = level2_cost * 0.8
                            level3_cost = level3_cost * 0.8
                            upgrade_cost = upgrade_cost * 0.8
                        end
                        --设置基础信息
                        -- 上古时期用了这种办法  虽然不能说最好 但是简单    （并且某些天赋可以改变这些值）
                        newAbility.classlevel = 1
                        newAbility.level1_id = ability_1_Name
                        newAbility.level2_id = ability_2_Name
                        newAbility.level3_id = ability_3_Name
                        newAbility.to_level2_cost = level2_cost
                        newAbility.to_level3_cost = level3_cost
                        newAbility.upgrade_cost = upgrade_cost
                        newAbility.totalcost = abilityCost
         


                        local associatedAbilities = abilityKV.associated_spells
                        local associatedAbility_entity
                        if associatedAbilities then  --如果有副技能 再添加几个信息
                            -- print("1111111111111111")
                            -- Add associated abilities
                            associatedAbility_entity = playerHero:AddAbility(associatedAbilities)
                            if need_to_swap_hideAbility[associatedAbilities] == true then  --说明这是一个需要隐藏的技能 放到后面去
                                PassiveAbilitySwapHiden(playerHero,associatedAbilities)
                            end
                            -- print("2222222222222222")
                            associatedAbility_entity.subSpell = true --用于判断副技能
                            associatedAbility_entity:SetLevel(1)
                            newAbility.now_associatedAbility = associatedAbilities                     --现在的副技能
                            newAbility.level2_associatedAbility = abilityKV.level2_associated_spells  --中阶的副技能
                            newAbility.level3_associatedAbility = abilityKV.level3_associated_spells  --高阶的副技能
                            -- print("3333333333333333")

                        end
                        local keys = {
                            unit = playerHero,
                            ability = newAbility,
                            associatedAbility = associatedAbility_entity,
                            cost = abilityCost,
                            bIsGeneralSpell = true,
                            bIsChaoticEraSpell = false,
                            bIsTalent = false,
                            isUpgrade = false,
                            IsEvolve = false,
                            isBuy = true,
                        }
                        FireSpellLearnEvent(keys)
    
                        
                        -- Deduct card points
                        local gameEvent = {}
                        gameEvent["player_id"] = nPlayerID
                        gameEvent["teamnumber"] = -1
                        gameEvent["ability_name"] = abilityName
                        gameEvent["message"] = "#Spells_Menu_PurchaseNewAbility"
                        FireGameEvent( "dota_combat_event_message", gameEvent )
                        hero:EmitSound("General.Buy")


                        local keys = {}
                        keys.PlayerID = nPlayerID


                        self:OnPlayerLearnSpell(keys)

                else  
                    SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
                    hero:EmitSound("General.Cancel")
                end
            end
        end

         -- 这个东西会导致卡死
        -- CustomGameEventManager:Send_ServerToPlayer(player, "dota_ability_changed", { entityIndex = playerHero })
    end
end






function skillshop:LearnTalentDefaultAbility(unit,name,costKeys,associatedAbilities)
    local playerId = unit:GetPlayerOwnerID()
    local playerHero = unit

    local ability_1_Name ="Primary_"..name
    local ability_2_Name ="Middle_"..name
    local ability_3_Name = "Advanced_"..name
 
    if playerHero:HasAbility(ability_1_Name) or playerHero:HasAbility(ability_2_Name) or playerHero:HasAbility(ability_3_Name) then
        -- playerHero:SetAbilityPoints(playerHero:GetAbilityPoints()+2)
        playerHero:ModifyGoldFiltered(costKeys.baseCost,true,DOTA_ModifyGold_CreepKill )  --金币奖励
        SendOverheadEventMessage(playerHero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,playerHero, costKeys.baseCost, nil)
        return
    else
        local maxSlotNumber = skillshop:GetMaxSpellCount(playerHero)

        print("your max spell:"..maxSlotNumber)
        print("your now spell:"..skillshop:GetPlayerAbilityNumber(playerHero))
        if skillshop:GetPlayerAbilityNumber(playerHero) >= maxSlotNumber then
            SendCustomErrorToPlayer(playerId,"DOTA_HUD_Spells_Menu_Not_Enough_Slot","General.Cancel")
            playerHero:ModifyGoldFiltered(costKeys.baseCost,true,DOTA_ModifyGold_CreepKill )  --金币奖励
            SendOverheadEventMessage(playerHero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,playerHero, costKeys.baseCost, nil)
        else
            local newAbility = playerHero:AddAbility(ability_1_Name)
            newAbility:SetLevel(1)
            --被动技能自动靠后
            if newAbility:IsPassive() then
                PassiveAbilitySwap(playerHero,ability_1_Name) 
            end

            if associatedAbilities then  --如果有副技能 再添加几个信息
                local associatedAbilities_1_Name ="Primary_"..associatedAbilities
                local associatedAbilities_2_Name ="Middle_"..associatedAbilities
                local associatedAbilities_3_Name = "Advanced_"..associatedAbilities


                local associatedAbility_entity = playerHero:AddAbility(associatedAbilities_1_Name)
                if need_to_swap_hideAbility[associatedAbilities_1_Name] == true then  --说明这是一个需要隐藏的技能 放到后面去
                    PassiveAbilitySwapHiden(playerHero,associatedAbilities_1_Name)
                end
                -- print("2222222222222222")
                associatedAbility_entity.subSpell = true --用于判断副技能
                associatedAbility_entity:SetLevel(1)
                newAbility.now_associatedAbility = associatedAbilities_1_Name                     --现在的副技能
                newAbility.level2_associatedAbility = associatedAbilities_2_Name  --中阶的副技能
                newAbility.level3_associatedAbility = associatedAbilities_3_Name  --高阶的副技能
                -- print("3333333333333333")

            end

            



            --设置基础信息
            newAbility.classlevel = 1
            newAbility.level1_id = ability_1_Name
            newAbility.level2_id = ability_2_Name
            newAbility.level3_id =ability_3_Name
            newAbility.to_level2_cost = costKeys.to_level2_cost
            newAbility.to_level3_cost = costKeys.to_level3_cost
            newAbility.upgrade_cost = costKeys.upgrade_cost
            newAbility.totalcost = costKeys.baseCost

            local keys = {
                unit = playerHero,
                ability = newAbility,
                -- associatedAbility = associatedAbility_entity,
                cost = 0,
                bIsGeneralSpell = false,
                bIsChaoticEraSpell = false,
                bIsTalent = true,
                isUpgrade = false,
                IsEvolve = false,
                isBuy = false,
            }
            FireSpellLearnEvent(keys)

        end
      
    end



end









function PassiveAbilitySwap(playerHero,abilityName) 
    -- if true then
    --     --因为有绑定功能 不再需要这个了
    --     return
    -- end
    for i=6,23 do
        local ability = playerHero:GetAbilityByIndex(i)
        if not ability then
            -- if IsServer() then
            --     -- playerHero:SetAbilityByIndex(newAbility,i) 
            --     -- playerHero:RemoveAbilityByHandle(playerHero:GetAbilityByIndex(index) )
            -- end
            local number = 0
            --获取前面有多少个技能
            -- 0-6 应该为主动技能 共七个  获取到技能数量（当然现在这个被动技能包含在里面）
            --假设是第七个技能了 那么 number = 7
            --此时 10-7=3  添加三个技能后 那么index=9
            --此时再添加一个换位技能 
            --两个技能换位 那么被动就到后面去了
            --删除所有占位技能 
            for i= 0,9 do
                local ability = playerHero:GetAbilityByIndex(i)
                if ability then
                    number = number + 1
                end
            end
            --计算出需要添加几个空技能
            number = 10 -  number
            for i = 1, number do
                playerHero:AddAbility("none_spell_001")
            end
            local abilitySwap = playerHero:AddAbility("none_spell_002")

            local ability_remove_hidden = false
            local ability = playerHero:FindAbilityByName(abilityName)
            if IsValid(ability) and not ability:IsHidden() then --技能存在并且不是本身就被隐藏起来的
                ability_remove_hidden = true
            end

            playerHero:SwapAbilities(abilityName, "none_spell_002", true, true)

            if ability_remove_hidden then
                ability:SetHidden(false)
            end
            
            
            --此时成功换位成功
            print('i='..i) 
            for i = 1, number do
                playerHero:RemoveAbility("none_spell_001")
            end
            playerHero:RemoveAbility("none_spell_002")
            --删掉占位技能
            break
        end
    end
end
function PassiveAbilitySwapHiden(playerHero,abilityName) --适用与隐藏这个技能
    for i=6,23 do
        local ability = playerHero:GetAbilityByIndex(i)
        if not ability then
            -- if IsServer() then
            --     -- playerHero:SetAbilityByIndex(newAbility,i) 
            --     -- playerHero:RemoveAbilityByHandle(playerHero:GetAbilityByIndex(index) )
            -- end
            local number = 0
            --获取前面有多少个技能
            -- 0-6 应该为主动技能 共七个  获取到技能数量（当然现在这个被动技能包含在里面）
            --假设是第七个技能了 那么 number = 7
            --此时 10-7=3  添加三个技能后 那么index=9
            --此时再添加一个换位技能 
            --两个技能换位 那么被动就到后面去了
            --删除所有占位技能 
            for i= 0,9 do
                local ability = playerHero:GetAbilityByIndex(i)
                if ability then
                    number = number + 1
                end
            end
            --计算出需要添加几个空技能
            number = 10 -  number
            for i = 1, number do
                playerHero:AddAbility("none_spell_001")
            end
            local abilitySwap = playerHero:AddAbility("none_spell_002")
            playerHero:SwapAbilities(abilityName, "none_spell_002", false, false)
            --此时成功换位成功
            print('i='..i) 
            for i = 1, number do
                playerHero:RemoveAbility("none_spell_001")
            end
            playerHero:RemoveAbility("none_spell_002")
            --删掉占位技能
            break
        end
    end
end



--获取玩家英雄的可出售技能列表与返还
function skillshop:_SpellsMenuGetSpells_by_classlevel(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    --由此获取到了技能列表
    local playerAbilities = self:_GetPlayerSpellsByLevel(nPlayerID)

    --反馈给js这个技能列表
    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_get_player_spells_by_classlevel_feedback", { player_abilities = playerAbilities })
end




--基于技能阶级与等级返还可以升阶的技能表
function skillshop:_GetPlayerSpellsByLevel(nPlayerID)
    local player = PlayerResource:GetPlayer(nPlayerID)
    if player and PlayerResource:HasSelectedHero(nPlayerID) then
        local playerHero = player:GetAssignedHero()
        if not playerHero then
            return
        end
        local maxAbilities = playerHero:GetAbilityCount() - 1

        local playerAbilities = {}
        local abilitiesCost = {}
        local nextAbilityName = {}

        for ability_id = 0, maxAbilities do
            local ability = playerHero:GetAbilityByIndex(ability_id)
            -- Make sure it is not a talent and there is level
            if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
            -- if ability and not ability:IsAttributeBonus() then
                local ability_level = ability.classlevel

                if ability_level then
                    ---低阶且满级的情况下
                    if ability_level==1 and ability:GetLevel()==5 then
                         local abilityName = ability:GetAbilityName()
                         local cost = ability.to_level2_cost
                         table.insert(abilitiesCost, cost)
                         table.insert(playerAbilities, abilityName)
                         table.insert(nextAbilityName, ability.level2_id)
                    end
                    ---中阶且满级的情况下
                    if ability_level==2 and ability:GetLevel()==3 then
                        local abilityName = ability:GetAbilityName()
                        local cost = ability.to_level3_cost
                        table.insert(abilitiesCost, cost)
                        -- table.insert(playerAbilities, ability.level3_id)
                        table.insert(playerAbilities, abilityName)
                        table.insert(nextAbilityName, ability.level3_id)
                    end
                    --高阶
                    if ability_level==3 and ability.advanced_level<25 then
                        local cost = ability.upgrade_cost
                        table.insert(abilitiesCost, cost)
                        local abilityName = ability:GetAbilityName()
                        table.insert(playerAbilities, abilityName)
                        table.insert(nextAbilityName, abilityName)
    
                    end
                end
                
            end
        end
        local abilitytable = {}
        table.insert(abilitytable, playerAbilities)  --技能
        table.insert(abilitytable, abilitiesCost)  --花费
        table.insert(abilitytable, nextAbilityName)  --下一个技能

        return abilitytable
    end

    return {}
end


--升级技能
function skillshop:_SpellsMenuUpgradeAbilities(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local upgradeAbilityName = event_data.upgrade  --由此拿到了升阶对象

    local player = PlayerResource:GetPlayer(nPlayerID) 
    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
    local ability = playerHero:FindAbilityByName(upgradeAbilityName)  --拿到技能的实体
    --接下来需要获取几个自定义属性以便升级后的技能去继承
    if not ability then
        return
    end
    local ability_level = ability.classlevel    --得到阶级
    --如果已经是第三阶级
    if ability_level==3 then
        local freeSpellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.freeSpellMap
        if ability.advanced_level>=25 then  --说明已经满级
            return
        end
        if not playerHero:IsAlive() then
            SendCustomErrorToPlayer(playerHero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_3","General.Cancel")
            playerHero:EmitSound("General.Cancel")
            return
        end
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
        local spellxpmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable
        local playerSteamID= tostring(PlayerResource:GetSteamID(nPlayerID))
        local index = nPlayerID

        if tostring(spellmap[index].steamID)~=tostring(playerSteamID) then
            return  --说明找不到 出错了
        end
        --现在我们拿到了位置后就该判断是不是有这个技能书了
        local spellstable = spellmap[index].spells
        local spellsname = upgradeAbilityName
        local nowxp = tonumber(spellstable[spellsname] ) --目前的经验值
        local need_xp = spellxpmap[ability.advanced_level+1]
        if (not nowxp or need_xp>nowxp ) and not _G.GAME_debugTesting then  --经验不足以升级
            if not freeSpellMap[spellsname] or ability.advanced_level>=10 then  --如果没有免费技能效果 或者超过10级
                UpgradeFail_advanced(playerHero,upgradeAbilityName)  --失败提示
                return
            end
        end

        local cost = ability.upgrade_cost
        if playerHero:HasModifier("modifier_Advanced_Untouchable_unlock3") then
            cost = cost *0.5
        end
        if playerHero:HasModifier("modifier_item_hd_revtel_signet_ring") then
            cost = cost *0.92
        end
        -- 升级技能的时候需要检查是否在乱纪元模式下，是的话这里要过一个检查剩余玩家升级点数，25/9/11将此设定停用
        -- if Game_State:IsInChaoticEra() then
        --     if not chaotic_era_shop:CheckUpgradeChange(nPlayerID) then
        --         if not chaotic_era_shop:TryBuyUpgradeChance(nPlayerID) then
        --             SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_UpgradeChance","General.Cancel")
        --             return
        --         end
              
        --     end
        -- end
 
        --三阶技能不需要置换技能 改自己就行了
        if not skillshop:CheckGold_Advanced(playerHero,cost) then  --检测金币
            return
        end
        -- 升级技能的时候需要检查是否在乱纪元模式下，是的话这里要过一个消耗剩余玩家升级点数，25/9/11将此设定停用
        -- if Game_State:IsInChaoticEra() then
        --     chaotic_era_shop:GeneralSpellUpgrade(nPlayerID)
        -- end


        skillshop:SpendGoldToEvolute_Advanced(playerHero,cost,ability.advanced_level,upgradeAbilityName)


        ability.totalcost = ability.totalcost + cost  --增加消费量
        ability.advanced_level = ability.advanced_level + 1  --升级技能需要增加等级 
        if ability.advanced_level>=25 then
            if not ability.achievement_lv25 then
                ability.achievement_lv25 = true
               if playerHero:HaveAchievement("exp_millionaire_1") and 20>=RandomInt(1, 100) then
                    ability.advanced_level = ability.advanced_level + 1
               end 
            end
            
        end
        if ability.OnAdvancedUpgrade ~= nil then
            ability:OnAdvancedUpgrade()
        end

        local NetTable_key = tostring(nPlayerID).."_"..upgradeAbilityName
        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {level =ability.advanced_level } )  --更新网表


        --目前没有任何提升 直接留空return
        print("upgrade finished")
        playerHero:EmitSound("ui.trophy_levelup")

        local keys = {
            unit = playerHero,
            ability = ability,
            -- associatedAbility = associatedAbility_entity,
            cost = cost,
            bIsGeneralSpell = true,
            bIsChaoticEraSpell = false,
            bIsTalent = false,
            isUpgrade = true,
            IsEvolve = false,
            isBuy = false,
        }
        FireSpellLearnEvent(keys)

    elseif ability_level==1 then  --低阶技能

        if not playerHero:IsAlive() then
            SendCustomErrorToPlayer(playerHero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_2","General.Cancel")
            playerHero:EmitSound("General.Cancel")
            return
        end
        -- 升级技能的时候需要检查是否在乱纪元模式下，是的话这里要过一个检查剩余玩家升阶点数，25/9/11将此设定停用
        -- if Game_State:IsInChaoticEra() then
        --     if not chaotic_era_shop:CheckEvolutionChange(nPlayerID) then
        --         if not chaotic_era_shop:TryBuyEvoluteionChance(nPlayerID) then
        --             SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_EvoluteChance","General.Cancel")
        --             return
        --         end
                
        --     end
        -- end

        local cost = ability.to_level2_cost
        if not skillshop:CheckGold(playerHero,cost) then --检测金币
            return
        end
       
        -- 升级技能的时候需要检查是否在乱纪元模式下，是的话这里要过一个消耗剩余玩家升级点数，25/9/11将此设定停用
        -- if Game_State:IsInChaoticEra() then
        --     chaotic_era_shop:GeneralSpellEvolute(nPlayerID)
        -- end

        skillshop:SpendGoldToEvolute(playerHero,cost,ability.level2_id)

        local newAbility =  playerHero:AddAbility(ability.level2_id)  --添加下一个阶级
        newAbility.level3_id = ability.level3_id    --设置阶级三
        newAbility.classlevel = 2                   --设置为二阶   
        newAbility.to_level3_cost = ability.to_level3_cost  --设置升级花费
        newAbility.upgrade_cost = ability.upgrade_cost  --设置升级花费
        newAbility:SetLevel(1)
        self:_SwapAbilitiesPosition(nPlayerID, ability.level2_id, upgradeAbilityName)  --换个位
        newAbility.totalcost = ability.totalcost + cost   --增加消费

    


        print("1111111111111111111")

        local associatedAbilityname = ability.now_associatedAbility
        local associatedAbility_entity
        if associatedAbilityname then  --如果有副技能 先加副技能
            print("2222222222222222")

            -- Add associated abilities
            associatedAbility_entity = playerHero:AddAbility(ability.level2_associatedAbility)
            associatedAbility_entity.subSpell = true --用于判断副技能
            -- self:_SwapAbilitiesPosition(nPlayerID, ability.now_associatedAbilities, ability.level2_associatedAbility)  --换个位
            associatedAbility_entity:SetLevel(1)
            print("3333333333333333333")

            newAbility.now_associatedAbility = ability.level2_associatedAbility     --现在的副技能
            newAbility.level3_associatedAbility = ability.level3_associatedAbility  --高阶的副技能
            -- print(ability.level3_associatedAbility)
            playerHero:RemoveAbility(associatedAbilityname)
            print("44444444444")

        end
        --删除原技能
        local modifiers = playerHero:FindAllModifiers()
        for _, modifier in pairs(modifiers) do
            if modifier:GetAbility() == ability then
                 modifier:SafeDestroy()
            end
        end

        local keys = {
            unit = playerHero,
            ability = newAbility,
            associatedAbility = associatedAbility_entity,
            cost = cost,
            bIsGeneralSpell = true,
            bIsChaoticEraSpell = false,
            bIsTalent = false,
            isUpgrade = false,
            IsEvolve = true,
            isBuy = false,
        }
        FireSpellLearnEvent(keys)


        RemoveSpells(playerHero,upgradeAbilityName)
        playerHero:EmitSound("underdraft_levelup_1")
        
    elseif ability_level==2 then  --处理二阶技能
        if not playerHero:IsAlive() then
            SendCustomErrorToPlayer(playerHero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_2","General.Cancel")
            playerHero:EmitSound("General.Cancel")
            return
        end
        --放处理是否玩家拥有技能书的位置
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
        local playerSteamID= tostring(PlayerResource:GetSteamID(nPlayerID))
        -- local index = 0
        local index = nPlayerID
        -- for i, key in ipairs(spellmap) do   --先遍历一下得到在表里的的位置
        --     if key了，。steamID == playerSteamID then
        --         index = i
        --     end
        -- end
        if not Game_State:IsInChaoticEra() then
            if spellmap[index].steamID~=playerSteamID then
                return  --说明找不到 出错了
            end
            --现在我们拿到了位置后就该判断是不是有这个技能书了
            local spellstable = spellmap[index].spells
            local spellsname = ability.level3_id
            local freeSpellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.freeSpellMap
            if not spellstable[spellsname] and not _G.GAME_debugTesting then  --表里没有这个技能 那就直接返回吧
                if not freeSpellMap[spellsname] then
                    UpgradeFail(playerHero,ability.level3_id)  --失败提示
                    return   
                end
                
            end
        end
       

        
        -- PrintTable(spellmap)
        -- print(spellmap)
        -- GameRules:GetGameModeEntity().CHoldoutGameMode.spellMap
        ----
        if not skillshop:CheckGold(playerHero,ability.to_level3_cost) then --检测金币
            return 
        end
        -- 升级技能的时候需要检查是否在乱纪元模式下，是的话这里要过一个检查，扣除升阶点数，25/9/11将此设定停用
        -- if Game_State:IsInChaoticEra() then
        --     if not chaotic_era_shop:CheckEvolutionChange(nPlayerID) then
        --         if not chaotic_era_shop:TryBuyEvoluteionChance(nPlayerID) then
        --             SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_EvoluteChance","General.Cancel")
        --             return
        --         end
                
        --     end
        -- end
        -- if Game_State:IsInChaoticEra() then
        --     chaotic_era_shop:GeneralSpellEvolute(nPlayerID)
        -- end
        local cost = ability.to_level3_cost
        skillshop:SpendGoldToEvolute(playerHero,cost,ability.level3_id) --扣除金币

        local newAbility =  playerHero:AddAbility(ability.level3_id)  --添加下一个阶级
        -- newAbility.level3_id = ability.level3_id    --设置阶级三
        newAbility.classlevel = 3                   --设置为三阶   
        newAbility.advanced_level = 1          --设置初始的高阶等级
        newAbility.upgrade_cost = ability.upgrade_cost  --设置升级花费

        local NetTable_key = tostring(nPlayerID).."_"..ability.level3_id

        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {level =1 } )  --更新网表
        local NetTable_key = tostring(nPlayerID).."_"..ability.level3_id.."_unlock"
        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {coreUnlock =0 } )  --更新网表


        newAbility:SetLevel(1)
        self:_SwapAbilitiesPosition(nPlayerID, ability.level3_id, upgradeAbilityName)  --换个位
        newAbility.totalcost = ability.totalcost + cost  --增加消费
            

        local associatedAbilityname = ability.now_associatedAbility
        local associatedAbility_entity
        if associatedAbilityname then  --如果有副技能 先加副技能
            
            -- Add associated abilities
            associatedAbility_entity = playerHero:AddAbility(ability.level3_associatedAbility)
            associatedAbility_entity.subSpell = true --用于判断副技能
            -- self:_SwapAbilitiesPosition(nPlayerID, ability.now_associatedAbilities, ability.level3_associatedAbility)  --换个位
            associatedAbility_entity:SetLevel(1)
            newAbility.now_associatedAbility = ability.level3_associatedAbility     --现在的副技能
            playerHero:RemoveAbility(associatedAbilityname)
        end
        --删除原技能
        local modifiers = playerHero:FindAllModifiers()
        for _, modifier in pairs(modifiers) do
            if modifier:GetAbility() == ability then
                 modifier:SafeDestroy()
            end
        end
        RemoveSpells(playerHero,upgradeAbilityName)
        playerHero:EmitSound("underdraft_levelup_2")

        local keys = {
            unit = playerHero,
            ability = newAbility,
            associatedAbility = associatedAbility_entity,
            cost = cost,
            bIsGeneralSpell = true,
            bIsChaoticEraSpell = false,
            bIsTalent = false,
            isUpgrade = false,
            IsEvolve = true,
            isBuy = false,
        }
        FireSpellLearnEvent(keys)

        _G.SPELL_UPGRADE_TO_ADVANCED[nPlayerID] = true


    end

    self:HeroUpgradeAbility(nPlayerID,playerHero)


    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_upgrade_player_spells_fnished_feedback", { })
end


--升级技能+5
function skillshop:_SpellsMenuUpgradeAbilities_lv5(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local upgradeAbilityName = event_data.upgrade  --由此拿到了升阶对象

    local player = PlayerResource:GetPlayer(nPlayerID) 
    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
    local ability = playerHero:FindAbilityByName(upgradeAbilityName)  --拿到技能的实体
    --接下来需要获取几个自定义属性以便升级后的技能去继承
    if not ability then
        return
    end
    if not playerHero:IsAlive() then
        SendCustomErrorToPlayer(playerHero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_3","General.Cancel")
        playerHero:EmitSound("General.Cancel")
        return
    end
    local ability_level = ability.classlevel    --得到阶级

    if ability_level==3 then

        local freeSpellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.freeSpellMap
        for i = 1, 5, 1 do
            if ability.advanced_level>=25 then  --说明已经满级
                -- Notifications:Top(playerHero:GetPlayerOwnerID(), { text = "debug2", duration = 4, style = { color = "red" } })
                break
            end
    
            local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
            local spellxpmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable
            local playerSteamID= tostring(PlayerResource:GetSteamID(nPlayerID))
            local index = nPlayerID
          
            if tostring(spellmap[index].steamID)~=tostring(playerSteamID) then
                return  --说明找不到 出错了
            end
            --现在我们拿到了位置后就该判断是不是有这个技能书了
            local spellstable = spellmap[index].spells
            local spellsname = upgradeAbilityName
            local nowxp = tonumber(spellstable[spellsname] ) --目前的经验值
            local need_xp = spellxpmap[ability.advanced_level+1]
            if (not nowxp or need_xp>nowxp ) and not _G.GAME_debugTesting then  --经验不足以升级
                if not freeSpellMap[spellsname] or ability.advanced_level>=10 then  
                    UpgradeFail_advanced(playerHero,upgradeAbilityName)  --失败提示
                    return
                end
          
            end
            local cost = ability.upgrade_cost
            if playerHero:HasModifier("modifier_Advanced_Untouchable_unlock3") then
                cost = cost *0.5
            end
            if playerHero:HasModifier("modifier_item_hd_revtel_signet_ring") then
                cost = cost *0.92
            end
            -- 升级技能的时候需要检查是否在乱纪元模式下，是的话这里要过一个检查剩余玩家升级点数，25/9/11将此设定停用
            -- if Game_State:IsInChaoticEra() then
            --     if not chaotic_era_shop:CheckUpgradeChange(nPlayerID) then
            --         if not chaotic_era_shop:TryBuyUpgradeChance(nPlayerID) then
            --             SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_UpgradeChance","General.Cancel")
            --             return
            --         end
                  
            --     end
            -- end
            if not skillshop:CheckGold_Advanced(playerHero,cost) then  --检测金币
                return
            end
            -- 升级技能的时候需要检查是否在乱纪元模式下，是的话这里要过一个检查剩余玩家升级点数，25/9/11将此设定停用
            -- if Game_State:IsInChaoticEra() then
            --     chaotic_era_shop:GeneralSpellUpgrade(nPlayerID)
            -- end

            skillshop:SpendGoldToEvolute_Advanced(playerHero,cost,ability.advanced_level,upgradeAbilityName)



            ability.totalcost = ability.totalcost + cost  --增加消费量
            ability.advanced_level = ability.advanced_level + 1  --升级技能需要增加等级 
            if ability.advanced_level>=25 then
                if not ability.achievement_lv25 then
                    ability.achievement_lv25 = true
                   if playerHero:HaveAchievement("exp_millionaire_1") and 20>=RandomInt(1, 100) then
                        ability.advanced_level = ability.advanced_level + 1
                   end 
                end
                
            end
            if ability.OnAdvancedUpgrade ~= nil then
                ability:OnAdvancedUpgrade()
            end
            local NetTable_key = tostring(nPlayerID).."_"..upgradeAbilityName
            CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {level =ability.advanced_level } )  --更新网表
            playerHero:EmitSound("ui.trophy_levelup")
            
            
            local keys = {
                unit = playerHero,
                ability = ability,
                -- associatedAbility = associatedAbility_entity,
                cost = cost,
                bIsGeneralSpell = true,
                bIsChaoticEraSpell = false,
                bIsTalent = false,
                isUpgrade = true,
                IsEvolve = false,
                isBuy = false,
            }
            FireSpellLearnEvent(keys)


        end

        self:HeroUpgradeAbility(nPlayerID,playerHero)
     
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_upgrade_player_spells_fnished_feedback", { })
end

function skillshop:UpgradeAbilitiesPassLV25(ability,maxLevel)
    --接下来需要获取几个自定义属性以便升级后的技能去继承
    if not ability then
        return
    end
    local ability_level = ability.classlevel    --得到阶级
    local playerHero = ability:GetCaster()
    local nPlayerID = playerHero:GetPlayerOwnerID()
    local player = PlayerResource:GetPlayer(nPlayerID) 
    if not player then
        return
    end
    --如果已经是第三阶级
    if ability_level==3 then
        local freeSpellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.freeSpellMap
        if ability.advanced_level>=maxLevel then  --说明已经满级
            return
        end
        if not playerHero:IsAlive() then
            SendCustomErrorToPlayer(playerHero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_3","General.Cancel")
            playerHero:EmitSound("General.Cancel")
            return
        end
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
        local spellxpmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable
        local playerSteamID= tostring(PlayerResource:GetSteamID(nPlayerID))
        local index = nPlayerID

        if tostring(spellmap[index].steamID)~=tostring(playerSteamID) then
            return  --说明找不到 出错了
        end
        --现在我们拿到了位置后就该判断是不是有这个技能书了
        local spellstable = spellmap[index].spells
        local spellsname = ability:GetAbilityName()
        local nowxp = tonumber(spellstable[spellsname] ) --目前的经验值
        local need_xp = spellxpmap[math.min(ability.advanced_level+1,25)]
        if (not nowxp or need_xp>nowxp ) and not _G.GAME_debugTesting then  --经验不足以升级
            if not freeSpellMap[spellsname] or ability.advanced_level>=10 then  --如果没有免费技能效果 或者超过10级
                
            
                -- UpgradeFail_advanced(playerHero,spellsname)  --失败提示
                return
            end
      
        end

        ability.advanced_level = ability.advanced_level + 1  --升级技能需要增加等级 
   
        if ability.OnAdvancedUpgrade ~= nil then
            ability:OnAdvancedUpgrade()
        end

        local NetTable_key = tostring(nPlayerID).."_"..spellsname
        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {level =ability.advanced_level } )  --更新网表


        --目前没有任何提升 直接留空return
        print("upgrade finished")
        playerHero:EmitSound("ui.trophy_levelup")
   

    end



-- 下面进行升级技能的操作
    -- self:_SwapAbilitiesPosition(nPlayerID, firstAbilityName, secondAbilityName)

    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_upgrade_player_spells_fnished_feedback", { })
end

function skillshop:UpgradeAbilitiesPassLV25AndExp(ability,maxLevel)
    --接下来需要获取几个自定义属性以便升级后的技能去继承
    if not ability then
        return
    end
    local ability_level = ability.classlevel    --得到阶级
    local playerHero = ability:GetCaster()
    local nPlayerID = playerHero:GetPlayerOwnerID()
    local player = PlayerResource:GetPlayer(nPlayerID) 
    if not player then
        return
    end
    --如果已经是第三阶级
    if ability_level==3 then
        if ability.advanced_level>=maxLevel then  --说明已经满级
            return
        end
        if not playerHero:IsAlive() then
            SendCustomErrorToPlayer(playerHero:GetPlayerOwnerID(),"DOTA_CUSTOM_Cant_Learn_3","General.Cancel")
            playerHero:EmitSound("General.Cancel")
            return
        end
        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
        local playerSteamID= tostring(PlayerResource:GetSteamID(nPlayerID))
        local index = nPlayerID
        if tostring(spellmap[index].steamID)~=tostring(playerSteamID) then
            return  --说明找不到 出错了
        end
        local spellsname = ability:GetAbilityName()
        ability.advanced_level = ability.advanced_level + 1  --升级技能需要增加等级 
        if ability.OnAdvancedUpgrade ~= nil then
            ability:OnAdvancedUpgrade()
        end
        local NetTable_key = tostring(nPlayerID).."_"..spellsname
        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {level =ability.advanced_level } )  --更新网表
        --目前没有任何提升 直接留空return
        print("upgrade finished")
        playerHero:EmitSound("ui.trophy_levelup")
   

    end



-- 下面进行升级技能的操作
    -- self:_SwapAbilitiesPosition(nPlayerID, firstAbilityName, secondAbilityName)

    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_upgrade_player_spells_fnished_feedback", { })
end




function RemoveSpells(hero,abilityname)
    local existingAbility = hero:FindAbilityByName(abilityname)
    --破坏技能效果
    local modifiers = hero:FindAllModifiers()
    for _, modifier in pairs(modifiers) do
        if modifier:GetAbility() == abilityname then
           
            modifier:SafeDestroy()
        end
    end
    hero:RemoveAbilityByHandle(existingAbility)
end

--一般用
function skillshop:CheckGold(hero,cost)
    local gold = hero:GetGold()
    if gold>=cost then

        return true  --购买成功
    end
    SendCustomErrorToPlayer(hero:GetPlayerOwnerID(),"Spells_Menu_Insufficient_CP","General.Cancel")
    hero:EmitSound("General.Cancel")
    return false    --购买失败
    
end

function skillshop:SpendGoldToEvolute(hero,cost,abilityNmae)
    hero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --金币奖励
    local gameEvent = {}
    gameEvent["player_id"] = hero:GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["ability_name"] = abilityNmae
    gameEvent["message"] = "#Spells_Menu_UpgradeNewAbility"
    FireGameEvent( "dota_combat_event_message", gameEvent )
end

--高阶技能用
function skillshop:CheckGold_Advanced(hero,cost)
    local gold = hero:GetGold()
    if gold>=cost then
        return true  --购买成功
    end
    SendCustomErrorToPlayer(hero:GetPlayerOwnerID(),"Spells_Menu_Insufficient_CP","General.Cancel")
    hero:EmitSound("General.Cancel")
    return false    --购买失败
    
end


function skillshop:SpendGoldToEvolute_Advanced(hero,cost,level,abilityName)
    hero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)  --金币奖励
    local gameEvent = {}
    gameEvent["player_id"] = hero:GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["ability_name"] = abilityName
    gameEvent["locstring_value"] = tostring(level+1)
    gameEvent["message"] = "#Spells_Menu_UpgradeNewAbility_advanced"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    hero:EmitSound("General.Buy")
end




--技能升阶失败的提示
function UpgradeFail(hero,abilityName)
    local gameEvent = {}
    gameEvent["player_id"] = hero:GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["ability_name"] = abilityName
    gameEvent["message"] = "#Spells_Upgrade_Fail_left"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    SendCustomErrorToPlayer(hero:GetPlayerOwnerID(),"Spells_Upgrade_Fail","General.Cancel")
    hero:EmitSound("General.Cancel")
end
--技能升级失败
function UpgradeFail_advanced(hero,abilityName)
    local gameEvent = {}
    gameEvent["player_id"] = hero:GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["ability_name"] = abilityName
    gameEvent["message"] = "#Spells_Upgrade_Fail_advanced_left"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    SendCustomErrorToPlayer(hero:GetPlayerOwnerID(),"Spells_Upgrade_Fail_advanced","General.Cancel")
    hero:EmitSound("General.Cancel")
end

--获取玩家英雄的可出售技能列表与返还
function skillshop:_SellSpellsMenuGetSpells_by_classlevel(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    --由此获取到了技能列表
    local playerAbilities = self:_GetPlayerSellSpellsByLevel(nPlayerID)

    --反馈给js这个技能列表
    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_get_player_sellspells_by_classlevel_feedback", { player_abilities = playerAbilities })
end

--基于技能阶级与等级返还可以出售的技能表
function skillshop:_GetPlayerSellSpellsByLevel(nPlayerID)
    local player = PlayerResource:GetPlayer(nPlayerID)
    if player and PlayerResource:HasSelectedHero(nPlayerID) then
        local playerHero = player:GetAssignedHero()
        local maxAbilities = playerHero:GetAbilityCount() - 1

        local playerAbilities = {}
        local abilitiesCost = {}


        for ability_id = 0, maxAbilities do
            local ability = playerHero:GetAbilityByIndex(ability_id)
            -- Make sure it is not a talent and there is level
            if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
            -- if ability and not ability:IsAttributeBonus() then
                local ability_level = ability.classlevel

                if ability_level and ability:IsSpellCanBeSell() then
                    ---低阶的情况下
                    if ability_level==1 then
                         local abilityName = ability:GetAbilityName()
                         local cost = ability.totalcost*0.5
                         table.insert(abilitiesCost, cost)
                         table.insert(playerAbilities, abilityName)
                    end
                    ---中阶的情况下
                    if ability_level==2 then
                        local abilityName = ability:GetAbilityName()
                        local cost = ability.totalcost*0.5
                        table.insert(abilitiesCost, cost)
                        -- table.insert(playerAbilities, ability.level3_id)
                        table.insert(playerAbilities, abilityName)
    
                    end
                    --高阶
                    if ability_level==3 then
                        
                        local cost = ability.totalcost*0.5
                        table.insert(abilitiesCost, cost)
                        local abilityName = ability:GetAbilityName()
                        table.insert(playerAbilities, abilityName)
         
    
                    end
                else   
                    if string.match(ability:GetAbilityName(), "chaotic") and ability:IsSpellCanBeSell() then
                        local cost = 0
                        table.insert(abilitiesCost, cost)
                        local abilityName = ability:GetAbilityName()
                        table.insert(playerAbilities, abilityName)
                    end
         
                end

                
                
            end
        end
        local abilitytable = {}
        table.insert(abilitytable, playerAbilities)  --技能
        table.insert(abilitytable, abilitiesCost)  --花费
  

        return abilitytable
    end

    return {}
end





--出售
function skillshop:_SpellsMenuSellAbilities(eventSourceIndex, event_data)
    if not IsServer() then
        return
    end
    local nPlayerID = event_data.player_id
    local SellAbilityName = event_data.sell  --由此拿到了出售对象

    local player = PlayerResource:GetPlayer(nPlayerID) 
    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
    local ability = playerHero:FindAbilityByName(SellAbilityName)  --拿到技能的实体
    if not ability then  --不知道为什么会获取一个nil 明明成功执行了 加这个可以不出错误提示
        return
    end
    -- if Game_State:IsInChaoticEra() and  SellAbilityName~="for_swap_spells" then
    --     if not chaotic_era_shop:CheckSellChange(nPlayerID) then
    --         if not chaotic_era_shop:TryBuySellChance(nPlayerID) then
    --             SendCustomErrorToPlayer(nPlayerID,"HUD_ChaoticEra_Error_No_Sellhance","General.Cancel")
    --             return
    --         else

    --         end
           
    --     end
    -- end
    -- if Game_State:IsInChaoticEra()and  SellAbilityName~="for_swap_spells" then
    --     chaotic_era_shop:GeneralSpellSell(nPlayerID)
    -- end


    local returncost = (ability.totalcost or 0) *0.5

                  
    -- 售出技能需要破坏原来的技能效果
    local modifiers = playerHero:FindAllModifiers()
    for _, modifier in pairs(modifiers) do
        if modifier:GetAbility() == ability and modifier:RemoveOnSell() then
            -- print("remaining time ="..modifier:GetRemainingTime())
             modifier:SafeDestroy()
        end
    end
    if returncost then  --防止BUG

        if ability.now_associatedAbility then  --如果有副技能 先删副技能

            playerHero:RemoveAbility(ability.now_associatedAbility)
        end
        local point_cost = 0
        if string.sub(SellAbilityName,1,8)=="Advanced" then
            point_cost = 6
        elseif string.sub(SellAbilityName,1,6)=="Middle" then
            point_cost = ability:GetLevel()+3
        else
            point_cost = ability:GetLevel()-1
        end
        --单人返还技能点
        if playerHero:HasModifier("modifier_wolf_power") or playerHero:HasModifier("modifier_it_takes_two") then
            local abilityPoints = playerHero:GetAbilityPoints()
            playerHero:SetAbilityPoints(abilityPoints+point_cost)
        else
            --多人返还一半
            point_cost = point_cost/2
            point_cost = point_cost-point_cost%1  --向下取整
            local abilityPoints = playerHero:GetAbilityPoints()
            playerHero:SetAbilityPoints(abilityPoints+point_cost)
        end


        --删除原技能
        RemoveSpells(playerHero,SellAbilityName)
        playerHero:ModifyGoldFiltered(returncost,true,DOTA_ModifyGold_SellItem)  --金币返回
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,playerHero, returncost, nil)
        local gameEvent = {}
        gameEvent["player_id"] = playerHero:GetPlayerOwnerID()
        gameEvent["teamnumber"] = -1
        gameEvent["locstring_value"] = tostring(returncost)
        gameEvent["ability_name"] = SellAbilityName
        gameEvent["message"] = "#Spells_Menu_SellNeutralAbility"
        
        FireGameEvent( "dota_combat_event_message", gameEvent )
        playerHero:EmitSound("General.Buy")

        local keys = {}
        keys.PlayerID = nPlayerID
        self:OnPlayerLearnSpell(keys)

        if true then
            local keys = {
                unit = playerHero,
                ability_name = SellAbilityName,
            }
            FireSpellSellEvent(keys)
        end

    end
    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_swap_player_sell_feedback", { }) --刷新界面
end




MysterUnlock ={
    "dk_persona_debut_stinger",
    "dawnbreaker_debut_stinger",
    "drow_arcana_stinger",
}


function skillshop:_UnlockSpellMystery(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local upgradeAbilityName = event_data.ability_name  --由此拿到了升阶对象
    local spellsClass = tonumber(event_data.spellsClass)  --解锁的奥义类型
    local player = PlayerResource:GetPlayer(nPlayerID) 
    local playerHero = player:GetAssignedHero()   --由此拿到了玩家的英雄
    local ability = playerHero:FindAbilityByName(upgradeAbilityName)  --拿到技能的实体
    --接下来需要获取几个自定义属性以便升级后的技能去继承
    if not ability then
        return
    end
    if not playerHero:IsAlive() then
        print("Error:死亡状态")
        return
    end
    if playerHero:IsInvulnerable() then
        print("Error:无敌状态中")
        return
    end
    if playerHero:IsOutOfGame() then
        print("Error:游戏外")
        return
    end
    if ability.CoreUnlock then
        print("Error:奥义已解锁")
        return
    end

    if spellsClass==1 then
        if ability.UnlockFirstCore==nil then
            print("Error:无奥义1")
            return
        end
        local item = playerHero:FindItemInInventory("item_hd_the_first_core")
        if not item then
            print("Error:没有原石可以解锁")
            -- Notifications:Top(nPlayerID, { text = "#dota_hud_NoUnlockRock", duration = 4, style = { color = "red" } })
            SendCustomErrorToPlayer(nPlayerID,"dota_hud_NoUnlockRock","General.Cancel")
            return
        end
        
        ability.CoreUnlock = true
        ability.unlock1 = true
        local result = ability:UnlockFirstCore()
        if not result then
            return
        end
        item:Unlock()

        local NetTable_key = tostring(nPlayerID).."_"..upgradeAbilityName.."_unlock"
        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {coreUnlock =1 } )  --更新网表

        playerHero:EmitSound(MysterUnlock[RandomInt(1, #MysterUnlock)])
        -- EmitSoundOnClient("dk_persona_debut_stinger", player)

    elseif spellsClass==2 then
        if ability.UnlockSecondCore==nil then
            print("Error:无奥义2")
            return
        end
        local item = playerHero:FindItemInInventory("item_hd_the_second_core")
        if not item then
            print("Error:没有原石可以解锁")
            -- Notifications:Top(nPlayerID, { text = "#dota_hud_NoUnlockRock", duration = 4, style = { color = "red" } })
            SendCustomErrorToPlayer(nPlayerID,"dota_hud_NoUnlockRock","General.Cancel")
            return
        end
        ability.CoreUnlock = true
        ability.unlock2 = true
        local result = ability:UnlockSecondCore()
        if not result then
            return
        end
        item:Unlock()
        
        local NetTable_key = tostring(nPlayerID).."_"..upgradeAbilityName.."_unlock"
        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {coreUnlock =2 } )  --更新网表
        playerHero:EmitSound(MysterUnlock[RandomInt(1, #MysterUnlock)])
    elseif spellsClass==3 then
        if ability.UnlockThirdCore==nil then
            print("Error:无奥义3")
            return
        end
        local item = playerHero:FindItemInInventory("item_hd_the_third_core")
        if not item then
            print("Error:没有原石可以解锁")
            -- Notifications:Top(nPlayerID, { text = "#dota_hud_NoUnlockRock", duration = 4, style = { color = "red" } })
            SendCustomErrorToPlayer(nPlayerID,"dota_hud_NoUnlockRock","General.Cancel")
            return
        end
        ability.CoreUnlock = true
        ability.unlock3 = true
        local result = ability:UnlockThirdCore()
        if not result then
            return
        end
        item:Unlock()
        local NetTable_key = tostring(nPlayerID).."_"..upgradeAbilityName.."_unlock"
        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {coreUnlock =3 } )  --更新网表
        playerHero:EmitSound(MysterUnlock[RandomInt(1, #MysterUnlock)])
    else 
        print("Error:奥义索引错误")
    end

end



numberIndexTable ={
    1,
    1.5,
    1.9,
    2.2,
    2.4
}
_G.Game_bonus_chance = 5
_G.Game_Ranking_bonus_chance = 1  --Top3的奖励值
--传入可能数值以求得随机的奖励
--会根据GetPlayerCount()变动
--单人情况下传入10k即有百分之10的基础几率
function skillshop:RollBonusCore(rollIndex)
    if _G.Game_bonus_chance<=0 then
        print("没有次数了")
        return
    end
    print("_G.Game_Ranking_bonus_chance=".._G.Game_Ranking_bonus_chance)
    local baseChance = numberIndexTable[GetPlayerCount()] * rollIndex * _G.Game_Ranking_bonus_chance
    local newChance = baseChance * (1+_G.GAME_Reincarnation_Wave*0.08) --即每12.5层增加100%的获取几率 此时单人传入10K为20%
    print("newChance="..newChance)
    print("baseChance="..baseChance)
    local needCount = 100000  --100K

    if newChance>=RandomInt(1, needCount) then
        print("成功挖掘了原石 计算数量")
        local bonusCount = 1
        local mulCount = math.floor(_G.GAME_Reincarnation_Wave/10)  --向下取整
        if mulCount>=1 then
            for i = 1, mulCount, 1 do
                if baseChance>=RandomInt(1, needCount) then
                    baseChance = baseChance  *0.7
                    bonusCount = bonusCount + 1
                end
            end
        end
        --计算完毕 开始选择幸运玩家
        local bonusTable = {}
        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
            local player = PlayerResource:GetPlayer(nPlayerID)
            if player and steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED  and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_DISCONNECTED   then
                --如果该名玩家在游戏内
                table.insert(bonusTable,nPlayerID)
            end
        end
        if #bonusTable<=0 then
            print("Error:没有任何玩家？")
            return
        end
        local target = bonusTable[RandomInt(1, #bonusTable)] --幸运玩家产生了
        local coreID = RandomInt(1, 3)
        _G.Game_bonus_chance = _G.Game_bonus_chance - bonusCount
        self:CreateAghanimCoreBonusForPlayer(target,coreID,bonusCount) --发送奖励
    end
end





function skillshop:CreateAghanimCoreBonusForPlayer(nPlayerID,coreID,count)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
    local currentNumber = 0
    --取得当前的原石数量
    local coreTarget = "core"..coreID
    currentNumber = spellmap.playerinfo[coreTarget]
    local newData = {}
    newData.playerInfo = {}
    newData.playerInfo.steamId =  tostring(PlayerResource:GetSteamID(nPlayerID))
    newData.playerInfo[coreTarget] = currentNumber+count
    newData.token = _G.GAME_GLOBAL_KEY  --合法性
    --转换格式 发送数据包
    local encoded = json.encode(newData)
    player_database:SendGetAghanimCoreBonus(nPlayerID,encoded,coreTarget,count) 

end





function skillshop:FindAbilityShopKV(abilityName)
    for index, value in ipairs(SpellShopKV) do
        local abilityKV = KeyValues[value][abilityName]
        if abilityKV then
            return abilityKV
        end
    end
end


return skillshop