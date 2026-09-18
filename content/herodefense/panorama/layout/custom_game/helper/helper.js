function Donothing(){


    //
}
var page = 1
var helper_menu_background = $("#helper_menu_background");
var helper_menu_left = $("#helper_menu_left");
var helper_menu_right = $("#helper_menu_right");
helper_menu_background.SetHasClass("Visible", false);
var OpenState = false;
function CloseWheelMenu(){
    helper_menu_background.SetHasClass("Visible", false);
    OpenState = false;
}
function OpenWheelMenu(){
    if(OpenState){
        Game.EmitSound( "ui_menu_activate_close" );
        helper_menu_background.SetHasClass("Visible", false);
        
        OpenState = false;
        
    }else{
        Game.EmitSound( "ui.treasure_unlock.wav" );
        helper_menu_background.SetHasClass("Visible", true);
        OpenState = true;
        if(helper){
            CreateSoundHero();
        }else{

        }
    }
  
   
   
    

}

// 在ChangePage函数或其他需要遍历的函数中调用
function ChangePage(keys) {

    var language="schinese"
    if ($.Language()=="schinese") {
        language="schinese"
    }
    if ($.Language()=="english") {
        language="english"
    }
    if ($.Language()=="russian") {
        language="russian"
    }
    $.Msg("#helper_"+language+"_"+page)
    for (let index = 1; index <= 4; index++) {
        panel = $("#helper_"+language+"_"+index)
        panel.SetHasClass("Visible_helper", true);
    }
    panel = $("#helper_"+language+"_"+page)
    panel.SetHasClass("Visible_helper", false);
    page++;
    if(page > 4){
        page = 1;
    }

    // 遍历并处理helper_menu下的所有Image元素
    
}
var fruits = ["Banana", "Orange", "Apple", "Mango"];
fruits.sort();
$.Msg(fruits);


var helper;
var nameSort;

GameEvents.Subscribe( "CameraShake",CameraShake)
function shakeCamera(duration, strength) {
    let startTime = Game.GetGameTime();
    let endTime = startTime + duration;
    let originalTargetPos = GameUI.GetCameraLookAtPosition();
    $.Msg(originalTargetPos)
    // 使用一个回调来持续更新位置直到结束时间
    let updateCallback = function() {
        if (Game.GetGameTime() < endTime) {
            let randomOffset = {
                x: Math.random()*(strength+strength)-strength,
                y: Math.random()*(strength+strength)-strength,
                z: Math.random()*(strength+strength)-strength // 如果需要，可以在这里添加Z轴上的抖动
            };
            $.Msg(randomOffset)
            let newTargetPos = {
                x: originalTargetPos[0] + randomOffset.x,
                y: originalTargetPos[1] + randomOffset.y,
                z: originalTargetPos[2] + randomOffset.z
            };
            
            // 应用新的目标位置
            GameUI.SetCameraTargetPosition(newTargetPos, 0.01); // 0.01是平滑过渡的时间
            
            // 持续调用自身直到结束时间
            $.Schedule(0.01, updateCallback);
        } else {
            // 重置到原始位置
            GameUI.SetCameraTargetPosition(originalTargetPos, 0.01);
        }
    };

    updateCallback();
}
function CameraShake(data){
    $.Msg("CameraShake test")
    $.Msg(data)
    shakeCamera(data.duration,data.strength)
}