








const gameShopOpenButton = $("#gameShopOpenButton");

const gameShopPanelRoot = $("#gameShopPanelRoot");
const gameShop_chaoticEraRoot = $("#gameShop_chaoticEraRoot");
const chaoticEra_ShopSpecialButton = gameShop_chaoticEraRoot.FindChildInLayoutFile("chaoticEra_ShopSpecialButton");
const ChaoticEraButton_UpgrateShop = chaoticEra_ShopSpecialButton.FindChildInLayoutFile("ChaoticEraButton_UpgrateShop");

const ChaoticEraButton_RefreshShop =  chaoticEra_ShopSpecialButton.FindChildInLayoutFile("ChaoticEraButton_RefreshShop");
const ChaoticEraButton_RefreshTask =  chaoticEra_ShopSpecialButton.FindChildInLayoutFile("ChaoticEraButton_RefreshTask");

const chaoticEraItemListBlock = gameShop_chaoticEraRoot.FindChildInLayoutFile("chaotic_era_ItemList").FindChildInLayoutFile("itemListBlock");
const chaoticEraSpecialItemListBlock = gameShop_chaoticEraRoot.FindChildInLayoutFile("chaotic_era_SpecialItemList").FindChildInLayoutFile("specialItemListBlock");
const itemListPanel = $("#itemListPanel");

const BuySpellPanel = chaoticEraSpecialItemListBlock.FindChildInLayoutFile("BuySpellPanel");
const EvolutionPanel = chaoticEraSpecialItemListBlock.FindChildInLayoutFile("EvolutionPanel");
const UpgradePanel = chaoticEraSpecialItemListBlock.FindChildInLayoutFile("UpgradePanel");
const SellPanel = chaoticEraSpecialItemListBlock.FindChildInLayoutFile("SellPanel");
const TaskRefreshPanel = chaoticEraSpecialItemListBlock.FindChildInLayoutFile("TaskRefreshPanel");
const PauseTaskPanel = chaoticEraSpecialItemListBlock.FindChildInLayoutFile("PauseTaskPanel");
const ArtifactPanel = chaoticEraSpecialItemListBlock.FindChildInLayoutFile("ArtifactPanel");

const PauseTimeLabel =  PauseTaskPanel.FindChildInLayoutFile("itemTime_Label");
const PauseTimeOverlay =  PauseTaskPanel.FindChildInLayoutFile("itemTime_Overlay");

// 资源存量
const EvolutionChance = chaoticEra_ShopSpecialButton.FindChildInLayoutFile("resourceList").FindChildInLayoutFile("EvolutionChance");
const UpgradeChance = chaoticEra_ShopSpecialButton.FindChildInLayoutFile("resourceList").FindChildInLayoutFile("UpgradeChance");
// const SellChance = chaoticEra_ShopSpecialButton.FindChildInLayoutFile("resourceList").FindChildInLayoutFile("SellChance");

const ArtifactList = $("#ArtifactList");




let chaoticEraShopData;
let itemTypeList = {};
let gameModInit = false;
Update();
function Update() {
    let playerID = Game.GetLocalPlayerID()
    let pass = false;
    if(playerID==-1){
        pass = true;
    }
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
    // 注意 对于非玩家皆为-1
    queryUnit_PlyaerID = Entities.GetPlayerOwnerID( queryUnit);
    if(Players.GetTeam( playerID )==Players.GetTeam( queryUnit_PlyaerID ) ){
        pass = true;
    }
    if(queryUnit_PlyaerID==-1){
        pass = false;
    }
    if(pass){
        gameShopOpenButton.SetDialogVariable("value",Players.GetGold( queryUnit_PlyaerID ));
    }else{
        gameShopOpenButton.SetDialogVariable("value","?");

    }
    {
        // check item
        let selfGold = Players.GetGold( playerID );
        for (const key in itemTypeList) {
            if (Object.hasOwnProperty.call(itemTypeList, key)) {
                const itemList = itemTypeList[key].FindChildInLayoutFile("itemListBlock").Children();

                for (let index = 0; index < itemList.length; index++) {
                    const element = itemList[index];
                    if (element.cost>selfGold) {
                        element.FindChildInLayoutFile("buyCostLabel").SetHasClass("deficit", true);
                    }else{
                        element.FindChildInLayoutFile("buyCostLabel").SetHasClass("deficit", false);
                    }
                    // $.Msg(element.cost);
                    
                }
                
            }
        }
    }


    $.Schedule( 0.03, Update );
}



