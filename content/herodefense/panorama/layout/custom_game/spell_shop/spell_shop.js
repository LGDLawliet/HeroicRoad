var CustomUIConfig = GameUI.CustomUIConfig();

var SpellsShopMenuwindowROOTPanel = $("#SpellsShopMenuwindowROOT");
// SpellsShopMenuwindowROOTPanel.SetHasClass("Visible", false);
var customSpellsMenuPanel = $("#SpellsWindowPanel");  //上面
var SpellsinfoWindowPanel = $("#SpellsinfoWindowPanel"); //下面

var SpellsMysteryWindowPanel = $("#SpellsMysteryWindowPanel");
SpellsMysteryWindowPanel.SetHasClass("Visible", false);

let ChaoticEraMod = false;


var spellSwapFirstSelected = null;
var spellSwapSecondSelected = null;  //用于技能移动
var freeSpell = {};
let currentOpenSpellclass = 0;  //当前打开的技能商店类型

var SpellsShopMenuClose = $("#SpellsShopMenuClose");

SpellsShopMenuClose.SetPanelEvent("onactivate", function () {
    CloseSpellsShopMenuwindow();
});
// 打开技能商店
var settingStatus = false;
function OpenSpellsShop(){
    Game.EmitSound( "ui.treasure_count" );
    settingStatus = true;
    SpellsShopMenuwindowROOTPanel.SetHasClass("Show", settingStatus);
    if(!ChaoticEraMod){
        OpenSpellsUpgradeListingForPlayerHero();
    }
 
}
//关闭技能商店
function CloseSpellsShopMenuwindow() {
    $.Msg("aaaaaa");
    Game.EmitSound( "ui.treasure_unlock.wav" );
    settingStatus = false;
    SpellsShopMenuwindowROOTPanel.SetHasClass("Show", settingStatus);
}

// var IsshopOpening = false

function OnTestButtonPressed(){
    if(settingStatus==true){
        CloseSpellsShopMenuwindow();
    }else{
        OpenSpellsShop();
    }
}


var PhysicalSpellsButton = $("#PhysicalSpellsButton");
var MagicalSpellsButton = $("#MagicalSpellsButton");
var SummonSpellsButton = $("#SummonSpellsButton");
var DefenseSpellsButton = $("#DefenseSpellsButton");
var AssistSpellsButton = $("#AssistSpellsButton");
var OtherSpellsButton = $("#OtherSpellsButton");


function OpenPhysicalSpellsMenu() { 
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", true);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    OpenSpellsMenu(0);
    // $("#SpellMemuPostGameBG").style.hueRotation="240deg"; 
    // $("#SpellMemuPostGameBG2").style.hueRotation="240deg"; 

}//展开物理技能
function OpenMagicalSpellsMenu() {  
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", true);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    OpenSpellsMenu(1);
    // $("#SpellMemuPostGameBG").style.hueRotation="50deg"; 
    // $("#SpellMemuPostGameBG2").style.hueRotation="50deg"; 
}//展开魔法技能
function OpenSummonSpellsMenu() {
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", true);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
      OpenSpellsMenu(2);
    //   $("#SpellMemuPostGameBG").style.hueRotation="260deg"; 
    //   $("#SpellMemuPostGameBG2").style.hueRotation="260deg"; 
    }//展开召唤技能
function OpenDefenseSpellsMenu() {
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", true);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    OpenSpellsMenu(3);
    // $("#SpellMemuPostGameBG").style.hueRotation="120deg"; 
    // $("#SpellMemuPostGameBG2").style.hueRotation="120deg"; 
}//展开防御技能
function OpenAssistSpellsMenu() {  
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", true);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    OpenSpellsMenu(4);
    // $("#SpellMemuPostGameBG").style.hueRotation="340deg"; 
    // $("#SpellMemuPostGameBG2").style.hueRotation="340deg"; 
}//展开辅助技能
function OpenOtherSpellsMenu() {  
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", true);
    // $("#SpellMemuPostGameBG").style.hueRotation="790deg"; 
    // $("#SpellMemuPostGameBG2").style.hueRotation="790deg"; 
    OpenSpellsMenu(5);
}//展开其他技能

//展开技能列表

let spellList = [
    GameUI.CustomUIConfig().SpellShop_PhysicalKV,
    GameUI.CustomUIConfig().SpellShop_MagicalKV,
    GameUI.CustomUIConfig().SpellShop_SummonKV,
    GameUI.CustomUIConfig().SpellShop_DefenseKV,
    GameUI.CustomUIConfig().SpellShop_AssistKV,
    GameUI.CustomUIConfig().SpellShop_OtherKV,
]


