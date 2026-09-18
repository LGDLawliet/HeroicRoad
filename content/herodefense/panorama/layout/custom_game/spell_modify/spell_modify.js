

var spell_modifyMenuwindowROOT = $("#spell_modifyMenuwindowROOT");
const spell_modifyPanel  = $("#spell_modifyPanel");
function Openspell_modifyMenu(){
    spell_modifyMenuwindowROOT.SetHasClass("show", true);
}

function ClosePanel(){
    spell_modifyMenuwindowROOT.SetHasClass("show", false);
}


let SpellDataList = {};
function SpellModifyData_feedBack(keys){
    let data = keys[1];
   
    if(SpellDataList[data.spellName]){
        if( SpellDataList[data.spellName].point==data.point){
            return;
        }
      
    }
    SpellDataList[data.spellName] ={};
    SpellDataList[data.spellName].point = data.point;
    SpellDataList[data.spellName].option =  data.option;
    SpellDataList[data.spellName].name = data.spellName;



    spell_modify_OptionList_content.RemoveAndDeleteChildren();
    spell_modifyInfo_currentPoint.SetDialogVariable("value1", 0);
    currentSpell = null;

    UpdateList();
    spell_modifyPanel.SetHasClass("show",true);

}



const  spell_modify_SpellList =  $("#spell_modify_SpellList");
function UpdateList(){
    spell_modify_SpellList.RemoveAndDeleteChildren();
    let index = 0;
    for (var key in SpellDataList) {
        if (SpellDataList.hasOwnProperty(key) ) {
            var individualHeroSpellName = key;
            var data = SpellDataList[key];
            spellPanel = $.CreatePanel("Panel", spell_modify_SpellList, "spellModify_" + index);
            spellPanel.BLoadLayoutSnippet("spell");

            var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
            image.abilityname = individualHeroSpellName;


            var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
            addSpellModifyEvens(spellButton,individualHeroSpellName,data)
            index++;
        }
    }
}


function addSpellModifyEvens(spellButton,name,data){
    // spellButton.SetPanelEvent("onactivate", Function("UnlockSpell(   \'" + name + "\' , \'" + spellsClass + "\'      )"));
    spellButton.SetPanelEvent("onactivate", function () {
        CheckSpell(name,data);
    });
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,name);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });
}

const spell_modifyInfo_currentPoint =  $("#spell_modifyInfo_currentPoint");
const spell_modify_OptionList_content =  $("#spell_modify_OptionList_content");
spell_modifyInfo_currentPoint.SetDialogVariable("value1", 0);
let currentDataList = [];
let currentSpell;
function CheckSpell(spellname,data){
    spell_modifyInfo_currentPoint.SetDialogVariable("value1", data.point);
    spell_modify_OptionList_content.RemoveAndDeleteChildren();
    let index = 0;
    currentSpell = spellname;
    currentDataList = [];
    for (const key in data.option) {
        if (Object.hasOwnProperty.call( data.option, key)) {
            let name =  data.option[key];

            spellPanel = $.CreatePanel("Panel", spell_modify_OptionList_content, "spellModifyAttribute_" + index);
            spellPanel.BLoadLayoutSnippet("modifyOption");

            spellPanel.FindChildInLayoutFile("Bonus_Attributes_Label").text =$.Localize("#"+name);
            let currentLength = currentDataList.length
            currentDataList[currentLength] =  {};
            currentDataList[currentLength].target =spellPanel.FindChildInLayoutFile("Bonus_attributes");
            currentDataList[currentLength].name = name;
            // var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
            // addSpellModifyEvens(spellButton,individualHeroSpellName,data)
            index++;
        }
    }
}

function SendBonusAttributes(){
    // let dataList = spell_modify_OptionList_content.Children();
    if(!currentSpell){
        return;
    }
    let send = false;
    let data = {
        player_id: Game.GetLocalPlayerID(),
        spell : currentSpell,

    };
    let optionList = {}
    for (let index = 0; index < currentDataList.length; index++) {
        const element = currentDataList[index];
        if(element.target.value>0){
            send = true;
            optionList[element.name] = element.target.value;
        }

        
    }
    if(send){
        data.options = optionList;
        GameEvents.SendCustomGameEventToServer("SpellModifySend",  data );
        spell_modify_OptionList_content.RemoveAndDeleteChildren();
        spell_modify_SpellList.RemoveAndDeleteChildren();
        spell_modifyInfo_currentPoint.SetDialogVariable("value1", 0);
        spell_modifyPanel.SetHasClass("show",false);
        SpellDataList = {};
        ClosePanel();
        currentSpell = null;
    }
    
}

(function () {
	GameEvents.Subscribe("SpellModifyData", SpellModifyData_feedBack);

})();






