"use strict";

var m_BuffPanels = [];
var m_DeBuffPanels = []; 
var showAllBuff = false;
const buffsListPanel = $( "#buffs_list" );
const debuffsListPanel = $( "#debuffs_list" );
let currentQueryUnit;


function UpdateBuff( buffPanel, queryUnit, buffSerial,buffIndex, debuff )
{
	
	buffPanel.Data().m_QueryUnit = queryUnit;
	buffPanel.Data().m_BuffSerial = buffSerial;
	// 必须加1 因为这个是给lua用的
	buffPanel.Data().m_Buffindex = buffIndex+1;

	
	var buffTexture = Buffs.GetTexture( queryUnit, buffSerial );

	var buffImage = buffPanel.FindChildInLayoutFile( "BuffImg" );
	
	var isItem = ( buffTexture.indexOf( "item" ) != -1 );
    // var aaa = buffPanel.Children();
    // $.Msg( buffPanel);
	let address1 = "s2r://panorama/images/spellicons/" + buffTexture + ".png";
	let address2 = "raw://resource/flash3/images/spellicons/" + buffTexture + ".png";
	buffPanel.FindChildInLayoutFile( "BuffImgAlt" ).SetImage( address1 );
	buffPanel.FindChildInLayoutFile( "BuffImgOther" ).SetImage( address2 );
	// $.Msg(buffTexture);
	if ( isItem ) {
		var itemImg = buffPanel.FindChildInLayoutFile( "AbilityImg" );
		let address_item = "raw://resource/flash3/images/items/" + buffTexture.substring(5) + ".png";
		buffImage.SetImage( address_item );
		itemImg.itemname = buffTexture;
		buffPanel.SetHasClass( "item_buff", true );
		buffPanel.SetHasClass( "ability_buff", false );
	}
	else {
		var abilityImg = buffPanel.FindChildInLayoutFile( "AbilityImg" );
		buffImage.SetImage( address2 );
		abilityImg.abilityname = buffTexture;
		buffPanel.SetHasClass( "item_buff", false );
		buffPanel.SetHasClass( "ability_buff", true );
	}
	
	
	var cooldownLength = Buffs.GetDuration( queryUnit, buffSerial );
	let durationPanel = buffPanel.FindChildInLayoutFile( "CircularDuration" );
	if ( debuff && cooldownLength == 1 ) { durationPanel.style.clip = "radial( 50.0% 50.0%, 0.0deg, -360deg)";return; }
	if ( !debuff && cooldownLength == 0.5 ) { durationPanel.style.clip = "radial( 50.0% 50.0%, 0.0deg, -360deg)";return; }
	
	if (cooldownLength > 0) {
		let cooldownRemaining = Buffs.GetRemainingTime( queryUnit, buffSerial );
		let cooldownPercent = Math.ceil( 100 * cooldownRemaining / cooldownLength );
		let deg = -360 * cooldownPercent * 0.01;
		durationPanel.style.clip = "radial( 50.0% 50.0%, 0.0deg, "+deg+"deg)";
	} else {
		durationPanel.style.clip = "radial( 50.0% 50.0%, 0.0deg, -360deg)";
	}	
}