function OpenSpellsMenu(spellclass) {
    currentOpenSpellclass = spellclass;
    Game.EmitSound( "ui_hero_select_slide" );
    customSpellsMenuPanel.RemoveAndDeleteChildren();  //先清除

    var spellsContainer = customSpellsMenuPanel;

    // $.Msg(spellList[0]);
    let i = 0;
    for (const spell_id in spellList[spellclass]) {
        if (Object.hasOwnProperty.call(spellList[spellclass], spell_id)) {
            const individualHeroSpell = spellList[spellclass][spell_id];
            spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
            spellPanel.BLoadLayoutSnippet("spell"); //载入模块



            var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
            var name =  spell_id.replace("Primary", 'Advanced');
            if (ChaoticEraMod && spell_id!="for_swap_spells") {
                spellPanel.SetHasClass("onChaoticEraMode",true);
                spellCost.text ="";
                spellPanel.FindChildInLayoutFile("SpellCostorReturn").text = $.Localize("#HUD_DISABLED");
                
            }else{
                spellCost.text = individualHeroSpell.cost;

                var spellButton_outside = spellPanel.FindChildInLayoutFile("SingleSpellPanel_id");
                if(freeSpell[name]){
                    spellButton_outside.SetHasClass("freeSpell", true);
                }else if(individualHeroSpell.Recommended){

                    spellPanel.FindChildInLayoutFile("Recommended_icon").SetHasClass("show", true);
    
                }else{
                    spellButton_outside.SetHasClass("normalSpell", true);
                }
            }
            var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
            image.abilityname = spell_id;
            var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
            var spellStringified = JSON.stringify(individualHeroSpell);
            
            addSpellBuyEvens(spellButton,spell_id,spellclass);
            i++;
        }
    }


    // var spellPanel;
    // $.Msg(XPTable);
    // for (var i = 0; i < spells[spellclass].length; i++) {
    //     // $.Msg(spells[spellclass][i])
    //     if (spells[spellclass][i]) {
    //         var individualHeroSpell = spells[spellclass][i];
    //         spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
    //         spellPanel.BLoadLayoutSnippet("spell"); //载入模块
    //         var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
    //         image.abilityname = individualHeroSpell.spell_id;
    //         var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
    //         spellCost.text = individualHeroSpell.cost;
   
    //         var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
    //         var spellStringified = JSON.stringify(individualHeroSpell);
    //         // $.Msg(individualHeroSpell.spell_id);
    //         var name =  individualHeroSpell.spell_id.replace("Primary", 'Advanced');
    
    //         var spellButton_outside = spellPanel.FindChildInLayoutFile("SingleSpellPanel_id");
    //         if(freeSpell[name]){
    //             // var spellButton_outside = spellPanel.FindChildInLayoutFile("SingleSpellPanel_id");
    //             // $.Msg(spellButton_outside);
    //             spellButton_outside.SetHasClass("freeSpell", true);
    //             // spellButton.SetHasClass("freeSpell", true);
    //         }else if(individualHeroSpell.Recommended){
              
    //             spellButton_outside.SetHasClass("Recommended", true);
    //             // $.Msg(spellButton_outside);
    //             // spellButton.SetHasClass("Recommended", true);

    //         }else{
    //             spellButton_outside.SetHasClass("normalSpell", true);
    //         }

   
    //         addSpellBuyEvens(spellButton,spellStringified,individualHeroSpell.spell_id);


    //     }
      
    // }
}
function addSpellBuyEvens(spellButton,spellName,spellclass) {
    // spellButton.SetPanelEvent("onactivate", Function("BuySpell(\'" + spellStringified + "\')"));
    spellButton.SetPanelEvent("onactivate", function () {
        BuySpell(spellName,spellclass);
    });

    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,spellName);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });
    // spellButton.style.tooltipPosition = "top";
    // spellButton.style.tooltipBodyPosition = "50% 50%";
    spellButton.SetHasClass("myhero_spellimage",true)
}



//关闭下方技能列表
function CloseSpellsListingForHero() {
    // Clear children
    SpellsinfoWindowPanel.RemoveAndDeleteChildren();
}

