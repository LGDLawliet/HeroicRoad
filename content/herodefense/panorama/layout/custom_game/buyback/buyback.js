let base;
let topbarPlayer;
let buyBackButtonList = {};

$.Schedule( 1.0, CheckAlive );

function CheckAlive( )
{
// 
    $.Schedule( 1.0, CheckAlive );
    // $.Msg("check");
    var event_data = {
		player_id: Game.GetLocalPlayerID(),
	}
    GameEvents.SendCustomGameEventToServer("CheckAlive", event_data);  //重连时重新获取奖励

}


function CheckAliveCallBack(keys){
    // for (let index = 0; index < buyBackButtonList.length; index++) {
    //     const element = buyBackButtonList[index];
    //     element.SetHasClass("show", false);
        
    // }
    for (let index = 0; index < 5; index++) {
        let targetButton = GetPlayerBuyBackButton(index);
        if (targetButton) {
            targetButton.SetHasClass("show", false);
        }
    }
    var list = keys[1]
    // $.Msg(list);
    for (const key in list) {
        // $.Msg(XPTable[key]);
        switch(list[key]) {
            case 0:
                let targetButton = GetPlayerBuyBackButton(0);
                if (targetButton) {
                    targetButton.SetHasClass("show", true);
                }
                // BuyBackButton1.visible = true;
                break;
            case 1:
                let targetButton1 = GetPlayerBuyBackButton(1);
                if (targetButton1) {
                    targetButton1.SetHasClass("show", true);
                }
                break;
            case 2:
                // BuyBackButton3.visible = true;
                let targetButton2 = GetPlayerBuyBackButton(2);
                if (targetButton2) {
                    targetButton2.SetHasClass("show", true);
                }
                break;
            case 3:
                // BuyBackButton4.visible = true;
                let targetButton3 = GetPlayerBuyBackButton(3);
                if (targetButton3) {
                    targetButton3.SetHasClass("show", true);
                }
                break;
            case 4:
                // BuyBackButton5.visible = true;
                let targetButton4 = GetPlayerBuyBackButton(4);
                if (targetButton4) {
                    targetButton4.SetHasClass("show", true);
                }
                break;
            default:
                break;
            }
    }
    var id = Game.GetLocalPlayerID()
    let targetButton_self = GetPlayerBuyBackButton(id);
    if (targetButton_self!=null) {
        targetButton_self.SetHasClass("show", false);
    }

}


function CreateRandomHotKey(hotkey){
    let key = hotkey;
    const command = `On${key}${Date.now()}`;
    Game.CreateCustomKeyBind(key, `+${command}`);
    Game.AddCommand(
        `+${command}`,
        () => {
            BuyBackTargetClosest();
            // key down callback
        },
        ``,
        1 << 32
    );
    Game.AddCommand(
        `-${command}`,
        () => {
            // key up callback
        },
        ``,
        1 << 32
    );
}

(function () {

    GameEvents.Subscribe("CheckAliveCallBack", CheckAliveCallBack);  //难度选择成功 UI反馈



    CreateRandomHotKey("F3");
    // Game.AddCommand( "+BuyBack", BuyBackTarget, "", Date.now() );
	
})();

function BuyBackTargetClosest(){
    var event_data = {
		player_id: Game.GetLocalPlayerID(),
	}
    GameEvents.SendCustomGameEventToServer("BuyBackClosest", event_data);  
}
function BuyBackTarget(id) {
    var event_data = {
		player_id: Game.GetLocalPlayerID(),
        target_player_id : id,
	}
    GameEvents.SendCustomGameEventToServer("BuyBackHero", event_data);  
    let targetButton = GetPlayerBuyBackButton(id);
    if (targetButton) {
        targetButton.SetHasClass("show", false);
    }
}


function Init() {
        
    if (!base) {
        base = (() => {
            let panel = $.GetContextPanel();
            while (panel) {
                if (panel.id === "DotaHud") return panel;
                panel = panel.GetParent();
            }
        })();
    }

    var topbar =  base.FindChildTraverse("topbar");
    if (topbar) {
        topbarPlayer = topbar.FindChildTraverse("TopBarRadiantPlayersContainer");
        GetPlayerBuyBackButton(0);
    }
}

function GetPlayerBuyBackButton(playerId) {
    if (topbarPlayer==null) {
        Init();
    }
    if (topbarPlayer==null) {
        return;
    }

    let key = "RadiantPlayer"+playerId;
    // $.Msg(key);
    // let target = topbarPlayer.Children()[playerId];
    let target = topbarPlayer.FindChildTraverse(key);
    if (target) {
        let spellPanel = target.FindChildTraverse("buyBack"+playerId);
        if (spellPanel==null) {
            spellPanel = $.CreatePanel("Panel", target, "buyBack"+playerId);
            spellPanel.BLoadLayout("file://{resources}/layout/custom_game/buyback/buyback_Button.xml", false, false);
            SetBuyBackEvent(spellPanel,playerId);
        }
        return spellPanel
        

        
       

        
    }
    return null;

    
}

function SetBuyBackEvent(spellButton,id) {
    spellButton.SetPanelEvent("onactivate", function () {
        BuyBackTarget(id);
    });
}


Init();