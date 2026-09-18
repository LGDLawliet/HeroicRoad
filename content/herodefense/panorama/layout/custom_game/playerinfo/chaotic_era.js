var CustomUIConfig = GameUI.CustomUIConfig();
let RuneKV = CustomUIConfig.ChaoticSpellRuneKV;
const ChaoticEra_subdivision_left_block = $("#ChaoticEra_subdivision_left_block");
const ChaoticEra_spellList  = $("#ChaoticEra_spellList");
const ChaoticEraRuneModify_Button_4 =  $("#ChaoticEraRuneModify_Button_4");
let currentActiveButton;
let runeData = {};  //符石数据
function OpenChaoticSpellList(level){
    $.Msg("level=",level);


    let targetButton = ChaoticEra_subdivision_left_block.FindChildTraverse("ChaoticEraSpellButton_"+level);
    if (currentActiveButton) {
        currentActiveButton.SetHasClass("Active", false);
    }
    if (targetButton) {
        targetButton.SetHasClass("Active", true);
        currentActiveButton = targetButton;
    
        CreateSpellList(level);
    }

}


function ChaoticEraListSubdivisionOn(key) {
    $.Msg("check");
}

function ChaoticEraListSubdivisionOff(key) {
    $.Msg("check");
}

function CreateSpellList(level) {
    ChaoticEra_spellList.RemoveAndDeleteChildren();
    // ChaoticSpellKV_class5
    let targetKv = CustomUIConfig["ChaoticSpellKV_class"+level];
    
    if (targetKv) {
        // $.Msg(targetKv);

        let i = 0;
        for (const spellName in targetKv) {
            // $.Msg("spellName=",spellName);
            if (CustomUIConfig.AbilitiesKv[spellName]) {
                const element = targetKv[spellName];
                i++;
                // $.Msg(element);
                spellPanel = $.CreatePanel("Panel", ChaoticEra_spellList, "spellPanel" + i);
                spellPanel.BLoadLayoutSnippet("general_spell"); //载入模块
                var image = spellPanel.FindChildInLayoutFile("single_general_spell"); //找到图片
                spellPanel.SetDialogVariable("spellName",$.Localize("#DOTA_Tooltip_ability_"+spellName));
                var SpellLevel= spellPanel.FindChildInLayoutFile("spell_type_label");
                var spellButton = spellPanel.FindChildInLayoutFile("single_general_spellButton");
    
                image.abilityname = spellName;
                if (CustomUIConfig.AbilityBonusInfoKV[spellName]) {
                    SpellLevel.text = $.Localize(CustomUIConfig.AbilityBonusInfoKV[spellName]["ChaoticSpellType"]);
                }
              
    
                addSpellInfoHoverEvens(spellPanel,spellName);
                AddChaoticSpellCheckRuneEvent(spellPanel,spellName);
            }else{
                $.Msg("缺失的本地技能数据ustomUIConfig.AbilitiesKv[spellName] spellName=",spellName);
            }
          
        }
    }
}

const ChaoticEra_rune_content =  $("#ChaoticEra_rune_content");
function AddChaoticSpellCheckRuneEvent(targetPanel,spellName) {
	targetPanel.SetPanelEvent("onactivate", function () {
        CreateRuneList(spellName,true);

    });


    // LOCAL_DEBUG_TOOLS_SPELL_MENU


}


function GetChaoticEraRuneData(){
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("GetChaoticEraRuneData", event_data);
}


