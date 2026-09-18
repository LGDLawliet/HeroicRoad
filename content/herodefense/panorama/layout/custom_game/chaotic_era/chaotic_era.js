const ChaoticEraSpellsListPanel =  $("#ChaoticEraSpellsListPanel");
const ShowSpellsListButton =  $("#ShowSpellsListButton");
const ChaoticEraSpellsList_Mask =  $("#ChaoticEraSpellsList_Mask");

const MonsterPanel = $("#MonsterPanel");
const MonsterCount_Progress_Left = MonsterPanel.FindChildInLayoutFile("MonsterCount_Progress_Left");
const MonsterCount_Progress = MonsterPanel.FindChildInLayoutFile("MonsterCount_Progress");
const ChaoticEraSpellsListContainer =  $("#ChaoticEraSpellsListContainer");
const bossSummon_Progress_Left = MonsterPanel.FindChildInLayoutFile("bossSummon_Progress_Left")

{
	let keys ={
		title :$.Localize("#HUD_Boss_Summon_wave_Title"),
		text :$.Localize("#HUD_Boss_Summon_wave_Info"),
	}
	SetBaseAdavncedInfoHoverEvent(MonsterPanel.FindChildInLayoutFile("bossSummon_Progress"),keys);
	
}
const MissingCountWarningDigit1 = $("#MissingCountWarningDigit1");
const MissingCountWarningDigit2 = $("#MissingCountWarningDigit2");
const MissingCountWarningDigit3 = $("#MissingCountWarningDigit3");
MissingCountWarningDigit1.SetHasClass("Hidden", true);
MissingCountWarningDigit2.SetHasClass("Hidden", true);
MissingCountWarningDigit3.SetHasClass("Hidden", true);

const rerollSpellButton1 =  $("#rerollSpellButton1");
const rerollSpellButton2 =  $("#rerollSpellButton2");

let gameModInit = false;
let BaseSetting_KV = GameUI.CustomUIConfig().BaseSetting_KV;
let failTimer = -1;
let current_wave = 0;

let Chaotic_Era_upgrade_attribute = 0;
let Chaotic_Era_upgrade_progress = 0
let TaskModifyData;
// let currentSpellData;
function UpdateChaoticEraDataNetTable(tableName, tableKeyName, table) {

	var localPlayerID = Players.GetLocalPlayer();
	if (Players.IsSpectator(localPlayerID)) {
        // 如果是观战的情况下就把切换ID到点击的单位身上
		// localPlayerID = -1;
		// if (Players.GetLocalPlayerPortraitUnit() != -1) {
		// 	localPlayerID = Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit());
		// }
        return;
	}
	let playerID = Game.GetLocalPlayerID();
	let netKey = "spellList_waitForSelected"+playerID;
	
	let artifactKey = "chaotic_era_artifact_"+playerID;
	let task_modifyKey = "chaotic_era_task_modify_"+playerID;


	if (tableKeyName ==netKey) {
        // 侦测player_fellomen_boss_list的改变
		if (localPlayerID == -1) return;
        // $.Msg(table);
		let tData = table;
		// let tData = table[localPlayerID.toString()];
		if (tData == null || tData == undefined) {
			// 说明已经选完技能了 需要隐藏面板
			HideAllSelectListPanelState();
			return;
		}
		HideAllSelectListPanelState();
		let pass = false;
		for (const key in tData) {
			pass  = true;
		}
		if (pass) {
			$.Schedule(0.5, function () {
				GenerateSpellSelectList(tData);
			})
		}
		






	}
	if (tableKeyName ==artifactKey) {
		if (localPlayerID == -1) return;
		let tData = table;
		if (tData == null || tData == undefined) {
			// 说明已经选完技能了 需要隐藏面板
			// HideAllSelectListPanelState();
			return;
		}
		// $.Msg("goooooo");
		// $.Msg(table);
		
		InitArtifactSelect(tData);





	}
	if (tableKeyName ==task_modifyKey) {
		if (localPlayerID == -1) return;
		let tData = table;
		if (tData == null || tData == undefined) {
			// 说明已经选完技能了 需要隐藏面板
			// HideAllSelectListPanelState();
			return;
		}
		// $.Msg("goooooo");
		// $.Msg(tData);
		TaskModifyData = tData;
		// InitArtifactSelect(tData);





	}
	if (tableKeyName=="bonusAttribute_cost") {
		if (localPlayerID == -1) return;
		let tData = table;
		if (tData == null || tData == undefined) {
			return;
		}
		// $.Msg(tData);
		SetBonusAttributesCost(tData)

	}
	if (tableKeyName=="bonusAttribute") {
		if (localPlayerID == -1) return;
		let tData = table;
		if (tData == null || tData == undefined) {
			return;
		}
		$.Msg(tData);
		SetPlayerBonusAttributes(tData)

	}

	
}



