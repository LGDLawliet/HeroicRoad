var base;
var tooltipManager;
var ability_tooltip;
var details;
var ad_label;
var ad_scepter_container;
var ad_scepter_label;
var ad_shard_container;
var ad_shard_label;
var ability_name;
var ad_container;
var prev_ability_name;
var prev_time;
var prev_height;
var screen_height;
var l_arrow, r_arrow;



var registered_abilities = {
    
};

function _ParseHeight(css_line) {
	const values = css_line.slice(css_line.indexOf("(") + 2, css_line.length - 1).split(" ");
	const height = values[1];
	return height.slice(0, height.length - 4);
}

function RegisterHoverableAbility(data) {

	var  loc_name = $.Localize("#DOTA_Tooltip_ability_" + data.ability_name).toUpperCase() 
    registered_abilities[loc_name.toUpperCase()]={};
	registered_abilities[loc_name.toUpperCase()].ability_name = data.ability_name;
    registered_abilities[loc_name.toUpperCase()].ability_level = data.ability_level;
	registered_abilities[loc_name.toUpperCase()].unlock = data.unlock_level;
    // ability_level = dota.ability_level;
}

send();
function send() {
	GameEvents.SendEventClientSide("hd_data_syn", {
		data_name: "aaaa",
		value: 111,
	});
}


// real magic begins here, since tooltip is moved with translate3d instead of position set,
// we need to parse height value and reduce it to accomodate tooltip height changes
// but only if tooltip actually overflowing screen
function RealignTooltipBlock(fast_hover, value) {
	const parsed_height = _ParseHeight(ability_tooltip.style.transform);
	const float_value = parseFloat(parsed_height);
	let ad_content_height = value;
	if (!ad_content_height) {
		ad_content_height = ad_container.contentheight;
	}

	if (float_value + ability_tooltip.contentheight > screen_height && !fast_hover) {
		ability_tooltip.style.transform = ability_tooltip.style.transform
			.replace(parsed_height, float_value - ad_content_height)
			.replace(/x /g, "x,");

		// same goes for arrows, but only if they are visible
		// also style string from .transform is returned without commas
		// but setter for .transform requires them, otherwise throws errors
		// splendid system!
		if (l_arrow.visible) {
			const l_arrow_height = _ParseHeight(l_arrow.style.transform);
			l_arrow.style.transform = l_arrow.style.transform
				.replace(l_arrow_height, parseFloat(l_arrow_height) + ad_content_height)
				.replace(/x /g, "x,");
		}
		if (r_arrow.visible) {
			const r_arrow_height = _ParseHeight(r_arrow.style.transform);
			r_arrow.style.transform = r_arrow.style.transform
				.replace(r_arrow_height, parseFloat(r_arrow_height) + ad_content_height)
				.replace(/x /g, "x,");
		}
		return ad_content_height;
	}
}
var AbilityTooltipContents;
var AbilityDescriptionContainer;

var ability_icon;
function Init() {


	if (!base) {
		base = dotaHud;


	}
	if (!tooltipManager) {
		tooltipManager = base.FindChildTraverse("Tooltips");
	}
	$.Schedule(0.2, function () {
		CloseSwitch()
	});
	ability_icon = base.FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("abilities");

	$.Schedule(0.03, function () {
		InitStatusTooltip();
	});
	

	InitAbilityTooltip();
	InitTextTooltip();
	InitTitileImageTextTooltip();
	InitCenterBG();

}
function CloseSwitch(){
	var scoreboard = base.FindChildTraverse("HUDElements").FindChildTraverse("scoreboard");
	scoreboard.style.marginTop = "120px";
	scoreboard.FindChildTraverse("DireHeader").style.visibility = "collapse";
	scoreboard.FindChildTraverse("DireTeamContainer").style.visibility = "collapse";
	scoreboard.FindChildTraverse("Background").style.height = "420px";

	var raniant = scoreboard.FindChildTraverse("RadiantTeamContainer");
	if(raniant.FindChildTraverse("RadiantPlayer0")==null){
		$.Schedule(0.2, function () {
			CloseSwitch()
		});
		return;
	}
	raniant.FindChildTraverse("RadiantPlayer0").FindChildTraverse("AvatarImage").ClearPanelEvent("oncontextmenu");
	raniant.FindChildTraverse("RadiantPlayer1").FindChildTraverse("AvatarImage").ClearPanelEvent("oncontextmenu");
	raniant.FindChildTraverse("RadiantPlayer2").FindChildTraverse("AvatarImage").ClearPanelEvent("oncontextmenu");
	raniant.FindChildTraverse("RadiantPlayer3").FindChildTraverse("AvatarImage").ClearPanelEvent("oncontextmenu");
	raniant.FindChildTraverse("RadiantPlayer4").FindChildTraverse("AvatarImage").ClearPanelEvent("oncontextmenu");

	// scoreboard.FindChildTraverse("RadiantPlayer0").FindChildTraverse("TalentTree").style.visibility = "collapse";
	// scoreboard.FindChildTraverse("RadiantPlayer1").FindChildTraverse("TalentTree").style.visibility = "collapse";
	// scoreboard.FindChildTraverse("RadiantPlayer2").FindChildTraverse("TalentTree").style.visibility = "collapse";
	// scoreboard.FindChildTraverse("RadiantPlayer3").FindChildTraverse("TalentTree").style.visibility = "collapse";
	// scoreboard.FindChildTraverse("RadiantPlayer4").FindChildTraverse("TalentTree").style.visibility = "collapse";
	// scoreboard.FindChildTraverse("RadiantHeader").Children()[2].style.visibility = "collapse";

	var newUI = base.FindChildTraverse("HUDElements").FindChildTraverse("topbar").FindChildTraverse("TopBarDireTeamContainer").FindChildTraverse("DireTeamScorePlayers");
	newUI.style.visibility = "collapse";




}


let unrefreshable;
let advancedInfo;
let buffCheck = [];
let debuffCheck=[];
let item_uniqueness;
let isBreak = [];
let falseDeath = [];
let hero_talent;
let advanced_level_panel;
let advanced_upgrade_cost;
let probably_info = [];
let shield_disable = [];
let shield_type = [];
let creater;
let abilityGift;
let chaotic_spell_info;
let overCastingInfo;
let singleCastingInfo;
let GiantInfo;
let poisonSpellInfo;
let FalseDeathInfo;
let backstabInfo;
let burningInfo;
let freezingInfo;
let elecshockingInfo;
let runeTypeBonus;
let onlyChaoticEra;

