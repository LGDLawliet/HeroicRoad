"use strict";
var tSettings = CustomNetTables.GetTableValue("common", "settings");
var current_round_img = "";
var tPlayerAllItem = {};

let shopCartList = {
	"CrystalShopCard_item_card_sr" : true,
	"CrystalShopCard_item_card_ssr": true,
	// "CrystalShopCard_item_chest_04": true,
	"CrystalShopCard_item_chest_05": true,
}



	


function InitCrystalShopItemPanelEvent(panel) {
	panel.SetPanelEvent("onactivate", function () {
		GameEvents.SendEventClientSide("dota_link_clicked", {
			"link": "dota.item." + panel.itemname,
			"shop": 0,
			"recipe": 0,
		});
	});
	panel.SetPanelEvent("oncontextmenu", function () {
		var unitEntIndex = Players.GetSelectedEntities(Players.GetLocalPlayer())[0];
		if (unitEntIndex == undefined || unitEntIndex == null || !Entities.IsControllableByPlayer(unitEntIndex, Players.GetLocalPlayer())) {
			return;
		}
		if (Game.IsGamePaused()) {
			ErrorMessage("dota_hud_error_game_is_paused");
			return;
		}
		if (panel.stock == 0) {
			ErrorMessage("dota_hud_error_item_out_of_stock");
			return;
		}
		if (panel.crystalCost > CrystalAmount) {
			ErrorMessage("dota_hud_error_not_enough_crystal", "General.CastFail_NoMana");
			return;
		}
		if (panel.goldCost > Players.GetGold(Players.GetLocalPlayer())) {
			ErrorMessage("dota_hud_error_not_enough_gold", "General.NoGold");
			return;
		}
		Game.EmitSound("General.Buy");
		GameEvents.SendCustomGameEventToServer("PurchaseCrystalShopItem", {
			itemName: panel.itemname,
			unit: unitEntIndex,
		});
	});
}

function CrystalShopCardOnContextMenu(sItemName) {
	let p = $("#CrystalShop").FindChildTraverse("CrystalShopCard_" + sItemName);
	if (p) {
		var unitEntIndex = Players.GetSelectedEntities(Players.GetLocalPlayer())[0];
		// if (unitEntIndex == undefined || unitEntIndex == null || !Entities.IsControllableByPlayer(unitEntIndex, Players.GetLocalPlayer())) {
		// 	return;
		// }
		// if (Game.IsGamePaused()) {
		// 	ErrorMessage("dota_hud_error_game_is_paused");
		// 	return;
		// }
		// if (p.stock == 0) {
		// 	ErrorMessage("dota_hud_error_item_out_of_stock");
		// 	return;
		// }
		// if (p.crystalCost > CrystalAmount) {
		// 	ErrorMessage("dota_hud_error_not_enough_crystal", "General.CastFail_NoMana");
		// 	return;
		// }
		if (!ShopLawfulCheck(unitEntIndex,p)) {
			return;
		}
		Game.EmitSound("General.Buy");
		GameEvents.SendCustomGameEventToServer("PurchaseCrystalShopCard", {
			itemName: sItemName,
			unit: unitEntIndex,
		});
	}
}
// function CrystalShopCardOnContextMenu_chestt(itemName) {
// 	let p = $("#CrystalShop").FindChildTraverse("CrystalShopCard_" + itemName);
// 	if (p) {
// 		var unitEntIndex = Players.GetSelectedEntities(Players.GetLocalPlayer())[0];
// 		if (!ShopLawfulCheck(unitEntIndex,p)) {
// 			return;
// 		}
// 		Game.EmitSound("General.Buy");
// 		GameEvents.SendCustomGameEventToServer("PurchaseCrystalShopCard", {
// 			itemName: itemName,
// 			unit: unitEntIndex,
// 		});
// 	}
// }



function ShopLawfulCheck(unitEntIndex,data) {
	if (unitEntIndex == undefined || unitEntIndex == null || !Entities.IsControllableByPlayer(unitEntIndex, Players.GetLocalPlayer())) {
		return false;
	}
	if (Game.IsGamePaused()) {
		ErrorMessage("dota_hud_error_game_is_paused");
		return false;
	}
	if (data.stock == 0) {
		ErrorMessage("dota_hud_error_item_out_of_stock");
		return false;
	}
	if (data.crystalCost > CrystalAmount) {
		ErrorMessage("dota_hud_error_not_enough_crystal", "General.CastFail_NoMana");
		return false;
	}
	return true;
}



function InitPropsShopItem() {
	var localPlayerID = Players.GetLocalPlayer();

	if (Players.IsSpectator(localPlayerID)) {
		localPlayerID = -1;
		if (Players.GetLocalPlayerPortraitUnit() != -1) {
			localPlayerID = Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit());
		}
	}
	var crystalShopPropsContainer = $("#CrystalShop").FindChildTraverse("CrystalShopPropsContainer");
	var tPropsShopItem = CustomUIConfig.PropsShopKv;
	for (let i = 0; i < crystalShopPropsContainer.GetChildCount(); i++) {
		let panel = crystalShopPropsContainer.GetChild(i);
		// $.Msg(panel.id);
		// $.Msg(shopCartList);
		// $.Msg(shopCartList[panel.id]);
		if(!shopCartList[panel.id]){
			
		// if (panel.id != "CrystalShopCard_item_card_ssr" && panel.id != "CrystalShopCard_item_card_sr" && panel.id != "CrystalShopCard_item_chest_04") {
			panel.AddClass("Hidden");
			panel.DeleteAsync(0);
		}
	}
	$.Schedule(0, function () {
		if (tPropsShopItem) {
			for (const sItemName in tPropsShopItem) {
				let data = tPropsShopItem[sItemName];
				let panel = crystalShopPropsContainer.FindChild(sItemName);
				if (panel == undefined || panel == null) {
					panel = $.CreatePanel("Panel", crystalShopPropsContainer, sItemName);
					panel.BLoadLayoutSnippet("CrystalShopPropsItem");
					InitCrystalShopPropsItemPanelEvent(panel);
				}
				if (panel.id == sItemName) {
					panel.RemoveClass("Hidden");
					panel.FindChildTraverse("CrystalShopPropsItemImage").itemname = sItemName;
					panel.itemname = sItemName;
					panel.goldCost = data.iGoldCost;
					panel.crystalCost = data.CrystalCost;
					panel.SetHasClass("HasCrystalCost", data.CrystalCost > 0);
					panel.SetHasClass("HasGoldCost", data.iGoldCost > 0);
					panel.SetHasClass("WithGoldCost", data.CrystalCost > 0 && data.iGoldCost > 0);
					panel.SetDialogVariableInt("crystal_cost", data.CrystalCost);
					panel.SetDialogVariableInt("gold_cost", data.iGoldCost);
					panel.SetHasClass("CanPurchase", Math.max(Players.GetGold(localPlayerID) + Players.GetLastBuybackTime(localPlayerID), 0) >= data.iGoldCost && CrystalAmount >= data.CrystalCost);
				}
			}
		}
	});
}
function InitCrystalShopPropsItemPanelEvent(panel) {
	panel.SetPanelEvent("onactivate", function () { });
	panel.SetPanelEvent("oncontextmenu", function () {
		var unitEntIndex = Players.GetSelectedEntities(Players.GetLocalPlayer())[0];
		if (unitEntIndex == undefined || unitEntIndex == null || !Entities.IsControllableByPlayer(unitEntIndex, Players.GetLocalPlayer())) {
			return;
		}
		if (Game.IsGamePaused()) {
			ErrorMessage("dota_hud_error_game_is_paused");
			return;
		}
		if (panel.crystalCost > CrystalAmount) {
			ErrorMessage("dota_hud_error_not_enough_crystal", "General.CastFail_NoMana");
			return;
		}
		if (panel.goldCost > Math.max(Players.GetGold(Players.GetLocalPlayer()) + Players.GetLastBuybackTime(Players.GetLocalPlayer()), 0)) {
			ErrorMessage("dota_hud_error_not_enough_gold", "General.NoGold");
			return;
		}
		Game.EmitSound("General.Buy");
		GameEvents.SendCustomGameEventToServer("PurchaseCrystalShopPropsItem", {
			itemName: panel.itemname,
			unit: unitEntIndex,
		});
	});
}

function InitUnitImageEvent(pImage) {
	pImage.SetPanelEvent("onmouseover", function () {
		$.DispatchEvent("UIShowCustomLayoutParametersTooltip", pImage, "card_tooltip", "file://{resources}/layout/custom_game/tooltips/card/card.xml", "cardname=" + pImage.cardname);
	});

	pImage.SetPanelEvent("onmouseout", function () {
		$.DispatchEvent("UIHideCustomLayoutTooltip", pImage, "card_tooltip");
	});

	pImage.SetPanelEvent("onactivate", function () {
		GameEvents.SendCustomGameEventToServer("PingCard", {
			card_name: pImage.cardname,
		});
	});
}

function InitQualificationAbilityPanelEvents(panel) {
	panel.SetPanelEvent("onactivate", function () {
		GameEvents.SendCustomGameEventToServer("BuildingSelectingQualificationAbility", {
			iUnitIndex: panel.unitEntIndex,
			sAbilityName: panel.abilityname,
		});
	});
}

var StatBranch = $("#CustomStatBranch");

var IsEndless = false;
var NextRoundTime = -1;
var NextRoundWaitTime = -1;
var LastWarningTime = -1;
var WarningTime = -1;
var WarningSoundHandle = -1;
var ShopState = 0;
var CountingMode = 0;
var Difficulty = 0;
var BuildingLimitsPanel;
var CrtstalStockTime = -1;
var CrystalAmount = 0;
var ItemsArea;
var Shop;
var iPortraitUnitQualificationLevel = 5;
var iExtraGold = 0;
var bIsPlus = false;
var fDealCardsCountTime = -1;
var fMinCameraDistance = 1300;
var fMaxCameraDistance = 4000;
var VentureChallengeSelectionTime = -1;
var VentureChallengeLevel = 0;
var VentureChallengeEnabled = true;
var VentureChallengePossibleLevelUp = 0;
var iLastLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();
var iLastGold = Math.max(Players.GetGold(Entities.GetPlayerOwnerID(iLastLocalPortraitUnit)) + Players.GetLastBuybackTime(Entities.GetPlayerOwnerID(iLastLocalPortraitUnit)), 0);





function finiteNumber(i, defaultVar = 0) {
	return isFinite(i) ? i : defaultVar;
}




function ToGreen(text) {
	let newText ="<font color='#90EE90'>" + text+ "</font>";
	return newText;

}