function UpdateBuffs()
{
    if(!showAllBuff) {
		let base = $.GetContextPanel().GetParent().GetParent().GetParent();
		base.FindChildTraverse("BuffContainer").style.marginBottom = "12px";
		return;
	}


	// var buffsListPanel = $( "#buffs_list" );
	// if ( !buffsListPanel )
	// 	return;
	// var debuffsListPanel = $( "#debuffs_list" );
	// if ( !debuffsListPanel )
	// 	return;
	
    buffsListPanel.SetHasClass("Visible", true);
    debuffsListPanel.SetHasClass("Visible", true);
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (queryUnit!=currentQueryUnit) {
		// 切换单位时重置
		currentQueryUnit = queryUnit;
		buffsListPanel.RemoveAndDeleteChildren();
		debuffsListPanel.RemoveAndDeleteChildren();
		m_DeBuffPanels = []; 
		m_BuffPanels = [];
	}
	
	var nBuffs = Entities.GetNumBuffs( queryUnit );
	
	
	var nUsedPanelsbuff = 0;
	var nUsedPanelsdebuff = 0;

	for ( var i = 0; i < nBuffs; ++i )
	{
		
		var buffSerial = Entities.GetBuff( queryUnit, i );
		if ( buffSerial == -1 )
			continue;

		if ( Buffs.IsHidden( queryUnit, buffSerial ) )
			continue;
		
		var nNumStacks = Buffs.GetStackCount( queryUnit, buffSerial );
		
		
		if ( Buffs.IsDebuff( queryUnit, buffSerial ) ) 
		{
			if ( nUsedPanelsbuff > 41 ) continue;
			if ( nUsedPanelsdebuff >= m_DeBuffPanels.length )
			{


				// SingleBuff

				let buffPanel = $.CreatePanel( "Panel", debuffsListPanel, "" );
				buffPanel.BLoadLayoutSnippet("SingleBuff")
				// buffPanel.BLoadLayout( "file://{resources}/layout/custom_game/buff_list/buff_list_buff.xml", false, false );
				m_DeBuffPanels.push( buffPanel );
				let target = buffPanel.FindChildTraverse("BuffFrame");
				AddBuffEvent(target)

			}
			var buffPanel = m_DeBuffPanels[ nUsedPanelsdebuff ];
			UpdateBuff( buffPanel, queryUnit, buffSerial,i, true );
			buffPanel.SetHasClass( "is_debuff", true );
			nUsedPanelsdebuff++;
			
		}
		else
		{
			if ( nUsedPanelsbuff > 41 ) continue;
			if ( nUsedPanelsbuff >= m_BuffPanels.length )
			{
				let buffPanel = $.CreatePanel( "Panel", buffsListPanel, "" );
				buffPanel.BLoadLayoutSnippet("SingleBuff")
				// buffPanel.BLoadLayout( "file://{resources}/layout/custom_game/buff_list/buff_list_buff.xml", false, false );
				m_BuffPanels.push( buffPanel );
				let target = buffPanel.FindChildTraverse("BuffFrame");
				AddBuffEvent(target)

			}
			var buffPanel = m_BuffPanels[ nUsedPanelsbuff ];
			UpdateBuff( buffPanel, queryUnit, buffSerial, i,false );
			buffPanel.SetHasClass( "is_debuff", false );
			nUsedPanelsbuff++;
		}
		buffPanel.SetHasClass( "has_stacks", nNumStacks > 0 ); 
		buffPanel.FindChildInLayoutFile( "StackCount" ).text = nNumStacks;
		buffPanel.SetHasClass( "no_buff", false );

		
	}
	

	// while (nUsedPanelsbuff< m_BuffPanels.length) {
	// 	var buffPanel = m_BuffPanels[ nUsedPanelsbuff ];
	// 	m_DeBuffPanels.splice(nUsedPanelsbuff, 1);
	// 	buffPanel.DeleteAsync(0);
	// }
	let targetCount = m_BuffPanels.length
	let delIndex = nUsedPanelsbuff;
	for ( var i = nUsedPanelsbuff; i < targetCount; ++i )
	{
		var buffPanel = m_BuffPanels[ delIndex ];
		// buffPanel.SetHasClass( "no_buff", true );
		m_BuffPanels.splice(delIndex, 1);
		buffPanel.DeleteAsync(0);
	}
	
	targetCount = m_DeBuffPanels.length
	delIndex = nUsedPanelsdebuff;
	for ( var i = nUsedPanelsdebuff; i < targetCount; ++i )
	{
		var buffPanel = m_DeBuffPanels[ delIndex ];
		m_DeBuffPanels.splice(delIndex, 1);
		buffPanel.DeleteAsync(0);
		// buffPanel.SetHasClass( "no_buff", true );
	}
	
	$( "#BuffBlock" ).SetHasClass( "bShrink", nUsedPanelsbuff > 13 );
}