let runeTransfer = null;
let completedRuneTransfer = 0;
function OnGetChaoticEraRuneData__Feedback(keys){
    const id = Number(keys.transferId);
    const part = Number(keys.part);
    const total = Number(keys.total);
    if (!id || id <= completedRuneTransfer || part < 1 || part > total) return;
    if (runeTransfer && id < runeTransfer.id) return;
    if (!runeTransfer || id > runeTransfer.id) {
        runeTransfer = {id: id, total: total, parts: {}, count: 0};
    }
    if (total !== runeTransfer.total || runeTransfer.parts[part] !== undefined) return;
    let records;
    try { records = JSON.parse(keys.payload); }
    catch (error) { $.Msg("Invalid rune inventory chunk", error); return; }
    if (!Array.isArray(records)) return;
    runeTransfer.parts[part] = records;
    runeTransfer.count++;
    if (runeTransfer.count !== total) return;

    // Replace the list only after receiving a complete, current snapshot.
    const nextData = {};
    for (let index = 1; index <= total; index++) {
        runeTransfer.parts[index].forEach(function (rune) {
            const skill = rune.correspondingSkill;
            if (!nextData[skill]) nextData[skill] = {runeSet: {}};
            nextData[skill].runeSet[String(rune.runeId)] = rune;
            if (Number(rune.isEquip) === 1) nextData[skill].on_Rune = rune.runeId;
        });
    }
    runeData = nextData;
    completedRuneTransfer = id;
    runeTransfer = null;
    if (current_spellName) CreateRuneList(current_spellName, false);
}

let current_spellName; //当前查看的符石
// Single_Rune_Snippet
let currentRuneSelected;
let currentSeleceRuneData;

function CreateRuneList(spellName,bShowFadein){
    current_spellName = spellName;
    if (GameUI.CustomUIConfig().ChaoticSpellRuneKV[spellName]) {
        $.Msg("有符石");
        ChaoticEraRuneModify_Button_4.SetHasClass("hidden",false);
    }else{
        $.Msg("没有符石");
        ChaoticEraRuneModify_Button_4.SetHasClass("hidden",true);
    }
    let targetData = runeData[spellName];
    ChaoticEra_rune_content.RemoveAndDeleteChildren();
    if (targetData!=null) {
        // let on_RuneID = -1;
        // $.Msg("spellName=",spellName);
       
        let i = 0
        Game.EmitSound( "ui.inv_drop_stone" );
        currentRuneSelected=null;
        for (const key in targetData.runeSet) {
            if (Object.hasOwnProperty.call(targetData.runeSet, key)) {
                i++;
                const data = targetData.runeSet[key];
                let runePanel = $.CreatePanel("Panel", ChaoticEra_rune_content, "rune_" + i);
                if (bShowFadein) {
                    runePanel.SetHasClass("hasFade",true);
                }
                SetUpRuneInfo(runePanel,data,false);
            }
        }
    }
}



function SetUpRuneInfo(runePanel,data,bOnlyShow) {
  

 
    runePanel.BLoadLayoutSnippet("Single_Rune_Container"); //载入模块
    runePanel.SetHasClass("Show",true);

    let singlerune = $.CreatePanel("Panel", runePanel.FindChildInLayoutFile("runeContainer"), "singlerune_" + i);
    singlerune.BLoadLayoutSnippet("Single_Rune_Snippet"); //载入模块
    
    singlerune.FindChildInLayoutFile("RuneImageInternal").abilityname = data.correspondingSkill;
    singlerune.FindChildInLayoutFile("second_layer").SetHasClass("level"+data.rarity,true);
    singlerune.FindChildInLayoutFile("RuneImageOverlay").SetHasClass("level"+data.rarity,true);
    singlerune.FindChildInLayoutFile("RuneImageBorder").SetHasClass("level"+data.rarity,true);
    singlerune.FindChildInLayoutFile("RuneGlow").SetHasClass("level"+data.rarity,true);
    singlerune.FindChildInLayoutFile("RuneLevelLabel").text = $.Localize("#HUD_Level"+data.rarity);


    singlerune.SetPanelEvent("onmouseover", function () {
        let jsonData = JSON.stringify(data);
        $.DispatchEvent("UIShowCustomLayoutParametersTooltip", singlerune, "rune_info_tooltip", "file://{resources}/layout/custom_game/tooltips/rune_info/rune_info.xml", "data=" + jsonData);
    });

    singlerune.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("UIHideCustomLayoutTooltip", singlerune, "rune_info_tooltip");
    });


    if (bOnlyShow) {
        return
    }
	singlerune.SetPanelEvent("onactivate", function () {
        singlerune.FindChildInLayoutFile("Single_Rune_Image").SetHasClass("active",true);
        // $.Msg(currentRuneSelected);
        
        if (currentRuneSelected!=null) {
            currentRuneSelected.FindChildInLayoutFile("Single_Rune_Image").SetHasClass("active",false);
        }
        currentRuneSelected = singlerune;
        currentSeleceRuneData = {
            correspondingSkill : data.correspondingSkill,
            runeId :data.runeId,
        };
    });

  
    if (data.isEquip==1) {
        runePanel.FindChildInLayoutFile("StatusLabel0").SetHasClass("Visible",false);
        runePanel.FindChildInLayoutFile("StatusLabel1").SetHasClass("Visible",true);

    }else{
        runePanel.FindChildInLayoutFile("StatusLabel0").SetHasClass("Visible",true);
        runePanel.FindChildInLayoutFile("StatusLabel1").SetHasClass("Visible",false);
        let actionButton =  runePanel.FindChildInLayoutFile("ActionButton");
        runePanel.FindChildInLayoutFile("itemInfoContainer").SetPanelEvent("onmouseover", function () {
            actionButton.SetHasClass("Visible",true);
        });
        runePanel.FindChildInLayoutFile("itemInfoContainer").SetPanelEvent("onmouseout", function () {
            actionButton.SetHasClass("Visible",false);
        });
        actionButton.SetPanelEvent("onactivate", function () {
            EquipTargetRune(data);
        });
    }
    runePanel.FindChildInLayoutFile("RuneLockButton").SetHasClass("show",true);
    if (data.locked==1) {
        runePanel.FindChildInLayoutFile("RuneLockButton").SetHasClass("lock",true);
    }else{
        runePanel.FindChildInLayoutFile("RuneLockButton").SetHasClass("lock",false);
    }

    runePanel.FindChildInLayoutFile("RuneLockButton").SetPanelEvent("onactivate", function () {
        LockRuneEvent(data);
    });



}