const ConfirmSpellListButton = $("#ConfirmSpellListButton");
let currentSelectSpell;
let currentSelectButton;
function GenerateSpellSelectList(tData) {
	SetSpellSelectListPanelState(true);
	Game.EmitSound( "ui_hero_select_slide" );
	ChaoticEraSpellsListContainer.RemoveAndDeleteChildren();  //先清除

	currentSelectSpell = null;
	currentSelectButton = null;
	var spellsContainer = ChaoticEraSpellsListContainer;
	ConfirmSpellListButton.SetHasClass("active",false);
	let index = 0;
	for (const key in tData) {
		if (Object.hasOwnProperty.call(tData, key)) {
			const spellName = tData[key];
			let spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + index);
			spellPanel.BLoadLayoutSnippet("general_spell"); //载入模块
			// single_general_spell
			let abilityImage = spellPanel.FindChildInLayoutFile("single_general_spell");
			abilityImage.abilityname = spellName;

			spellPanel.SetDialogVariable("spellName",  $.Localize("#DOTA_Tooltip_ability_"+spellName));

			addSpellInfoHoverEvens(abilityImage,spellName);
			AddLearnSpellEvent_ChaoticEra(abilityImage,spellName,spellPanel);
			let abilityType = GetAbilityType(spellName);
			if (abilityType==ABILITY_TYPE_GENERAL_SHOP) {
				let target = spellPanel.FindChildInLayoutFile("spell_tyle_label");
				target.SetDialogVariable("spelltype",  $.Localize("#HUD_Chaotic_era_spell_type_1"));

				let keys ={
					text : $.Localize("#HUD_Chaotic_era_spell_type_1_info"),
					title :$.Localize("#HUD_Chaotic_era_detail"),
				}
				SetBaseAdavncedInfoHoverEvent(target,keys)
			}else if (abilityType==ABILITY_TYPE_CHAOTIC_ERA_SPECIAL) {
				let target = spellPanel.FindChildInLayoutFile("spell_tyle_label");
				target.SetDialogVariable("spelltype",  $.Localize("#HUD_Chaotic_era_spell_type_2"));

				let keys ={
					text : $.Localize("#HUD_Chaotic_era_spell_type_2_info"),
					title :$.Localize("#HUD_Chaotic_era_detail"),
				}
				SetBaseAdavncedInfoHoverEvent(target,keys)
			}




		
		}
	}


	let key = "chaoticEra_spellReroll_"+Game.GetLocalPlayerID();
	let netData = CustomNetTables.GetTableValue("game_config", key);
	if (netData) {
		if (netData.freeReRollAbility>=1) {
			rerollSpellButton1.SetHasClass("show",true);
			rerollSpellButton1.SetDialogVariable("count",netData.freeReRollAbility);
		}else{
			rerollSpellButton1.SetHasClass("show",false);
			if (netData.rerollAbilityCharge>=1) {
				rerollSpellButton2.SetHasClass("show",true);
				rerollSpellButton2.SetDialogVariable("cost",netData.rerollAurumCost);
				rerollSpellButton2.SetDialogVariable("charge",netData.rerollAbilityCharge);

			}else{
				rerollSpellButton2.SetHasClass("show",false);
			}
		}
	}else{
		rerollSpellButton1.SetHasClass("show",false);
		rerollSpellButton2.SetHasClass("show",false);
	}

}


function RerollSpell() {
	var event_data = {
       
    }
    GameEvents.SendCustomGameEventToServer("RerollAbility",  event_data );
}

// 控制技能选择面板开关
function SetSpellSelectListPanelState(state) {
	ChaoticEraSpellsListPanel.SetHasClass("show_state", state);
	ShowSpellsListButton.SetHasClass("show_state", !state);
	ChaoticEraSpellsList_Mask.SetHasClass("hidden", state);
}
function HideAllSelectListPanelState(){
	ChaoticEraSpellsListPanel.SetHasClass("show_state", false);
	ShowSpellsListButton.SetHasClass("show_state", false);
	ChaoticEraSpellsList_Mask.SetHasClass("hidden", false);
}

// 隐藏技能选择面板开关
function HideChaoticEraSpellsListPanel() {
	SetSpellSelectListPanelState(false);
}
function ShowChaoticEraSpellsListPanel() {
	SetSpellSelectListPanelState(true);
}

