
const AchievementWindowPanel = $("#playerAchievementMenuwindowROOT").FindChildTraverse("AchievementWindowPanel");

let achievement_list = {};
let customData;
let AchievementButton ={
   
}
AchievementButton[0] =  $("#playerAchievementMenuwindowROOT").FindChildTraverse("CheckAchievementButton1");
AchievementButton[1] =  $("#playerAchievementMenuwindowROOT").FindChildTraverse("CheckAchievementButton2");
AchievementButton[2] =  $("#playerAchievementMenuwindowROOT").FindChildTraverse("CheckAchievementButton3");
AchievementButton[3] =  $("#playerAchievementMenuwindowROOT").FindChildTraverse("CheckAchievementButton4");
function CheckAchievement(type){
    for (const key in AchievementButton) {
        if (Object.hasOwnProperty.call(AchievementButton, key)) {
            const element = AchievementButton[key];
            element.SetHasClass("achievement_active",false)
            
        }
    }
    Game.EmitSound( "ui_hero_select_slide" );
    AchievementButton[type-1].SetHasClass("achievement_active",true)
    // achievement_active
    if(!achievement_list[type]){
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            type:type,
        }
        if(!customData){
            event_data.getCustomData = true;
        }
        GameEvents.SendCustomGameEventToServer("GetAchievementList", event_data);
    }else{
        $.Msg("已经有了");
        CreateList(type);
    }

}


