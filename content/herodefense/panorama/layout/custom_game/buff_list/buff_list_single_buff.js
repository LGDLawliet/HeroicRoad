// var HUD = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent();
// const ChatLinesPanel = HUD.FindChildTraverse("HudChat").FindChildTraverse("ChatLinesPanel");
// $.Msg(ChatLinesPanel);

const HUD = (() => {
    let panel = $.GetContextPanel();
    while (panel) {
        if (panel.id === "DotaHud") return panel;
        panel = panel.GetParent();
    }
})();
// $.Msg(HUD.FindChildTraverse("RadiantPlayer0").FindChildTraverse("SlantedContainerPanel").FindChildTraverse("HeroImage"));
const ChatLinesPanel = HUD.FindChildTraverse("HudChat").FindChildTraverse("ChatLinesPanel");
const ChatLineTime = 5;
function OnBuffClicked(queryUnit,buffSerial,buffindex)
{
	var alertBuff = GameUI.IsAltDown();
    if (alertBuff) {
        // $.Msg("buffSerial="+buffSerial);
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            queryUnit :queryUnit,
            buffSerial: buffSerial,
            buffIndex:buffindex,
            buffName : Buffs.GetName( queryUnit, buffSerial ),
        }
        GameEvents.SendCustomGameEventToServer("CustomBuffAlert", event_data);
    }
}

function AddBuffEvent(targetPanel) {

    targetPanel.ClearPanelEvent("onactivate");
    targetPanel.ClearPanelEvent("onmouseover");
    targetPanel.ClearPanelEvent("onmouseout");

    targetPanel.SetPanelEvent("onactivate", function () {
        var queryUnit = targetPanel.GetParent().Data().m_QueryUnit;
        var buffSerial = targetPanel.GetParent().Data().m_BuffSerial;
        var buffindex = targetPanel.GetParent().Data().m_Buffindex;

        
        
        OnBuffClicked(queryUnit,buffSerial,buffindex)
    });

    targetPanel.SetPanelEvent("onmouseover", function () {
        var queryUnit = targetPanel.GetParent().Data().m_QueryUnit;
        var buffSerial = targetPanel.GetParent().Data().m_BuffSerial;
        // $.Msg(Buffs.GetName(queryUnit,buffSerial));
        if (Buffs.GetName(queryUnit,buffSerial)=="modifier_unit_cooldownReduction") {
            $.DispatchEvent("UIShowCustomLayoutTooltip", targetPanel, "advanced_stats_tooltip", "file://{resources}/layout/custom_game/tooltips/advanced_stats/advanced_stats.xml");
        }else{
            var isEnemy = Entities.IsEnemy( queryUnit );
            $.DispatchEvent( "DOTAShowBuffTooltip",targetPanel, queryUnit, buffSerial, isEnemy );
        }
        // if (condition) {
        //     $.DispatchEvent("UIShowCustomLayoutTooltip", targetPanel, "advanced_stats_tooltip", "file://{resources}/layout/custom_game/tooltips/advanced_stats/advanced_stats.xml");
        //     if (target) {
        //         $.DispatchEvent("UIShowCustomLayoutTooltip", target, "advanced_stats_tooltip", "file://{resources}/layout/custom_game/tooltips/advanced_stats/advanced_stats.xml");
        
        //         target.SetPanelEvent("onmouseout", function () {
        //             $.DispatchEvent("UIHideCustomLayoutTooltip", target, "advanced_stats_tooltip");
        //         });
        //     }
        // }

    });
    targetPanel.SetPanelEvent("onmouseout", function () {
        // $.DispatchEvent("DOTAHideTitleImageTextTooltip");
        var queryUnit = targetPanel.GetParent().Data().m_QueryUnit;
        var buffSerial = targetPanel.GetParent().Data().m_BuffSerial;
        if (buffSerial) {
            let name = Buffs.GetName(queryUnit,buffSerial);
            // $.Msg(name);
            if (name&&name=="modifier_unit_cooldownReduction") {
                $.DispatchEvent("UIHideCustomLayoutTooltip", targetPanel, "advanced_stats_tooltip");
            }else{
                $.DispatchEvent( "DOTAHideBuffTooltip", targetPanel );
            }
        }else{
            $.DispatchEvent( "DOTAHideBuffTooltip", targetPanel );
        }
      
        // $.DispatchEvent( "DOTAHideBuffTooltip", targetPanel );
    });
}