function OpenGameShop() {
   
    if (chaoticEraShopData) {
        gameShop_chaoticEraRoot.ToggleClass("show");
    }else{
        gameShopPanelRoot.ToggleClass("show");
    }
}

// function CreateRandomHotKey_OpenShop(hotkey){
//     let key = hotkey;
//     const command = `On${key}${Date.now()}`;
//     Game.CreateCustomKeyBind(key, `+${command}`);
//     Game.AddCommand(
//         `+${command}`,
//         () => {
//             OpenGameShop();
//             // key down callback
//         },
//         ``,
//         1 << 32
//     );
//     Game.AddCommand(
//         `-${command}`,
//         () => {
//             // key up callback
//         },
//         ``,
//         1 << 32
//     );
// }


const sPauseCommand = "toggle_shop" + Date.now();
Game.AddCommand(sPauseCommand, () => {
    OpenGameShop();
}, "desc", 0);
Game.CreateCustomKeyBind(Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_SHOP_TOGGLE), sPauseCommand);




function Init(shop_type) {
    
    if (shop_type==1) {
        let KV = GameUI.CustomUIConfig().GameShop_General_KV;

        itemListPanel.RemoveAndDeleteChildren();
        
        for (const key in KV) {
            if (Object.hasOwnProperty.call(KV, key)) {
                const element = KV[key];
                // $.Msg(element);
                if (itemTypeList[element.type]==null) {
                    let newPanel = $.CreatePanel("Panel", itemListPanel, "itemType_" + element.type);
                    newPanel.BLoadLayoutSnippet("itemList"); //载入模块
                    newPanel.SetDialogVariable("itemType",$.Localize("#HUD_GAME_SHOP_Item_type_"+element.type));
                    itemTypeList[element.type] = newPanel;
                }
    
                {
                    let target = itemTypeList[element.type].FindChildInLayoutFile("itemListBlock");
                    let newPanel = $.CreatePanel("Panel", target, "item_" + key);
                    newPanel.BLoadLayoutSnippet("singleShopItem"); //载入模块
                    newPanel.SetDialogVariable("cost",element.cost);
                    newPanel.cost = element.cost;
                    newPanel.FindChildInLayoutFile("singleItem").itemname = key;

                    AddItemBuyEvent(newPanel.FindChildInLayoutFile("singleItem"),key);
                }
                
            }
        }

        $("#shop_disable").FindChildInLayoutFile("center_message_label").text = $.Localize("#DOTA_HUD_Game_Shop_state_2");
    }





  
}

function AddItemBuyEvent(targetPanel,itemname) {
    targetPanel.SetPanelEvent("oncontextmenu", function () {
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            itemname : itemname
        }

        GameEvents.SendCustomGameEventToServer("TryBuyItem_GameShop",  event_data );
    });

    targetPanel.SetPanelEvent("onactivate", function () {
    });
}



let playerArtifact;
function UpdateCommonNetTable(tableName, tableKeyName, table) {
	var localPlayerID = Players.GetLocalPlayer();

	if (Players.IsSpectator(localPlayerID)) {
        // 如果是观战的情况下就把切换ID到点击的单位身上
		localPlayerID = -1;
		if (Players.GetLocalPlayerPortraitUnit() != -1) {
			localPlayerID = Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit());
		}
	}
    if (table==null) {
        return;
    }

    if (tableKeyName=="hd_game_mode") {
        if (table.game_shop_type!=-1) {
            if (!gameModInit) {
                gameModInit = true;
                Init(table.game_shop_type);
            }
            
        }
    }
    if (tableKeyName == "game_round") {
        // configData
        let game_round =Math.floor( Number(table.value));
        // $.Msg("game_round=",game_round)
        if (game_round>=1) {
            $("#shop_disable").SetHasClass("hide",true);
        }
        

    }
    if (tableKeyName=="chaoticEra_ShopConfig") {
        UpdateGameShop(table);
    }

    if (tableKeyName=="chaoticEra_playerShopItem") {
        playerShopItemData = table;
        UpdateGameShopItem();
    }
    if (tableKeyName=="chaoticEra_artifact") {
        playerArtifact = table;
        UpdateArtifact();
    }
    if (tableKeyName=="chaoticEra_playerPotionBag") {
        potionData = table;
        UpdatePlayerPotionBag();
    }
}




