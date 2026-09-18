
const potionBagRoot = $("#potionBagRoot");
function OpenPotionBag() {
    potionBagRoot.ToggleClass("show");
}




const chaotc_era_itemListPanel = $("#potionBagRoot").FindChildInLayoutFile("chaotc_era_itemListPanel");
const potionBlockList = {
    "regen" :  chaotc_era_itemListPanel.FindChildInLayoutFile("itemListBlock_regen_potion"),
    "buff"  :chaotc_era_itemListPanel.FindChildInLayoutFile("itemListBlock_buff_potion"),
}
let potionData;
let highLightTarget = {};
function UpdatePlayerPotionBag() {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (!potionData) {
        return;
    }

    if (playerShopItemData) {
      
        if (playerID==-1) {
            playerID = Game.GetLocalPlayerID();
            if (playerID==-1) {
                return;
            }
        }
        for (const key in potionBlockList) {
            if (Object.hasOwnProperty.call(potionBlockList, key)) {
                const element = potionBlockList[key];
                element.RemoveAndDeleteChildren();
            }
        }
        let dataList = potionData[playerID];
        
        if (dataList) {
            
            for (const key in dataList) {
                if (Object.hasOwnProperty.call(dataList, key)) {
                    const element = dataList[key];
                    let block = potionBlockList[GetPotionType(element.item_name)];
                    if (!block) {
                        $.Msg("没有找到目标类型block:",element.item_name);
                        continue;
                    }
                    if (element.count>=1) {
                        let newPanel = $.CreatePanel("Panel", block, "item_" + element.item_name);
                        newPanel.BLoadLayoutSnippet("singlePotion"); //载入模块
                        newPanel.SetDialogVariable("count",element.count);
                        
    

                        let kv = GameUI.CustomUIConfig().ChaoticEraPotionKV[element.item_name];
                        if (kv&&kv.texture) {
                            newPanel.FindChildInLayoutFile("potionImage").SetImage("file://{images}/spellicons/"+kv.texture +".png");
                        // }else{
                        //     newPanel.FindChildInLayoutFile("potionImage").SetImage("file://{images}/custom_game/potion/"+element.item_name +".png");
                        }
                      
                        if (highLightTarget[element.item_name]) {
                            newPanel.SetHasClass("select",true);
                        }
    
                        let oderList = {}
                        AddPotionHoverEvent(newPanel,element.item_name,oderList);
                        AddGetPotionEvent(newPanel,element.item_name);
                    }

                    // AddItemBuyEvent_ChaoticEraShop(newPanel.FindChildInLayoutFile("potionImage"),element.item_name);


                }
            }
        }else{
            $.Msg("找不到商店？");
        }
    }
}


function AddGetPotionEvent(targetPanel,item_name) {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }

    targetPanel.SetPanelEvent("oncontextmenu", function () {
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            item_name : item_name
        }
        GameEvents.SendCustomGameEventToServer("UseChaoticEraPotion",  event_data );
    });

    targetPanel.SetPanelEvent("onactivate", function () {
        if (highLightTarget[item_name]) {
            targetPanel.SetHasClass("select",false);
            highLightTarget[item_name]= null;
        }else{
            targetPanel.SetHasClass("select",true);
            highLightTarget[item_name]= true;
        }

    });
}










function CreateRandomHotKey_OpePotionBag(hotkey){
    let key = hotkey;
    const command = `On${key}${Date.now()}`;
    Game.CreateCustomKeyBind(key, `+${command}`);
    Game.AddCommand(
        `+${command}`,
        () => {
            OpenPotionBag();
            // key down callback
        },
        ``,
        1 << 32
    );
    Game.AddCommand(
        `-${command}`,
        () => {
            // key up callback
        },
        ``,
        1 << 32
    );
}