// 放弃选择
function GiveupChaoticEraSpellsListPanel() {
	var event_data = {
       
    }
    GameEvents.SendCustomGameEventToServer("GiveChaoticEraSpell",  event_data );
}
function AddLearnSpellEvent_ChaoticEra(targetPanel,spellName,spellPanel) {
	
	targetPanel.SetPanelEvent("onactivate", function () {
		currentSelectSpell = spellName;
		ConfirmSpellListButton.SetHasClass("active",true);
		spellPanel.SetHasClass("active",true);
		$.Msg("ok");
		if (IsValidPanel(currentSelectButton)) {
			currentSelectButton.SetHasClass("active",false);
		}
		currentSelectButton = spellPanel;
        // LearnAbility_ChaoticEra(spellName);
    });

}


function ConfirmLearnSpell() {
	if (currentSelectSpell) {
		var event_data = {
			spellName : currentSelectSpell
		}
		GameEvents.SendCustomGameEventToServer("LearnChaoticEraSpell",  event_data );
	}
}



let gameWaveFirstInit = false;
let chaoticEra_recordTime = 0;
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
			MonsterPanel.SetHasClass("show",true);

        }
    }
	if (tableKeyName=="chaoticEraSpawnerData") {
		MonsterPanel.SetDialogVariable("max_count",table.max_unit_count);
		let percentage = Math.min(table.current_unit_count/table.max_unit_count,1)*100;
		MonsterCount_Progress_Left.style.width = percentage+"%";
		MonsterPanel.SetDialogVariable("current_count",table.current_unit_count);

		// $.Msg(table);
		MonsterPanel.SetDialogVariable("wave_count",table.wave_count);


		{
			let percentage_boss = Math.min(table.wave_count/table.max_wave,1)*100;
			MonsterPanel.SetDialogVariable("remain_wave",table.max_wave-table.wave_count);
			bossSummon_Progress_Left.style.width = percentage_boss+"%";
			// $.Msg("percentage_boss=",percentage_boss);
	
		}
	

		Chaotic_Era_upgrade_attribute = table.Chaotic_Era_upgrade_attribute;
		Chaotic_Era_upgrade_progress = table.Chaotic_Era_upgrade_progress;




		if (percentage>=100) {
			MonsterCount_Progress.SetHasClass("max_warning",true);
		}else{
			MonsterCount_Progress.SetHasClass("max_warning",false);
		}
		failTimer = table.failTimer;
		if (current_wave!=table.wave_count) {
			current_wave = table.wave_count;
			// $.Msg("wave changing");
			OnCurrentWaveChange();
		}
		

	}
	if (tableKeyName=="chaoticEra_RuneProgress") {
		UpdateRuneProgress(table);
	}
	if (tableKeyName=="chaoticEra_spawnList") {
		UpdateTaskList(table);
	}
	if (tableKeyName=="chaoticEra_TaskList") {
		// $.Msg("chaoticEra_TaskList")
		// $.Msg(table);
		UpdateTaskSelectList(table);
	}

	if (tableKeyName=="chaoticEra_RecordTime") {
        if (!gameWaveFirstInit) {
            gameWaveFirstInit = true;
            chaoticEra_recordTime = table.time;
			UpdateChaoticEraWaveTimer();
        }
    }

	if (tableKeyName=="chaoticEra_mapEffect") {
		// $.Msg(table);
		InitMapEffectSelect(table);
	}
}

let LastWarningTime = -1;

let zeroReset = false;
function UpdateFailTimer() {
	if (failTimer!=-1) {
		// $.Msg(failTimer);
		let number = failTimer-Game.GetGameTime();
		let remainTime = Math.max(Math.floor(number),0);
		// $.Msg("remainTime=",remainTime);


		if (!zeroReset && LastWarningTime != -1 && Math.ceil(LastWarningTime) - Math.ceil(remainTime) > 0) {
			Game.EmitSound("ui.quest_select");
			$("#MissingCountWarningFx").FireEntityInput("particle_1", "Stop", "1");
			$("#MissingCountWarningFx").FireEntityInput("particle_1", "Start", "1");
			$("#MissingCountWarningFx").SetHasClass("show", true);
			// let iParticleID = Particles.CreateParticle("particles/generic_gameplay/warning_screen.vpcf", ParticleAttachment_t.PATTACH_EYES_FOLLOW, Players.GetLocalPlayerPortraitUnit());
			// Particles.ReleaseParticleIndex(iParticleID);
		}
		LastWarningTime = remainTime;

		// var remainTime = Math.ceil(LastWarningTime);


		MissingCountWarningDigit1.SetHasClass("Hidden", remainTime < 0);
		MissingCountWarningDigit2.SetHasClass("Hidden", remainTime < 10);
		MissingCountWarningDigit3.SetHasClass("Hidden", remainTime < 100);
		MissingCountWarningDigit1.SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((remainTime % 10)) + "_v2.png");
		MissingCountWarningDigit2.SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((remainTime / 10) % 10) + "_v2.png");
		MissingCountWarningDigit3.SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((remainTime / 100) % 100) + "_v2.png");
	
		if (remainTime==0) {
			zeroReset = true;
		}
	}else{
		if (LastWarningTime!=-1) {
			MissingCountWarningDigit1.SetHasClass("Hidden", true);
			MissingCountWarningDigit2.SetHasClass("Hidden", true);
			MissingCountWarningDigit3.SetHasClass("Hidden", true);
			$("#MissingCountWarningFx").SetHasClass("show", false);
			LastWarningTime = -1;
			zeroReset = false;
		}

	}
	$.Schedule( 0.03, UpdateFailTimer );
}






