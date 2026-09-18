var CustomUIConfig = GameUI.CustomUIConfig();
// let RuneKV = CustomUIConfig.ChaoticSpellRuneKV;
const ChaoticEra_playerArtifact_left_block = $("#ChaoticEra_playerArtifact_left_block");
const ChaoticEra_artifactBlock  = $("#ChaoticEra_artifactBlock");
let artifactData  = {};
// const ChaoticEraRuneModify_Button_4 =  $("#ChaoticEraRuneModify_Button_4");
// let currentActiveButton;
// let runeData = {};  //符石数据
let currentLevel = "1";
let bShowGetButton = false;
let bShowBuyButton = false;
function openPlayerArtifactList() {
    // bShowGetButton = true;
    OpenPlayerArtifactMenu(false,true);

}

function UpdatePlayerArfactPanel(){
    OpenArtifactList(currentLevel);
    // $.Msg("re open")
}
function OpenArtifactList(level,_bShowBuyButton,_bShowGetButton){
    // $.Msg("level=",level);
    currentLevel= level;
    if (_bShowGetButton) {
        bShowGetButton = _bShowGetButton;
    }
    if (_bShowBuyButton) {
        bShowBuyButton = _bShowBuyButton;
    }

    // $.Msg(bShowGetButton);

    let targetButton = ChaoticEra_playerArtifact_left_block.FindChildTraverse("ChaoticEraArtifactButton_"+level);
    if (currentActiveButton) {
        currentActiveButton.SetHasClass("Active", false);
    }
    if (targetButton) {
        targetButton.SetHasClass("Active", true);
        currentActiveButton = targetButton;
    
        CreateArtifactList(level);
    }


    // playerArtifact_Single
}
function CreateArtifactList(iLevel){
    ChaoticEra_artifactBlock.RemoveAndDeleteChildren();
    // ChaoticSpellKV_class5
    let targetKv = CustomUIConfig["ChaoticEra_PlayerArtifact"];
    
    var localPlayerID = Players.GetLocalPlayer();
    let artifactData;
    if (localPlayerID!=-1) {
        if (GameUI.CustomUIConfig().artifactData) {
            artifactData = GameUI.CustomUIConfig().artifactData[localPlayerID];
        }
    }
    // $.Msg(artifactData);
    // artifactData
    if (targetKv) {
        // $.Msg(targetKv);

        let i = 0;
        let spellPanel;
        for (const spellName in targetKv) {
            
            const element = targetKv[spellName];
            if (element.rarity==iLevel) {
    
                spellPanel = $.CreatePanel("Panel", ChaoticEra_artifactBlock, "artifactPanel" + i);
                spellPanel.BLoadLayoutSnippet("playerArtifact_Single"); //载入模块
                // $.Msg("url('s2r://panorama/images/custom_game/chaotic_era/PlayerArtifact/"+element.IconName+".png')");
                spellPanel.FindChildInLayoutFile("playerArtifact_icon").style.backgroundImage = "url('s2r://panorama/images/custom_game/chaotic_era/PlayerArtifact/"+element.IconName+".png')";
                spellPanel.SetDialogVariable("artifactName",$.Localize("#DOTA_Tooltip_ability_"+spellName))
                InitArtifactHover(spellPanel,artifactData,spellName,iLevel);
                spellPanel.FindChildInLayoutFile("ArtifactBottomBlock").SetHasClass("rarity"+iLevel,true);
                if (artifactData){
     
                    if (artifactData[spellName]["complete"]==1) {
                        if (bShowGetButton=="true" || bShowGetButton==true) {
                            spellPanel.FindChildInLayoutFile("GetArtifactButton").SetHasClass("chaoticGetMode",true);
                            // 活动，黄金取用消费减半
                            spellPanel.SetDialogVariable("aurumCost",element.AurumCost);
                            // $.Msg("GameUI.CustomUIConfig().GoldCurrency_number=",GameUI.CustomUIConfig().GoldCurrency_number);
                            // $.Msg("element.AurumCost=",element.AurumCost);
                            if (element.AurumCost>GameUI.CustomUIConfig().GoldCurrency_number) {
                                // $.Msg("fasfasfasfas");
                                spellPanel.FindChildInLayoutFile("aurum_cost").SetHasClass("redColored",true);
                                // InitGetArtifactEvent(spellPanel,spellName);
                                
                            }else{
                                // InitGetArtifactEvent(spellPanel,spellName);
                            }
                            InitGetArtifactEvent(spellPanel,spellName);
                           
                        }else{
                            spellPanel.FindChildInLayoutFile("GetArtifactButton").SetHasClass("chaoticGetMode",false);
                        }
                    }else{
        
                        // 如果已解锁就不显示了
                        if ((bShowBuyButton=="true"||bShowBuyButton==true) && element.PlatinumCost && element.PlatinumCost>0) {
                            spellPanel.FindChildInLayoutFile("BuyArtifactButton").SetHasClass("chaoticGetMode",true);
                            spellPanel.SetDialogVariable("platinumCost",element.PlatinumCost);
                            if (element.PlatinumCost>GameUI.CustomUIConfig().PlatinumCurrency_number) {
                                // $.Msg("fasfasfasfas");
                                spellPanel.FindChildInLayoutFile("platinum_cost").SetHasClass("redColored",true);
                                // InitGetArtifactEvent(spellPanel,spellName);
                                
                            }else{
                                // InitGetArtifactEvent(spellPanel,spellName);
                            }
                            InitBuyArtifactEvent(spellPanel,spellName);
                        }
    
                    }
                    

                    
                 
                }
               
                // chaoticGetMode
                
                // spellPanel.SetDialogVariable("spellName",$.Localize("#DOTA_Tooltip_ability_"+spellName));
                // var SpellLevel= spellPanel.FindChildInLayoutFile("spell_type_label");
                // var spellButton = spellPanel.FindChildInLayoutFile("single_general_spellButton");

                // // image.abilityname = spellName;
                // if (CustomUIConfig.AbilityBonusInfoKV[spellName]) {
                //     SpellLevel.text = $.Localize(CustomUIConfig.AbilityBonusInfoKV[spellName]["ChaoticSpellType"]);
                // }
            }
            if (true) {
                continue;
            }
            // const element = targetKv[spellName];
            i++;
            // $.Msg(element);
            
          

            addSpellInfoHoverEvens(spellPanel,spellName);
            AddChaoticSpellCheckRuneEvent(spellPanel,spellName);
          
        }
    }
}

function InitGetArtifactEvent(spellPanel,spellName){
    spellPanel.SetPanelEvent("onactivate", function () {
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            artifactName : spellName,
        }
        GameEvents.SendCustomGameEventToServer("TryTakeArtifact", event_data);
    });
}


function InitBuyArtifactEvent(spellButton,individualHeroSpell) {
    // spellButton.SetPanelEvent("onactivate", Function("BuySaveSpecialSpells_inMarket(\'" + individualHeroSpell + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        BuyGood_Artifact(individualHeroSpell);
    });


}



// 监听反馈
(function () {

    GameEvents.Subscribe("openArtifactList", openPlayerArtifactList); 


    GameEvents.Subscribe("UpdatePlayerArfactPanel", UpdatePlayerArfactPanel); 

  
})();




