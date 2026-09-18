"use strict";
var pSelf = $.GetContextPanel();
var CustomUIRoot;
var lower_hud;
var abilities;
var InventoryContainer;
var inventory;
var IsEndless = false;
var iPortraitUnitQualificationLevel = 5;
var iExtraGold = 0;
var fDealCardsCountTime = -1;
let isChaoticEraMode = false;
const hotkeySettingList = $("#hotkeySettingList");
const GetPlayerArtifactRoot = $("#GetPlayerArtifactRoot");
let artifactKV = CustomUIConfig["ChaoticEra_PlayerArtifact"];
    
let hotKeyPanelList = [
	"",
	"",
	"",
	"",
	"",
	"",
	"Z",
	"X",
	"C",
	"V",
	"B",
];
let hotkeyState = {};

function Update() {
	$.Schedule(1 / 10, Update);
	if (!dotaHud) {
		$.Msg("????");

		return;
	}
	if (IsNull(lower_hud)) {

		lower_hud = dotaHud.FindChildTraverse("lower_hud");
		$.Msg(lower_hud);
	}
	if (IsNull(abilities)) {
		abilities = dotaHud.FindChildTraverse("abilities");
	}
	if (IsNull(InventoryContainer)) {
		InventoryContainer = dotaHud.FindChildTraverse("InventoryContainer");
	}
	if (IsNull(lower_hud)) {
		return;
	}
	if (IsNull(abilities)) {
		return;
	}

	// $.Msg("11111");
	let localPlayerID = Players.GetLocalPlayer();
	let localPortraitUnit = Players.GetLocalPlayerPortraitUnit();

	let bHasAbilityToSpend = Entities.GetAbilityPoints(localPortraitUnit) > 0;
	let bControllable = Entities.IsControllableByPlayer(localPortraitUnit, localPlayerID);
	for (let index = 0; index < $("#AbilitiesCustomUIContainer").GetChildCount(); index++) {
		$("#AbilitiesCustomUIContainer").GetChild(index).SetHasClass("Hidden", true);
	}
	
	let abilityCount = 0;
	for (let i = 0; i < abilities.GetChildCount(); i++) {
		let abilityPanel = abilities.GetChild(i);
		let abilityImage = abilityPanel.FindChildTraverse("AbilityImage");
		let ability = abilityImage.contextEntityIndex;
		let abilityMaxLevel = Abilities.GetMaxLevel(ability);
		let abilityLevel = Abilities.GetLevel(ability);
		let abilityName = Abilities.GetAbilityName(ability);

		let customPanel = $("#AbilitiesCustomUIContainer").FindChildTraverse("Ability" + i.toString());
		if (IsNull(customPanel)) {
			customPanel = $.CreatePanel("Panel", $("#AbilitiesCustomUIContainer"), "Ability" + i.toString());
			customPanel.BLoadLayoutSnippet("AbilityCustomUI");
			// InitAbilityPanelEvents(customPanel);
			// customPanel.FindChildTraverse("LevelUpBurstFXContainer").BLoadLayoutSnippet("LevelUpBurstFXContents");
		}
		let upgrateTab = customPanel.FindChildTraverse("upgrateTab");
		
		if (bControllable) {
			if (!abilityPanel.BHasClass("Hidden")) {
				// 如果不是被隐藏的技能
				if (abilityCount>=6) {
					let customHotKeySetting = hotkeySettingList.FindChildTraverse("hotkey_setting"+abilityCount);
					if (IsNull(customHotKeySetting)) {
						customHotKeySetting = $.CreatePanel("Panel", hotkeySettingList, "hotkey_setting"+abilityCount);
						customHotKeySetting.BLoadLayoutSnippet("customAbilityHotKeySetting");
						
						if (hotKeyPanelList[abilityCount]) {
							customHotKeySetting.FindChildTraverse("hotKeyText").text = hotKeyPanelList[abilityCount];
						}
						SetHotKeySettingEvent(customHotKeySetting,abilityCount);
						
					}
					customHotKeySetting.FindChildTraverse("abilityIcon").abilityname = abilityName;
					if (hotkeyState[abilityCount]) {
						customHotKeySetting.SetHasClass("setting_done",true);
					}
						
				}
			}
			// $.Msg(dataList);
			if (dataList[abilityName]) {
				
				if (upgrateTab.currentSpell!=abilityName) {
					upgrateTab.currentSpell = abilityName;
					upgrateTab.ClearPanelEvent("onactivate");
					upgrateTab.ClearPanelEvent("oncontextmenu");
					
					let cost = dataList[abilityName].cost;
					let nextSpell = dataList[abilityName].nextSpells;
					let advanced = false;
					if (abilityName==nextSpell) { //两个技能名一样说明是高阶技能
						advanced = true;
					}
					addSpellUpgradeEvens(upgrateTab,abilityName,nextSpell,advanced,cost);
				}
				upgrateTab.SetHasClass("show",true);
			}else{
				upgrateTab.SetHasClass("show",false);
			}
		}else{
			upgrateTab.SetHasClass("show",false);
		}



		customPanel.ability = ability;
		customPanel.SetHasClass("Hidden", abilityPanel.BHasClass("Hidden"));
		customPanel.SetHasClass("is_passive", abilityPanel.BHasClass("is_passive"));
		customPanel.SetHasClass("no_hotkey", abilityPanel.BHasClass("no_hotkey"));

		let position = abilityPanel.GetPositionWithinWindow();
		if (position.x && position.y) {
			customPanel.SetPositionInPixels(position.x / customPanel.actualuiscale_x, position.y / customPanel.actualuiscale_y, 0);
		}
	
		if (!abilityPanel.BHasClass("Hidden"))
			abilityCount++;
	}
	pSelf.SetHasClass("HasAbilityToSpend", bHasAbilityToSpend);
	pSelf.SetHasClass("FiveAbilities", abilityCount == 5);
	pSelf.SetHasClass("SixAbilities", abilityCount == 6);
	pSelf.SetHasClass("SevenAbilities", abilityCount == 7);
	pSelf.SetHasClass("EightAbilities", abilityCount == 8);
	pSelf.SetHasClass("NineAbilities", abilityCount == 9);
	pSelf.SetHasClass("TenAbilities", abilityCount == 10);
	pSelf.SetHasClass("ElevenAbilities", abilityCount == 11);
	pSelf.SetHasClass("TwelveAbilities", abilityCount == 12);


	// #InventoryContainer

	updateSlots();
		


	// lower_hud.SetHasClass("HasAbilityToSpend", bHasAbilityToSpend);
	// lower_hud.SetHasClass("FiveAbilities", abilityCount == 5);
	// lower_hud.SetHasClass("SixAbilities", abilityCount == 6);
	// lower_hud.SetHasClass("SevenAbilities", abilityCount == 7);
	// lower_hud.SetHasClass("EightAbilities", abilityCount == 8);
	// lower_hud.SetHasClass("NineAbilities", abilityCount == 9);

}