const RuneProgress_level1 = $("#RuneProgress_level1");
const RuneProgress_level2 = $("#RuneProgress_level2");
const RuneProgress_level3 = $("#RuneProgress_level3");
const RuneProgress_level4 = $("#RuneProgress_level4");
const RuneProgress_level5 = $("#RuneProgress_level5");

function UpdateRuneProgress(data) {
	RuneProgressRoot.SetHasClass("state_show",true);
	if (true) {
		RuneProgress_level1.SetDialogVariable("current",Math.floor(data.level1.current*100)/100);
		RuneProgress_level1.SetDialogVariable("require",Math.floor(data.level1.require*100)/100);
		RuneProgress_level1.SetDialogVariable("current_count",Math.floor(data.level1.count));
		RuneProgress_level1.FindChildInLayoutFile("RuneProgress_Left").style.width = (data.level1.current/data.level1.require*100)+"%";
	}
	if (true) {
		RuneProgress_level2.SetDialogVariable("current",Math.floor(data.level2.current*100)/100);
		RuneProgress_level2.SetDialogVariable("require",Math.floor(data.level2.require*100)/100);
		RuneProgress_level2.SetDialogVariable("current_count",Math.floor(data.level2.count));
		RuneProgress_level2.FindChildInLayoutFile("RuneProgress_Left").style.width = (data.level2.current/data.level2.require*100)+"%";
	}
	if (true) {
		RuneProgress_level3.SetDialogVariable("current",Math.floor(data.level3.current*100)/100);
		RuneProgress_level3.SetDialogVariable("require",Math.floor(data.level3.require*100)/100);
		RuneProgress_level3.SetDialogVariable("current_count",Math.floor(data.level3.count));
		RuneProgress_level3.FindChildInLayoutFile("RuneProgress_Left").style.width = (data.level3.current/data.level3.require*100)+"%";
	}
	if (true) {
		RuneProgress_level4.SetDialogVariable("current",Math.floor(data.level4.current*100)/100);
		RuneProgress_level4.SetDialogVariable("require",Math.floor(data.level4.require*100)/100);
		RuneProgress_level4.SetDialogVariable("current_count",Math.floor(data.level4.count));
		RuneProgress_level4.FindChildInLayoutFile("RuneProgress_Left").style.width = (data.level4.current/data.level4.require*100)+"%";
	}
	if (true) {
		RuneProgress_level5.SetDialogVariable("current",Math.floor(data.level5.current*100)/100);
		RuneProgress_level5.SetDialogVariable("require",Math.floor(data.level5.require*100)/100);
		RuneProgress_level5.SetDialogVariable("current_count",Math.floor(data.level5.count));
		RuneProgress_level5.FindChildInLayoutFile("RuneProgress_Left").style.width = (data.level5.current/data.level5.require*100)+"%";
	}
}