function Update() {
	$.Schedule(0.1, Update);
	
	let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();

	let pCustomHealthLabel = $.GetContextPanel().FindChildTraverse("CustomHealthLabel");
	let pCustomHealthRegenLabel = $.GetContextPanel().FindChildTraverse("CustomHealthRegenLabel");
	// let pAttackDamageLabel = $.GetContextPanel().FindChildTraverse("Stats").FindChildTraverse("DamageModifierLabel");

	
	// $.Msg(pAttackDamageLabel);
	// 生命值显示
	{


		let healthMAXRaw =  Entities.GetCustomMaxHealth(iLocalPortraitUnit);

		let health = Number(Entities.GetHealth(iLocalPortraitUnit));
		let healthMax = Number(Entities.GetMaxHealth(iLocalPortraitUnit));
		if (healthMax == 0)
			healthMax = 1;
		health = health * healthMAXRaw / healthMax;
		//print("<UI> hud_main.Update Health:", health);
		let maxHealth = Number(healthMAXRaw);
		//let fHealthPercent = finiteNumber(health / maxHealth);
		let iMaxHealth = finiteNumber(maxHealth);
		//print("<UI> hud_main.Update Max Health:", iMaxHealth);
		let fHealthRegen = finiteNumber(Number(Entities.GetHealthRegen(iLocalPortraitUnit)));
		if (pCustomHealthLabel) {
			pCustomHealthLabel.text = `${FormatNumber(Math.floor(health))} / ${FormatNumber(Math.floor(iMaxHealth))}`;
		}
		if (pCustomHealthRegenLabel) {
			let s = FormatNumber(fHealthRegen, 1);
			if (fHealthRegen > 0) s = "+" + s;
			pCustomHealthRegenLabel.text = s;
			if (Entities.IsEnemy(iLocalPortraitUnit)) {
				pCustomHealthRegenLabel.style.color = "#ff4433";
			} else {
				pCustomHealthRegenLabel.style.color = "#3ED038";
			}
		}
		// if (pAttackDamageLabel) {

		// 	if (fDamage>=0) {
		// 		pAttackDamageLabel.text =  "+"+FormatNumber(fDamage, 1);
		// 		// pCustomHealthRegenLabel.SetHasClass("StatNegative",false);
		// 		// pCustomHealthRegenLabel.SetHasClass("StatPositive",true);
		// 	}else{
		// 		pAttackDamageLabel.text =  "-"+FormatNumber(fDamage, 1);
		// 		pCustomHealthRegenLabel.SetHasClass("StatNegative",true);
		// 		pCustomHealthRegenLabel.SetHasClass("StatPositive",false);
		// 	}

			



		// }
	}

	//let fCameraDistance = RemapValClamped($("#CameraDistanceSlider").value, 0, 1, fMinCameraDistance, fMaxCameraDistance);
	let fCameraDistance = RemapValClamped($("#CameraDistanceSlider").value, $("#CameraDistanceSlider").min, $("#CameraDistanceSlider").max, fMinCameraDistance, fMaxCameraDistance);

	let fCameraPitch = RemapValClamped(fCameraDistance, 3000, 4000, 60, 90);
	GameUI.SetCameraPitchMin(fCameraPitch);
	GameUI.SetCameraPitchMax(fCameraPitch);
	GameUI.SetCameraDistance(fCameraDistance);

	var localPlayerID = Players.GetLocalPlayer();
	var isAltPressed = GameUI.IsAltDown();
	var localPortraitUnit = Players.GetLocalPlayerPortraitUnit();
	var localPortraitPlayerID = Entities.GetPlayerOwnerID(localPortraitUnit);
	var localHero = Players.GetPlayerHeroEntityIndex(localPlayerID);
	var playerSelectedEntities = Players.GetSelectedEntities(localPlayerID) || [];
	var buildingData = Entities.GetBuildingData(localPortraitUnit);
	var bHasAbilityToSpend = Entities.GetAbilityPoints(localPortraitUnit) > 0;
	var bControllable = Entities.IsControllableByPlayer(localPortraitUnit, localPlayerID);

	let pManaContainer = $("#health_mana").FindChildTraverse("ManaContainer");
	if (pManaContainer) {
		pManaContainer.style.visibility = Entities.IsHero(localPortraitUnit) ? "visible" : "collapse";
	}
	if (StatBranch)
		StatBranch.SetUnit(localPortraitUnit);

	var iGold = Math.max(Players.GetGold(localPortraitPlayerID) + Players.GetLastBuybackTime(localPortraitPlayerID), 0);
	$("#ShopButton").SetDialogVariable("gold", iGold.toFixed(0));
	// 金钱跳动特效
	{
		if (iLastGold != iGold && localPortraitUnit == iLastLocalPortraitUnit) CustomUIConfig.FireChangeGold($("#GoldLabel"), iGold - iLastGold);
		iLastGold = iGold;
		iLastLocalPortraitUnit = localPortraitUnit;
	}

	var n = 0;
	if (bControllable) {
		if (buildingData) {
			var tQualificationAbilities = buildingData.tQualificationAbilities;
			if (tQualificationAbilities) {
				for (const key in tQualificationAbilities) {
					var sQualificationAbility = tQualificationAbilities[key];
					var sCardName = GetCardNameByQualificationAbility(sQualificationAbility);

					var panel = $("#QualificationAbilitiesSelectionContainer").GetChild(n);
					if (panel == undefined || panel == null) {
						panel = $.CreatePanel("Panel", $("#QualificationAbilitiesSelectionContainer"), "");
						panel.BLoadLayoutSnippet("QualificationAbility");
						LoadCard(panel.FindChildTraverse("QualificationCard"));
					}

					InitQualificationAbilityPanelEvents(panel);

					panel.FindChildTraverse("QualificationCard").SetCard(sCardName);
					panel.FindChildTraverse("QualificationCard").SetCardStyle(1);

					panel.RemoveClass("Hidden");

					panel.abilityname = sQualificationAbility;
					panel.unitEntIndex = localPortraitUnit;

					++n;
				}
			}
		}
	}
	for (let i = n; i < $("#QualificationAbilitiesSelectionContainer").GetChildCount(); i++) {
		var panel = $("#QualificationAbilitiesSelectionContainer").GetChild(i);
		panel.AddClass("Hidden");
	}

	$("#QualificationAbilitiesSelection").SetHasClass("Hidden", n == 0);

	$("#lower_hud").SetHasClass("HasAbilityToSpend", bHasAbilityToSpend);

	$("#buffs").SetHasClass("AltPressed", isAltPressed);
	$("#debuffs").SetHasClass("AltPressed", isAltPressed);
	$("#death_panel_buyback").SetHasClass("AltPressed", isAltPressed);
	$("#xp").SetHasClass("AltPressed", isAltPressed);
	$("#Stats").SetHasClass("AltPressed", isAltPressed);
	$("#BuildingsRoundDamage").SetHasClass("AltPressed", isAltPressed);

	$("#center_block").SetHasClass("IsLocalHero", localHero == localPortraitUnit);
	$("#center_block").SetHasClass("NonHero", !Entities.IsHero(localPortraitUnit));

	$("#multiunit").SetHasClass("Hidden", playerSelectedEntities.length <= 1);
	$("#multiunit").SetHasClass("ShowMultiUnit", playerSelectedEntities.length > 1);
	$("#portraitHUD").SetHasClass("Hidden", playerSelectedEntities.length > 1);
	$("#center_block").SetHasClass("MultiUnit", playerSelectedEntities.length > 1);

	let iQualificationLevel = buildingData ? buildingData.iQualificationLevel : 5;
	if (!IsNull(Shop)) {
		if (iQualificationLevel != iPortraitUnitQualificationLevel) {
			let pGridMainShop = Shop.FindChildTraverse("GridMainShop");
			if (!IsNull(pGridMainShop)) {
				let shopItemPanels = Shop.FindChildTraverse("GridMainShop").FindChildrenWithClassTraverse("MainShopItem");
				for (let i = 0; i < shopItemPanels.length; i++) {
					let shopItemPanel = shopItemPanels[i];
					if (IsNull(shopItemPanel)) continue;
					let shopItemImage = shopItemPanel.FindChildTraverse("ItemImage");
					if (IsNull(shopItemImage)) continue;
					let shopItemName = shopItemImage.itemname;
					let iItemRarity = GetItemRarity(shopItemName);

					if (iQualificationLevel >= iItemRarity) {
						shopItemPanel.enabled = true;
						shopItemPanel.style.saturation = null;
						shopItemPanel.style.brightness = null;
					}
					else {
						shopItemPanel.enabled = false;
						shopItemPanel.style.saturation = "0.0";
						shopItemPanel.style.brightness = "0.3";
					}
				}
			}
		}

		let pItemCombines = Shop.FindChildTraverse("ItemCombines");
		if (!IsNull(pItemCombines)) {
			let shopItemPanels = pItemCombines.FindChildrenWithClassTraverse("MainShopItem");
			for (let i = 0; i < shopItemPanels.length; i++) {
				let shopItemPanel = shopItemPanels[i];
				if (IsNull(shopItemPanel)) continue;
				let shopItemImage = shopItemPanel.FindChildTraverse("ItemImage");
				if (IsNull(shopItemImage)) continue;
				let shopItemName = shopItemImage.itemname;
				let iItemRarity = GetItemRarity(shopItemName);

				if (iQualificationLevel >= iItemRarity) {
					shopItemPanel.enabled = true;
					shopItemPanel.style.saturation = null;
					shopItemPanel.style.brightness = null;
				}
				else {
					shopItemPanel.enabled = false;
					shopItemPanel.style.saturation = "0.0";
					shopItemPanel.style.brightness = "0.3";
				}
			}
		}
	}
	iPortraitUnitQualificationLevel = iQualificationLevel;

	if (fDealCardsCountTime != -1) {
		// TODO: 宝箱抽卡倒计时
		var time = Math.max(fDealCardsCountTime - Game.GetGameTime(), 0);
		var percent = Clamp(time / tSettings.deal_cards_time, 0, 1);
		// $("#DealCardsCountdownProgressBar1").value = percent;
		// $("#DealCardsCountdownProgressBar2").value = percent;

		var angle = -360 * percent;
		$("#DealCardsCountdown").style.clip = "radial(50% 50%, 0deg, " + angle + "deg)";
	}

	if (NextRoundTime != -1) {
		var time = Math.max(NextRoundTime - Game.GetGameTime(), 0);
		var minutes = Math.floor(time / 60);
		if (minutes < 10) minutes = "0" + minutes;
		var seconds = Math.floor(time % 60);
		if (seconds < 10) seconds = "0" + seconds;
		$("#RoundCounterLabel").SetDialogVariable("minutes", minutes);
		$("#RoundCounterLabel").SetDialogVariable("seconds", seconds);
	}
	if (WarningTime != -1) {
		var time = Math.max(WarningTime - Game.GetGameTime(), 0);
		if (LastWarningTime != -1 && Math.ceil(LastWarningTime) - Math.ceil(time) > 0) {
			Game.EmitSound("GameUI.Warning." + (Math.ceil(time) + 1));
			$("#MissingCountWarningDigits").TriggerClass("popup");
			$("#MissingCountWarningFx").FireEntityInput("particle_1", "Stop", "1");
			$("#MissingCountWarningFx").FireEntityInput("particle_1", "Start", "1");

			let iParticleID = Particles.CreateParticle("particles/generic_gameplay/warning_screen.vpcf", ParticleAttachment_t.PATTACH_EYES_FOLLOW, Players.GetLocalPlayerPortraitUnit());
			Particles.ReleaseParticleIndex(iParticleID);
		}
		LastWarningTime = time;
		$("#MissingCountWarning").SetDialogVariableInt("warning_time", Math.ceil(LastWarningTime));
		var number = Math.ceil(LastWarningTime);
		$("#MissingCountWarningDigit1").SetHasClass("Hidden", number < 0);
		$("#MissingCountWarningDigit2").SetHasClass("Hidden", number < 10);
		$("#MissingCountWarningDigit3").SetHasClass("Hidden", number < 100);
		$("#MissingCountWarningDigit1").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number % 10)) + "_v2.png");
		$("#MissingCountWarningDigit2").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number / 10) % 10) + "_v2.png");
		$("#MissingCountWarningDigit3").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number / 100) % 100) + "_v2.png");
	}
	if (CrtstalStockTime != -1) {
		var time = Math.max(CrtstalStockTime - Game.GetGameTime(), 0);
		var minutes = Math.floor(time / 60);
		if (minutes < 10) minutes = "0" + minutes;
		var seconds = Math.floor(time % 60);
		if (seconds < 10) seconds = "0" + seconds;
		$("#CrystalShop").SetDialogVariable("minutes", minutes);
		$("#CrystalShop").SetDialogVariable("seconds", seconds);
	}
	var crystalShopContainer = $("#CrystalShop").FindChildTraverse("CrystalShopContainer");
	for (var i = 0; i < crystalShopContainer.GetChildCount(); i++) {
		var panel = crystalShopContainer.GetChild(i);
		var shopItemName = panel.itemname;
		var iItemRarity = GetItemRarity(shopItemName);

		if (iQualificationLevel >= iItemRarity) {
			panel.enabled = true;
			panel.style.saturation = null;
			panel.style.brightness = null;
		}
		else {
			panel.enabled = false;
			panel.style.saturation = "0.0";
			panel.style.brightness = "0.3";
		}
		panel.SetHasClass("CanPurchase", Players.GetGold(localPlayerID) >= panel.goldCost && CrystalAmount >= panel.crystalCost && panel.stock > 0);
		panel.SetHasClass("OutOfStock", panel.stock <= 0);
	}
	if (Shop && Shop.IsValid()) {
		$.GetContextPanel().SetHasClass("ShopLarge", Shop.BHasClass("ShopLarge"));
	}

	if (VentureChallengeSelectionTime != -1) {
		// var time = Math.max(VentureChallengeSelectionTime-Game.GetGameTime(), 0);
		// var percent = Clamp(time / tSettings.venture_challenge_selection_time, 0, 1);
		// $("#CountdownProgressBar1").value = percent;
		// $("#CountdownProgressBar2").value = percent;
	}
}