let firstInit = false;
function UpdateGameShop(table) {
    gameShopPanelRoot.SetHasClass("show",false);
    // $.Msg(table);
    if (table) {
        chaoticEraShopData = table;
    }
    if (!firstInit) {
        firstInit = true;
        GameEvents.Subscribe("dota_player_update_selected_unit", PortraitUnitChanged);
	    GameEvents.Subscribe("dota_player_update_query_unit", PortraitUnitChanged);
        UpdateChaoticEraShop();
        SetUpDefaultSpecialCharge();
        
    }

    // let playerID = Game.GetLocalPlayerID()
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (playerID==-1) {
        playerID = Game.GetLocalPlayerID();
        if (playerID==-1) {
            return;
        }
    }
    let data = chaoticEraShopData.playerShop[playerID];
    if (data) {
        let currentLevel = data.currentLevel;
        let currentExp = data.currentExp;
        if (currentLevel>=chaoticEraShopData.chaoticEraShopMaxLevel) {
            // 已经是最大等级了
            // TODO:特殊处理
            ChaoticEraButton_UpgrateShop.FindChildInLayoutFile("UpgradeProgress_PieChart_CircleBar").value =100;
            ChaoticEraButton_UpgrateShop.SetDialogVariable("level",currentLevel);
            ChaoticEraButton_UpgrateShop.FindChildInLayoutFile("chaoticEraShopUpgradeCost").SetHasClass("hidden",true);
            ChaoticEraButton_UpgrateShop.FindChildInLayoutFile("chaoticEraShopUpgrade_exp").SetHasClass("hidden",true);
            
            // chaoticEraShopUpgradeCost

        }else{
            ChaoticEraButton_UpgrateShop.SetDialogVariable("current",currentExp);
            ChaoticEraButton_UpgrateShop.SetDialogVariable("require",chaoticEraShopData.Chaotic_Era_Shop_ExpRequire[currentLevel]);
            ChaoticEraButton_UpgrateShop.SetDialogVariable("value",data.Chaotic_Era_Shop_UpgradeCost);
            ChaoticEraButton_UpgrateShop.SetDialogVariable("level",currentLevel);
            ChaoticEraButton_UpgrateShop.FindChildInLayoutFile("UpgradeProgress_PieChart_CircleBar").value = currentExp/chaoticEraShopData.Chaotic_Era_Shop_ExpRequire[currentLevel]*100;
            ChaoticEraButton_UpgrateShop.FindChildInLayoutFile("chaoticEraShopUpgradeCost").SetHasClass("hidden",false);
            ChaoticEraButton_UpgrateShop.FindChildInLayoutFile("chaoticEraShopUpgrade_exp").SetHasClass("hidden",false);
            
        }
        ChaoticEraButton_RefreshShop.SetDialogVariable("refreshShopCost",data.refreshShopCost+data.refreshShopCost_Step * data.currentShopRefreshCount);
        // ChaoticEraButton_RefreshTask.SetDialogVariable("refreshTaskCost",data.refreshTaskCost+data.refreshTaskCost_Step * data.currentTaskRefreshCount);

        {

            BuySpellPanel.SetDialogVariable("charge",data.currentbuySpellCharge);
            BuySpellPanel.SetDialogVariable("cost",data.buySpellCost+data.buySpellCost_Step * data.currentBuyCount);
        }

        {
            TaskRefreshPanel.SetDialogVariable("charge",data.currentTaskRefreshCharge);
            // TaskRefreshPanel.SetDialogVariable("cost",data.EvolutionCost+data.EvolutionCost_Step * data.currentEvolutionBuyCount);
  
            TaskRefreshPanel.SetDialogVariable("cost",data.refreshTaskCost+data.refreshTaskCost_Step * data.currentBuyCount);
        
        }
        {
            EvolutionPanel.SetDialogVariable("charge",data.currentEvolutionCharge);
            // EvolutionPanel.SetDialogVariable("cost",data.refreshTaskCost+data.refreshTaskCost_Step * data.currentBuyCount);
            EvolutionPanel.SetDialogVariable("cost",data.EvolutionCost+data.EvolutionCost_Step * data.currentEvolutionBuyCount);
            // EvolutionPanel.SetDialogVariable("max",chaoticEraShopData.max_charge.evolution);
            EvolutionChance.SetDialogVariable("value",data.currentEvolutionCount);
        
        }

        {
                    
            UpgradePanel.SetDialogVariable("charge",data.currentUpgradeCharge);
        
            UpgradePanel.SetDialogVariable("cost",data.UpgradeCost+data.UpgradeCost_Step * data.currentUpgradeBuyCount);
            UpgradeChance.SetDialogVariable("value",data.currentUpgradeCount);
        


        }
        // {
        //     SellPanel.SetDialogVariable("charge",data.currentSellCharge);
        //     SellPanel.SetDialogVariable("cost",data.SellCost+data.SellCost_Step * data.currentSellBuyCount);
        //     SellChance.SetDialogVariable("value",data.currentSellCount);
        
        // }
        {
            ArtifactPanel.SetDialogVariable("charge",data.currentArtifactCharge);
            ArtifactPanel.SetDialogVariable("cost",data.ArtifactCost+data.ArtifactCost_Step * data.currentArtifactBuyCount);
 
        }

        
        {
            // 延迟征召
            // $.Msg(chaoticEraShopData.DelayTask);
            let time = Game.GetGameTime();
            if (time<chaoticEraShopData.DelayTask.timer) {
                PauseTimeLabel.SetHasClass("hide",false);
                PauseTimeOverlay.SetHasClass("hide",false);
                CheckingPauseProgress(chaoticEraShopData.DelayTask);
                
            }else{
                PauseTimeLabel.SetHasClass("hide",true);
                PauseTimeOverlay.SetHasClass("hide",true);
                
        
            }
        }
        // {
        //     ArtifactList.RemoveAndDeleteChildren();
        
        // }

        

    }else{
        ChaoticEraButton_UpgrateShop.SetDialogVariable("current","?");
        ChaoticEraButton_UpgrateShop.SetDialogVariable("require","?");
        ChaoticEraButton_UpgrateShop.SetDialogVariable("value","?");
        ChaoticEraButton_UpgrateShop.SetDialogVariable("level","?");
        ChaoticEraButton_UpgrateShop.FindChildInLayoutFile("UpgradeProgress_PieChart_CircleBar").value = 100;
        
        ChaoticEraButton_RefreshShop.SetDialogVariable("refreshShopCost","?");
        // ChaoticEraButton_RefreshTask.SetDialogVariable("refreshTaskCost","?");


        TaskRefreshPanel.SetDialogVariable("charge","?");
        TaskRefreshPanel.SetDialogVariable("cost","?");
        BuySpellPanel.SetDialogVariable("charge","?");
        BuySpellPanel.SetDialogVariable("cost","?");


        EvolutionPanel.SetDialogVariable("charge","?");
        EvolutionPanel.SetDialogVariable("cost","?");
        EvolutionChance.SetDialogVariable("value","?");

        UpgradePanel.SetDialogVariable("charge","?");
        UpgradePanel.SetDialogVariable("cost","?");
        UpgradeChance.SetDialogVariable("value","?");
    
        // SellPanel.SetDialogVariable("charge","?");
        // SellPanel.SetDialogVariable("cost","?");
        // SellChance.SetDialogVariable("value","?");
        ArtifactList.RemoveAndDeleteChildren();
        
    
    }


}

