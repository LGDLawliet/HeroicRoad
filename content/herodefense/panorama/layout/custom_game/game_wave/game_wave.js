"use strict";

$( "#WaveDiscoverPanel" ).FindChildInLayoutFile( "WaveEncounterNameLabel" ).text = $.Localize("#DOTA_NOW_WAVE")+0;
var WaveDiscoverStrip2 = $("#WaveDiscoverStrip2");
WaveDiscoverStrip2.SetHasClass("Visible", true);

var WaveDiscoverStrip3 = $("#WaveDiscoverStrip3");
WaveDiscoverStrip3.SetHasClass("Visible", false);

// var WaveDiscoverStrip4 = $("#WaveDiscoverStrip4");
// WaveDiscoverStrip4.SetHasClass("Visible", false);

function OnNewRoomDiscovered(event_data )
{
    var roomData = event_data[1];
	if ( roomData !== null )
	{
		$( "#RoomDiscoverPanel" ).FindChildInLayoutFile( "EncounterNameLabel" ).text = $.Localize( roomData.encounter_name );
		$( "#WaveDiscoverPanel" ).FindChildInLayoutFile( "WaveEncounterNameLabel" ).text = $.Localize("#DOTA_NOW_WAVE")+roomData.encounter_ROUND;
        // $( "#RoomDiscoverPanel" ).FindChildInLayoutFile( "EncounterNameLabel" ).text = $.Localize("#DOTA_HUD_GAME_WAVE_CD_ROOM1");
	}
    // $.Msg(roomData);
	$( "#RoomDiscoverPanel" ).SetHasClass( "Visible", true );

	var szRoomClass = "Difficulty";
	szRoomClass = szRoomClass + roomData.encounter_difficulty;

	$( "#RoomDiscoverPanel" ).SwitchClass( "RoomType", szRoomClass );

	// Game.EmitSound( "RoomDiscover" );

	$.Schedule( 5.0, HideRoomDiscoverPanel );
}

function HideRoomDiscoverPanel()
{
	$( "#RoomDiscoverPanel" ).SetHasClass( "Visible", false );
}
function HideNextWaveName()
{
	// $.Msg("隐藏");
	$( "#WaveDiscoverStrip2" ).SetHasClass( "Visible", false );
}

function setWave(event_data) {
	var roomData=event_data[1];
	$( "#WaveDiscoverPanel" ).FindChildInLayoutFile( "WaveEncounterNameLabel" ).text = $.Localize("#DOTA_NOW_WAVE")+roomData.encounter_ROUND;
}
function GetNextWaveName(event_data )
{
	// $.Msg("aaaa");
    var roomData = event_data[1];
	$.Msg(roomData);
	if ( roomData !== null )
	{

		var name = $.Localize( roomData.encounter_name );
		var target = $( "#WaveDiscoverPanel" ).FindChildInLayoutFile( "WaveEncounterNameLabel2" );
		target.text= $.Localize("#DOTA_HUD_GAME_WAVE_NEXT_INFO")+name;
		addTooltipEvens(target,name);
	}

}


function addTooltipEvens(spellButton,text) {
    // Hover events
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowTextTooltip",spellButton,text);
    });
    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideTextTooltip");
    });

}








// $.Schedule( 2.0, UpdataNextWave );


// function UpdataNextWave( )
// {
//     var event_data = {
// 		player_id: Game.GetLocalPlayerID(),
// 	}
// 	GameEvents.SendCustomGameEventToServer("UpdateGameWave",  event_data );
	

// }




function ShowEndless(keys)
{
	// $.Msg(keys);
	WaveDiscoverStrip3.SetHasClass( "Visible", true );
	WaveDiscoverStrip3.FindChildInLayoutFile( "WaveEncounterNameLabel3" ).text = $.Localize("#DOTA_HUD_game_info_ENDLESS_WAVE")+keys[1];
	
}
// function ShowEndlessCount(keys)
// {
// 	// $.Msg(keys);
// 	// show current endless num
// 	WaveDiscoverStrip4.SetHasClass( "Visible", true );
// 	WaveDiscoverStrip4.FindChildInLayoutFile( "WaveEncounterNameLabel4" ).text = $.Localize("#DOTA_HUD_game_info_ENDLESS_WAVE_COUNT_CURRENT")+keys[1];

	
// }



$("#CheckFellOmenBuff").SetHasClass( "Visible", false );


