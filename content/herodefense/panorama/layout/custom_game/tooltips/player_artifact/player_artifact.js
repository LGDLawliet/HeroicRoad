function donothing(params) {
    
}
var CustomUIConfig = GameUI.CustomUIConfig();
let RuneKV = CustomUIConfig.ChaoticSpellRuneKV;
let itemKV = CustomUIConfig.ChaoticEra_PlayerArtifact;
// let expKV = CustomUIConfig.ChaoticEra_PlayerArtifact_exp
var self = $.GetContextPanel();

let PlayerCount = 0;
let challenge_difficulty = 0;
let game_round = 0;
let configData;
const Header = $("#Header");
const AbilityTarget =  $("#AbilityTarget");
const AbilityDescriptionContainer =  $("#AbilityDescriptionContainer");


function setupTooltip()
{
 
    let data =   JSON.parse(self.GetAttributeString("data", ''));  
    // if (data.type==ADVANCED_ABILITY_INFO_CHALLENGE) {
    //     SetUpChallengeInfo(data);
    //     return;
    // }


    let targetAbility = data.itemName;
    $.Msg("targetAbility=",targetAbility);
    let kv = itemKV[targetAbility];
    if (kv==null) {
        $.Msg("错误：没找到符石信息");
        return;
    }
    let abilityLocalize = "#DOTA_Tooltip_ability_"+targetAbility;
    Header.SetDialogVariable("ability_owner",$.Localize(abilityLocalize));
    Header.SetDialogVariable("rarity",$.Localize("#HUD_Level"+data.rarity));

    let maxLevel = kv.MaxLevel;
    let level = GetCurrentArtifactLevel(data.exp_current);
    if (data.lock) {
        level = 0;
    }
    // const expKV = CustomUIConfig.ChaoticEra_PlayerArtifact_exp;
    // $.Msg("expKV=",expKV);
    if (level>=maxLevel) {
        self.SetDialogVariable("artifactLevel",level+" / "+maxLevel);
        self.SetDialogVariable("exp_current",data.exp_current-expKV[maxLevel].value);
        self.SetDialogVariable("exp_require","∞");
        $("#artifactLevelProgress").value =1;
        $("#artifactLevelProgress").SetHasClass("maxLevel",true);

        
    }else{
        self.SetDialogVariable("artifactLevel",level+" / "+maxLevel);
        $("#artifactLevelProgress").SetHasClass("maxLevel",false);
        if (level==0) {
           
            self.SetDialogVariable("exp_current",data.exp_current-expKV[1].value);
            self.SetDialogVariable("exp_require",expKV[2].value-expKV[1].value);
            $("#artifactLevelProgress").value =(data.exp_current-expKV[1].value)/(expKV[2].value-expKV[1].value)
            
        }else{
            self.SetDialogVariable("exp_current",data.exp_current-expKV[level].value);
            self.SetDialogVariable("exp_require",expKV[level+1].value-expKV[level].value);
            $("#artifactLevelProgress").value =(data.exp_current-expKV[level].value)/(expKV[level+1].value-expKV[level].value)
        }
       

    }
    kv
  
    $("#artifact_bg").style.backgroundImage = "url('s2r://panorama/images/custom_game/chaotic_era/PlayerArtifact/"+kv.IconName+".png')";
    
    AbilityDescriptionContainer.RemoveAndDeleteChildren();
    $("#AbilityDescriptionOuterContainer").SetHasClass("hidden",false);
    // {
    //     let targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "defaultDescription");
    //     targetPanel.BLoadLayoutSnippet("DescriptionBlock"); //载入模块
    //     targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = $.Localize("#HUD_Rune_Description");
    
    // }
    let abilityValues = kv.AbilityValues;
    if (abilityValues) {
        let bFirst = true;

        let bonusInfo_Block;

        let targetPanel;
        for (const [key, value] of Object.entries(abilityValues)) {
            let processedValue = typeof value === 'object' ? value : { value: value };
            // $.Msg(key);
            // $.Msg(processedValue);

            let Description = $.Localize(abilityLocalize+"_"+key);
            if (Description==(abilityLocalize+"_"+key)) {
                continue;
            }
            let bonus = "";


            Description = Description.replace(/([+\-%]+)\$(\w+)/g, (match, symbols, variable) => {
                let localizedKey = `dota_ability_variable_${variable}`;
                let localizedText = $.Localize("#" + localizedKey);
                
                // 检查是否成功本地化
                if (localizedText && localizedText !== `#${localizedKey}`) {
                    // 从 processedValue 中获取数值
                    let value = processedValue.value || 0;
                    
                    // 检查原始文本中是否包含百分号
                    if (symbols.includes('%')) {
                        bonus = `+${value}%`;
                    } else {
                        bonus = `+${value}`;
                    }
                    
                    return localizedText; // 只返回本地化的属性名称，不包含符号
                }
                
                return match; // 如果本地化失败，保持原始文本
            });



            Description = ChangeNumberColor(Description,"ffffff");
            if (bFirst) {
                bFirst = false;
                targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "bonusInfoRoot");
                targetPanel.BLoadLayoutSnippet("SpecialBonusBlock"); //载入模块
                bonusInfo_Block =  targetPanel.FindChildInLayoutFile("bonusInfo_Block");
            }

            let bonusInfo = $.CreatePanel("Panel", bonusInfo_Block, "bonus_info");
            bonusInfo.BLoadLayoutSnippet("specialBonus"); //载入模块
            bonusInfo.SetDialogVariable("bonus", bonus);
            bonusInfo.SetDialogVariable("header", Description);
            if (processedValue._level_bonus) {
                if (processedValue._level_bonus>0) {
                    bonusInfo.SetDialogVariable("bonus_pre_level", "+"+processedValue._level_bonus);
                }else{
                    bonusInfo.SetDialogVariable("bonus_pre_level", processedValue._level_bonus);
                }
              
            }
            // $.Msg(Description);
    
        }
    }



    // "AbilityValues": {
    //     "bonus_damage": {
    //         "value": 30,
    //         "_level_bonus": 1,
    //     },
    //     "damage_index": 10,
    // },
    if (true) {
        //<TODO>技能冷却
        let targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "defaultDescription");
        targetPanel.BLoadLayoutSnippet("DescriptionBlock"); //载入模块
        let Description = $.Localize(abilityLocalize+"_main_ability")
        let text = Description;
        text = GameUI.ReplaceDOTAAbilitySpecialValues(targetAbility, text);
        text = ChangeNumberColor(text,"ffffff");
        targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = text;


        targetPanel.FindChildInLayoutFile("single_DescriptionLabel_left").text = $.Localize(abilityLocalize+"_main_ability_title");
    }
    
    {
        let rootPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "defaultDescription");
        rootPanel.BLoadLayoutSnippet("DescriptionBlock2"); //载入模块
        for (let index = 1; index <= 10; index++) {
            let levelRequire = itemKV[targetAbility]["additional_unlock_level_"+index]
            if (levelRequire) {
                let targetPanel = $.CreatePanel("Panel", rootPanel, "defaultDescription");
                targetPanel.BLoadLayoutSnippet("additionalBlock"); //载入模块
                let Description = $.Localize(abilityLocalize+"_additional_"+index)
                let text = Description;
                text = GameUI.ReplaceDOTAAbilitySpecialValues(targetAbility, text);
                text = ChangeNumberColor(text,"ffffff");
                // targetPanel.FindChildInLayoutFile("single_additionalLabel").text = "\u3000\u3000\u3000\u3000\u3000"+text;
                targetPanel.FindChildInLayoutFile("single_additionalLabel").text = text;
            
                targetPanel.SetDialogVariable("level_require", itemKV[targetAbility]["additional_unlock_level_"+index]);
                if (level>=itemKV[targetAbility]["additional_unlock_level_"+index]) {
                    targetPanel.SetHasClass("unlock",true);
                }
            }
            
        }
    
    }
    if (true) {
        $("#AbilityLore").SetHasClass("hidden",false);
        $("#AbilityLore").SetDialogVariable("lore",$.Localize(abilityLocalize+"_lore"));
    }

  
    $("#AbilityLevelRequire").SetDialogVariable("level_require",itemKV[targetAbility].RequireLevel);

    if (true) {
        return;
    }
   
  
    // self.SetDialogVariable("artifactLevel",padStringWithZeros(""+data.runeId,10));

    {
        if (data.runeType>=1) {
            let targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "defaultDescription");
            targetPanel.BLoadLayoutSnippet("DescriptionBlock"); //载入模块

            let title = $.Localize(abilityLocalize+"_rune_"+data.runeType);
            let Description = $.Localize(abilityLocalize+"_rune_"+data.runeType+"_Description")
            if (title==abilityLocalize+"_rune_"+data.runeType) {
                title = $.Localize("#HUD_Rune_Special_None");
            }
            if (Description==abilityLocalize+"_rune_"+data.runeType+"_Description") {
               
                Description = "";
            }

            // HUD_Rune_Special_None

            let text =  "-"+ToColor(title,"#ffffff")
            + "<br><br>"+Description;
            text = GameUI.ReplaceDOTAAbilitySpecialValues(targetAbility, text);
            text = ChangeNumberColor(text,"ffffff");
            text = $.Localize("#HUD_Rune_Type_Bonus_Title") + "<br><br>"+text;

            // 
            targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = text;
        }
    
    }

    {
        let specialKV = RuneKV[targetAbility].special;
        if (specialKV==null) {
            $.Msg("错误：没找到��石specialKV",targetAbility);
            return;
        }
        let special = data.specicaValue;
        let KV_Prefix= "#DOTA_Tooltip_ability_"+targetAbility+"_";
        // let bonus_info = $.Localize("#HUD_Rune_Bonus_Title");
        let targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "bonusInfoRoot");
        targetPanel.BLoadLayoutSnippet("SpecialBonusBlock"); //载入模块
        // targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = bonus_info;

        let bonusInfo_Block =  targetPanel.FindChildInLayoutFile("bonusInfo_Block");
        let level = Math.min(data.rarity,5);  //注意：至宝等级不加数值！！！！！！！

        special = GeneralSoft(special);
        for (const key in special) {
            if (specialKV[key]) {
                let bonus = Number(special[key]);
                bonus = bonus.toFixed(2);
     
    
                let min_bonus = specialKV[key].min_value.base + specialKV[key].min_value.level_step * level;
                let max_bonus = specialKV[key].max_value.base + specialKV[key].max_value.level_step * level;
                let realBonusValue = Math.floor((min_bonus+(max_bonus-min_bonus)*bonus)*100)/100;
                if (level==4) {
                    realBonusValue = Math.floor(realBonusValue * 1.6);
                    max_bonus = Math.floor(max_bonus * 1.6);
                    min_bonus = Math.floor(min_bonus * 1.6);
                }
                let bonus_intervalInfo = "";
                if (specialKV[key].Type==RUNE_BONUS_TYPE_Percentage) {
                    bonus_intervalInfo = min_bonus+"% ~ "+max_bonus+"%";
                }else if (specialKV[key].Type==RUNE_BONUS_TYPE_Neg_Percentage) {
                    bonus_intervalInfo = min_bonus+"% ~ "+max_bonus+"%";
                }else{
                    bonus_intervalInfo = min_bonus+" ~ "+max_bonus;
                }
               

                let keyLocalize = "";
                let defaultKey = "#HUD_Spell_Rune_"+targetAbility+"_"  +key;
                if (defaultKey!=$.Localize(defaultKey)) {
                    keyLocalize = $.Localize(defaultKey);
                }else{
                    keyLocalize = $.Localize(KV_Prefix+key);
                    if (keyLocalize==(KV_Prefix+key)) {
                        $.Msg("存在未添加本地化的文段 ","HUD_Spell_Rune_"+targetAbility+"_"  +key);
                    }
                    keyLocalize = keyLocalize.replaceAll(":", '');
                    keyLocalize = keyLocalize.replaceAll("：", '');
                    // $.Msg("keyLocalize=",keyLocalize);
                }
                // let keyLocalize = KV_Prefix+key;
                // if (keyLocalize!=$.Localize(KV_Prefix+key) ) {
                //     keyLocalize = $.Localize(KV_Prefix+key);
                // }else{
                //     keyLocalize = $.Localize("#HUD_Spell_Rune_"+key);
                // }
    
                let bonusInfo = $.CreatePanel("Panel", bonusInfo_Block, "bonus_info");
                bonusInfo.BLoadLayoutSnippet("specialBonus"); //载入模块
                bonusInfo.SetDialogVariable("header",keyLocalize);
                // if (specialKV[key].Type==RUNE_BONUS_TYPE_Percentage) {
                //     bonusInfo.SetDialogVariable("bonus",realBonusValue+"%");
                // }else{
                //     bonusInfo.SetDialogVariable("bonus",realBonusValue);
                // }

                // if (specialKV[key].Type==RUNE_BONUS_TYPE_Percentage) {
                //     realBonusValue=  CheckBonusColor(bonus,"+"+realBonusValue+"%");
                //     bonusInfo.SetDialogVariable("bonus",realBonusValue);
                // }else{
                //     realBonusValue=  CheckBonusColor(bonus,realBonusValue);
                //     bonusInfo.SetDialogVariable("bonus","+"+realBonusValue);
                // }


                

                if (specialKV[key].Type==RUNE_BONUS_TYPE_Percentage) {
                    realBonusValue=  CheckBonusColor(bonus,"+"+realBonusValue+"%");
                    bonusInfo.SetDialogVariable("bonus",realBonusValue);
                }else if (specialKV[key].Type==RUNE_BONUS_TYPE_Neg_Percentage) {
                    // $.Msg("sasadsa")
                    realBonusValue=  CheckBonusColor(bonus,"-"+realBonusValue+"%");
                    bonusInfo.SetDialogVariable("bonus",realBonusValue);
                }else{
                    realBonusValue=  CheckBonusColor(bonus,realBonusValue);
                    bonusInfo.SetDialogVariable("bonus","+"+realBonusValue);
                }
               
                
                bonusInfo.SetDialogVariable("bonus_interval",bonus_intervalInfo);
            }else{
                $.Msg("Error:没找到key",targetAbility,key);
            }
           

            // keyLocalize = padStringToLength(keyLocalize, 10);
            // $.Msg("keyLocalize=",keyLocalize);
            // bonus_info += "<br>"+keyLocalize  +" + "+ bonus  ;

            // specialBonus
        }

        // 键值对
    }


    {
        if (data.particleType>=1) {
            let targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "defaultDescription");
            targetPanel.BLoadLayoutSnippet("DescriptionBlock"); //载入模块

            let text =  $.Localize("#HUD_Rune_Type_Particle_Title") + "<br><br>"+  ToColor("-"+$.Localize(abilityLocalize+"_runeParticle_"+data.runeType),"#ffffff");


            // 
            targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = text;
        }
    
    }

    {
        let targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "defaultDescription");
        targetPanel.BLoadLayoutSnippet("DescriptionBlock"); //载入模块

        let text =  $.Localize("#HUD_Rune_Modify_Count") +  ToColor(data.modifyCount,"#ffffff");


        // 
        targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = text;

        
    }
    // HUD_Rune_Description
    // Header.SetDialogVariable("value1",  $.Localize("#HUD_Advanced_Header"));
    // $.Msg(data.type);
    // let data = self.GetAttributeString("data", '').split(",");


}