// let debuffCheck2;
function InitAbilityTooltip(){
	ability_tooltip = tooltipManager.FindChildTraverse("DOTAAbilityTooltip");
	if (!ability_tooltip) {
		// tooltip for ability initializes first time ability is hovered
		$.Schedule(0.3, InitAbilityTooltip); // so search for it is not that reliable without retries
		return;
	}
	AbilityDetails = ability_tooltip.FindChildTraverse("Contents").FindChildTraverse("AbilityDetails");
	AbilityDescriptionContainer = AbilityDetails.FindChildTraverse("AbilityDescriptionContainer");


	details = ability_tooltip.FindChildrenWithClassTraverse("TooltipRow")[0];
	l_arrow = details.GetChild(0);
	r_arrow = details.GetChild(2);
	details = details.GetChild(1);
	details = details.FindChildTraverse("AbilityDetails");
	ad_container = details.FindChildTraverse("AbilityDraftDescriptionContainer");
	ad_label = ad_container.GetChild(3);
	ability_name = details.FindChildTraverse("AbilityName");

	ad_scepter_container = details.FindChildTraverse("ScepterDesc");
	ad_scepter_label = ad_scepter_container.GetChild(1);

	ad_shard_container = details.FindChildTraverse("ShardDesc");
	ad_shard_label = ad_shard_container.GetChild(1);

	const header = details.FindChildTraverse("AbilityName");
	screen_height = Game.GetScreenHeight();
	// $.RegisterEventHandler("LocalizationChanged", header, function () {
	// 	$.Schedule(0.01, TooltipTextChanged);
	// });


	InitHUDStyleChange();
	UpdateTooltip();


	
	let AbilityCoreDetails = ability_tooltip.FindChildTraverse("Contents").FindChildTraverse("AbilityCoreDetails");

	let AbilityTarget = ability_tooltip.FindChildTraverse("Contents").FindChildTraverse("AbilityTarget");
	let removeTarget = AbilityCoreDetails.FindChildTraverse("unrefreshable");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityCoreDetails.FindChildTraverse("advancedInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityCoreDetails.FindChildTraverse("debuffCheck");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityCoreDetails.FindChildTraverse("debuffCheck2");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	removeTarget = AbilityCoreDetails.FindChildTraverse("item_uniqueness");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityCoreDetails.FindChildTraverse("isBreak1");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	removeTarget = AbilityCoreDetails.FindChildTraverse("falseDeath1");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	removeTarget = AbilityCoreDetails.FindChildTraverse("falseDeath2");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}



	removeTarget = AbilityCoreDetails.FindChildTraverse("hero_talent");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityCoreDetails.FindChildTraverse("onlyChaoticEra");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	
	removeTarget = AbilityCoreDetails.FindChildTraverse("advanced_level");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityCoreDetails.FindChildTraverse("advanced_upgrade_cost");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityCoreDetails.FindChildTraverse("probably_info1");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityCoreDetails.FindChildTraverse("shield_disable");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	removeTarget = AbilityCoreDetails.FindChildTraverse("shield_type");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	removeTarget = AbilityCoreDetails.FindChildTraverse("shield_disable2");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	removeTarget = AbilityCoreDetails.FindChildTraverse("shield_type2");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	
	removeTarget = AbilityCoreDetails.FindChildTraverse("creater");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	removeTarget = AbilityCoreDetails.FindChildTraverse("abilityGift");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	
	
	removeTarget = AbilityTarget.FindChildTraverse("chaotic_spell_info");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityTarget.FindChildTraverse("poisonSpellInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityTarget.FindChildTraverse("FalseDeathInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityTarget.FindChildTraverse("backstabInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityTarget.FindChildTraverse("burningInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityTarget.FindChildTraverse("freezingInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityTarget.FindChildTraverse("elecshockingInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}


	

	

	removeTarget = AbilityTarget.FindChildTraverse("overCastingInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}

	removeTarget = AbilityTarget.FindChildTraverse("singleCastingInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}
	removeTarget = AbilityTarget.FindChildTraverse("GiantInfo");
	if (removeTarget) {
		removeTarget.DeleteAsync(-1);
	}


	removeTarget = AbilityTarget.FindChildTraverse("runeTypeBonus");
	// $.Msg(removeTarget);
	if (removeTarget) {
		// $.Msg("del");
		removeTarget.DeleteAsync(-1);

	}
	

	
	let spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "unrefreshable");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "isBreak1");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_break.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "falseDeath1");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_false_death.xml", false, false);
	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "falseDeath2");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_false_death.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "shield_disable");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_shield_disable.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "shield_type");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_shield_type.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "shield_disable2");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_shield_disable.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "shield_type2");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_shield_type.xml", false, false);




	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "advancedInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info.xml", false, false);



	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "debuffCheck");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info_debuff.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "debuffCheck2");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info_debuff.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "buffCheck");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info_buff.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "item_uniqueness");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_item_uniqueness.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "hero_talent");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_talent.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "onlyChaoticEra");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_talent.xml", false, false);

	

	
	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "advanced_level");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_advanced_level.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "advanced_upgrade_cost");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_upgrate_cost.xml", false, false);



	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "probably_info1");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info_probability.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "creater");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_creater.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "abilityGift");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_abilityGift.xml", false, false);


	spellPanel = $.CreatePanel("Panel", AbilityTarget, "chaotic_spell_info");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_chaotic_spell_info.xml", false, false);







	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "overCastingInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info_2.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "singleCastingInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info_2.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "GiantInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info_2.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "runeTypeBonus");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_info_2.xml", false, false);


	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "poisonSpellInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_poison_spell.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "FalseDeathInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_false_death_info.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "backstabInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_backstab_info.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "burningInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_burning_info.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "freezingInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_freezing_info.xml", false, false);

	spellPanel = $.CreatePanel("Panel", AbilityCoreDetails, "elecshockingInfo");
	spellPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_note/ability_note_bonus_elecshocking_info.xml", false, false);

	$.Schedule(0.01, 
		()=>{




			unrefreshable = AbilityCoreDetails.FindChildTraverse("unrefreshable");
			AbilityCoreDetails.MoveChildBefore(unrefreshable, AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			unrefreshable.SetDialogVariable("value1",  $.Localize("#HUD_NOTE_UNREFRSHABLE"));
			// unrefreshable.SetDialogVariable("value2",  $.Localize("#DOTA_HUD_Star_Info"));
			unrefreshable.FindChildTraverse("info").SetHasClass("hide",true);

			isBreak[0] = AbilityCoreDetails.FindChildTraverse("isBreak1");
			AbilityCoreDetails.MoveChildBefore(isBreak[0], AbilityCoreDetails.FindChildTraverse("AbilityLore"));



			falseDeath[0]= AbilityCoreDetails.FindChildTraverse("falseDeath1");
			AbilityCoreDetails.MoveChildBefore(falseDeath[0], AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			falseDeath[1]= AbilityCoreDetails.FindChildTraverse("falseDeath2");
			AbilityCoreDetails.MoveChildBefore(falseDeath[1], AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			
			
			shield_disable[0] = AbilityCoreDetails.FindChildTraverse("shield_disable");
			shield_disable[0].SetDialogVariable("shieldInfo",  $.Localize("#HUD_NOTE_Shield_disabled"));
			AbilityCoreDetails.MoveChildBefore(shield_disable[0], AbilityCoreDetails.FindChildTraverse("AbilityLore"));

			shield_type[0] = AbilityCoreDetails.FindChildTraverse("shield_type");
			AbilityCoreDetails.MoveChildBefore(shield_type[0], AbilityCoreDetails.FindChildTraverse("AbilityLore"));

			shield_disable[1] = AbilityCoreDetails.FindChildTraverse("shield_disable2");
			shield_disable[1].SetDialogVariable("shieldInfo",  $.Localize("#HUD_NOTE_Shield_disabled"));
			AbilityCoreDetails.MoveChildBefore(shield_disable[1], AbilityCoreDetails.FindChildTraverse("AbilityLore"));

			shield_type[1] = AbilityCoreDetails.FindChildTraverse("shield_type2");
			AbilityCoreDetails.MoveChildBefore(shield_type[1], AbilityCoreDetails.FindChildTraverse("AbilityLore"));

			
			overCastingInfo = AbilityCoreDetails.FindChildTraverse("overCastingInfo");
			AbilityCoreDetails.MoveChildBefore(overCastingInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));
			overCastingInfo.SetDialogVariable("value1", $.Localize("#HUD_Spell_Bonus_Behavior_OverCasting_Title"));
		
			singleCastingInfo = AbilityCoreDetails.FindChildTraverse("singleCastingInfo");
			AbilityCoreDetails.MoveChildBefore(singleCastingInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));
			singleCastingInfo.SetDialogVariable("value1", $.Localize("#HUD_Spell_Bonus_Behavior_SingleCasting_Title"));
		
			runeTypeBonus = AbilityCoreDetails.FindChildTraverse("runeTypeBonus");
			AbilityCoreDetails.MoveChildBefore(runeTypeBonus, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));

			

			GiantInfo = AbilityCoreDetails.FindChildTraverse("GiantInfo");
			AbilityCoreDetails.MoveChildBefore(GiantInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));
			GiantInfo.SetDialogVariable("value1", $.Localize("#HUD_Spell_Bonus_Info_GiantUnit_Title"));
			GiantInfo.SetDialogVariable("value2", $.Localize("#HUD_Spell_Bonus_Info_GiantUnit_Info"));
		
			
		


			poisonSpellInfo = AbilityCoreDetails.FindChildTraverse("poisonSpellInfo");
			AbilityCoreDetails.MoveChildBefore(poisonSpellInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));


			FalseDeathInfo = AbilityCoreDetails.FindChildTraverse("FalseDeathInfo");
			AbilityCoreDetails.MoveChildBefore(FalseDeathInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));

			backstabInfo = AbilityCoreDetails.FindChildTraverse("backstabInfo");
			AbilityCoreDetails.MoveChildBefore(backstabInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));

			burningInfo = AbilityCoreDetails.FindChildTraverse("burningInfo");
			AbilityCoreDetails.MoveChildBefore(burningInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));

			freezingInfo = AbilityCoreDetails.FindChildTraverse("freezingInfo");
			AbilityCoreDetails.MoveChildBefore(freezingInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));

			elecshockingInfo = AbilityCoreDetails.FindChildTraverse("elecshockingInfo");
			AbilityCoreDetails.MoveChildBefore(elecshockingInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));

			advancedInfo = AbilityCoreDetails.FindChildTraverse("advancedInfo");
			advancedInfo.style.border = "1px solid rgba(63, 63, 63,0.5);"
			AbilityCoreDetails.MoveChildBefore(advancedInfo, AbilityCoreDetails.FindChildTraverse("AbilityScepterDescriptionContainer"));
			advancedInfo.SetDialogVariable("value1",  $.Localize("#HUD_Advanced_Header"));
			// advancedInfo.SetDialogVariable("value2",  $.Localize("#DOTA_HUD_Star_Info"));
			advancedInfo.FindChildTraverse("header").SetHasClass("big",true);
			advancedInfo.FindChildTraverse("info").SetHasClass("big",true);


			debuffCheck[0] = AbilityCoreDetails.FindChildTraverse("debuffCheck");
			AbilityCoreDetails.MoveChildBefore(debuffCheck[0], AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			debuffCheck[0].SetDialogVariable("header1",  "");
			debuffCheck[0].SetDialogVariable("header2",  $.Localize("#HUD_NOTE_DEBUFF"));
			// debuffCheck.SetHasClass("hide",false);


			debuffCheck[1] = AbilityCoreDetails.FindChildTraverse("debuffCheck2");
			AbilityCoreDetails.MoveChildBefore(debuffCheck[1], AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			debuffCheck[1].SetDialogVariable("header1",  "");
			debuffCheck[1].SetDialogVariable("header2",  $.Localize("#HUD_NOTE_DEBUFF"));



			buffCheck[0] = AbilityCoreDetails.FindChildTraverse("buffCheck");
			AbilityCoreDetails.MoveChildBefore(buffCheck[0], AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			buffCheck[0].SetDialogVariable("header1",  "");
			buffCheck[0].SetDialogVariable("header2",  $.Localize("#HUD_NOTE_BUFF"));
			// debuffCheck.SetHasClass("hide",false);



			probably_info[0] = AbilityCoreDetails.FindChildTraverse("probably_info1");
			AbilityCoreDetails.MoveChildBefore(probably_info[0], AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			probably_info[0].SetDialogVariable("header1",  "");
			probably_info[0].SetDialogVariable("header2",  $.Localize("#HUD_NOTE_Trigger_Event"));

			




			item_uniqueness = AbilityCoreDetails.FindChildTraverse("item_uniqueness");
			AbilityCoreDetails.MoveChildBefore(item_uniqueness, AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			
			hero_talent = AbilityCoreDetails.FindChildTraverse("hero_talent");
			AbilityCoreDetails.MoveChildBefore(hero_talent, AbilityCoreDetails.FindChildTraverse("AbilityLore"));

			onlyChaoticEra= AbilityCoreDetails.FindChildTraverse("onlyChaoticEra");
			AbilityCoreDetails.MoveChildBefore(onlyChaoticEra, AbilityCoreDetails.FindChildTraverse("AbilityLore"));
			onlyChaoticEra.FindChildTraverse("header").text = $.Localize("#HUD_NOTE_Only_ChaoticEraMod");
			

			advanced_level_panel = AbilityCoreDetails.FindChildTraverse("advanced_level");
			AbilityCoreDetails.MoveChildBefore(advanced_level_panel, AbilityCoreDetails.FindChildTraverse("AbilityCosts"));

			advanced_upgrade_cost = AbilityCoreDetails.FindChildTraverse("advanced_upgrade_cost");
			AbilityCoreDetails.MoveChildBefore(advanced_upgrade_cost, AbilityCoreDetails.FindChildTraverse("advanced_upgrade_cost"));
			GameUI.CustomUIConfig().advanced_upgrade_costPanel = advanced_upgrade_cost;
			



			creater = AbilityCoreDetails.FindChildTraverse("creater");
			AbilityCoreDetails.MoveChildBefore(advanced_upgrade_cost, AbilityCoreDetails.FindChildTraverse("creater"));


			abilityGift = AbilityCoreDetails.FindChildTraverse("abilityGift");
			AbilityCoreDetails.MoveChildBefore(advanced_upgrade_cost, AbilityCoreDetails.FindChildTraverse("abilityGift"));

			

			chaotic_spell_info = AbilityTarget.FindChildTraverse("chaotic_spell_info");
			// AbilityCoreDetails.MoveChildBefore(advanced_upgrade_cost, AbilityCoreDetails.FindChildTraverse("chaotic_spell_info"));



		
			
		// "CanBeBreak1"  "1"
		// "BreakKeyWord1"  "#HUD_NOTE_Bonus_Move"
			
		}
	
	);

}


function UpdateTooltip(){
	$.Schedule(0.00, UpdateTooltip);
	var elements = AbilityDescriptionContainer.Children();
	for (const key in elements) {
		// ItemMap[key1].SetHasClass("Visible", false);  //隐藏道具
		elements[key].style.width = "100%";
		elements[key].style.backgroundColor= "rgba(0, 0,0,1)";
		elements[key].style.backgroundSize= "0%";
	}

}
var heroSpells;
var spellsCost;
var nextSpells;
var abilityChangeList = {};



// function OnSpellLearn(keys){
// 	heroSpells = keys.player_abilities[1];
//     spellsCost = keys.player_abilities[2];
//     nextSpells = keys.player_abilities[3];
	

//     // if (!heroSpells.hasOwnProperty(1)) { 
// 	// 	// 不用做处理
//     //     return;
// 	// };
// 	// $.Msg("go");
// 	UpdateSpellUpgrate();
	

	





// }
OnUiLoad();
function OnUiLoad(){
	var event_data = {
        player_id: Game.GetLocalPlayerID(),
  	};

    GameEvents.SendCustomGameEventToServer("AbilityNoteOnUiLoad", event_data);

}






var titleImageTextTooltip;
function InitHUDStyleChange(){



	var newUI = ability_tooltip.FindChildTraverse("Contents");
	newUI.style.marginBottom = "20px";
	newUI.style.marginLeft = "10px";
	newUI.style.marginTop = "20px";
	newUI.style.marginRight = "10px";
	newUI.style.boxShadow= "rgb(0, 0, 0) 0px 0px 0px 0px";
	newUI.style.backgroundColor= "rgba(0, 0,0,1)";
	newUI.style.border = "2px solid rgba(50, 50,50,0.9)"
	newUI.style.width = "450px";
	newUI.style.maxWidth = "450px";
	var abilityDetails = newUI.FindChildTraverse("AbilityDetails");
	var AbilityDescriptionOuterContainer = abilityDetails.FindChildTraverse("AbilityDescriptionOuterContainer");
	abilityDetails.FindChildTraverse("AbilityLore").style.width = "100%";

	newUI.FindChildTraverse("AbilityExtraDescription").style.width = "100%";
	
	

	abilityDetails.FindChildTraverse("AbilityDraftDescriptionContainer").style.width = "100%";
	abilityDetails.FindChildTraverse("AbilityDraftDescriptionContainer").FindChildTraverse("ADNote").style.width = "100%";
	abilityDetails.FindChildTraverse("AbilityCharges").style.marginTop = "25px";
	abilityDetails.FindChildTraverse("AbilityExtraAttributes").style.marginTop = "25px";


	// if(_child[0].classList)


	AbilityDescriptionOuterContainer.style.boxShadow= "rgb(0, 0, 0) 0px 0px 20px 0px";

	AbilityDescriptionOuterContainer.FindChildTraverse("CurrentItemCosts").style.marginTop = "20px";
	var AbilityDescriptionContainer = AbilityDescriptionOuterContainer.FindChildTraverse("AbilityDescriptionContainer");
	
	AbilityDescriptionContainer.style.boxShadow= "rgb(20, 20, 20) 0px 0px 20px 20px";
	AbilityDescriptionContainer.style.marginTop = "20px";
	AbilityDescriptionContainer.style.width = "420px";


	abilityDetails.FindChildTraverse("AbilityCoreDetails").style.boxShadow= "rgb(0, 0, 0) 0px 0px 10px 0px";


	var AbilityExtraDescription = abilityDetails.FindChildTraverse("AbilityExtraDescription");
	AbilityExtraDescription.style.boxShadow= "rgb(10, 10, 10) 0px 0px 10px 0px";
	AbilityExtraDescription.style.backgroundColor= "rgba(30, 30,30,0.2)";
	AbilityExtraDescription.style.borderBottom ="3px solid rgba(50, 50,50,0.2)";
	AbilityExtraDescription.style.borderTop ="3px solid rgba(50, 50,50,0.2)";
	AbilityExtraDescription.style.borderLeft ="3px solid rgba(50, 50,50,0.2)";
	AbilityExtraDescription.style.borderRight ="3px solid #gba(50, 50,50,0.2)";
	AbilityExtraDescription.style.margin = "2px";


	newUI = newUI.FindChildTraverse("Header");


	newUI.FindChildTraverse("ItemImage").style.width = "88px";
	newUI.FindChildTraverse("ItemImage").style.height = "66px";
	newUI.FindChildTraverse("ItemImage").style.boxShadow= "rgba(100, 100, 100,0.5) 0px 0px 5px 0px";
	newUI.FindChildTraverse("AbilityName").style.fontSize = "18px";
	newUI.style.borderBottom ="0px solid #38383888";
	newUI.style.boxShadow= "rgb(0, 0, 0) 0px 0px 50px 5px";


	
	var newUI = base.FindChildTraverse("HUDElements").FindChildTraverse("minimap_container").FindChildTraverse("minimap");

	// newUI.style.width = "256px";
	// newUI.style.height = "256px";
	// newUI.style.marginLeft = "20px";
	// newUI.style.marginBottom = "20px";
	newUI.style.width = "240px";
	newUI.style.height = "240px";
	newUI.style.marginLeft = "10px";
	newUI.style.marginBottom = "10px";

	var newUI = base.FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("quickbuy").FindChildTraverse("BuybackHeader");
	newUI.style.visibility = "collapse";
	var newUI = base.FindChildTraverse("HUDElements").FindChildTraverse("shop").FindChildTraverse("GridShopHeaders");
	newUI.FindChildTraverse("GridUpgradesTab").style.visibility = "collapse";
	newUI.FindChildTraverse("GridNeutralsTab").style.visibility = "collapse";
	newUI = base.FindChildTraverse("HUDElements").FindChildTraverse("shop").FindChildTraverse("GridMainShopContents");
	newUI.FindChildTraverse("ShopItems_attributes").FindChildTraverse("ShopItemsHeader").text = "";
	newUI.FindChildTraverse("ShopItems_misc").FindChildTraverse("ShopItemsHeader").text = "";
	newUI.FindChildTraverse("ShopItems_secretshop").FindChildTraverse("ShopItemsHeader").text = $.Localize("#DOTA_Shop_info");
	newUI.FindChildTraverse("ShopItems_secretshop").FindChildTraverse("ShopItemsHeader").style.color = "rgba(255, 255, 255,0.05)";





	$.Schedule(1, function () {
		abilityDetails.FindChildTraverse("AbilityDraftDescriptionContainer").style.backgroundColor = "rgba(20,20,20,0.8)";
		abilityDetails.FindChildTraverse("AbilityDraftDescriptionContainer").style.border = "1px solid rgba(100, 100, 100, .25)";
		
		var _child = abilityDetails.FindChildTraverse("AbilityDraftDescriptionContainer").Children();
		if(_child[0]){
			var elements = _child[0].Children();
			elements[0].style.visibility = "collapse";
			elements[1].style.marginLeft = "1px";
			elements[1].style.color = "#aacbd1";
		}
	});




}


function InitTextTooltip(){
	var TextTooltip = tooltipManager.FindChildTraverse("TextTooltip");
	if(!TextTooltip){
		$.Schedule(0.3, InitTextTooltip);
		return;
	}
	var TextTooltip_Contents = TextTooltip.FindChildTraverse("Contents");
	TextTooltip_Contents.style.maxWidth = "600px";
	TextTooltip_Contents.style.boxShadow= "fill rgba(31, 25, 43,0.5) 0px 0px 60px 2px";
	TextTooltip_Contents.style.padding = "20px"
	TextTooltip_Contents.style.marginTop = "0px";
	TextTooltip_Contents.style.marginBottom = "0px";
	TextTooltip_Contents.style.marginLeft = "0px";
	TextTooltip_Contents.style.marginRight = "0px";
	TextTooltip_Contents.style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( rgba(9, 4, 20, 0.99) ), to( rgba(5, 2, 10, 0.99)) )";



	TextTooltip_Contents.FindChildTraverse("TextLabel").style.boxShadow= "rgba(0, 0, 0,0) 0px 0px 10px 0px";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.borderBottom ="0px solid rgba(50, 50,50,0.5)";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.borderTop ="0px solid rgba(50, 50,50,0.5)";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.borderLeft ="0px solid rgba(50, 50,50,0.5)";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.borderRight ="0px solid rgba(50, 50,50,0.5)";
	// TextTooltip_Contents.FindChildTraverse("TitleLabel").style.boxShadow= "rgb(0, 0, 0) 0px 0px 500px 0px";
	// TextTooltip_Contents.FindChildTraverse("TitleLabel").style.borderBottom ="0px solid rgba(50, 50,50,1)";
	// TextTooltip_Contents.FindChildTraverse("TitleLabel").style.borderTop ="0px solid rgba(50, 50,50,1)";
	// TextTooltip_Contents.FindChildTraverse("TitleLabel").style.borderLeft ="0px solid rgba(50, 50,50,1)";
	// TextTooltip_Contents.FindChildTraverse("TitleLabel").style.borderRight ="0px solid rgba(50, 50,50,1)";
	// TextTooltip_Contents.FindChildTraverse("TitleLabel").style.minWidth = "350px";
}
function InitTitileImageTextTooltip(){

	var TitleImageTextTooltip = tooltipManager.FindChildTraverse("TitleImageTextTooltip");
	if(!TitleImageTextTooltip){
		$.Schedule(0.3, InitTitileImageTextTooltip);
		return;
	}
	var TextTooltip_Contents = TitleImageTextTooltip.FindChildTraverse("Contents");
	TextTooltip_Contents.style.maxWidth = "600px";
	TextTooltip_Contents.style.margin = "10px";
	TextTooltip_Contents.style.boxShadow= "rgb(10, 10, 10) 0px 0px 20px 0px";
	TextTooltip_Contents.style.padding = "2px";
	// TextTooltip_Contents.style.backgroundImage = "url('s2r://panorama/images/splash_ads/compendium_bg_psd.vtex')"


	TextTooltip_Contents.FindChildTraverse("TitleLabel").style.boxShadow= "rgb(0, 0, 0) 0px 0px 200px 0px";
	TextTooltip_Contents.FindChildTraverse("TitleLabel").style.borderBottom ="0px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("TitleLabel").style.borderTop ="0px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("TitleLabel").style.borderLeft ="0px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("TitleLabel").style.borderRight ="0px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("TitleLabel").style.minWidth = "450px";
	TextTooltip_Contents.FindChildTraverse("TitleLabel").style.backgroundImage = "url('s2r://panorama/images/splash_ads/compendium_bg_psd.vtex')"


	TextTooltip_Contents.FindChildTraverse("Image").style.boxShadow= "rgb(0, 0, 0) 0px 0px 00px 0px";
	TextTooltip_Contents.FindChildTraverse("Image").style.borderBottom ="2px solid rgba(50, 50,50,1)";
	// TextTooltip_Contents.FindChildTraverse("Image").style.borderTop ="2px solid rgba(50, 50,50,1)";
	// TextTooltip_Contents.FindChildTraverse("Image").style.borderLeft ="2px solid rgba(50, 50,50,1)";
	// TextTooltip_Contents.FindChildTraverse("Image").style.borderRight ="2px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("Image").style.margin ="0px";


	TextTooltip_Contents.FindChildTraverse("TextLabel").style.boxShadow= "rgb(0, 0, 0) 0px 0px 30px 0px";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.borderBottom ="0px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.borderTop ="0px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.borderLeft ="0px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.borderRight ="0px solid rgba(50, 50,50,1)";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.width ="100%";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.padding ="5px";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.backgroundImage = "url('s2r://panorama/images/splash_ads/ti7_reminder_bg_psd.vtex')"
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.horizontalAlign = "center";
	TextTooltip_Contents.FindChildTraverse("TextLabel").style.textAlign = "center";
}

function InitCenterBG(){
	var center_block =  base.FindChildTraverse("center_block");

	center_block.FindChildTraverse("center_bg").style.boxShadow= "rgb(0, 0, 0) 0px 0px 20px 0px";
	center_block.FindChildTraverse("center_bg").style.border = "0px solid rgba(50, 50,50,0.9)";

	center_block.FindChildTraverse("PortraitGroup").style.boxShadow= "rgb(0, 0, 0) 0px 0px 20px 0px";
	center_block.FindChildTraverse("PortraitGroup").style.border = "0px solid rgba(50, 50,50,0.9)";
	center_block.FindChildTraverse("PortraitGroup").style.marginLeft = "46px";

	center_block.FindChildTraverse("inventory").style.boxShadow= "rgb(0, 0, 0) 0px 0px 20px 0px";
	center_block.FindChildTraverse("inventory").style.border = "0px solid rgba(50, 50,50,0.9)";


	var topbar =  base.FindChildTraverse("topbar");
	topbar.FindChildTraverse("TopBarDireTeam").style.width = "0px";
	topbar.FindChildTraverse("TopBarRadiantTeam").FindChildTraverse("TopBarRadiantScore").text = "";
	topbar.FindChildTraverse("TopBarRadiantTeam").Children()[0].style.boxShadow= "rgb(0, 0, 0) 0px 0px 40px 0px";
	topbar.style.marginLeft="100px";
	center_block.FindChildTraverse("inventory_neutral_craft_holder").style.visibility = "collapse";

	// center_block.FindChildTraverse("inventory_neutral_level_up").style.visibility = "collapse";
}




function OnDOTAShowAbilityTooltipForEntityIndex(targetPanel,abilityName,unitIndex) {

	// $.Msg("aaaaaaaaaaaaaaaaa");

	AbilityTooltipSetDetail(abilityName,unitIndex);


}
function OnDOTAShowAbilityTooltip(targetPanel,abilityName){
	// $.Msg("bbbbbbbbbbb")
	AbilityTooltipSetDetail(abilityName);
}
function OnDOTAShowAbilityShopItemTooltip(targetPanel,abilityName,unitIndex) {
	// $.Msg("ccccccccccc")
	AbilityTooltipSetDetail(abilityName);
}
function OnDOTAShowDroppedItemTooltip(targetPanel, x,y,item_name,ownerPlayerID,boolUnknow) {
	// $.Msg("ddddddddd")
	AbilityTooltipSetDetail(item_name);
}
function OnDOTAShowAbilityInventoryItemTooltip(targetPanel,entityIndex,  inventorySlot) {
	// $.Msg("eeeeeeee")

	let item_id = 	Entities.GetItemInSlot( entityIndex, inventorySlot );
	let item_name = 	Abilities.GetAbilityName( item_id);
	AbilityTooltipSetDetail(item_name);
}



function AbilityTooltipSetDetail(abilityName,unitIndex) {
	if (!unrefreshable) {
		$.Msg("retgurn");
		return;		

	}
	let abilityIndex = -1;
	localPlayerID = -1;
	if (unitIndex) {
		abilityIndex = Entities.GetAbilityByName( unitIndex, abilityName );
		localPlayerID = Entities.GetPlayerOwnerID(unitIndex);
	}

	chaotic_spell_info.SetHasClass("hide",true);
	overCastingInfo.SetHasClass("hide",true);
	singleCastingInfo.SetHasClass("hide",true);
	GiantInfo.SetHasClass("hide",true);
	runeTypeBonus.SetHasClass("hide",true);
	unrefreshable.SetHasClass("hide",true);
	creater.SetHasClass("hide",true);
	abilityGift.SetHasClass("hide",true);
	item_uniqueness.SetHasClass("hide",true);
	poisonSpellInfo.SetHasClass("hide",true);
	FalseDeathInfo.SetHasClass("hide",true);
	backstabInfo.SetHasClass("hide",true);
	burningInfo.SetHasClass("hide",true);
	freezingInfo.SetHasClass("hide",true);
	elecshockingInfo.SetHasClass("hide",true);
	hero_talent.SetHasClass("hide",true);
	advancedInfo.SetHasClass("hide",true);
	onlyChaoticEra.SetHasClass("hide",true);
	advanced_level_panel.SetHasClass("hide",true);

	for (let index = 0; index < debuffCheck.length; index++) {
		debuffCheck[index].SetHasClass("hide",true);
	}
	for (let index = 0; index < buffCheck.length; index++) {
		buffCheck[index].SetHasClass("hide",true);
	}
	for (let index = 0; index < shield_disable.length; index++) {
		shield_disable[index].SetHasClass("hide",true);
	}
	for (let index = 0; index < isBreak.length; index++) {
		isBreak[index].SetHasClass("hide",true);
	}
	for (let index = 0; index < falseDeath.length; index++) {
		falseDeath[index].SetHasClass("hide",true);
	}





	for (let index = 0; index < shield_type.length; index++) {
		shield_type[index].SetHasClass("hide",true);
	}





	let abilityKV= GameUI.CustomUIConfig().AbilityBonusInfoKV[abilityName];
	let isItem = false;
	// $.Msg(abilityName);
	if (abilityName.match("item_")) {
		// abilityKV = GameUI.CustomUIConfig().ItemsKv[abilityName];
		isItem = true;
		if (abilityKV==null) {
			abilityKV = GameUI.CustomUIConfig().ItemsKv[abilityName];
		}
		// $.Msg("abilityName");
	}else{
		// $.Msg(GameUI.CustomUIConfig().AbilitiesKv);
		if (abilityKV==null) {
			abilityKV = GameUI.CustomUIConfig().AbilitiesKv[abilityName];
		}
		// abilityKV = GameUI.CustomUIConfig().AbilitiesKv[abilityName];
	}

	// $.Msg(abilityName)

	if (abilityKV) {
		// let special = abilityKV.AbilityValues;
		// 不可刷新
		if (abilityKV.Unrefreshable && abilityKV.Unrefreshable==1) {
			unrefreshable.SetHasClass("hide",false);
		}


		if (abilityKV.Creater) {
			creater.SetHasClass("hide",false);
			creater.SetDialogVariable("heroName",  $.Localize(abilityKV.Creater));
		}

		if (abilityIndex==-1) {
			
			if (abilityKV.GiftAbility1) {
				
				let abilityName = $.Localize("#DOTA_Tooltip_ability_"+abilityKV.GiftAbility1);
				if (abilityKV.GiftAbility1_level) {
					abilityGift.SetDialogVariable("level",  abilityKV.GiftAbility1_level);
				}else{
					abilityGift.SetDialogVariable("level", 1);
				}
				if (abilityKV.GiftAbility2) {
					abilityName = abilityName + " "+$.Localize("#DOTA_Tooltip_ability_"+abilityKV.GiftAbility2)
				}
				abilityGift.SetHasClass("hide",false);
				abilityGift.SetDialogVariable("abilityName",  abilityName);

			}
			
		}

	

		
		

		SetDebuffCheckInfo(abilityKV,1,null,null,localPlayerID,abilityName);
		SetDebuffCheckInfo(abilityKV,2,null,null,localPlayerID,abilityName);
		
		CheckBreak(abilityKV,1);
		CheckFalseDeathInfo(abilityKV,1);
		CheckFalseDeathInfo(abilityKV,2);
		SetProbabilityCheckInfo(abilityKV,1);

		SetBuffCheckInfo(abilityKV,1,null,null,localPlayerID,abilityName);
		CheckShieldInfo(abilityKV,1,null,null,localPlayerID,abilityName);
		CheckShieldInfo(abilityKV,2,null,null,localPlayerID,abilityName);

		


		if (isItem) {
			item_uniqueness.SetHasClass("hide",false);
			// $.Msg(abilityKV.Uniqueness);
			if (abilityKV.Uniqueness!=null && abilityKV.Uniqueness=="false") {
				item_uniqueness.SetDialogVariable("isUnquenss",  $.Localize("#HUD_NOTE_NO"));
			}else{
				item_uniqueness.SetDialogVariable("isUnquenss",  $.Localize("#HUD_NOTE_YES"));
			}
		}


		if (abilityKV.IsChaoticEraSpell && abilityKV.IsChaoticEraSpell==1) {

			chaotic_spell_info.SetHasClass("hide",false);

			chaotic_spell_info.SetDialogVariable("level",  abilityKV.ChaoticSpell_ClassLevel);
			chaotic_spell_info.SetDialogVariable("spell_type",  $.Localize(abilityKV.ChaoticSpellType));
			// 过度施法
			if (abilityKV.OverCastingBehavior) {
				// overCastingInfo[1]
				// $.Msg("go1111");
				if (abilityKV.OverCastingBehavior=="1") {
					// $.Msg("go2222222");
					overCastingInfo.SetHasClass("hide",false);

					let text = $.Localize("#HUD_Spell_Bonus_Behavior_OverCasting_Info");
					if (abilityIndex!=-1) {
						text = ReplaceSpecialValueWithAbilityEntity(text,abilityIndex);
					}else{
						text = GameUI.ReplaceDOTAAbilitySpecialValues(abilityName, text);
					}
					text = ChangeNumberColor(text,"ffffff");
					// $.Msg(text);
					overCastingInfo.SetDialogVariable("value1", $.Localize("#HUD_Spell_Bonus_Behavior_OverCasting_Title"));
					overCastingInfo.SetDialogVariable("value2",  text);
				}else if (abilityKV.OverCastingBehavior=="2") {
					overCastingInfo.SetHasClass("hide",false);
					let text = $.Localize("#HUD_Spell_Bonus_Behavior_OverCasting2_Info");
					if (abilityIndex!=-1) {
						text = ReplaceSpecialValueWithAbilityEntity(text,abilityIndex);
					}else{
						text = GameUI.ReplaceDOTAAbilitySpecialValues(abilityName, text);
					}
					
					text = ChangeNumberColor(text,"ffffff");
					overCastingInfo.SetDialogVariable("value1", $.Localize("#HUD_Spell_Bonus_Behavior_OverCasting2_Title"));
					overCastingInfo.SetDialogVariable("value2",  text);
					// $.Msg("go33333");
				}
			}else{
				overCastingInfo.SetHasClass("hide",true);
			}
			// 有限施法
			if (abilityKV.SingleCastingBehavior) {
				// overCastingInfo[1]
				if (abilityKV.SingleCastingBehavior=="1") {

					singleCastingInfo.SetHasClass("hide",false);

					let text = $.Localize("#HUD_Spell_Bonus_Behavior_SingleCasting_Info");
					text = GameUI.ReplaceDOTAAbilitySpecialValues(abilityName, text);
					text = ChangeNumberColor(text,"ffffff");
					// $.Msg(text);
					singleCastingInfo.SetDialogVariable("value2",  text);
				}
			}else{
				singleCastingInfo.SetHasClass("hide",true);
			}


			if (abilityKV.BonusInfo_Giant) {
				// overCastingInfo[1]
				if (abilityKV.BonusInfo_Giant=="1") {

					GiantInfo.SetHasClass("hide",false);
				}
			}else{
				GiantInfo.SetHasClass("hide",true);
			}


			if (localPlayerID != -1) {
                let data = GetEquippedRune(localPlayerID, abilityName);
                if (data && data.runeId) {
					if (data.runeType!=0) {

						runeTypeBonus.SetHasClass("hide",false);
	
						let title = $.Localize("#DOTA_Tooltip_ability_"+abilityName+"_rune_"+data.runeType);
						if (title==("#DOTA_Tooltip_ability_"+abilityName+"_rune_"+data.runeType)) {
							runeTypeBonus.SetDialogVariable("value1",$.Localize("#HUD_Rune_Special_None"));
							runeTypeBonus.SetDialogVariable("value2","");
						}else{
							let info = $.Localize("#DOTA_Tooltip_ability_"+abilityName+"_rune_"+data.runeType+"_Description");
							info = GameUI.ReplaceDOTAAbilitySpecialValues(abilityName, info);
							info = ChangeNumberColor(info,"ffffff");

							// $.Msg(info);
							// info = ReplaceRuneSpecial(info,abilityName,data.runeType);
							// $.Msg(runeTypeBonus);
							runeTypeBonus.SetDialogVariable("value1",title);
							runeTypeBonus.SetDialogVariable("value2",info);
						}
						
					}
					
				}
			}
		}
		if (abilityKV.FalseDeath && abilityKV.FalseDeath=="1") {
			FalseDeathInfo.SetHasClass("hide",false);
			
		}

		if (abilityKV.IsPoisonSpell && abilityKV.IsPoisonSpell=="1") {
			poisonSpellInfo.SetHasClass("hide",false);
		}

		if (abilityKV.IsBackstabSpell && abilityKV.IsBackstabSpell=="1") {
			backstabInfo.SetHasClass("hide",false);
		}

		if (abilityKV.IsBurningSpell && abilityKV.IsBurningSpell=="1") {
			burningInfo.SetHasClass("hide",false);
		}

		if (abilityKV.IsFreezingSpell && abilityKV.IsFreezingSpell=="1") {
			freezingInfo.SetHasClass("hide",false);
		}
		if (abilityKV.IsElecshockingSpell && abilityKV.IsElecshockingSpell=="1") {
			elecshockingInfo.SetHasClass("hide",false);
		}

	
		// "ShieldDisabled1"  "1"
		// "ShieldType1"  "2"

		

	}
	if (abilityName.match("Advanced_")) {
		advancedInfo.SetHasClass("hide",false);
		if (unitIndex) {
			// 如果是单位的技能
			const NetTable_key = localPlayerID+"_"+abilityName;
			const level = CustomNetTables.GetTableValue( "playerSpellLevelInfo", NetTable_key);
			var advanced_level = 0;
			var unlock_level = 0;
			if(level){
				advanced_level = level.level;
				const unlock = CustomNetTables.GetTableValue( "playerSpellLevelInfo", NetTable_key+"_unlock");
				if (unlock && unlock.coreUnlock) {
					unlock_level = unlock.coreUnlock;
	
				}

				if (abilityKV) {
					CheckShieldInfo(abilityKV,1,unlock_level,advanced_level,localPlayerID,abilityName);
					CheckShieldInfo(abilityKV,2,unlock_level,advanced_level,localPlayerID,abilityName);
					SetBuffCheckInfo(abilityKV,1,unlock_level,advanced_level,localPlayerID,abilityName);
					SetDebuffCheckInfo(abilityKV,1,unlock_level,advanced_level,localPlayerID,abilityName);
					SetDebuffCheckInfo(abilityKV,2,unlock_level,advanced_level,localPlayerID,abilityName);
					
				}
				
				advancedInfo.SetDialogVariable("value2",  GetAdvancedInfo(abilityName,advanced_level,unlock_level));


				advanced_level_panel.SetHasClass("hide",false);
				
				advanced_level_panel.SetDialogVariable("level",  advanced_level);

			}else{
				advancedInfo.SetHasClass("hide",true);
				advanced_level_panel.SetHasClass("hide",true);
			}
		}else{
			// 如果是图鉴里的没所有者的技能那么显示的为空
			advancedInfo.SetDialogVariable("value2",  GetAdvancedInfo(abilityName,0,0));
			advanced_level_panel.SetHasClass("hide",true);
		}
	}

	if (abilityName.match("heroTalent_")) {
		hero_talent.SetHasClass("hide",false);
		let heroID = abilityName.replaceAll("heroTalent_", '');
		let reg = /[0-9]+/g;
		heroID = heroID.replace(reg,"");  //删除数字
		if (heroID.charAt(heroID.length-1)=="_") {
			heroID = heroID.substr(0, heroID.length - 1);  //删除最后一个字符
		}
		hero_talent.SetDialogVariable("heroName",  $.Localize("#"+heroID));
		// var heroInfo = +$.Localize("#"+heroID)
	}

	if (abilityKV && abilityKV.IsChaoticEraOnly && abilityKV.IsChaoticEraOnly==1) {
		onlyChaoticEra.SetHasClass("hide",false);
	}

}


function GetAdvancedInfo(ability_name,level,unlock_level) {
	var unlock = $.Localize("#DOTA_Tooltip_ability_Unlock");
	// const ad_note_loc_token_base = `DOTA_Tooltip_ability_Info`;
	// let ad_note_loc_string ="<font color='#005791'>"+ $.Localize("#" + ad_note_loc_token_base)+"</font><br/>";
	let ad_note_loc_string ="";

	const ad_note_loc_token = `DOTA_Tooltip_ability_${ability_name}_note_lv5`;
	let ad_note_loc_string_lv5 = $.Localize("#" + ad_note_loc_token);
	if(ad_note_loc_string_lv5){
		if(level>=5){
			ad_note_loc_string_lv5 = "<font color='#798fcc'>"+"LV5:" + unlock + ad_note_loc_string_lv5+"</font>";
		}else{
			ad_note_loc_string_lv5 = "<font color='#777777'>"+"LV5:" + unlock + ad_note_loc_string_lv5+"</font>";
		}
		ad_note_loc_string = ad_note_loc_string+ "<br/>" + ad_note_loc_string_lv5
	}
	ad_note_localized = ad_note_loc_token != ad_note_loc_string;
	ad_note_loc_token_lv10 = `DOTA_Tooltip_ability_${ability_name}_note_lv10`;
	let ad_note_loc_string_lv10 = $.Localize("#" + ad_note_loc_token_lv10);
	if(ad_note_loc_string_lv10){
		if(level>=10){
			ad_note_loc_string_lv10 = "<font color='#798fcc'>"+"LV10:" + unlock + ad_note_loc_string_lv10+"</font>";
		}else{
			ad_note_loc_string_lv10 = "<font color='#777777'>"+"LV10:" + unlock+ ad_note_loc_string_lv10+"</font>";
		}
		ad_note_loc_string = ad_note_loc_string+ "<br/>" + ad_note_loc_string_lv10
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ad_note_loc_token_lv15 = `DOTA_Tooltip_ability_${ability_name}_note_lv15`;
	let ad_note_loc_string_lv15 = $.Localize("#" + ad_note_loc_token_lv15);
	if(ad_note_loc_string_lv15){
		if(level>=15){
			ad_note_loc_string_lv15 = "<font color='#798fcc'>"+"LV15:" + unlock + ad_note_loc_string_lv15+"</font>";
		}else{
			ad_note_loc_string_lv15 = "<font color='#777777'>"+"LV15:" + unlock + ad_note_loc_string_lv15+"</font>";
		}
		ad_note_loc_string = ad_note_loc_string+ "<br/>" + ad_note_loc_string_lv15
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ad_note_loc_token_lv20 = `DOTA_Tooltip_ability_${ability_name}_note_lv20`;
	let ad_note_loc_string_lv20 = $.Localize("#" + ad_note_loc_token_lv20);
	if(ad_note_loc_string_lv20){
		if(level>=20){
			ad_note_loc_string_lv20 = "<font color='#798fcc'>"+"LV20:" + unlock + ad_note_loc_string_lv20+"</font>";
		}else{
			ad_note_loc_string_lv20 = "<font color='#777777'>"+"LV20:" + unlock + ad_note_loc_string_lv20+"</font>";
		}
		ad_note_loc_string = ad_note_loc_string+ "<br/>" + ad_note_loc_string_lv20
	}

	
	if (unlock_level>=1) {
		var unlock_key=  `#DOTA_Tooltip_ability_${ability_name}_note_lv25_`+unlock_level;
		// $.Msg(unlock_key);
		let locailze_unlock = $.Localize(unlock_key);
		var unlock_string = ad_note_loc_string_lv20 = "<font color='#798fcc'>"+"LV25:" + unlock + locailze_unlock+"</font>";
		ad_note_loc_string = ad_note_loc_string+ "<br/>" + unlock_string
	}
	ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(ability_name, ad_note_loc_string);

	return ad_note_loc_string;

}


function SetDebuffCheckInfo(abilityKV,index,unlock_level,advanced_level,playerID,abilityName) {



	let StateResistanceIndex = "StateResistanceIndex"+index;
	let NegativeGainIndex = "NegativeGainIndex"+index;
	let targetDebuffCheck = debuffCheck[index-1];
	let DebuffIndexKeyWord = "DebuffIndexKeyWord"+index;
	let debuffMaxDuration  = "debuffMaxDuration"+index;
	let debuffMinDuration  = "debuffMinDuration"+index;
	let RuneTypeRequire = "debuffInfoRuneTypeRequire"+index;
	let debuffInfoUnlockRequire = "debuffInfoUnlockRequire"+index;
	let debuffInfoLevelRequire = "debuffInfoLevelRequire"+index;




	let showInfo = false;
	if (abilityKV[debuffInfoUnlockRequire]==null && abilityKV[debuffInfoLevelRequire]==null &&abilityKV[RuneTypeRequire]==null) {
		showInfo = true
	}else if (unlock_level || advanced_level) {
		if (abilityKV[debuffInfoUnlockRequire] && abilityKV[debuffInfoUnlockRequire]==unlock_level) {
			showInfo = true;
		}else if (abilityKV[debuffInfoLevelRequire] && abilityKV[debuffInfoLevelRequire]<=advanced_level) {
			showInfo = true;
		}

	}else if (abilityKV[RuneTypeRequire] && playerID!=-1) {
		if (playerID != -1) {
            let data = GetEquippedRune(playerID, abilityName);
            if (data && data.runeId) {
				if (data.runeType==abilityKV[RuneTypeRequire]) {
					showInfo = true;
				}
			}
		}
		
	}

	if (showInfo) {
		if (abilityKV[StateResistanceIndex]!=null || abilityKV[NegativeGainIndex]!=null) {
			targetDebuffCheck.SetHasClass("hide",false);
			if (abilityKV[StateResistanceIndex]!=null) {
				if (typeof(abilityKV[StateResistanceIndex])=="object") {
					let info = abilityKV[StateResistanceIndex].Enemy + "/" +abilityKV[StateResistanceIndex].Allies;
					targetDebuffCheck.SetDialogVariable("value1",  info);
				}else{
					targetDebuffCheck.SetDialogVariable("value1",  abilityKV[StateResistanceIndex]);
				}
	
				
				
			}else{
				targetDebuffCheck.SetDialogVariable("value1",  "?");
			}
			if (abilityKV[NegativeGainIndex]!=null) {
				if (typeof(abilityKV[NegativeGainIndex])=="object") {
					let info = abilityKV[NegativeGainIndex].Enemy + "/" +abilityKV[NegativeGainIndex].Allies;
					targetDebuffCheck.SetDialogVariable("value2",  info);
				}else{
					targetDebuffCheck.SetDialogVariable("value2",  abilityKV[NegativeGainIndex]);
				}
	
	
				// targetDebuffCheck.SetDialogVariable("value2",  abilityKV[NegativeGainIndex]);
			}else{
				targetDebuffCheck.SetDialogVariable("value2",  "?");
			}
	
			if (abilityKV[DebuffIndexKeyWord]) {
				targetDebuffCheck.SetDialogVariable("header1",   $.Localize(abilityKV[DebuffIndexKeyWord]));
			}else{
				targetDebuffCheck.SetDialogVariable("header1",  "");
			}
	
			if (abilityKV[debuffMaxDuration]) {
				targetDebuffCheck.FindChildTraverse("buff_max_duration").SetHasClass("hide",false);
				targetDebuffCheck.SetDialogVariable("max_duration",  abilityKV[debuffMaxDuration]);
			}else{
				targetDebuffCheck.FindChildTraverse("buff_max_duration").SetHasClass("hide",true);
			}
	
			if (abilityKV[debuffMinDuration]) {
				targetDebuffCheck.FindChildTraverse("buff_min_duration").SetHasClass("hide",false);
				targetDebuffCheck.SetDialogVariable("min_duration",  abilityKV[debuffMinDuration]);
			}else{
				targetDebuffCheck.FindChildTraverse("buff_min_duration").SetHasClass("hide",true);
			}
	
		}else{
			targetDebuffCheck.SetHasClass("hide",true);
		}
	}




	
	
	
}


function SetBuffCheckInfo(abilityKV,index,unlock_level,advanced_level,playerID,abilityName) {




	let PositiveGainIndex = "PositiveGainIndex"+index;
	let targetbuffCheck = buffCheck[index-1];
	let BuffIndexKeyWord = "BuffIndexKeyWord"+index;
	let buffMaxDuration  = "buffMaxDuration"+index;
	let buffMinDuration  = "buffMinDuration"+index;
	let RuneTypeRequire = "PositiveInfoRuneTypeRequire"+index;
	let PositiveInfoUnlockRequire = "PositiveInfoUnlockRequire"+index;
	let PositiveInfoLevelRequire = "PositiveInfoLevelRequire"+index;



	let showInfo = false;
	if (abilityKV[PositiveInfoUnlockRequire]==null && abilityKV[PositiveInfoLevelRequire]==null &&abilityKV[RuneTypeRequire]==null) {
		showInfo = true
	}else if (unlock_level || advanced_level) {
		if (abilityKV[PositiveInfoUnlockRequire] && abilityKV[PositiveInfoUnlockRequire]==unlock_level) {
			showInfo = true;
		}else if (abilityKV[PositiveInfoLevelRequire] && abilityKV[PositiveInfoLevelRequire]<=advanced_level) {
			showInfo = true;
		}

	}else if (abilityKV[RuneTypeRequire] && playerID!=-1) {
		if (playerID != -1) {
            let data = GetEquippedRune(playerID, abilityName);
            if (data && data.runeId) {
				if (data.runeType==abilityKV[RuneTypeRequire]) {
					showInfo = true;
				}
			}
		}
		
	}

	if (showInfo) {
		if (abilityKV[PositiveGainIndex]!=null ) {
			targetbuffCheck.SetHasClass("hide",false);
			targetbuffCheck.SetDialogVariable("value1",  abilityKV[PositiveGainIndex]);
	
	
			if (abilityKV[BuffIndexKeyWord]) {
				targetbuffCheck.SetDialogVariable("header1",   $.Localize(abilityKV[BuffIndexKeyWord]));
			}else{
				targetbuffCheck.SetDialogVariable("header1",  "");
			}
	
			if (abilityKV[buffMaxDuration]) {
				targetbuffCheck.FindChildTraverse("buff_max_duration").SetHasClass("hide",false);
				targetbuffCheck.SetDialogVariable("max_duration",  abilityKV[buffMaxDuration]);
			}else{
				targetbuffCheck.FindChildTraverse("buff_max_duration").SetHasClass("hide",true);
			}
	
			if (abilityKV[buffMinDuration]) {
				targetbuffCheck.FindChildTraverse("buff_min_duration").SetHasClass("hide",false);
				targetbuffCheck.SetDialogVariable("min_duration",  abilityKV[buffMinDuration]);
			}else{
				targetbuffCheck.FindChildTraverse("buff_min_duration").SetHasClass("hide",true);
			}
	
		}else{
			targetbuffCheck.SetHasClass("hide",true);
		}
	}else{
		targetbuffCheck.SetHasClass("hide",true);
	}


	

}





function SetProbabilityCheckInfo(abilityKV,index) {




	let ProbabilityIndex = "ProbabilityIndex"+index;
	let targetCheck = probably_info[index-1];
	let ProbabilityKeyWord = "ProbabilityKeyWord"+index;

	if (abilityKV[ProbabilityIndex]!=null ) {
		targetCheck.SetHasClass("hide",false);
		targetCheck.SetDialogVariable("value1",  abilityKV[ProbabilityIndex]);


		if (abilityKV[ProbabilityKeyWord]) {
			targetCheck.SetDialogVariable("header1",   $.Localize(abilityKV[ProbabilityKeyWord]));
		}else{
			targetCheck.SetDialogVariable("header1",  "");
		}



	}else{
		targetCheck.SetHasClass("hide",true);
	}
}




function CheckBreak(abilityKV,index) {




	let canBeBreak = "CanBeBreak"+index;
	let targetIsBreak = isBreak[index-1];
	let KeyWord = "BreakKeyWord"+index;
	let LatterNote = "BreakLatterNote"+index;

	// $.Msg(targetIsBreak);
	
	if (abilityKV[canBeBreak]!=null && abilityKV[canBeBreak]=="1" ) {
		targetIsBreak.SetHasClass("hide",false);
		if (abilityKV[KeyWord]) {
			targetIsBreak.SetDialogVariable("breakTarget",   $.Localize(abilityKV[KeyWord]));
		}else{
			targetIsBreak.SetDialogVariable("breakTarget",  "");
		}
		if (abilityKV[LatterNote]) {
			
			targetIsBreak.SetDialogVariable("breakNote",  ", "+ $.Localize(abilityKV[LatterNote]));
		}else{
			targetIsBreak.SetDialogVariable("breakNote",  "");
		
		}

	

	}else{
		targetIsBreak.SetHasClass("hide",true);
	}
	
}



function CheckFalseDeathInfo(abilityKV,index) {




	let targetIsBreak = falseDeath[index-1];
	let KeyWord = "FalseDeathInfo"+index;

	if (abilityKV[KeyWord]) {
		targetIsBreak.SetHasClass("hide",false);
		targetIsBreak.SetDialogVariable("falseDeathTarget",   $.Localize("#"+abilityKV[KeyWord]));
	}else{
		targetIsBreak.SetHasClass("hide",true);
	}

	
}





function CheckShieldInfo(abilityKV,index,unlock_level,advanced_level,playerID,abilityName) {




	let ShieldDisabled = "ShieldDisabled"+index;
	let ShieldType = "ShieldType"+index;
	let ShieldInfoUnlockRequire = "ShieldInfoUnlockRequire"+index;
	let RuneTypeRequire = "ShieldInfoRuneTypeRequire"+index;
	let ShieldInfoLevelRequire = "ShieldInfoLevelRequire"+index;
	let shield_disable_target = shield_disable[index-1];
	let shield_type_target = shield_type[index-1];
	let ShieldNote = "ShieldNote"+index;



	// const unlock = CustomNetTables.GetTableValue( "playerSpellLevelInfo", NetTable_key+"_unlock");
	// if (unlock && unlock.coreUnlock) {
	// 	unlock_level = unlock.coreUnlock;

	// }
	// let KeyWord = "BreakKeyWord"+index;

	let showInfo = false;





	if (abilityKV[ShieldInfoUnlockRequire]==null && abilityKV[ShieldInfoLevelRequire]==null &&abilityKV[RuneTypeRequire]==null) {
		showInfo = true
	}else if (unlock_level || advanced_level) {
		if (abilityKV[ShieldInfoUnlockRequire] && abilityKV[ShieldInfoUnlockRequire]==unlock_level) {
			showInfo = true;
		}else if (abilityKV[ShieldInfoLevelRequire] && abilityKV[ShieldInfoLevelRequire]<=advanced_level) {
			showInfo = true;
		}

	}else if (abilityKV[RuneTypeRequire] && playerID!=-1) {
		if (playerID != -1) {
            let data = GetEquippedRune(playerID, abilityName);
            if (data && data.runeId) {
				if (data.runeType==abilityKV[RuneTypeRequire]) {
					showInfo = true;
				}
			}
		}
		
	}
	if (showInfo) {
		if (abilityKV[ShieldDisabled] && abilityKV[ShieldDisabled]==1) {
			shield_disable_target.SetHasClass("hide",false);
			if (abilityKV[ShieldNote]) {
				shield_disable_target.SetDialogVariable("name",  $.Localize(abilityKV[ShieldNote]));
			}else{
				shield_disable_target.SetDialogVariable("name",  "");
			}
		}
		if (abilityKV[ShieldType]) {
			shield_type_target.SetDialogVariable("shieldInfo",  $.Localize(abilityKV[ShieldType]));
			shield_type_target.SetHasClass("hide",false);
			if (abilityKV[ShieldNote]) {
				shield_type_target.SetDialogVariable("name",  $.Localize(abilityKV[ShieldNote]));
			}else{
				shield_type_target.SetDialogVariable("name",  "");
			}
		}
	}



	
}


function InitStatusTooltip() {
	let target = base.FindChildTraverse("center_with_stats").FindChildTraverse("stats_tooltip_region");
	if (true) {
		return;
	}
	// $.Msg(target)
	target.ClearPanelEvent("onmouseover");
	target.ClearPanelEvent("onmouseout");

	
    target.SetPanelEvent("onmouseover", function () {
        // $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,item_name,urlid,text);
        let data = {
            // name :individualHeroShopGood,
            // type : ADVANCED_ABILITY_INFO_CHALLENGE,
        }
        let jsonData = JSON.stringify(data);

        $.DispatchEvent("UIShowCustomLayoutParametersTooltip", target, "advanced_unit_state", "file://{resources}/layout/custom_game/tooltips/unit_stats/unit_stats.xml", "data=" + jsonData);
    });

    target.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("UIHideCustomLayoutTooltip", target, "advanced_unit_state");
        
    });
}

function GetEquippedRune(playerID, abilityName) {
    return CustomNetTables.GetTableValue("RuneData", "equip_" + playerID + "_" + abilityName);
}

(function () {


	// $.Schedule(2, function () {
	// 	GameEvents.Subscribe("RegisterHoverableAbility", RegisterHoverableAbility);
	// 	GameEvents.Subscribe("dota_portrait_ability_layout_changed", PortraitUnitChanged);
	// 	GameEvents.Subscribe("dota_player_update_selected_unit", PortraitUnitChanged);
	// 	GameEvents.Subscribe("dota_player_update_query_unit", PortraitUnitChanged);
		
	// 	GameEvents.Subscribe("OnSpellLearn", OnSpellLearn);


	// 	$.RegisterForUnhandledEvent("DOTAShowAbilityTooltipForEntityIndex",OnDOTAShowAbilityTooltipForEntityIndex);
	// 	$.RegisterForUnhandledEvent("DOTAShowAbilityTooltip",OnDOTAShowAbilityTooltip);
	// 	$.RegisterForUnhandledEvent("DOTAShowAbilityShopItemTooltip",OnDOTAShowAbilityShopItemTooltip);

	// });


	GameEvents.Subscribe("RegisterHoverableAbility", RegisterHoverableAbility);
	// GameEvents.Subscribe("dota_portrait_ability_layout_changed", PortraitUnitChanged);
	// GameEvents.Subscribe("dota_player_update_selected_unit", PortraitUnitChanged);
	// GameEvents.Subscribe("dota_player_update_query_unit", PortraitUnitChanged);
	
	// GameEvents.Subscribe("OnSpellLearn", OnSpellLearn);


	$.RegisterForUnhandledEvent("DOTAShowAbilityTooltipForEntityIndex",OnDOTAShowAbilityTooltipForEntityIndex);
	$.RegisterForUnhandledEvent("DOTAShowAbilityTooltip",OnDOTAShowAbilityTooltip);
	$.RegisterForUnhandledEvent("DOTAShowAbilityShopItemTooltip",OnDOTAShowAbilityShopItemTooltip);
	$.RegisterForUnhandledEvent("DOTAShowDroppedItemTooltip",OnDOTAShowDroppedItemTooltip);
    $.RegisterForUnhandledEvent("DOTAShowAbilityInventoryItemTooltip",OnDOTAShowAbilityInventoryItemTooltip);





	

	// Init();

	$.Schedule(0.1, function () {
        // $.Msg("try init");
        // $.Msg("try init");

		Init();
	});

    // LOCAL_DEBUG_TOOLS_PANEL
})();