let playerShopItemData;
// 更新玩家商店
function UpdateGameShopItem() {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (playerShopItemData) {
      
        if (playerID==-1) {
            playerID = Game.GetLocalPlayerID();
            if (playerID==-1) {
                return;
            }
        }
        chaoticEraItemListBlock.RemoveAndDeleteChildren();
        let dataList = playerShopItemData[playerID];
        if (dataList) {
            // $.Msg(dataList);
            
            for (const key in dataList) {
                if (Object.hasOwnProperty.call(dataList, key)) {
                    const element = dataList[key];
                    $.Msg(element);
            
                    
                    let newPanel = $.CreatePanel("Panel", chaoticEraItemListBlock, "item_" + element.item_name);
                    newPanel.BLoadLayoutSnippet("singleShopItem"); //载入模块
                    newPanel.SetDialogVariable("cost",element.cost);
                    newPanel.cost = element.cost;
                    
                    if (element.enable==1) {
                        
                    }else{
                        newPanel.SetHasClass("disable",true);
                    }
                    // 买完了也让发送信息 但是会提示卖完了
                
                    let lockButton = newPanel.FindChildInLayoutFile("itemLockButton");
                    lockButton.SetHasClass("show",true);
                    // $.Msg(element);
                    if (element.lock==1) {
                        lockButton.SetHasClass("lock",true);
                    }
                    LockItemEvent(lockButton,element.item_name)

                    if (element.isPotion) {
                        newPanel.SetHasClass("useImage",true);

                        // newPanel.FindChildInLayoutFile("potionImage").SetImage("file://{images}/custom_game/potion/"+element.item_name +".png");
                        let kv = GameUI.CustomUIConfig().ChaoticEraPotionKV[element.item_name];
                        if (kv&&kv.texture) {
                            newPanel.FindChildInLayoutFile("potionImage").SetImage("file://{images}/spellicons/"+kv.texture +".png");
                        // }else{
                        //     newPanel.FindChildInLayoutFile("potionImage").SetImage("file://{images}/custom_game/potion/"+element.item_name +".png");
                        }
                        newPanel.SetDialogVariable("potionCount","x"+element.count);
                        let oderList={
                            bUsePotionInfo:true,
                        }
                        AddPotionHoverEvent(newPanel,element.item_name,oderList);
                        AddItemBuyEvent_ChaoticEraShop(newPanel.FindChildInLayoutFile("potionImage"),element.item_name);

                        
                    }else{
                        newPanel.FindChildInLayoutFile("singleItem").itemname = element.item_name;
                        AddItemBuyEvent_ChaoticEraShop(newPanel.FindChildInLayoutFile("singleItem"),element.item_name);

                    }
                    // AddItemBuyEvent(newPanel.FindChildInLayoutFile("singleItem"),key);
                }
            }
        }else{
            $.Msg("找不到商店？");
        }
    }
}
function UpdateArtifact() {
    ArtifactList.RemoveAndDeleteChildren();
    if (!playerArtifact) {
        return;
    }
    // let playerID = Game.GetLocalPlayerID()
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (playerID==-1) {
        playerID = Game.GetLocalPlayerID();
        if (playerID==-1) {
            return;
        }
    }
    let data = playerArtifact[playerID];
    if (data) {

        
        {
           
            for (const key in data) {
                if (Object.hasOwnProperty.call(data, key)) {
                    const element = data[key];
                    $.Msg(element);
                    let kv =  GameUI.CustomUIConfig().ChaoticEra_Artifact[element];
                    if (kv) {
                        let newPanel = $.CreatePanel("Panel", ArtifactList, "artifact_" + element);
                        newPanel.BLoadLayoutSnippet("singleArtifact"); //载入模块
                        newPanel.FindChildInLayoutFile("singleArtifactIcon").style.backgroundImage = "url('"+ kv.image+"')";
                        let title = $.Localize("#"+element);
                        let info = $.Localize("#"+element+"_info");
                        info = ReplaceSpecialWithKV(kv["AbilityValues"],info);
                        info = ChangeAllNumberColor(info,"#caa7e9");

                        let keys ={
                            title :title,
                            text : info,
                            
                        }
                        SetBaseAdavncedInfoHoverEvent(newPanel,keys);
                        AddEvent_OnArtifactClick(newPanel,element);
    
                    }

                }
            }
        }


        

    }

}