let unitList = [];
const ChaoticEraTask_Set = $("#ChaoticEraTask_Set");
function UpdateTaskList(data) {
	ChaoticEraTask_Set.RemoveAndDeleteChildren();
	unitList = [];
	let index = 0;
	for (const key in data) {
		if (Object.hasOwnProperty.call(data, key)) {
			index++;
			const element = data[key];
			$.Msg(element);
			let attribute = element.attribute;
			let runeProgress = element.runeProgress;

			let name =element.UnitName;

			let targetPanel = $.CreatePanel("Panel", ChaoticEraTask_Set, "unitTask_" + index);
			targetPanel.BLoadLayoutSnippet("singleTask_snippet"); //载入模块

			targetPanel.SetDialogVariable("unitName",$.Localize("#"+name));
			// targetPanel.SetDialogVariable("level1",(Math.floor(runeProgress.level1*1000)/1000));
			// targetPanel.SetDialogVariable("level2",(Math.floor(runeProgress.level2*1000)/1000));
			// targetPanel.SetDialogVariable("level3",(Math.floor(runeProgress.level3*1000)/1000));
			// targetPanel.SetDialogVariable("level4",(Math.floor(runeProgress.level4*1000)/1000));
			// targetPanel.SetDialogVariable("level5",(Math.floor(runeProgress.level5*1000)/1000));
			targetPanel.SetDialogVariable("level1",(runeProgress.level1*1).toFixed(3));
			targetPanel.SetDialogVariable("level2",(runeProgress.level2*1).toFixed(3));
			targetPanel.SetDialogVariable("level3",(runeProgress.level3*1).toFixed(3));
			targetPanel.SetDialogVariable("level4",(runeProgress.level4*1).toFixed(3));
			targetPanel.SetDialogVariable("level5",(runeProgress.level5*1).toFixed(3));

			targetPanel.SetDialogVariable("count",element.count);
			targetPanel.SetDialogVariable("interval",Math.floor(element.interval*10)/10);

			let health = (attribute.baseHealth + attribute.bonusHealth * current_wave) * Math.pow(attribute.HealthPow,current_wave);
			let damage = (attribute.baseAttackDamage + attribute.bonusAttackDamage * current_wave) * Math.pow(attribute.DamagePow,current_wave);
			let bounty = (attribute.bounty + attribute.bonusBounty * current_wave)
				
			targetPanel.SetDialogVariable("health",Math.floor(health));
			targetPanel.SetDialogVariable("attackdamage",Math.floor(damage));
			targetPanel.SetDialogVariable("bonus_count",element.bonus_count);
			targetPanel.SetDialogVariable("bounty",Math.floor(bounty));

			targetPanel.unit_attribute = attribute;
			unitList[unitList.length] = targetPanel;



			targetPanel.FindChildInLayoutFile("TaskImage").style.backgroundImage = "url('s2r://panorama/images/custom_game/unit_image/"+name+".png')";


			let keys ={
				title :$.Localize("#"+name),
				text :$.Localize("#"+name+"_info"),
			}
			SetBaseAdavncedInfoHoverEvent(targetPanel.FindChildInLayoutFile("TaskImage"),keys);


			SetUpTaskModifyEvent(targetPanel.FindChildInLayoutFile("TaskModifyAddIcon"),element.taskId);
			let taskModifyList = targetPanel.FindChildInLayoutFile("modifyListPanel");
			let id = 0;
			for (const key in element.modifyCallBackList) {
				if (Object.hasOwnProperty.call(element.modifyCallBackList, key)) {
					const modifyData = element.modifyCallBackList[key];
					// $.Msg(modifyData);
					AddTaskModify(taskModifyList,modifyData,id);
					id++;
				}
			}
		}
	}

}

function OnCurrentWaveChange() {
	for (let index = 0; index < unitList.length; index++) {
		const targetPanel = unitList[index];
		if (IsValidPanel(targetPanel)) {
			let attribute = targetPanel.unit_attribute;
			let health = (attribute.baseHealth + attribute.bonusHealth * current_wave) * Math.pow(attribute.HealthPow,current_wave);
			let damage = (attribute.baseAttackDamage + attribute.bonusAttackDamage * current_wave) * Math.pow(attribute.DamagePow,current_wave);
			let bounty = (attribute.bounty + attribute.bonusBounty * current_wave)
					
			targetPanel.SetDialogVariable("health",Math.floor(health));
			targetPanel.SetDialogVariable("attackdamage",Math.floor(damage));
			targetPanel.SetDialogVariable("bounty",Math.floor(bounty));
		}

	}
}