function AutoUpdateBuffs()
{
	UpdateBuffs();
	$.Schedule( 0.06, AutoUpdateBuffs );
}

function HiddenBuffPanel(bool){
	let base = $.GetContextPanel().GetParent().GetParent().GetParent();
	base.FindChildTraverse("BuffContainer").visible = bool;
}



function ShowAllBuff(){
    
    HiddenBuffPanel(showAllBuff);
    showAllBuff = !showAllBuff;
    var BuffListButton = $( "#BuffListButton" );
    if(BuffListButton){
        if(showAllBuff){
            BuffListButton.style.transform = "scaleY(1)";
        }else{
            BuffListButton.style.transform = "scaleY(-1)";
        }
        
    }
    var buffsListPanel = $( "#buffs_list" );

	if ( buffsListPanel )
    buffsListPanel.SetHasClass("Visible", showAllBuff);
	var debuffsListPanel = $( "#debuffs_list" );
	if ( debuffsListPanel )
    debuffsListPanel.SetHasClass("Visible", showAllBuff);

}



$.Schedule( 0.5, ShowAllBuff );

function OnReceiveBuffAlert(data) {
    let queryUnit = data.queryUnit;
    let buffSerial = data.buffSerial;
	// let buffIndex  = data.buffIndex;
    let caller = data.caller;
	GameUI.PingMinimapAtLocation( Entities.GetAbsOrigin(queryUnit ) );
    var localPlayerID = Players.GetLocalPlayer()
	let caster = data.caster;
	// $.Msg("aaaaaaa");
    if (data.alertType==0) {
        FriendlyAlert(queryUnit,buffSerial,caller,null,caster,null);
    }else if (data.alertType==1) {
		$.Msg(caster);
		EnemyAlert(queryUnit,buffSerial,caller,null,caster,null);
	}


}

// DOTA_Modifier_Alert_hd_special_1
function OnReceiveBuffAlert_special(data) {
    let queryUnit = data.queryUnit;
    let buffSerial = data.buffSerial;
	// let buffIndex  = data.buffIndex;
    let caller = data.caller;
	// let specialType = data.specialType;
	let valueData = data.valueData;
	let disableStack = data.disableStack;
	let caster = data.caster;
	GameUI.PingMinimapAtLocation( Entities.GetAbsOrigin(queryUnit ) );
    if (data.alertType==0) {
        FriendlyAlert(queryUnit,buffSerial,caller,disableStack,caster,valueData);
    }else if (data.alertType==1) {
		EnemyAlert(queryUnit,buffSerial,caller,disableStack,caster,valueData);
	}

}
function OnReceiveCustomAlert(data) {
	$.Msg(data);

	var localPlayerID = Players.GetLocalPlayer();

    var Label = $.CreatePanel("Label", ChatLinesPanel, "");
    LabelDefaultSetUp(Label,data.caller);
	var sMessage = $.Localize(data.text);
	for (const key in data.keys) {
		if (Object.hasOwnProperty.call(data.keys, key)) {
			const element = data.keys[key];
			if (element.bLocalize==1) {
				sMessage = SetMessage(sMessage,"%"+key,$.Localize("#"+element.text));
			}else{
				sMessage = SetMessage(sMessage,"%"+key,element.text);
			}
		}
	}
	
	$.Msg(sMessage);
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
	// Game.EmitSound("ui_chat_msg_send");
    
}
(function()
{
	buffsListPanel.RemoveAndDeleteChildren();
	debuffsListPanel.RemoveAndDeleteChildren();
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateBuffs );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateBuffs );
	GameEvents.Subscribe( "dota_player_update_killcam_unit", UpdateBuffs );
	GameEvents.Subscribe( "AlertBuff_JS", OnReceiveBuffAlert );
	GameEvents.Subscribe( "AlertBuff_JS_special", OnReceiveBuffAlert_special );


	GameEvents.Subscribe( "CustomAlert_JS", OnReceiveCustomAlert );

	
	AutoUpdateBuffs();
	// HiddenBuffPanel();
})();

