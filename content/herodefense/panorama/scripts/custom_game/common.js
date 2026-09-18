var CustomUIConfig = GameUI.CustomUIConfig();
let expKV = CustomUIConfig.ChaoticEra_PlayerArtifact_exp

// Buffs.GetUnitDataTest = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetUnitDataTest"));


Entities.GetCooldownReduction = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetCooldownReduction"));
Entities.GetTotalDamageOutgoing = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetTotalDamageOutgoing"));

Entities.GetCastRangeBonus = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetCastRangeBonus"));

Entities.GetHealAMP_Percentage = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetHealAMP_Percentage"));
Entities.GetHealReceiveAMP_Percentage = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetHealReceiveAMP_Percentage"));
Entities.GetDurationGain = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetDurationGain"));
Entities.GetNegativeDurationGain = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetNegativeDurationGain"));
Entities.GetSummonIntensity = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetSummonIntensity"));
Entities.GetSummonTimeIntensity = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetSummonTimeIntensity"));

Entities.GetLifeStealIntensity = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetLifeStealIntensity"));

Entities.GetRandomEffectGain = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetRandomEffectGain"));
Entities.GetPhysicalCriticalAmp = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetPhysicalCriticalAmp"));


Entities.GetIncomingDamage_Percentage = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetIncomingDamage_Percentage"));
Entities.GetProficiency_Percentage = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetTalentEffectGain"));


Entities.GetPrimaryAttribute = (iUnitEntIndex) => tofiniteNumber(Entities.GetUnitData(iUnitEntIndex, "GetPrimaryAttribute"));




// Entities.GetCooldownReduction



// Entities.GetUnitData = (iUnitEntIndex,buffSerial, sFuncName) => {
//     $.Msg("progress 1");
//     let tData = ClientRequest("get_modifier_property", {
//         modifier_ent_index: iUnitEntIndex,
//         function_name: sFuncName,
//     });
//     return tData?.value;
// };

function ToColor(info,color) {
    return "<font color='"+color+"'>"+ info+"</font>";
}
Entities.GetUnitData = (iUnitEntIndex, sFuncName) => {
    // $.Msg("progress 2");
    // $.Msg("Entities.GetUnitData iUnitEntIndex: ", iUnitEntIndex)
    // $.Msg("Entities.GetUnitData sFuncName: ", sFuncName)
	GameEvents.SendEventClientSide("hd_get_unit_data", {
		unit_ent_index: iUnitEntIndex,
		function_name: sFuncName,
	});

    // $.Msg("aaa");
    // $.Msg(Entities.GetAbilityCount( iUnitEntIndex))
	let iAbilityEntIndex = Entities.GetAbilityByName(iUnitEntIndex, "unit_state");
    //print("Entities.GetUnitData iAbilityEntIndex: ", iAbilityEntIndex)
    // $.Msg(iAbilityEntIndex)
    // $.Msg("aaaaaaaaaaaa")
	if (iAbilityEntIndex == -1) 
        return;


    let sValue = Abilities.GetAbilityTextureName(iAbilityEntIndex);
    // $.Msg("Entities.GetUnitData sValue: ", sValue)
    if (sValue == "nil")
        return;
    
    if (sValue == "") 
        return;

    if (sValue == "true")
        return true;
    
    if (sValue == "false")
        return false;
    
    let fValue = Number(sValue);
    if (isFinite(fValue)) {
        return fValue;
    } else {
        return sValue;
    }
};




function finiteNumber(i, defaultVar = 0) {
    return isFinite(i) ? i : defaultVar;
}

function tofiniteNumber(v, defaultVar = 0) {
    return finiteNumber(Number(v), defaultVar);
}



// 返回提供的数字的四舍五入到最近整数的
function Round(fNumber, prec = 0) {
    let i = Math.pow(10, prec);
    return Math.round(fNumber * i) / i;
}