let rightFulKeyList = {
	// "Q" :true,
	// "W" :true,
	// "E" :true,
	// "R" :true,
	// "T" :true,
}
for (let charCode = 65; charCode <= 90; charCode++) {
	const letter = String.fromCharCode(charCode);
	rightFulKeyList[letter] = true;
}

function SetHotKeySettingEvent(targetPanel,abilityIndex) {
	$("#hotKeySetting").SetHasClass("show",true);
	// customAbilityHotKeySetting
	targetPanel.FindChildTraverse("HotkeyButton").SetPanelEvent("onactivate", function () {
		let textPanel = targetPanel.FindChildTraverse("hotKeyText");
		if (textPanel.text) {
			if (rightFulKeyList[textPanel.text]) {
				$.Msg("好的");
				hotkeyState[abilityIndex] = textPanel.text;
				targetPanel.FindChildTraverse("HotkeyButton").ClearPanelEvent("onactivate");
				targetPanel.SetHasClass("setting_done",true);
				CreateRandomHotKey(textPanel.text,abilityIndex);

				let customPanel = $("#AbilitiesCustomUIContainer").FindChildTraverse("Ability" + abilityIndex.toString());
				if (customPanel) {
					customPanel.FindChildTraverse("HotkeyContainer").SetHasClass("show",true);
					customPanel.FindChildTraverse("HD_HotkeyText").text=textPanel.text;
				}
				
				// let abilityPanel = abilities.GetChild(abilityIndex).SetHasClass("no_hotkey",false);
				// lethotkeySettingList.FindChildTraverse("hotkey_setting"+abilityCount);
			}else{
				var message = "#HUD_Hotkey_setting_error_1";
				var sound = "General.Cancel";
				GameUI.SendCustomHUDError( message, sound );
			}
			// $.Msg(textPanel.text);
		}
		// hotkeyState[abilityIndex] = 
    });
}