function OpenSpellsListingForPlayerHero() {
    SpellsMenuUpgradeSpellsButton.SetHasClass("functionButton_on", false);
    SpellsMenuSwapSpellsButton.SetHasClass("functionButton_on", true);
    SpellsMenuSellSpellsButton.SetHasClass("functionButton_on", false);
    var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("spells_menu_get_player_spells", event_data);
}
function BuySpell(spellName,spellclass) {
    // var spellObj = JSON.parse(spellJson);
    let data ={
        spellName : spellName,
        spellclass :spellclass,
        player_id: Game.GetLocalPlayerID(),
    }
    // spellObj.player_id = Game.GetLocalPlayerID();
    GameEvents.SendCustomGameEventToServer("spells_menu_buy_spell", data);
}

function RefreshSellPlayerSpellsFeedback() {
    OpenSpellsSellListingForPlayerHero()
}
function RefreshupgradePlayerSpellsFeedback() {
    OpenSpellsUpgradeListingForPlayerHero()
}
var SpellsMenuUpgradeSpellsButton = $("#SpellsMenuUpgradeSpellsButton");
var SpellsMenuSwapSpellsButton = $("#SpellsMenuSwapSpellsButton");
var SpellsMenuSellSpellsButton = $("#SpellsMenuSellSpellsButton");

//打开可升级的技能列表
function OpenSpellsUpgradeListingForPlayerHero() {
    SpellsMenuUpgradeSpellsButton.SetHasClass("functionButton_on", true);
    SpellsMenuSwapSpellsButton.SetHasClass("functionButton_on", false);
    SpellsMenuSellSpellsButton.SetHasClass("functionButton_on", false);
    var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("spells_menu_get_player_spells_by_classlevel", event_data);
}

//打开可出售的技能列表
function OpenSpellsSellListingForPlayerHero() {
    SpellsMenuUpgradeSpellsButton.SetHasClass("functionButton_on", false);
    SpellsMenuSwapSpellsButton.SetHasClass("functionButton_on", false);
    SpellsMenuSellSpellsButton.SetHasClass("functionButton_on", true);
    var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("Sellspells_menu_get_player_spells_by_classlevel", event_data);
}

//打开可出售的技能列表


//由上面的gameevents链接  收到lua的反馈后  调用技能ui界面
function UpgradePlayerSpellsFeedback(event_data) {
    // show spells
    //首先需要找到显示技能的画布
    var playerHeroSpellsContainer = SpellsinfoWindowPanel;
    // Clear children
    //情况之前存在的技能
    CloseSpellsListingForHero();

    // $.Msg(event_data);

    var heroSpells = event_data.player_abilities[1];
    var spellsCost = event_data.player_abilities[2];
    var nextSpells = event_data.player_abilities[3];
    if (!heroSpells.hasOwnProperty(1)) { //说明没有任意符合条件的技能 给出提示即可 提示作为技能展出
        var individualHeroSpellName = "none_spells_info"
        spellPanel = $.CreatePanel("Panel", playerHeroSpellsContainer, "spellPanel" + 0);
        spellPanel.BLoadLayoutSnippet("spell");
        var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage"); //图片画布
        image.abilityname = individualHeroSpellName;
        var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
        spellCost.text = 0;  //设置开销
        var spellButton_outside = spellPanel.FindChildInLayoutFile("SingleSpellPanel_id");
        spellButton_outside.SetHasClass("normalSpell", true);
      
 
        var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
        // Hover events
        spellButton.SetPanelEvent("onmouseover", function () {
            $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,"none_spells_info");
        });
        // spellButton.SetPanelEvent("onmouseover", Function("$.DispatchEvent( \"DOTAShowAbilityTooltip\", \"" + "none_spells_info" + "\")"));
        spellButton.SetPanelEvent("onmouseout", function () {
            $.DispatchEvent("DOTAHideAbilityTooltip");
        });
        
        return;};


    var spellPanel;
    for (var key in heroSpells) { //这里key是一个下标 从1开始
        //hasOwnProperty() 方法会返回一个布尔值，指示对象自身属性中是否具有指定的属性（也就是，是否有指定的键）
        if (heroSpells.hasOwnProperty(key)) {
            var individualHeroSpellName = heroSpells[key]; //获取到技能名
            // var newChildPanel = $.CreatePanel( "Panel", parentPanel, "ChildPanelID" );
            //parentpanel 放在指定的这个父类画布的里面  后面是画布ID 为 例子"spellPanelPrimary_Berserkers"
            spellPanel = $.CreatePanel("Panel", playerHeroSpellsContainer, "spellPanel" + key);

            //添加到spell snippet段
            spellPanel.BLoadLayoutSnippet("spell");

            var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage"); //图片画布
            var spellButton_outside = spellPanel.FindChildInLayoutFile("SingleSpellPanel_id");
            spellButton_outside.SetHasClass("normalSpell", true);
          
            image.abilityname = individualHeroSpellName;
            var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
            spellCost.text = spellsCost[key];  //设置开销
            var key_index = nextSpells[key]
            var advanced = false;
            var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
            if (individualHeroSpellName==key_index) { //两个技能名一样说明是高阶技能
                // $.Msg("一样"+individualHeroSpellName);
                advanced = true
            }
            addSpellUpgradeEvens(spellButton,individualHeroSpellName,key_index,advanced);
        }
    }
}






