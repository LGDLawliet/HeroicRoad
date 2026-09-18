function Ok()
{
    $("#endswaves").visible = false;
    GameEvents.SendCustomGameEventToServer( "pushOK", {} );
}

function open()
{
	$("#endswaves").visible = true;
}



// (function()
// {
//     GameEvents.Subscribe( "endswaves", open)
    
//     $("#endswaves").visible = false;
// })();