function SetDifficultyInfo(keys){
	$.Msg(keys)
	$.Msg("aaaaaaaaaaa")
	if (keys.index==9) {
		var label = $( "#WaveDiscoverPanel" ).FindChildInLayoutFile( "WaveEncounterNameLabel0");
		var text =$.Localize("#DOTA_HUD_difficulty_select_"+keys.index);
		text = text.replace("WAVE",keys.wave);
		label.text = text;
		$("#CheckFellOmenBuff").SetHasClass( "Visible", true );
	}else{
		$.Msg(keys.sendInfo)
		if (keys.index==7 ||keys.index==8) {
			if (keys.sendInfo==1) {
				$.Msg("显示面板");
				$( "#SendData_Panel_Root" ).SetHasClass( "show", true );
			}
			
		}
		$( "#WaveDiscoverPanel" ).FindChildInLayoutFile( "WaveEncounterNameLabel0" ).text =$.Localize("#DOTA_HUD_game_difficult")+ $.Localize("#DOTA_HUD_difficulty_select_"+keys.index);
	}
}
function ConfirmSendData(){
	$( "#SendData_Panel_Root" ).SetHasClass( "show", false );
	var event_data = {
		player_id: Game.GetLocalPlayerID(),
		hidden: 1,
	}
	GameEvents.SendCustomGameEventToServer("SendHiddenInfo",  event_data );
	
}

function CancleSendData(){
	$( "#SendData_Panel_Root" ).SetHasClass( "show", false );
	var event_data = {
		player_id: Game.GetLocalPlayerID(),
		hidden: 0,
	}
	GameEvents.SendCustomGameEventToServer("SendHiddenInfo",  event_data );
}


function EndGameMenu()
{
	$( "#EndGameButton" ).SetHasClass( "Visible", false );
    var event_data = {
		player_id: Game.GetLocalPlayerID(),
	}
	GameEvents.SendCustomGameEventToServer("EndGame",  event_data );
	
}


const FellOmenPanelWindow = $( "#FellOmenPanelWindow" );
const FellOmenPanelRoot = $( "#FellOmenPanelRoot" );
const FellOmenBan_Panel_Root = $( "#FellOmenBan_Panel_Root" );
const SetBonusAttributesButton = $( "#SetBonusAttributesButton" );
const FellOmenBan_Bonus_Attributes_PanelWindow = $( "#FellOmenBan_Bonus_Attributes_PanelWindow" );
const FellOmenPanelWindow_Bad = FellOmenPanelWindow.FindChildInLayoutFile( "FellOmenPanelWindow_Bad" );
const FellOmenPanelWindow_Good = FellOmenPanelWindow.FindChildInLayoutFile( "FellOmenPanelWindow_Good" );
var FellState = true;
var firstTime = true;
var FellOmenData;
FellOmenPanelWindow.SetHasClass("Hidden", true);
function CheckFellOmenBuff(){
    if(FellState==true){
		Game.EmitSound( "ui_menu_activate_open" );
        FellState = false;
        // SettingWindowBack.visible = true;
        FellOmenPanelRoot.hittest = true;
		if (firstTime) {
			// firstTime = false;
			GetFellInfoFromLua();
		}
		
        FellOmenPanelWindow.SetHasClass("Hidden", FellState);
    }else{
		Game.EmitSound( "ui_menu_activate_close" );
        FellState = true;
        // SettingWindowBack.visible = false;
        FellOmenPanelRoot.hittest = false;
        FellOmenPanelWindow.SetHasClass("Hidden", FellState);
    }
    
}
function CloseFellOmenBuff(){
	Game.EmitSound( "ui_menu_activate_close" );
	FellState = true;
	FellOmenPanelRoot.hittest = false;
	FellOmenPanelWindow.SetHasClass("Hidden", FellState);
    
}
function Donothing(){

}

function GetFellInfo(){

	var spells_bad = FellOmenData.bad;
	var spells_good = FellOmenData.good;
	
    FellOmenPanelWindow_Bad.RemoveAndDeleteChildren();  //先清除
    var spellsContainer = FellOmenPanelWindow_Bad
	var spellPanel;
	var count = 0;
	var i = 0
	for (const key in spells_bad) {
		if (Object.hasOwnProperty.call(spells_bad, key)) {
			const individualHeroSpell = spells_bad[key][1];

			spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
            spellPanel.BLoadLayoutSnippet("spell"); //载入模块
    
            var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage"); //找到图片

            var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
			var leveltext = spellPanel.FindChildInLayoutFile("leveltext");
			leveltext.text = spells_bad[key][2];

            image.abilityname = individualHeroSpell;  //设置技能名

            addSpellInfoEvens(spellButton,individualHeroSpell,1);
			var spellPanel = spellsContainer.Children()[i];
			$.Schedule( i*0.1, ()=>{
				SetPanelNotHidden(count);
				count = count + 1;
			})
			i++;
		}
	}

	FellOmenPanelWindow_Good.RemoveAndDeleteChildren();  //先清除
    var spellsContainer = FellOmenPanelWindow_Good;
	var count2 = 0
	var j = 0
	for (const key in spells_good) {
		if (Object.hasOwnProperty.call(spells_good, key)) {
			const individualHeroSpell = spells_good[key][1];
            spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
            spellPanel.BLoadLayoutSnippet("spell"); //载入模块
    
            var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage"); //找到图片
            // var SpellLevel= spellPanel.FindChildInLayoutFile("SpellLevel");
            var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
			var leveltext = spellPanel.FindChildInLayoutFile("leveltext");
			leveltext.text = spells_good[key][2];
            image.abilityname = individualHeroSpell;  //设置技能名
            addSpellInfoEvens(spellButton,individualHeroSpell,2);
			var spellPanel = spellsContainer.Children()[i];
			$.Schedule( j*0.2, ()=>{
				SetPanelNotHidden2(count2);
				count2 = count2 + 1;
			})
			j++;
		}
	}

}

