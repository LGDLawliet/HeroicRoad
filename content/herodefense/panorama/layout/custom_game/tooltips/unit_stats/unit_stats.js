// let tSettings = CustomNetTables.GetTableValue("common", "settings");
// CustomUIConfig.SubscribeNetTableListener("common", () => {
// 	tSettings = CustomNetTables.GetTableValue("common", "settings");
// });


let pSelf = $.GetContextPanel()

function setupTooltip() {
	let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();
	// $.Msg(iLocalPortraitUnit);
	// let bIsBuilding = IsBuilding(iLocalPortraitUnit)

	// pSelf.SetHasClass("Hero", Entities.HasHeroAttribute(iLocalPortraitUnit));

	// pSelf.FindChildTraverse("AttackContainer").SetHasClass("Hidden", !bIsBuilding);
	// pSelf.FindChildTraverse("DefenseContainer").SetHasClass("Hidden", bIsBuilding);
	// pSelf.FindChildTraverse("OutgoingContainer").SetHasClass("Hidden", !bIsBuilding);
	// pSelf.FindChildTraverse("IncomingContainer").SetHasClass("Hidden", bIsBuilding);

	// let tData = CustomUIConfig.UnitsKv[Entities.GetUnitName(iLocalPortraitUnit)] || CustomUIConfig.HeroesKv[Entities.GetUnitName(iLocalPortraitUnit)];
	// let fExtraBaseHealthRegen = 0;
	// let fExtraBaseManaRegen = 0;

	// if (Entities.IsHero(iLocalPortraitUnit)) {
	// 	var iPrimaryAttribute = Entities.GetPrimaryAttribute(iLocalPortraitUnit);

	// 	pSelf.FindChildTraverse("StrengthContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_STRENGTH);
	// 	pSelf.FindChildTraverse("AgilityContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_AGILITY);
	// 	pSelf.FindChildTraverse("IntellectContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_INTELLECT);

	// 	let fStrengthGain = (tData && tData.AttributeStrengthGain) ? Float(tData.AttributeStrengthGain) : 0;
	// 	let fAgilityGain = (tData && tData.AttributeAgilityGain) ? Float(tData.AttributeAgilityGain) : 0;
	// 	let fIntellectGain = (tData && tData.AttributeIntelligenceGain) ? Float(tData.AttributeIntelligenceGain) : 0;
	// 	pSelf.SetDialogVariable("strength_per_level", fStrengthGain)
	// 	pSelf.SetDialogVariable("agility_per_level", fAgilityGain)
	// 	pSelf.SetDialogVariable("intelligence_per_level", fIntellectGain)

	// 	// 力量
	// 	{
	// 		let pStrength = pSelf.FindChildTraverse("StrengthContainer");

	// 		let iStrength = Entities.GetStrength(iLocalPortraitUnit);
	// 		let iBaseStrength = Entities.GetBaseStrength(iLocalPortraitUnit);
	// 		let iBonusStrength = iStrength - iBaseStrength;
	// 		let sSign = iBonusStrength == 0 ? "" : (iBonusStrength > 0 ? "+" : "-");
	// 		let sBonusStrength;

	// 		if (sSign == "") {
	// 			sBonusStrength = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			sBonusStrength = sSign + iBonusStrength.toFixed(0);
	// 		}
	// 		else {
	// 			sBonusStrength = iBonusStrength.toFixed(0);
	// 		}

	// 		pStrength.SetDialogVariableInt("base_strength", iBaseStrength);
	// 		pStrength.SetDialogVariable("bonus_strength", sBonusStrength);
	// 		pStrength.SetDialogVariable("strength_hp", iStrength * tSettings.attribute_strength_hp);
	// 		pStrength.SetDialogVariable("strength_hp_regen", Float(iStrength * Float(tSettings.attribute_strength_hp_regen)));
	// 		pStrength.SetDialogVariable("primary_attribute_damage", Math.floor(Float(iStrength * Float(tSettings.attribute_primary_attack_damage))));
	// 		var unitName = Entities.GetUnitName(iLocalPortraitUnit);
	// 		unitName = SkinNameToUnitName(unitName) || unitName;
	// 		pStrength.SetDialogVariable("primary_attribute_total", Round(iStrength * Float(GetCardRarity(unitName) == "ssr" ? tSettings.attribute_primary_total_damage_ssr : tSettings.attribute_primary_total_damage), 2));
	// 		pStrength.SetHasClass("NegativeValue", sSign == "-");
	// 		pStrength.SetHasClass("NoBonus", sSign == "");
	// 		fExtraBaseHealthRegen += Float(iStrength * Float(tSettings.attribute_strength_hp_regen));
	// 	}

	// 	// 敏捷
	// 	{
	// 		let pAgility = pSelf.FindChildTraverse("AgilityContainer");

	// 		let iAgility = Entities.GetAgility(iLocalPortraitUnit);
	// 		let iBaseAgility = Entities.GetBaseAgility(iLocalPortraitUnit);
	// 		let iBonusAgility = iAgility - iBaseAgility;
	// 		let sSign = iBonusAgility == 0 ? "" : (iBonusAgility > 0 ? "+" : "-");
	// 		let sBonusAgility;

	// 		if (sSign == "") {
	// 			sBonusAgility = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			sBonusAgility = sSign + iBonusAgility.toFixed(0);
	// 		}
	// 		else {
	// 			sBonusAgility = iBonusAgility.toFixed(0);
	// 		}

	// 		var fAgiCooldownReductionPercent = (1 - Math.pow(1 - Float(tSettings.attribute_agility_cooldown_reduction_percent) * 0.01, iAgility)) * Float(tSettings.attribute_agility_cooldown_reduction_max);

	// 		pAgility.SetDialogVariableInt("base_agility", iBaseAgility);
	// 		pAgility.SetDialogVariable("bonus_agility", sBonusAgility);
	// 		pAgility.SetDialogVariable("agility_attack_speed", Float(iAgility * Float(tSettings.attribute_agility_attack_speed)));
	// 		pAgility.SetDialogVariable("agility_cooldown_reduction", Round(fAgiCooldownReductionPercent, 1));
	// 		pAgility.SetDialogVariable("primary_attribute_damage", Math.floor(Float(iAgility * tSettings.attribute_primary_attack_damage)));
	// 		var unitName = Entities.GetUnitName(iLocalPortraitUnit);
	// 		unitName = SkinNameToUnitName(unitName) || unitName;
	// 		pAgility.SetDialogVariable("primary_attribute_total", Round(iAgility * Float(GetCardRarity(unitName) == "ssr" ? tSettings.attribute_primary_total_damage_ssr : tSettings.attribute_primary_total_damage), 2));
	// 		pAgility.SetHasClass("NegativeValue", sSign == "-");
	// 		pAgility.SetHasClass("NoBonus", sSign == "");
	// 	}

	// 	// 智力
	// 	{
	// 		let pIntellect = pSelf.FindChildTraverse("IntellectContainer");

	// 		let iIntellect = Entities.GetIntellect(iLocalPortraitUnit);
	// 		let iBaseIntellect = Entities.GetBaseIntellect(iLocalPortraitUnit);
	// 		let iBonusIntellect = iIntellect - iBaseIntellect;
	// 		let sSign = iBonusIntellect == 0 ? "" : (iBonusIntellect > 0 ? "+" : "-");
	// 		let sBonusIntellect;

	// 		if (sSign == "") {
	// 			sBonusIntellect = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			sBonusIntellect = sSign + iBonusIntellect.toFixed(0);
	// 		}
	// 		else {
	// 			sBonusIntellect = iBonusIntellect.toFixed(0);
	// 		}

	// 		pIntellect.SetDialogVariableInt("base_intellect", iBaseIntellect);
	// 		pIntellect.SetDialogVariable("bonus_intellect", sBonusIntellect);
	// 		pIntellect.SetDialogVariable("intelligence_mana", Float(iIntellect * Float(tSettings.attribute_intelligence_mana)));
	// 		pIntellect.SetDialogVariable("intelligence_mana_regen", Float(iIntellect * Float(tSettings.attribute_intelligence_mana_regen)));
	// 		pIntellect.SetDialogVariable("primary_attribute_damage", Math.floor(Float(iIntellect * Float(tSettings.attribute_primary_attack_damage))));
	// 		var unitName = Entities.GetUnitName(iLocalPortraitUnit);
	// 		unitName = SkinNameToUnitName(unitName) || unitName;
	// 		pIntellect.SetDialogVariable("primary_attribute_total", Round(iIntellect * Float(GetCardRarity(unitName) == "ssr" ? tSettings.attribute_primary_total_damage_ssr : tSettings.attribute_primary_total_damage), 2));
	// 		pIntellect.SetHasClass("NegativeValue", sSign == "-");
	// 		pIntellect.SetHasClass("NoBonus", sSign == "");
	// 		fExtraBaseManaRegen += Float(iIntellect * Float(tSettings.attribute_intelligence_mana_regen));
	// 	}
	// }

	// 攻击属性
	// {
	// 	// 攻击速度
	// 	{
	// 		let pAttackSpeed = pSelf.FindChildTraverse("AttackSpeedRow");

	// 		let fAttackSpeed = Entities.GetAttackSpeedPercent(iLocalPortraitUnit);
	// 		let fSecondsPerAttack = Entities.GetSecondsPerAttack(iLocalPortraitUnit);

	// 		pAttackSpeed.SetDialogVariableInt("attack_speed", fAttackSpeed);
	// 		pAttackSpeed.SetDialogVariable("seconds_per_attack", Round(fSecondsPerAttack, 2));
	// 	}
	// 	// 攻击力
	// 	{
	// 		let pDamage = pSelf.FindChildTraverse("DamageRow");

	// 		// let fBonusDamage = Entities.GetDamageBonus(iLocalPortraitUnit);
	// 		// let fBonusDamage = Entities.GetUnitData(iLocalPortraitUnit, "EOMGetGreenAttackDamage");
	// 		let fBonusDamage = Entities.GetGreenAttackDamage(iLocalPortraitUnit);
	// 		// let fMinDamage = Entities.GetDamageMin(iLocalPortraitUnit);
	// 		// let fMaxDamage = Entities.GetDamageMax(iLocalPortraitUnit);
	// 		// let fBaseDamage = (fMinDamage + fMaxDamage) / 2;

	// 		let fBaseDamage = Entities.GetWhiteAttackDamage(iLocalPortraitUnit);
			
	
	// 		// let fBaseDamage =  Entities.GetWhiteAttackDamage(iLocalPortraitUnit);
	// 		let sSign = fBonusDamage == 0 ? "" : (fBonusDamage > 0 ? "+" : "-");
	// 		let sBonusDamage;

	// 		if (sSign == "") {
	// 			sBonusDamage = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			// sBonusDamage = sSign + fBonusDamage.toFixed(0);
	// 			sBonusDamage = sSign + FormatNumber(fBonusDamage, 0);
	// 		}
	// 		else {
	// 			sBonusDamage =  FormatNumber(fBonusDamage, 0);
	// 		}

	// 		// pDamage.SetDialogVariableInt("base_damage_min", fMinDamage);
	// 		// pDamage.SetDialogVariableInt("base_damage_max", fMaxDamage);
	// 		// $.Msg(fBaseDamage);
	// 		fBaseDamage = FormatNumber(fBaseDamage, 0);
	// 		// pDamage.SetDialogVariableInt("base_damage", FormatNumber(fBaseDamage, 0));
	// 		pDamage.SetDialogVariable("base_damage", fBaseDamage);


	// 		pDamage.SetDialogVariable("bonus_damage", sBonusDamage);
	// 		pDamage.SetHasClass("NegativeValue", sSign == "-");
	// 		pDamage.SetHasClass("NoBonus", sSign == "");
	// 	}
	// 	// 攻击距离
	// 	{
	// 		let pAttackRange = pSelf.FindChildTraverse("AttackRangeRow");

	// 		let fAttackRange = Entities.GetAttackRange(iLocalPortraitUnit);
	// 		let fBaseAttackRange = (tData && tData.AttackRange) ? Float(tData.AttackRange) : 0;
	// 		let fBonusAttackRange = fAttackRange - fBaseAttackRange;
	// 		let sSign = fBonusAttackRange == 0 ? "" : (fBonusAttackRange > 0 ? "+" : "-");
	// 		let sBonusAttackRange;

	// 		if (sSign == "") {
	// 			sBonusAttackRange = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			sBonusAttackRange = sSign + fBonusAttackRange.toFixed(0);
	// 		}
	// 		else {
	// 			sBonusAttackRange = fBonusAttackRange.toFixed(0);
	// 		}

	// 		pAttackRange.SetDialogVariableInt("base_attack_range", fBaseAttackRange);
	// 		pAttackRange.SetDialogVariable("bonus_attack_range", sBonusAttackRange);
	// 		pAttackRange.SetHasClass("NegativeValue", sSign == "-");
	// 		pAttackRange.SetHasClass("NoBonus", sSign == "");
	// 	}
	// 	// 移动速度
	// 	{
	// 		let pMoveSpeed = pSelf.FindChildTraverse("MoveSpeedRow");

	// 		let fBaseMoveSpeed = Entities.GetBaseMoveSpeed(iLocalPortraitUnit);
	// 		let fBonusMoveSpeed = Entities.GetMoveSpeed(iLocalPortraitUnit) - fBaseMoveSpeed;
	// 		let sSign = fBonusMoveSpeed == 0 ? "" : (fBonusMoveSpeed > 0 ? "+" : "-");
	// 		let sBonusMoveSpeed;

	// 		if (sSign == "") {
	// 			sBonusMoveSpeed = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			sBonusMoveSpeed = sSign + fBonusMoveSpeed.toFixed(0);
	// 		}
	// 		else {
	// 			sBonusMoveSpeed = fBonusMoveSpeed.toFixed(0);
	// 		}

	// 		pMoveSpeed.SetDialogVariable("base_move_speed", fBaseMoveSpeed.toFixed(0));
	// 		pMoveSpeed.SetDialogVariable("bonus_move_speed", sBonusMoveSpeed);
	// 		pMoveSpeed.SetHasClass("NegativeValue", sSign == "-");
	// 		pMoveSpeed.SetHasClass("NoBonus", sSign == "");
	// 	}
	// 	// 技能伤害
	// 	{
	// 		let pSpellAmplify = pSelf.FindChildTraverse("SpellAmpRow");

	// 		let fSpellAmplify = Entities.GetSpellAmplify(iLocalPortraitUnit);
	// 		// let fBaseSpellAmplify = Entities.GetBaseSpellAmplify(iLocalPortraitUnit);
	// 		// let fBonusSpellAmplify = fSpellAmplify - fBaseSpellAmplify;
	// 		// let sSign = fBonusSpellAmplify == 0 ? "" : (fBonusSpellAmplify > 0 ? "+" : "-");
	// 		// let sBonusSpellAmplify;

	// 		// if (sSign == "") {
	// 		// 	sBonusSpellAmplify = "";
	// 		// }
	// 		// else if (sSign == "+") {
	// 		// 	sBonusSpellAmplify = sSign + Round(fBonusSpellAmplify, 1);
	// 		// }
	// 		// else {
	// 		// 	sBonusSpellAmplify = Round(fBonusSpellAmplify, 1);
	// 		// }

	// 		pSpellAmplify.SetDialogVariable("base_spell_amplify", Round(fSpellAmplify, 1));
	// 		// pSpellAmplify.SetDialogVariable("bonus_spell_amplify", sBonusSpellAmplify);
	// 		// pSpellAmplify.SetHasClass("NegativeValue", sSign == "-");
	// 		// pSpellAmplify.SetHasClass("NoBonus", sSign == "");
	// 	}
	// 	// 冷却减少
	// 	{
	// 		let pCooldownReduction = pSelf.FindChildTraverse("CooldownReductionRow");

	// 		let fCooldownReduction = Entities.GetCooldownReduction(iLocalPortraitUnit);

	// 		pCooldownReduction.SetDialogVariable("cooldown_reduction", Round(fCooldownReduction, 1));
	// 	}
	// 	// 魔法恢复
	// 	{
	// 		let pManaRegen = pSelf.FindChildTraverse("ManaRegenRow");

	// 		let fBaseManaRegen = (tData && tData.CustomStatusManaRegen) ? Float(tData.CustomStatusManaRegen) : 0;
	// 		let fManaRegen = Entities.GetManaRegen(iLocalPortraitUnit) + fBaseManaRegen;
	// 		fBaseManaRegen += fExtraBaseManaRegen;
	// 		let fBonusManaRegen = fManaRegen - fBaseManaRegen;
	// 		let sSign = fBonusManaRegen == 0 ? "" : (fBonusManaRegen > 0 ? "+" : "-");
	// 		let sBonusManaRegen;


			
	// 		if (sSign == "") {
	// 			sBonusManaRegen = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			// sBonusManaRegen = FormatNumber(fBonusManaRegen, 0);
	// 			sBonusManaRegen = sSign + FormatNumber(fBonusManaRegen, 0);
	// 		}
	// 		else {
	// 			// sBonusManaRegen = Round(fBonusManaRegen, 1);
	// 			sBonusManaRegen = FormatNumber(fBonusManaRegen, 0);
	// 		}
	// 		fBaseManaRegen = FormatNumber(fBaseManaRegen, 0);

	// 		pManaRegen.SetDialogVariable("base_mana_regen", fBaseManaRegen);
	// 		pManaRegen.SetDialogVariable("bonus_mana_regen", sBonusManaRegen);
	// 		pManaRegen.SetHasClass("NegativeValue", sSign == "-");
	// 		pManaRegen.SetHasClass("NoBonus", sSign == "");
	// 	}
	// }
	// 防御属性
	// {
	// 	// 物理防御
	// 	{
	// 		let pPhysicalArmor = pSelf.FindChildTraverse("PhysicalArmorRow");

	// 		let fPhysicalArmor = Entities.GetPhysicalArmor(iLocalPortraitUnit);
	// 		let fBasePhysicalArmor = Entities.GetBasePhysicalArmor(iLocalPortraitUnit);
	// 		let fBonusPhysicalArmor = fPhysicalArmor - fBasePhysicalArmor;
	// 		let fPhysicalArmorReduction = (() => {
	// 			let iSign = fPhysicalArmor >= 0 ? 1 : -1
	// 			return iSign * tSettings.physical_armor_factor * Math.abs(fPhysicalArmor) / (1 + tSettings.physical_armor_factor * Math.abs(fPhysicalArmor))
	// 		})();
	// 		let sSign = fBonusPhysicalArmor == 0 ? "" : (fBonusPhysicalArmor > 0 ? "+" : "-");
	// 		let sBonusPhysicalArmor;

	// 		if (sSign == "") {
	// 			sBonusPhysicalArmor = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			sBonusPhysicalArmor = sSign + Round(fBonusPhysicalArmor, 1);
	// 		}
	// 		else {
	// 			sBonusPhysicalArmor = Round(fBonusPhysicalArmor, 1);
	// 		}

	// 		pPhysicalArmor.SetDialogVariable("base_physical_armor", Round(fBasePhysicalArmor, 1));
	// 		pPhysicalArmor.SetDialogVariable("bonus_physical_armor", sBonusPhysicalArmor);
	// 		pPhysicalArmor.SetDialogVariable("physical_resistance", Round(fPhysicalArmorReduction * 100, 1));
	// 		pPhysicalArmor.SetHasClass("NegativeValue", sSign == "-");
	// 		pPhysicalArmor.SetHasClass("NoBonus", sSign == "");
	// 	}
	// 	// 魔法防御
	// 	{
	// 		let pMagicalArmor = pSelf.FindChildTraverse("MagicalArmorRow");

	// 		let fMagicalArmor = Entities.GetMagicalArmor(iLocalPortraitUnit);
	// 		let fBaseMagicalArmor = Entities.GetBaseMagicalArmor(iLocalPortraitUnit);
	// 		let fBonusMagicalArmor = fMagicalArmor - fBaseMagicalArmor;
	// 		let fMagicalArmorReduction = (() => {
	// 			let iSign = fMagicalArmor >= 0 ? 1 : -1
	// 			return iSign * tSettings.magical_armor_factor * Math.abs(fMagicalArmor) / (1 + tSettings.magical_armor_factor * Math.abs(fMagicalArmor))
	// 		})();
	// 		let sSign = fBonusMagicalArmor == 0 ? "" : (fBonusMagicalArmor > 0 ? "+" : "-");
	// 		let sBonusMagicalArmor;

	// 		if (sSign == "") {
	// 			sBonusMagicalArmor = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			sBonusMagicalArmor = sSign + Round(fBonusMagicalArmor, 1);
	// 		}
	// 		else {
	// 			sBonusMagicalArmor = Round(fBonusMagicalArmor, 1);
	// 		}

	// 		pMagicalArmor.SetDialogVariable("base_magical_armor", Round(fBaseMagicalArmor, 1));
	// 		pMagicalArmor.SetDialogVariable("bonus_magical_armor", sBonusMagicalArmor);
	// 		pMagicalArmor.SetDialogVariable("magical_resistance", Round(fMagicalArmorReduction * 100, 1));
	// 		pMagicalArmor.SetHasClass("NegativeValue", sSign == "-");
	// 		pMagicalArmor.SetHasClass("NoBonus", sSign == "");
	// 	}
	// 	// 状态抗性
	// 	{
	// 		let pStatusResistance = pSelf.FindChildTraverse("DefenseContainer").FindChildTraverse("StatusResistRow");

	// 		let fStatusResistance = Entities.GetStatusResistance(iLocalPortraitUnit);

	// 		pStatusResistance.SetDialogVariable("status_resistance", Round(fStatusResistance, 1));
	// 	}
	// 	// 闪避
	// 	{
	// 		let pEvasion = pSelf.FindChildTraverse("EvasionRow");

	// 		let fEvasion = Entities.GetEvasion(iLocalPortraitUnit);

	// 		pEvasion.SetDialogVariable("evasion", fEvasion.toFixed(0));
	// 	}
	// 	// 生命恢复
	// 	{
	// 		let pHealthRegen = pSelf.FindChildTraverse("HealthRegenRow");

	// 		let fBaseHealthRegen = (tData && tData.CustomStatusHealthRegen) ? Float(tData.CustomStatusHealthRegen) : 0;
	// 		let fHealthRegen = Entities.GetHealthRegen(iLocalPortraitUnit) + fBaseHealthRegen;
	// 		fBaseHealthRegen += fExtraBaseHealthRegen;
	// 		let fBonusHealthRegen = fHealthRegen - fBaseHealthRegen;
	// 		let sSign = fBonusHealthRegen == 0 ? "" : (fBonusHealthRegen > 0 ? "+" : "-");
	// 		let sBonusHealthRegen;

	// 		if (sSign == "") {
	// 			sBonusHealthRegen = "";
	// 		}
	// 		else if (sSign == "+") {
	// 			sBonusHealthRegen = sSign + Round(fBonusHealthRegen, 1);
	// 		}
	// 		else {
	// 			sBonusHealthRegen = Round(fBonusHealthRegen, 1);
	// 		}

	// 		pHealthRegen.SetDialogVariable("base_health_regen", Round(fBaseHealthRegen, 1));
	// 		pHealthRegen.SetDialogVariable("bonus_health_regen", sBonusHealthRegen);
	// 		pHealthRegen.SetHasClass("NegativeValue", sSign == "-");
	// 		pHealthRegen.SetHasClass("NoBonus", sSign == "");
	// 	}
	// }
	// 其他
	// {
	// 	// 状态抗性
	// 	{
	// 		let pStatusResistance = pSelf.FindChildTraverse("OutgoingContainer").FindChildTraverse("StatusResistRow");

	// 		let fStatusResistance = Entities.GetStatusResistance(iLocalPortraitUnit);

	// 		pStatusResistance.SetDialogVariable("status_resistance", Round(fStatusResistance, 1));
	// 	}
	// 	// 额外全伤害
	// 	{
	// 		let pTotalDamagePercent = pSelf.FindChildTraverse("TotalDamagePercentRow");

	// 		let fTotalDamagePercent = Entities.GetOutgoingDamagePercent(iLocalPortraitUnit);

	// 		pTotalDamagePercent.SetDialogVariable("total_damage_percent", Round(fTotalDamagePercent, 2));
	// 	}
	// 	{
	// 		let target = pSelf.FindChildTraverse("TotalDamagePercentFinalRow");

	// 		let value = Entities.GetOutgoingDamagePercentFinal(iLocalPortraitUnit);

	// 		target.SetDialogVariable("value", Round(value, 2));
	// 	}


		


	// 	// 额外物理伤害
	// 	{
	// 		let pPhysicalDamagePercent = pSelf.FindChildTraverse("PhysicalDamagePercentRow");

	// 		let fPhysicalDamagePercent = Entities.GetOutgoingPhysicalDamagePercent(iLocalPortraitUnit);

	// 		pPhysicalDamagePercent.SetDialogVariable("physical_damage_percent", Round(fPhysicalDamagePercent, 2));
	// 	}
	// 	// 额外魔法伤害
	// 	{
	// 		let pMagicalDamagePercent = pSelf.FindChildTraverse("MagicalDamagePercentRow");

	// 		let fMagicalDamagePercent = Entities.GetOutgoingMagicalDamagePercent(iLocalPortraitUnit);

	// 		pMagicalDamagePercent.SetDialogVariable("magical_damage_percent", Round(fMagicalDamagePercent, 2));
	// 	}
	// 	// 额外纯粹伤害
	// 	{
	// 		let pPureDamagePercent = pSelf.FindChildTraverse("PureDamagePercentRow");

	// 		let fPureDamagePercent = Entities.GetOutgoingPureDamagePercent(iLocalPortraitUnit);

	// 		pPureDamagePercent.SetDialogVariable("pure_damage_percent", Round(fPureDamagePercent, 2));
	// 	}

	// 	// 最终物理
	// 	{
	// 		let target = pSelf.FindChildTraverse("PhysiicalDamagePercenFinaltRow");

	// 		let value = Entities.GetOutgoingPhyscalDamagePercentFinal(iLocalPortraitUnit);

	// 		target.SetDialogVariable("value", Round(value, 2));
	// 	}

	// 	// 最终魔法伤害
	// 	{
	// 		let target = pSelf.FindChildTraverse("MagicalDamagePercenFinaltRow");

	// 		let value = Entities.GetOutgoingMagicalDamagePercentFinal(iLocalPortraitUnit);

	// 		target.SetDialogVariable("value", Round(value, 2));
	// 	}


	// 	// 最终纯粹伤害
	// 	{
	// 		let target = pSelf.FindChildTraverse("PureDamagePercenFinaltRow");

	// 		let value = Entities.GetOutgoingPureDamagePercentFinal(iLocalPortraitUnit);

	// 		target.SetDialogVariable("value", Round(value, 2));
	// 	}
		
		




		
	// 	// 物理防御穿透
	// 	{
	// 		let pIgnorePhysicalArmorPercent = pSelf.FindChildTraverse("IgnorePhysicalArmorPercentRow");

	// 		let fIgnorePhysicalArmorPercent = Entities.GetIgnorePhysicalArmorPercentage(iLocalPortraitUnit);

	// 		pIgnorePhysicalArmorPercent.SetDialogVariable("ignore_physical_armor_percent", Round(fIgnorePhysicalArmorPercent, 2));
	// 	}
	// 	// 魔法防御穿透
	// 	{
	// 		let pIgnoreMagicalArmorPercent = pSelf.FindChildTraverse("IgnoreMagicalArmorPercentRow");

	// 		let fIgnoreMagicalArmorPercent = Entities.GetIgnoreMagicalArmorPercentage(iLocalPortraitUnit);

	// 		pIgnoreMagicalArmorPercent.SetDialogVariable("ignore_magical_armor_percent", Round(fIgnoreMagicalArmorPercent, 2));
	// 	}
	// }
}