function UpdateVentureChallenge() {
	$.Schedule(Game.GetGameFrameTime(), UpdateVentureChallenge);
	let venture_limit_level = 5;
	let venture_max_level = (IsEndless) ? 0 : tSettings.new_venture_difficulty_settings.max_level[Difficulty];// 当前难度超负荷最大等级, 无尽没法拉超负荷
	var percent = VentureChallengeLevel / venture_limit_level;// 当前超负荷对应的百分比 todo: 4是所有难度可选的最高超负荷等级，要和xml的(notches-1)相等
	$("#VentureChallengeSelectionSlider").SetValueNoEvents(Math.min(venture_max_level / venture_limit_level, Math.max(percent, $("#VentureChallengeSelectionSlider").value)));

	// 右边灰绿色的条，表示当前难度未解锁的超负荷等级
	let SliderNotchs = $("#VentureChallengeSelection").FindChildrenWithClassTraverse("SliderNotch");
	let SliderNotch = SliderNotchs[venture_max_level];
	if (!IsNull(SliderNotch)) {
		let offset = parseInt(SliderNotch.actualxoffset) + parseInt(SliderNotch.actuallayoutwidth) / 2;
		let pSliderMax = $("#VentureChallengeSelection").FindChildTraverse("SliderMax");
		if (pSliderMax) {
			pSliderMax.style.marginLeft = offset / pSliderMax.actualuiscale_x + "px";
		}
	}

	VentureChallengePossibleLevelUp = parseInt(($("#VentureChallengeSelectionSlider").value * tSettings.venture_challenge_max_level - VentureChallengeLevel).toFixed(0)); // 待定的超负荷等级变化数
	var possibleLevel = VentureChallengeLevel + VentureChallengePossibleLevelUp; // 待定的新超负荷等级
	$("#VentureChallengeSelection").SetHasClass("PossiblyLevelUp", VentureChallengePossibleLevelUp != 0);
	$("#VentureChallengeSelection").SetDialogVariableInt("now_level", VentureChallengeLevel);
	$("#VentureChallengeSelection").SetDialogVariableInt("possible_level", possibleLevel);
	var possible_level_up = "";
	if (VentureChallengePossibleLevelUp >= 0) {
		possible_level_up = "+" + VentureChallengePossibleLevelUp;
	} else {
		possible_level_up = VentureChallengePossibleLevelUp;
	}
	$("#VentureChallengeSelection").SetDialogVariable("possible_level_up", possible_level_up);
	// 挑战
	$("#VentureChallengeSelection").SetDialogVariableInt("locking_missing_count", tSettings.new_venture_level_settings.max_miss[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariableInt("possible_locking_missing_count", tSettings.new_venture_level_settings.max_miss[possibleLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("health_percent", tSettings.new_venture_level_settings.health_percent[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("possible_health_percent", tSettings.new_venture_level_settings.health_percent[possibleLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("venture_armor", tSettings.new_venture_level_settings.armor[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("possible_venture_armor", tSettings.new_venture_level_settings.armor[possibleLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("venture_magic_armor", tSettings.new_venture_level_settings.magic_armor[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("possible_venture_magic_armor", tSettings.new_venture_level_settings.magic_armor[possibleLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("venture_status_resistance", tSettings.new_venture_level_settings.status_resistance[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("possible_venture_status_resistance", tSettings.new_venture_level_settings.status_resistance[possibleLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("venture_aura_count", tSettings.new_venture_level_settings.aura_count[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("possible_venture_aura_count", tSettings.new_venture_level_settings.aura_count[possibleLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("venture_skill_count", tSettings.new_venture_level_settings.skill_count[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("possible_venture_skill_count", tSettings.new_venture_level_settings.skill_count[possibleLevel + 1] || 0);
	// 收益
	$("#VentureChallengeSelection").SetDialogVariable("wave_gold_damage_percent", tSettings.new_venture_level_settings.gold_damage[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("possible_wave_gold_damage_percent", tSettings.new_venture_level_settings.gold_damage[possibleLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("crystal_chance", (tSettings.new_venture_level_settings.crystal_chance[VentureChallengeLevel + 1] || 0).toFixed(2));
	$("#VentureChallengeSelection").SetDialogVariable("possible_crystal_chance", (tSettings.new_venture_level_settings.crystal_chance[possibleLevel + 1] || 0).toFixed(2));
	$("#VentureChallengeSelection").SetDialogVariableInt("max_gold", tSettings.new_venture_level_settings.max_gold[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariableInt("possible_max_gold", tSettings.new_venture_level_settings.max_gold[possibleLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("endless_start_round", tSettings.new_venture_level_settings.endless_start_round[VentureChallengeLevel + 1] || 0);
	$("#VentureChallengeSelection").SetDialogVariable("possible_endless_start_round", tSettings.new_venture_level_settings.endless_start_round[possibleLevel + 1] || 0);

	$("#VentureChallengeSelectionInfoExtraItem").SetHasClass("Hidden", VentureChallengePossibleLevelUp == 0 && VentureChallengeLevel == 0);
	// $("#VentureChallengeSelection").SetDialogVariable("health_percent", VentureChallengeLevel * tSettings.venture_challenge_health_percentage);
	// $("#VentureChallengeSelection").SetDialogVariable("possible_health_percent", possibleLevel * tSettings.venture_challenge_health_percentage);
	// $("#VentureChallengeSelection").SetDialogVariable("wave_gold_damage_percent", VentureChallengeLevel * tSettings.venture_challenge_wave_gold_damage_percentage);
	// $("#VentureChallengeSelection").SetDialogVariable("possible_wave_gold_damage_percent", possibleLevel * tSettings.venture_challenge_wave_gold_damage_percentage);
	// $("#VentureChallengeSelection").SetDialogVariable("crystal_chance", (VentureChallengeLevel * tSettings.Venture_challenge_crystal_chance).toFixed(2));
	// $("#VentureChallengeSelection").SetDialogVariable("possible_crystal_chance", (possibleLevel * tSettings.Venture_challenge_crystal_chance).toFixed(2));
	// $("#VentureChallengeSelection").SetDialogVariableInt("locking_missing_count", VentureChallengeLevel * tSettings.venture_challenge_locking_missing_count);
	// $("#VentureChallengeSelection").SetDialogVariableInt("possible_locking_missing_count", possibleLevel * tSettings.venture_challenge_locking_missing_count);
}

function UpdateCommonNetTable(tableName, tableKeyName, table) {
	var localPlayerID = Players.GetLocalPlayer();

	if (Players.IsSpectator(localPlayerID)) {
		localPlayerID = -1;
		if (Players.GetLocalPlayerPortraitUnit() != -1) {
			localPlayerID = Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit());
		}
	}
	if (tableKeyName == "round_info") {
		current_round_img = IsNull(table.round_img) ? "" : table.round_img;
		var roundPanel = $("#RoundPanel");
		roundPanel.SetHasClass("no_round_info", table.round_title == "");
		roundPanel.SetDialogVariableInt("round", table.round - 1);
		roundPanel.SetDialogVariable("round_title", $.Localize(table.round_title));
		roundPanel.SetDialogVariable("round_description", $.Localize(table.round_description));
		roundPanel.SetDialogVariable("next_round_title", $.Localize(table.next_round_title));
		roundPanel.SetDialogVariable("next_round_description", $.Localize(table.next_round_description));
		NextRoundTime = table.next_round_time;
		NextRoundWaitTime = table.next_round_wait_time;
		IsEndless = table.is_endless == 1;
		$("#KillSelfButton").SetHasClass("Hidden", !IsEndless);
		roundPanel.SetHasClass("ShowDamgeReduce", IsEndless);
		if (IsEndless == true) {
			HiddenORoshanScoreboard();
			let damage_reduce = IsNull(table.damage_reduce) ? 0 : Round(table.damage_reduce, 3);
			roundPanel.SetDialogVariable("damage_reduce", damage_reduce);
		}

		// 显示5秒的boss弹窗图
		if (current_round_img != "") {
			roundPanel.FindChildTraverse("BossIcon").SetImage("file://{images}/custom_game/wave/" + current_round_img + ".png");
			var seq = new RunSequentialActions();
			seq.actions.push(new AddClassAction(roundPanel, "HasRoundImg"));
			seq.actions.push(new WaitAction(5));
			seq.actions.push(new RemoveClassAction(roundPanel, "HasRoundImg"));
			RunSingleAction(seq);
		}
	}
	if (tableKeyName == "player_buildings") {
		if (localPlayerID == -1) return;

		var record = table[localPlayerID.toString()];

		var nonhero_count = 0;
		for (var k in record.nonhero.list) {
			nonhero_count++;
		}
		var hero_count = 0;
		for (var k in record.hero.list) {
			hero_count++;
		}
		BuildingLimitsPanel.SetDialogVariableInt("nonhero_count", nonhero_count);
		BuildingLimitsPanel.SetDialogVariableInt("nonhero_max", record.nonhero.max);
		BuildingLimitsPanel.SetDialogVariableInt("hero_count", hero_count);
		BuildingLimitsPanel.SetDialogVariableInt("hero_max", record.hero.max);
	}
	if (tableKeyName == "player_crystal_shop") {
		var localPlayerCrystalShop = table[localPlayerID.toString()];

		if (!localPlayerCrystalShop) return;

		var crystalShopContainer = $("#CrystalShop").FindChildTraverse("CrystalShopContainer");
		let index = {
			Attack: 0,
			Spell: 0,
			Function: 0,
		};
		for (const key in index) {
			let crystalShopTypeContainer = crystalShopContainer.FindChildTraverse("CrystalShopItem" + key + "Container");
			for (let i = 0; i < crystalShopTypeContainer.GetChildCount(); i++) {
				let panel = crystalShopTypeContainer.GetChild(i);
				panel.AddClass("Hidden");
			}
		}
		for (var itemName in localPlayerCrystalShop) {
			let data = localPlayerCrystalShop[itemName];

			let crystalShopTypeContainer = crystalShopContainer.FindChildTraverse("CrystalShopItem" + data.sType + "Container");
			let panel = crystalShopTypeContainer.GetChild(index[data.sType]);
			if (panel == undefined || panel == null) {
				panel = $.CreatePanel("Panel", crystalShopTypeContainer, "");
				panel.BLoadLayoutSnippet("CrystalShopItem");
				InitCrystalShopItemPanelEvent(panel);
			}
			panel.RemoveClass("Hidden");
			panel.FindChildTraverse("ItemImage").itemname = itemName;
			panel.itemname = itemName;
			panel.stock = data.iStock;
			panel.crystalCost = data.iCrystalCost;
			panel.goldCost = data.iGoldCost;

			panel.SetDialogVariableInt("stock_amount", data.iStock);
			panel.SetDialogVariableInt("crystal_cost", data.iCrystalCost);
			panel.SetDialogVariableInt("gold_cost", data.iGoldCost);
			panel.SetHasClass("CanPurchase", Math.max(Players.GetGold(localPlayerID) + Players.GetLastBuybackTime(localPlayerID), 0) >= data.iGoldCost && CrystalAmount >= data.iCrystalCost && data.iStock > 0);
			panel.SetHasClass("OutOfStock", data.iStock <= 0);

			++index[data.sType];
		}
	}

	if (tableKeyName == "player_crystal_cards") {
		if (localPlayerID == -1) return;

		let localPlayerCrystalShopCard = table[localPlayerID.toString()];

		if (!localPlayerCrystalShopCard) return;
		// $.Msg("check")
		let tRaritys = [
			"item_card_ssr", 
			"item_card_sr",
			// "item_chest_04",
			"item_chest_05",
		];
		for (const sRarity of tRaritys) {
			let tData = localPlayerCrystalShopCard[sRarity];
			if (tData) {
				let p = $("#CrystalShop").FindChildTraverse("CrystalShopCard_" + sRarity);
				if (p) {
					// $.Msg(tData);
					let iCrystalCost = tData.iCrystalCost || 0;
					let iStock = tData.iStock || 0;
					let iStockRound = tData.iStockRound || 0;
					p.SetDialogVariableInt("crystal_cost", iCrystalCost);
					p.SetDialogVariableInt("stock_round", iStockRound);
					p.SetDialogVariableInt("stock_amount", iStock);

					p.SetHasClass("CanPurchase", CrystalAmount >= iCrystalCost && iStock > 0);
					p.SetHasClass("OutOfStock", iStock <= 0);

					p.crystalCost = iCrystalCost;
					p.stock = iStock;
				}
			}
		}
	}
	if (tableKeyName == "crystal_shop") {
		CrtstalStockTime = table.stock_time;
	}
	if (tableKeyName == "game_mode_info") {
		CountingMode = table.counting_mode;
		Difficulty = table.difficulty[localPlayerID.toString()];

		// $.GetContextPanel().SetHasClass("ShowRoshanRank", Difficulty == 5 && CountingMode == 0);
		if (Difficulty <= 1) {
			$("#NewPlayerGuiderOpenButton").RemoveClass("Hidden");
			GameUI.ToggleWindows('NewPlayerGuider');
		}
	}
	if (tableKeyName == "phantom_roshan_info") {
		let roshanPanel = $("#PhantomRoshanWarning");
		roshanPanel.FindChildTraverse("PhantomRoshanWarningDescription").SetHasClass("Hidden", table.iTeamMode == 0);
		roshanPanel.SetDialogVariableInt("roshan_count", table.roshan_count);
		roshanPanel.SetHasClass("Hidden", false);
		$.Schedule(table.wait_time, function () {
			roshanPanel.SetHasClass("Hidden", true);
		});
	}
	if (tableKeyName == "roshan_info") {
		var roshanPanel = $("#RoshanWarning");
		roshanPanel.SetDialogVariableInt("roshan_count", table.roshan_count);
		roshanPanel.FindChildTraverse("RoshanWarningDescription").SetHasClass("Hidden", table.iTeamMode == 0);
		roshanPanel.SetHasClass("Hidden", false);
		$.Schedule(table.wait_time, function () {
			roshanPanel.SetHasClass("Hidden", true);
		});
	}
	if (tableKeyName == "endless_notification") {
		$("#RoundPanel").SetHasClass("is_roshan_round", false);
		$("#EndlessNotification").SetHasClass("Hidden", false);
		$.Schedule(table.duration, function () {
			$("#EndlessNotification").SetHasClass("Hidden", true);
		});
	}
	if (tableKeyName == "roshan_time_remaining") {
		let time = table.time;
		$("#RoundPanel").SetHasClass("is_roshan_round", time > 0);

		if (LastWarningTime != -1 && Math.ceil(LastWarningTime) - Math.ceil(time) > 0) {
			Game.EmitSound("GameUI.Warning." + Math.ceil(time));
			$("#MissingCountWarningDigits").TriggerClass("popup");
			$("#MissingCountWarningFx").FireEntityInput("particle_1", "Stop", "1");
			$("#MissingCountWarningFx").FireEntityInput("particle_1", "Start", "1");

			let iParticleID = Particles.CreateParticle("particles/generic_gameplay/warning_screen.vpcf", ParticleAttachment_t.PATTACH_EYES_FOLLOW, Players.GetLocalPlayerPortraitUnit());
			Particles.ReleaseParticleIndex(iParticleID);
		}
		LastWarningTime = time;
		$("#MissingCountWarning").SetDialogVariableInt("warning_time", Math.ceil(LastWarningTime));
		var number = Math.ceil(LastWarningTime);
		$("#MissingCountWarningDigit1").SetHasClass("Hidden", number < 0);
		$("#MissingCountWarningDigit2").SetHasClass("Hidden", number < 10);
		$("#MissingCountWarningDigit3").SetHasClass("Hidden", number < 100);
		$("#MissingCountWarningDigit1").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number % 10)) + "_v2.png");
		$("#MissingCountWarningDigit2").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number / 10) % 10) + "_v2.png");
		$("#MissingCountWarningDigit3").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number / 100) % 100) + "_v2.png");
	}
	if (tableKeyName == "phantom_roshan_time_remaining") {
		let time = table.time;
		$("#RoundPanel").SetHasClass("is_roshan_round", time > 0);

		if (LastWarningTime != -1 && Math.ceil(LastWarningTime) - Math.ceil(time) > 0) {
			Game.EmitSound("GameUI.Warning." + Math.ceil(time));
			$("#MissingCountWarningDigits").TriggerClass("popup");
			$("#MissingCountWarningFx").FireEntityInput("particle_1", "Stop", "1");
			$("#MissingCountWarningFx").FireEntityInput("particle_1", "Start", "1");

			let iParticleID = Particles.CreateParticle("particles/generic_gameplay/warning_screen.vpcf", ParticleAttachment_t.PATTACH_EYES_FOLLOW, Players.GetLocalPlayerPortraitUnit());
			Particles.ReleaseParticleIndex(iParticleID);
		}
		LastWarningTime = time;
		$("#MissingCountWarning").SetDialogVariableInt("warning_time", Math.ceil(LastWarningTime));
		var number = Math.ceil(LastWarningTime);
		$("#MissingCountWarningDigit1").SetHasClass("Hidden", number < 0);
		$("#MissingCountWarningDigit2").SetHasClass("Hidden", number < 10);
		$("#MissingCountWarningDigit3").SetHasClass("Hidden", number < 100);
		$("#MissingCountWarningDigit1").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number % 10)) + "_v2.png");
		$("#MissingCountWarningDigit2").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number / 10) % 10) + "_v2.png");
		$("#MissingCountWarningDigit3").SetImage("file://{images}/hud/arcana/es/numbers/combo_" + Math.floor((number / 100) % 100) + "_v2.png");
	}
	if (tableKeyName == "deal_cards") {
		if (table.countdown_time == undefined || table.countdown_time == null) {
			$("#DealCards").SetHasClass("show", false);
			fDealCardsCountTime = -1;
			return;
		}
		$("#DealCards").SetHasClass("show", true);

		var tPlayerIDs = table.player_ids;
		var iCurrentPlayerID = tPlayerIDs["1"];
		var tPlayerInfo = Game.GetPlayerInfo(iCurrentPlayerID);

		$("#DealCardsCurrentPlayerName").steamid = tPlayerInfo.player_steamid;
		$("#DealCardsCurrentPlayerAvatar").steamid = tPlayerInfo.player_steamid;

		fDealCardsCountTime = table.countdown_time;
		var tCards = table.cards;

		for (var index = 0; index < $("#DealCardsContainer").GetChildCount(); index++) {
			var panel = $("#DealCardsContainer").GetChild(index);
			panel.enabled = false;
			panel.AddClass("Hidden");
		}

		var bIsCurrentPlayer = iCurrentPlayerID == localPlayerID;
		$("#DealCards").SetHasClass("TurnToPick", bIsCurrentPlayer);
		if (bIsCurrentPlayer) {
			$("#DealCardsContainer").SetHasClass("CloseDealCardsContainer", false);
		}

		for (var key in tCards) {
			var iCardIndex = parseInt(key);
			var tCardInfo = tCards[key];
			var sCardName = tCardInfo.card_name;
			var iTakingPlayer = tCardInfo.player_id;
			var panelID = "DealCard_" + key;

			var panel = $("#DealCardsContainer").FindChildTraverse(panelID);
			if (panel == undefined || panel == null) {
				panel = $.CreatePanel("Panel", $("#DealCardsContainer"), panelID);
				panel.BLoadLayoutSnippet("DealCards_Card");
				LoadCard(panel.FindChildTraverse("Card"));
				InitDealCardsCardPanelEvent(panel);
			}

			panel.FindChildTraverse("Card").SetCard(sCardName);
			panel.SetHasClass("HasTakingPlayer", iTakingPlayer != -1);
			if (Players.IsValidPlayerID(iTakingPlayer)) {
				var iTakingPlayerInfo = Game.GetPlayerInfo(iTakingPlayer);
				panel.FindChildTraverse("TakingPlayerAvatar").steamid = iTakingPlayerInfo.player_steamid;
				panel.takingPlayer = iTakingPlayer;
				panel.SetDialogVariable("taking_player_name", iTakingPlayerInfo.player_name);
			}

			panel.FindChildTraverse("Card").SetCardStyle(bIsCurrentPlayer ? 0 : 1);

			panel.cardIndex = iCardIndex;
			panel.cardName = sCardName;
			panel.canPick = bIsCurrentPlayer;
			panel.enabled = true;

			panel.RemoveClass("Hidden");
		}
	}
	if (tableKeyName == "deal_mid_boss_reward") {
		if (table.countdown_time == undefined || table.countdown_time == null) {
			$("#DealCards").SetHasClass("show", false);
			fDealCardsCountTime = -1;
			return;
		}
		$("#DealCards").SetHasClass("show", true);

		let tPlayerIDs = table.player_ids;
		let iCurrentPlayerID = tPlayerIDs["1"];
		let tPlayerInfo = Game.GetPlayerInfo(iCurrentPlayerID);

		$("#DealCardsCurrentPlayerName").steamid = tPlayerInfo.player_steamid;
		$("#DealCardsCurrentPlayerAvatar").steamid = tPlayerInfo.player_steamid;

		fDealCardsCountTime = table.countdown_time;
		let tReward = table.rewards;

		for (let index = 0; index < $("#DealCardsContainer").GetChildCount(); index++) {
			let panel = $("#DealCardsContainer").GetChild(index);
			panel.enabled = false;
			panel.AddClass("Hidden");
		}

		let bIsCurrentPlayer = iCurrentPlayerID == localPlayerID;
		$("#DealCards").SetHasClass("TurnToPick", bIsCurrentPlayer);

		for (let key in tReward) {
			let iItemIndex = parseInt(key);
			let tRewardInfo = tReward[key];
			let tItemInfo = tRewardInfo.sItemName.split(",");
			let sItemName = tItemInfo[0];
			let sItemNum = tItemInfo[1];
			let iRarity = tRewardInfo.sRarity;
			let iTakingPlayer = tRewardInfo.player_id;
			let panelID = "DealMidBossReward_" + key;

			let panel = $("#DealCardsContainer").FindChildTraverse(panelID);
			if (panel == undefined || panel == null) {
				panel = $.CreatePanel("Panel", $("#DealCardsContainer"), panelID);
				panel.BLoadLayoutSnippet("MidBossRewardItem");
				InitDealMidBossRewardPanelEvent(panel);
			}

			panel.SetDialogVariable("phantom_roshan_reward_rarity", $.Localize("#MidBossRewardItemRarity_" + iRarity));
			panel.FindChildTraverse("MidBossRewardItemImage").itemname = sItemName;
			panel.FindChildTraverse("MidBossRewardItemmNum").SetDialogVariableInt("item_num", parseInt(sItemNum));
			panel.FindChildTraverse("MidBossRewardItemmNum").SetHasClass("Hidden", parseInt(sItemNum) <= 1);
			panel.SetHasClass("HasTakingPlayer", iTakingPlayer != -1);
			if (Players.IsValidPlayerID(iTakingPlayer)) {
				let iTakingPlayerInfo = Game.GetPlayerInfo(iTakingPlayer);
				panel.FindChildTraverse("TakingPlayerAvatar").steamid = iTakingPlayerInfo.player_steamid;
				panel.takingPlayer = iTakingPlayer;
				panel.SetDialogVariable("taking_player_name", iTakingPlayerInfo.player_name);
			}

			panel.tItemInfo = tItemInfo;
			panel.iItemIndex = iItemIndex;
			panel.sItemName = sItemName;
			panel.canPick = bIsCurrentPlayer;
			panel.enabled = true;

			panel.RemoveClass("Hidden");
		}
	}
	if (tableKeyName == "environment") {
		if (table.now_environment_type == undefined || table.now_environment_type == null) return;
		switch (table.now_environment_type) {
			case 0:
				$("#RoundEnvironment").SetDialogVariable("environment_name", $.Localize("#RoundEnvironment_Day"));
				$("#RoundEnvironment").SetDialogVariable("environment_description", $.Localize("#RoundEnvironment_Day_Description"));
				$.GetContextPanel().SwitchClass("Environment", "is_day");
				break;
			case 1:
				$("#RoundEnvironment").SetDialogVariable("environment_name", $.Localize("#RoundEnvironment_Night"));
				$("#RoundEnvironment").SetDialogVariable("environment_description", $.Localize("#RoundEnvironment_Night_Description"));
				$.GetContextPanel().SwitchClass("Environment", "is_night");
				break;
			case 2:
				$("#RoundEnvironment").SetDialogVariable("environment_name", $.Localize("#RoundEnvironment_Bloodmoon"));
				$("#RoundEnvironment").SetDialogVariable("environment_description", $.Localize("#RoundEnvironment_Bloodmoon_Description"));
				$.GetContextPanel().SwitchClass("Environment", "is_bloodmoon");
				break;
		}
	}
}

function UpdatePlayerDataNetTable(tableName, tableKeyName, table) {
	var localPlayerID = Players.GetLocalPlayer();

	if (tableKeyName == "player_datas") {
		if (localPlayerID == -1) return;
		var localHeroEntIndex = Players.GetPlayerHeroEntityIndex(localPlayerID);
		var localPlayerData = table[localPlayerID.toString()];
		// 漏怪
		var playerMaxMissingCount = (IsNull(tSettings)) ? 0 : tSettings["player_max_missing_count"];

		var missingCountPanel = $("#MissingCountPanel");
		var missingCount = 0;// 场上现在有几个怪
		var maxMissingCount = 0;// 漏怪上限
		let iVentureMissReduce = 0; // 超负荷带来的漏怪上限减少

		switch (CountingMode) {
			case 0: // 团队
				var playerCount = 0;
				for (var k in table) {
					var hero = Players.GetPlayerHeroEntityIndex(parseInt(k));
					if (hero != -1 && Entities.IsAlive(hero)) {
						playerCount++;
						let ventureChallenge = (table[k].venture_challenge_enabled == 1 ? table[k].venture_challenge : 0);
						iVentureMissReduce += (tSettings.new_venture_level_settings.max_miss[ventureChallenge + 1] || 0);
						missingCount += table[k].missingCount;
					}
				}
				maxMissingCount = playerMaxMissingCount[playerCount.toString()];

				break;
			case 1:
				let ventureChallenge = localPlayerData.venture_challenge_enabled == 1 ? localPlayerData.venture_challenge : 0;
				iVentureMissReduce += (tSettings.new_venture_level_settings.max_miss[ventureChallenge + 1] || 0);
				missingCount = localPlayerData.missingCount;
				maxMissingCount = playerMaxMissingCount["0"];
				break;
		}

		missingCountPanel.SetDialogVariableInt("venture_challenge_miss_reduce", iVentureMissReduce);
		missingCountPanel.SetDialogVariableInt("missing_count", missingCount);
		missingCountPanel.SetDialogVariableInt("max_missing_count", maxMissingCount - iVentureMissReduce);
		$("#RoundPanel").SetHasClass("beyond_limit", Entities.IsAlive(localHeroEntIndex) && missingCount != 0 && missingCount >= maxMissingCount - iVentureMissReduce);
		$("#VentureChallengeProgressBar").value = iVentureMissReduce == 0 ? 0 : Math.max(iVentureMissReduce / maxMissingCount, 0.1);
		$("#MissingCountProgressBar").value = RemapValClamped(missingCount / (maxMissingCount - iVentureMissReduce), 0, 1, 0, 1 - $("#VentureChallengeProgressBar").value) + $("#VentureChallengeProgressBar").value;;

		// 警告时间
		var oldWarningTime = WarningTime;
		WarningTime = localPlayerData.warning_time || -1;

		if (oldWarningTime != WarningTime) {
			if (WarningTime != -1) {
				LastWarningTime = Math.max(WarningTime - Game.GetGameTime(), 0) + 1;
			}
			else {
				LastWarningTime = -1;
			}
		}

		// 额外金钱
		iExtraGold = localPlayerData.extra_gold;

		// 水晶
		$("#CrystalShop").SetDialogVariableInt("crystal_amount", localPlayerData.crystal);
		CrystalAmount = localPlayerData.crystal;
		let tType = {
			Attack: 0,
			Spell: 0,
			Function: 0,
		};
		let crystalShopContainer = $("#CrystalShop").FindChildTraverse("CrystalShopContainer");
		for (const key in tType) {
			let crystalShopTypeContainer = crystalShopContainer.FindChildTraverse("CrystalShopItem" + key + "Container");
			for (let i = 0; i < crystalShopTypeContainer.GetChildCount(); i++) {
				let panel = crystalShopTypeContainer.GetChild(i);
				panel.SetHasClass("CanPurchase", Math.max(Players.GetGold(localPlayerID) + Players.GetLastBuybackTime(localPlayerID), 0) >= panel.goldCost && CrystalAmount >= panel.crystalCost && panel.stock > 0);
			}
		}
		let crystalShopPropsContainer = $("#CrystalShop").FindChildTraverse("CrystalShopPropsContainer");
		for (let i = 0; i < crystalShopPropsContainer.GetChildCount(); i++) {
			let panel = crystalShopPropsContainer.GetChild(i);
			// if (panel.id != "CrystalShopCard_item_card_ssr" && panel.id != "CrystalShopCard_item_card_sr") {
			if(shopCartList[panel.id]){
				panel.SetHasClass("CanPurchase", Math.max(Players.GetGold(localPlayerID) + Players.GetLastBuybackTime(localPlayerID), 0) >= panel.goldCost && CrystalAmount >= panel.crystalCost);
			}
		}

		// Plus
		bIsPlus = localPlayerData.monthcard == 1;

		// Venture Challenge
		VentureChallengeLevel = IsEndless ? 0 : localPlayerData.venture_challenge;
		VentureChallengeEnabled = localPlayerData.venture_challenge_enabled == 1;

		$("#VentureChallenge").SetHasClass("Hidden", !VentureChallengeEnabled);
		$("#VentureChallenge").SetDialogVariableInt("venture_challenge_level", VentureChallengeLevel);

		// $.Schedule(1, function() {
		var SliderNotchs = $("#VentureChallengeSelection").FindChildrenWithClassTraverse("SliderNotch");
		var SliderNotch = SliderNotchs[VentureChallengeLevel];
		if (SliderNotch != undefined && SliderNotch != null) {
			var offset = parseInt(SliderNotch.actualxoffset);
			let pSliderMin = $("#VentureChallengeSelection").FindChildTraverse("SliderMin");
			if (pSliderMin) {
				pSliderMin.style.width = offset / pSliderMin.actualuiscale_x + "px";
			}
		}
		for (var index = 0; index < SliderNotchs.length; index++) {
			var SliderNotch = SliderNotchs[index];
			// SliderNotch.SetHasClass("Node", index % 5 == 0);
			SliderNotch.SetHasClass("Node", true);
		}
		// });
		$("#HiddenResetQualificationAbility").checked = localPlayerData.bShowConfirmResetQualificationAbility;
	}
	// if (tableKeyName == "venture_challenge_selection") {
	// 	VentureChallengeSelectionTime = table.selection_time;

	// 	var tSelectionInfo = table.selection_info;
	// 	if (tSelectionInfo[localPlayerID.toString()]) {
	// 		var bCanLevelUp = tSelectionInfo[localPlayerID.toString()].can_level_up;
	// 		var bShow = (bCanLevelUp != undefined || bCanLevelUp != null) ? bCanLevelUp == 1 : false;
	// 		$("#VentureChallengeSelection").SetHasClass("Show", bShow);
	// 	}
	// }
}

function UpdateServiceNetTable(tableName, tableKeyName, table) {
	var localPlayerID = Players.GetLocalPlayer();
	if (tableKeyName == "player_all_items") {
		var playerAllItem = table[localPlayerID.toString()];

		if (playerAllItem == undefined || playerAllItem == null) return;

		tPlayerAllItem = playerAllItem;

		UpdateStoreProps(playerAllItem);

		// for (var k in CustomUIConfig.HeroIDKv) {
		// 	tSkin[CustomUIConfig.HeroIDKv[k]] = [k];
		// };
		// for (var sItemName in playerAllItem) {
		// 	var sUnitName = SkinNameToUnitName(sItemName);
		// 	if (sUnitName) {
		// 		var sHeroID = GetHeroID(sUnitName);
		// 		if (tSkin[sHeroID] != undefined) {
		// 			tSkin[sHeroID].push(sItemName);
		// 		}
		// 	}
		// }

		// UpdateCardSkin();
	}
}

function VentureChallengeSelectionConfirm() {
	GameEvents.SendCustomGameEventToServer("VentureChallengeLevelup", {
		level: VentureChallengePossibleLevelUp,
	});
}
function VentureChallengeSelectionCancel() {
	var percent = VentureChallengeLevel / tSettings.venture_challenge_max_level;
	$("#VentureChallengeSelectionSlider").SetValueNoEvents(percent);
}

function OnAllRoshanKilled() {
	$("#RoshanScoreboard").SetHasClass("Hidden", true);
	$("#MissingComplete").SetHasClass("Hidden", false);
	$.Schedule(10, function () {
		$("#MissingComplete").SetHasClass("Hidden", true);
	});
}

function OnRoshanKilled(data) {
	var iLocalplayerID = Players.GetLocalPlayer();
	var panelID = "#RoshanPlayerScore_" + data.iPlayerID;
	var RoshanPlayerScore = $(panelID);
	if (RoshanPlayerScore != undefined) {
		if (iLocalplayerID == data.iPlayerID) {
			RoshanPlayerScore.SetHasClass("WaitingKillRoshan", true);
		}
		else {
			RoshanPlayerScore.SetHasClass("SuccessKillRoshan", true);
		}
	}
}

function InitDealCardsCardPanelEvent(panel) {
	panel.FindChildTraverse("TakingPlayer").SetPanelEvent("onmouseover", function () {
		if (panel.takingPlayer != undefined && panel.takingPlayer != null) {
			$.DispatchEvent("DOTAShowTextTooltip", panel.FindChildTraverse("TakingPlayer"), $.Localize("#DealCards_HasTakingPlayer", panel));
		}
	});
	panel.FindChildTraverse("TakingPlayer").SetPanelEvent("onmouseout", function () {
		$.DispatchEvent("DOTAHideTextTooltip", panel.FindChildTraverse("TakingPlayer"));
	});
	panel.SetPanelEvent("onactivate", function () {
		if (panel.canPick) {
			GameEvents.SendCustomGameEventToServer("TakeCard", {
				card_index: panel.cardIndex,
			});
		}
		else {
			GameEvents.SendCustomGameEventToServer("PingCard", {
				card_name: panel.cardName,
			});
		}
	});

	panel.FindChildTraverse("Card").FindChildTraverse("CardImage").SetPanelEvent("onmouseover", () => {
		if (!CustomUIConfig.bHiddenCardRoles) {
			panel.FindChildTraverse("Card").AddClass("ShowCardRoles");
		}
	});
	panel.FindChildTraverse("Card").FindChildTraverse("CardImage").SetPanelEvent("onmouseout", () => {
		if (!CustomUIConfig.bHiddenCardRoles) {
			panel.FindChildTraverse("Card").RemoveClass("ShowCardRoles");
		}
	});
}
function InitDealMidBossRewardPanelEvent(panel) {
	panel.FindChildTraverse("TakingPlayer").SetPanelEvent("onmouseover", function () {
		if (panel.takingPlayer != undefined && panel.takingPlayer != null) {
			$.DispatchEvent("DOTAShowTextTooltip", panel.FindChildTraverse("TakingPlayer"), $.Localize("#DealCards_HasTakingPlayer", panel));
		}
	});
	panel.FindChildTraverse("TakingPlayer").SetPanelEvent("onmouseout", function () {
		$.DispatchEvent("DOTAHideTextTooltip", panel.FindChildTraverse("TakingPlayer"));
	});
	panel.SetPanelEvent("onactivate", function () {
		if (panel.canPick) {
			GameEvents.SendCustomGameEventToServer("TakeMidBossReward", {
				iItemIndex: panel.iItemIndex,
			});
		}
		else {
			GameEvents.SendCustomGameEventToServer("PingMidBossReward", {
				sItemName: panel.sItemName,
			});
		}
	});
}

function EventAbilityLearnModeToggled(bInLearnMode) {
	$.GetContextPanel().SetHasClass("AbilityLearnMode", bInLearnMode);
}

function OnShowDrawing(data) {
	var soundList = HERO_SPAWN_SOUND_EVENTS[data.name];
	if (soundList != undefined && soundList != null) {
		var soundEventName = soundList[Math.floor((Math.random() * soundList.length))];
		Game.EmitSound(soundEventName);
	}
	$("#BuildingDrawing").SetImage("file://{images}/custom_game/drawing/building/" + data.name + ".png");
	$("#BuildingDrawing").TriggerClass("fade");

	var particleID = Particles.CreateParticle("particles/generic_gameplay/screen_arcane_drop.vpcf", ParticleAttachment_t.PATTACH_EYES_FOLLOW, 0);
	$.Schedule(0.5, function () {
		Particles.DestroyParticleEffect(particleID, false);
	});
}

function OnShowRoundDamage(data) {
	var fMaxDamage = 0;
	var aList = [];
	for (var sUnitName in data) {
		var tDamage = data[sUnitName] || {};
		var fDamage = 0;
		for (var sDamageType in tDamage) {
			fDamage = fDamage + Number(tDamage[sDamageType]);
		}
		fMaxDamage = Math.max(fMaxDamage, fDamage);
		aList.push({
			unit_name: sUnitName,
			damage: fDamage,
			physical_damage: fDamage == 0 ? 0 : (parseFloat(tDamage[DAMAGE_TYPES.DAMAGE_TYPE_PHYSICAL.toString()] || 0) / fDamage).toFixed(4),
			magical_damage: fDamage == 0 ? 0 : (parseFloat(tDamage[DAMAGE_TYPES.DAMAGE_TYPE_MAGICAL.toString()] || 0) / fDamage).toFixed(4),
			pure_damage: fDamage == 0 ? 0 : (parseFloat(tDamage[DAMAGE_TYPES.DAMAGE_TYPE_PURE.toString()] || 0) / fDamage).toFixed(4),
		});
	}
	$("#BuildingsRoundDamageContainer").RemoveAndDeleteChildren();
	for (var iIndex = 0; iIndex < aList.length; iIndex++) {
		let tData = aList[iIndex];
		let fDamage = tData.damage;
		let sUnitName = tData.unit_name;

		let sCardRarity = GetCardRarity(sUnitName);

		let panel = $.CreatePanel("Panel", $("#BuildingsRoundDamageContainer"), sUnitName);
		panel.BLoadLayoutSnippet("BuildingRoundDamage");
		panel.fDamage = fDamage;

		panel.SetDialogVariable("unit_name", $.Localize("#" + sUnitName));
		panel.FindChildTraverse("BuildingIcon").SetImage(GetCardIcon(sUnitName));

		// panel.SetDialogVariable("damage", formatNumByLanguage(fDamage));
		panel.SetDialogVariable("damage", FormatNumber(fDamage));
		panel.FindChildTraverse("BuildingRoundDamageProgressBar").value = fDamage / fMaxDamage;
		panel.FindChildTraverse("PhysicalDamage").style.width = tData.physical_damage * 100 + "%";
		panel.FindChildTraverse("MagicalDamage").style.width = tData.magical_damage * 100 + "%";
		panel.FindChildTraverse("PureDamage").style.width = tData.pure_damage * 100 + "%";

		panel.FindChildTraverse("PhysicalPercentage").style.width = tData.physical_damage * 100 + "%";
		panel.FindChildTraverse("MagicalPercentage").style.width = tData.magical_damage * 100 + "%";
		panel.FindChildTraverse("PurePercentage").style.width = tData.pure_damage * 100 + "%";

		panel.SetDialogVariable("physical_ptg", (tData.physical_damage * 100).toFixed(0));
		panel.SetDialogVariable("magical_ptg", (tData.magical_damage * 100).toFixed(0));
		panel.SetDialogVariable("pure_ptg", (tData.pure_damage * 100).toFixed(0));

		panel.SetHasClass("rarity_n", sCardRarity == "n");
		panel.SetHasClass("rarity_r", sCardRarity == "r");
		panel.SetHasClass("rarity_sr", sCardRarity == "sr");
		panel.SetHasClass("rarity_ssr", sCardRarity == "ssr");
	}
	for (var i = 0; i < $("#BuildingsRoundDamageContainer").GetChildCount() - 1; i++) {
		for (var j = 0; j < $("#BuildingsRoundDamageContainer").GetChildCount() - 1 - i; j++) {
			var panel1 = $("#BuildingsRoundDamageContainer").GetChild(j);
			var panel2 = $("#BuildingsRoundDamageContainer").GetChild(j + 1);
			if (panel1.fDamage < panel2.fDamage) {
				$("#BuildingsRoundDamageContainer").MoveChildAfter(panel1, panel2);
			}
		}
	}
}

function OnToggleRoundDamage() {
	$("#BuildingsRoundDamage").ToggleClass("show");
}

function CreateRoshanScoreboard() {
	var RoshanScoreboard = $("#RoshanScoreboard");
	RoshanScoreboard.SetHasClass("ShowRoshanScoreboard", true);
	var playerIDs = Game.GetAllPlayerIDs();
	for (var index = 0; index < playerIDs.length; index++) {
		var playerID = playerIDs[index];
		var playerInfo = Game.GetPlayerInfo(playerID);
		var playerColor = intToARGB(Players.GetPlayerColor(playerID));
		var hHeroIndex = Players.GetPlayerHeroEntityIndex(playerID);

		if (playerInfo.player_connection_state != DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED && Entities.IsAlive(hHeroIndex) == false) {
			var panelID = "RoshanPlayerScore_" + playerID;
			var panel = RoshanScoreboard.FindChildTraverse(panelID);
			if (panel == undefined || panel == null) {
				panel = $.CreatePanel("Panel", RoshanScoreboard, panelID);
				panel.BLoadLayoutSnippet("RoshanPlayerScore");
				panel.FindChildTraverse("RoshanPlayerAvatar").SetPanelEvent("onactivate", function () {
				});
			}

			panel.FindChildTraverse("RoshanPlayerColor").style.backgroundColor = "#" + playerColor;
			panel.FindChildTraverse("RoshanPlayerAvatar").steamid = playerInfo.player_steamid;
			panel.FindChildTraverse("RoshanPlayerName").steamid = playerInfo.player_steamid;

			panel.SetHasClass("Disconnected", playerInfo.player_connection_state >= DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED);
		}
	}
	// OnRoshanKilled();
}
function HiddenORoshanScoreboard() {
	var RoshanScoreboard = $("#RoshanScoreboard");
	if (RoshanScoreboard != undefined && RoshanScoreboard != null) {
		RoshanScoreboard.SetHasClass("Hidden", true);
	}
}
var sLastWaveName = "";
function OnSceneWaveChanged(tData) {
	var sWaveName = tData.wave_name || "";
	$("#EndRoundWaveImage").FireEntityInput(sLastWaveName, "Disable", "1");
	$("#EndRoundWaveImage").FireEntityInput(tData.wave_name, "Enable", "1");
	sLastWaveName = sWaveName;
}

function PauseUpdate() {
	$.Schedule(Game.GetGameFrameTime(), PauseUpdate);
	$("#PausePanel").SetHasClass("Hidden", !Game.IsGamePaused());
}

function ShowStoreProp(sPropName) {
	var localPlayerID = Players.GetLocalPlayer();
	var localHero = Players.GetPlayerHeroEntityIndex(localPlayerID);
	var panel = $("#" + sPropName);
	$.DispatchEvent("DOTAShowAbilityTooltipForEntityIndex", panel, Abilities.GetAbilityName(panel.abilityEntIndex), localHero);
}
function HideStoreProp(sPropName) {
	var panel = $("#" + sPropName);
	$.DispatchEvent("DOTAHideAbilityTooltip", panel);
}
function ActivateStoreProp(sPropName) {
	var localPlayerID = Players.GetLocalPlayer();
	var localHero = Players.GetPlayerHeroEntityIndex(localPlayerID);
	var panel = $("#" + sPropName);

	if (!Entities.IsAlive(localHero)) {
		ErrorMessage("dota_hud_error_unit_dead");
		return;
	}

	if (panel.amount <= 0) {
		ErrorMessage("dota_hud_error_no_charges");
		return;
	}

	GameEvents.SendCustomGameEventToServer("UseProp", {
		prop_name: panel.propName,
	});
}

function UpdateStorePropsTimer() {
	$.Schedule(Game.GetGameFrameTime(), UpdateStorePropsTimer);
	UpdateStoreProps();
}

function UpdateStoreProps(playerAllItem) {
	if ($("#StoreProps") == undefined || $("#StoreProps") == null) return;

	var localPlayerID = Players.GetLocalPlayer();
	var localHero = Players.GetPlayerHeroEntityIndex(localPlayerID);

	if (playerAllItem == undefined || playerAllItem == null) {
		var table = CustomNetTables.GetTableValue("service", "player_all_items");
		if (table)
			playerAllItem = table[localPlayerID.toString()];
		else
			return;
	}

	if (localHero == -1) {
		return;
	}

	$("#StoreProps").SetHasClass("AltPressed", GameUI.IsAltDown());

	var builder_bomb = Entities.GetAbilityByName(localHero, "builder_bomb");
	if (builder_bomb != -1) {
		var iAmount = playerAllItem["item_1"] != undefined ? parseInt(playerAllItem["item_1"]) : 0;
		$("#StoreProp_Bomb").SetDialogVariableInt("amount", iAmount);
		$("#StoreProp_Bomb").SetDialogVariableInt("cooldown_seconds", Abilities.GetCooldownTimeRemaining(builder_bomb));

		$("#StoreProp_Bomb").abilityEntIndex = builder_bomb;
		$("#StoreProp_Bomb").amount = iAmount;
		$("#StoreProp_Bomb").propName = "item_1";
		$("#StoreProp_Bomb").SetHasClass("HasCharges", iAmount > 0);
		$("#StoreProp_Bomb").SetHasClass("IsCooldownReady", Abilities.IsCooldownReady(builder_bomb));

		$("#WarningProp_Bomb").SetDialogVariableInt("amount", iAmount);
		$("#WarningProp_Bomb").SetDialogVariableInt("cooldown_seconds", Abilities.GetCooldownTimeRemaining(builder_bomb));

		$("#WarningProp_Bomb").abilityEntIndex = builder_bomb;
		$("#WarningProp_Bomb").amount = iAmount;
		$("#WarningProp_Bomb").propName = "item_1";
		$("#WarningProp_Bomb").SetHasClass("HasCharges", iAmount > 0);
		$("#WarningProp_Bomb").SetHasClass("IsCooldownReady", Abilities.IsCooldownReady(builder_bomb));
	}

	var builder_masterkey = Entities.GetAbilityByName(localHero, "builder_masterkey");
	if (builder_masterkey != -1) {
		var iAmount = playerAllItem["item_2"] != undefined ? parseInt(playerAllItem["item_2"]) : 0;
		$("#StoreProp_MasterKey").SetDialogVariableInt("amount", iAmount);
		$("#StoreProp_MasterKey").SetDialogVariableInt("cooldown_seconds", Abilities.GetCooldownTimeRemaining(builder_masterkey));

		$("#StoreProp_MasterKey").abilityEntIndex = builder_masterkey;
		$("#StoreProp_MasterKey").amount = iAmount;
		$("#StoreProp_MasterKey").propName = "item_2";
		$("#StoreProp_MasterKey").SetHasClass("HasCharges", iAmount > 0);
		$("#StoreProp_MasterKey").SetHasClass("IsCooldownReady", Abilities.IsCooldownReady(builder_masterkey));
	}

	var builder_surge = Entities.GetAbilityByName(localHero, "builder_surge");
	if (builder_surge != -1) {
		var iAmount = playerAllItem["item_3"] != undefined ? parseInt(playerAllItem["item_3"]) : 0;
		$("#StoreProp_Surge").SetDialogVariableInt("amount", iAmount);
		$("#StoreProp_Surge").SetDialogVariableInt("cooldown_seconds", Abilities.GetCooldownTimeRemaining(builder_surge));

		$("#StoreProp_Surge").abilityEntIndex = builder_surge;
		$("#StoreProp_Surge").amount = iAmount;
		$("#StoreProp_Surge").propName = "item_3";
		$("#StoreProp_Surge").SetHasClass("HasCharges", iAmount > 0);
		$("#StoreProp_Surge").SetHasClass("IsCooldownReady", Abilities.IsCooldownReady(builder_surge));
	}

	var builder_rage = Entities.GetAbilityByName(localHero, "builder_rage");
	if (builder_rage != -1) {
		var iAmount = playerAllItem["item_4"] != undefined ? parseInt(playerAllItem["item_4"]) : 0;
		$("#StoreProp_Rage").SetDialogVariableInt("amount", iAmount);
		$("#StoreProp_Rage").SetDialogVariableInt("cooldown_seconds", Abilities.GetCooldownTimeRemaining(builder_rage));

		$("#StoreProp_Rage").abilityEntIndex = builder_rage;
		$("#StoreProp_Rage").amount = iAmount;
		$("#StoreProp_Rage").propName = "item_4";
		$("#StoreProp_Rage").SetHasClass("HasCharges", iAmount > 0);
		$("#StoreProp_Rage").SetHasClass("IsCooldownReady", Abilities.IsCooldownReady(builder_rage));
	}
}

function OnKillSelf() {
	OpenPopup("kill_self_confirm");
}

function FindDotaHudElement(id) {
	var rootUI = $.GetContextPanel();
	while (rootUI.id != "DotaHud" && rootUI.GetParent() != null) {
		rootUI = rootUI.GetParent();
	}

	return rootUI.FindChildTraverse(id);
}

function AdjacentGuider(i) {
	var index = $("#NewPlayerGuiderImgs").GetFocusIndex() + i;

	if (index < 0)
		index = $("#NewPlayerGuiderImgs").GetChildCount() - 1;
	else if (index >= $("#NewPlayerGuiderImgs").GetChildCount())
		index = 0;

	$("#NewPlayerGuiderImgs").SetSelectedChild($("#NewPlayerGuiderImgs").GetChild(index));

}

function ShowOtherPlayerParticle() {
	GameEvents.SendEventClientSide("custom_toggle_show_other_player_particle", {
		flag: true,
	});
}
function HideOtherPlayerParticle() {
	GameEvents.SendEventClientSide("custom_toggle_show_other_player_particle", {
		flag: false,
	});
}
function ShowResetQualificationAbility() {
	GameEvents.SendCustomGameEventToServer("CustomToggleShowConfirmResetQualificationAbility", {
		flag: true,
	});
}
function HideResetQualificationAbility() {
	GameEvents.SendCustomGameEventToServer("CustomToggleShowConfirmResetQualificationAbility", {
		flag: false,
	});
}

function OnShopButtonClicked() {
	$.DispatchEvent("DOTAHUDToggleShop");
}

function OnResetQualificationAbility(params) {
	OpenPopup("reset_qualification_ability", {
		bForce: params.bForce,
		iUnitIndex: params.iUnitIndex,
		iItemIndex: params.iItemIndex
	});
}

function OnSealedItemUpgradeSelect(params) {
	OpenPopup("sealed_item_upgrade_select", {
		name: params.name,
		index: params.index,
	});
}
GameUI.bUseScientificNotation = false;
function UseScientificNotation(bUse) {
	GameUI.bUseScientificNotation = bUse;
}

CustomUIConfig.bHiddenCardRoles = false;
function HiddenCardRoles(bUse) {
	$.Msg(CustomUIConfig.bHiddenCardRoles);
	CustomUIConfig.bHiddenCardRoles = bUse;
}

//抽卡界面隐藏和展开
function OnDealCardsTitleBtn() {
	$("#DealCardsContainer").SetHasClass("CloseDealCardsContainer", !$("#DealCardsContainer").BHasClass("CloseDealCardsContainer"));
}

function OnRoshanChallenge() {
	OpenPopup("roshan_level_select", {});
}

const HUD_SKIN_SPRING_FESTIVAL = false;
const HUD_SKIN_NORMAL = true; // 默认UI时写为true

(function () {
	//魂晶道具商店
	InitPropsShopItem();

	$.GetContextPanel().SwitchClass("map", Game.GetMapInfo().map_display_name);
	// 在圣诞节的时候设置为true
	// $.GetContextPanel().SetHasClass("ChristmasHud", false);

	$("#AbilitiesCustomUIContainer").RemoveAndDeleteChildren();
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, false);

	$.RegisterForUnhandledEvent("DOTAHUDAbilityLearnModeToggled", EventAbilityLearnModeToggled);

	var HUD = $.GetContextPanel().GetParent().GetParent().GetParent();
	var CustomUIRoot = HUD.FindChildTraverse("CustomUIRoot");

	let pNeutralCampPullTimes = HUD.FindChildTraverse("NeutralCampPullTimes");
	if (pNeutralCampPullTimes) {
		pNeutralCampPullTimes.style.opacity = "0";
	}
	// 自定义血量
	let pHealthLabel = $.GetContextPanel().FindChildTraverse("HealthLabel");
	if (pHealthLabel) {
		pHealthLabel.style.opacity = "0";
	}
	
	let pHealthRegenLabel = $.GetContextPanel().FindChildTraverse("HealthRegenLabel");
	if (pHealthRegenLabel) {
		pHealthRegenLabel.style.opacity = "0";
	}

	// 全局设置ticket、star
	function SetGlobalNetVar(tableName, tableKeyName, table) {
		if (tableKeyName == "player_data") {
			var localPlayerID = Players.GetLocalPlayer();
			var localPlayerData = table[localPlayerID.toString()];
			if (!IsNull(table) && !IsNull(localPlayerData)) {
				GameUI.global_star_num = localPlayerData.star_num || 0;
				GameUI.global_ticket_num = localPlayerData.ticket_num || 0;
				GameUI.global_fragment_num = localPlayerData.fragment || 0;
				CustomUIRoot.SetDialogVariableInt("global_star_num", localPlayerData.star_num || 0);
				CustomUIRoot.SetDialogVariableInt("global_ticket_num", localPlayerData.ticket_num || 0);
				CustomUIRoot.SetDialogVariableInt("global_fragment_num", localPlayerData.fragment || 0);
			}
		}
	}
	CustomUIConfig.SubscribeNetTableListener("service", SetGlobalNetVar);
	SetGlobalNetVar("service", "player_data", CustomNetTables.GetTableValue("service", "player_data"));

	$("#StoreProp_Bomb").FindChildTraverse("StorePropImage").SetImage("file://{images}/custom_game/hud/skin/bomb.png");
	$("#StoreProp_Surge").FindChildTraverse("StorePropImage").SetImage("file://{images}/custom_game/hud/skin/surge.png");
	$("#StoreProp_Rage").FindChildTraverse("StorePropImage").SetImage("file://{images}/custom_game/hud/skin/rage.png");

	BuildingLimitsPanel = $("#BuildingLimits");

	$("#BuildingsRoundDamage").AddClass("show");

	$("#AghsStatusContainer").BLoadLayout("file://{resources}/layout/custom_game/elements/aghs_status_display/aghs_status_display.xml", false, false);

	// -------------------------

	$("#lower_hud").SetHasClass("HasSecondaryAbilities", true);
	$("#StoreProp_Bomb").SetDialogVariableInt("amount", 0);
	$("#StoreProp_MasterKey").SetDialogVariableInt("amount", 0);
	$("#StoreProp_Surge").SetDialogVariableInt("amount", 0);
	$("#StoreProp_Rage").SetDialogVariableInt("amount", 0);
	$("#StoreProp_Bomb").SetHasClass("HasCharges", false);
	$("#StoreProp_MasterKey").SetHasClass("HasCharges", false);
	$("#StoreProp_Surge").SetHasClass("HasCharges", false);
	$("#StoreProp_Rage").SetHasClass("HasCharges", false);
	$("#StoreProp_Bomb").SetHasClass("Available", true);
	$("#StoreProp_MasterKey").SetHasClass("Available", true);
	$("#StoreProp_Surge").SetHasClass("Available", true);
	$("#StoreProp_Rage").SetHasClass("Available", true);

	let pSliderLabel = $("#CameraDistanceSlider").FindChildTraverse("Title");
	if (pSliderLabel) {
		pSliderLabel.style.color = "#f3e8c2";
	}
	pSliderLabel = $("#CameraDistanceSlider").FindChildTraverse("Value");
	if (pSliderLabel) {
		pSliderLabel.style.color = "#f3e8c2";
	}
	let pSliderThumb = $("#CameraDistanceSlider").FindChildTraverse("SliderThumb");
	if (pSliderThumb) {
		pSliderThumb.style.width = "12px";
		pSliderThumb.style.backgroundColor = "#007e70";
		pSliderThumb.style.border = "1px solid #151d1b";
	}
	let pSliderTrackProgress = $("#CameraDistanceSlider").FindChildTraverse("SliderTrackProgress");
	if (pSliderTrackProgress) {
		pSliderTrackProgress.style.backgroundColor = "#78c5b0";
	}

	Update();
	UpdateVentureChallenge();

	CustomUIConfig.SubscribeNetTableListener("player_data", UpdatePlayerDataNetTable);

	UpdatePlayerDataNetTable("player_data", "player_datas", CustomNetTables.GetTableValue("player_data", "player_datas"));
	// UpdatePlayerDataNetTable("player_data", "venture_challenge_selection", CustomNetTables.GetTableValue("player_data", "venture_challenge_selection"));

	CustomUIConfig.SubscribeNetTableListener("common", UpdateCommonNetTable);

	UpdateCommonNetTable("common", "round_info", CustomNetTables.GetTableValue("common", "round_info"));
	UpdateCommonNetTable("common", "warning_time", CustomNetTables.GetTableValue("common", "warning_time"));
	UpdateCommonNetTable("common", "player_card_selection_list", CustomNetTables.GetTableValue("common", "player_card_selection_list"));
	UpdateCommonNetTable("common", "player_buildings", CustomNetTables.GetTableValue("common", "player_buildings"));
	UpdateCommonNetTable("common", "player_crystal_shop", CustomNetTables.GetTableValue("common", "player_crystal_shop"));
	UpdateCommonNetTable("common", "player_crystal_cards", CustomNetTables.GetTableValue("common", "player_crystal_cards"));
	UpdateCommonNetTable("common", "crystal_shop", CustomNetTables.GetTableValue("common", "crystal_shop"));
	UpdateCommonNetTable("common", "game_mode_info", CustomNetTables.GetTableValue("common", "game_mode_info"));
	UpdateCommonNetTable("common", "deal_cards", CustomNetTables.GetTableValue("common", "deal_cards"));
	UpdateCommonNetTable("common", "environment", CustomNetTables.GetTableValue("common", "environment"));

	CustomUIConfig.SubscribeNetTableListener("service", UpdateServiceNetTable);

	UpdateServiceNetTable("service", "player_data", CustomNetTables.GetTableValue("service", "player_data"));
	UpdateServiceNetTable("service", "player_all_items", CustomNetTables.GetTableValue("service", "player_all_items"));

	// var colorInt = Players.GetPlayerColor(Players.GetLocalPlayer());
	// $.Msg(intToARGB(colorInt));

	GameEvents.Subscribe("show_drawing", OnShowDrawing);
	GameEvents.Subscribe("show_round_damage", OnShowRoundDamage);
	GameEvents.Subscribe("scene_wave_changed", OnSceneWaveChanged);
	GameEvents.Subscribe("all_roshan_killed", OnAllRoshanKilled);
	GameEvents.Subscribe("roshan_killed", OnRoshanKilled);
	GameEvents.Subscribe("reset_qualification_ability", OnResetQualificationAbility);
	GameEvents.Subscribe("sealed_item_upgrade_select", OnSealedItemUpgradeSelect);

	// 新增肉山难度选择
	GameEvents.Subscribe("custom_roshan_select", OnRoshanChallenge);
	// $("#QueryUnitHeroPortrait").SetUnit("t29", "");
	// Ban卡提示
	if (GameUI.BanCardCheck && GameUI.BanCardCheck()) {
		$('#HandBookButton').AddClass('Activated');
	}

	PauseUpdate();

	UpdateStorePropsTimer();

	// CreateRoshanScoreboard();

	if (tSettings.is_in_tools_mode == 0) {
		$.GetContextPanel().SetHasClass("isLocalHost", tSettings.is_local_host == 1);
		$.GetContextPanel().SetHasClass("isCheatMode", tSettings.is_cheat_mode == 1);
	}

	// 在春节的时候设置为true
	$.GetContextPanel().SetHasClass("SpringFestivalHud", HUD_SKIN_SPRING_FESTIVAL);
	FindDotaHudElement("Hud").SetHasClass("SpringFestivalHud", HUD_SKIN_SPRING_FESTIVAL);

	let RoshanRankCourierImage = $("#RoshanRankCourierImage");
	if (RoshanRankCourierImage) {
		LoadStoreItemImage(RoshanRankCourierImage);
		RoshanRankCourierImage.SetStoreItem("courier_90");
	}

	let custom_update_fps = () => {
		GameEvents.SendEventClientSide("custom_update_fps", {
			fps: parseInt((1 / Game.GetGameFrameTime()).toFixed(0)),
		});
		$.Schedule(1, custom_update_fps);
	};
	$.Schedule(1, custom_update_fps);

	$.RegisterForUnhandledEvent("DOTAHUDShopOpened", (a, b) => {
		$.GetContextPanel().AddClass("ShopOpen");
	});
	$.RegisterForUnhandledEvent("DOTAHUDShopClosed", () => {
		$.GetContextPanel().RemoveClass("ShopOpen");
	});

	// 全局变量，是否正在试用
	CustomUIConfig.bPreview = false;
	const sPauseCommand = "custom_pause" + Date.now();
	Game.AddCommand(sPauseCommand, () => {
		GameEvents.SendCustomGameEventToServer("CustomTogglePause", {});
	}, "desc", 0);
	Game.CreateCustomKeyBind(Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_PAUSE), sPauseCommand);
})();