function addChallengeEvens(spellButton,individualHeroShopGood,item_name,urlid,text,isDebug) {
    // LOCAL_DEBUG_TOOLS_CHALLENGE_CLICK
    spellButton.SetPanelEvent("onactivate", function () {
        SelectChallenge(individualHeroShopGood);
    });


    spellButton.SetPanelEvent("onmouseover", function () {
        // $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,item_name,urlid,text);
        let data = {
            name :individualHeroShopGood,
            type : ADVANCED_ABILITY_INFO_CHALLENGE,
        }
        let jsonData = JSON.stringify(data);
        $.DispatchEvent("UIShowCustomLayoutParametersTooltip", spellButton, "advanced_ability_info", "file://{resources}/layout/custom_game/tooltips/advanced_ability/advanced_ability.xml", "data=" + jsonData);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        // $.DispatchEvent("DOTAHideTitleImageTextTooltip");
        $.DispatchEvent("UIHideCustomLayoutTooltip", spellButton, "advanced_ability_info");
        
    });
}


function AddPotionHoverEvent(targetPanel,itemName,oderList) {
    let kv = GameUI.CustomUIConfig().ChaoticEraPotionKV[itemName];
    if (kv) {
        let info = $.Localize("#"+itemName+"_info");
        let specialValue = kv.AbilityValues;
        // $.Msg(info);
        for (let key in specialValue){
            let v = specialValue[key];
            info = info.replace(('<' + key + '>'), v.toString());
        }
        info = ChangeNumberColor(info,"caa7e9");
        if (oderList.bUsePotionInfo) {
            let bonusInfo = ToColor($.Localize("#HUD_Potion_Info_1"),"#454545");
          
            info = bonusInfo + "<br><br>" +info;
            // $.Msg(info);
        }
        let name = $.Localize("#"+itemName);
        // if (specialKeys.useDefaultCount) {
        //     name = name+ ToColor("x"+kv.count,"a7d1e9");
        // }
        let keys ={
            title :name,
            text :info,
            
        }
        SetBaseAdavncedInfoHoverEvent(targetPanel,keys);
    }else{
        $.Msg("错误：找不到药剂kv",item);
    }
}

function GetPotionType(itemName) {
    let kv = GameUI.CustomUIConfig().ChaoticEraPotionKV[itemName];
    if (kv) {
        return kv.type;
    }else{
        return "unknow";
    }
}




function SelectChallenge(name){
    var index = Challenge_List[name];
    var event_data = {

        player_id: Game.GetLocalPlayerID(),
        location_index :index,
    };
    GameEvents.SendCustomGameEventToServer("TargetSelected", event_data);
}
// LOCAL_DEBUG_TOOLS_CHALLENGE_HELPER


CustomUIConfig.SubscribeNetTableListener = function (tableName, callback) {
    GameEvents.Subscribe("settablevalue_nil", (tEvents) => {
        if (tEvents.table_name == tableName) {
            if (typeof callback == "function") {
                callback(tableName, tEvents.key_name, undefined);
            }
        }
    });

    return CustomNetTables.SubscribeNetTableListener(tableName, callback);
};






// text,textColor,title,titleColor
function SetBaseAdavncedInfoHoverEvent(targetPanel,keys,bSetFormat) {
	let data = {
		type : AdvancedInfo_Type_Base,
		info:{
            // text : "",
            // title : "",
			// text : ToColor( text,"#fffed7"),
			// title: ToColor( $.Localize("#HUD_fellomen_buff_Lore"),"#ffffaf"),
		}
	}

    if (keys.textColor) {
        data.info.text = ToColor( keys.text,keys.textColor);
    }else{
        data.info.text = keys.text;
    }
    if (keys.titleColor) {
        data.info.title = ToColor( keys.title,keys.titleColor);
    }else{
        data.info.title = keys.title;
    }
    // $.Msg("-----------");
    // $.Msg(data);
    targetPanel.ClearPanelEvent("onmouseover");
    targetPanel.ClearPanelEvent("onmouseout");
	targetPanel.SetPanelEvent("onmouseover", () => {
		$.DispatchEvent("UIShowCustomLayoutParametersTooltip", targetPanel, "advanced_info", "file://{resources}/layout/custom_game/tooltips/advanced_info/advanced_info.xml", "data=" + JSON.stringify(processDataForJSON(data)));
	});
	targetPanel.SetPanelEvent("onmouseout", () => {
		$.DispatchEvent("UIHideCustomLayoutTooltip", targetPanel, "advanced_info");
	});
}