function SetUpChallengeInfo(data) {

    const Header =  $("#Header");
    const AbilityTarget =  $("#AbilityTarget");
    const AbilityDescriptionContainer =  $("#AbilityDescriptionContainer");

    let spilitSTR = data.name.split("_");
    // 这确实有点落后 但不好改太多了
    let challengeName = spilitSTR[0] +"_"+ spilitSTR[1];
    let challengeLevel = spilitSTR[2];

    let challengeKV = CustomUIConfig.ChallengeInfo_KV[challengeName];
    if (challengeKV==null) {
        $.Msg("Error：没有找到KV ",challengeName)
        return
    }




    let challengeTitle = $.Localize("#DOTA_Tooltip_"+challengeName+"_Name");
    var challenge_description = $.Localize("#DOTA_Tooltip_"+challengeName+"_Description");
    if (challengeLevel==5 && challengeKV.speical_level5 && challengeKV.speical_level5==1) {
        // 特殊5级描述
        challenge_description = $.Localize("#DOTA_Tooltip_"+challengeName+"_Description_5");
    }
   
    challenge_description = ReplaceChallengeSpecial(challengeKV.AbilityValues,challenge_description,challengeLevel);
  

    // $.Msg(challengeTitle);
    // $.Msg(challenge_description);
    // $.Msg(challengeTitle);
    Header.FindChildTraverse("AbilityName").text = challengeTitle;
    Header.FindChildTraverse("AbilityLevel").text =  $.Localize("#DOTA_HUD_Challenge_level")+"  " + $.Localize("#DOTA_HUD_Challenge_level_"+challengeLevel);


    AbilityTarget.SetDialogVariable("value1",  $.Localize("#DOTA_Tooltip_ChallengeInfo_type_"+challengeKV.Localize_type));
    AbilityTarget.FindChildTraverse("ChallengeType").SetHasClass("hidden", false);

    AbilityDescriptionContainer.RemoveAndDeleteChildren();
    $("#AbilityDescriptionOuterContainer").SetHasClass("hidden",false);
    let targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "defaultDescription");
    targetPanel.BLoadLayoutSnippet("DescriptionBlock"); //载入模块
    targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = $.Localize("#DOTA_Tooltip_ChallengeInfo_info_2") +  challenge_description;

    let bonus_count = challengeKV.special_bonus_count || 0;
    // $.Msg("bonus_count=",bonus_count);
    let bonus_info = $.Localize("#DOTA_Tooltip_ChallengeInfo_info_3");
    if (bonus_count>=1) {
        for (let index = 1; index <= bonus_count; index++) {
            if (index==1) {
                if (challengeKV.use_special_in_bonus1 && challengeKV.use_special_in_bonus1==1) {
                    bonus_info = bonus_info + "<br>" +index+"."+$.Localize("#DOTA_Tooltip_"+challengeName+"_Bonus_1_"+challengeLevel);
                    continue;
                }
            }
            bonus_info = bonus_info + "<br>" +index+"."+$.Localize("#DOTA_Tooltip_"+challengeName+"_Bonus_"+index);
           
            
        }
    }
    if (challengeKV.Localize_type=="Elite_Challenge") {

        // 在描述下插入属性
        let targetPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "boss_attribute");
        targetPanel.BLoadLayoutSnippet("DescriptionBlock"); //载入模块
        // targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = $.Localize("#DOTA_Tooltip_ChallengeInfo_info_2") +  challenge_description;

        let health = challengeKV.elite_base_health + (1+game_round)*challengeKV.elite_bonus_health*challengeLevel;
        let atk = challengeKV.elite_base_atk + (1+game_round) * challengeKV.elite_bonus_atk*challengeLevel;
        let armor = challengeKV.elite_base_armor+ challengeKV.elite_bonus_armor*challengeLevel;
        let bossInfo = $.Localize("#DOTA_Tooltip_Boss_health") + ToColor(health,"#c7c1c1");
        bossInfo = bossInfo+ "<br>" + $.Localize("#DOTA_Tooltip_Boss_atk") + ToColor(atk,"#c7c1c1");
        bossInfo = bossInfo+ "<br>" + $.Localize("#DOTA_Tooltip_Boss_armor") + ToColor(armor,"#c7c1c1");
        targetPanel.FindChildInLayoutFile("single_DescriptionLabel").text = bossInfo;

        bonus_count++;
        // 对于boss挑战 附加两个词条
        bonus_info = bonus_info + "<br>" +bonus_count+"."+$.Localize("#DOTA_Tooltip_Bonus_Boss_1");
        bonus_count++;
        bonus_info = bonus_info + "<br>" +bonus_count+"."+$.Localize("#DOTA_Tooltip_Bonus_Boss_2");

        let boss_bonus_gold = GetValueWithLevel(challengeKV.boss_bonus_gold,challengeLevel);
        let boss_spell_index = GetValueWithLevel(challengeKV.boss_spell_index,challengeLevel);

        // 受到人数与试炼难度影响
        let book_index = 1;
        let gold_bonus_index = 1;
        if (configData) {
            if (PlayerCount>=1) {
                book_index = book_index * Number(configData.BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT__SpellBook[PlayerCount])
                gold_bonus_index = gold_bonus_index * Number(configData.BONUS_GOLD_INDEX_FROM_CHALLENGE_BOSS[PlayerCount])
            }
            if (challenge_difficulty>=1) {
                book_index = book_index * Number(configData.BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__SpellBook[challenge_difficulty])
            }
            book_index = book_index.toFixed(2);  
            gold_bonus_index = gold_bonus_index.toFixed(2);  
        }

        

        bonus_info = ReplaceKeyWithValue(bonus_info,"boss_bonus_gold",Number(boss_bonus_gold*gold_bonus_index).toFixed(0));
        bonus_info = ReplaceKeyWithValue(bonus_info,"boss_spell_index",Number(boss_spell_index*book_index).toFixed(2));
    }




    // ReplaceKeyWithValue(challenge_description,key,value)


    bonus_info =  ReplaceChallengeSpecial(challengeKV.AbilityValues,bonus_info,challengeLevel);

    let bonusPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "bonus_info");
    bonusPanel.BLoadLayoutSnippet("DescriptionBlock"); //载入模块
    bonusPanel.FindChildInLayoutFile("single_DescriptionLabel").text = bonus_info;
    // $.Msg(bonus_info);




    // 再添加一个金币奖励
    if (challengeKV.exp_bonus || challengeKV.aurum_bonus) {

        // 金币与经验奖励会受到
        let index = 1;
        if (configData) {
            if (PlayerCount>=1) {
                index = index * Number(configData.BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT[PlayerCount])
            }
            if (challenge_difficulty>=1) {
                index = index * Number(configData.BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY[challenge_difficulty])
            }
            index = index.toFixed(2);  
        }
        
        
        let bonusPanel = $.CreatePanel("Panel", AbilityDescriptionContainer, "bonus_info_exp_N_aurum");
        bonusPanel.BLoadLayoutSnippet("DescriptionBlock_BonusResource"); //载入模块
        // bonusPanel.FindChildInLayoutFile("single_DescriptionLabel").text = bonus_info;
        if (challengeKV.exp_bonus) {
            bonusPanel.SetDialogVariable("exp_bonus",  Number(GetValueWithLevel(challengeKV.exp_bonus,challengeLevel)*index).toFixed(0)   );
            bonusPanel.FindChildInLayoutFile("bonus_block_exp").SetHasClass("hidden",false);
        }else{
            bonusPanel.FindChildInLayoutFile("bonus_block_exp").SetHasClass("hidden",true);
        }
        if (challengeKV.aurum_bonus) {
            bonusPanel.SetDialogVariable("aurum_bonus",  Number(GetValueWithLevel(challengeKV.aurum_bonus,challengeLevel)*index).toFixed(1)   );
            bonusPanel.FindChildInLayoutFile("bonus_block_aurum").SetHasClass("hidden",false);
        }else{
            bonusPanel.FindChildInLayoutFile("bonus_block_aurum").SetHasClass("hidden",true);
            // 
        }
        if (challengeKV.bonus_type) {
            if (challengeKV.bonus_type==1) {
                bonusPanel.SetDialogVariable("bonus_target", $.Localize("#DOTA_Tooltip_EACH_PLAYER"));
            }
            
        }else{
            bonusPanel.SetDialogVariable("bonus_target", $.Localize("#DOTA_Tooltip_ALL_PLAYER"));
        }
        
    }
    
}

