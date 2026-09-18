var talent
var OpenState = false;
var talent_bg = $("#talent_bg");
talent1_bg.SetHasClass("Visible", false);


function CloseWheelMenu(){
    talent_bg.SetHasClass("Visible", false);
    OpenState = false;
}


function OpenTalentMenu(){
    if(OpenState){
        Game.EmitSound( "ui_menu_activate_close" );
        talent_bg.SetHasClass("Visible", false);
        
        OpenState = false;
        
    }else{
        Game.EmitSound( "ui.treasure_unlock.wav" );
        talent_bg.SetHasClass("Visible", true);
        OpenState = true;
        if(talent){
            CreateSoundHero();
        }else{

        }
    }
  

}