// "DOTA_Modifier_Alert"				"正处于<font color='%s1'>%s2%s3</font>%s4的作用下"
// "DOTA_Modifier_Alert_Ally_Hero"		"队友 <font color='%s4'>%s5</font> 处于：<font color='%s1'>%s2%s3</font>%s6"
// "DOTA_Modifier_Alert_Ally_Unit"		"队友 <font color='%s4'>%s5</font> 处于：<font color='%s1'>%s2%s3</font>%s6作用下"
// "DOTA_Modifier_Alert_Enemy_Hero"	"敌人 <font color='%s4'>%s5</font> 处于：<font color='%s1'>%s2%s3</font>%s6作用下"
// "DOTA_Modifier_Alert_Enemy_Unit"	"敌人 <font color='%s4'>%s5</font> 处于：<font color='%s1'>%s2%s3</font>%s6作用下"
// "DOTA_Modifier_Alert_Self_BH_Track"		"处于：<font color='%s1'>%s2%s3</font>作用下并拥有<font color='#FFCC33'>%s6</font>金%s7"
// "DOTA_Modifier_Alert_Enemy_BH_Track"	"敌人 <font color='%s4'>%s5</font>处于：<font color='%s1'>%s2%s3</font>并拥有<font color='#FFCC33'>%s6</font>金%s7"
// "DOTA_Modifier_Alert_Ally_BH_Track"		"队友 <font color='%s4'>%s5</font>处于：<font color='%s1'>%s2%s3</font>并拥有<font color='#FFCC33'>%s6</font>金%s7"
// "DOTA_Modifier_Alert_Self_SB_ChargeOfDarknessTarget"	"%s3向%s3 <font color='%s6'>%s7</font>冲刺"
// "DOTA_Modifier_Alert_Ally_SB_ChargeOfDarknessTarget"	"队友 <font color='%s4'>%s5</font>%s3向%s3<font color='%s6'>%s7</font>冲刺"
// "DOTA_Modifier_Alert_Enemy_SB_ChargeOfDarknessTarget"	"敌人 <font color='%s4'>%s5</font>正受到：<font color='%s1'>%s2</font>"
function FriendlyAlert(queryUnit,buffSerial,caller,disableStack,caster,valueData){
    var localPlayerID = Players.GetLocalPlayer();
    let modifierName = Buffs.GetName( queryUnit, buffSerial);
    // let caster = Buffs.GetCaster(queryUnit,buffSerial);
    // $.Msg(caster);
    // $.Msg("caster");
    if (!caster) {
        $.Msg("再次获取");
        caster = -1;
    }
    // $.Msg(caster);
    var Label = $.CreatePanel("Label", ChatLinesPanel, "");


    // let aaa = Buffs.GetUnitDataTest(queryUnit);
    // $.Msg(aaa);
    
    LabelDefaultSetUp(Label,caller);
    // 自己点自己
    if (Entities.GetPlayerOwnerID( queryUnit)==caller) {
        var sMessage = $.Localize("#DOTA_Modifier_Alert");
        if (Buffs.IsDebuff( queryUnit, buffSerial)) {
            sMessage = SetMessage(sMessage,"%s1","#f51e1e")
        }else{
            sMessage = SetMessage(sMessage,"%s1","#59a044")
        }
      
        // let stackCount = Buffs.GetStackCount( queryUnit, buffSerial);
        let modifierNmaeLocaliztion = $.Localize("#DOTA_Tooltip_"+modifierName)+ " ";
        if (disableStack && disableStack==1) {
            // do nothing
        }else{
            let stackCount = Buffs.GetStackCount( queryUnit, buffSerial);
            if (stackCount>0) {
                modifierNmaeLocaliztion = stackCount + " " + modifierNmaeLocaliztion;
            }
        }
        sMessage = SetMessage(sMessage,"%s2",modifierNmaeLocaliztion);

        if (caster!=-1) {
            let casterMessage = $.Localize("#DOTA_Modifier_From");
            casterMessage = SetMessage(casterMessage,"%s1",$.Localize("#"+Entities.GetUnitName(caster)));
            sMessage = SetMessage(sMessage,"%s3",casterMessage);
        }else{
            let casterMessage = $.Localize("#DOTA_Modifier_From_Unknow");
            sMessage = SetMessage(sMessage,"%s3",casterMessage);
        }
        


        
        let duration = Buffs.GetRemainingTime( queryUnit, buffSerial);
        if (duration>0) {
            var sMessageDuration = $.Localize("#DOTA_Modifier_Alert_Time_Remaining");
            sMessageDuration = SetMessage(sMessageDuration,"%s1",duration.toFixed(2));
            sMessage = SetMessage(sMessage,"%s4",sMessageDuration);
        }else{
            sMessage = SetMessage(sMessage,"%s4","");
        }
        let unitNmae = "";
        let heroName = Players.GetPlayerSelectedHero( caller );
        if (heroName!=Entities.GetUnitName(queryUnit)) {
            unitNmae = $.Localize("#"+heroName) + " - " + $.Localize("#"+Entities.GetUnitName(queryUnit))
        }else{
            unitNmae = $.Localize("#"+Entities.GetUnitName(queryUnit));
        }
        unitNmae = ToColor(unitNmae,"#1ef5f5") 
        if (valueData!=null) {
            let specialMessage = $.Localize("#DOTA_Modifier_Alert_hd_special_"+valueData.specialType);
            specialMessage = SetMessage(specialMessage,"%s1",valueData.value);
            specialMessage = ToColor(specialMessage,"#f5911e") 
            specialMessage = "  " + specialMessage;
            sMessage = sMessage + specialMessage
        }

        Label.SetDialogVariable("message", unitNmae + sMessage);
        var sText = $.Localize("#DOTA_ChatMessage_HudAll", Label);
        sText = $.Localize("#DOTA_ChatMessage_Hud", Label);
        Label.text = sText;
        var time = Game.Time() + ChatLineTime;
        let removeClass = function () {
            Label.RemoveClass("Expired");
            if (Game.Time() < time) $.Schedule(Game.GetGameFrameTime(), removeClass);
        }
        removeClass();
        Game.EmitSound("Chat.Team.Received");
        // Game.EmitSound("ui_chat_msg_send");
    }else{
        // 点队友
        var sMessage = $.Localize("#DOTA_Modifier_Alert_Ally_Unit");
        // buff颜色
        if (Buffs.IsDebuff( queryUnit, buffSerial)) {
            sMessage = SetMessage(sMessage,"%s1","#f51e1e")
        }else{
            sMessage = SetMessage(sMessage,"%s1","#59a044")
        }
      
        // let stackCount = Buffs.GetStackCount( queryUnit, buffSerial);
        let modifierNmaeLocaliztion = $.Localize("#DOTA_Tooltip_"+modifierName)+ " ";
        // if (stackCount>0) {
        //     modifierNmaeLocaliztion = stackCount + " " + modifierNmaeLocaliztion;
        // }
        if (disableStack && disableStack==1) {
            // do nothing
        }else{
            let stackCount = Buffs.GetStackCount( queryUnit, buffSerial);
            if (stackCount>0) {
                modifierNmaeLocaliztion = stackCount + " " + modifierNmaeLocaliztion;
            }
        }
        sMessage = SetMessage(sMessage,"%s2",modifierNmaeLocaliztion);
        // sMessage = SetMessage(sMessage,"%s3","");
        if (caster!=-1) {
            let casterMessage = $.Localize("#DOTA_Modifier_From");
            casterMessage = SetMessage(casterMessage,"%s1",$.Localize("#"+Entities.GetUnitName(caster)));
            sMessage = SetMessage(sMessage,"%s3",casterMessage);
        }else{
            let casterMessage = $.Localize("#DOTA_Modifier_From_Unknow");
            sMessage = SetMessage(sMessage,"%s3",casterMessage);
        }
        
        let duration = Buffs.GetRemainingTime( queryUnit, buffSerial);
        if (duration>0) {
            var sMessageDuration = $.Localize("#DOTA_Modifier_Alert_Time_Remaining");
            sMessageDuration = SetMessage(sMessageDuration,"%s1",duration.toFixed(2));
            sMessage = SetMessage(sMessage,"%s6",sMessageDuration);
        }else{
            sMessage = SetMessage(sMessage,"%s6","");
        }
        // 名字 s4 s5
        sMessage = SetMessage(sMessage,"%s4","#1ef5f5");

        let unitNmae = "";
        // $.Msg(Entities.GetPlayerOwnerID( queryUnit));
        let heroName = Players.GetPlayerSelectedHero( Entities.GetPlayerOwnerID( queryUnit) );
        // $.Msg(heroName);
        if (heroName!=Entities.GetUnitName(queryUnit)) {
            unitNmae = $.Localize("#"+heroName) + " - " + $.Localize("#"+Entities.GetUnitName(queryUnit))
        }else{
            unitNmae = $.Localize("#"+Entities.GetUnitName(queryUnit));
        }
        unitNmae = ToColor(unitNmae,"#1ef5f5") 

        // Label.SetDialogVariable("message", unitNmae + sMessage);
        sMessage = SetMessage(sMessage,"%s5",unitNmae);
        if (valueData!=null) {
            let specialMessage = $.Localize("#DOTA_Modifier_Alert_hd_special_"+valueData.specialType);
            specialMessage = SetMessage(specialMessage,"%s1",valueData.value);
            specialMessage = ToColor(specialMessage,"#f5911e") 
            specialMessage = "  " + specialMessage;
            sMessage = sMessage + specialMessage
        }
        Label.SetDialogVariable("message", sMessage);
        var sText = $.Localize("#DOTA_ChatMessage_HudAll", Label);
        sText = $.Localize("#DOTA_ChatMessage_Hud", Label);
        Label.text = sText;
        var time = Game.Time() + ChatLineTime;
        let removeClass = function () {
            Label.RemoveClass("Expired");
            if (Game.Time() < time) $.Schedule(Game.GetGameFrameTime(), removeClass);
        }
        removeClass();
        Game.EmitSound("Chat.Team.Received");
    }

    // let buffPanel = $.CreatePanel( "Panel", Label, "" );
    // buffPanel.BLoadLayoutSnippet("SingleBuff");

    

    // let target = Label.Children();
    // // $.Msg(target);
    // if (target && target[1]) {
    //     let newPanel = $.CreatePanelWithProperties("DOTAAvatarImage",  target[1], "PlayerIcon", {
    //         accountid:"324420892"
    //     })
    //     newPanel.style.width = "80%";
    //     newPanel.style.height = "80%";
    //     newPanel.style.padding = "1px";
    //     newPanel.style.marginTop = "2px";
    //     target[1].style.color = "white";
    //     // $.Msg(newPanel);
    //     // $.Msg(target[1])
    //     // let buffPanel = $.CreatePanel( "Panel", Label, "" );
    //     // buffPanel.BLoadLayoutSnippet("CustomPlayerIcon");
    //     // $.Msg(buffPanel);
    //     // // let newtarget = buffPanel.FindChildTraverse("ChatPlayerAvatar");
    //     // // newtarget.accountid="324420892";
    // }
}

