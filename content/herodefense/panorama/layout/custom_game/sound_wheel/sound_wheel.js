function Donothing(){


    //
}
var sound_wheel_menu_background = $("#sound_wheel_menu_background");
var sound_wheel_menu_left = $("#sound_wheel_menu_left");
var sound_wheel_menu_right = $("#sound_wheel_menu_right");
sound_wheel_menu_background.SetHasClass("Visible", false);
var OpenState = false;
function CloseWheelMenu(){
    sound_wheel_menu_background.SetHasClass("Visible", false);
    OpenState = false;
}
function OpenWheelMenu(){
    if(OpenState){
        Game.EmitSound( "ui_menu_activate_close" );
        sound_wheel_menu_background.SetHasClass("Visible", false);
        OpenState = false;
        
    }else{
        Game.EmitSound( "ui.treasure_unlock.wav" );
        sound_wheel_menu_background.SetHasClass("Visible", true);
        OpenState = true;
        if(sound_wheel){
            CreateSoundHero();
        }else{
            var event_data = {
                player_id: Game.GetLocalPlayerID(),
            };
            GameEvents.SendCustomGameEventToServer("GetPlayerSoundWheel", event_data);
        }
    }
  
   
   
    

}

var fruits = ["Banana", "Orange", "Apple", "Mango"];
fruits.sort();
$.Msg(fruits);


var sound_wheel;
var nameSort;
function GetPlayerSoundWheel_feedback(keys){
    sound_wheel = {};
    nameSort = []
    for (const key in keys) {
       var type = SplitSoundName(key);
       if(!sound_wheel[type]){
        sound_wheel[type] = [];
        nameSort[nameSort.length] = type
       }
      
       sound_wheel[type][sound_wheel[type].length] = key;
    }



    // sound_wheel.sort();
    // $.Msg(sound_wheel);
    // $.Msg(nameSort);
    // 进行名字排序
    nameSort.sort();
    for (const key in sound_wheel) {
        var targetList = sound_wheel[key];
        targetList.sort();
    }



    CreateSoundHero();
}

function SplitSoundName(str){
    return str.split("_index_")[0];
}

function CreateSoundHero(){
    sound_wheel_menu_left.RemoveAndDeleteChildren();  //先清除

    var spellsContainer = sound_wheel_menu_left;
    for (let i = 0; i < nameSort.length; i++) {
        const heroName = nameSort[i];
        var abilityName = heroName+"_index_1"
        // $.Msg(abilityName);

        spellPanel = $.CreatePanel("Panel", spellsContainer, "wheel_image_Panel" + i);
        spellPanel.BLoadLayoutSnippet("wheel_image"); //载入模块
        var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
        image.abilityname = abilityName;
        spellPanel.FindChildInLayoutFile("sound_hero_name").text = $.Localize("#DOTA_Tooltip_ability_"+heroName+"_hero");

        var spellButton = spellPanel.FindChildInLayoutFile("Sound_wheelButton");
        AddOpenSoundListEvent(spellButton,heroName);
    }
    // var i = 0;
    // for (const key in sound_wheel) {
    //     var heroName = key;
    //     var abilityName = heroName+"_index_1"
    //     // $.Msg(abilityName);

    //     spellPanel = $.CreatePanel("Panel", spellsContainer, "wheel_image_Panel" + i);
    //     spellPanel.BLoadLayoutSnippet("wheel_image"); //载入模块
    //     var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
    //     image.abilityname = abilityName;
    //     spellPanel.FindChildInLayoutFile("sound_hero_name").text = $.Localize("#DOTA_Tooltip_ability_"+heroName+"_hero");

    //     var spellButton = spellPanel.FindChildInLayoutFile("Sound_wheelButton");
    //     AddOpenSoundListEvent(spellButton,key);
    //     i++;
    // }
}
function AddOpenSoundListEvent(spellButton,name){
    // spellButton.SetPanelEvent("onactivate", Function("BuySpell(\'" + spellStringified + "\')"));
    spellButton.SetPanelEvent("onactivate", function () {
        OpenSoundList(name);
    });

    // spellButton.SetPanelEvent("onmouseover", function () {
    //     $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,individualHeroSpell);
    // });

    // spellButton.SetPanelEvent("onmouseout", function () {
    //     $.DispatchEvent("DOTAHideAbilityTooltip");
    // });
}

function OpenSoundList(heroName){
    sound_wheel_menu_right.RemoveAndDeleteChildren();  //先清除

    var spellsContainer = sound_wheel_menu_right;
    var targetList = sound_wheel[heroName];
    var i = 0;
    for (const key in targetList) {
        var name = targetList[key];
        spellPanel = $.CreatePanel("Panel", spellsContainer, "single_sound_wheel_Panel" + i);
        spellPanel.BLoadLayoutSnippet("wheel_single_sound"); //载入模块
        spellPanel.FindChildInLayoutFile("single_sound_event_text").text = $.Localize("#DOTA_Tooltip_ability_"+name);

        // var spellButton = spellPanel.FindChildInLayoutFile("single_sound_event_icon");
        AddPlaySoundEvent(spellPanel,name);
        i++;
    }

}
function AddPlaySoundEvent(spellButton,name){
    spellButton.SetPanelEvent("onactivate", function () {
        PlaySoundWheel(name);
    });
}
function PlaySoundWheel(name){
    CloseWheelMenu();
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        soundName :name,
    }
    GameEvents.SendCustomGameEventToServer("PlaySoundWheel", event_data);
}

function CreateRandomHotKey(hotkey){
    let key = hotkey;
    const command = `On${key}${Date.now()}`;
    Game.CreateCustomKeyBind(key, `+${command}`);
    Game.AddCommand(
        `+${command}`,
        () => {
            OpenWheelMenu();
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

    GameEvents.Subscribe("GetPlayerSoundWheel_feedback", GetPlayerSoundWheel_feedback); //得到玩家数据反馈
    CreateRandomHotKey("F5");
})();