function GetAchievementList_FeedBack(keys){
    // $.Msg(keys);
    achievement_list[keys.type] = keys.list;
    if(keys.customData){
        customData = keys.customData;
        // $.Msg("获取自定义属性");
        // $.Msg(customData);
    }
    // $.Msg(achievement_list[keys.type]);
    CreateList(keys.type);
    // $.Schedule( 0.5, ()=>{
    //     CreateList(keys.type);
    // })
}
function CreateList(type){
    let list = achievement_list[type];
    AchievementWindowPanel.RemoveAndDeleteChildren();  //先清除

    let first_index = 0;
    let showSpace = false;
    let lastSpace;
    for (const key in list) {
        if (Object.hasOwnProperty.call(list, key)) {
            first_index++;
            const Achievement_series = list[key];
            let second_index = 0;
            let show_nextAchievement = true;
            showSpace = false;
            // let offect ="140px";
            for (const singleAchievementKey in Achievement_series) {
                if (Object.hasOwnProperty.call(Achievement_series, singleAchievementKey)) {
                    second_index++;
                    const data = Achievement_series[singleAchievementKey];
                    let customDataTarget = customData[data.custom_key];
                    if(customDataTarget){
                        // 拿到数据就进行下一步 不然就别创建了
                        // 配置完成进度
                        let valueNeed = data.value_require_1;
                        let currentValue = customDataTarget.valueOne;
                        currentValue = Math.min(currentValue,valueNeed);
                       
                        if(data.hide && data.hide==1 ){
                            if(currentValue<valueNeed){
                                // 隐藏的成就只有完成后才显示
                                if(data.notBreak&&data.notBreak==1){
                                    continue;
                                }else{
                                    break;
                                }
                                
                            }
                        }
                        showSpace =true;
                        ShopGoodPanel = $.CreatePanel("Panel", AchievementWindowPanel, "Achievement_" + first_index+"_"+second_index);
                        ShopGoodPanel.BLoadLayoutSnippet("SingleAchievementSnippet"); //载入模块
                        let styleData = data.style;
                        if(styleData.RelicImageInternal_image){
                            // $.Msg("设置图片");
                            ShopGoodPanel.FindChildInLayoutFile("RelicImageInternal1").style.backgroundImage = styleData.RelicImageInternal_image;
                            ShopGoodPanel.FindChildInLayoutFile("RelicImageInternal2").style.backgroundImage = styleData.RelicImageInternal_image;
                        };
                        if(styleData.RelicGlow_WashColor){
                            // $.Msg("设置颜色");
                            ShopGoodPanel.FindChildInLayoutFile("RelicGlow").style.washColor = styleData.RelicGlow_WashColor;
                        }
                        // $.Msg(styleData);
                        if(styleData.RelicImageInternal_image_margin_top){
                            // $.Msg("top offect");
                            ShopGoodPanel.FindChildInLayoutFile("RelicImageInternal1").style.marginTop = styleData.RelicImageInternal_image_margin_top;
                            ShopGoodPanel.FindChildInLayoutFile("RelicImageInternal2").style.marginTop = styleData.RelicImageInternal_image_margin_top;
                        }

                        let progressText = ShopGoodPanel.FindChildInLayoutFile("AchievementBar_Progress_text");

                        progressText.text = currentValue+" / "+valueNeed;
                        ShopGoodPanel.FindChildInLayoutFile("AchievementBar_Progress_Left").style.width = (currentValue/valueNeed*100)+"%";
                        // 看一下是否完成
                        let Achievement_StateInfoText = ShopGoodPanel.FindChildInLayoutFile("Achievement_StateInfoText");
                        let spellButton = ShopGoodPanel.FindChildInLayoutFile("GetAchievementBonusButton");
                        if(currentValue>=valueNeed){
                            // 那么就已经满足条件了
                            if(customDataTarget.recordDate){
                                if(customDataTarget.recordDate=="1"){
                                    Achievement_StateInfoText.text =  $.Localize("#DOTA_HUD_Achievement_state_4");
                                }else{
                                    Achievement_StateInfoText.text =  $.Localize("#DOTA_HUD_Achievement_state_3")+" "+customDataTarget.recordDate+" UTC+8";
                                }
                                spellButton.SetHasClass("unActive", true);
                            }else{
                                Achievement_StateInfoText.text =  $.Localize("#DOTA_HUD_Achievement_state_2");
                                // 这个状态下可以领取奖励
                                // 根据 type 位置 名字去拿奖励
                                
                                AddGetAchievementBonusEvent(spellButton,type,first_index,second_index,data.name)
                                spellButton.SetHasClass("active", true);
                            }
                        }else{
                            // 正在进行中 配置完成后直接break这个系列了 因为这个是系列成就
                            
                            if(data.notBreak&&data.notBreak==1){
                                // continue;
                            }else{
                                show_nextAchievement = false;
                            }
                            Achievement_StateInfoText.text =  $.Localize("#DOTA_HUD_Achievement_state_1");
                            spellButton.SetHasClass("unActive", true);
                        }
                        // if(styleData.Achievement_StateInfoIcon){
                        //     $.Msg("设置图标");
                        //     $.Msg(styleData.Achievement_StateInfoIcon);
                        //     ShopGoodPanel.FindChildInLayoutFile("Achievement_StateInfoIcon").style.backgroundImage = styleData.Achievement_StateInfoIcon;
                        //     ShopGoodPanel.FindChildInLayoutFile("Achievement_StateInfoIcon_right").style.backgroundImage = styleData.Achievement_StateInfoIcon;
                        // }
                        // 配置介绍
                        ShopGoodPanel.FindChildInLayoutFile("AchievementTitle").text =  $.Localize("#"+data.name+"_title");
                        ShopGoodPanel.FindChildInLayoutFile("AchievementInfo").text =  $.Localize("#"+data.name+"_Description");
                        ShopGoodPanel.FindChildInLayoutFile("AchievementInfo2").text =  $.Localize("#"+data.name+"_Lore");
                        // 配置奖励
                        let bonus = data.bonus;
                        if(bonus){
                            if(bonus.exp){
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_1").SetDialogVariable("value1", bonus.exp);
                            }else{
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_1").SetDialogVariable("value1", 0);
                            };
                            if(bonus.aurum){
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_2").SetDialogVariable("value1", bonus.aurum);
                            }else{
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_2").SetDialogVariable("value1", 0);
                            };
                            if(bonus.platinum){
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_3").SetDialogVariable("value1", bonus.platinum);
                            }else{
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_3").SetDialogVariable("value1", 0);
                            };
                            if(bonus.coreRollTime){
                                let info = bonus.coreRollTime+" x "+bonus.coreCount;
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_4").SetDialogVariable("value1", info);
                            }else{
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_4").SetDialogVariable("value1", 0);
                            };
                            if(bonus.secret){
                                
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_5").SetDialogVariable("value1",  $.Localize("#DOTA_HUD_Unknow"));
                            }else{
                                ShopGoodPanel.FindChildInLayoutFile("AchievementBonus_5").SetDialogVariable("value1",  $.Localize("#DOTA_HUD_Nope"));
                            };
                        }

                        // 系列成就的间隔
                        // ShopGoodPanel.FindChildInLayoutFile("AchievementSpace").style.width = offect;
                        // offect = "180px";
                        if(!show_nextAchievement){
                            break;
                        }
            
                    }
                }
            }
 
            if(showSpace){
                // SingleAchievementSnippet_space
                lastSpace = $.CreatePanel("Panel", AchievementWindowPanel, "Achievement_space_" + first_index);
                lastSpace.BLoadLayoutSnippet("SingleAchievementSnippet_space"); //载入模块
            }

        }
    }
    if(lastSpace){
        lastSpace.DeleteAsync(0);
    }
}



