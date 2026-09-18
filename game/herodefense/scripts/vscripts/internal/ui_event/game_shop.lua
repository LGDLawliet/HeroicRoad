-- TryBuyItem_GameShop








-- 购买商店道具
function uimanager:_TryBuyItem_GameShop(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    local playerHero = player:GetAssignedHero() 
    if not playerHero then
        return
    end

    local itemName = event_data.itemname
    -- 不同模式的价格可能不一样 先判断模式
    if Game_Mode.game_shop_type == Game_Shop_Type_Normal then
        -- 如果是正常模式
        local kv = KeyValues.game_shop_general[itemName]
        if not kv then
            print("Error：未能找到普通模式下的道具kv配置,",itemName)
        end
        local cost = kv.cost
        local gold = playerHero:GetGold()

        if gold<cost then
            -- 金币不足
            SendCustomErrorToPlayer(nPlayerID,"Spells_Menu_Insufficient_CP","General.Cancel")
            return
        end
        if not Game_State:IsShopOpen() then
            SendCustomErrorToPlayer(nPlayerID,"HUD_SHOP_DISABLE_ON_BATTLE","General.Cancel")
            return
        end

        local tParams = {
            cost = cost,
            itemName = itemName,
        }

        local reduction = 1-GetShopPriceReduction(playerHero,tParams)*0.01
        cost = math.floor(cost *reduction)

        local item = playerHero:AddItemByName(itemName)
        playerHero:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem  ) 

        EmitClientSound(nPlayerID,"General.Buy")

    elseif Game_Mode.game_shop_type == Game_Shop_Type_ChaoticEra then

        
    end


end


