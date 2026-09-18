

let pSelf = $.GetContextPanel()

function setupTooltip() {
	let nEntityIndex = Players.GetLocalPlayerPortraitUnit();
	// let bIsBuilding = IsBuilding(nEntityIndex)

	// pSelf.SetHasClass("Hero", Entities.HasHeroAttribute(nEntityIndex));

	// pSelf.FindChildTraverse("AdvancedAttribute1").SetHasClass("Hidden", !bIsBuilding);
	// pSelf.FindChildTraverse("AdvancedAttribute2").SetHasClass("Hidden", bIsBuilding);
	// pSelf.FindChildTraverse("OutgoingContainer").SetHasClass("Hidden", !bIsBuilding);
	// pSelf.FindChildTraverse("IncomingContainer").SetHasClass("Hidden", bIsBuilding);

	// let tData = CustomUIConfig.UnitsKv[Entities.GetUnitName(nEntityIndex)] || CustomUIConfig.HeroesKv[Entities.GetUnitName(nEntityIndex)];
	// let fExtraBaseHealthRegen = 0;
	// let fExtraBaseManaRegen = 0;

	// if (Entities.HasHeroAttribute(nEntityIndex)) {
	// 	var iPrimaryAttribute = Entities.GetPrimaryAttribute(nEntityIndex);

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

	// 		let iStrength = Entities.GetStrength(nEntityIndex);
	// 		let iBaseStrength = Entities.GetBaseStrength(nEntityIndex);
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
	// 		pStrength.SetDialogVariableInt("strength_hp", iStrength * tSettings.attribute_strength_hp);
	// 		pStrength.SetDialogVariable("strength_hp_regen", Float(iStrength * Float(tSettings.attribute_strength_hp_regen)));
	// 		pStrength.SetDialogVariableInt("primary_attribute_damage", Math.floor(Float(iStrength * Float(tSettings.attribute_primary_attack_damage))));
	// 		var unitName = Entities.GetUnitName(nEntityIndex);
	// 		unitName = SkinNameToUnitName(unitName) || unitName;
	// 		pStrength.SetDialogVariable("primary_attribute_total", Round(iStrength * Float(GetCardRarity(unitName) == "ssr" ? tSettings.attribute_primary_total_damage_ssr : tSettings.attribute_primary_total_damage), 2));
	// 		pStrength.SetHasClass("NegativeValue", sSign == "-");
	// 		pStrength.SetHasClass("NoBonus", sSign == "");
	// 		fExtraBaseHealthRegen += Float(iStrength * Float(tSettings.attribute_strength_hp_regen));
	// 	}

	// 	// 敏捷
	// 	{
	// 		let pAgility = pSelf.FindChildTraverse("AgilityContainer");

	// 		let iAgility = Entities.GetAgility(nEntityIndex);
	// 		let iBaseAgility = Entities.GetBaseAgility(nEntityIndex);
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
	// 		pAgility.SetDialogVariableInt("agility_attack_speed", Float(iAgility * Float(tSettings.attribute_agility_attack_speed)));
	// 		pAgility.SetDialogVariable("agility_cooldown_reduction", Round(fAgiCooldownReductionPercent, 1));
	// 		pAgility.SetDialogVariableInt("primary_attribute_damage", Math.floor(Float(iAgility * tSettings.attribute_primary_attack_damage)));
	// 		var unitName = Entities.GetUnitName(nEntityIndex);
	// 		unitName = SkinNameToUnitName(unitName) || unitName;
	// 		pAgility.SetDialogVariable("primary_attribute_total", Round(iAgility * Float(GetCardRarity(unitName) == "ssr" ? tSettings.attribute_primary_total_damage_ssr : tSettings.attribute_primary_total_damage), 2));
	// 		pAgility.SetHasClass("NegativeValue", sSign == "-");
	// 		pAgility.SetHasClass("NoBonus", sSign == "");
	// 	}

	// 	// 智力
	// 	{
	// 		let pIntellect = pSelf.FindChildTraverse("IntellectContainer");

	// 		let iIntellect = Entities.GetIntellect(nEntityIndex);
	// 		let iBaseIntellect = Entities.GetBaseIntellect(nEntityIndex);
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
	// 		pIntellect.SetDialogVariableInt("intelligence_mana", Float(iIntellect * Float(tSettings.attribute_intelligence_mana)));
	// 		pIntellect.SetDialogVariable("intelligence_mana_regen", Float(iIntellect * Float(tSettings.attribute_intelligence_mana_regen)));
	// 		pIntellect.SetDialogVariableInt("primary_attribute_damage", Math.floor(Float(iIntellect * Float(tSettings.attribute_primary_attack_damage))));
	// 		var unitName = Entities.GetUnitName(nEntityIndex);
	// 		unitName = SkinNameToUnitName(unitName) || unitName;
	// 		pIntellect.SetDialogVariable("primary_attribute_total", Round(iIntellect * Float(GetCardRarity(unitName) == "ssr" ? tSettings.attribute_primary_total_damage_ssr : tSettings.attribute_primary_total_damage), 2));
	// 		pIntellect.SetHasClass("NegativeValue", sSign == "-");
	// 		pIntellect.SetHasClass("NoBonus", sSign == "");
	// 		fExtraBaseManaRegen += Float(iIntellect * Float(tSettings.attribute_intelligence_mana_regen));
	// 	}
	// }

	// 攻击属性
	{

		// 攻击力
		{
			let pDamage = pSelf.FindChildTraverse("DamageRow");
			let DamageMin = Entities.GetDamageMin(nEntityIndex);
			let DamageMax = Entities.GetDamageMax(nEntityIndex);
			let base_damage = (DamageMax+DamageMin)*0.5;
			let bonus_damage = Entities.GetDamageBonus( nEntityIndex )
			let sSign = bonus_damage == 0 ? "" : (bonus_damage > 0 ? "+" : "-");
			if (sSign == "") {
				bonus_damage = "";
			}
			else if (sSign == "+") {
				bonus_damage = sSign + Round(bonus_damage,0);
			}
			else {
				bonus_damage =  Round(bonus_damage,0);
			}
			pDamage.SetDialogVariable("base_damage", Round(base_damage,0));
			pDamage.SetDialogVariable("bonus_damage", bonus_damage);``
			pDamage.SetHasClass("NegativeValue", sSign == "-");
			pDamage.SetHasClass("NoBonus", sSign == "");
		}
		
		// // 冷却减少
		{
			let targetPanel = pSelf.FindChildTraverse("CooldownReductionRow");
			let CooldownReduction = Entities.GetCooldownReduction(nEntityIndex);
			targetPanel.SetDialogVariable("cooldown_reduction", Round(CooldownReduction, 1));
		}
		// 最终伤害
		{
			let targetPanel = pSelf.FindChildTraverse("OutGoingDamageRow");
			let value = Entities.GetTotalDamageOutgoing(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}

		// 施法距离
		{
			let targetPanel = pSelf.FindChildTraverse("CastRangeBonusRow");
			let value = Entities.GetCastRangeBonus(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}


		// 治疗增强
		{
			let targetPanel = pSelf.FindChildTraverse("HealAMP_PercentageBonusRow");
			let value = Entities.GetHealAMP_Percentage(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
			
		}

		// 受到治疗增强
		{
			let targetPanel = pSelf.FindChildTraverse("HealReceiveAMP_PercentageBonusRow");
			let value = Entities.GetHealReceiveAMP_Percentage(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
			
		}
		{
			let targetPanel = pSelf.FindChildTraverse("LifeStealntensityRow");
			let value = Entities.GetLifeStealIntensity(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
			
		}
		
		{
			let targetPanel = pSelf.FindChildTraverse("PhysicalCriticalAmpRow");
			let value = Entities.GetPhysicalCriticalAmp(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}


		
	}
	// 防御属性
	{
		// 正面状态增强
		{
			let targetPanel = pSelf.FindChildTraverse("DurationGainRow");
			let value = Entities.GetDurationGain(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}
		{
			let targetPanel = pSelf.FindChildTraverse("NegativeDurationGainRow");
			let value = Entities.GetNegativeDurationGain(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}

		{
			let targetPanel = pSelf.FindChildTraverse("SummonIntensityGainRow");
			let value = Entities.GetSummonIntensity(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}

		{
			let targetPanel = pSelf.FindChildTraverse("SummonTimeIntensityRow");
			let value = Entities.GetSummonTimeIntensity(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}
		

		{
			let targetPanel = pSelf.FindChildTraverse("RandomEffectGainRow");
			let value = Entities.GetRandomEffectGain(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}

		{
			
			let targetPanel = pSelf.FindChildTraverse("Incoming_DamageGainRow");
			let value = -Entities.GetIncomingDamage_Percentage(nEntityIndex);
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}

		{
			
			let targetPanel = pSelf.FindChildTraverse("Proficiency_GainRow");
			let value = Entities.GetProficiency_Percentage(nEntityIndex)*100-100;
			// $.Msg(value);
			targetPanel.SetDialogVariable("value", Round(value, 1));
		}

		
	}



}