// 检测时间
let enablePauseProgress = false;
let pauseTimer = -1;
let pauseCoolodown = 90;
function CheckingPauseProgress(data){

    if (!enablePauseProgress) {
        pauseTimer = data.timer;
        pauseCoolodown = data.cooldown;
        UpdatePauseProgress();
    }
}
function UpdatePauseProgress(){
    let time = Game.GetGameTime();
    if (time<pauseTimer) {
        let remainTime = (pauseTimer-time).toFixed(1);
        PauseTimeLabel.SetDialogVariable("time",remainTime);
        let value1 = remainTime/pauseCoolodown*360;
        PauseTimeOverlay.style.clip =  "radial( 50.0% 50.0%, 0.0deg,-"+ value1+"deg )";

        $.Schedule( 0.03, UpdatePauseProgress );
    }else{
        enablePauseProgress = false;
        PauseTimeLabel.SetHasClass("hide",true);
        PauseTimeOverlay.SetHasClass("hide",true);
    }
    // $.Schedule( 0.03, UpdatePauseProgress );
}



// 初始化特供的数据
function SetUpDefaultSpecialCharge(){
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (playerID==-1) {
        playerID = Game.GetLocalPlayerID();
        if (playerID==-1) {
            playerID = 0;
        }
    }
    let data = chaoticEraShopData.playerShop[playerID];
    if (!data) {
        // 防止本地测试创建英雄报错
        playerID = 0;
        data = chaoticEraShopData.playerShop[playerID];
    }
    {
        TaskRefreshPanel.SetDialogVariable("charge",data.currentTaskRefreshCharge);
        TaskRefreshPanel.SetDialogVariable("max",chaoticEraShopData.max_charge.refreshTask);
        
        TaskRefreshPanel.SetPanelEvent("oncontextmenu", function () {
            RefreshChaoticEraTask();
        });
        TaskRefreshPanel.SetPanelEvent("onactivate", function () {
        });

        let keys ={
            title :$.Localize("#HUD_Era_Special_RefreshTask_Title"),
            text : $.Localize("#HUD_Era_Special_RefreshTask_Info"),
            
        }
        SetBaseAdavncedInfoHoverEvent(TaskRefreshPanel,keys);
    
    }

    {
        // 暂停征召
        PauseTaskPanel.SetDialogVariable("cost",chaoticEraShopData.DelayTask.cost);
        let info = $.Localize("#HUD_Era_Special_PauseTask_Info");
        info = info.replace(('<' + 'cooldown' + '>'), chaoticEraShopData.DelayTask.cooldown.toString());
        info = info.replace(('<' + 'delayTime' + '>'), chaoticEraShopData.DelayTask.delayTime.toString());
        info = info.replace(('<' + 'levelRequire' + '>'), chaoticEraShopData.DelayTask.levelRequire.toString());
        info = ChangeAllNumberColor(info,"#caa7e9");
        let keys ={
            title :$.Localize("#HUD_Era_Special_PauseTask_Title"),
            text : info,
            
        }
        SetBaseAdavncedInfoHoverEvent(PauseTaskPanel,keys);


        PauseTaskPanel.SetPanelEvent("oncontextmenu", function () {
            var event_data = {
                player_id: Game.GetLocalPlayerID(),
            }
            GameEvents.SendCustomGameEventToServer("PauseTaskProgress",  event_data );
        });
        PauseTaskPanel.SetPanelEvent("onactivate", function () {
        });

    
        
    }
    {
        // 购买技能
        BuySpellPanel.SetDialogVariable("charge",data.currentbuySpellCharge);
        BuySpellPanel.SetDialogVariable("max",chaoticEraShopData.max_charge.buySpell);
        
        BuySpellPanel.SetPanelEvent("oncontextmenu", function () {
            BuyGenerateSpell();
        });
        BuySpellPanel.SetPanelEvent("onactivate", function () {
        });

        let keys ={
            text : $.Localize("#HUD_Era_Special_BuySpell_Info"),
            title :$.Localize("#HUD_Era_Special_BuySpell_Title"),
        }
        SetBaseAdavncedInfoHoverEvent(BuySpellPanel,keys);
    

    }
    {
        // 升阶机会
        
        EvolutionPanel.SetDialogVariable("charge",data.currentEvolutionCharge);
        EvolutionPanel.SetDialogVariable("max",chaoticEraShopData.max_charge.evolution);
        
        EvolutionPanel.SetPanelEvent("oncontextmenu", function () {
            BuyEvoluteionChance();
        });
        EvolutionPanel.SetPanelEvent("onactivate", function () {
        });

        keys ={
            text : $.Localize("#HUD_Era_Special_Evolution_Info"),
            title :$.Localize("#HUD_Era_Special_Evolution_Title"),
        }
        SetBaseAdavncedInfoHoverEvent(EvolutionPanel,keys);
    }
    {
        // 升级机会
        
        UpgradePanel.SetDialogVariable("charge",data.currentUpgradeCharge);
        UpgradePanel.SetDialogVariable("max",chaoticEraShopData.max_charge.upgrade);
        
        UpgradePanel.SetPanelEvent("oncontextmenu", function () {
            BuyUpgradeChance();
        });
        UpgradePanel.SetPanelEvent("onactivate", function () {
        });

        let keys ={
            title :$.Localize("#HUD_Era_Special_Upgrade_Title"),
            text : $.Localize("#HUD_Era_Special_Upgrade_Info"),
            
        }
        SetBaseAdavncedInfoHoverEvent(UpgradePanel,keys);
    
    }

    // {
    //     // 出售机会
        
    //     let keys ={
    //         title :$.Localize("#HUD_Era_Special_Sell_Title"),
    //         text : $.Localize("#HUD_Era_Special_Sell_Info"),
            
    //     }
    //     SetBaseAdavncedInfoHoverEvent(SellPanel,keys);
    //     SellPanel.SetDialogVariable("charge",data.currentSellCharge);
    //     SellPanel.SetDialogVariable("max",chaoticEraShopData.max_charge.sell);
        
    //     SellPanel.SetPanelEvent("oncontextmenu", function () {
    //         BuySellChance();
    //     });
    //     SellPanel.SetPanelEvent("onactivate", function () {
    //     });


    // }

    {
        // 出售机会
        let info = $.Localize("#HUD_Era_Special_Artifact_Info")
        info = info.replace(('<' + 'artifact_count' + '>'), chaoticEraShopData.Chaotic_era_artifact_count.toString());
        info = ChangeAllNumberColor(info,"#caa7e9");
        let keys ={
            title :$.Localize("#HUD_Era_Special_Artifact_Title"),
            text : info,
            
        }
        SetBaseAdavncedInfoHoverEvent(ArtifactPanel,keys);
        ArtifactPanel.SetDialogVariable("charge",data.currentArtifactCharge);
        ArtifactPanel.SetDialogVariable("max",chaoticEraShopData.max_charge.artifact);
        
        ArtifactPanel.SetPanelEvent("oncontextmenu", function () {
            BuyArtifact();
        });
        ArtifactPanel.SetPanelEvent("onactivate", function () {
        });


    }

}