function LockRuneEvent(data) {
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        spell_name : data.correspondingSkill,
        runeId : data.runeId,
    };

    GameEvents.SendCustomGameEventToServer("ChangeRuneLockState", event_data);
}



function EquipTargetRune(data) {
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        spell_name : data.correspondingSkill,
        runeId : data.runeId,
    };

    GameEvents.SendCustomGameEventToServer("EquipTargetRune", event_data);
}


function OpenRuneModify(index) {
    if (index==1) {
        OpenRuneDelMenu();
    }else if (index==3) {
        OpenRuneEditMenu();
    }else if (index==4) {
        // $.Msg("dasdfas");
        if (current_spellName) {
            BuyGood_Rune(current_spellName);
        }
        
        // addChaoticEraSpellRune(spellButton,individualHeroSpell)
    }
}


let title = $.Localize("#DOTA_Tooltip_ability_buy_rune_target");
let info = $.Localize("#DOTA_Tooltip_ability_buy_rune_target_Description");
let keys ={
    title :title,
    text : info,
    
}

SetBaseAdavncedInfoHoverEvent(ChaoticEraRuneModify_Button_4,keys);

const ChaoticEra_Rune_modifyBlockRoot = $("#ChaoticEra_Rune_modifyBlockRoot");
const ChaoticEra_Rune_DelBlockRoot = $("#ChaoticEra_Rune_DelBlockRoot");
// 打开魔改窗口
function OpenRuneEditMenu() {
    if (currentRuneSelected!=null) {


        let data = runeData[currentSeleceRuneData.correspondingSkill].runeSet[currentSeleceRuneData.runeId];
        ToggleModifyBlock();

        let runePanel = ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("runeContainer_Modify");
        runePanel.RemoveAndDeleteChildren();
        let singlerune = $.CreatePanel("Panel", runePanel, "singlerune");
        singlerune.BLoadLayoutSnippet("Single_Rune_Snippet"); //载入模块
        singlerune.SetHasClass("big",true);
        singlerune.FindChildInLayoutFile("RuneImageInternal").abilityname = data.correspondingSkill;
        singlerune.FindChildInLayoutFile("second_layer").SetHasClass("level"+data.rarity,true);
        singlerune.FindChildInLayoutFile("RuneImageOverlay").SetHasClass("level"+data.rarity,true);
        singlerune.FindChildInLayoutFile("RuneImageBorder").SetHasClass("level"+data.rarity,true);
        singlerune.FindChildInLayoutFile("RuneGlow").SetHasClass("level"+data.rarity,true);
        singlerune.FindChildInLayoutFile("RuneLevelLabel").text = $.Localize("#HUD_Level"+data.rarity);
        singlerune.SetPanelEvent("onmouseover", function () {
            let jsonData = JSON.stringify(data);
            $.DispatchEvent("UIShowCustomLayoutParametersTooltip", singlerune, "rune_info_tooltip", "file://{resources}/layout/custom_game/tooltips/rune_info/rune_info.xml", "data=" + jsonData);
        });
        singlerune.SetPanelEvent("onmouseout", function () {
            $.DispatchEvent("UIHideCustomLayoutTooltip", singlerune, "rune_info_tooltip");
        });

        Switch_EditBonus_value();




    }else{

        let data={
            message:"HUD_NO_SELECT_RUNE",
            sound:"General.Cancel",
        }
        SendCustomErroMessage(data);
    }
}