function EnemyAlert(queryUnit,buffSerial,caller,disableStack,caster,valueData){
    var localPlayerID = Players.GetLocalPlayer();
    let modifierName = Buffs.GetName( queryUnit, buffSerial);
    var Label = $.CreatePanel("Label", ChatLinesPanel, "");
    LabelDefaultSetUp(Label,caller);
    // let caster = Buffs.GetCaster(queryUnit,buffSerial);
    // $.Msg(caster);
    // $.Msg("caster");
    if (!caster) {
        $.Msg("再次获取");
        caster = -1;
    }
    // $.Msg(caster);
    var sMessage = $.Localize("#DOTA_Modifier_Alert_Enemy_Hero");
    // buff颜色
    if (Buffs.IsDebuff( queryUnit, buffSerial)) {
        sMessage = SetMessage(sMessage,"%s1","#f51e1e")
    }else{
        sMessage = SetMessage(sMessage,"%s1","#59a044")
    }
  
    
    let modifierNmaeLocaliztion = $.Localize("#DOTA_Tooltip_"+modifierName)+ " ";
    if (disableStack && disableStack==1) {
        // do nothing
    }else{
        let stackCount = Buffs.GetStackCount( queryUnit, buffSerial);
        if (stackCount>0) {
            modifierNmaeLocaliztion = stackCount + " " + modifierNmaeLocaliztion;
        }
    }

    sMessage = SetMessage(sMessage,"%s2",modifierNmaeLocaliztion);
    // sMessage = SetMessage(sMessage,"%s3","");
    if (caster!=-1) {
        let casterMessage = $.Localize("#DOTA_Modifier_From");
        casterMessage = SetMessage(casterMessage,"%s1",$.Localize("#"+Entities.GetUnitName(caster)));
        sMessage = SetMessage(sMessage,"%s3",casterMessage);
    }else{
        let casterMessage = $.Localize("#DOTA_Modifier_From_Unknow");
        sMessage = SetMessage(sMessage,"%s3",casterMessage);
    }
    

    let duration = Buffs.GetRemainingTime( queryUnit, buffSerial);
    if (duration>0) {
        var sMessageDuration = $.Localize("#DOTA_Modifier_Alert_Time_Remaining");
        sMessageDuration = SetMessage(sMessageDuration,"%s1",duration.toFixed(2));
        sMessage = SetMessage(sMessage,"%s6",sMessageDuration);
    }else{
        sMessage = SetMessage(sMessage,"%s6","");
    }
    // 名字 s4 s5
    sMessage = SetMessage(sMessage,"%s4","#eef51e");
    sMessage = SetMessage(sMessage,"%s5",$.Localize("#"+Entities.GetUnitName(queryUnit)));
    if (valueData!=null) {
        let specialMessage = $.Localize("#DOTA_Modifier_Alert_hd_special_"+valueData.specialType);
        specialMessage = SetMessage(specialMessage,"%s1",valueData.value);
        specialMessage = ToColor(specialMessage,"#f5911e") 
        specialMessage = "  " + specialMessage;
        sMessage = sMessage + specialMessage
    }
    Label.SetDialogVariable("message", sMessage);
    var sText = $.Localize("#DOTA_ChatMessage_HudAll", Label);
    sText = $.Localize("#DOTA_ChatMessage_Hud", Label);
    Label.text = sText;
    var time = Game.Time() + ChatLineTime;
    let removeClass = function () {
        Label.RemoveClass("Expired");
        if (Game.Time() < time) $.Schedule(Game.GetGameFrameTime(), removeClass);
    }
    removeClass();
    Game.EmitSound("Chat.Team.Received");


}





function LabelDefaultSetUp(Label,caller){
    Label.AddClass("ChatLine");
    Label.selectionpos_x = "auto";
    Label.selectionpos_y = "auto";
    Label.html = true;
    Label.hittest = false;
    Label.hittestchildren = false;
    Label.SetDialogVariable("target", $.Localize("#DOTA_ChatTarget_GameAllies"));
    Label.SetDialogVariable("sender_class", "GameAlliesChat");

    Label.SetDialogVariable("hero_badge_icon", "<panel class='HeroBadge'/>");
    let hero = Players.GetPlayerSelectedHero( caller );
 

    Label.SetDialogVariable("hero_icon", "<img class='HeroIcon' src='file://{images}/heroes/" +Players.GetPlayerSelectedHero( caller ) + ".png'>");
    Label.SetDialogVariable("player_color_class", "PlayerColor" + caller);
    Label.SetDialogVariable("event_crest", "");
    Label.SetDialogVariable("battle_cup_icon", "");
    Label.SetDialogVariable("new_player_icon", "");
    Label.SetDialogVariable("persona", 	Players.GetPlayerName( caller ));
}

function SetMessage(text,key,value){
    return text.replace(key,value);
}