function SetPanelNotHidden(i){
	Game.EmitSound( "ui.inv_drop_stone" );
	var spellPanel = FellOmenPanelWindow_Bad.Children()[i];
	if (spellPanel) {
		spellPanel.SetHasClass("SpellHidden", false);
	}

}
function SetPanelNotHidden2(i){
	Game.EmitSound( "ui.inv_drop_stone" );
	var spellPanel = FellOmenPanelWindow_Good.Children()[i];
	if (spellPanel) {
		spellPanel.SetHasClass("SpellHidden", false);
	}
}



function addSpellInfoEvens(spellButton,individualHeroSpell,isBad) {
    // spellButton.SetPanelEvent("onactivate", Function("BanFellOmen(\'" + individualHeroSpell + "," + isBad + "\')"));
	spellButton.SetPanelEvent("onactivate", function () {
		BanFellOmen(individualHeroSpell,isBad);
	});
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,individualHeroSpell);
    });
}


function GetFellInfoFromLua(){
	var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("GetFellomen", event_data);
}


function GetFellomenFeedback(keys){
	FellOmenData = keys;
	// $.Msg(FellOmenData);
	GetFellInfo();
}

var currentFellOmenName = "a";
var currentFellType = 0;
function BanFellOmen(name,type){
	// var info = keys.split(',');
	currentFellOmenName = name;
	// $.Msg(currentFellOmenName);
	currentFellType = type;
	FellOmenBan_Panel_Root.SetHasClass("Hidden", false);
}

function ConfirmBan(){
	var event_data = {
        player_id: Game.GetLocalPlayerID(),
		fellOmen : currentFellOmenName,
		badFellOmen : currentFellType,
    }
    GameEvents.SendCustomGameEventToServer("TryBanFellOmen", event_data);
	FellOmenBan_Panel_Root.SetHasClass("Hidden", true);
}

function CancleBan(){

	FellOmenBan_Panel_Root.SetHasClass("Hidden", true);
}

const FellOmenBan_Bonus_Attributes_Panel_Root = $( "#FellOmenBan_Bonus_Attributes_Panel_Root" );
const FellOmenBan_Bonus_Attributes = $( "#FellOmenBan_Bonus_Attributes" );

const FellOmenBan_Bonus_Attributes_base = FellOmenBan_Bonus_Attributes.FindChildInLayoutFile( "FellOmenBan_Bonus_Attributes_0" );
var current_max_point = 0;
FellOmenBan_Bonus_Attributes_base.SetDialogVariable("point", current_max_point);
var current_cost = 0;
$( "#SetBonusAttributesButton" ).SetHasClass("Visible", false);
var costMap = [
	{
		"1": 1,
	},
	{
		"1": 1,
	},
	{
		"1": 1,
	},
	{
		"1": 0.02,
	},
	{
		"1": 0.025,
	},

	{
		"1": 2,
	},
	{
		"1": 0.3,
	},
	{
		"1": 2,
	},
	// 技能点
	{
		"0": 0,
		"1": 5,
		"2": 11,
		"3": 18,
		"4": 26,
		"5": 35,
		"6": 45,
		"7": 56,
		"8": 68,
		"9": 81,
		"10": 95,
	},
];





// 数值发生变化时
function BonusAttributesQuantityChanged(key){
	var target = FellOmenBan_Bonus_Attributes.FindChildInLayoutFile( "FellOmenBan_Bonus_Attributes_"+key );
	let value = target.FindChildInLayoutFile( "Bonus_attributes").value;
	// $.Msg(costMap[key-1]);
	let cost = costMap[key][1]*value;
	if ((key)==9) {
		cost = costMap[key][value+1];
	}
	cost = Math.ceil(cost);

	target.SetDialogVariable("point", cost);
	Game.EmitSound( "ui.inv_drop_bone" );
	CalculateTotalCost();
}



