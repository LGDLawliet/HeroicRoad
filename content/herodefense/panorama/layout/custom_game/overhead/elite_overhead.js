

// var overhead = $("#overhead");  //上面

let base = $.GetContextPanel().GetParent().GetParent().GetParent();
var base_panel  = base.FindChildTraverse("HeroRelicProgress");
// 把板子放这里才不会遮挡到某些ui
// $.Msg(base_panel);

function CreateHealthBar(keys) {
    // $.Msg(keys);
    var unit =keys.enemyIndex;
    if (Entities.IsValidEntity(unit)) {
        let panel = $.CreatePanel("Panel", base_panel, "Hp");
        // $.Msg(panel);
        // var buffPanel = $.CreatePanel( "Panel", buffsListPanel, "" );
        panel.BLoadLayout( "file://{resources}/layout/custom_game/overhead/over_head_health_bar.xml", false, false );

        // panel.BLoadLayoutSnippet("EliteHealthBarSnippet");
        var unit_name =Entities.GetUnitName( unit );
        panel.FindChildTraverse("EliteName").text = $.Localize("#"+unit_name);

        
        // var class_name =Entities.GetClassNameAsCStr( unit )
        // $.Msg(unit_name);
        // $.Msg(class_name);
        UpdateHealthBarPosition(unit, panel);
    }
}

function UpdateHealthBarPosition(unit, panel) {
    
    if (!Entities.IsAlive(unit)) {
        panel.DeleteAsync(0);
    }
    else {
        // var units = Entities.GetAllEntitiesByName( unit_name );
        var buffs = Entities.GetNumBuffs( unit );
        const HPBar = panel.FindChildTraverse("EliteHpBar");
        var healthbar = Entities.NoHealthBar( unit );
        
        if(buffs<=0 || healthbar==true){
            // buff数量为0说明没有视野
            panel.style.visibility = "collapse";
            $.Schedule(0, () => UpdateHealthBarPosition(unit, panel));
            return;
        }
        // HPBar.style.visibility = "visible";
        var origin = Entities.GetAbsOrigin(unit);
        panel.style.visibility = "visible";
        var offSet = Entities.GetHealthBarOffset(unit);
        // if (offSet <= 0) {
        //     offSet = 150;
        // }
        //更新位置
        var newX = Game.WorldToScreenX(origin[0], origin[1], origin[2] + offSet);
        var newY = Game.WorldToScreenY(origin[0], origin[1], origin[2] + offSet);
        panel.SetPositionInPixels((newX - panel.actuallayoutwidth / 2) / panel.actualuiscale_x, (newY - panel.actuallayoutheight) / panel.actualuiscale_y, -10);
        //更新当前血量
       
        let hp = Entities.GetHealth(unit) / Entities.GetMaxHealth(unit);
        HPBar.value = hp;
        const HPWhiteBar = panel.FindChildTraverse("EliteHpBarWhite");
        var value = HPWhiteBar.value;
        if(value>hp){
            value = Math.max(value  -0.0005,hp);
        }else{
            value = hp;
        }
        HPWhiteBar.value = value;
        
        $.Schedule(0, () => UpdateHealthBarPosition(unit, panel));
    }
}


(function () {
    GameEvents.Subscribe("elite_health_bar_create", CreateHealthBar);
})();