function ReplaceChallengeSpecial(specialValue,challenge_description,level) {
    for (let key in specialValue){
        let v = specialValue[key];
        // $.Msg(typeof(v));
        if (typeof(v)=="string"){
            let value = v.split(" ");
            challenge_description = challenge_description.replace(('<' + key + '>'), value[Math.min(level-1,value.length)].toString());
        }else{
            challenge_description = challenge_description.replace(('<' + key + '>'), v.toString());
        }
       
    }
    return challenge_description;
}

function ReplaceKeyWithValue(challenge_description,key,value) {
    challenge_description = challenge_description.replace(('<' + key + '>'), value.toString());
    return challenge_description;
}

function GetValueWithLevel(specialValue,level) {
    if (typeof(specialValue)=="string"){
        let value = specialValue.split(" ");
        return value[Math.min(level-1,value.length)];
    }else{
        return specialValue;
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


	if (tableKeyName == "player_count") {
        PlayerCount =Math.floor( Number(table.value));
    }

    if (tableKeyName == "base_bonus_congig") {
        configData = table;
    }
    if (tableKeyName == "game_round") {
        // configData
        game_round =Math.floor( Number(table.value));
    }

    
}



// .toFixed(0)

(function () {

    CustomUIConfig.SubscribeNetTableListener("game_config", UpdateCommonNetTable);
	UpdateCommonNetTable("game_config", "base_bonus_congig", CustomNetTables.GetTableValue("game_config", "base_bonus_congig"));
	UpdateCommonNetTable("game_config", "hd_game_mode", CustomNetTables.GetTableValue("game_config", "hd_game_mode"));

	UpdateCommonNetTable("game_config", "game_round", CustomNetTables.GetTableValue("game_config", "game_round"));

	// $.Schedule(0.1, Update);
})()





