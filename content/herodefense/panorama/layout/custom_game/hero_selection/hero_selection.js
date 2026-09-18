

var HeroSelectionRoot = $("#HeroSelectionRoot");
var HeroSelectionRootBG= $("#HeroSelectionRootBG");

var CloseButton= $("#CloseButton");


HeroSelectionRoot.SetHasClass("Visible", true); 
HeroSelectionRootBG.SetHasClass("Visible", true); 
CloseButton.SetHasClass("show", false); 

const loading_player_Progress = HeroSelectionRoot.FindChildTraverse("loading_player_Progress");


// $.Msg("aaaaaaaaaaaaa");

function Donothing(){

}




function CheckLoading(){
    var event_data = {
		player_id: Game.GetLocalPlayerID(),
	}
	GameEvents.SendCustomGameEventToServer("CheckGameLoadingBG",  event_data );
}

var closeDone = false;

$.Schedule( 40, ()=>{
    if(!closeDone){
        CloseButton.SetHasClass("show", true); 
    }
    
})

let state = 0;
function CloaseLoading(){
    HeroSelectionRoot.SetHasClass("Visible", false); 
    HeroSelectionRootBG.SetHasClass("Visible", false); 
    closeDone = true;
    CloseButton.SetHasClass("show", false); 
    state++;
    if (state<=10) {
        $.Schedule( 1, CloaseLoading );
    }
    
}

function UpdateLoginProgress(data){
    // var data = keys[1];
    // $.Msg(keys);
    var playerCount = data.playerCount;
    var loginCount = data.loginCount;


    var percent =  loginCount /  playerCount*100;
    loading_player_Progress.style.width = percent+"%";

    if(loginCount>=playerCount){
        // 全部登录完毕
        $.Schedule( 1, CloaseLoading );

    }


}


CheckLoading();
GameEvents.Subscribe("CloseLoadingBG", CloaseLoading);
// GameEvents.Subscribe("UpdateLoginProgress", UpdateLoginProgress);


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


	if (tableKeyName=="player_login") {

		UpdateLoginProgress(table);
	}
}

(function () {
    CustomUIConfig.SubscribeNetTableListener("game_config", UpdateCommonNetTable);
	UpdateCommonNetTable("game_config", "player_login", CustomNetTables.GetTableValue("game_config", "player_login"));

})()