function AddItemBuyEvent_ChaoticEraShop(targetPanel,itemname) {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }

    targetPanel.SetPanelEvent("oncontextmenu", function () {
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            itemname : itemname
        }
        GameEvents.SendCustomGameEventToServer("TryBuyItem_ChaoticEraShop",  event_data );
    });

    targetPanel.SetPanelEvent("onactivate", function () {
    });
}

function LockItemEvent(targetPanel,itemname) {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }


    targetPanel.SetPanelEvent("onactivate", function () {
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            itemname : itemname
        }
        GameEvents.SendCustomGameEventToServer("TryLockItem_ChaoticEraShop",  event_data );
    });
}




function UpgradeChaoticEraShop() {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }


    // $.Msg("send upgrade");
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("UpgradeChaoticEraShop",  event_data );
}


function RefreshChaoticEraShop() {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("RefreshChaoticEraShop",  event_data );
}

function RefreshChaoticEraTask() {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("RefreshChaoticEraTask",  event_data );
}



function BuyGenerateSpell() {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("BuyGenerateSpell",  event_data );
}

function BuyEvoluteionChance(){
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("BuyEvoluteionChance",  event_data );
}
function BuyUpgradeChance(){
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("BuyUpgradeChance",  event_data );
}
function BuySellChance(){
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("BuySellChance",  event_data );
}