function CreateRandomHotKey(hotkey,index){
    let key = hotkey;
    const command = `On${key}${Date.now()}`;
    Game.CreateCustomKeyBind(key, `+${command}`);
    Game.AddCommand(
        `+${command}`,
        () => {
            PreAbility(index);
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



function PreAbility(abilityIndex){
    // Abilities.ExecuteAbility(item, hero, false);
	let localPlayerID = Players.GetLocalPlayer();
	let localPortraitUnit = Players.GetLocalPlayerPortraitUnit();
	let bControllable = Entities.IsControllableByPlayer(localPortraitUnit, localPlayerID);
	let abilityCount = 0;
	if (bControllable) {
		// 找到绑定的第几个技能
		for (let i = 0; i < abilities.GetChildCount(); i++) {
			let abilityPanel = abilities.GetChild(i);
			if (abilityCount==abilityIndex) {
				let abilityImage = abilityPanel.FindChildTraverse("AbilityImage");
				let ability = abilityImage.contextEntityIndex;
				Abilities.ExecuteAbility(ability, localPortraitUnit, false);
			}
	
		
			if (!abilityPanel.BHasClass("Hidden"))
				abilityCount++;
		}
	}

}

let dataList ={};
function UpdateAbilityData(keys){
	dataList ={};
	let heroSpells = keys[1];
    let spellsCost = keys[2];
    let nextSpells = keys[3];
	for (const key in heroSpells) {
		if (Object.hasOwnProperty.call(heroSpells, key)) {
			const element = heroSpells[key];
			dataList[heroSpells[key]] = {
				name : heroSpells[key],
				cost :spellsCost[key],
				nextSpells:nextSpells[key],

			}
		}
	}


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
	let NetTable_key = "playerUpgrade_"+Game.GetLocalPlayerID();

	if (tableKeyName==NetTable_key) {
		UpdateAbilityData(table);
	}
	if (tableKeyName=="hd_game_mode") {
        if (table.ChaoticEraMod==1) {
			// $.Msg("ok");
			isChaoticEraMode = true;
        }
    }


}


function UpdatePlayerArtifactDataNetTable(tableName, tableKeyName, table) {

	// var localPlayerID = Players.GetLocalPlayer();
	// if (Players.IsSpectator(localPlayerID)) {
    //     return;
	// }
	// let playerID = Game.GetLocalPlayerID();
	if (tableKeyName =="playerArtifact") {
        GameUI.CustomUIConfig().artifactData = table;
	


	}
	

	
}


function OpenHotkeySetting(){
	$("#hotKeySetting").ToggleClass("active");
}

var g_nMovingCameraOffset = 600;
var g_nStillCameraOffset = 0;
var g_flTimeSpentMoving = 0.0;
var HUD_THINK = 0.005;
var g_bInBossIntro = false;
var g_bBossFightStart = false;
var g_nBossCameraEntIndex = -1;
var g_nBossEntIndex = -1;
var g_flCameraDesiredOffset = 128.0;
var g_flCameraYawSpeed = 0.05;
var g_flInitialYaw = 0;
var g_flAdditionalCameraOffset = 0.0;
var g_flMaxLookDistance = 1200.0;
var g_bSentGuideDisable = false;
var g_szLastZoneLocation = null;
var g_cameraDistance = 1200;
var g_ZoneList = [ 	"start", 
					"forest", 
					"forest_holdout", 
					"darkforest_death_maze", 
					"darkforest_rescue", 
					"darkforest_pass", 
					"underground_temple", 
					"desert_start", 
					"desert_town", 
					"desert_expanse",
					"desert_outpost",
					"desert_chasm",
					"desert_fortress" 
];


function OnBossIntroBegin( data ){
	$( "#BossProgressBar" ).value = 0;
	$( "#BossHP").SetHasClass( data["BossName"], true );
	// $( "#BossIcon" ).SetHasClass( data["BossName"], true );
	$( "#BossLabel" ).text = $.Localize("#"+ data["BossName"] );
	
	if ( g_bInBossIntro === true )
		return;

	if ( data["SkipIntro"] )
		return;

	Game.EmitSound( "Dungeon.Stinger02" );
	Game.EmitSound( "Dungeon.BossBar" );

	$( "#BossHP").SetHasClass( "Visible", true );

	// $( "#DialogPanel" ).SetHasClass( "Visible", data["DialogText"] != "" );
	//$( "#DialogTitle" ).text = $.Localize( Entities.GetUnitName( data["DialogEntIndex"] ) );
	// g_nCurrentDialogEnt = data["DialogEntIndex"];
	// g_nCurrentDialogLine = data["DialogLine"];

	g_flInitialYaw = GameUI.GetCameraYaw();
	g_nBossCameraEntIndex = data["BossEntIndex"];
	g_nBossEntIndex = data["BossEntIndex"];
	
	if ( typeof( data["BossEntIndex"] ) != "undefined" )
	{
		GameUI.SetCameraTarget( data["BossEntIndex"] );
	}
	if ( typeof( data["CameraPitch"] ) != "undefined" )
	{
		GameUI.SetCameraPitchMin( data["CameraPitch"] );
		GameUI.SetCameraPitchMax( data["CameraPitch"] );
	}
	if ( typeof( data["CameraDistance"] ) != "undefined" )
	{
		GameUI.SetCameraDistance( data["CameraDistance"] );
	}
	if ( typeof( data["CameraLookAtHeight"] ) != "undefined" )
	{
		GameUI.SetCameraLookAtPositionHeightOffset( data["CameraLookAtHeight"] );
	}
	if ( typeof( data["camera_yaw_rotate_speed"] ) != "undefined" )
	{
		g_flCameraYawSpeed = data["camera_yaw_rotate_speed"];
	}
	if ( typeof( data["camera_inital_yaw"] ) != "undefined" )
	{
		GameUI.SetCameraYaw( g_flInitialYaw + data["camera_inital_yaw"] )
	}

	g_bBossFightStart = true
	g_bInBossIntro = true;
}
GameEvents.Subscribe( "boss_intro_begin", OnBossIntroBegin );


function OnBossIntroEnd( data )
{
	g_bInBossIntro = false;
	g_nBossCameraEntIndex = -1;
	GameUI.SetCameraPitchMin( 38 );
	GameUI.SetCameraPitchMax( 60 );
	GameUI.SetCameraDistance( GameUI._G_cameraDistance );
	GameUI.SetCameraLookAtPositionHeightOffset( 0 );
	GameUI.SetCameraTarget( -1 );
	GameUI.SetCameraYaw( g_flInitialYaw );

	// $( "#DialogPanel" ).SetHasClass( "Visible", false );
	// UpdateCameraLockedPos();

	g_flCameraYawSpeed = 0.05;
}

GameEvents.Subscribe( "boss_intro_end", OnBossIntroEnd );
function BossHPTickUp()
{
	if ( $( "#BossProgressBar" ).value < 1.0 )
	{
		$( "#BossProgressBar" ).value = $( "#BossProgressBar" ).value + 0.025;
	}
}
$( "#BossHP").SetHasClass( "Visible", false );
function UpdateBossHP()
{
	// var key = 0;
	// var bossData = CustomNetTables.GetTableValue( "boss", key.toString() );
	// if ( typeof( bossData ) != "undefined" )
	// {
	// 	var nBossHP = bossData["boss_hp"];
	// 	var bShowBossHP = bossData["bosses_alive"] > 0 ? true : false;

	let nBossHP = Entities.GetHealth(g_nBossEntIndex);
	let maxHpP =  Entities.GetMaxHealth(g_nBossEntIndex);
	let alive = Entities.IsAlive(g_nBossEntIndex);
	$( "#BossProgressBar" ).value = (nBossHP/maxHpP);
	// $.Msg("aaaaaaaaaaaaaaa",alive);
	
	if (!alive) {
		// $.Msg("bbbbbbbb");
		$( "#BossHP").SetHasClass( "Visible", false );
		g_bBossFightStart = false;
	}

}



(function HUDThink()
{	
	// var flThink = HUD_THINK;
	var flThink = 1;
	// $.Msg("gooo");

	if (g_bBossFightStart) {
		if ( g_bInBossIntro ) {
			GameUI.SetCameraYaw( GameUI.GetCameraYaw() + g_flCameraYawSpeed );
			BossHPTickUp();
			
			flThink = 0.003;
		}
		else {
			UpdateBossHP()
		}
	}
	
	$.Schedule( flThink, HUDThink );
})();







// $("#artifactList").RemoveAndDeleteChildren();
function updateSlots() {
	if (IsNull(InventoryContainer)) {
		InventoryContainer = dotaHud.FindChildTraverse("InventoryContainer");
	}
	if (isChaoticEraMode && !IsNull(InventoryContainer)) {
		$("#artifactList").SetHasClass("hidden",false);
		// $.Msg("aaaa");
		const iMaxEquipmentSlotCount = 4;

		const iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();
		let localPlayerID = Entities.GetPlayerOwnerID(iLocalPortraitUnit);
		let artifactData = GameUI.CustomUIConfig().artifactData[localPlayerID];

		let pass = false;
		// 注意 对于非玩家皆为-1
		if(localPlayerID==Game.GetLocalPlayerID() && Entities.IsRealHero(iLocalPortraitUnit) ){
			pass = true;
		}




		{
			const tEquipmentSlot = CustomNetTables.GetTableValue("equipment_slot", iLocalPortraitUnit) ?? {};
			// const iMaxEquipmentSlotCount = safeNumber(Players.GetPlayerData(Entities.GetPlayerOwnerID(iLocalPortraitUnit), "GetMaxEquipmentSlotCount"), MAX_EQUIPMENT_SLOT_COUNT);
		
			for (let index = 1; index <= iMaxEquipmentSlotCount; index++) {
				let data = tEquipmentSlot[""+index];
				let customPanel = $("#artifactList").FindChildTraverse("artifact_slot" + index.toString());
				if (IsNull(customPanel)) {
					customPanel = $.CreatePanel("Panel", $("#artifactList"), "artifact_slot" + index.toString());
					customPanel.BLoadLayoutSnippet("playerArtifactSlot");
				}
				if (data) {
					// 有圣物的情况下
					let element = artifactKV[data.name];

					customPanel.FindChildTraverse("EquipmentExpandButton").style.backgroundImage = "url('s2r://panorama/images/custom_game/chaotic_era/PlayerArtifact/"+element.IconName+".png')";;

					if (artifactData) {
						InitArtifactHover(customPanel,artifactData,data.name,element.rarity);
					}
					if (pass) {
						SetUpGetPlayerArtifactEvent(customPanel,false,true,index,data.name);
					}else{
						customPanel.ClearPanelEvent("onactivate");
					}
					// $.Msg("data.bIsEquip=",data)
					if (data.bIsEquip==0) {
						// 未装备情况
						customPanel.SetHasClass("unEquip",true);
					}else{
						customPanel.SetHasClass("unEquip",false);
					}
					
				}else{
					customPanel.ClearPanelEvent("onmouseover");
					customPanel.ClearPanelEvent("onmouseout");
					customPanel.FindChildTraverse("EquipmentExpandButton").style.backgroundImage = "none";;
					if (pass) {
						SetUpGetPlayerArtifactEvent(customPanel,true,false,-1,"");
					}else{
						customPanel.ClearPanelEvent("onactivate");
					}
					
				}

			
			}

			let position = InventoryContainer.GetPositionWithinWindow();
			$("#artifactList").SetPositionInPixels(position.x / $("#artifactList").actualuiscale_x, position.y / $("#artifactList").actualuiscale_y-50, 0);
		

		}




	}
	
}


function SetUpGetPlayerArtifactEvent(panel,bShowTakeButton,bShowClearButton,ClearIndex,artifactName) {
	panel.ClearPanelEvent("onactivate");
	panel.SetPanelEvent("onactivate", function () {
		SetGetPlayerArtifactEvent(bShowTakeButton,bShowClearButton,ClearIndex,artifactName);
	});
}

// ClearArtifactSlot


function SetGetPlayerArtifactEvent(bShowTakeButton,bShowClearButton,ClearIndex,artifactName) {

	const contextMenu = GetPlayerArtifactRoot;
	contextMenu.SetAcceptsFocus(true);
	contextMenu.SetDisableFocusOnMouseDown(true);
	contextMenu.SetFocus();
	contextMenu.UpdateFocusInContext();
	contextMenu.SetPanelEvent("onblur", () => {
		// contextMenu.DeleteAsync(0);
		contextMenu.SetHasClass("hidden",true);

	});
	contextMenu.SetHasClass("hidden",false);

	const pos = GameUI.GetCursorPosition();
	contextMenu.SetPositionInPixels(pos[0] / contextMenu.actualuiscale_x+30, pos[1] / contextMenu.actualuiscale_y-20, 0);
	if (bShowTakeButton) {
		contextMenu.FindChildTraverse("GoToArtifactList").SetHasClass("hidden",false);
	}else{
		contextMenu.FindChildTraverse("GoToArtifactList").SetHasClass("hidden",true);
	}
	if (bShowClearButton) {
		contextMenu.FindChildTraverse("ClearArtifactSlot").SetHasClass("hidden",false);
		contextMenu.FindChildTraverse("ClearArtifactSlot").ClearPanelEvent("onactivate");
		contextMenu.FindChildTraverse("ClearArtifactSlot").SetPanelEvent("onactivate", function () {
			var event_data = {
				player_id: Game.GetLocalPlayerID(),
				ClearIndex : ClearIndex,
				name :artifactName
			}
			GameEvents.SendCustomGameEventToServer("TryClearArtifact", event_data);
			contextMenu.SetHasClass("hidden",true);

		});
	}else{
		contextMenu.FindChildTraverse("ClearArtifactSlot").SetHasClass("hidden",true);
	}

}



function OpenArtifactList(){

	GameEvents.SendEventClientSide("openArtifactList", {

	});
	GetPlayerArtifactRoot.SetHasClass("hidden",true);
}











const dotaHud = (() => {
    let panel = $.GetContextPanel();
    while (panel) {
        if (panel.id === "DotaHud") return panel;
        panel = panel.GetParent();
    }
})();
(function () {
	$("#AbilitiesCustomUIContainer").RemoveAndDeleteChildren();
	hotkeySettingList.RemoveAndDeleteChildren();
	// var HUD = $.GetContextPanel().GetParent().GetParent().GetParent();
	// CustomUIRoot = HUD.FindChildTraverse("CustomUIRoot");
	
	CustomNetTables.SubscribeNetTableListener( "boss", UpdateBossHP )
	
	
    CustomUIConfig.SubscribeNetTableListener("game_data", UpdateCommonNetTable);
	let NetTable_key = "playerUpgrade_"+Game.GetLocalPlayerID();
	UpdateCommonNetTable("game_data", NetTable_key, CustomNetTables.GetTableValue("game_data", NetTable_key));



    CustomUIConfig.SubscribeNetTableListener("game_config", UpdateCommonNetTable);
	UpdateCommonNetTable("game_config", "hd_game_mode", CustomNetTables.GetTableValue("game_config", "hd_game_mode"));

	CustomUIConfig.SubscribeNetTableListener("chaoticEraData", UpdatePlayerArtifactDataNetTable);

	UpdatePlayerArtifactDataNetTable("chaoticEraData", "playerArtifact", CustomNetTables.GetTableValue("chaoticEraData", "playerArtifact"));

    CustomNetTables.SubscribeNetTableListener("equipment_slot", updateSlots);
    GameEvents.Subscribe("dota_player_update_selected_unit", updateSlots);
    GameEvents.Subscribe("dota_player_update_query_unit", updateSlots);


	Update();





	const sPauseCommand = "custom_pause" + Date.now();
	Game.AddCommand(sPauseCommand, () => {
		GameEvents.SendCustomGameEventToServer("CustomTogglePause", {});
	}, "desc", 0);
	Game.CreateCustomKeyBind(Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_PAUSE), sPauseCommand);



	
})();


