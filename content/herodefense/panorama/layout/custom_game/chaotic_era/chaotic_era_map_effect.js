
let card_index = 0;
const global_game_effect_cardRoot = $("#global_game_effect_cardRoot");
const player_artifact_cardRoot = $("#player_artifact_cardRoot");
function InitMapEffectSelect(data) {

    let level = data.level;
    if (level==null) {
        global_game_effect_cardRoot.SetHasClass( "show", false);
        global_game_effect_cardRoot.FindChildInLayoutFile("ChaoticEra_GameEffect_Body").SetHasClass("show",false);
        return;
    }else{
        global_game_effect_cardRoot.SetHasClass( "show", true);
        global_game_effect_cardRoot.FindChildInLayoutFile("ChaoticEra_GameEffect_Body").SetHasClass("show",true);
    }
   
    let kv_keyName = "AbilityValues_Primary";
    if (level==2) {
        kv_keyName = "AbilityValues_Middle";
    }else if (level==3) {
        kv_keyName = "AbilityValues_Advanced";
    }


    // global_game_effect_cardRoot.SetHasClass( "show", true);
    global_game_effect_cardRoot.SetDialogVariable("level", $.Localize("#Map_Card_effect_level"+level))
    let cardPanel = global_game_effect_cardRoot.FindChildInLayoutFile("ChaoticEra_GameEffect_Body");
    
    if (data.card_index!=card_index) {
        cardPanel.RemoveAndDeleteChildren();
        card_index = data.card_index;
        global_game_effect_cardRoot.SetHasClass("hidden",false);
    }

    let cardList = data.list;
    for (const key in cardList) {
        if (Object.hasOwnProperty.call(cardList, key)) {
            const element = cardList[key];
            // $.Msg(element);
            let targetPanel = cardPanel.FindChildInLayoutFile(element.name);
            let kv =  GameUI.CustomUIConfig().ChaoticEra_MapEffect[element.name];
            if (targetPanel==null) {
                targetPanel = $.CreatePanel("Panel", cardPanel, element.name);
                targetPanel.BLoadLayoutSnippet("singleBuffCard"); //载入模块
                targetPanel.SetDialogVariable("title",$.Localize("#"+element.name));
    
                targetPanel.FindChildInLayoutFile("buffCardImage").style.backgroundImage = "url('"+ kv.image+"')";
                let info = $.Localize("#"+element.name+"_info");
                targetPanel.SetHasClass("level"+level,true);

                info = ReplaceSpecialWithKV(kv[kv_keyName],info);
                info = ChangeAllNumberColor(info,"#caa7e9");
                targetPanel.SetDialogVariable("effect",info);
                SelectBuffCard(targetPanel,element.name);
                targetPanel.SetHasClass("show",true);
            }

            if (true) {
                let selecter = element.selecter;
                let playerSelected= targetPanel.FindChildInLayoutFile("playerSelected");
                targetPanel.FindChildInLayoutFile("selectProgress_Left").style.width = element.progress*100+"%";
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
                        if (element>=1) {
                            targetPanel.SetHasClass("show",true);
                        }else{
                            targetPanel.SetHasClass("show",false);
                        }
                    }
                }
            }
        }
    }
}


function SelectBuffCard(targetPanel,name) {
	targetPanel.SetPanelEvent("onactivate", function () {
		var event_data = {
			name : name,
			player_id: Game.GetLocalPlayerID(),
		}
        // $.Msg(event_data);
		GameEvents.SendCustomGameEventToServer("SelectTargetBuffCard",  event_data );
    });
}



function ToggleGameEffectCard() {
    global_game_effect_cardRoot.ToggleClass("hidden");
}