let currentIndex = -1;
function UpdateTaskSelectList(data){
	// ChaoticEraTaskSelect_Set.RemoveAndDeleteChildren();
	if (data.currentIndex !=currentIndex) {
		TaskSelectMenuOpenButton.SetHasClass("show",false);
		TaskSelectMenuOpenButton.SetHasClass("warning",true);
		ChaoticEraTaskSelectRoot.SetHasClass("show",false);
		ChaoticEraTaskSelect_Set.RemoveAndDeleteChildren();
		// UpdateCommonNetTable("game_config", "chaoticEra_TaskList", CustomNetTables.GetTableValue("game_config", "chaoticEra_TaskList"));
	}
	currentIndex = data.currentIndex;
	// $.Msg("ok");
	let pass = false;
	for (const key in data.list) {
		if (Object.hasOwnProperty.call(data.list, key)) {
			// $.Msg("pass");
			pass = true;
			const element = data.list[key];
			let name =element.UnitName;
			let targetPanel = ChaoticEraTaskSelect_Set.FindChildInLayoutFile("unitTask_" + name);
			if (targetPanel==null) {
				// 初始化数据
				targetPanel = $.CreatePanel("Panel", ChaoticEraTaskSelect_Set, "unitTask_" + name);
				targetPanel.BLoadLayoutSnippet("singleTaskSelect_snippet"); //载入模块
				let attribute = element.attribute;
				let runeProgress = element.runeProgress;
				
				targetPanel.SetDialogVariable("level1",(runeProgress.level1*1).toFixed(3));
				targetPanel.SetDialogVariable("level2",(runeProgress.level2*1).toFixed(3));
				targetPanel.SetDialogVariable("level3",(runeProgress.level3*1).toFixed(3));
				targetPanel.SetDialogVariable("level4",(runeProgress.level4*1).toFixed(3));
				targetPanel.SetDialogVariable("level5",(runeProgress.level5*1).toFixed(3));
				targetPanel.SetDialogVariable("count",element.count);
				targetPanel.SetDialogVariable("bonus_count",element.bonus_count);
				targetPanel.SetDialogVariable("interval",Math.floor(element.interval*10)/10);
				let health = (attribute.baseHealth + attribute.bonusHealth * current_wave) * Math.pow(attribute.HealthPow,current_wave);
				let damage = (attribute.baseAttackDamage + attribute.bonusAttackDamage * current_wave) * Math.pow(attribute.DamagePow,current_wave);
				let bounty = (attribute.bounty + attribute.bonusBounty * current_wave)
				
				targetPanel.SetDialogVariable("health",Math.floor(health));
				targetPanel.SetDialogVariable("attackdamage",Math.floor(damage));
				targetPanel.SetDialogVariable("bounty",Math.floor(bounty));
				targetPanel.unit_attribute = attribute;
				unitList[unitList.length] = targetPanel;
				if (element.shouldHide==1) {
					name = "npc_dota_unkonw";
				}
				targetPanel.SetDialogVariable("unitName",$.Localize("#"+name));
				targetPanel.FindChildInLayoutFile("TaskImage").style.backgroundImage = "url('s2r://panorama/images/custom_game/unit_image/"+name+".png')";
				let keys ={
					title :$.Localize("#"+name),
					text :$.Localize("#"+name+"_info"),
				}
				SetBaseAdavncedInfoHoverEvent(targetPanel.FindChildInLayoutFile("TaskImage"),keys);
				
				SelectTask(targetPanel,element.id);
				SelectTask_Advanced(targetPanel,element.id);
			}
			let selecter = element.selecter;
			let playerSelected= targetPanel.FindChildInLayoutFile("playerSelected");

			targetPanel.FindChildInLayoutFile("selectProgress_Left").style.height = element.progress*100+"%";

			for (const key in selecter) {
				// 设置选择
				if (Object.hasOwnProperty.call(selecter, key)) {
					const element = selecter[key];
					let targetPanel = playerSelected.FindChildInLayoutFile("player_avatar" + key);
					if (targetPanel==null) {
						targetPanel = $.CreatePanel("Panel", playerSelected, "player_avatar" + key);
						targetPanel.BLoadLayoutSnippet("singlePlayerImage"); //载入模块
						targetPanel.FindChildInLayoutFile("avatar").accountid = key;
				
					}
					$.Msg(element);
					if (element>=1) {
						targetPanel.SetHasClass("show",true);
					}else{
						targetPanel.SetHasClass("show",false);
					}
					if (element==2) {
						targetPanel.SetHasClass("advanced_select",true);
					}else{
						targetPanel.SetHasClass("advanced_select",false);
					}
				}
			}
	
		}
	}
	if (pass) {
		TaskSelectMenuOpenButton.SetHasClass("show",true);
	}else{
		TaskSelectMenuOpenButton.SetHasClass("show",false);
	}
}