function BuyArtifact(){
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    let playerID = Entities.GetPlayerOwnerID( queryUnit);
    if (Game.GetLocalPlayerID()!=playerID) {
        // 不是看自己那就不发送了
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("BuyArtifact",  event_data );
}

function UpdateChaoticEraShop() {
    let playerID = Game.GetLocalPlayerID()
    {
        // check item

        let selfGold = Players.GetGold( playerID );
        let list = chaoticEraItemListBlock.Children();
        for (let index = 0; index < list.length; index++) {
            const element = list[index];
            if (element.cost>selfGold) {
                element.FindChildInLayoutFile("buyCostLabel").SetHasClass("deficit", true);
            }else{
                element.FindChildInLayoutFile("buyCostLabel").SetHasClass("deficit", false);
            }
            
        }
    }


    $.Schedule( 0.03, UpdateChaoticEraShop );
}


function PortraitUnitChanged() {
    UpdateGameShop();
    UpdateGameShopItem();
    UpdatePlayerPotionBag();
    UpdateArtifact();
}
function CloaseChaoticEraShop() {
    gameShop_chaoticEraRoot.SetHasClass("show",false);
}





function AddEvent_OnArtifactClick(targetPanel,artifactName)
{
    targetPanel.SetPanelEvent("onactivate", function () {
        var queryUnit = Players.GetLocalPlayerPortraitUnit();
        let playerID = Entities.GetPlayerOwnerID( queryUnit);
        if (playerID!=-1) {
            var bAltDown = GameUI.IsAltDown();
            var event_data = {
                player_id: Game.GetLocalPlayerID(),
                targetPlayerID :playerID,
                artifactName:artifactName,
                bAltDown:bAltDown,
            }
            GameEvents.SendCustomGameEventToServer("OnArtifactClicked", event_data);
        }
    });




}










(function () {


    CustomUIConfig.SubscribeNetTableListener("game_config", UpdateCommonNetTable);
	UpdateCommonNetTable("game_config", "hd_game_mode", CustomNetTables.GetTableValue("game_config", "hd_game_mode"));

	UpdateCommonNetTable("game_config", "game_round", CustomNetTables.GetTableValue("game_config", "game_round"));
    
	UpdateCommonNetTable("game_config", "chaoticEra_ShopConfig", CustomNetTables.GetTableValue("game_config", "chaoticEra_ShopConfig"));
    
    UpdateCommonNetTable("game_config", "chaoticEra_playerShopItem", CustomNetTables.GetTableValue("game_config", "chaoticEra_playerShopItem"));

    UpdateCommonNetTable("game_config", "chaoticEra_playerPotionBag", CustomNetTables.GetTableValue("game_config", "chaoticEra_playerPotionBag"));
    UpdateCommonNetTable("game_config", "chaoticEra_artifact", CustomNetTables.GetTableValue("game_config", "chaoticEra_artifact"));

    
    GameEvents.Subscribe("CloaseChaoticEraShop", CloaseChaoticEraShop);  //收到可出售技能列表反馈

    CreateRandomHotKey_OpePotionBag("F2");
    // CreateRandomHotKey_OpenShop("F4");

})();