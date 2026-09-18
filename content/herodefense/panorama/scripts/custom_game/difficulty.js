// const { isValidElement } = require("react");

var ui1 = $("#difficultySelectWindows");
var difficultySelectWindowsRoot = $("#difficultySelectWindowsRoot");
difficultySelectWindowsRoot.SetHasClass("Visible", false);

var difficultyLabelPanel = $("#difficultyLabelPanel");
difficultyLabelPanel.SetHasClass("Visible", true);
difficultyLabelPanel.style.width = "0px";


function SelectDifficulty(i) {
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        difficulty : i
    }

    // $.Msg(i);
    GameEvents.SendCustomGameEventToServer("SelectDifficulty", event_data);
    difficultyLabelPanel.style.width = "0px";
    $.Schedule( 4.0, closeDifficultyLabel );
    
}


$.Schedule( 2.0, CheckDifficulty );
$.Schedule( 4.0, CheckDifficulty );
function closeDifficultyLabel(){
    difficultyLabelPanel.SetHasClass("Visible", false);
}


function CheckDifficulty( )
{
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("CheckDifficulty", event_data);
    // GameEvents.SendCustomGameEventToServer("Checkchallenge", player_id= Game.GetLocalPlayerID());  //重连时重新获取奖励
    $.Msg("check发送了");
}

$("#difficulty9").SetHasClass("hidden", true);
$("#difficulty10").SetHasClass("hidden", true);
function ShowDifficulty(keys){
    // if(Game.GetLocalPlayerID()==0){

     // 如果有新玩家则不出现百相
    if (keys.newPlayer==1) {
        
    }else{
        var label = $("#difficulty9").Children()[0];
        var labelText = label.text;
        labelText = labelText.replace("WAVE",keys.wave);
        label.text =labelText;
        $("#difficulty9").SetHasClass("hidden", false);
    }
    if (keys.shouldUnlockChaoticEra==1) {
        $("#difficulty10").SetHasClass("hidden", false);
    }
    
    difficultySelectWindowsRoot.SetHasClass("Visible", true);
    difficultyLabelPanel.style.width = "750px";

}





function CreateListing() {
    for (var category = 1; category <= 10; category++) {
        var difficultyUI = ui1.FindChildTraverse("difficulty"+category);
        // difficultyUI.SetPanelEvent("onactivate", function () {
        //     SelectDifficulty(category);
        // });
        if (difficultyUI) {
            CreateDifficultyEvent(difficultyUI,category);
        }
       
    }
}
function CreateDifficultyEvent(difficultyUI,category){
    difficultyUI.SetPanelEvent("onactivate", function () {
        SelectDifficulty(category);
    });
}




(function () {
    CreateListing();
    GameEvents.Subscribe("ShowDifficulty", ShowDifficulty);  
    
})();