function addSpellInfoHoverEvens(spellButton,spellName) {
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,spellName);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });
}




function GetAbilityType(spellName) {
    if (spellName.match("Primary_")){
        return ABILITY_TYPE_GENERAL_SHOP;
    }
    if (spellName.match("chaotic_")) {
        return ABILITY_TYPE_CHAOTIC_ERA_SPECIAL;
    }

    return ABILITY_TYPE_OTHER;
}

function ChangeNumberColor(targetText,color) {
	// targetText = targetText.replace(/(\d+%?)/g, "<font color='#"+color+"'>$1</font>");
	// return targetText;

    targetText = targetText.replace(/(<[^>]+>)|(\d+%?)/g, (match, tag, number) => {
        if (tag) {
            // 如果是 HTML 标签，直接返回原始匹配内容
            return tag;
        } else if (number) {
            // 如果是数字，进行替换
            return `<font color='#${color}'>${number}</font>`;
        }
        return match;
    });
    return targetText;
}
function GetCurrentArtifactLevel(current_exp) {
    let lv = 0;
    for (let index = 1; index <= 100; index++) {
        const element = expKV[index];
        if (current_exp>=element.value) {
            lv = index;
        }
        
    }
    return lv;
}


function SendCustomErroMessage(event_data){
    var message = event_data.message;
    var sound = event_data.sound;
    GameUI.SendCustomHUDError( message, sound );
}
function PlayClientSound(keys){
    Game.EmitSound(keys.sound)
}

String.prototype.replaceAll = function(s1,s2){
    　　return this.replace(new RegExp(s1,"gm"),s2);
}

function IsNull(variable) {
    return variable == null || variable == undefined || (typeof (variable) == "number" && isNaN(variable));
}

function CheckBonusColor(bonus,realBonusValue) {
    if (bonus>=0.2) {
        if ( bonus>=0.5 ) {
            if ( bonus>=0.85 ) {
                realBonusValue = ToColor(realBonusValue,"#e27e6d");
            }else{
                realBonusValue = ToColor(realBonusValue,"#e2b56d");
            }
        }else{
            realBonusValue = ToColor(realBonusValue,"#6ddae2");
        }
        
    }else{
        realBonusValue = ToColor(realBonusValue,"#ffffff");
    }
    return realBonusValue;
}

// 自动加空格
function padStringToLength(str, length) {
    if (str.length >= length) {
        return str; // 字符串已经达到或超过所需长度，无需修改
    } else {
        const spacesToAdd = length - str.length;
        const spaces = "&nbsp;".repeat(spacesToAdd);
        return str + spaces;
    }
}
// 自动加0
function padStringWithZeros(inputString,desiredLength) {
    $.Msg(inputString.length);
    if (inputString.length >= desiredLength) {
      return inputString; // 字符串已经达到或超过所需长度，无需修改
    } else {
      const zerosToAdd = desiredLength - inputString.length;
      const zeros = "0".repeat(zerosToAdd);
      return zeros + inputString;
    }
}


function ChangeAllNumberColor(targetText,color) {
    // targetText = targetText.replace(/(\d+%?)/g, "<font color='"+color+"'>$1</font>");
    
    targetText = targetText.replace(/(?<!<\/font>)(\d+%?)(?![^<]*>)/g, "<font color='"+color+"'>$1</font>");
	
    return targetText;
}