let delIdList = {};
let delExpValue = [];
let delAurumValue = [];
let currentDelExp = 0;
let currentAurum = 0;

function OpenRuneDelMenu() {
    ToggleDelBlock();
    let content = ChaoticEra_Rune_DelBlockRoot.FindChildInLayoutFile("rube_BonusEdit_Content");
    UpdatePlayerCurrency__Rune_Del();
    content.RemoveAndDeleteChildren();
    delIdList = {};
    fliterState= [
        false,false,false,false,false,false
    ];
    currentDelExp = 0;
    currentAurum = 0;
    delExpValue =[
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_1"].value1,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_2"].value1,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_3"].value1,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_4"].value1,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_5"].value1,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_6"].value1,
    ];
    delAurumValue =[
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_1"].value2,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_2"].value2,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_3"].value2,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_4"].value2,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_5"].value2,
        GameUI.CustomUIConfig().BaseSetting_KV["Rune_Del_return_6"].value2,
    ];
    ChaoticEra_Rune_DelBlockRoot.SetDialogVariable("exp",currentDelExp);
    ChaoticEra_Rune_DelBlockRoot.SetDialogVariable("aurum",currentAurum);
    for (const key in runeData) {
        if (Object.hasOwnProperty.call(runeData, key)) {
            const singleAbilityData = runeData[key].runeSet;
            for (const runeId in singleAbilityData) {
                if (Object.hasOwnProperty.call(singleAbilityData, runeId)) {
                    const singleRuneData = singleAbilityData[runeId];
                    if (singleRuneData.isEquip==1) {
                        // $.Msg("这是被装备的符石");
                        continue;
                    }
                    if (singleRuneData.locked==1) {
                        // $.Msg("这是被锁定的符石");
                        continue;
                    }
                    let runePanel = $.CreatePanel("Panel", content, "rune_" + singleRuneData.runeId);
                    runePanel.BLoadLayoutSnippet("single_runeDelContainer"); //载入模块
                    SetUpRuneInfo(runePanel.FindChildInLayoutFile("runeContainer"),singleRuneData,true);
                    runePanel.FindChildInLayoutFile("itemInfoContainer").SetHasClass("hide",true);
                    let RuneChecking = runePanel.FindChildInLayoutFile("RuneChecking");
                    RuneChecking.runeData = {
                        id:singleRuneData.runeId,
                        rarity:singleRuneData.rarity,
                        spellName :singleRuneData.correspondingSkill,
                    }
                    SetUpDelEvent(RuneChecking,singleRuneData.runeId,singleRuneData.rarity,singleRuneData.correspondingSkill);
                }
            }

        }
    }
    // single_runeDelContainer
}