function SelectTask(targetPanel,id) {
	targetPanel.SetPanelEvent("onactivate", function () {
		var event_data = {
			
			id : id,
			player_id: Game.GetLocalPlayerID(),
		}
		GameEvents.SendCustomGameEventToServer("SelectTargetTask",  event_data );
    });
}
function SelectTask_Advanced(targetPanel,id) {
	targetPanel.FindChildInLayoutFile("UpgradeTaskButton").SetPanelEvent("onactivate", function () {
		var event_data = {
			id : id,
			player_id: Game.GetLocalPlayerID(),
			advanced:1,
		}
		GameEvents.SendCustomGameEventToServer("SelectTargetTask",  event_data );
    });

	targetPanel.FindChildInLayoutFile("UpgradeTaskButton").SetDialogVariable("upgrade_value",Chaotic_Era_upgrade_attribute);
	targetPanel.FindChildInLayoutFile("UpgradeTaskButton").SetDialogVariable("progress_bonus",Chaotic_Era_upgrade_progress);



}






function RefreshTaskSelect() {
	// $.Msg("del all");
	TaskSelectMenuOpenButton.SetHasClass("show",false);
	TaskSelectMenuOpenButton.SetHasClass("warning",true);
	ChaoticEraTaskSelectRoot.SetHasClass("show",false);
	ChaoticEraTaskSelect_Set.RemoveAndDeleteChildren();
	UpdateCommonNetTable("game_config", "chaoticEra_TaskList", CustomNetTables.GetTableValue("game_config", "chaoticEra_TaskList"));

}



const RuneProgressRoot = $("#RuneProgressRoot");
const ChaoticEraTaskRoot = $("#ChaoticEraTaskRoot");
function ToggleProgress() {
	RuneProgressRoot.ToggleClass("show");
}

function ToggleTask() {
	ChaoticEraTaskRoot.ToggleClass("show");
	
}

const TaskSelectMenuOpenButton = $("#TaskSelectMenuOpenButton");
const ChaoticEraTaskSelectRoot = $("#ChaoticEraTaskSelectRoot");
const ChaoticEraTaskSelect_Set = ChaoticEraTaskSelectRoot.FindChildInLayoutFile("ChaoticEraTaskSelect_Set");
function ToggleSelectTask() {
	ChaoticEraTaskSelectRoot.ToggleClass("show");
	TaskSelectMenuOpenButton.SetHasClass("warning",false);
}





const MonsterPanel_LeftBlock_wave_timer = $("#MonsterPanel_LeftBlock_wave_timer");
MonsterPanel_LeftBlock_wave_timer.SetDialogVariable("min",0);
MonsterPanel_LeftBlock_wave_timer.SetDialogVariable("second",0);
function UpdateChaoticEraWaveTimer() {
    // let playerID = Game.GetLocalPlayerID()
    {
        let time = Game.GetGameTime()-chaoticEra_recordTime;
		let min = Math.floor(time/60);
		let second = Math.floor(time%60);

		MonsterPanel_LeftBlock_wave_timer.SetDialogVariable("min",min);
		MonsterPanel_LeftBlock_wave_timer.SetDialogVariable("second",second);
    }


    $.Schedule( 0.03, UpdateChaoticEraWaveTimer );
}





function SetUpTaskModifyEvent(panel,id) {
	panel.SetPanelEvent("onactivate", function () {
		SetTaskModifyClickEvent(id);
	});
}

function SetTaskModifyClickEvent(id) {
	const contextMenu = $.CreatePanel("Panel", $.GetContextPanel(), "");
	contextMenu.AddClass("TaskModifyContextMenu");
	contextMenu.BLoadLayoutSnippet("TaskModifyContext");
	contextMenu.SetAcceptsFocus(true);
	contextMenu.SetDisableFocusOnMouseDown(true);
	contextMenu.SetFocus();
	contextMenu.UpdateFocusInContext();
	contextMenu.SetPanelEvent("onblur", () => {
		contextMenu.DeleteAsync(0);
	});

	const pos = GameUI.GetCursorPosition();
	contextMenu.SetPositionInPixels(pos[0] / contextMenu.actualuiscale_x, pos[1] / contextMenu.actualuiscale_y, 0);


	const setCMBtnEvt = (targetPanel,modifyID,taskId) => {
		if (targetPanel) {
			targetPanel.SetPanelEvent("onactivate", () => {
				var event_data = {
					taskId : taskId,
					modifyId : modifyID,
					player_id: Game.GetLocalPlayerID(),
				}
				GameEvents.SendCustomGameEventToServer("ModifyTaskData_Event",  event_data );
				contextMenu.DeleteAsync(0);
			});
		}
	}
	let count = 0;
	for (const key in TaskModifyData) {
		if (Object.hasOwnProperty.call(TaskModifyData, key)) {
			const element = TaskModifyData[key];
			let newPanel = AddTaskModify(contextMenu,element,key);
			setCMBtnEvt(newPanel, key,id);
			count++;
		}
	}
	if (count<=0) {
		let newPanel = $.CreatePanel("Panel", contextMenu, "singleModify_0" );
		newPanel.BLoadLayoutSnippet("singleModify"); //载入模块
		newPanel.FindChildInLayoutFile("singleModifyIcon").style.backgroundImage = "url('s2r://panorama/images/game_modes/all_random_popup.png')";
		let title = $.Localize("#HUD_Chaotic_Era_TaskModify_None_Title");
		let info = $.Localize("");
		let keys ={
			title :title,
			text : info,
			
		}
		SetBaseAdavncedInfoHoverEvent(newPanel,keys);
	}
}