function ReplaceSpecialWithKV(specialValue,description) {
    for (let key in specialValue){
        let v = specialValue[key];
        description = description.replace(('<' + key + '>'), v.toString());
       
    }
    return description;
}


function addSpellUpgradeEvens_tooltip(spellButton,cost) {

	let text = $.Localize("#DOTA_HUD_spell_upgrate_button_tooltip")+cost;
    spellButton.SetPanelEvent("onmouseover", function () {
		
        $.DispatchEvent("DOTAShowTextTooltip",spellButton,text);
    });
    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideTextTooltip");
    });

}

function addSpellUpgradeEvens(spellButton,individualHeroSpellName,key_index,advanced,cost) {
    spellButton.SetPanelEvent("onactivate", function () {
        SpellUpgradeSelect(individualHeroSpellName);
    });
    if (advanced) {
        spellButton.SetPanelEvent("oncontextmenu", function () {
            SpellUpgradeSelect_max(individualHeroSpellName);
        });
    }
    // Hover events
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,key_index);
		// cost
        if (cost) {
            GameUI.CustomUIConfig().advanced_upgrade_costPanel.SetHasClass("hide",false)
            GameUI.CustomUIConfig().advanced_upgrade_costPanel.SetDialogVariable("cost",  cost);
        }


    });
    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
		GameUI.CustomUIConfig().advanced_upgrade_costPanel.SetHasClass("hide",true)
    });

}

//升级该技能
function SpellUpgradeSelect(spellName) {
    upgradetarget = spellName;
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        upgrade: upgradetarget,
    };

    GameEvents.SendCustomGameEventToServer("spells_menu_Upgrade_player_spells", event_data);

}
function SpellUpgradeSelect_max(spellName) {
    upgradetarget = spellName;
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        upgrade: upgradetarget,
    };

    GameEvents.SendCustomGameEventToServer("spells_menu_Upgrade_player_spells_max", event_data);

}


function InitArtifactHover(spellPanel,artifactData,spellName,iLevel){

    spellPanel.ClearPanelEvent("onmouseover");
    spellPanel.ClearPanelEvent("onmouseout");
    if (artifactData && artifactData[spellName]["complete"]==1) {
        let data = {
            itemName : spellName,
            rarity : iLevel,
            exp_current:artifactData[spellName]["valueOne"],
        };
        spellPanel.SetPanelEvent("onmouseover", function () {
            let jsonData = JSON.stringify(data);
            $.DispatchEvent("UIShowCustomLayoutParametersTooltip", spellPanel, "player_artifact_tooltip", "file://{resources}/layout/custom_game/tooltips/player_artifact/player_artifact.xml", "data=" + jsonData);
        });
        spellPanel.SetPanelEvent("onmouseout", function () {
            $.DispatchEvent("UIHideCustomLayoutTooltip", spellPanel, "player_artifact_tooltip");
        });
        spellPanel.SetDialogVariable("level",GetCurrentArtifactLevel(data.exp_current))
    }else{
        spellPanel.SetHasClass("lock",true);
        let data = {
            itemName : spellName,
            rarity : iLevel,
            exp_current:0,
            lock :true,
        };
        spellPanel.SetPanelEvent("onmouseover", function () {
            let jsonData = JSON.stringify(data);
            $.DispatchEvent("UIShowCustomLayoutParametersTooltip", spellPanel, "player_artifact_tooltip", "file://{resources}/layout/custom_game/tooltips/player_artifact/player_artifact.xml", "data=" + jsonData);
        });
        spellPanel.SetPanelEvent("onmouseout", function () {
            $.DispatchEvent("UIHideCustomLayoutTooltip", spellPanel, "player_artifact_tooltip");
        });
        spellPanel.SetDialogVariable("level",GetCurrentArtifactLevel(data.exp_current))
    }
}