function SetUpDelEvent(panel,id,rarity,spellName) {
    panel.SetPanelEvent("onselect", function () {
        AddRuneToDelList(id,rarity,spellName);
        // $.Msg(delIdList);
    });

    panel.SetPanelEvent("ondeselect", function () {
        RemoveRuneFromDelList(id,rarity);
    });
}
function AddRuneToDelList(id,rarity,spellName) {

    currentDelExp = currentDelExp + delExpValue[rarity-1];
    currentAurum = currentAurum + delAurumValue[rarity-1];
    delIdList[id] = {
        rarity :rarity,
        spellName:spellName,
    };

    ChaoticEra_Rune_DelBlockRoot.SetDialogVariable("exp",currentDelExp);
    ChaoticEra_Rune_DelBlockRoot.SetDialogVariable("aurum",currentAurum);
}
function RemoveRuneFromDelList(id) {

    if (delIdList[id]==null) {
        return;
    }

    currentDelExp = currentDelExp - delExpValue[delIdList[id].rarity-1];
    currentAurum = currentAurum - delAurumValue[delIdList[id].rarity-1];
    delete delIdList[id];
    
    ChaoticEra_Rune_DelBlockRoot.SetDialogVariable("exp",currentDelExp);
    ChaoticEra_Rune_DelBlockRoot.SetDialogVariable("aurum",currentAurum);
}


let fliterState= [
    false,false,false,false,false,false
]
function RuneDelFliter(level){
    // $.Msg(level);
    if (fliterState[level]==true) {
        fliterState[level] = false;
    }else{
        fliterState[level] = true;
    }
    let runeList = ChaoticEra_Rune_DelBlockRoot.FindChildInLayoutFile("rube_BonusEdit_Content").Children();
    for (let index = 0; index < runeList.length; index++) {
        const element = runeList[index];
        let RuneChecking = element.FindChildInLayoutFile("RuneChecking");
        // $.Msg("RuneChecking.rarity=",RuneChecking.runeData.rarity);
        if (RuneChecking.runeData.rarity==level) {
            if (RuneChecking.checked!=fliterState[level]) {
                RuneChecking.checked = fliterState[level];
                // if (fliterState[level]==true) {
                //     AddRuneToDelList(RuneChecking.runeData.id,RuneChecking.runeData.rarity);
                // }else{
                //     RemoveRuneFromDelList(RuneChecking.runeData.id);
                // }
            }
            
        }
    }
}

function ToggleModifyBlock() {
    ChaoticEra_Rune_modifyBlockRoot.ToggleClass("show");
}
function ToggleDelBlock() {
    ChaoticEra_Rune_DelBlockRoot.ToggleClass("show");
}

function OnOpenRuneEditWindow_BonusValue(keys) {
    currentSeleceRuneData = {
        correspondingSkill : keys.correspondingSkill,
        runeId :keys.runeId,
        currentSelectSpecialName:currentSelectSpecialName,
    };
    Switch_EditBonus_value();
}



