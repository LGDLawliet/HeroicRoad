

// $("#challengeMenuwindowROOT").visible = false;
// $("#challengeMenuwindowROOT").SetHasClass("Visible", false);
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // 
// 背负更多的苦难说明
var ShowinfoButton = $("#challengeMenuwindowROOT").FindChildTraverse("ShowinfoButton");
var challengeInfoRoot = $("#challengeMenuwindowROOT").FindChildTraverse("challengeInfoRoot");
const challengeMenuOpenButtonBG = $("#challengeMenuOpenButtonBG");

$.Schedule(0.1, function () {
    challengeMenuOpenButtonBG.FireEntityInput("summon_start1", "StopPlayEndCap", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_start2", "StopPlayEndCap", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_start3", "StopPlayEndCap", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_click1", "StopPlayEndCap", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_click2", "StopPlayEndCap", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_click3", "StopPlayEndCap", "" );
    challengeMenuOpenButtonBG.FireEntityInput("box_particle", "StopPlayEndCap", "" );
    challengeMenuOpenButtonBG.FireEntityInput("box", "SetPlaybackRate", "0.1" );
})

var challengeInfo =	challengeInfoRoot.Children()
for (var i = 0; i < challengeInfo.length; i++) {
		
    challengeInfo[i].visible = false;
    


}

var challengewindow =	$("#challengewindow").Children()
// challengewindow[0].visible = false;
for (var i = 0; i < challengewindow.length; i++) {  
    challengewindow[i].visible = false; 
}


var herochallengePanel = $("#herochallengePanel");
var herochallengewindow =	herochallengePanel.Children()
for (var i = 0; i < herochallengewindow.length; i++) {  

    herochallengewindow[i].visible = false; 
}

$("#RerollButton").visible= false;


function showCurrencyhover() {

    var item_name_intext = "ChallengeInfo"
    // var urlid = "";
    var urlid = "s2r://panorama/images/econ/huds/hud_esp_surge_hud_png.vtex";
    // urlid = "";
    var item_name = "#DOTA_Tooltip_ability_"+item_name_intext;
    var text = "#DOTA_Tooltip_ability_"+item_name_intext+"_Description";
    $.DispatchEvent("DOTAShowTitleImageTextTooltip",ShowinfoButton,item_name,urlid,$.Localize(text))


}
function closeCurrencyhover() {
    $.DispatchEvent("DOTAHideTitleImageTextTooltip");
}
// 背负更多的苦难说明结束
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // 

// 挑战菜单开关
const challengeMenuwindowROOT = $("#challengeMenuwindowROOT");
var settingStatus = false;

challengeMenuwindowROOT.SetHasClass("show", settingStatus);
const SettingWindowBack = $("#SettingWindowBack");

let challengeMenuwindow = $("#challengeMenuwindow");
function OpenchallengeMenu(){
    // if(challengeMenuwindowROOT.visible==true){
    //     challengeMenuwindowROOT.visible = false;
    // }else{
    //     challengeMenuwindowROOT.visible = true;
    // };
    if(settingStatus==false){
        Game.EmitSound( "ui_find_match_slide_out" );
        settingStatus = true;
        SettingWindowBack.visible = true;
        challengeMenuwindow.hittest = true;
        challengeMenuwindowROOT.SetHasClass("show", settingStatus);
    }else{
        
        Game.EmitSound( "ui_find_match_find" );
        settingStatus = false;
        SettingWindowBack.visible = false;
        challengeMenuwindow.hittest = false;
        challengeMenuwindowROOT.SetHasClass("show", settingStatus);
    }
};

function CloseSetting(){
    Game.EmitSound( "ui_find_match_find" );
    // SettingWindowRoot.visible = false;
    settingStatus = false;
    SettingWindowBack.visible = false;
    challengeMenuwindow.hittest = false;
    challengeMenuwindowROOT.SetHasClass("show", false);
}

function Donothing(){

}



var Challenge_List = {}
// var challengeMenuOpenButton = $("#challengePanel").FindChildTraverse("challengeMenuOpenButton");
// challengeMenuOpenButton.SetHasClass("class_bigger",false);
// challengeMenuOpenButton.SetHasClass("class_normal",true);
// var buttonChanging = false;
// var IsBig = false;

function ShowChallenge(keys) {
    $("#RerollButton").visible= false;
	if(keys.chance>0){
		$("#RerollButton").SetDialogVariable("reRollCount", keys.chance);
		$("#RerollButton").visible= true;
	}
    // buttonChanging = true;
    $.Schedule( 15.0, DisableChanging );
	var challengewindow =	$("#challengewindow").Children()
	// challengewindow[5].visible = false;
	for (var i = 0; i < challengewindow.length; i++) {
		
		if (keys.item[i+1]) {
            var spell_name = keys.item[i+1]

            Challenge_List[spell_name] =i  //数组
            challengewindow[i].Children()[2].text =$.Localize("#DOTA_HUD_Challenge_Cost_return")+":"+keys.item_bonus[i+1];
			challengewindow[i].Children()[0].abilityname = spell_name;
			challengewindow[i].abilityname = spell_name;
			challengewindow[i].visible = true;
            urlid = "";
            var item_name = "#DOTA_Tooltip_ability_"+spell_name;
            var text = "#DOTA_Tooltip_ability_"+spell_name+"_Description";
            addChallengeEvens(challengewindow[i].Children()[0],spell_name,$.Localize(item_name),urlid,$.Localize(text));
		}
        
	}
	for (var i = 0; i < challengeInfo.length; i++) {
		
		challengeInfo[i].visible = false;
        
	}

    for (var i = 0; i < herochallengewindow.length; i++) {  

        herochallengewindow[i].visible = false; 
    }
    
  
    PlayParticleOn();
}

function ShowChallengeReroll(keys) {
	// $("#DropSelectRoot").visible = true;
   
    
	Game.EmitSound( "DOTAMusic_PLUS_ONE" );
    $("#RerollButton").visible= false;
	if(keys.chance>0){
		$("#RerollButton").SetDialogVariable("reRollCount", keys.chance);
		$("#RerollButton").visible= true;
	}
    buttonChanging = true;
    $.Schedule( 15.0, DisableChanging );
	var challengewindow =	$("#challengewindow").Children()
	// challengewindow[5].visible = false;
	for (var i = 0; i < challengewindow.length; i++) {
		
		if (keys.item[i+1]) {
            var spell_name = keys.item[i+1]

            Challenge_List[spell_name] =i  //数组
            // var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
            // spellCost.text = individualHeroSpell.cost;
            // challengewindow[i].Children()[2].text = $.Localize("DOTA_HUD_Spells_Menu_Spell_Cost")+":"+keys.item_cost[i+1];
            challengewindow[i].Children()[2].text =$.Localize("#DOTA_HUD_Challenge_Cost_return")+":"+keys.item_bonus[i+1];
            // $.Msg(keys.item_cost);
            // $.Msg(keys.item_bonus);
			// $.Msg(keys.item[i+1]);
			challengewindow[i].Children()[0].abilityname = spell_name;
			challengewindow[i].abilityname = spell_name;

			challengewindow[i].visible = true;
            

            // var urlid = "s2r://panorama/images/hud/reborn/ping_icon_default_psd.vtex";
            urlid = "";
            var item_name = "#DOTA_Tooltip_ability_"+spell_name;
            var text = "#DOTA_Tooltip_ability_"+spell_name+"_Description";
            addChallengeEvens(challengewindow[i].Children()[0],spell_name,$.Localize(item_name),urlid,$.Localize(text));
		}
        
	}

    PlayParticleOn();

}

function PlayParticleOn() {

    challengeMenuOpenButtonBG.FireEntityInput("box_particle", "Start", "" );
    challengeMenuOpenButtonBG.FireEntityInput("box", "SetPlaybackRate", "0.8" );

    challengeMenuOpenButtonBG.FireEntityInput("summon_start1", "Start", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_start2", "Start", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_start3", "Start", "" );
    $.Schedule(1.5, function () {
        challengeMenuOpenButtonBG.FireEntityInput("summon_start1", "StopPlayEndCap", "" );
        challengeMenuOpenButtonBG.FireEntityInput("summon_start2", "StopPlayEndCap", "" );
        challengeMenuOpenButtonBG.FireEntityInput("summon_start3", "StopPlayEndCap", "" );
    })
}


function StopParticle() {
    challengeMenuOpenButtonBG.FireEntityInput("summon_click1", "Start", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_click2", "Start", "" );
    challengeMenuOpenButtonBG.FireEntityInput("summon_click3", "Start", "" );
    $.Schedule(1.5, function () {
        challengeMenuOpenButtonBG.FireEntityInput("summon_click1", "StopPlayEndCap", "" );
        challengeMenuOpenButtonBG.FireEntityInput("summon_click2", "StopPlayEndCap", "" );
        challengeMenuOpenButtonBG.FireEntityInput("summon_click3", "StopPlayEndCap", "" );
    });
    challengeMenuOpenButtonBG.FireEntityInput("box_particle", "StopPlayEndCap", "" );
    challengeMenuOpenButtonBG.FireEntityInput("box", "SetPlaybackRate", "0.1" );
}



function ChallengeSelectClear(){
    var challengewindow =	$("#challengewindow").Children();
    // //设置选中信息
	for (var i = 0; i < challengewindow.length; i++) {
        challengewindow[i].Children()[0].SetHasClass("Button_on", false);
	}
}
// 
function ChallengeSelectSucess(keys){
    
    var index = keys.index;
    var challengewindow =	$("#challengewindow").Children();
    var music_name = "DOTAMusic_smoke_end"+index
    Game.EmitSound( music_name );
    // //设置选中信息
	for (var i = 0; i < challengewindow.length; i++) {
        challengewindow[i].Children()[0].SetHasClass("Button_on", false);
	}
    challengewindow[index].Children()[0].SetHasClass("Button_on", true);

    buttonChanging = false;
    // challengeMenuOpenButton.SetHasClass("class_bigger",false);
    // challengeMenuOpenButton.SetHasClass("class_normal",true);
    StopParticle();
}
function GetdebugInfo(keys){

    // $.Msg("get debug")
    var index = keys.encoded;

    // for (const key in index) {
    //     $.Msg(index[key])
    //     for (const key2 in index[key]) {
    //         $.Msg(index[key][key2])
    //     }
    // }
  
  
    // $.Msg("get debug  end")


}


$.Schedule( 1.0, Checkchallenge );

$.Schedule( 5.0, Checkchallenge );



function Checkchallenge( )
{

    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("Checkchallenge", event_data);
    // GameEvents.SendCustomGameEventToServer("Checkchallenge", player_id= Game.GetLocalPlayerID());  //重连时重新获取奖励

}

function DisableChanging( )
{

    buttonChanging = false;

}


// $.Schedule( 15.0, ChangingButtonScale );

// function ChangingButtonScale(){
//     if(buttonChanging){
//         if(IsBig){
//             challengeMenuOpenButton.SetHasClass("class_bigger",false);
//             challengeMenuOpenButton.SetHasClass("class_normal",true);
//             IsBig = false;
//         }else{
//             challengeMenuOpenButton.SetHasClass("class_bigger",true);
//             challengeMenuOpenButton.SetHasClass("class_normal",false);
//             IsBig = true;
//         }
//     }
    
//     $.Schedule( 0.5, ChangingButtonScale );
// }




function ChallengeSelectUI(keys){
    var key = "#DOTA_Tooltip_modifier_"+keys.challenge_name;

    challengeInfo[keys.nPlayerID].text = $.Localize("#"+keys.name)+":"+$.Localize(key);
    challengeInfo[keys.nPlayerID].visible = true;

    
    herochallengewindow[keys.nPlayerID].visible = true; 
    var spellButton = herochallengewindow[keys.nPlayerID].Children()[0];
    var spell_name = keys.challenge_name

    spellButton.abilityname = spell_name;
    urlid = "";
    var item_name = "#DOTA_Tooltip_ability_"+spell_name;
    var text = "#DOTA_Tooltip_ability_"+spell_name+"_Description";
    var nemae = $.Localize(item_name);
    // $.Msg(nemae);
    addheroChallengeEvens(spellButton,spell_name,$.Localize(item_name),urlid,$.Localize(text));

    spellButton.SetHasClass("class_index0",false)
    spellButton.SetHasClass("class_index1",false)
    spellButton.SetHasClass("class_index2",false)
    spellButton.SetHasClass("class_index3",false)
    spellButton.SetHasClass("class_index4",false)
    spellButton.SetHasClass("class_index"+keys.index,true)








 
}


function addheroChallengeEvens(spellButton,individualHeroShopGood,item_name,urlid,text) {
 

    // var name = individualHeroShopGood.split("_");
    // name = name[0] +"_"+ name[1];
    // var useKV = "#DOTA_Tooltip_ability_"+name+"_USE_KEYVALUE";
    // if($.Localize(useKV)=="1"){
    //     // $.Msg("ok new kv");
    //     var type = $.Localize("#DOTA_Tooltip_ability_"+name+"_type")
    //     var newText = $.Localize("#DOTA_Tooltip_ChallengeInfo_info_1")+ $.Localize("#DOTA_Tooltip_ChallengeInfo_type_"+type)+
    //     $.Localize("#DOTA_Tooltip_ChallengeInfo_info_2")+text+
    //     $.Localize("#DOTA_Tooltip_ChallengeInfo_info_3");
    //     var bonus_key ="#DOTA_Tooltip_ability_"+individualHeroShopGood+"_bonus_"
    //     var bonus_count =  $.Localize("#DOTA_Tooltip_ability_"+name+"_bonus");
    //     for (let index = 1; index <= bonus_count; index++) {
    //        var bonus = bonus_key+index;
    //        var value = $.Localize(bonus);
    //        if(value!=bonus){
    //         newText = newText + value;
    //        }
    //     }
    //     text = newText;
    //     var name = "#DOTA_Tooltip_ability_"+name+"_name";
    //     item_name = $.Localize(name);
    // }

    spellButton.SetPanelEvent("onmouseover", function () {
        // $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,item_name,urlid,text);
        let data = {
            name :individualHeroShopGood,
            type : ADVANCED_ABILITY_INFO_CHALLENGE,
        }
        let jsonData = JSON.stringify(data);
        // // $.Msg(jsonData)
        // $.Msg(data)

        $.DispatchEvent("UIShowCustomLayoutParametersTooltip", spellButton, "advanced_ability_info", "file://{resources}/layout/custom_game/tooltips/advanced_ability/advanced_ability.xml", "data=" + jsonData);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        // $.DispatchEvent("DOTAHideTitleImageTextTooltip");
        $.DispatchEvent("UIHideCustomLayoutTooltip", spellButton, "advanced_ability_info");
        
    });
}

function ReRollChallenge(){
	var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("TryReRollChallenge", event_data);
	for (var i = 0; i < challengewindow.length; i++) {  
        challengewindow[i].visible = false; 
    }
    $("#RerollButton").visible= false;
}
function DoNothing(){
    // $.Msg("aaaaaaaaa");
}

function CreateRandomHotKey(hotkey){
    let key = hotkey;
    const command = `On${key}${Date.now()}`;
    Game.CreateCustomKeyBind(key, `+${command}`);
    Game.AddCommand(
        `+${command}`,
        () => {
            OpenchallengeMenu();
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
			$("#challengePanel").SetHasClass("hidden",true);

        }
    }

}





(function () {
	GameEvents.Subscribe("ShowChallenge", ShowChallenge);
	GameEvents.Subscribe("ShowChallengeReroll", ShowChallengeReroll);

    
    GameEvents.Subscribe("ChallengeSelectSucess", ChallengeSelectSucess);  //难度选择成功 UI反馈
    GameEvents.Subscribe("ChallengeSelectClear", ChallengeSelectClear);  //回合结束 清除选择信息
    
    GameEvents.Subscribe("GetdebugInfo", GetdebugInfo);  //debug

    GameEvents.Subscribe("ChallengeSelectUI", ChallengeSelectUI);  //debug
    CreateRandomHotKey("F8");
    // Game.AddCommand( "+OpenChallenge", OpenchallengeMenu, "", Date.now() );



    CustomUIConfig.SubscribeNetTableListener("game_config", UpdateCommonNetTable);
    UpdateCommonNetTable("game_config", "hd_game_mode", CustomNetTables.GetTableValue("game_config", "hd_game_mode"));
})();