// 排序map
function GeneralSoft(originalObject){
    const sortedKeys = Object.keys(originalObject).sort();
    // 创建一个新的对象来存储排序后的键值对
    let sortedObject = {};
    for (const key of sortedKeys) {
        sortedObject[key] = originalObject[key];
    }
    return sortedObject;
}
function IsValidPanel() {
    function _IsValidPanel(panel) {
        return panel != null && panel != undefined && typeof (panel.IsValid) == "function" && panel.IsValid();
    }
    let res = _IsValidPanel(arguments[0]);
    for (let index = 1; ((index < arguments.length) && res); index++) {
        const ag = arguments[index];
        res = res && _IsValidPanel(ag);
    }
    return res;
}
    
// 替换所有special value
function ReplaceSpecialValueWithAbilityEntity(description,abilityIndex) {
    // $.Msg("222");
    let name = Abilities.GetAbilityName(abilityIndex);
    let abilityKV;

	if (name.match("item_")) {
		abilityKV = GameUI.CustomUIConfig().ItemsKv[name];
		// isItem = true;
	}else{
		abilityKV = GameUI.CustomUIConfig().AbilitiesKv[name];
	}
    // $.Msg(description);
    if (abilityKV) {
        let AbilityValues = abilityKV.AbilityValues
        if (AbilityValues) {
            // $.Msg(AbilityValues);
            for (const key in AbilityValues) {
                if (Object.hasOwnProperty.call(AbilityValues, key)) {
                    const element = AbilityValues[key];
                    if (typeof(element)=="number") {
                        let value = Math.floor(Abilities.GetSpecialValueFor( abilityIndex, key )*100)/100;
                        description = description.replace('%'+key+'%%%', value.toString()+"%");
                        description = description.replace(('%' + key + '%'), value.toString());

                    }else{
                        // todo table的处理
                    }

                }
            }
        }
    }
    // $.Msg(description);
    // description = description.replace(('<' + key + '>'), value.toString());
    return description;
}

// "AbilityValues"
// 		{
// 			"level_step"      "10"
// 			"bonus_attribute" "20"
// 			"bonus_primary_attribute" "35"

// 			"attribute_reduce_rate"  "65"

// 			"duration"  "60"
// 			"debuff_duration"  "30"
		
			

// 		}


// 高级信息类型
AdvancedInfo_Type_Base = 1;

// 常量
ADVANCED_ABILITY_INFO_CHALLENGE = 1;
ADVANCED_ABILITY_INFO_WAVE_BONUS = 2;




// Spell Type
ABILITY_TYPE_GENERAL_SHOP = 1
ABILITY_TYPE_CHAOTIC_ERA_SPECIAL = 2
ABILITY_TYPE_OTHER = 4


// Rune Special Bonus Type
RUNE_BONUS_TYPE_Percentage = 1
RUNE_BONUS_TYPE_Constant = 2
RUNE_BONUS_TYPE_Neg_Percentage = 3
RUNE_BONUS_TYPE_Neg_Constant = 4

// 处理数据中的加号
function processDataForJSON(data) {
    if (typeof data === 'string') {
        return data.replace(/\+/g, '___PLUS___');
    } else if (typeof data === 'object') {
        if (Array.isArray(data)) {
            return data.map(item => processDataForJSON(item));
        } else {
            let newData = {};
            for (let key in data) {
                newData[key] = processDataForJSON(data[key]);
            }
            return newData;
        }
    }
    return data;
}

// 恢复数据中的加号
function restoreDataFromJSON(data) {
    if (typeof data === 'string') {
        return data.replace(/___PLUS___/g, '+');
    } else if (typeof data === 'object') {
        if (Array.isArray(data)) {
            return data.map(item => restoreDataFromJSON(item));
        } else {
            let newData = {};
            for (let key in data) {
                newData[key] = restoreDataFromJSON(data[key]);
            }
            return newData;
        }
    }
    return data;
}