// 重新计算所有消耗点
function CalculateTotalCost(){
	var bonusChildren = FellOmenBan_Bonus_Attributes.Children();
	var cost = 0;
	for (let index = 1; index < bonusChildren.length; index++) {
		const element = bonusChildren[index];
		let value = 	 element.FindChildInLayoutFile( "Bonus_attributes").value;
		
		if ((index)==9) {
			// $.Msg(value);
			value = costMap[index][value+1];

		}else{
			value = costMap[index][1]*value;
		}
		value = Math.ceil(value);
		// target.SetDialogVariable("point", cost);

		cost+=value;
	}
	current_cost = cost;
	FellOmenBan_Bonus_Attributes_base.SetDialogVariable("point", current_max_point-cost);
}

function SendBonusAttributes(){
	if (current_cost!=current_max_point) {
		if (current_cost>=current_max_point) {
			var message = "#DOTA_HUD_FellOmen_Send_Bonus_Attributes_failed2";
			var sound = "General.Cancel";
			GameUI.SendCustomHUDError( message, sound );
			return
		}
		var message = "#DOTA_HUD_FellOmen_Send_Bonus_Attributes_failed";
		var sound = "General.Cancel";
		GameUI.SendCustomHUDError( message, sound );
		return
	}
	var data = {};
	var bonusChildren = FellOmenBan_Bonus_Attributes.Children();
	for (let index = 1; index < bonusChildren.length; index++) {
		const element = bonusChildren[index];
		let value = 	 element.FindChildInLayoutFile( "Bonus_attributes").value;
		data[index] = value;
	}
	var event_data = {
		player_id: Game.GetLocalPlayerID(),
		attributes :data,
	}
	GameEvents.SendCustomGameEventToServer("SendBonusAttributes",  event_data );
}


// const FellOmenBan_Bonus_Attributes_Panel_Root = $( "#FellOmenBan_Bonus_Attributes_Panel_Root" );
var settingStatus = true;
function ChangingBonusAttributesStatus(){
	
	if(settingStatus==true){
        Game.EmitSound( "ui.treasure_count" );
        settingStatus = false;
        FellOmenBan_Bonus_Attributes_PanelWindow.SetHasClass("FellOmenHidden", settingStatus);
		SetBonusAttributesButton.SetHasClass("FellOmenHidden", settingStatus);
    }else{
        Game.EmitSound( "ui.treasure_unlock.wav" );
        settingStatus = true;
        FellOmenBan_Bonus_Attributes_PanelWindow.SetHasClass("FellOmenHidden", settingStatus);
		SetBonusAttributesButton.SetHasClass("FellOmenHidden", settingStatus);
    }
}

function SetBonusAttributesCost(keys){
	costMap = keys;
	for (let index = 1; 9; index++) {
		BonusAttributesQuantityChanged(index);
		if (index>=9) {
			break;
		}
		
	}
}




GetBonusAttributesCostTable();
function GetBonusAttributesCostTable(){
	var event_data = {
		player_id: Game.GetLocalPlayerID(),
	}
	GameEvents.SendCustomGameEventToServer("GetBonusAttributesCost",  event_data );
	GameEvents.SendCustomGameEventToServer("CheckWave", event_data);
}

function SetBonuisPoint(keys){
	current_max_point = keys[1];
	FellOmenBan_Bonus_Attributes_base.SetDialogVariable("point", current_max_point);
	
	$( "#SetBonusAttributesButton" ).SetHasClass("Visible", true);
}

function CloseBonusWindow(){
	$( "#SetBonusAttributesButton" ).SetHasClass("Visible", false);
	settingStatus = true;
	FellOmenBan_Bonus_Attributes_PanelWindow.SetHasClass("FellOmenHidden", true);
	Game.EmitSound( "ui.herochallenge_complete" );
}



GameEvents.Subscribe( "on_new_room_discovered", OnNewRoomDiscovered );
GameEvents.Subscribe( "GetNextWaveName", GetNextWaveName );
GameEvents.Subscribe( "HideNextWaveName", HideNextWaveName );
// GameEvents.Subscribe( "ShowEndlessCount", ShowEndlessCount );//监听无尽怪物数

GameEvents.Subscribe( "ShowEndless", ShowEndless );
GameEvents.Subscribe( "SetDifficultyInfo", SetDifficultyInfo );

GameEvents.Subscribe("GetFellomen_feedback", GetFellomenFeedback); //得到玩家数据反馈
GameEvents.Subscribe("SetBonusAttributesCost", SetBonusAttributesCost); //设置属性消耗
GameEvents.Subscribe("TriggerBonuisPoint", SetBonuisPoint); //设置属性点

GameEvents.Subscribe("SettingFnished", CloseBonusWindow); //设置属性完毕
GameEvents.Subscribe("setWave", setWave); //设置属性完毕

