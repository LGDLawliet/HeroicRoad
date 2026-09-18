
const SetBonusAttributesButton = $( "#SetBonusAttributesButton" );
const FellOmenBan_Bonus_Attributes_PanelWindow = $( "#FellOmenBan_Bonus_Attributes_PanelWindow" );
var settingStatus = true;
function ChangingBonusAttributesStatus(){
	
	if(settingStatus==true){
        Game.EmitSound( "ui.treasure_count" );
        settingStatus = false;
        FellOmenBan_Bonus_Attributes_PanelWindow.SetHasClass("FellOmenHidden", settingStatus);
		SetBonusAttributesButton.SetHasClass("FellOmenHidden", settingStatus);
    }else{
        Game.EmitSound( "ui.treasure_unlock.wav" );
        settingStatus = true;
        FellOmenBan_Bonus_Attributes_PanelWindow.SetHasClass("FellOmenHidden", settingStatus);
		SetBonusAttributesButton.SetHasClass("FellOmenHidden", settingStatus);
    }
}
const FellOmenBan_Bonus_Attributes = $( "#FellOmenBan_Bonus_Attributes" );
const FellOmenBan_Bonus_Attributes_base = FellOmenBan_Bonus_Attributes.FindChildInLayoutFile( "FellOmenBan_Bonus_Attributes_0" );
var current_max_point = 0;
FellOmenBan_Bonus_Attributes_base.SetDialogVariable("point", current_max_point);
var current_cost = 0;
$( "#SetBonusAttributesButton" ).SetHasClass("Visible", false);
var costMap = [
	{
		"1": 1,
	},
	{
		"1": 1,
	},
	{
		"1": 0.5,
	},
	{
		"1": 40,
	},
	{
		"1": 40,
	},

	{
		"1": 40,
	},
	{
		"1": 40,
	},
	{
		"1": 40,
	},
	// 技能点
	{
		"0": 0,
		"1": 5,
		"2": 11,
		"3": 18,
		"4": 26,
		"5": 35,
		"6": 45,
		"7": 56,
		"8": 68,
		"9": 81,
		"10": 95,
	},
];





// 数值发生变化时
function BonusAttributesQuantityChanged(key){
     //$.Msg("key=",key);
	var target = FellOmenBan_Bonus_Attributes.FindChildInLayoutFile( "FellOmenBan_Bonus_Attributes_"+key );
	let value = target.FindChildInLayoutFile( "Bonus_attributes").value;
	 //$.Msg(costMap[key-1]);
	let cost = costMap[key][1]*value;
	if ((key)==9) {
		cost = costMap[key][value+1];
	}
	cost = Math.ceil(cost);

	target.SetDialogVariable("point", cost);
	Game.EmitSound( "ui.inv_drop_bone" );
	CalculateTotalCost();
}



// 重新计算所有消耗点
function CalculateTotalCost(){
	var bonusChildren = FellOmenBan_Bonus_Attributes.Children();
	var cost = 0;
    // $.Msg(costMap);
	for (let index = 1; index < bonusChildren.length; index++) {
		const element = bonusChildren[index];
		let value = 	 element.FindChildInLayoutFile( "Bonus_attributes").value;
        // $.Msg("value=",value);
        // $.Msg("index=",index);
		value = costMap[index][1]*value;
		value = Math.ceil(value);
		// target.SetDialogVariable("point", cost);

		cost+=value;
	}
	current_cost = cost;
	FellOmenBan_Bonus_Attributes_base.SetDialogVariable("point", current_max_point-cost);
}

function SendBonusAttributes(){
	if (current_cost!=current_max_point) {
		if (current_cost>=current_max_point) {
			var message = "#DOTA_HUD_FellOmen_Send_Bonus_Attributes_failed2";
			var sound = "General.Cancel";
			GameUI.SendCustomHUDError( message, sound );
			return
		}
		var message = "#DOTA_HUD_FellOmen_Send_Bonus_Attributes_failed";
		var sound = "General.Cancel";
		GameUI.SendCustomHUDError( message, sound );
		return
	}
	var data = {};
	var bonusChildren = FellOmenBan_Bonus_Attributes.Children();
	for (let index = 1; index < bonusChildren.length; index++) {
		const element = bonusChildren[index];
		let value = 	 element.FindChildInLayoutFile( "Bonus_attributes").value;
		data[index] = value;
	}
	var event_data = {
		player_id: Game.GetLocalPlayerID(),
		attributes :data,
	}
	GameEvents.SendCustomGameEventToServer("SendBonusAttributes_ChaoticEra",  event_data );
}

function SetBonusAttributesCost(keys){
	costMap = keys;
	for (let index = 1; 8; index++) {
		BonusAttributesQuantityChanged(index);
        if (index>=8) {
            break;
        }
		
	}
}



function SetBonuisPoint(keys){
	current_max_point = keys[1];
	FellOmenBan_Bonus_Attributes_base.SetDialogVariable("point", current_max_point);
	
	$( "#SetBonusAttributesButton" ).SetHasClass("Visible", true);
}

function CloseBonusWindow(){
	$( "#SetBonusAttributesButton" ).SetHasClass("Visible", false);
	settingStatus = true;
	FellOmenBan_Bonus_Attributes_PanelWindow.SetHasClass("FellOmenHidden", true);
	Game.EmitSound( "ui.herochallenge_complete" );
}




GetBonusAttributesCostTable();
function GetBonusAttributesCostTable(){
	var event_data = {
		player_id: Game.GetLocalPlayerID(),
	}
	GameEvents.SendCustomGameEventToServer("GetBonusAttributesCost_ChaoticEra",  event_data );

}



function SetPlayerBonusAttributes(keys) {

    let id = Game.GetLocalPlayerID();
    if (keys[id]) {
        $.Msg("keys=",keys[id]);
        if (keys[id].setting == 0) {
            $( "#SetBonusAttributesButton" ).SetHasClass("Visible", true);
            current_max_point =  keys[id].count;
            FellOmenBan_Bonus_Attributes_base.SetDialogVariable("point", keys[id].count);
	



        }else{
            $( "#SetBonusAttributesButton" ).SetHasClass("Visible", false);
            FellOmenBan_Bonus_Attributes_PanelWindow.SetHasClass("FellOmenHidden", true);
        }
    }else{
        $( "#SetBonusAttributesButton" ).SetHasClass("Visible", false);
        FellOmenBan_Bonus_Attributes_PanelWindow.SetHasClass("FellOmenHidden", true);
    }
}