function AddTaskModify(targetPanel,element,id) {
	let newPanel = $.CreatePanel("Panel", targetPanel, "singleModify_" + id);
	newPanel.BLoadLayoutSnippet("singleModify"); //载入模块
	newPanel.FindChildInLayoutFile("singleModifyIcon").style.backgroundImage = "url('"+ element.icon+"')";
	let title = $.Localize("#"+element.title);
	let info = $.Localize("#"+element.text);
	// info = ReplaceSpecialWithKV(kv["AbilityValues"],info);
	for (const key in element.keys) {
		if (Object.hasOwnProperty.call(element.keys, key)) {
			const data = element.keys[key];
			if (data.bLocalize==1) {
				info = info.replace(('<' + key + '>'), $.Localize("#"+data.text));
			}else{
				info = info.replace(('<' + key + '>'), data.text);
			}
		}
	}
	info = ChangeAllNumberColor(info,"#caa7e9");

	let keys ={
		title :title,
		text : info,
		
	}
	SetBaseAdavncedInfoHoverEvent(newPanel,keys);
	return newPanel;
}




(function () {
    CustomUIConfig.SubscribeNetTableListener("game_config", UpdateCommonNetTable);
    CustomUIConfig.SubscribeNetTableListener("chaoticEraData", UpdateChaoticEraDataNetTable);

	let playerID = Game.GetLocalPlayerID();
	let netKey = "spellList_waitForSelected"+playerID;




	UpdateChaoticEraDataNetTable("chaoticEraData", netKey, CustomNetTables.GetTableValue("chaoticEraData", netKey));
	let artifactKey = "chaotic_era_artifact_"+playerID;
	UpdateChaoticEraDataNetTable("chaoticEraData", artifactKey, CustomNetTables.GetTableValue("chaoticEraData", artifactKey));
	let task_modifyKey = "chaotic_era_task_modify_"+playerID;
	UpdateChaoticEraDataNetTable("chaoticEraData", task_modifyKey, CustomNetTables.GetTableValue("chaoticEraData", task_modifyKey));



	UpdateChaoticEraDataNetTable("chaoticEraData", "bonusAttribute_cost", CustomNetTables.GetTableValue("chaoticEraData", "bonusAttribute_cost"));
	UpdateChaoticEraDataNetTable("chaoticEraData", "bonusAttribute", CustomNetTables.GetTableValue("chaoticEraData", "bonusAttribute"));


	

	
	

	UpdateCommonNetTable("game_config", "hd_game_mode", CustomNetTables.GetTableValue("game_config", "hd_game_mode"));
	UpdateCommonNetTable("game_config", "chaoticEraSpawnerData", CustomNetTables.GetTableValue("game_config", "chaoticEraSpawnerData"));
	UpdateCommonNetTable("game_config", "chaoticEra_RuneProgress", CustomNetTables.GetTableValue("game_config", "chaoticEra_RuneProgress"));
	UpdateCommonNetTable("game_config", "chaoticEra_spawnList", CustomNetTables.GetTableValue("game_config", "chaoticEra_spawnList"));
	UpdateCommonNetTable("game_config", "chaoticEra_TaskList", CustomNetTables.GetTableValue("game_config", "chaoticEra_TaskList"));
    UpdateCommonNetTable("game_config", "chaoticEra_RecordTime", CustomNetTables.GetTableValue("game_config", "chaoticEra_RecordTime"));
    UpdateCommonNetTable("game_config", "chaoticEra_mapEffect", CustomNetTables.GetTableValue("game_config", "chaoticEra_mapEffect"));


    
	

	// UpdateCommonNetTable("game_config", "chaoticEra_TaskList", CustomNetTables.GetTableValue("game_config", "chaoticEra_TaskList"));


	// GameEvents.Subscribe("RefreshTaskSelect", RefreshTaskSelect); 
	

	UpdateFailTimer();
})()