//由上面的gameevents链接  收到lua的反馈后  调用技能ui界面
function SellPlayerSpellsFeedback(event_data) {
    // show spells
    //首先需要找到显示技能的画布
    var playerHeroSpellsContainer = SpellsinfoWindowPanel;
    // Clear children
    //情况之前存在的技能
    CloseSpellsListingForHero();


    var heroSpells = event_data.player_abilities[1];
    var spellsCost = event_data.player_abilities[2];

    if (!heroSpells.hasOwnProperty(1)) { //说明没有任意符合条件的技能 给出提示即可 提示作为技能展出
        var individualHeroSpellName = "none_spells_info"
        spellPanel = $.CreatePanel("Panel", playerHeroSpellsContainer, "spellPanel" + 0);
        spellPanel.BLoadLayoutSnippet("spell");
        var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage"); //图片画布
        var spellButton_outside = spellPanel.FindChildInLayoutFile("SingleSpellPanel_id");
        spellButton_outside.SetHasClass("normalSpell", true);
      
        image.abilityname = individualHeroSpellName;
        var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
        spellCost.text = 0;  //设置开销
        var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
        // Hover events
        // spellButton.SetPanelEvent("onmouseover", Function("$.DispatchEvent( \"DOTAShowAbilityTooltip\", \"" + "none_spells_info" + "\")"));
        spellButton.SetPanelEvent("onmouseover", function () {
            $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,"none_spells_info");
        });
        spellButton.SetPanelEvent("onmouseout", function () {
            $.DispatchEvent("DOTAHideAbilityTooltip");
        });
        
        return;};


    var spellPanel;
    for (var key in heroSpells) { //这里key是一个下标 从1开始
        //hasOwnProperty() 方法会返回一个布尔值，指示对象自身属性中是否具有指定的属性（也就是，是否有指定的键）
        if (heroSpells.hasOwnProperty(key)) {
            var individualHeroSpellName = heroSpells[key]; //获取到技能名
            // var newChildPanel = $.CreatePanel( "Panel", parentPanel, "ChildPanelID" );
            //parentpanel 放在指定的这个父类画布的里面  后面是画布ID 为 例子"spellPanelPrimary_Berserkers"
            spellPanel = $.CreatePanel("Panel", playerHeroSpellsContainer, "spellPanel" + key);

            //添加到spell snippet段
            spellPanel.BLoadLayoutSnippet("spell");

            var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage"); //图片画布
            var spellButton_outside = spellPanel.FindChildInLayoutFile("SingleSpellPanel_id");
            spellButton_outside.SetHasClass("normalSpell", true);
          
            image.abilityname = individualHeroSpellName;
            var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
            spellCost.text = spellsCost[key];  //设置开销
            var spellCost = spellPanel.FindChildInLayoutFile("SpellCostorReturn");
            spellCost.text = $.Localize("#DOTA_HUD_Spells_Menu_Spell_Cost_return");  //设置文本
            var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
            addSpellSellEvens(spellButton,individualHeroSpellName);
    
        }
    }
}

function addSpellSellEvens(spellButton,individualHeroSpellName) {
    // spellButton.SetPanelEvent("onactivate", Function("SpellSellSelect(\'" + individualHeroSpellName + "\')"));
    spellButton.SetPanelEvent("onactivate", function () {
        SpellSellSelect(individualHeroSpellName);
    });
    // Hover events
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,individualHeroSpellName);
    });
    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });

}






//出售该技能
function SpellSellSelect(spellName) {
    selltarget = spellName;
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        sell: selltarget,
  };

    GameEvents.SendCustomGameEventToServer("spells_menu_sell_player_spells", event_data);

}






