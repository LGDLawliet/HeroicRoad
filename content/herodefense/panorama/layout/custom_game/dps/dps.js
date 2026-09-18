var players = {}; 
var panel;
var length = -1;

function AddDebugPlayer(color)
{
	panel = $.CreatePanel('Panel', $('#Players'), '');
	panel.BLoadLayoutSnippet("Player");
	panel.FindChildTraverse('PlayerNameSignal').text = "assbutt";
	panel.FindChildTraverse('PlayerDamageDealth').text = "666"
	panel.FindChildTraverse('PlayerDamageTaken').text = "666";
	$.Msg("hello")
}  
function InitPlayer(name)
{
    // $.Msg("helloaaaaaaaaaaaaaaaaaaaaaaaa")
	panel = $.CreatePanel('Panel', $('#Players'), '');
	panel.BLoadLayoutSnippet("Player");
	
	panel.FindChildTraverse('PlayerHeroSignal').text = $.Localize("#"+name.name);
	panel.FindChildTraverse('HeroMovie').heroname = name.name;
	panel.FindChildTraverse('PlayerDamageDealt').text = "0"
	panel.FindChildTraverse('PlayerDamageTaken').text = "0";
	panel.FindChildTraverse('PlayerDamageHealed').text = "0";
	panel.FindChildTraverse('PlayerDPS').text = "0";
	players[name.id]= panel;
	length = length + 1;
}
var DamageList = $("#DamageList");
// DamageList.SetHasClass("Visible", true);
var damage_list_on = false
Delete();
var event_data = {
	player_id: Game.GetLocalPlayerID()
}


GameEvents.SendCustomGameEventToServer("Create_DPS",event_data);
DamageList.SetHasClass("Hidden", true);
function OpenDamageListButton() {

	if (damage_list_on==true) {
		Game.EmitSound( "ui_friends_slide_in" );
		damage_list_on = false;
		DamageList.SetHasClass("Hidden", true);
		// DamageList.SetHasClass("Visible", false);
		// Delete();
	}else{
		Game.EmitSound( "ui_friends_slide_in" );
		damage_list_on = true;
		// DamageList.SetHasClass("Visible", true);
		DamageList.SetHasClass("Hidden", false);
		// var event_data = {
		// 	player_id: Game.GetLocalPlayerID()
		// }


		// GameEvents.SendCustomGameEventToServer("Create_DPS",event_data);
	}
	
}



function Delete()
{
	for (i = 0; i <= length; i++) {
	  players[i].RemoveAndDeleteChildren();
	}
	length = -1;
}


function SetDamageDealt(damage)
{
	if (damage_list_on==false) {
		return
	}

	players[damage.id].FindChildTraverse('PlayerDamageDealt').text = damage.damage;
}	
function SetDamageTaken(damage)
{
	if (damage_list_on==false) {
		return
	}
	players[damage.id].FindChildTraverse('PlayerDamageTaken').text = damage.damage;
}	

function SetDamageHealed(damage)
{
	if (damage_list_on==false) {
		return
	}
	players[damage.id].FindChildTraverse('PlayerDamageHealed').text = damage.damage;
}	
function SetDPS(damage)
{
	if (damage_list_on==false) {
		return
	}
	players[damage.id].FindChildTraverse('PlayerDPS').text = damage.damage;
}	
function SetDamageTypes(damage)

{
	if (damage_list_on==false) {
		return
	}
	var total = damage.physical + damage.magical + damage.pure;
	var physpercent =  Math.floor(damage.physical / total * 100)
	var magpercent =  Math.floor(damage.magical / total * 100)
	var purepercent =  Math.floor(damage.pure / total * 100)
	if (physpercent + magpercent + purepercent < 100)
	{
		if (physpercent > magpercent && physpercent > purepercent)
			physpercent = 100 - magpercent - purepercent;
		else if (magpercent > purepercent)
			magpercent = 100 - physpercent - purepercent;
		else purepercent = 100 - physpercent - magpercent;
	}
	players[damage.id].FindChildTraverse('Playerphysdamagepercent').text = physpercent + "%";
	players[damage.id].FindChildTraverse('Playermagdamagepercent').text = magpercent + "%";
	players[damage.id].FindChildTraverse('Playerpuredamagepercent').text = purepercent + "%";
	
	players[damage.id].FindChildTraverse("PlayerPhysical").style.width = physpercent + "%";
	players[damage.id].FindChildTraverse("PlayerMagical").style.width = magpercent  + "%";
	players[damage.id].FindChildTraverse("PlayerPure").style.width = purepercent + "%";
}	

function debug()
{
	GameEvents.Subscribe("game_begin", InitPlayer);
	GameEvents.Subscribe("damage_update", SetDamageDealt);
	GameEvents.Subscribe("damage_taken_update", SetDamageTaken);
	GameEvents.Subscribe("heal_update", SetDamageHealed);
	GameEvents.Subscribe("dps_update", SetDPS);
	GameEvents.Subscribe("damage_type_update", SetDamageTypes);
	GameEvents.Subscribe("delete", Delete);

}

debug();