function AddGetAchievementBonusEvent(spellButton,type,first_index,second_index,Name) {
    // spellButton.SetPanelEvent("onactivate", Function("ShiftParticle(\'" + Name + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        GetAchievementBonus(type,first_index,second_index,Name);
    });
}

function GetAchievementBonus(type,first_index,second_index,Name){
    // $.Msg("ok")
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        type:type,
        first_index:first_index,
        second_index:second_index,
        Name:Name,
    }
    GameEvents.SendCustomGameEventToServer("GetAchievementBonus", event_data);
}


const AchievementBroadcast_root = $("#AchievementBroadcast_root");
let count = 0;
AchievementBroadcast_root.RemoveAndDeleteChildren();  //先清除



function PlayerAchievementReceive(keys){
    count++;
    // single_AchievementBroadcastSnippet
    // var newNotification = true;
    // var lastNotification = panel.GetChild(panel.GetChildCount() - 1)
    Game.EmitSound( keys.sound );
    let ShopGoodPanel = $.CreatePanel("Panel", AchievementBroadcast_root, "Achievement_receive" + count);
    ShopGoodPanel.BLoadLayoutSnippet("single_AchievementBroadcastSnippet"); //载入模块
    let data = keys.list;
    let styleData = data.style;
    if(styleData.RelicImageInternal_image){
        // $.Msg("设置图片");
        ShopGoodPanel.FindChildInLayoutFile("RelicImageInternal1").style.backgroundImage = styleData.RelicImageInternal_image;
        ShopGoodPanel.FindChildInLayoutFile("RelicImageInternal2").style.backgroundImage = styleData.RelicImageInternal_image;
    };
    if(styleData.RelicGlow_WashColor){
        // $.Msg("设置颜色");
        ShopGoodPanel.FindChildInLayoutFile("RelicGlow").style.washColor = styleData.RelicGlow_WashColor;
        ShopGoodPanel.FindChildInLayoutFile("BackgroundFX2").style.washColor = styleData.RelicGlow_WashColor;
        ShopGoodPanel.FindChildInLayoutFile("BackgroundFX").style.washColor = styleData.RelicGlow_WashColor;

        
    }
    // $.Msg(styleData);
    if(styleData.RelicImageInternal_image_margin_top){
        // $.Msg("top offect");
        ShopGoodPanel.FindChildInLayoutFile("RelicImageInternal1").style.marginTop = styleData.RelicImageInternal_image_margin_top;
        ShopGoodPanel.FindChildInLayoutFile("RelicImageInternal2").style.marginTop = styleData.RelicImageInternal_image_margin_top;
    }
    ShopGoodPanel.FindChildInLayoutFile("AchievementBroadcast_playerAvatar").accountid = keys.dota2ID;
    ShopGoodPanel.FindChildInLayoutFile("AchievementBroadcast_userName").accountid = keys.dota2ID;
    ShopGoodPanel.FindChildInLayoutFile("AchievementBroadcast_info").SetDialogVariable("value1", $.Localize("#"+data.name+"_title"));



    $.Schedule(7, function(){
        ShopGoodPanel.SetHasClass("hide",true);
        $.Schedule(0.5, function(){
            ShopGoodPanel.DeleteAsync(0);
        });
        
       
    });
  

}

// 监听反馈
(function () {

    GameEvents.Subscribe("GetAchievementList_FeedBack", GetAchievementList_FeedBack); //得到玩家数据反馈

    GameEvents.Subscribe("PlayerAchievementReceive", PlayerAchievementReceive); //得到玩家数据反馈


    
})();