function UpdateCameraDIS(event_data) {

    var dis = event_data.dis;
    GameUI.SetCameraLookAtPositionHeightOffset(dis)

}



function SellSpellsSelect(spellName) {

    // var playerID = Game.GetLocalPlayerID();
    // var event_data = {
    //     player_id: playerID,
    //     ability_name: sellspellselected,
    //     spellCost: spellcost
    // };
    // GameEvents.SendCustomGameEventToServer("spells_menu_sell_player_spells", event_data);
    // sellspellselected = spellName;
    var spellObj = JSON.parse(spellJson);
    spellObj.player_id = Game.GetLocalPlayerID();
    GameEvents.SendCustomGameEventToServer("spells_menu_buy_spell", spellObj);
}

function GetPlayerSpellsFeedback(event_data) {
    // show spells
    var playerHeroSpellsContainer = SpellsinfoWindowPanel;
    // Clear children
    CloseSpellsListingForHero();
    // var playerHeroSpellsContainer  =customSpellsMenuPanel;
    
    var heroSpells = event_data.player_abilities;
    var spellPanel;
    // $.Msg(heroSpells);
    for (var key in heroSpells) {
        if (heroSpells.hasOwnProperty(key) ) {
            var individualHeroSpellName = heroSpells[key];
            // 不显示默认技能
            if (individualHeroSpellName!="Default_Move") {
                spellPanel = $.CreatePanel("Panel", playerHeroSpellsContainer, "spellPanel" + key);
                spellPanel.BLoadLayoutSnippet("spell");

                var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
                var spellButton_outside = spellPanel.FindChildInLayoutFile("SingleSpellPanel_id");
                spellButton_outside.SetHasClass("normalSpell", true);
              
                image.abilityname = individualHeroSpellName;
                var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
                spellCost.text = "0";

                var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
                addSpellSwapEvens(spellButton,individualHeroSpellName);
            }
            
        }
    }
}

function addSpellSwapEvens(spellButton,individualHeroSpellName) {
    // spellButton.SetPanelEvent("onactivate", Function("SpellSwapSelect(\'" + individualHeroSpellName + "\')"));
    spellButton.SetPanelEvent("onactivate", function () {
        SpellSwapSelect(individualHeroSpellName);
    });
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,individualHeroSpellName);
    });
    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });

}




function SpellSwapSelect(spellName) {
    if (spellSwapFirstSelected != null) {
        spellSwapSecondSelected = spellName;

        var playerID = Game.GetLocalPlayerID();
        var event_data = {
            player_id: playerID,
            first_ability_name: spellSwapFirstSelected,
            second_ability_name: spellSwapSecondSelected
        };
        GameEvents.SendCustomGameEventToServer("spells_menu_swap_player_spells", event_data);
        // Clear selections
        spellSwapFirstSelected = null;
        spellSwapSecondSelected = null;
    } else {
        spellSwapFirstSelected = spellName;
    }

}

function SwapPlayerSpellsFeedback() {
    OpenSpellsListingForPlayerHero();
}



function GetplayerdataFeedback(spellmap,spellsXPTable){
    // CloseSpellsShopMenuwindow();
}


// 获取免费技能列表
$.Schedule( 5.0, GetFreeSpell );
function GetFreeSpell() {
    var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("GetFreeSpells", event_data);
}
function GetFreeSpellFeedback(keys){
    var spells = keys.spellmap;
    for (const key in spells) {
        freeSpell[key]=true;
    }


}


const  MysteryPanel =  $("#MysterySelectContainer");

function MysterySpellsFeedback(event_data) {
  
    // Clear children
    MysteryPanel.RemoveAndDeleteChildren();
    // var playerHeroSpellsContainer  =customSpellsMenuPanel;

    var heroSpells = event_data.abilities;
    var spellsClass = event_data.class;
    // $.Msg(heroSpells)
    var spellPanel;
    var i = 0
    // $.Msg(heroSpells);
    for (var key in heroSpells) {
        if (heroSpells.hasOwnProperty(key) ) {
            var individualHeroSpellName = heroSpells[key];
            // 不显示默认技能
            if (individualHeroSpellName!="Default_Move") {
                spellPanel = $.CreatePanel("Panel", MysteryPanel, "MysterspellPanel" + key);
                spellPanel.BLoadLayoutSnippet("spell2");

                var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage2");
                image.abilityname = individualHeroSpellName;


                var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton2");
                addSpellUnlockEvens(spellButton,individualHeroSpellName,spellsClass);
                i++;
            }
            
        }
    }

    if (i<=1) {
        SpellsMysteryWindowPanel.style.width = "350px";
    }else{
        
        var width = i*200 
        SpellsMysteryWindowPanel.style.width = width+"px";
    }
    SpellsMysteryWindowPanel.SetHasClass("Visible", true);
}