let currentRuneEditSelectButton;
let currentSelectSpecialName;
function Switch_EditBonus_value() {
    ChangeEditButton(ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("ChaoticEraRuneEditButton1"));
    UpdatePlayerCurrency__Rune();
    let data = runeData[currentSeleceRuneData.correspondingSkill].runeSet[currentSeleceRuneData.runeId];


    let targetAbility = data.correspondingSkill;
    if (RuneKV[targetAbility]==null) {
        $.Msg("错误：没找到符石信息");
        return;
    }
    let bonusList_content = ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("bonusList_content");
    bonusList_content.RemoveAndDeleteChildren();
    {
        let specialKV = RuneKV[targetAbility].special;
        if (specialKV==null) {
            $.Msg("错误：没找到符石specialKV",targetAbility);
            return;
        }
        let special = data.specicaValue;
        let KV_Prefix= "#DOTA_Tooltip_ability_"+targetAbility+"_";

        let level = Math.min(data.rarity,5);  //注意：至宝等级不加数值！！！！！！！
        let i = 0;

        special = GeneralSoft(special);  //排序一下

     
        for (const key in special) {
            if (specialKV[key]) {
                i++;
                let targetPanel = $.CreatePanel("Panel", bonusList_content, "bonusInfoRoot_"+i);
                targetPanel.BLoadLayoutSnippet("single_runeBonusEditOption"); //载入模块
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
                let defaultKey = "#HUD_Spell_Rune_"+currentSeleceRuneData.correspondingSkill+"_"  +key;
                if (defaultKey!=$.Localize(defaultKey)) {
                    keyLocalize = $.Localize(defaultKey);
                }else{
                    keyLocalize = $.Localize(KV_Prefix+key);
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
                targetPanel.BLoadLayoutSnippet("specialBonus"); //载入模块
                targetPanel.SetDialogVariable("header",keyLocalize);
                // if (specialKV[key].Type==RUNE_BONUS_TYPE_Percentage) {
                //     realBonusValue=  CheckBonusColor(bonus,"+"+realBonusValue+"%");
                //     targetPanel.SetDialogVariable("bonus",realBonusValue);
                // }else{
                //     realBonusValue=  CheckBonusColor(bonus,realBonusValue);
                //     targetPanel.SetDialogVariable("bonus","+"+realBonusValue);
                // }


                if (specialKV[key].Type==RUNE_BONUS_TYPE_Percentage) {
                    realBonusValue=  CheckBonusColor(bonus,"+"+realBonusValue+"%");
                    targetPanel.SetDialogVariable("bonus",realBonusValue);
                }else if (specialKV[key].Type==RUNE_BONUS_TYPE_Neg_Percentage) {
                    // $.Msg("sasadsa")
                    realBonusValue=  CheckBonusColor(bonus,"-"+realBonusValue+"%");
                    targetPanel.SetDialogVariable("bonus",realBonusValue);
                }else{
                    realBonusValue=  CheckBonusColor(bonus,realBonusValue);
                    targetPanel.SetDialogVariable("bonus","+"+realBonusValue);
                }
               

                
                targetPanel.SetDialogVariable("bonus_interval",bonus_intervalInfo);
                let radioButton = targetPanel.FindChildInLayoutFile("runeBonusRadioButton");
                if (currentSeleceRuneData.currentSelectSpecialName && currentSeleceRuneData.currentSelectSpecialName==key) {
                    radioButton.checked = true;
                    currentSelectSpecialName = key;
                }else{
                    if (i==1) {
                        radioButton.checked = true;
                        currentSelectSpecialName = key;
                    }
                }
        
                radioButton.SetPanelEvent("onselect", function () {
                    currentSelectSpecialName = key;
                });
                
            }else{
                $.Msg("Error:没找到key",targetAbility,key);
            }
        }

        // 键值对
    }
    ChaoticEra_Rune_modifyBlockRoot.SetDialogVariable("modify_count",data.modifyCount);

    {
        let button = ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("runeEdit_1");
        button.ClearPanelEvent("onactivate");


        let exp_cost = ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("exp_cost");
        let cost = 1000+(Number(data.modifyCount)+1)*1000;
        exp_cost.text = cost;
        if (playerData.spellmap.spellmap.playerinfo.reliableExp<cost) {
            exp_cost.SetHasClass("redColored",true);
            button.SetHasClass("disable",true);
        }else{
            exp_cost.SetHasClass("redColored",false);
            button.SetHasClass("disable",false);
            button.SetPanelEvent("onactivate", function () {
                EditRuneBonusValue(targetAbility,currentSelectSpecialName,data.runeId,1);
            });
        }

    }
    {
        let button = ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("runeEdit_2");
        button.ClearPanelEvent("onactivate");
     
        let aurum_cost = ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("aurum_cost");
        let cost = 50+(Number(data.modifyCount)+1)*20;
        aurum_cost.text = cost;
        if (playerData.spellmap.spellmap.playerinfo.gold<cost) {
            aurum_cost.SetHasClass("redColored",true);
            button.SetHasClass("disable",true);
        }else{
            aurum_cost.SetHasClass("redColored",false);
            button.SetHasClass("disable",false);
            button.SetPanelEvent("onactivate", function () {
                EditRuneBonusValue(targetAbility,currentSelectSpecialName,data.runeId,2);
            });
        }
    }
    {
        let button = ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("runeEdit_3");
        button.ClearPanelEvent("onactivate");
        
        let platinum_cost = ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("platinum_cost");
        let cost = (Number(data.modifyCount)+1)*2;
        cost = Math.min(cost,200);
        platinum_cost.text = cost;
        if (playerData.spellmap.spellmap.playerinfo.platinum<cost) {
            platinum_cost.SetHasClass("redColored",true);
            button.SetHasClass("disable",true);
        }else{
            platinum_cost.SetHasClass("redColored",false);
            button.SetHasClass("disable",false);
            button.SetPanelEvent("onactivate", function () {
                EditRuneBonusValue(targetAbility,currentSelectSpecialName,data.runeId,3);
            });
        }
       

    }

    // 如果已装备 那么关闭窗口  但是仍然会跑完流程
    // if ( data.isEquip==1) {
    //     var message = "HUD_Rune_error_1";
    //     var sound = "General.Cancel";
    //     GameUI.SendCustomHUDError( message, sound );
    //     ToggleModifyBlock();
    // }
}



function ChangeEditButton(targetButton) {
    if (currentRuneEditSelectButton!=null) {
        currentRuneEditSelectButton.SetHasClass("Active",false);
    }

    currentRuneEditSelectButton  = targetButton;
    currentRuneEditSelectButton.SetHasClass("Active",true);
}


function UpdatePlayerCurrency__Rune(){
    // $.Msg(exp_number);
    ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("ReliableExperienceCurrency_number").text = playerData.spellmap.spellmap.playerinfo.reliableExp;
    ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("GoldCurrency_number").text = playerData.spellmap.spellmap.playerinfo.gold;
    ChaoticEra_Rune_modifyBlockRoot.FindChildInLayoutFile("PlatinumCurrency_number").text = playerData.spellmap.spellmap.playerinfo.platinum;
    
}
function UpdatePlayerCurrency__Rune_Del(){
    // $.Msg(exp_number);
    ChaoticEra_Rune_DelBlockRoot.FindChildInLayoutFile("ReliableExperienceCurrency_number").text = playerData.spellmap.spellmap.playerinfo.reliableExp;
    ChaoticEra_Rune_DelBlockRoot.FindChildInLayoutFile("GoldCurrency_number").text = playerData.spellmap.spellmap.playerinfo.gold;
    ChaoticEra_Rune_DelBlockRoot.FindChildInLayoutFile("PlatinumCurrency_number").text = playerData.spellmap.spellmap.playerinfo.platinum;
    
}

let costTyle = -1;
let current_spell_name;
let current_currentSelectSpecialName;
let current_runeId = -1;

// 重新随机词条数值
function EditRuneBonusValue(targetAbility,currentSelectSpecialName,runeId,index) {
    // $.Msg("targetAbility",targetAbility);
    // $.Msg("currentSelectSpecialName",currentSelectSpecialName);
    costTyle = index;
    current_spell_name = targetAbility;
    current_currentSelectSpecialName = currentSelectSpecialName;
    current_runeId = runeId;
    let data = runeData[targetAbility].runeSet[runeId];
    if (data) {
		
		let kv = data.specicaValue;
        if (kv[currentSelectSpecialName]>=0.85) {
            // $.Msg("checking");
            $("#runeModifyConfirmPanel").SetHasClass("show",true);
            return;
        }

	}



    // $.Msg("runeId",runeId);
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        costTyle : costTyle,
        spell_name:current_spell_name,
        currentSelectSpecialName:current_currentSelectSpecialName,
        runeId:current_runeId,

    }
    GameEvents.SendCustomGameEventToServer("EditRuneBonusValue", event_data);
}

function ConfirmRuneModify() {



	$("#runeModifyConfirmPanel").SetHasClass("show",false);
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        costTyle : costTyle,
        spell_name:current_spell_name,
        currentSelectSpecialName:current_currentSelectSpecialName,
        runeId:current_runeId,

    }
    GameEvents.SendCustomGameEventToServer("EditRuneBonusValue", event_data);
}

function CancleConfirmRuneModify() {
	$("#runeModifyConfirmPanel").SetHasClass("show",false);

}


function ConfirmDelRune(){
    let pass = false;
    for (const key in delIdList) {
        if (Object.hasOwnProperty.call(delIdList, key)) {
            const element = delIdList[key];
            pass = true;
            break;
        }
    }
    if (pass) {
        ChaoticEra_Rune_DelBlockRoot.SetHasClass("show",false);
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            delIdList : delIdList,
        }
        GameEvents.SendCustomGameEventToServer("DelRuneList", event_data); 
    }
    
}

// 监听反馈
(function () {

    GameEvents.Subscribe("GetChaoticEraRuneData__Feedback", OnGetChaoticEraRuneData__Feedback); 
    GameEvents.Subscribe("OpenRuneEditWindow_BonusValue", OnOpenRuneEditWindow_BonusValue); 


    

})();





