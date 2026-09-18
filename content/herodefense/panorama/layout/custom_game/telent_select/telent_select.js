



var customSpellsMenuPanel = $("#SelectWindowContest");  
var telent_SelectRoot = $("#telent_SelectRoot"); 
telent_SelectRoot.SetHasClass("Visible", false);


var heroTelent =[
    "Primary_Starbreaker",
    "heroTalent_npc_dota_hero_axe",
    "heroTalent_npc_dota_hero_batrider",
]
    
function TalentSpawnFinished(keys){
    // heroTelent = key;
    $.Msg("收到天赋");
    heroTelent = [];
    for (const key in keys) {
        heroTelent[heroTelent.length] = keys[key];
    }
    heroTelent.sort();
    $.Msg(heroTelent);
    // CreateTalentList();

    OpenTelentPanel();
    $.Msg("打开天赋完成");
}

// OpenTelentPanel();
function OpenTelentPanel() {
    $.Msg("打开天赋");
    telent_SelectRoot.SetHasClass("Visible", true);

    // Game.EmitSound( "ui_hero_select_slide" );
    
    customSpellsMenuPanel.RemoveAndDeleteChildren();  //先清除
    var spellsContainer = customSpellsMenuPanel;
    var spellPanel;
    for (const key in heroTelent) {
        if (heroTelent[key]) {
            var individualHeroSpell =heroTelent[key];
            spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + key);
            spellPanel.BLoadLayoutSnippet("spell"); //载入模块
            var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
            image.abilityname = individualHeroSpell;
            var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
            let maskIndex = Math.floor(Math.random()*98+36);
            if (maskIndex<100) {
                maskIndex = "0"+maskIndex;
            }
            spellButton.style.opacityMask =  "url('s2r://panorama/images/masks/sequence/flamereveal/"+maskIndex+"_png.vtex')";
            // var spellStringified = JSON.stringify(individualHeroSpell);
            addTelentEvens(spellButton,individualHeroSpell);

        }
    }
    // $.Msg("检查天赋hhh");
}

function addTelentEvens(spellButton,individualHeroSpell) {
    spellButton.SetPanelEvent("onactivate", function () {
        SelectTelent(individualHeroSpell);
    });

    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,individualHeroSpell);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");

    });
}


function SelectTelent(target){
   
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        spellName : target
    }
    GameEvents.SendCustomGameEventToServer("SelectTelent",  event_data );
    // Game.EmitSound( "ui.inv_equip_metalblade" );
    customSpellsMenuPanel.RemoveAndDeleteChildren();  //先清除
    
    telent_SelectRoot.SetHasClass("Visible", false);
    heroTelent = {}
    Game.EmitSound( "HD_Learn_Talent" );
}
function FroceClose(){
    telent_SelectRoot.SetHasClass("Visible", false);
    heroTelent = {}
    Game.EmitSound( "HD_Learn_Talent" );
}

// $.Msg("检查天赋");
$.Schedule( 2.0, CheckTelent );


var a = 0;

function CheckTelent(){
    // $.Msg("检查天赋发送");
    var event_data = {
        player_id: Game.GetLocalPlayerID(),

    }
    GameEvents.SendCustomGameEventToServer("CheckPlayerHeroTalent",  event_data );
    // $.Msg("检查天赋发送完成");
}


(function () {
    GameEvents.Subscribe("TalentSpawnFinished", TalentSpawnFinished);
    GameEvents.Subscribe("FroceClose", FroceClose);
})();