let artifactIndex = -1;
function InitArtifactSelect(data) {
    // if (true) {
        $.Msg(data);
    //     return
    // }

    player_artifact_cardRoot.SetHasClass( "show", true);
    player_artifact_cardRoot.FindChildInLayoutFile("ChaoticEra_Artifact_Body").SetHasClass("show",true);

    let cardPanel = player_artifact_cardRoot.FindChildInLayoutFile("ChaoticEra_Artifact_Body");
    
    if (data.card_index!=artifactIndex) {
        cardPanel.RemoveAndDeleteChildren();
        artifactIndex = data.card_index;
    }
    let pass = false;
    let cardList = data.list;
    for (const key in cardList) {
        if (Object.hasOwnProperty.call(cardList, key)) {
            const element = cardList[key];
            // $.Msg(element);
            let targetPanel = cardPanel.FindChildInLayoutFile(element);
            let kv =  GameUI.CustomUIConfig().ChaoticEra_Artifact[element];
            if (targetPanel==null) {
                targetPanel = $.CreatePanel("Panel", cardPanel, element);
                targetPanel.BLoadLayoutSnippet("singleBuffCard"); //载入模块
                targetPanel.SetDialogVariable("title",$.Localize("#"+element));
    
                targetPanel.FindChildInLayoutFile("buffCardImage").style.backgroundImage = "url('"+ kv.image+"')";
                let info = $.Localize("#"+element+"_info");
                // targetPanel.SetHasClass("level"+level,true);

                info = ReplaceSpecialWithKV(kv["AbilityValues"],info);
                info = ChangeAllNumberColor(info,"#caa7e9");
                targetPanel.SetDialogVariable("effect",info);
                SelectArtifactCard(targetPanel,element);
                targetPanel.SetHasClass("show",true);
            }
            pass = true;
        }
    }
    if (!pass) {
        player_artifact_cardRoot.SetHasClass( "show", false);
        player_artifact_cardRoot.FindChildInLayoutFile("ChaoticEra_Artifact_Body").SetHasClass("show",false);
        // player_artifact_cardRoot.SetHasClass("hidden",true);
    }
}
function SelectArtifactCard(targetPanel,name) {
	targetPanel.SetPanelEvent("onactivate", function () {
		var event_data = {
			name : name,
			player_id: Game.GetLocalPlayerID(),
		}
        // $.Msg(event_data);
		GameEvents.SendCustomGameEventToServer("SelectTargetArtifact",  event_data );
    });
}


function ToggleArtifactCard() {
    player_artifact_cardRoot.ToggleClass("hidden");

}




  
function UpdateMapEffects() {
    const data = CustomNetTables.GetTableValue('game_config', 'chaoticEra_mapEffect_record');
    // $.Msg(data);
    // 检查 data 是否存在
    if (!data) return;

    let container = $("#mapEffectList");
    

    // 每次更新时删除所有面板
    container.RemoveAndDeleteChildren();

    // 遍历 data 对象，按次序创建面板

    for (const key in data) {
        if (data.hasOwnProperty(key)) {

            let element = data[key];
            let targetPanel;
            let kv =  GameUI.CustomUIConfig().ChaoticEra_MapEffect[element.name];
            if (kv) {
                targetPanel = $.CreatePanel("Panel", container, element.name);
                targetPanel.BLoadLayoutSnippet("singleMapEffect"); //载入模块
                // targetPanel.SetDialogVariable("title",$.Localize("#"+element.name));
                let level = element.level;

                let kv_keyName = "AbilityValues_Primary";
                if (level==2) {
                    kv_keyName = "AbilityValues_Middle";
                }else if (level==3) {
                    kv_keyName = "AbilityValues_Advanced";
                }
                let title = $.Localize("#"+element.name)
    
                targetPanel.FindChildInLayoutFile("singleMapEffectIcon").style.backgroundImage = "url('"+ kv.image+"')";
                let info = $.Localize("#"+element.name+"_info");
                // targetPanel.SetHasClass("level"+level,true);

                info = ReplaceSpecialWithKV(kv[kv_keyName],info);
                info = ChangeAllNumberColor(info,"#caa7e9");
                // targetPanel.SetDialogVariable("effect",info);
                // SelectBuffCard(targetPanel,element.name);
                // targetPanel.SetHasClass("show",true);
                // info = ChangeAllNumberColor(info,"#caa7e9");


                // $.Msg(info);
                let keys ={
                    title :title,
                    text : info,
                    
                }

                SetBaseAdavncedInfoHoverEvent(targetPanel,keys,false);
            }



            // const effectName = data[key];
            // // 生成唯一的 id，这里使用 key 作为 id 的一部分确保唯一性
            // const panelId = `MapEffectPanel_${key}`; 
            // // 创建面板时指定 id
            // const panel = $.CreatePanel('Panel', container, panelId); 
            // panel.BLoadLayoutSnippet('MapEffectSnippet');
            // // 创建 Label 组件来存储文字
            // const label = $.CreatePanel('Label', panel, `EffectNameLabel_${key}`);
            // label.AddClass('text-center')
            // label.text = $.Localize("#"+effectName);
        }
    }
}

CustomNetTables.SubscribeNetTableListener('game_config', UpdateMapEffects);
UpdateMapEffects();