function CloseSpellsMysteryWindowPanel(){
    SpellsMysteryWindowPanel.SetHasClass("Visible", false);
}

function addSpellUnlockEvens(spellButton,name,spellsClass){
    // spellButton.SetPanelEvent("onactivate", Function("UnlockSpell(   \'" + name + "\' , \'" + spellsClass + "\'      )"));
    spellButton.SetPanelEvent("onactivate", function () {
        UnlockSpell(name,spellsClass);
    });
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,name);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });
}


function UnlockSpell(name,unlockClass){
    // $.Msg(name);
    // $.Msg(spellsClass);
    SpellsMysteryWindowPanel.SetHasClass("Visible", false);
    var playerID = Game.GetLocalPlayerID();
    var event_data = {
        player_id: playerID,
        ability_name : name,
        spellsClass : unlockClass,
    };
    GameEvents.SendCustomGameEventToServer("UnlockSpellMystery", event_data);
}

function CreateRandomHotKey(hotkey){
    let key = hotkey;
    const command = `On${key}${Date.now()}`;
    Game.CreateCustomKeyBind(key, `+${command}`);
    Game.AddCommand(
        `+${command}`,
        () => {
            OnTestButtonPressed();
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
        if (table.ChaoticEraMod==1) {
            ChaoticEraMod = true;
            $("#PotionBagButton").SetHasClass("show",true);
            // SpellsMenuUpgradeSpellsButton.SetHasClass("hidden",true);
            // SpellsMenuSellSpellsButton.SetHasClass("hidden",true);
            OpenSpellsListingForPlayerHero();
            OpenSpellsMenu(currentOpenSpellclass);
        }
    }

    
    
}




(function () {
    GameEvents.Subscribe("GetFreeSpellFeedback", GetFreeSpellFeedback);
    GameEvents.Subscribe("spells_menu_get_player_spells_feedback", GetPlayerSpellsFeedback);
    GameEvents.Subscribe("spells_menu_swap_player_spells_feedback", SwapPlayerSpellsFeedback);
    GameEvents.Subscribe("spells_menu_swap_player_sell_feedback", RefreshSellPlayerSpellsFeedback);   //出售技能成功 刷新界面
    GameEvents.Subscribe("spells_menu_upgrade_player_spells_fnished_feedback", RefreshupgradePlayerSpellsFeedback);   //升级技能成功 刷新界面
    GameEvents.Subscribe("spells_menu_get_player_spells_by_classlevel_feedback", UpgradePlayerSpellsFeedback);  //收到可升阶技能列表反馈
    GameEvents.Subscribe("spells_menu_get_player_sellspells_by_classlevel_feedback", SellPlayerSpellsFeedback);  //收到可出售技能列表反馈

    GameEvents.Subscribe("spells_menu_get_Mystery", MysterySpellsFeedback);  //收到奥义解锁数据
    GameEvents.Subscribe("spells_menu_update_camera_dis", UpdateCameraDIS);  //改变摄像头距离
    GameEvents.Subscribe("SendCustomErroMessage", SendCustomErroMessage);  //自定义错误信息
    GameEvents.Subscribe("PlayClientSound", PlayClientSound);  //播放客户端音效
    



    CreateRandomHotKey("F7");
    // Game.AddCommand( "+OpenSpellShop", OnTestButtonPressed, "", Date.now() );




    GameEvents.Subscribe("Getplayerdata_feedback", GetplayerdataFeedback); //得到玩家数据反馈
    // GameEvents.Subscribe("spells_menu_update_spells_advanced_level", UpdateSpell_Level);  //更新客户端的技能等级数据



    CustomUIConfig.SubscribeNetTableListener("game_config", UpdateCommonNetTable);
	UpdateCommonNetTable("game_config", "hd_game_mode", CustomNetTables.GetTableValue("game_config", "hd_game_mode"));

    
})();



// 打开一个初始窗口
OpenSpellsShop();
OpenPhysicalSpellsMenu();
CloseSpellsShopMenuwindow();