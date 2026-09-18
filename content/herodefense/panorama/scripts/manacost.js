$.Msg("manacost running")

function FindDotaHud(string){
    var rootPanel = $.GetContextPanel();
    while (rootPanel.GetParent()) {
        rootPanel = rootPanel.GetParent();
    }
    return rootPanel.FindChildTraverse(string)
}
const mana_progress = FindDotaHud("ManaProgress")

if(mana_progress){
    var overlay = mana_progress.FindChild("ManaProgress_Overlay")
    if(!overlay){
        overlay = $.CreatePanel("Panel", mana_progress, "ManaProgress_Overlay")
    }
    overlay.style.backgroundColor = "rgba(255,0,0,0.5)"
    overlay.style.width = "0"
    overlay.style.height = "100%";
    (function loop(){
        $.Schedule(Game.GetGameFrameTime()/2, loop)
        let ability = Abilities.GetLocalPlayerActiveAbility()
        if(ability){
            let unit = Players.GetLocalPlayerPortraitUnit()
            let mana = Abilities.GetManaCost(ability)
            let max_mana = Math.max(Entities.GetMaxMana(unit),0.1);
            let now_mana = Entities.GetMana(unit)
            let mana_persent = mana/max_mana
            overlay.style.width = `${Math.min(100,mana/max_mana*100)}%`
            overlay.style.marginLeft = `${Math.max(0,now_mana/max_mana*100-mana_persent*100)}%`
            if(mana > Entities.GetMana(unit)){
                overlay.style.backgroundColor = "rgba(255,0,0,0.5)"
            }
            else{
                overlay.style.backgroundColor = "rgba(0,255,0,0.5)"
            }
            
        }else{
            overlay.style.width = "0"
        }
    })();
}
