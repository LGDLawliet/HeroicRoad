

// function SelectItem(itemNumber) {
// 	var event_data = {
//         player_id: Game.GetLocalPlayerID(),
//         difficulty : itemNumber
//     }
// 	GameEvents.SendCustomGameEventToServer("BossRewardChosen", { event_data });
// 	$("#DropSelectRoot").visible = false;
// }
//
$("#DropSelectRoot").visible = false;

function GetItem(itemname,itemtype) {
	var event_data = {
        player_id: Game.GetLocalPlayerID(),
        itemname : itemname,
		itemtype : itemtype
    }
	GameEvents.SendCustomGameEventToServer("BossRewardChosen",  event_data );
	$("#DropSelectRoot").visible = false;
	Game.EmitSound( "ui.inv_equip_metalblade" );
}
$("#RerollButton").visible= false;


function ShowBossRewards(keys) {
    
	$("#DropSelectRoot").visible = true;
	Game.EmitSound( "DOTAMusic_PLUS_ONE" );
	$("#RerollButton").visible= false;
	if(keys.chance>0){
		$("#RerollButton").SetDialogVariable("reRollCount", keys.chance);
		$("#RerollButton").visible= true;
	}
	

	
	var DropSelectItemContainer =	$("#DropSelectItemContainer").Children()
	// $.Msg(DropSelectItemContainer.length);
	DropSelectItemContainer[5].visible = false;
	DropSelectItemContainer[6].visible = false;
	for (let i = 0; i < DropSelectItemContainer.length; i++) {
		
		if (keys.item[i+1]) {
			// $.Msg(keys.item[i+1]);
			DropSelectItemContainer[i].Children()[0].itemname = keys.item[i+1].itemName;
			DropSelectItemContainer[i].itemname = keys.item[i+1].itemName;
			DropSelectItemContainer[i].itemtype = keys.item[i+1].itemType;
			// DropSelectItemContainer[i].Children()[0].SetPanelEvent("onactivate", Function("GetItem(\"" + DropSelectItemContainer[i].itemname + "\")"));
			DropSelectItemContainer[i].Children()[0].SetPanelEvent("onactivate", function () {
				GetItem(DropSelectItemContainer[i].itemname,DropSelectItemContainer[i].itemtype);
			});
			DropSelectItemContainer[i].visible = true;
		}

		
		// DropSelectItemContainer[i].enabled = false;
		// $.Msg(DropSelectItemContainer[i].itemname);
		// DropSelectItemContainer[i].SetImage= DropSelectItemContainer[i].itemname
	}
	// $.Schedule(1, function () {
	// 	for (var i = 0; i < DropSelectItemContainer.length; i++) {
	// 		// DropSelectItemContainer[i].SetPanelEvent("onactivate", Function("GetItem(\"" + DropSelectItemContainer[i].itemname + "\")"));
	// 		DropSelectItemContainer[i].enabled = true;
	// 	}
	// });
	// for (var i = 0; i < DropSelectItemContainer.length; i++) {
	// 	// $.Msg(DropSelectItemContainer[i]);
	// 	DropSelectItemContainer[i].itemname = keys.item[i+1];
	// 	DropSelectItemContainer[i].visible = true;
	// 	DropSelectItemContainer[i].enabled = false;
	// }

	
	
	// $("#DropSelectItemContainer")
	// 	.Children()
	// 	.forEach((panelWrap, index) => {
	// 		if (keys.items[index + 1]) {
	// 			panelWrap.GetChild(0).itemname = keys.item[index + 1];
	// 			panelWrap.visible = true;
	// 			panelWrap.GetChild(0).enabled = false;
	// 		}
	// 	});

	
	//add second delay before player can click, to be safe from misclicks
	// $.Schedule(1, function () {
	// 	$("#DropSelectItemContainer")
	// 		.Children()
	// 		.forEach((panelWrap, index) => {
	// 			if (keys.item[index + 1]) {
	// 				panelWrap.GetChild(0).enabled = true;
	// 			}
	// 		});
	// });
}

//


$.Schedule( 5.0, CheckItems );

///
function CheckItems( )
{


    $.Msg("checkItem");
	var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("CheckPendingBossReward", event_data);

}

function ReRollItemBonus(){
	var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("TryReRollItem", event_data);
	$("#DropSelectRoot").visible = false;
}

(function () {

	GameEvents.Subscribe("showBossRewards", ShowBossRewards);
})();

