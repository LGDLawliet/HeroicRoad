var playerSpellslibraryMenuwindowROOT = $("#playerSpellslibraryMenuwindowROOT");
var playerGameShopMenuwindowROOT = $("#playerGameShopMenuwindowROOT");
var customSpellsMenuPanel = $("#SpellsWindowPanel");
var playerinfo_vip = $("#playerinfo_vip");
var customSpellsinfo_detailPanel = $("#Spellsinfo_detail");
var playerParticleMenuwindowROOT = $("#playerParticleMenuwindowROOT");
var spell_info_inside_text = customSpellsinfo_detailPanel.FindChildTraverse("Spells_info_inside").FindChildTraverse("spell_info_inside_text"); 
var spell_info_inside_text_2 = customSpellsinfo_detailPanel.FindChildTraverse("Spells_info_inside").FindChildTraverse("spell_info_inside_text_2"); 
var exp_number = $("#Spellsinfo_exp_WindowPanel").FindChildTraverse("Spellsinfo_exp_number");

var playerGameBonusMenuwindowROOT = $("#playerGameBonusMenuwindowROOT");
var playerInfowindowROOT = $("#playerInfowindowROOT");

var Buy_GOODS_Confirm_Panel = $("#Buy_GOODS_Confirm_Panel");
var SpecificTeamDataRoot = $("#SpecificTeamDataRoot");  //成绩面板
var playerParticleMenuwindowROOT = $("#playerParticleMenuwindowROOT");
var playerAchievementMenuwindowROOT = $("#playerAchievementMenuwindowROOT");
var playerChaoticEraSpellslibraryMenuwindowROOT = $("#playerChaoticEraSpellslibraryMenuwindowROOT");
var playerArtifactMenuwindowROOT = $("#playerArtifactMenuwindowROOT");
var playerData;  //储存玩家数据

var targetSpellName = ""  //储存技能名
var targetSpellLevel = 0;  //储存技能目前等级
var reliableExp = 0; //记录需要消耗的经验值
var nextexp = 0;   //记录升级技能后技能的经验值
var opentargetFunction = -1; //记录当前打开的类型  物理=0 魔法=1 召唤=2 防御=3 辅助=4 其他=5
var CanSpellBeUpgraded = true; //false的时候不会弹出升级按钮
// playerSpellslibraryMenuwindowROOT.SetHasClass("Visible", false);
// playerGameShopMenuwindowROOT.SetHasClass("Visible", false);
// playerGameBonusMenuwindowROOT.SetHasClass("Visible", false);
// playerParticleMenuwindowROOT.SetHasClass("Visible", false);
// playerAchievementMenuwindowROOT.SetHasClass("Visible", false);

const MenuList =[
    playerSpellslibraryMenuwindowROOT,
    playerGameShopMenuwindowROOT,
    playerGameBonusMenuwindowROOT,
    playerInfowindowROOT,
    playerParticleMenuwindowROOT,
    playerAchievementMenuwindowROOT,
    playerChaoticEraSpellslibraryMenuwindowROOT,
    playerArtifactMenuwindowROOT,
];
for (const key in MenuList) {
    MenuList[key].SetHasClass("Visible", false);
};
playerInfowindowROOT.SetHasClass("Visible", false);
Buy_GOODS_Confirm_Panel.SetHasClass("Visible", false);
spell_info_inside_text.SetHasClass("Visible", false);
spell_info_inside_text_2.SetHasClass("Visible", false);



var playerSpellslibraryMenuwindowTitle = $("#playerSpellslibraryMenuwindowTitle");
// playerSpellslibraryMenuwindowTitle.SetPanelEvent("onactivate", Function("CloseplayerSpellslibraryMenuwindow()"));
playerSpellslibraryMenuwindowTitle.SetPanelEvent("onactivate", function () {
    // CloseplayerSpellslibraryMenuwindow();
    CloseAllPanel();
});

var CurrencyWindowPanel = $("#playerGameShopMenuwindowROOT").FindChildTraverse("CurrencyWindowPanel");

//获取货币栏数值
var ReliableExperienceCurrency_number = CurrencyWindowPanel.FindChildTraverse("ReliableExperienceCurrencyPanel").FindChildTraverse("ReliableExperienceCurrency_number");
var GoldCurrency_number = CurrencyWindowPanel.FindChildTraverse("GoldCurrencyPanel").FindChildTraverse("GoldCurrency_number");
var PlatinumCurrency_number = CurrencyWindowPanel.FindChildTraverse("PlatinumCurrencyPanel").FindChildTraverse("PlatinumCurrency_number");

// 打开技能图鉴
function  OpenplayerSpellslibraryMenu(){
    GetPlayerDate() //首先先去lua拿数据更新一下
    for (const key in MenuList) {
        MenuList[key].SetHasClass("Visible", false);
    }
    playerSpellslibraryMenuwindowROOT.SetHasClass("Visible", true); 
    Game.EmitSound( "ui_menu_activate_open" );
}

function  OpenChaoticEraLibraryMenu(){
    GetPlayerDate() //首先先去lua拿数据更新一下
    GetChaoticEraRuneData();
    for (const key in MenuList) {
        MenuList[key].SetHasClass("Visible", false);
    }
    playerChaoticEraSpellslibraryMenuwindowROOT.SetHasClass("Visible", true); 
    Game.EmitSound( "ui_menu_activate_open" );
}

// 打开圣物图鉴
function OpenPlayerArtifactMenu(_bShowBuyButton,_bShowGetButton){
    GetPlayerDate() //首先先去lua拿数据更新一下
    // GetChaoticEraRuneData();
    for (const key in MenuList) {
        MenuList[key].SetHasClass("Visible", false);
    }
    playerArtifactMenuwindowROOT.SetHasClass("Visible", true); 
    Game.EmitSound( "ui_menu_activate_open" );
    // $.Msg(_bShowBuyButton,_bShowGetButton)
    OpenArtifactList(currentLevel,_bShowBuyButton,_bShowGetButton);
}

// 打开商城
function OpenplayerShopMenu(){
    GetPlayerDate() //首先先去lua拿数据更新一下
    for (const key in MenuList) {
        MenuList[key].SetHasClass("Visible", false);
    }
    playerGameShopMenuwindowROOT.SetHasClass("Visible", true);
    Game.EmitSound( "ui_menu_activate_open" );
}
//打开特效仓库
function OpenplayerParticleMenu() {
    GetPlayerDate() //首先先去lua拿数据更新一下
    for (const key in MenuList) {
        MenuList[key].SetHasClass("Visible", false);
    }
    playerParticleMenuwindowROOT.SetHasClass("Visible", true);
    Game.EmitSound( "ui_menu_activate_open" );
}


function OpenAchievementMenu() {
    GetPlayerDate() //首先先去lua拿数据更新一下
    for (const key in MenuList) {
        MenuList[key].SetHasClass("Visible", false);
    }
    playerAchievementMenuwindowROOT.SetHasClass("Visible", true);
    Game.EmitSound( "ui_menu_activate_open" );


}



function OpenplayerinfoMenu(){
    GetPlayerDate() //首先先去lua拿数据更新一下
    for (const key in MenuList) {
        MenuList[key].SetHasClass("Visible", false);
    }
    playerInfowindowROOT.SetHasClass("Visible", true);
    Game.EmitSound( "ui_menu_activate_open" );
}
function CloseAllPanel(){
    Game.EmitSound( "ui_menu_activate_close" );
    for (const key in MenuList) {
        $.Msg(MenuList[key]);
        MenuList[key].SetHasClass("Visible", false);
    }

    bShowGetButton = false;

}


//清除所有需要重置的 当升级技能收到服务器的反馈后执行
//将会把页面数据清空
function resetPanel() {
    customSpellsMenuPanel.RemoveAndDeleteChildren();  

    var Spells_info_ExpBar_Progress = customSpellsinfo_detailPanel.FindChildTraverse("Spells_info_ExpBar_Progress");
    customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name").text = "";
    // customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level_number").text =0; // mark
    customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level").text = $.Localize("#DOTA_HUD_Spellsinfo_level_now") + "0";

    Spells_info_ExpBar_Progress.FindChildTraverse("Spells_info_ExpBar_Progress_Left").style.width = "0px";
    Spells_info_ExpBar_Progress.FindChildTraverse("spell_info_level_progress_text").text = "0/0";
    customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", false);  //隐藏经验分配按钮
    // customSpellsinfo_detailPanel.FindChildTraverse("ForceBuySpellButton").SetHasClass("Visible", false);  //隐藏经验分配按钮

    
    // OpenPhysicalSpellsMenu();
}
//关闭技能图鉴窗口
//会关闭所有窗口
function CloseplayerUnitsLibraryMenuwindow(){
    Game.EmitSound( "ui_menu_activate_close" );
    playerSpellslibraryMenuwindowROOT.SetHasClass("Visible", false);
    playerGameShopMenuwindowROOT.SetHasClass("Visible", false);
    playerInfowindowROOT.SetHasClass("Visible", false);
}
var PhysicalSpellsButton = $("#PhysicalSpellsButton");
var MagicalSpellsButton = $("#MagicalSpellsButton");
var SummonSpellsButton = $("#SummonSpellsButton");
var DefenseSpellsButton = $("#DefenseSpellsButton");
var AssistSpellsButton = $("#AssistSpellsButton");
var OtherSpellsButton = $("#OtherSpellsButton");

// playerSpellslibraryMenuwindowROOT.FindChildTraverse("playerSpellslibraryMenuwindowPostGameBG1").SetHasClass("Visible", false);


var currentONpanel = playerSpellslibraryMenuwindowROOT.FindChildTraverse("playerSpellslibraryMenuwindowPostGameBG1");
currentONpanel.SetHasClass("Visible", true);
// currentONpanel.SetHasClass("Visible", true);
function OpenPhysicalSpellsMenu() {  
    OpenSpellsMenu(0);
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", true);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    // currentONpanel.SetHasClass("Visible", false);
    // currentONpanel = playerSpellslibraryMenuwindowROOT.FindChildTraverse("playerSpellslibraryMenuwindowPostGameBG1");
    // currentONpanel.SetHasClass("Visible", true);
    currentONpanel.style.hueRotation="170deg"; 
    currentONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;

    opentargetFunction = 0;
}//展开物理技能
function OpenMagicalSpellsMenu() {  
    OpenSpellsMenu(1);
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", true);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    // currentONpanel.SetHasClass("Visible", false);
    // currentONpanel = playerSpellslibraryMenuwindowROOT.FindChildTraverse("playerUnitsLibraryMenuwindowPostGameBG2");
    // currentONpanel.SetHasClass("Visible", true);
    currentONpanel.style.hueRotation="30deg"; 
    currentONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    opentargetFunction = 1;
}//展开魔法技能
function OpenSummonSpellsMenu() {  
    OpenSpellsMenu(2);
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", true);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    // currentONpanel.SetHasClass("Visible", false);
    // currentONpanel = playerSpellslibraryMenuwindowROOT.FindChildTraverse("playerUnitsLibraryMenuwindowPostGameBG3");
    // currentONpanel.SetHasClass("Visible", true);
    currentONpanel.style.hueRotation="200deg"; 
    currentONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    opentargetFunction = 2;
}//展开召唤技能
function OpenDefenseSpellsMenu() {  
    OpenSpellsMenu(3);
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", true);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    // currentONpanel.SetHasClass("Visible", false);
    // currentONpanel = playerSpellslibraryMenuwindowROOT.FindChildTraverse("playerUnitsLibraryMenuwindowPostGameBG4");
    // currentONpanel.SetHasClass("Visible", true);
    currentONpanel.style.hueRotation="60deg"; 
    currentONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;

    opentargetFunction = 3;
}//展开防御技能
function OpenAssistSpellsMenu() {  
    OpenSpellsMenu(4);
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", true);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", false);
    // currentONpanel.SetHasClass("Visible", false);
    // currentONpanel = playerSpellslibraryMenuwindowROOT.FindChildTraverse("playerUnitsLibraryMenuwindowPostGameBG5");
    // currentONpanel.SetHasClass("Visible", true);
    currentONpanel.style.hueRotation="270deg"; 
    currentONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    opentargetFunction = 4;

}//展开辅助技能
function OpenOtherSpellsMenu() {  
    OpenSpellsMenu(5);
    PhysicalSpellsButton.SetHasClass("PhysicalSpellsButton_on", false);
    MagicalSpellsButton.SetHasClass("MagicalSpellsButton_on", false);
    SummonSpellsButton.SetHasClass("SummonSpellsButton_on", false);
    DefenseSpellsButton.SetHasClass("DefenseSpellsButton_on", false);
    AssistSpellsButton.SetHasClass("AssistSpellsButton_on", false);
    OtherSpellsButton.SetHasClass("OtherSpellsButton_on", true);
    // currentONpanel.SetHasClass("Visible", false);
    // currentONpanel = playerSpellslibraryMenuwindowROOT.FindChildTraverse("playerUnitsLibraryMenuwindowPostGameBG6");
    // currentONpanel.SetHasClass("Visible", true);
    currentONpanel.style.hueRotation="0deg"; 
    currentONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    opentargetFunction = 5;
}//展开其他技能


function OpenAttachParticleMenu() {
    
}

//展开技能列表
function OpenSpellsMenu(spellclass) {
    Game.EmitSound( "ui_hero_select_slide" );
    GetPlayerDate()
    customSpellsMenuPanel.RemoveAndDeleteChildren();  //先清除
    var spellsContainer = customSpellsMenuPanel;


    var spellPanel;
    var XPTable = playerData.spellmap.spellsXPTable
    // $.Msg(XPTable);
    for (var i = 0; i < spells[spellclass].length; i++) {
        // $.Msg(spells[spellclass][i])
        if (spells[spellclass][i]) {
            var individualHeroSpell = spells[spellclass][i];
            spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
            spellPanel.BLoadLayoutSnippet("general_spell"); //载入模块
    
            var image = spellPanel.FindChildInLayoutFile("single_general_spell"); //找到图片
            spellPanel.SetDialogVariable("spellName",$.Localize("#DOTA_HUD_Spells_Menu_level"));
            var SpellLevel= spellPanel.FindChildInLayoutFile("spell_type_label");
            var spellButton = spellPanel.FindChildInLayoutFile("single_general_spellButton");
            // 当技能未解锁时显灰色
            if (playerData.spellmap.spellmap) {

                //技能表里没这个技能 显灰 0级
                if (!playerData.spellmap.spellmap.spells[individualHeroSpell]) {
                    image.SetHasClass("gray",true)
                    SpellLevel.text =0;
                }else{
                    //开始判断目前技能等级
                    var xp = playerData.spellmap.spellmap.spells[individualHeroSpell]
                    var spellslevel = 0
                    for (const key in XPTable) {
                        if (xp>=XPTable[key]) {
                            spellslevel = spellslevel + 1;
                        }else{
                            break
                        }
                        // $.Msg(XPTable[key]);
                    }
                    // $.Msg(playerData.spellmap.spellmap.spells[individualHeroSpell.spell_id]);
                    
                    SpellLevel.text =spellslevel;

                }
            }
            image.abilityname = individualHeroSpell;  //设置技能名
            addSpellInfoEvens(spellButton,individualHeroSpell);
        }
      
    }
}

function addSpellInfoEvens(spellButton,individualHeroSpell) {
    // spellButton.SetPanelEvent("onactivate", Function("GetSpellinfo(\'" + individualHeroSpell + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        GetSpellinfo(individualHeroSpell);
    });

    addSpellInfoHoverEvens(spellButton,individualHeroSpell);
    // spellButton.SetPanelEvent("onmouseover", function () {
    //     $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,individualHeroSpell);
    // });

    // spellButton.SetPanelEvent("onmouseout", function () {
    //     $.DispatchEvent("DOTAHideAbilityTooltip");
    // });
    // spellButton.style.tooltipPosition = "top";
    // spellButton.style.tooltipBodyPosition = "50% 50%";
    // spellButton.SetHasClass("myhero_spellimage",true)
}

var nowSelectedSpellName = "none";
var now_type = 1;


var Spellsinfo_levelInfo = customSpellsinfo_detailPanel.FindChildTraverse("Spellsinfo_levelInfo");
var Spellsinfo_ParticleInfo = customSpellsinfo_detailPanel.FindChildTraverse("Spellsinfo_ParticleInfo");

Type_On = 1;
Type_Off = 2;
Type_locked = 3;
//获取技能数据
function GetSpellinfo(spellname){

    Spellsinfo_ParticleInfo.SetHasClass("Visible", false); 
    Spellsinfo_levelInfo.SetHasClass("Visible", false); 
    GetPlayerDate()
    nowSelectedSpellName = spellname;
    Game.EmitSound( "ui_rolloff_today" );
    Spellsinfo_ParticleInfo.RemoveAndDeleteChildren();  //先清除
    // 技能特效切换
    if (now_type==3) {
       var particleInfo = playerData.spellmap.spellmap.Particle.SpellParticle; //拿到特效数据
    //    $.Msg(particleInfo);
        Spellsinfo_levelInfo.SetHasClass("Visible", false); 
        Spellsinfo_ParticleInfo.SetHasClass("Visible", true); 
        // var info = spellsParticle[nowSelectedSpellName];
        if(particleInfo[nowSelectedSpellName]){
            // 说明该玩家拥有这个技能的某个特效
            var info = particleInfo[nowSelectedSpellName];
            var on_Particle_Name = info.on_Particle;
            var particle_Set = info.ParticleSet
            // $.Msg(on_Particle_Name);
            var particleName = "ability_particle_0";
            spellPanel = $.CreatePanel("Panel", Spellsinfo_ParticleInfo, "spellParticlePanel0");
            spellPanel.BLoadLayoutSnippet("spellParticle"); //载入模块
            var image = spellPanel.FindChildInLayoutFile("SingleSpellParticleImage"); //找到图片
            image.abilityname = particleName;  //设置技能名
            var spellButton = spellPanel.FindChildInLayoutFile("ParticleButton");
            addSpellParticleShiftEvens(spellButton,particleName);
            var SingleSpellParticlePanelButton = spellPanel.FindChildInLayoutFile("SingleSpellParticlePanelButton");
            addSpellParticleHoverEvens(SingleSpellParticlePanelButton,particleName)
            var ParticleButtonLabel = spellPanel.FindChildInLayoutFile("ParticleButtonLabel");
            var ParticleButtonLabel2 = spellPanel.FindChildInLayoutFile("ParticleButtonLabel2");
            ParticleButtonLabel2.text = $.Localize("#DOTA_HUD_Forver");
            if(on_Particle_Name=="ability_particle_0"){
                
                ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_locked");
                spellButton.SetHasClass("particleOn",true);
            }else{
                ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_on");
                spellButton.SetHasClass("particleOff",true);
            }
            for (const key in particle_Set) {
                var particleName = key;
                spellPanel = $.CreatePanel("Panel", Spellsinfo_ParticleInfo, "spellParticlePanel" + (i+1));
                spellPanel.BLoadLayoutSnippet("spellParticle"); //载入模块
                var image = spellPanel.FindChildInLayoutFile("SingleSpellParticleImage"); //找到图片
                image.abilityname = particleName;  //设置技能名
                var spellButton = spellPanel.FindChildInLayoutFile("ParticleButton");
                addSpellParticleShiftEvens(spellButton,particleName);
                var SingleSpellParticlePanelButton = spellPanel.FindChildInLayoutFile("SingleSpellParticlePanelButton");
                addSpellParticleHoverEvens(SingleSpellParticlePanelButton,particleName)
                var ParticleButtonLabel = spellPanel.FindChildInLayoutFile("ParticleButtonLabel");
                if(on_Particle_Name==particleName){
                    ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_off");
                    spellButton.SetHasClass("particleOn",true);
                }else{
                    ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_on");
                    spellButton.SetHasClass("particleOff",true);
                }
                ParticleButtonLabel2 = spellPanel.FindChildInLayoutFile("ParticleButtonLabel2");
                var time = particle_Set[key];
                var firstToSecond = time.substr(0,2)

                if (firstToSecond=="21") {
                    ParticleButtonLabel2.text = $.Localize("#DOTA_HUD_Forver");
                }else{
                    ParticleButtonLabel2.text =particle_Set[key]+"UTC+8";
                }
            }
        }else{
            // 说明一个特效都没解锁 直接创建默认特效即可
            // $.Msg("no");
            var particleName = "ability_particle_0";
            spellPanel = $.CreatePanel("Panel", Spellsinfo_ParticleInfo, "spellParticlePanel0");
            spellPanel.BLoadLayoutSnippet("spellParticle"); //载入模块
            var image = spellPanel.FindChildInLayoutFile("SingleSpellParticleImage"); //找到图片
            image.abilityname = particleName;  //设置技能名
            var spellButton = spellPanel.FindChildInLayoutFile("ParticleButton");
           
            // addSpellParticleShiftEvens(spellButton,particleName); 不需要绑定切换事件
            var SingleSpellParticlePanelButton = spellPanel.FindChildInLayoutFile("SingleSpellParticlePanelButton");
            addSpellParticleHoverEvens(SingleSpellParticlePanelButton,particleName)
            var ParticleButtonLabel = spellPanel.FindChildInLayoutFile("ParticleButtonLabel");
            ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_locked");
            spellButton.SetHasClass("particleOn",true)
            var ParticleButtonLabel2 = spellPanel.FindChildInLayoutFile("ParticleButtonLabel2");
            ParticleButtonLabel2.text = $.Localize("#DOTA_HUD_Forver");
        }
    }else{
        Spellsinfo_levelInfo.SetHasClass("Visible", true); 
        Spellsinfo_ParticleInfo.SetHasClass("Visible", false); 
        var localize_name = "#DOTA_Tooltip_ability_"+spellname;
        // var spellslevel = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level_number").text; 

    
        customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name").text =$.Localize(localize_name);
        targetSpellName = spellname;//在这里记录技能名
        // customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level_number").text =$.Localize(localize_name); //mark
        
        customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level").text = $.Localize("#DOTA_HUD_Spellsinfo_level_now") + $.Localize(localize_name);
        
        var Spells_info_ExpBar_Progress = customSpellsinfo_detailPanel.FindChildTraverse("Spells_info_ExpBar_Progress");
        customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", false);  //总之先隐藏分配经验的按钮

        var XPTable = playerData.spellmap.spellsXPTable;
        if (playerData.spellmap.spellmap) {
            // 没有该技能时啥都不用处理 等级显示0就行
            if (!playerData.spellmap.spellmap.spells[spellname]) {
                // customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level_number").text =0; //mark
                customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level").text = $.Localize("#DOTA_HUD_Spellsinfo_level_now") + "0";
                Spells_info_ExpBar_Progress.FindChildTraverse("Spells_info_ExpBar_Progress_Left").style.width = "0px";
                Spells_info_ExpBar_Progress.FindChildTraverse("spell_info_level_progress_text").text = "0/0";
    
    
            }else{
                //开始判断目前技能等级
                var xp = playerData.spellmap.spellmap.spells[spellname];  //当前经验值
                var spellslevel = 0;
                for (const key in XPTable) {
                    if (xp>=XPTable[key]) {
                        spellslevel = spellslevel + 1;
                    }else{
                        break;
                    }
                }
                //拿到等级了 先设置一下等级显示 
                // customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level_number").text =spellslevel; // mark
                customSpellsinfo_detailPanel.FindChildTraverse("spell_info_level").text = $.Localize("#DOTA_HUD_Spellsinfo_level_now") + spellslevel;
                //修改经验条
                targetSpellLevel = spellslevel; //记录当前技能等级
                // 满级就回退1
                var needxp = XPTable[spellslevel+1];
                if (spellslevel==25) {
                    spellslevel = 24;
                    //满级了就不显示按钮了
                    customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", false);  //隐藏经验分配按钮
                    var rightwidth = Spells_info_ExpBar_Progress.FindChildTraverse("Spells_info_ExpBar_Progress_Right").desiredlayoutwidth+ "px";
                    //不知道为啥获取的是333px
                    var rightwidth = "400px";
                    // $.Msg(rightwidth); //jsprint
                    Spells_info_ExpBar_Progress.FindChildTraverse("Spells_info_ExpBar_Progress_Left").style.width = rightwidth;//设置经验条
                    Spells_info_ExpBar_Progress.FindChildTraverse("spell_info_level_progress_text").text =  "MAX" ;  //设置经验条
                }else{
                    reliableExp =needxp - xp;  //计算出需要的经验值
                    nextexp = needxp;
                    
                    //当满足升级需求才显示
                    if (playerData.spellmap.spellmap.playerinfo.reliableExp>=reliableExp) {
                        customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", true);  //显示经验分配按钮
                    }else{
                        customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", false);  //隐藏经验分配按钮
                    }
                                // var needxp = XPTable[spellslevel+1];
                    //不知道为啥获取的是333px
                    var rightwidth = Spells_info_ExpBar_Progress.FindChildTraverse("Spells_info_ExpBar_Progress_Right").desiredlayoutwidth;
    
                    var rightwidth = 400;
                    var exp_gap = needxp - XPTable[spellslevel];//求出两级的经验差
                    var exp_now_gap = xp - XPTable[spellslevel]; //标准化目前经验
                    // $.Msg(rightwidth); //jsprint
                    var nextwidth = rightwidth*exp_now_gap/exp_gap + "px";
                    // var nextwidth = rightwidth*xp/needxp + "px";
                    // Spells_info_ExpBar_Progress.FindChildTraverse("Spells_info_ExpBar_Progress_Left").style.width = nextwidth;//设置经验条
                    // Spells_info_ExpBar_Progress.FindChildTraverse("spell_info_level_progress_text").text = xp + "/" +needxp;  //设置经验条
                    Spells_info_ExpBar_Progress.FindChildTraverse("Spells_info_ExpBar_Progress_Left").style.width = nextwidth;//设置经验条
                    Spells_info_ExpBar_Progress.FindChildTraverse("spell_info_level_progress_text").text = exp_now_gap + "/" +exp_gap;  //设置经验条
                }
    
    
               
            }
        }
        if (CanSpellBeUpgraded==false) {
            customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", false);  //隐藏经验分配按钮
        }
        // $.Msg(spell_info[spellname]);
        var localizeName = "#DOTA_HUD_Spell_Info_"+spellname;
    
        if (now_type==1) {
            spell_info_inside_text_2.SetHasClass("Visible", false);
            let ad_note_loc_string_text;
            let ad_note_loc_string;
        
            var unlock = $.Localize("#DOTA_Tooltip_ability_Unlock");
            var ad_note_loc_token = `DOTA_Tooltip_ability_${spellname}_note_base_Info`;
            ad_note_loc_string_text = $.Localize("#" + ad_note_loc_token);
            // ad_note_loc_string_text = ad_note_loc_string_text.replaceAll("%%", '%');
            ad_note_loc_string = "<font color='#40484a'>—————————————————————————————</font><br/><font color='#058a94'>"+  ad_note_loc_string_text+"</font><br/>";
            
            spell_info_inside_text.SetDialogVariable("InfoBase", ad_note_loc_string);
            /////////////////////////////////////////////////////////////////
            ad_note_loc_token = `DOTA_Tooltip_ability_${spellname}_note_lv5`;
            ad_note_loc_string_text = $.Localize("#" + ad_note_loc_token);
            // ad_note_loc_string_text = ad_note_loc_string_text.replaceAll("%%", '%');
            ad_note_loc_string = "<font color='#40484a'>—————————————————————————————</font><br/><font color='#7f8da8'>"+"LV5:" + unlock +   ad_note_loc_string_text+"</font><br/>";
            // $.Msg(ad_note_loc_string);
            ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(spellname, ad_note_loc_string);

            spell_info_inside_text.SetDialogVariable("Infolv5", ad_note_loc_string);
            /////////////////////////////////////////////////////////////////
            ad_note_loc_token = `DOTA_Tooltip_ability_${spellname}_note_lv10`;
            ad_note_loc_string_text = $.Localize("#" + ad_note_loc_token);
            // ad_note_loc_string_text =ad_note_loc_string_text.replaceAll("%%", "%");
            ad_note_loc_string = "<br/>"  +  "<font color='#40484a'>—————————————————————————————</font><br/><font color='#7f8da8'>"+ "LV10:" + unlock + ad_note_loc_string_text+"</font><br/>";
            ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(spellname, ad_note_loc_string);

            spell_info_inside_text.SetDialogVariable("Infolv10", ad_note_loc_string);
            /////////////////////////////////////////////////////////////////
            ad_note_loc_token = `DOTA_Tooltip_ability_${spellname}_note_lv15`;
            ad_note_loc_string_text = $.Localize("#" + ad_note_loc_token);
            // ad_note_loc_string_text =ad_note_loc_string_text.replaceAll("%%", "%");
            ad_note_loc_string = "<br/>" + "<font color='#40484a'>—————————————————————————————</font><br/><font color='#7f8da8'>"+ "LV15:" + unlock + ad_note_loc_string_text+"</font><br/>";
            ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(spellname, ad_note_loc_string);

            spell_info_inside_text.SetDialogVariable("Infolv15", ad_note_loc_string);
            /////////////////////////////////////////////////////////////////
            ad_note_loc_token = `DOTA_Tooltip_ability_${spellname}_note_lv20`;
            ad_note_loc_string_text = $.Localize("#" + ad_note_loc_token);
            // ad_note_loc_string_text =ad_note_loc_string_text.replaceAll("%%", "%");
            ad_note_loc_string = "<br/>" + "<font color='#40484a'>—————————————————————————————</font><br/><font color='#7f8da8'>"+ "LV20:" + unlock + ad_note_loc_string_text+"</font>";
            ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(spellname, ad_note_loc_string);
            
            spell_info_inside_text.SetDialogVariable("Infolv20", ad_note_loc_string);
        
            spell_info_inside_text.SetHasClass("Visible", true);
        }else{
            GetSpellLV25Info();
        }
    }





    


}



function addSpellParticleShiftEvens(spellButton,Name) {
    // spellButton.SetPanelEvent("onactivate", Function("ShiftParticle(\'" + Name + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        ShiftParticle(Name);
    });
}

function addSpellParticleHoverEvens(spellButton,Name) {
    addSpellInfoHoverEvens(spellButton,Name);
}
function ShiftParticle(Name) {
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        particleName : Name,
        spellName :nowSelectedSpellName,

    }
    GameEvents.SendCustomGameEventToServer("ShiftParticle", event_data);
}

function GetNextSpellPage(){
    if (now_type==1) {
        now_type=2;
    }
    else if(now_type==2){
        now_type = 3
    }else{
        now_type =1;
    }

    if (nowSelectedSpellName!="none") {
        GetSpellinfo(nowSelectedSpellName);
    }
}



function GetSpellLV25Info(){
    spell_info_inside_text.SetHasClass("Visible", false);
    var spellname = nowSelectedSpellName;

    let ad_note_loc_string_text;
    let ad_note_loc_string;

    var ad_note_loc_token;
    var none = $.Localize("#DOTA_Tooltip_ability_None");
    ad_note_loc_token = `DOTA_Tooltip_ability_${spellname}_note_lv25_1`;
    ad_note_loc_string_text = $.Localize("#" + ad_note_loc_token);
    
    
    if (ad_note_loc_string_text=="#" + ad_note_loc_token) {
        spell_info_inside_text_2.SetDialogVariable("Infolv25_1",""+$.Localize("#DOTA_Tooltip_ability_First")+ none);
    }else{
        // ad_note_loc_string_text = ad_note_loc_string_text.replaceAll("%%", '%');
        ad_note_loc_string = ""+"<font color='#7f8da8'>"+ $.Localize("#DOTA_Tooltip_ability_First")+  ad_note_loc_string_text+"</font>";
        ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(spellname, ad_note_loc_string);

        spell_info_inside_text_2.SetDialogVariable("Infolv25_1",ad_note_loc_string);
    }

    /////////////////////////////////////////////////////////////////
    ad_note_loc_token = `DOTA_Tooltip_ability_${spellname}_note_lv25_2`;
    ad_note_loc_string_text = $.Localize("#" + ad_note_loc_token);
    if (ad_note_loc_string_text=="#" + ad_note_loc_token) {
        spell_info_inside_text_2.SetDialogVariable("Infolv25_2","<br/><font color='#40484a'>—————————————————————————————</font><br/>"+"<br/>"+ $.Localize("#DOTA_Tooltip_ability_Second")+none);
    }else{
        // ad_note_loc_string_text =ad_note_loc_string_text.replaceAll("%%", "%");
        ad_note_loc_string = "<br/><br/>"  + "<font color='#40484a'>—————————————————————————————</font><br/>"+ "<font color='#7f8da8'>"+$.Localize("#DOTA_Tooltip_ability_Second")+  ad_note_loc_string_text+"</font>";
        ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(spellname, ad_note_loc_string);

        spell_info_inside_text_2.SetDialogVariable("Infolv25_2", ad_note_loc_string);
    }




    /////////////////////////////////////////////////////////////////
    ad_note_loc_token = `DOTA_Tooltip_ability_${spellname}_note_lv25_3`;
    ad_note_loc_string_text = $.Localize("#" + ad_note_loc_token);
    if (ad_note_loc_string_text=="#" + ad_note_loc_token) {
        spell_info_inside_text_2.SetDialogVariable("Infolv25_3","<br/><font color='#40484a'>—————————————————————————————</font><br/>"+"<br/>"+$.Localize("#DOTA_Tooltip_ability_Third")+none);
    }else{
        // ad_note_loc_string_text =ad_note_loc_string_text.replaceAll("%%", "%");
        ad_note_loc_string = "<br/><br/>" + "<font color='#40484a'>—————————————————————————————</font><br/>"+"<font color='#7f8da8'>"+ $.Localize("#DOTA_Tooltip_ability_Third")+ad_note_loc_string_text+"</font>";
        ad_note_loc_string = GameUI.ReplaceDOTAAbilitySpecialValues(spellname, ad_note_loc_string);

        spell_info_inside_text_2.SetDialogVariable("Infolv25_3", ad_note_loc_string);
    }


    
    spell_info_inside_text_2.SetHasClass("Visible", true);
}



//获取玩家的数据
function GetPlayerDate() {
    
    var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("Getplayerdata", event_data);
}

//获取玩家数据反馈
function GetplayerdataFeedback(spellmap,spellsXPTable){
    playerData = {}
    playerData.spellmap = spellmap
    playerData.spellsXPTable = spellsXPTable
    // 当前打开啥窗口就更新哪个
    if (playerGameShopMenuwindowROOT.visible) {  //如果商城
        UpdatePlayerShop();
    }else{
        if (playerSpellslibraryMenuwindowROOT.visible) {  //如果技能图鉴
            UpdatereliableExp()
        }
    }
}

//更新技能图鉴的可靠经验
function UpdatereliableExp(){
    // $.Msg(exp_number);
    exp_number.text = playerData.spellmap.spellmap.playerinfo.reliableExp;
    
}

//升级技能按钮
function UpgradeSpell(keys){
    // var classname = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name")
    
    // exp_number.text = playerData.spellmap.spellmap.playerinfo.reliableExp;
    // $.Msg(exp_number);
    resetPanel(); //重置画板
    CanSpellBeUpgraded = false;
    customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", false);  //隐藏经验分配按钮
    playerSpellslibraryMenuwindowROOT.SetHasClass("Visible", false);
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        spell_name : targetSpellName,
    };
    GameEvents.SendCustomGameEventToServer("UpgradePlayerSpell", event_data);
    
}


function UpgradeSpell_lv5(keys) {
    CanSpellBeUpgraded = false;
    customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", false);  //隐藏经验分配按钮
    playerSpellslibraryMenuwindowROOT.SetHasClass("Visible", false);
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        spell_name : targetSpellName,
    };
    GameEvents.SendCustomGameEventToServer("UpgradePlayerSpell_lv5", event_data);
}



// 技能升级成功了 需要刷新一下数据更新页面
function UpgradeSpellSuccessFeedback(){
    GetPlayerDate();  //先行更新一次数据
    resetPanel();    //重置所有面板
    $.Schedule(0.5, resetCanSpellBeUpgraded);  //不管如何延迟2秒再重新启用 防止一些BUG
}

function BuySpellSuccessFeedback(){
    GetPlayerDate();  //先行更新一次数据
    resetPanel();    //重置所有面板
    GetChaoticEraRuneData();
    // $.Schedule(2, resetCanSpellBeUpgraded);  //不管如何延迟2秒再重新启用 防止一些BUG
}
// function BuyRuneFeedback(){
//     GetPlayerDate();  //先行更新一次数据
//     resetPanel();    //重置所有面板
//     // $.Schedule(2, resetCanSpellBeUpgraded);  //不管如何延迟2秒再重新启用 防止一些BUG
// }

function GetCoreFeedBack(){
    Game.EmitSound( "DOTAMusic_PLUS_ONE" );
    OpenGeneralInfoMenu();
}



//这个时候设置原先打开的面板
var functionname=[
    "OpenPhysicalSpellsMenu",
    "OpenMagicalSpellsMenu",
    "OpenSummonSpellsMenu",
    "OpenDefenseSpellsMenu",
    "OpenAssistSpellsMenu",
    "OpenOtherSpellsMenu",
];
    
function resetCanSpellBeUpgraded(){
    CanSpellBeUpgraded = true;
     OpenplayerSpellslibraryMenu()
    if (opentargetFunction == 0) {
        OpenPhysicalSpellsMenu();
    }else{
        if (opentargetFunction == 1) {
            OpenMagicalSpellsMenu();
        }else{
            if (opentargetFunction == 2) {
                OpenSummonSpellsMenu();
            }else{
                if (opentargetFunction == 3) {
                    OpenDefenseSpellsMenu();
                }else{
                    if (opentargetFunction == 4) {
                        OpenAssistSpellsMenu();
                    }else{
                        OpenOtherSpellsMenu();

                    }
                }
            }
        }
    };

    GetSpellinfo(targetSpellName);
}
//获取玩家的数据
function GetPlayerDate() {
    var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("Getplayerdata", event_data);
}

//技能升级失败
function  UpgradeSpellFailedFeedback() {
    GetPlayerDate();  //先行更新一次数据
    resetPanel();    //重置所有面板
    
}


// ------------------------------------------------------------------
// 商店的内容
//更新技能图鉴的可靠经验

function UpdatePlayerShop(){
    // $.Msg(exp_number);
    GameUI.CustomUIConfig().ReliableExperienceCurrency_number = playerData.spellmap.spellmap.playerinfo.reliableExp;
    GameUI.CustomUIConfig().GoldCurrency_number = playerData.spellmap.spellmap.playerinfo.gold;
    GameUI.CustomUIConfig().PlatinumCurrency_number = playerData.spellmap.spellmap.playerinfo.platinum;


    ReliableExperienceCurrency_number.text = playerData.spellmap.spellmap.playerinfo.reliableExp;
    GoldCurrency_number.text = playerData.spellmap.spellmap.playerinfo.gold;
    PlatinumCurrency_number.text = playerData.spellmap.spellmap.playerinfo.platinum;
    
}



//定时刷新页面 暂时不启用
function startUpdateHealthBarLoop() {
    if (playerGameShopMenuwindowROOT.visible) {
        GetPlayerDate();
        // 当选择的技能存在时刷新该技能页面 从而可以确保按钮的正确显示
        if (!targetSpellName) {
            customSpellsinfo_detailPanel.FindChildTraverse("GetexpButton").SetHasClass("Visible", false);
        }else{
            GetSpellinfo(targetSpellName);
        }
    }

    $.Schedule(30.0/30.0, startUpdateHealthBarLoop);
}





//获取本地化 并根据类型选择反馈
function GetLocalize(keys) {

    if (keys.type==1) {  //返回本地化字段 让lua输出技能奖励
        var spell_name = "#DOTA_Tooltip_ability_"+keys.sMessage
        var tip =$.Localize( "#DOTA_CUSTOM_PlayerGetSpellsBook")+$.Localize(spell_name);
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            message :tip,
        }
        GameEvents.SendCustomGameEventToServer("ReturnSpellBonus", event_data);
    } 
}

const playerBonusSpellBookRoot = $("#playerBonusSpellBookRoot");
//给出技能结算提示
function SetBonus(keys) {
    $.Msg(keys);
    playerBonusSpellBookRoot.RemoveAndDeleteChildren();  //先清除
    var spellmap = keys.sMessage;
    var bonus_info = keys.playerinfo;
    let runeList = keys.runeList
    var i = 0;
    var count = 0
    for (const key in spellmap) {
        if (spellmap.hasOwnProperty.call(spellmap, key)) {
            const element = spellmap[key];
            var spell_name = "#DOTA_Tooltip_ability_"+element.name
            spellPanel = $.CreatePanel("Panel", playerBonusSpellBookRoot, "BonusSpellBookPanel" + i);
            spellPanel.BLoadLayoutSnippet("BonusSpellBook"); //载入模块
            if (i==0) {
                spellPanel.FindChildTraverse("playerGameBonus_inside_text").text =$.Localize( "#DOTA_CUSTOM_PlayerGetSpellsBook"); 
                spellPanel.FindChildTraverse("playerGameBonus_inside_text3").text =$.Localize( "#DOTA_CUSTOM_BONUS_INFO_EXP"); 
            }else{
                spellPanel.FindChildTraverse("playerGameBonus_inside_text").text =""; 
                spellPanel.FindChildTraverse("playerGameBonus_inside_text3").text =""; 
            }
            spellPanel.FindChildTraverse("playerGameBonus_inside_text2").text =$.Localize(spell_name); 
            spellPanel.FindChildTraverse("playerGameBonus_inside_Ability_picture").abilityname =element.name; 
            if (element.exp>=45000) {
                spellPanel.FindChildTraverse("playerGameBonus_inside_text4").text =$.Localize("#DOTA_CUSTOM_BONUS_INFO_max_level"); 
            }else{
                spellPanel.FindChildTraverse("playerGameBonus_inside_text4").text =element.exp; 
            }
            
            var spellButton = spellPanel.FindChildInLayoutFile("playerGameBonus_inside_Ability_picture");
            addBonusSpellEvent(spellButton,element.name);
            i++;
            $.Schedule( i*0.1, ()=>{
				SetPanelNotHidden(count);
				count = count + 1;
			})
        }
    }

    playerGameBonusMenuwindowROOT.FindChildTraverse("playerGameBonus_info_inside_exp").FindChildTraverse("playerGameBonus_inside_exp_text2").text =bonus_info.reliableExp;
    playerGameBonusMenuwindowROOT.FindChildTraverse("playerGameBonus_info_inside_gold").FindChildTraverse("playerGameBonus_inside_gold_text2").text =bonus_info.gold;

    if (i==0) {
       var name = "player_spell_info_none"
       spellPanel = $.CreatePanel("Panel", playerBonusSpellBookRoot, "BonusSpellBookPanel1");
        spellPanel.BLoadLayoutSnippet("BonusSpellBook"); //载入模块
        // var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
        // image.abilityname = individualHeroSpell.spell_id;
        spellPanel.FindChildTraverse("playerGameBonus_inside_text").text =$.Localize( "#DOTA_CUSTOM_NOPlayerGetSpellsBook"); 
        spellPanel.FindChildTraverse("playerGameBonus_inside_text2").text ="/"; 
        spellPanel.FindChildTraverse("playerGameBonus_inside_Ability_picture").abilityname =name; 
        
        spellPanel.FindChildTraverse("playerGameBonus_inside_text3").text =$.Localize( "#DOTA_CUSTOM_BONUS_INFO_EXP"); 
        spellPanel.FindChildTraverse("playerGameBonus_inside_text4").text ="0"; 
        var spellButton = spellPanel.FindChildInLayoutFile("playerGameBonus_inside_Ability_picture");
        addBonusSpellEvent(spellButton,name);
        $.Schedule( i*0.1, ()=>{
            SetPanelNotHidden(count);
            count = count + 1;
        })
    }

    let runeListPanel =  playerGameBonusMenuwindowROOT.FindChildTraverse("playerBonusRuneContent");
    runeListPanel.RemoveAndDeleteChildren();
    for (const key in runeList) {
        if (Object.hasOwnProperty.call(runeList, key)) {
            const element = runeList[key];
            // $.Msg(element);
            let runePanel = $.CreatePanel("Panel", runeListPanel, "rune_" + key);

            SetUpRuneInfo(runePanel,element,true);
            runePanel.FindChildInLayoutFile("itemInfoContainer").SetHasClass("hide",true);
        }
    }

    playerGameBonusMenuwindowROOT.SetHasClass("Visible", true);

   


}


function addBonusSpellEvent(spellButton,individualHeroSpellName) {
    addSpellInfoHoverEvens(spellButton,individualHeroSpellName);
}


function SetPanelNotHidden(i){
    var index = Math.floor(Math.random()*3)+1;
	Game.EmitSound( "ui.treasure_0"+index );
	var spellPanel = playerBonusSpellBookRoot.Children()[i];
	if (spellPanel) {
		spellPanel.SetHasClass("SpellHidden", false);
	}

}







// playerGameBonusMenuwindowROOT.SetHasClass("Visible", false);
// playerGameBonus_inside_text.text = "11111"





// spell_class  物理=1 魔法=2 召唤=3 防御=4 辅助=5 其他=6
var spells = [
    //class1
    [
        "Advanced_Starbreaker",
        "Advanced_Luminosity",
        "Advanced_Celestial_Hammer",
        "Advanced_Solar_Guardian",
        "Advanced_Spear",
        "Advanced_Gods_Rebuke",
        "Advanced_Spectral_Dagger",
        "Advanced_Desolate",
        "Advanced_Haunt",
        "Advanced_Battle_Hunger",
        "Advanced_Culling_Blade",
        "Advanced_Burrow_Strike",
        "Advanced_Caustic_Finale",
        "Advanced_Sand_Storm",
        "Advanced_Epicenter",
        "Advanced_Storm_Bolt",
        "Advanced_Great_Cleave",
        "Advanced_God_Strength",
        "Advanced_Warpath",
        "Advanced_Time_Lock",
        "Advanced_Stifling_Dagger",
        "Advanced_Phantom_Strike",
        "Advanced_Blur",
        "Advanced_Coup_De_Grace",
        "Advanced_Powershot",
        "Advanced_Focus_Fire",
        "Advanced_Acid_Sparay",
        "Advanced_Unstable_Concoction",
        "Advanced_Chemical_Rage",
        "Advanced_Blade_Fury",
        "Advanced_Blade_Dance",
        "Advanced_Omni_Slash",
        "Advanced_frostmourne",
        "Advanced_shapeshift",
        "Advanced_elder_dragon_form",
        "Advanced_metamorphosis",
        "Advanced_feast",
        "Advanced_take_aim",
        "Advanced_split_shot",
        "Advanced_unleash",
        "Advanced_hoof_stomp",
        "Advanced_Anchor_Smash",
        "Advanced_overpower",
        "Advanced_frost_arrows",
        "Advanced_marksmanship",
        "Advanced_unrivaled",
        "Advanced_hunter_in_the_night",
        "Advanced_quadruple_chop",
        "Advanced_Einherjar",
        "Advanced_shockwave",
        "Advanced_Rot",
        "Advanced_Blood_grudge_Dagger",
        "Advanced_clock_and_dagger",
        "Advanced_necromastery",
        "Advanced_bash_of_the_deep",
        "Advanced_Boundless_Strike",
        "Advanced_assassinate",
        "Advanced_corrosive_haze",
        "Advanced_invincible_army",
        "Advanced_chaos_strike",
        "Advanced_Bloodrage",
        "Advanced_double_edge",
        "Advanced_enchant_totem",
        "Advanced_lucent_beam",
        "Advanced_onslaught",
        "Advanced_acorn_shot",
        "Advanced_infernal_blade",
        "Advanced_Sharpshooter",
        "Advanced_Moment_of_Courage",
        "Advanced_Tidebringer",
        "Advanced_uproar",
        "Advanced_headshot",
        "Advanced_greater_bash",
        // "Advanced_Multiple_overlapping_waves",
        "Advanced_Burning_Spear",
        "Advanced_moon_glaive",
        "Advanced_berserkers_blood",
        "Advanced_seahit",
        "Advanced_eye_of_the_storm",
    ],
    //class2
    [
        "Advanced_Death_Pulse",
        "Advanced_Ghost_Shroud",
        "Advanced_Heart_Stopper_Aura",
        "Advanced_Reapers_Scythe",
        "Advanced_Venomous_Gale",
        "Advanced_Poison_Sting",
        "Advanced_Poison_Nova",
        "Advanced_Ice_Vortex",
        "Advanced_Chilling_Touch",
        "Advanced_Dual_Breath",
        "Advanced_Ice_Path",
        "Advanced_Liquid_Fire",
        "Advanced_Liquid_Frost",
        "Advanced_Macropyre",
        "Advanced_Malefice",
        "Advanced_Midnight_Pulse",
        "Advanced_Black_Hole",
        "Advanced_Nether_Blast",
        "Advanced_Nether_Ward",
        "Advanced_Life_Drain",
        "Advanced_Impetus",
        "Advanced_Arc_Lightning",
        "Advanced_Static_Field",
        "Advanced_Lightning_Bolt",
        "Advanced_Thundergods_Wrath",
        "Advanced_spirits",
        "Advanced_fortunes_end",
        "Advanced_chaos_form",
        "Advanced_magic_blessing",
        "Advanced_earth_spike",
        "Advanced_aether_remnant",
        "Advanced_dissimilate",
        "Advanced_astral_step",
        "Advanced_split_earth",
        "Advanced_lightning_storm",
        "Advanced_pulse_nova",
        "Advanced_dragon_slave",
        "Advanced_laguna_blade",
        "Advanced_Dragons_Lighting",
        "Advanced_stroke_of_fate",
        "Advanced_laser",
        "Advanced_Chaos_Meteor",
        "Advanced_gravity",
        "Advanced_astral_imprisonment",
        "Advanced_hyakkiyakou",
        "Advanced_Thunderstrike",
        "Advanced_Acid_bomb",
        "Advanced_finger_of_death",
        "Advanced_brain_sap",
        "Advanced_light_strike_array",
        "Advanced_fiery_soul",
        "Advanced_arcane_bolt",
        "Advanced_Arcane_Replacement",
        "Advanced_ancient_seal",
        "Advanced_mystic_flare",
        "Advanced_Doom",
        "Advanced_heat_seeking_missile",
        "Advanced_Overload",
        "Advanced_pierce_the_veil",
        "Advanced_Ghost_Saya",
        "Advanced_arcane_supremacy",
        "Advanced_elder_dragon_form_ice",
        "Advanced_Poison_Touch",
        "Advanced_ravage",
    ],
    //class3
    [
        "Advanced_Plague_Ward",
        "Advanced_Demonic_Conversion",
        "Advanced_summon_wolves",
        "Advanced_summon_Dave_Chisnall",
        "Advanced_Soul_Link",
        "Advanced_Chaotic_Offering",
        "Advanced_summon_water_element",
        "Advanced_Eldwurm_soul_Aethrak",
        "Advanced_summon_healing_ward",
        "Advanced_summon_earth_element",
        "Advanced_summons_undead_jack_the_ripper",
        "Advanced_Eldwurm_soul_Vahdrak",
        "Advanced_Eldwurm_soul_Uldorak",
        "Advanced_Eldwurm_soul_Slyrak",
        "Advanced_Eldwurm_soul_Byssrak",
        "Advanced_Eldwurm_soul_Lirrak",
        "Advanced_Eldwurm_soul_Indrak",
        "Advanced_summons_ward_Aghanim_the_Wisest",
        "Advanced_summon_Slime",
        "Advanced_summon_Forge_Spirit",
        "Advanced_summon_demon_dark_rift",
        "Advanced_summon_humanoid_cave_troll",
        "Advanced_summon_wind_element",
        "Advanced_summon_immortal_sarcophagus",
        

    ],
    //class4
    [
        "Advanced_Bulwark",
        "Advanced_Dispersion",
        "Advanced_Berserkers_Call",
        "Advanced_Counter_Helix",
        "Advanced_Bristle_Back",
        "Advanced_Untouchable",
        "Advanced_borrowed_time",
        "Advanced_dragon_blood",
        "Advanced_kraken_shell",
        "Advanced_reactive_armor",
        "Advanced_true_form",
        "Advanced_counterspell",
        "Advanced_reincarnation",
        "Advanced_rage",
        "Advanced_enrage",
        "Advanced_mana_shield",
       
        "Advanced_return",
        "Advanced_Body_of_Effulgent_Beryl",
        "Advanced_Corrosive_Skin",
        "Advanced_Electrostatic_Armor",
        "Advanced_whirling_death",
        "Advanced_Holy_Light_Shield",
        "Advanced_shield_crash",
        "Advanced_bulldoze",
        "Advanced_Refraction",
       
    ],
    //class5
    [
        "Advanced_Warcry",
        "Advanced_Viscous_Nasal_Goo",
        "Advanced_Blood_Lust",
        "Advanced_Shallow_Grave",
        "Advanced_Shadow_Wave",
        "Advanced_Bad_Juju",
        "Advanced_Decrepify",
        "Advanced_Nature_Attendants",
        "Advanced_mist_coil",
        "Advanced_aphotic_shield",
        "Advanced_tether",
        "Advanced_overcharge",
        "Advanced_purifying_flame",
        "Advanced_fates_edict",
        "Advanced_false_promise",
        "Advanced_purification",
        "Advanced_repel",
        "Advanced_infest",
        "Advanced_Inner_Beast",
        "Advanced_Arcane_Aura",
        "Advanced_frost_armor",
        "Advanced_Vengeance_Aura",
        "Advanced_aftershock",
        "Advanced_Chakra",
        "Advanced_Voodoo_Restoration",
        "Advanced_Vampiric_Spirit",
        "Advanced_empower",
        "Advanced_fear_arua",
        "Advanced_water_prison",
        "Advanced_cold_embrace",
        "Advanced_howl",
        "Advanced_lunar_blessing",
        "Advanced_reverse_polarity",
        "Advanced_presence_of_the_dark_lord",
        "Advanced_Ghost_Purimn",
        "Advanced_Ghost_Rocha",
        "Advanced_vaccum",
        // "Advanced_Hand_in_hand_together",
        "Advanced_Anti_time",
        "Advanced_curse",
        
        
    ],
        //class6
    [
        "Advanced_Void_time_walk",
        "Advanced_Time_Drain",
        "Advanced_Chronosphere",
        "Advanced_Blood_Sacrifice",
        "Advanced_Windrun",
        "Advanced_Greevils_Greed",
        "Advanced_cook",
        "Advanced_timber_chain",
        "Advanced_morph",
        "Advanced_trace_on",
        "Advanced_Nightmare",
        "Advanced_talentgain",
    ],


 
];

//记录对应技能的各个特效名
// var spellsParticle = {
//     "Advanced_Starbreaker" : [
//         "ability_particle_1",
//         "ability_particle_2",
//     ]
// };

var VIPGoodsButton = $("#VIPGoodsButton");
var SpecialSpellGoodsButton = $("#SpecialSpellGoodsButton");
var BlackMarketButton = $("#BlackMarketButton");
var OtherGoodsButton = $("#OtherGoodsButton");

playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG1").SetHasClass("Visible", true);
// playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG2").SetHasClass("Visible", false);
// playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG3").SetHasClass("Visible", false);
// playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG4").SetHasClass("Visible", false);
// playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG5").SetHasClass("Visible", false);



var currentShopONpanel = playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG1");


//进入商店
function OpenVIPGoodsMenu() {
    VIPGoodsButton.SetHasClass("VIPGoodsButton_on",  true);
    SpecialSpellGoodsButton.SetHasClass("SpecialSpellGoodsButton_on", false);
    BlackMarketButton.SetHasClass("BlackMarketButton_on", false);
    OtherGoodsButton.SetHasClass("OtherGoodsButton_on", false);
    // currentShopONpanel.SetHasClass("Visible", false);
    // currentShopONpanel = playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG2");
    // currentShopONpanel.SetHasClass("Visible", true);
    currentShopONpanel.style.hueRotation="200deg"; 
    currentShopONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    OpenGoodsMenu(1)
}
function OpenSpecialSpellGoodsMenu() {
    VIPGoodsButton.SetHasClass("VIPGoodsButton_on", false);
    SpecialSpellGoodsButton.SetHasClass("SpecialSpellGoodsButton_on",  true);
    BlackMarketButton.SetHasClass("BlackMarketButton_on", false);
    OtherGoodsButton.SetHasClass("OtherGoodsButton_on", false);
    // currentShopONpanel.SetHasClass("Visible", false);
    // currentShopONpanel = playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG5");
    // currentShopONpanel.SetHasClass("Visible", true);
    currentShopONpanel.style.hueRotation="30deg"; 
    currentShopONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    OpenGoodsMenu(2)
}
function OpenBlackMarketMenu() {
    VIPGoodsButton.SetHasClass("VIPGoodsButton_on", false);
    SpecialSpellGoodsButton.SetHasClass("SpecialSpellGoodsButton_on", false);
    BlackMarketButton.SetHasClass("BlackMarketButton_on", true);
    OtherGoodsButton.SetHasClass("OtherGoodsButton_on", false);
    // currentShopONpanel.SetHasClass("Visible", false);
    // currentShopONpanel = playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG4");
    // currentShopONpanel.SetHasClass("Visible", true);
    currentShopONpanel.style.hueRotation="60deg"; 
    currentShopONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;

    OpenGoodsMenu(3)
}
function OpenOtherGoodsMenu() {
    VIPGoodsButton.SetHasClass("VIPGoodsButton_on", false);
    SpecialSpellGoodsButton.SetHasClass("SpecialSpellGoodsButton_on", false);
    BlackMarketButton.SetHasClass("BlackMarketButton_on", false);
    OtherGoodsButton.SetHasClass("OtherGoodsButton_on",  true);
    // currentShopONpanel.SetHasClass("Visible", false);
    // currentShopONpanel = playerGameShopMenuwindowROOT.FindChildTraverse("playerGameShopMenuwindowPostGameBG3");
    // currentShopONpanel.SetHasClass("Visible", true);
    currentShopONpanel.style.hueRotation="270deg"; 
    currentShopONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;

    OpenGoodsMenu(4)
}

var GoodsWindowPane = $("#GoodsWindowPanel");

function ToColor(info,color) {
    return "<font color='"+color+"'>"+ info+"</font>";
}

// if ($.Language()!="schinese") {
// }

function OpenGoodsMenu(keys) {
    // Game.EmitSound( "ui_menu_activate_open" );
    Game.EmitSound( "ui_hero_select_slide" );
    GoodsWindowPane.RemoveAndDeleteChildren();  //先清除


    var ShopGoodsContainer = GoodsWindowPane;

    var ShopGoodPanel;
    var targetPlayerShop = PlayerShop[keys];


    if(keys==1){
        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
            ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
            var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片
            // var spellStringified = JSON.stringify(individualHeroShopGood);
        
            image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
            var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
            var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
            ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
            // var urlid = "s2r://panorama/images/hud/reborn/ping_icon_default_psd.vtex";
            urlid = "";
            var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
            var text = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Description";


            let title = $.Localize(item_name);
            let info = $.Localize(text);
            let keys ={
                title :title,
                text : info,
                
            }
            SetBaseAdavncedInfoHoverEvent(ShopGoodButton,keys);


            addVipGoodsBuyEvens(ShopGoodButton,individualHeroShopGood.item_name,$.Localize(item_name),urlid,$.Localize(text));
        }
    };

    //特殊技能
    if(keys==2){ 
        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
            ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
            var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片
            // var spellStringified = JSON.stringify(individualHeroShopGood);
        
            image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
            var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
            var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
            ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
            // var urlid = "s2r://panorama/images/hud/reborn/ping_icon_default_psd.vtex";
            urlid = "";
            var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
            var text = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Description";

            // ShopGoodPanel.FindChildInLayoutFile("bonus_info_icon");
            
        
            addSpecialSpellGoodInfoEvens(ShopGoodButton,individualHeroShopGood.item_name)
        }
    };

    //黑市
    if(keys==3){

        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            var firstToSecond = individualHeroShopGood.item_name.substr(0,5)
       
            if (firstToSecond=="Advan") {
               
      
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
                ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片
                // var spellStringified = JSON.stringify(individualHeroShopGood);
            
                image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
                var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
                var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
                ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
                // var urlid = "s2r://panorama/images/hud/reborn/ping_icon_default_psd.vtex";
                urlid = "";
                var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
                var text = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Description";
                addSpellGoodInfoEvens(ShopGoodButton,individualHeroShopGood.item_name)
            }
          
        }
        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            var firstToSecond = individualHeroShopGood.item_name.substr(0,6)
            if (firstToSecond=="attach") {
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
                ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片

                image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
                var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
                var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
                ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
                urlid = "";
                var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
                var text = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Description";
                var discount = individualHeroShopGood.discount;
                if (discount>0) {
                    var ShopGoodCostTypoe2 = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe2");
                    ShopGoodCostTypoe2.SetHasClass("Visible",true);
                    ShopGoodCostTypoe2.text = "-"+discount+"%";
                }
                var title = $.Localize(item_name);
                var des = ToColor($.Localize("#DOTA_HUD_TYPE")+$.Localize("#DOTA_HUD_Particle_type_1"),"#5bdeff")+"<br>"+ $.Localize(text);
                {
                    let title = $.Localize(item_name);
                    let info = $.Localize(text);
                    let keys ={
                        title :title,
                        text : info,
                        
                    }
                    SetBaseAdavncedInfoHoverEvent(ShopGoodButton,keys);
                }
                addBlackMarketEffectGoodInfoEvens(ShopGoodButton,individualHeroShopGood.item_name,title,"",des,false,false)
            }
          
        }
        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            var firstToSecond = individualHeroShopGood.item_name.substr(0,12)
            if (firstToSecond=="melee_attack") {
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
                ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片

                image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
                var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
                var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
                ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
                urlid = "";
                var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
                var text = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Description";
                var discount = individualHeroShopGood.discount;
                if (discount>0) {
                    var ShopGoodCostTypoe2 = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe2");
                    ShopGoodCostTypoe2.SetHasClass("Visible",true);
                    ShopGoodCostTypoe2.text = "-"+discount+"%";
                }
                var title = $.Localize(item_name);
                var des = ToColor($.Localize("#DOTA_HUD_TYPE")+$.Localize("#DOTA_HUD_Particle_type_2"),"#5bdeff")+"<br>"+ $.Localize(text);
                {
                    // let title = $.Localize(item_name);
                    // let info = $.Localize(text);
                    let keys ={
                        title :title,
                        text : des,
                        
                    }
                    SetBaseAdavncedInfoHoverEvent(ShopGoodButton,keys);
                }
                addBlackMarketEffectGoodInfoEvens(ShopGoodButton,individualHeroShopGood.item_name,title,"",des,false,false)
            }
          
        }
        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            var firstToSecond = individualHeroShopGood.item_name.substr(0,16)
            if (firstToSecond=="ability_particle") {
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
                ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片

                image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
                var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
                var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
                ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
                urlid = "";
                var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
                var text = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Description";

               
                var discount = individualHeroShopGood.discount;
                if (discount>0) {
                    var ShopGoodCostTypoe2 = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe2");
                    ShopGoodCostTypoe2.SetHasClass("Visible",true);
                    ShopGoodCostTypoe2.text = "-"+discount+"%";
                }
                var title = $.Localize(item_name);
                var des = ToColor($.Localize("#DOTA_HUD_TYPE")+$.Localize("#DOTA_HUD_Particle_type_4"),"#5bdeff")+"<br>"+ $.Localize(text);
                {
                    // let title = $.Localize(item_name);
                    // let info = $.Localize(text);
                    let keys ={
                        title :title,
                        text : des,
                        
                    }
                    SetBaseAdavncedInfoHoverEvent(ShopGoodButton,keys);
                }
                addBlackMarketEffectGoodInfoEvens(ShopGoodButton,individualHeroShopGood.item_name,title,"",des,false,false)
            }
          
        }

        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            var firstToSecond = individualHeroShopGood.item_name.substr(0,10)
            if (firstToSecond=="heroTalent") {
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
                ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片

                image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
                var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
                var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
                ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
                urlid = "";
                var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
                var text = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Description";
                var text2 = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Note0";
            
                var discount = individualHeroShopGood.discount;
                if (discount>0) {
                    var ShopGoodCostTypoe2 = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe2");
                    ShopGoodCostTypoe2.SetHasClass("Visible",true);
                    ShopGoodCostTypoe2.text = "-"+discount+"%";
                }
                var title = $.Localize(item_name);
                // var description = $.Localize(text);
                let description = GameUI.ReplaceDOTAAbilitySpecialValues(individualHeroShopGood.item_name, $.Localize(text));
                // description = description.replaceAll("%%", '%');
                var heroID = individualHeroShopGood.item_name;
                heroID = heroID.replaceAll("heroTalent_", '');
                let reg = /[0-9]+/g;
                heroID = heroID.replace(reg,"");  //删除数字
                if (heroID.charAt(heroID.length-1)=="_") {
                    heroID = heroID.substr(0, heroID.length - 1);  //删除最后一个字符
                }
                var heroInfo = $.Localize("#DOTA_HUD_HERO") +$.Localize("#"+heroID)
                heroInfo  ="<font color='#ffef5b'>"+ heroInfo+"</font>";
                // npc_dota_hero_snapfire
                var des = ToColor($.Localize("#DOTA_HUD_TYPE")+$.Localize("#DOTA_HUD_Particle_type_5"),"#5bdeff")+"<br>"+heroInfo +"<br>"+description+"<br><br>"+ $.Localize(text2);

                var text3 = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Note1";
                if($.Localize(text3)!=text3){
                    des = des +"<br>"+ $.Localize(text3);
                }
                // $.Msg(individualHeroShopGood.item_name);
                // des =  GameUI.ReplaceDOTAAbilitySpecialValues(individualHeroShopGood.item_name, des);
                // des
                // des = des.replaceAll("%%", '%');
                addBlackMarketEffectGoodInfoEvens(ShopGoodButton,individualHeroShopGood.item_name,title,"",des,false,true)
            }
          
        }

        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            var firstToSecond = individualHeroShopGood.item_name.substr(0,11)
            if (firstToSecond=="sound_wheel") {
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
                ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片

                image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
                var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
                var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
                ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
                urlid = "";
           
            
                var discount = individualHeroShopGood.discount;
                if (discount>0) {
                    var ShopGoodCostTypoe2 = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe2");
                    ShopGoodCostTypoe2.SetHasClass("Visible",true);
                    ShopGoodCostTypoe2.text = "-"+discount+"%";
                }
                var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
                var title = $.Localize(item_name);

                var description = $.Localize(text);
                var nameid = individualHeroShopGood.item_name.split("_index_")[0];
   
                var heroID = "#DOTA_Tooltip_ability_"+nameid+"_hero";

                var info = $.Localize("#DOTA_HUD_Wheel_info_2") + $.Localize(heroID);
 
                var language_type = "#DOTA_Tooltip_ability_"+nameid+"_language_type";
                var target_key = $.Localize(language_type);
                var language = $.Localize("#DOTA_HUD_Wheel_info_3")+$.Localize(target_key);
                var des = ToColor($.Localize("#DOTA_HUD_TYPE")+$.Localize("#DOTA_HUD_Wheel_info_1"),"#5bdeff")+"<br>"+info+"<br>"+language;
                
                des = des + "<br><br>" +$.Localize("#DOTA_HUD_Wheel_info_4");
                {
                    // let title = $.Localize(item_name);
                    // let info = $.Localize(text);
                    let keys ={
                        title :title,
                        text : des,
                        
                    }
                    SetBaseAdavncedInfoHoverEvent(ShopGoodButton,keys);
                }

                
                addBlackMarketEffectGoodInfoEvens(ShopGoodButton,individualHeroShopGood.item_name,title,"",des,true,false)
            }
          
        }
        
    };


    // 其他
    if(keys==4){
        for (const key in targetPlayerShop) {
            var individualHeroShopGood = targetPlayerShop[key];
            ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
            ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
            var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片
            // var spellStringified = JSON.stringify(individualHeroShopGood);
        
            image.abilityname = individualHeroShopGood.item_name ;  //设置技能名
            var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
            var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
            ShopGoodCostTypoe.text = $.Localize(cost_class[individualHeroShopGood.cost_class])+":   "+individualHeroShopGood.cost; //拿到类型文本
            // var urlid = "s2r://panorama/images/hud/reborn/ping_icon_default_psd.vtex";
            urlid = "";
            var item_name = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name;
            var text = "#DOTA_Tooltip_ability_"+individualHeroShopGood.item_name+"_Description";
            if (individualHeroShopGood.iconType) {
                ShopGoodPanel.FindChildInLayoutFile("bonus_info").SetHasClass("Visible", true);
                ShopGoodPanel.FindChildInLayoutFile("bonus_info_icon").SetHasClass(individualHeroShopGood.iconType,true);
                // $.Msg(individualHeroShopGood.iconType);
                ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe3").text = individualHeroShopGood.base;
                if (individualHeroShopGood.bonus>0) {
                    ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe4").text = "+"+individualHeroShopGood.bonus;
                }
            }
            let title = $.Localize(item_name);
            let info = $.Localize(text);
            let keys ={
                title :title,
                text : info,
                
            }
            SetBaseAdavncedInfoHoverEvent(ShopGoodButton,keys);


            addOtherGoodsBuyEvens(ShopGoodButton,individualHeroShopGood.item_name,$.Localize(item_name),urlid,$.Localize(text));
        }
    };

 

}

function name(params) {
    
}




// 添加商品事件
function addVipGoodsBuyEvens(spellButton,individualHeroShopGood,item_name,urlid,text) {
    // spellButton.SetPanelEvent("onactivate", Function("BuyGood_vip(\'" + individualHeroShopGood + "\')"));
    spellButton.SetPanelEvent("onactivate", function () {
        BuyGood_vip(individualHeroShopGood);
    });

    // spellButton.SetPanelEvent("onmouseover", function () {
    //     $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,item_name,urlid,text);
    // });

    // spellButton.SetPanelEvent("onmouseout", function () {
    //     $.DispatchEvent("DOTAHideTitleImageTextTooltip");
    // });
}


// 添加技能商品事件（特殊技能）
function addSpecialSpellGoodInfoEvens(spellButton,individualHeroSpell) {
    // spellButton.SetPanelEvent("onactivate", Function("BuySaveSpecialSpells_inMarket(\'" + individualHeroSpell + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        BuySaveSpecialSpells_inMarket(individualHeroSpell);
    });

    addSpellInfoHoverEvens(spellButton,individualHeroSpell);

}

// 添加技能商品事件（黑市）
function addSpellGoodInfoEvens(spellButton,individualHeroSpell) {
    // spellButton.SetPanelEvent("onactivate", Function("BuySaveSpells_inBlackMarket(\'" + individualHeroSpell + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        BuySaveSpells_inBlackMarket(individualHeroSpell);
    });
    addSpellInfoHoverEvens(spellButton,individualHeroSpell);
   
}
//添加黑市特效事件
function addBlackMarketEffectGoodInfoEvens(spellButton,item_name,title,urlid,text,sound,isTalent) {
    // spellButton.SetPanelEvent("onactivate", Function("BuySaveSpells_inBlackMarket(\'" + item_name + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        BuySaveSpells_inBlackMarket(item_name);
    });


    if(sound){
        spellButton.SetPanelEvent("oncontextmenu", function () {
            Game.EmitSound( item_name );
        });
    }
    // Hover events

    if (isTalent) {

        addSpellInfoHoverEvens(spellButton,item_name);

    }else{
        // spellButton.SetPanelEvent("onmouseover", function () {
        //     $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,title,urlid,text);
        // });
    
        // spellButton.SetPanelEvent("onmouseout", function () {
        //     $.DispatchEvent("DOTAHideTitleImageTextTooltip");
        // });
    }
   
}

// 添加购买其他商品
function addOtherGoodsBuyEvens(spellButton,individualHeroShopGood,item_name,urlid,text) {
    // spellButton.SetPanelEvent("onactivate", Function("BuyGood_Other(\'" + individualHeroShopGood + "\')"));
    spellButton.SetPanelEvent("onactivate", function () {
        BuyGood_Other(individualHeroShopGood);
    });

    // spellButton.SetPanelEvent("onmouseover", function () {
    //     $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,item_name,urlid,text);
    // });

    // spellButton.SetPanelEvent("onmouseout", function () {
    //     $.DispatchEvent("DOTAHideTitleImageTextTooltip");
    // });
}

function addMarketTalentEvens(spellButton,item_name,title,urlid,text,sound) {
    // spellButton.SetPanelEvent("onactivate", Function("BuySaveSpells_inBlackMarket(\'" + item_name + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        BuyMarketTalent(item_name);
    });
    if(sound){
        spellButton.SetPanelEvent("oncontextmenu", function () {
            Game.EmitSound( item_name );
        });
    }
    // Hover events

    // spellButton.SetPanelEvent("onmouseover", function () {
    //     $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,title,urlid,text);
    // });

    // spellButton.SetPanelEvent("onmouseout", function () {
    //     $.DispatchEvent("DOTAHideTitleImageTextTooltip");
    // });

    addSpellInfoHoverEvens(spellButton,item_name);


    
}


function addChaoticEraSpellRune(spellButton,individualHeroSpell) {
    // spellButton.SetPanelEvent("onactivate", Function("BuySaveSpecialSpells_inMarket(\'" + individualHeroSpell + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        BuyGood_Rune(individualHeroSpell);
    });


}


function BuyMarketTalent(targetSpellName){
    Game.EmitSound( "ui_hero_select_slide" );
    // var classname = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name")
    now_buy_good = targetSpellName
    buy_type = 999//方便获取所在位置
    var localize_name = "#DOTA_Tooltip_ability_"+targetSpellName;
    Confirm_text_2.text =$.Localize(localize_name);
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", true);
}



var now_buy_good = "";
var buy_type = 0
var Confirm_text_2 = $("#Buy_GOODS_Confirm_Panel").FindChildTraverse("Confirm_text_2");

//购买物品处理逻辑
//先将数据储存于变量中 当订单被确认后 发送给lua订单进行处理
//商城购买技能(黑市)
function BuySaveSpells_inBlackMarket(targetSpellName){
    Game.EmitSound( "ui_hero_select_slide" );
    // var classname = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name")
    now_buy_good = targetSpellName
    buy_type = 3//方便获取所在位置
    var localize_name = "#DOTA_Tooltip_ability_"+targetSpellName;
    Confirm_text_2.text =$.Localize(localize_name);
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", true);
}

//商城购买技能（特权商品）
function BuyGood_vip(targetSpellName){
    Game.EmitSound( "ui_hero_select_slide" );
    // var classname = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name")
    now_buy_good = targetSpellName;
    buy_type = 1; //方便获取所在位置
    var localize_name = "#DOTA_Tooltip_ability_"+targetSpellName;
    Confirm_text_2.text =$.Localize(localize_name);
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", true);
}

//购买技能 特殊技能
function BuySaveSpecialSpells_inMarket(targetSpellName){
    Game.EmitSound( "ui_hero_select_slide" );
    // var classname = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name")
    // $.Msg("buy special");
    now_buy_good = targetSpellName;
    buy_type = 2; //方便获取所在位置
    var localize_name = "#DOTA_Tooltip_ability_"+targetSpellName;
    Confirm_text_2.text =$.Localize(localize_name);
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", true);
}
//商城购买（其他商品）
function BuyGood_Other(targetSpellName){
    Game.EmitSound( "ui_hero_select_slide" );
    // var classname = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name")
    now_buy_good = targetSpellName;
    buy_type = 4; //方便获取所在位置
    var localize_name = "#DOTA_Tooltip_ability_"+targetSpellName;
    Confirm_text_2.text =$.Localize(localize_name);
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", true);
}


function BuyGood_Rune(targetSpellName){
    Game.EmitSound( "ui_hero_select_slide" );
    // var classname = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name")
    now_buy_good = targetSpellName;
    buy_type = 7; //方便获取所在位置
    var localize_name = "#DOTA_Tooltip_ability_"+targetSpellName;
    Confirm_text_2.text = $.Localize("#DOTA_Tooltip_ability_buy_rune_target") +"-"+  $.Localize(localize_name);
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", true);
}

function BuyGood_Artifact(targetSpellName){
    // spellPanel.SetPanelEvent("onactivate", function () {
    //     var event_data = {
    //         player_id: Game.GetLocalPlayerID(),
    //         artifactName : spellName,
    //     }
    //     GameEvents.SendCustomGameEventToServer("TryTakeArtifact", event_data);
    // });

    Game.EmitSound( "ui_hero_select_slide" );
    // var classname = customSpellsinfo_detailPanel.FindChildTraverse("spell_info_name")
    now_buy_good = targetSpellName;
    buy_type = 8; //方便获取所在位置
    var localize_name = "#DOTA_Tooltip_ability_"+targetSpellName;
    Confirm_text_2.text =  $.Localize(localize_name);
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", true);
}




function Buy_GOODS_Confirm_yes(){
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", false);
    Game.EmitSound( "ui_rollover_logo" );
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        spell_name : now_buy_good,   //技能名
        type: buy_type,   //用于获取在表中的位置
    };
    GameEvents.SendCustomGameEventToServer("Buy_GOODS_Confirm_to_lua", event_data);

    
}


//直接强制购买技能
function buySpell() {

    buy_type = 2; //方便获取所在位置
    var localize_name = "#DOTA_Tooltip_ability_"+targetSpellName;
    Confirm_text_2.text =$.Localize(localize_name);
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", true);
}



function Buy_GOODS_Confirm_no(){
    Game.EmitSound( "ui_find_match_cancel" );
    Buy_GOODS_Confirm_Panel.SetHasClass("Visible", false);  
}

// 商城内容
//这里是测试数据
//item_class=0-4   一般 特权 特殊技能 黑市 其他 弃用
//cost_class=0-2   人民币 金币 白金
//PlayerShop[item_class][name]为链接的技能名 包含展示信息
var PlayerShop = [
    [
        // // 一般 充值
        Exchange_for_platinum_01={   
            "item_name":"Exchange_for_platinum_01",
            "cost_class" : 0,
            "cost" :10,
            "iconType":"icon_1",
            "base":100,
            "bonus":0,
       
        },
        Exchange_for_platinum_02={   
            "item_name":"Exchange_for_platinum_02",
            "cost_class" : 0,
            "cost" :19,
            "iconType":"icon_1",
            "base":190,
            "bonus":10,
        },
        Exchange_for_platinum_03={   
            "item_name":"Exchange_for_platinum_03",
            "cost_class" : 0,
            "cost" :40,
            "iconType":"icon_1",
            "base":400,
            "bonus":100,
        },
        Exchange_for_platinum_04={   
            "item_name":"Exchange_for_platinum_04",
            "cost_class" : 0,
            "cost" :75,
            "iconType":"icon_1",
            "base":750,
            "bonus":250,
        },
        Exchange_for_platinum_05={   
            "item_name":"Exchange_for_platinum_05",
            "cost_class" : 0,
            "cost" :140,
            "iconType":"icon_1",
            "base":1400,
            "bonus":600,
        },
        Exchange_for_platinum_04={   
            "item_name":"Exchange_for_platinum_06",
            "cost_class" : 0,
            "cost" :260,
            "iconType":"icon_1",
            "base":2600,
            "bonus":1400,
        },
        Exchange_for_platinum_04={   
            "item_name":"Exchange_for_platinum_07",
            "cost_class" : 0,
            "cost" :530,
            "iconType":"icon_1",
            "base":5300,
            "bonus":4700,
        },
    ],
    [
        // 特权
        Shop_Fast_learning={   
            "item_name":"Shop_Fast_learning",
            "cost_class" : 2,
            "cost" :100,
        },
        Shop_Alchemy={   
            "item_name":"Shop_Alchemy",
            "cost_class" : 2,
            "cost" :100,
        },
        Shop_Metallurgy={   
            "item_name":"Shop_Metallurgy",
            "cost_class" : 2,
            "cost" :100,
        },
        Shop_Metallurgy_2={   
            "item_name":"Shop_Metallurgy_2",
            "cost_class" : 2,
            "cost" :1000,
        },
        // Shop_fool={   
        //     "item_name":"Shop_fool",
        //     "cost_class" : 2,
        //     "cost" :1000,
        // },

        Shop_ban_fellOmen={   
            "item_name":"Shop_ban_fellOmen",
            "cost_class" : 2,
            "cost" :150,
        },
        Shop_Refresh_Chaoticera_spell={   
            "item_name":"Shop_Refresh_Chaoticera_spell",
            "cost_class" : 2,
            "cost" :200,
        },
        Shop_artifact_bonus_exp={   
            "item_name":"Shop_artifact_bonus_exp",
            "cost_class" : 2,
            "cost" :300,
        },
        Shop_artifact_bonus_exp_2={   
            "item_name":"Shop_artifact_bonus_exp_2",
            "cost_class" : 2,
            "cost" :1700,
        },
        Shop_artifact_bonus_exp_3={   
            "item_name":"Shop_artifact_bonus_exp_3",
            "cost_class" : 2,
            "cost" :4000,
        },
    ],

    //特殊技能
    [
       Advanced_talentgain = {
        "item_name":"Advanced_talentgain",
         "cost_class" : 2,
           "cost" :100,
       },
       Advanced_ravage = {
        "item_name":"Advanced_ravage",
         "cost_class" : 2,
           "cost" :100,
       },
    ],

    // 黑市
    [
        // Exchange_for_platinum_01={   
        //     "spell_name":"Exchange_for_platinum_01",
        //     "cost_class" : 0,
        //     "cost" :10,
        // },
        // 黑市需要去获取lua的内容更新
    ],

    // 其他
    [


        // 白金购买
        // Shop_buy_exp_1={   
        //     "item_name":"Shop_buy_exp_1",
        //     "cost_class" : 2,
        //     "cost" :20,
        //     "iconType":"icon_2",
        //     "base":1500,
        //     "bonus":0,
  
        // },
        // Shop_buy_exp_2={   
        //     "item_name":"Shop_buy_exp_2",
        //     "cost_class" : 2,
        //     "cost" :50,
        //     "iconType":"icon_2",
        //     "base":3750,
        //     "bonus":250,


        // },
        // Shop_buy_exp_3={   
        //     "item_name":"Shop_buy_exp_3",
        //     "cost_class" : 2,
        //     "cost" :100,
        //     "iconType":"icon_2",
        //     "base":7500,
        //     "bonus":2500,

        // },
        // Shop_buy_exp_4={   
        //     "item_name":"Shop_buy_exp_4",
        //     "cost_class" : 2,
        //     "cost" :200,
        //     "iconType":"icon_2",
        //     "base":15000,
        //     "bonus":10000,

        // },
        Shop_buy_exp_5={   
            "item_name":"Shop_buy_exp_5",
            "cost_class" : 2,
            "cost" :450,
            "iconType":"icon_2",
            "base":33750,
            "bonus":26250,

        },
        
        Shop_buy_spell_by_platinum={   
            "item_name":"Shop_buy_spell_by_platinum",
            "cost_class" : 2,
            "cost" :200,
            "iconType":"icon_4",
            "base":10,
            "bonus":0,
        },


        Shop_buy_spell_by_platinum2={   
            "item_name":"Shop_buy_spell_by_platinum2",
            "cost_class" : 2,
            "cost" :950,
            "iconType":"icon_4",
            "base":47.5,
            "bonus":2.5,

        },
        buy_core_5_2 ={
            "item_name":"buy_core_5_2",
            "cost_class" : 3,
            "cost" :35000,
            "iconType":"icon_5",
            "base":5,
            "bonus":0,
        },
    
        buy_core_20_2 ={
            "item_name":"buy_core_20_2",
            "cost_class" : 3,
            "cost" :120000,
            "iconType":"icon_5",
            "base":17,
            "bonus":3,
        },


        //Shop_buy_gold_by_platinum_1={   
        //     "item_name":"Shop_buy_gold_by_platinum_1",
        //     "cost_class" : 2,
        //     "cost" :20,
         //    "iconType":"icon_3",
        //     "base":60,
        //     "bonus":0,
  
        // },
        //Shop_buy_gold_by_platinum_2={   
        //     "item_name":"Shop_buy_gold_by_platinum_2",
        //     "cost_class" : 2,
        //    "cost" :50,
        //    "iconType":"icon_3",
        //     "base":150,
        //    "bonus":10,

        // },
        //Shop_buy_gold_by_platinum_3={   
        //     "item_name":"Shop_buy_gold_by_platinum_3",
        //     "cost_class" : 2,
        //    "cost" :100,
        //     "iconType":"icon_3",
        //     "base":300,
        //    "bonus":50,

        //},
        // Shop_buy_gold_by_platinum_4={   
        //    "item_name":"Shop_buy_gold_by_platinum_4",
        //     "cost_class" : 2,
        //    "cost" :200,
        //     "iconType":"icon_3",
        //    "base":600,
        //     "bonus":150,

        // },
         Shop_buy_gold_by_platinum_5={   
             "item_name":"Shop_buy_gold_by_platinum_5",
             "cost_class" : 2,
             "cost" :450,
             "iconType":"icon_3",
             "base":1350,
             "bonus":350,

         },

        
        // 金币购买
        Shop_buy_exp_by_gold_1={   
            "item_name":"Shop_buy_exp_by_gold_1",
            "cost_class" : 1,
            "cost" :100,
            "iconType":"icon_2",
            "base":1500,
            "bonus":0,

        },
        // Shop_buy_exp_by_gold_2={   
        //     "item_name":"Shop_buy_exp_by_gold_2",
        //     "cost_class" : 1,
        //     "cost" :200,
        //     "iconType":"icon_2",
        //     "base":3000,
        //     "bonus":1000,

        // },
        // Shop_buy_exp_by_gold_3={   
        //     "item_name":"Shop_buy_exp_by_gold_3",
        //     "cost_class" : 1,
        //     "cost" :400,
        //     "iconType":"icon_2",
        //     "base":6000,
        //     "bonus":4000,

        // },
        Shop_buy_exp_by_gold_4={   
            "item_name":"Shop_buy_exp_by_gold_4",
            "cost_class" : 1,
            "cost" :800,
            "iconType":"icon_2",
            "base":12000,
            "bonus":13000,

        },
        Shop_buy_exp_by_gold_5={   
            "item_name":"Shop_buy_exp_by_gold_5",
            "cost_class" : 1,
            "cost" :1800,
            "iconType":"icon_2",
            "base":27000,
            "bonus":33000,

        },



        buy_rune_level1={   
            "item_name":"buy_rune_level1",
            "cost_class" : 2,
            "cost" :500,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,

        },
        buy_rune_level2={   
            "item_name":"buy_rune_level2",
            "cost_class" : 2,
            "cost" :550,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,
        },
        buy_rune_level3={   
            "item_name":"buy_rune_level3",
            "cost_class" : 2,
            "cost" :600,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,
        },
        buy_rune_level4={   
            "item_name":"buy_rune_level4",
            "cost_class" : 2,
            "cost" :650,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,
        },
        buy_rune_level5={   
            "item_name":"buy_rune_level5",
            "cost_class" : 2,
            "cost" :700,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,
        },
        buy_rune_level6={   
            "item_name":"buy_rune_level6",
            "cost_class" : 2,
            "cost" :750,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,
        },
        buy_rune_level7={   
            "item_name":"buy_rune_level7",
            "cost_class" : 2,
            "cost" :750,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,
        },
        buy_rune_level8={   
            "item_name":"buy_rune_level8",
            "cost_class" : 2,
            "cost" :750,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,
        },
        buy_rune_level9={   
            "item_name":"buy_rune_level9",
            "cost_class" : 2,
            "cost" :750,
            "iconType":"icon_6",
            "base":20,
            // "bonus":33000,
        },

        



    


        // buy_core_5 ={
        //     "item_name":"buy_core_5",
        //     "cost_class" : 2,
        //     "cost" :300,
        // },
    
        // buy_core_20 ={
        // "item_name":"buy_core_20",
        // "cost_class" : 2,
        // "cost" :1000,
        // },



        // ability_particle_1 ={
        //     "item_name":"ability_particle_1",
        //     "cost_class" : 2,
        //     "cost" :500,
        // }
        
        // heroTalent_npc_dota_hero_antimage_2 ={
        //     "item_name":"heroTalent_npc_dota_hero_antimage_2",
        //     "cost_class" : 2,
        //     "cost" :500,
        // }

        // ability_particle_3 ={
        //     "item_name":"ability_particle_3",
        //     "cost_class" : 2,
        //     "cost" :2000,
        // }

    ],
 
];

//更新黑市内容
function SetBlackMarket(keys) {
    // PlayerShop[3] = {}
    // $.Msg(keys.list[4]);
     var list = keys.list[4]
    for (const key in list) {
        var target = list[key]
        
        PlayerShop[3][target.item_name] = {
            "item_name":target.item_name,
            "cost_class" : target.cost_class,
            "cost" :target.cost,
            "goods_class": target.goods_class,
            "discount":target.discount,
        }

        // $.Msg(PlayerShop[3]);
    }

  
}











var cost_class = [
    "#DOTA_HUD_Spellsinfo_Yuan_Currency",
    "#DOTA_HUD_Spellsinfo_gold_Currency",
    "#DOTA_HUD_Spellsinfo_Platinum_Currency",
    "#DOTA_HUD_Spellsinfo_exp_Currency",
]














//转换时间 转换为2021-08-29- 13：57：57的格式
function formatDateTime(t) {
    var date = new Date(t);

    Y = date.getFullYear() + '-';
  
    M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
  
    D = date.getDate() + ' ';
  
    h = date.getHours() + ':';
  
    m = date.getMinutes() + ':';
  
    s = date.getSeconds();
  
    return Y+M+D+h+m+s;

};


// 创建货币槽的悬浮提示
var challengewindow =	$("#ReliableExperienceCurrencyIcon");
var urlid = "";
var spell_name = "GoodsInfo_01";
var item_name = "#DOTA_Tooltip_ability_"+spell_name;
var text = "#DOTA_Tooltip_ability_"+spell_name+"_Description";
addShowInfoEvens(challengewindow,spell_name,$.Localize(item_name),urlid,$.Localize(text));
var challengewindow =	$("#GoldCurrencyIcon");
var spell_name = "GoodsInfo_02";
var item_name = "#DOTA_Tooltip_ability_"+spell_name;
var text = "#DOTA_Tooltip_ability_"+spell_name+"_Description";
addShowInfoEvens(challengewindow,spell_name,$.Localize(item_name),urlid,$.Localize(text));
var challengewindow =	$("#PlatinumCurrencyIcon");
var spell_name = "GoodsInfo_03";
var item_name = "#DOTA_Tooltip_ability_"+spell_name;
var text = "#DOTA_Tooltip_ability_"+spell_name+"_Description";
addShowInfoEvens(challengewindow,spell_name,$.Localize(item_name),urlid,$.Localize(text));

function addShowInfoEvens(spellButton,individualHeroShopGood,item_name,urlid,text) {

    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,item_name,urlid,text);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideTitleImageTextTooltip");
    });
}








var playerinfo_detail = $("#playerinfo_detail");
var playerinfo_vip = $("#playerinfo_vip");
var GameContestinfo = $("#GameContestinfo");
var playerinfo_item = $("#playerinfo_item");
var GameInfoWindowPanel = $("#GameInfoWindowPanel");
playerinfo_detail.SetHasClass("Visible", false);
GameContestinfo.SetHasClass("Visible", false);
playerinfo_item.SetHasClass("Visible", false);
function OpenGeneralInfoMenu(){
    // Game.EmitSound( "ui_menu_activate_open" );
    Game.EmitSound( "ui_hero_select_slide" );
    playerinfo_vip.SetHasClass("Visible", false);
    playerinfo_detail.SetHasClass("Visible", true);
    GameContestinfo.SetHasClass("Visible", false);
    playerinfo_item.SetHasClass("Visible", false);
    GameInfoWindowPanel.SetHasClass("Visible", false);
    GetPlayerInfoDate();
}
function OpenVIPInfoMenu(){
    // Game.EmitSound( "ui_menu_activate_open" );
    Game.EmitSound( "ui_hero_select_slide" );
    playerinfo_vip.SetHasClass("Visible", true);
    playerinfo_detail.SetHasClass("Visible", false);
    GameContestinfo.SetHasClass("Visible", false);
    playerinfo_item.SetHasClass("Visible", false);
    GameInfoWindowPanel.SetHasClass("Visible", false);
    GetPlayerVIPInfoDate();
}

var CheckTalentButton = $("#CheckTalentButton");
var CheckGameInfoButton = $("#CheckGameInfoButton");
var CheckBonusButton = $("#CheckBonusButton");
var GeneralPlayerInfoButton = $("#GeneralPlayerInfoButton");
var VIPPlayerInfoButton = $("#VIPPlayerInfoButton");
var CheckTalentMarketButton = $("#CheckTalentMarketButton");
var CheckItemButton = $("#CheckItemButton");
var CheckHDGameInfoButton = $("#CheckHDGameInfoButton");

CheckTalentMarketButton.SetHasClass("show",false);
CheckItemButton.SetHasClass("show",true);



//获取玩家的数据  一般
function GetPlayerInfoDate() {
    GeneralPlayerInfoButton.SetHasClass("GeneralPlayerInfoButton_on", true);
    VIPPlayerInfoButton.SetHasClass("VIPPlayerInfoButton_on", false);
    CheckBonusButton.SetHasClass("CheckBonusButton_on", false);
    CheckGameInfoButton.SetHasClass("CheckGameInfoButton_on", false);
    CheckTalentButton.SetHasClass("CheckTalentButton_on", false);
    CheckItemButton.SetHasClass("CheckItemButton_on", false);
    CheckHDGameInfoButton.SetHasClass("CheckItemButton_on", false);

    
    var playerInfoGoodsWindowPanelPostGameBG = $("#playerInfoGoodsWindowPanelPostGameBG");
    playerInfoGoodsWindowPanelPostGameBG.style.hueRotation="0deg"; 
    playerInfoGoodsWindowPanelPostGameBG.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("GetPlayerInfoDate", event_data);

}

//获取玩家的数据  特权
function GetPlayerVIPInfoDate() {
    GeneralPlayerInfoButton.SetHasClass("GeneralPlayerInfoButton_on", false);
    VIPPlayerInfoButton.SetHasClass("VIPPlayerInfoButton_on", true);
    CheckBonusButton.SetHasClass("CheckBonusButton_on", false);
    CheckGameInfoButton.SetHasClass("CheckGameInfoButton_on", false);
    CheckTalentButton.SetHasClass("CheckTalentButton_on", false);
    CheckItemButton.SetHasClass("CheckItemButton_on", false);
    CheckHDGameInfoButton.SetHasClass("CheckItemButton_on", false);


    var playerInfoGoodsWindowPanelPostGameBG = $("#playerInfoGoodsWindowPanelPostGameBG");
    playerInfoGoodsWindowPanelPostGameBG.style.hueRotation="200deg"; 
    playerInfoGoodsWindowPanelPostGameBG.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    var event_data = {
        player_id: Game.GetLocalPlayerID()
    }
    GameEvents.SendCustomGameEventToServer("GetPlayerVIPInfoDate", event_data);
}


const coreLabel1 = playerinfo_detail.FindChildInLayoutFile("corePanel1").FindChildInLayoutFile("coreLabel1");
const coreLabel2 = playerinfo_detail.FindChildInLayoutFile("corePanel2").FindChildInLayoutFile("coreLabel2");
const coreLabel3 = playerinfo_detail.FindChildInLayoutFile("corePanel3").FindChildInLayoutFile("coreLabel3");
coreLabel1.SetDialogVariable("count", "0");
coreLabel2.SetDialogVariable("count", "0");
coreLabel3.SetDialogVariable("count", "0");
//获取玩家数据反馈
function GetplayerInfofeedback(keys){
  

    var playerinfo_detail = $("#playerInfoGoodsWindowPanel").FindChildInLayoutFile("playerinfo_detail");
    var name = Players.GetPlayerName(Game.GetLocalPlayerID());
    playerinfo_detail.FindChildInLayoutFile("PlayerInfo_text_1").text =   $.Localize("#DOTA_HUD_playerName")+name;
    playerinfo_detail.FindChildInLayoutFile("PlayerInfo_text_2").text =    "DOTA2 ID : "+keys.dota2ID;
    playerinfo_detail.FindChildInLayoutFile("PlayerInfo_text_3").text =   "Steam ID : "+keys.steamID;
    playerinfo_detail.FindChildInLayoutFile("PlayerInfo_text_4").text =   $.Localize("#DOTA_HUD_firstGameTime")+keys.firstGameTime;
   
    playerinfo_detail.FindChildInLayoutFile("PlayerInfo_text_1").SetHasClass("show",true);
    playerinfo_detail.FindChildInLayoutFile("PlayerInfo_text_2").SetHasClass("show",true);
    playerinfo_detail.FindChildInLayoutFile("PlayerInfo_text_3").SetHasClass("show",true);
    playerinfo_detail.FindChildInLayoutFile("PlayerInfo_text_4").SetHasClass("show",true);

    // 设置原石数
    coreLabel1.SetDialogVariable("count", ""+keys.core1);
    coreLabel2.SetDialogVariable("count", ""+keys.core2);
    coreLabel3.SetDialogVariable("count", ""+keys.core3);

}
function GetCore(id){
    // $.Msg("db click");
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        coreID : id,
    };
    GameEvents.SendCustomGameEventToServer("TryGetCore", event_data);
}

function GetPlayerVIPInfofeedback(keys){
    // $.Msg(keys);
    playerinfo_vip.RemoveAndDeleteChildren();  //先清除
    var spellsContainer = playerinfo_vip;
    var i = 0;
    for (const key in keys) {
        // $.Msg(key);

        spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
        spellPanel.BLoadLayoutSnippet("vipinfo"); //载入模块

        var image = spellPanel.FindChildInLayoutFile("SinglevipinfoPictureImage"); //找到图片
        var enddayLabel= spellPanel.FindChildInLayoutFile("endday");

        enddayLabel.text = keys[key].endday+" UTC+8";


        var spellButton = spellPanel.FindChildInLayoutFile("SinglevipinfoPanelButton");
        image.abilityname = key;  //设置技能名

        addVIPInfoEvens(spellButton,key)
        i ++;
    }



}


function addVIPInfoEvens(spellButton,key) {


    addSpellInfoHoverEvens(spellButton,key);
}

// CheckBonusButton.SetHasClass("CheckBonusButton_on", true);
function CheckPlayerBonus(){
    // Game.EmitSound( "ui_menu_activate_open" );
    Game.EmitSound( "ui_hero_select_slide" );
    playerinfo_vip.RemoveAndDeleteChildren();  //先清除
    playerinfo_vip.SetHasClass("Visible", true);
    playerinfo_detail.SetHasClass("Visible", false);
    GameContestinfo.SetHasClass("Visible", false);
    playerinfo_item.SetHasClass("Visible", false);
    GameInfoWindowPanel.SetHasClass("Visible", false);
    GeneralPlayerInfoButton.SetHasClass("GeneralPlayerInfoButton_on", false);
    VIPPlayerInfoButton.SetHasClass("VIPPlayerInfoButton_on", false);
    CheckBonusButton.SetHasClass("CheckBonusButton_on", true);
    CheckGameInfoButton.SetHasClass("CheckGameInfoButton_on", false);
    CheckTalentButton.SetHasClass("CheckTalentButton_on", false);
    CheckItemButton.SetHasClass("CheckItemButton_on", false);
    CheckHDGameInfoButton.SetHasClass("CheckItemButton_on", false);

    
    var playerInfoGoodsWindowPanelPostGameBG = $("#playerInfoGoodsWindowPanelPostGameBG");
    playerInfoGoodsWindowPanelPostGameBG.style.hueRotation="0deg"; 
    playerInfoGoodsWindowPanelPostGameBG.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;

    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    };
    GameEvents.SendCustomGameEventToServer("CheckPlayerBonus", event_data);
}


function GetPlayerBonusInfo_feedback(keys){
    // $.Msg(keys.count);
    playerinfo_vip.RemoveAndDeleteChildren();  //先清除
    var spellsContainer = playerinfo_vip;
    var i = 0;

    var haveBonus = false;
    for (const key in keys) {

    
        haveBonus = true;
        spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
        spellPanel.BLoadLayoutSnippet("Bonusinfo"); //载入模块

        var image = spellPanel.FindChildInLayoutFile("SingleBonusinfoPictureImage"); //找到图片
        var spellButton = spellPanel.FindChildInLayoutFile("SingleBonusInfoPanelButton");
        // var enddayLabel= spellPanel.FindChildInLayoutFile("BonusinfoIndicator_reliableExp");

        // enddayLabel.text = keys[key].endday+" UTC+8";

        spellPanel.FindChildInLayoutFile("BonusinfoIndicator_reliableExp").SetDialogVariable("bonus", keys[key].bonusExp);
        spellPanel.FindChildInLayoutFile("BonusinfoIndicator_gold").SetDialogVariable("bonus", keys[key].bonusGold);
        spellPanel.FindChildInLayoutFile("BonusinfoIndicator_platinum").SetDialogVariable("bonus", keys[key].bonusPlatinum);
        
        var name = keys[key].bonusName;
        image.abilityname = name;  //设置技能名
        var id = key;
        // $.Msg(spellButton);
        addBonusInfoEvens(spellButton,name,id)
        i ++;
    }
    if(!haveBonus){
        spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
        spellPanel.BLoadLayoutSnippet("Bonusinfo"); //载入模块

        var image = spellPanel.FindChildInLayoutFile("SingleBonusinfoPictureImage"); //找到图片
        var spellButton = spellPanel.FindChildInLayoutFile("SingleBonusInfoPanelButton");
        // var enddayLabel= spellPanel.FindChildInLayoutFile("BonusinfoIndicator_reliableExp");

        // enddayLabel.text = keys[key].endday+" UTC+8";

        spellPanel.FindChildInLayoutFile("BonusinfoIndicator_reliableExp").SetDialogVariable("bonus", 0);
        spellPanel.FindChildInLayoutFile("BonusinfoIndicator_gold").SetDialogVariable("bonus", 0);
        spellPanel.FindChildInLayoutFile("BonusinfoIndicator_platinum").SetDialogVariable("bonus", 0);
        
        var name = "Shop_bonus_info_none";
        image.abilityname = name;  //设置技能名


        addBonusInfoEvens_none(spellButton,name)
    }


}


function addBonusInfoEvens(spellButton,name,id) {

    // spellButton.SetPanelEvent("onactivate", Function("GetBonus(\'" + id + "\')")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        GetBonus(id);
    });

    addSpellInfoHoverEvens(spellButton,name);
    
}
function addBonusInfoEvens_none(spellButton,name) {
    addSpellInfoHoverEvens(spellButton,name);
}
function GetBonus(id){
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        bonusID:id,
    }
    GameEvents.SendCustomGameEventToServer("GetPlayerBonus", event_data);
    playerinfo_vip.RemoveAndDeleteChildren();  //先清除
}


var SpeedContestTitle = GameContestinfo.FindChildTraverse("SpeedContestTitle");
var GameDataState = 0;
 // 0为默认 在0的情况下点击排行榜为获取一次数据
 // 1为竞速 获取完数据会设置当前为竞速排行榜
 // 2为无尽

function CheckGameInfo(){
    // Game.EmitSound( "ui_menu_activate_open" );
    Game.EmitSound( "ui_hero_select_slide" );
    // GameContestinfo.RemoveAndDeleteChildren();  //先清除
    GameContestinfo.SetHasClass("Visible", true);
    playerinfo_vip.SetHasClass("Visible", false);
    playerinfo_detail.SetHasClass("Visible", false);
    playerinfo_item.SetHasClass("Visible", false);
    GameInfoWindowPanel.SetHasClass("Visible", false);
    GeneralPlayerInfoButton.SetHasClass("GeneralPlayerInfoButton_on", false);
    VIPPlayerInfoButton.SetHasClass("VIPPlayerInfoButton_on", false);
    CheckBonusButton.SetHasClass("CheckBonusButton_on", false);
    CheckGameInfoButton.SetHasClass("CheckGameInfoButton_on", true);
    CheckTalentButton.SetHasClass("CheckTalentButton_on", false);
    CheckItemButton.SetHasClass("CheckItemButton_on", false);
    CheckHDGameInfoButton.SetHasClass("CheckItemButton_on", false);


    var playerInfoGoodsWindowPanelPostGameBG = $("#playerInfoGoodsWindowPanelPostGameBG");
    playerInfoGoodsWindowPanelPostGameBG.style.hueRotation="0deg"; 
    playerInfoGoodsWindowPanelPostGameBG.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;

    if (GameDataState==0) {
        GameDataState = 1; 
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
        };
        GameEvents.SendCustomGameEventToServer("CheckGameInfo", event_data);
        
    }

}

function GetNextGameInfo(){
    Game.EmitSound( "ui_goto_player_page" );
    if(GameDataState==0) {
        GameDataState = 1;
    }else if (GameDataState==1) {
        GameDataState = 2;
    }else{
        GameDataState = 1;
    }

  
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    };
    GameEvents.SendCustomGameEventToServer("CheckGameInfo", event_data);
}





function GetGameInfoFeedBack(keys){
    var map = keys[1];
    // $.Msg(map.playerinfo);
    // var object = map.playerinfo;
    // $.Msg(object);
    // for (const key in object) {
    //     if (Object.hasOwnProperty.call(object, key)) {
    //         const element = object[key];
    //         $.Msg(element);
            
    //     }
    // }
    // $.Msg("-----------------------");

    // $.Msg(map.speedInfo);

    // $.Msg("-----------------------");
    // $.Msg(map.endLessInfo);
    // $.Msg("-----------------------");
    // $.Msg(GameDataState);
    if(GameDataState==1) SetSpeedContest(map.speedInfo,map.playerinfo);
    if(GameDataState==2) SetEndLessContest(map.endLessInfo,map.playerinfo);


    
}

var Rank_player_1 = GameContestinfo.FindChildTraverse("Rank_player_1");
var Rank_player_2 = GameContestinfo.FindChildTraverse("Rank_player_2");
var Rank_player_3 = GameContestinfo.FindChildTraverse("Rank_player_3");
var Rank_player_4 = GameContestinfo.FindChildTraverse("Rank_player_4");
var Rank_player_5 = GameContestinfo.FindChildTraverse("Rank_player_5");
var RankMap = {
    Rank_player_1,
    Rank_player_2,
    Rank_player_3,
    Rank_player_4,
    Rank_player_5,
};


function SetSpeedContest(keys,keys2){
    // $.Msg(keys);
    SetDefault();
    SpeedContestTitle.text = $.Localize("#DOTA_HUD_GameContestinfo_Title");
    // $.Msg(RankMap["Rank_player_1"]);
    for (const key1 in keys) {
        // $.Msg(keys[key]);
        var level1Info = keys[key1];
        var str = "Rank_player_"+ key1;
        var target = RankMap[str];
        var rankTargetMap =  target.Children();
        // $.Msg("队列"+key1+":");
        for (const key2 in level1Info) {  //这里是从1开始
            var level2Info = level1Info[key2];
            // $.Msg(key2);
            // $.Msg(level2Info);  //该组玩家的数据
            var rankTarget = rankTargetMap[key2];  //这里本需要从0开始 但是由于0是title 从1开始即可
            // $.Msg(rankTarget);
            //对于单人赛区中有2个元素 对于五人赛区里有6个元素
            var rankTarget_PlayerImage_Map = rankTarget.Children();
            var TeamNameMap = level2Info.teamName.split(',');  //分割队伍名成数组
            // $.Msg(TeamNameMap[0]);
            //设置每个特定排名里的玩家头像
            for (var i = 0; i < rankTarget_PlayerImage_Map.length-1; i++) {  

                rankTarget_PlayerImage_Map[i].accountid = TeamNameMap[i];  //设置玩家头像
            }
            // var PlayerRankPanelName ="PlayerRank1" 
            var RankInfo = rankTarget_PlayerImage_Map[rankTarget_PlayerImage_Map.length-1]; //最后一个元素为数据
            // $.Msg(RankInfo);
            var useTime = level2Info.passTime;
            useTime = (useTime-useTime%60)/60 + "M" + (useTime%60)+"S";
            RankInfo.text = useTime;  //设置比赛时间
            addTeamDataEvens(RankInfo,level2Info.id)
        }
        // $.Msg("队列"+key1+"结束");
    }

    // 设置个人数据
    const teamType = 1;  //竞速
    var teamIndex =[ //对应排名组当前索引
        11,
        11,
        11,
        11,
        11,
    ];
    for (const key1 in keys2){ 
        var element = keys2[key1];  //抽出单名玩家的数据
        // $.Msg(element);
        for (const key2 in element){ 
            var singleData = element[key2];
            $.Msg(singleData);
            if (singleData.teamType==teamType) {
                //该项数据为竞速类型数据 写入对应表
                var teamNOP = singleData.teamNOP; //获取到队伍人数 放入相应的数组里
                var index = teamIndex[teamNOP-1];
                var targetRoot = RankMap["Rank_player_"+ teamNOP].Children()[index];
                targetRoot.SetHasClass("Visible", true);
                var target = targetRoot.Children();
                teamIndex[teamNOP-1] += 1;
                // $.Msg(target);
                const TeamMap = singleData.teamName.split(',');  //分割队伍名成数组
                for (var i = 0; i < target.length-1; i++) {  

                    target[i].accountid = TeamMap[i];  //设置玩家头像
                }
                var RankInfo = target[target.length-1]; //最后一个元素为数据
    
                var useTime = singleData.passTime;
                useTime = (useTime-useTime%60)/60 + "M" + (useTime%60)+"S";
                var rank = singleData.rank
                if (rank==1) {
                    rank = rank + "st"
                }else if (rank==2) {
                    rank = rank + "ed"
                }else if (rank==3) {
                    rank = rank + "rd"
                }else if (rank>3) {
                    rank = rank + "th"
                }
                RankInfo.text = rank + "/"+useTime;  //设置比赛数据
                addTeamDataEvens(RankInfo,singleData.teamId);
            }
        }
    }
}
// 设置无尽
function SetEndLessContest(keys,keys2){
    SetDefault();
    SpeedContestTitle.text = $.Localize("#DOTA_HUD_GameContestinfo_Title2");

    for (const key1 in keys) {
        // $.Msg(keys[key]);
        var level1Info = keys[key1];
        var str = "Rank_player_"+ key1;
        var target = RankMap[str];
        var rankTargetMap =  target.Children();
        // $.Msg("队列"+key1+":");
        for (const key2 in level1Info) {  //这里是从1开始
            var level2Info = level1Info[key2];
            // $.Msg(key2);
            // $.Msg(level2Info);  //该组玩家的数据
            var rankTarget = rankTargetMap[key2];  //这里本需要从0开始 但是由于0是title 从1开始即可
            // $.Msg(rankTarget);
            //对于单人赛区中有2个元素 对于五人赛区里有6个元素
            var rankTarget_PlayerImage_Map = rankTarget.Children();
            var TeamNameMap = level2Info.teamName.split(',');  //分割队伍名成数组
            // $.Msg(TeamNameMap[0]);
            //设置每个特定排名里的玩家头像
            for (var i = 0; i < rankTarget_PlayerImage_Map.length-1; i++) {  

                rankTarget_PlayerImage_Map[i].accountid = TeamNameMap[i];  //设置玩家头像
            }
            // var PlayerRankPanelName ="PlayerRank1" 
            var RankInfo = rankTarget_PlayerImage_Map[rankTarget_PlayerImage_Map.length-1]; //最后一个元素为数据
            // $.Msg(RankInfo);
            // 除了设置时间外其他是一致的
        //     var useTime = level2Info.passTime;
        //     useTime = (useTime-useTime%60)/60 + "M" + (useTime%60)+"S";
            RankInfo.text = level2Info.passRound + "kill";  //设置比赛时间
            addTeamDataEvens(RankInfo,level2Info.id)
        }
        // $.Msg("队列"+key1+"结束");
    }

    //设置个人数据
    const teamType = 2;  //竞速
    var teamIndex =[ //对应排名组当前索引
        11,
        11,
        11,
        11,
        11,
    ];
    for (const key1 in keys2){ 
        var element = keys2[key1];  //抽出单名玩家的数据
        // $.Msg(element);
        for (const key2 in element){ 
            var singleData = element[key2];
            // $.Msg(singleData);
            if (singleData.teamType==teamType) {
                //该项数据为竞速类型数据 写入对应表
                var teamNOP = singleData.teamNOP; //获取到队伍人数 放入相应的数组里
                var index = teamIndex[teamNOP-1];
                var targetRoot = RankMap["Rank_player_"+ teamNOP].Children()[index];
                targetRoot.SetHasClass("Visible", true);
                var target = targetRoot.Children();
                teamIndex[teamNOP-1] += 1;
                // $.Msg(target);
                const TeamMap = singleData.teamName.split(',');  //分割队伍名成数组
                for (var i = 0; i < target.length-1; i++) {  

                    target[i].accountid = TeamMap[i];  //设置玩家头像
                }
                var RankInfo = target[target.length-1]; //最后一个元素为数据
    
                var useTime = singleData.passRound + "kill";;

                var rank = singleData.rank
                if (rank==1) {
                    rank = rank + "st"
                }else if (rank==2) {
                    rank = rank + "ed"
                }else if (rank==3) {
                    rank = rank + "rd"
                }else if (rank>3) {
                    rank = rank + "th"
                }
                RankInfo.text = rank + "/"+useTime;  //设置比赛数据
                addTeamDataEvens(RankInfo,singleData.teamId);
            }
        }
    }
}

// 添加事件
function addTeamDataEvens(spellButton,teamID) {
    // spellButton.SetPanelEvent("onactivate", Function("GetTeamDataByID(\'" + teamID + "\')"));
    spellButton.SetPanelEvent("onactivate", function () {
        GetTeamDataByID(teamID);
    });
}



function SetDefault(){
    SpeedContestTitle.text = "ILOVETHISGAME"
 

    for (let key1 = 1; key1 <= 5; key1++) {

        var str = "Rank_player_"+ key1;
        var target = RankMap[str];
        var rankTargetMap =  target.Children();
        // $.Msg("队列"+key1+":");
        for (let key2 = 1; key2 <= 10; key2++) {  //这里是从1开始
   
            var rankTarget = rankTargetMap[key2];  //这里本需要从0开始 但是由于0是title 从1开始即可
            //对于单人赛区中有2个元素 对于五人赛区里有6个元素
            var rankTarget_PlayerImage_Map = rankTarget.Children();
            //设置每个特定排名里的玩家头像
            for (var i = 0; i < rankTarget_PlayerImage_Map.length-1; i++) {  
                rankTarget_PlayerImage_Map[i].accountid = 324420892;  //设置玩家头像
            }
  
            var RankInfo = rankTarget_PlayerImage_Map[rankTarget_PlayerImage_Map.length-1]; //最后一个元素为数据
            RankInfo.text = "NULL";
            removePlayerSpellInfoEvens(RankInfo)
            // addTeamDataEvens(RankInfo,level2Info.id)
        }

        //隐藏用于显示局内玩家数据的面板
        for (let key2 = 11; key2 <= 15; key2++) { 
   
            var rankTarget = rankTargetMap[key2];  
            rankTarget.SetHasClass("Visible", false);

        }
  
    }
}


SetDefaultFirst();

function SetDefaultFirst(){
    SpeedContestTitle.text = "ILOVETHISGAME"
 

    for (let key1 = 1; key1 <= 5; key1++) {

        var str = "Rank_player_"+ key1;
        var target = RankMap[str];
        var rankTargetMap =  target.Children();
        for (let key2 = 1; key2 <= 15; key2++) { 
            var rankTarget = rankTargetMap[key2];  
            rankTarget.SetHasClass("Visible", true);
   
        }
  
    }
}


//获取特定队伍数据
function GetTeamDataByID(id){

    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        teamID :id,
    };
    GameEvents.SendCustomGameEventToServer("GetTeamDataByID", event_data);
}

var SpecificTeamDataPanel = SpecificTeamDataRoot.FindChildTraverse("SpecificTeamDataPanel");
var SpecificTeamDataPanelMap =  SpecificTeamDataPanel.Children();
SpecificTeamDataRoot.SetHasClass("Visible", false);

//得到队伍数据反馈
function GetTeamDataFeedBack(keys){
    // $.Msg(keys);
    Game.EmitSound( "ui_hero_select_slide" );
    HideAllElement();
    SpecificTeamDataRoot.SetHasClass("Visible", true);

    var data = keys[1];
    // $.Msg(data);
    var idMap = data[1].teamName.split(',');  //分割队伍名成数组
    for (const key in data) {
        var value = data[key];
        // $.Msg(value);
        // $.Msg("name="+value.hero);
        // $.Msg("skill="+value.skill);
        // $.Msg("items="+value.items);
        SpecificTeamDataPanelMap[key-1].SetHasClass("Visible", true);  //显示一行玩家
        var targetMap = SpecificTeamDataPanelMap[key-1].Children();
        // $.Msg(targetMap[0]);
        targetMap[0].accountid =idMap[key-1];

        var hero_Level = value.hero.split(',');
        targetMap[1].Children()[0].heroname = "npc_dota_hero_" + hero_Level[1];
        targetMap[1].Children()[1].text = "lv"+hero_Level[0];

        var SpellMap = targetMap[2].Children()[0].Children();
        var ItemMap = targetMap[2].Children()[1].Children();
        var spells = value.skill;
        var items = value.items;
        // var map = eval("("+spells+")");
        // var spellsMap = spells.split(',');  //分割队伍名成数组
        // spells = spells.replaceAll("\'", '');
        // spells = spells.replace(/(\[])/g,'');

        // $.Msg("-------");
  
        // $.Msg("-----------");
        // 设置技能
        for (const key1 in spells) {
            var singleSpellData = spells[key1];
            // $.Msg(singleSpellData);
            // SpellMap[key-1].SetHasClass("Visible", true);  //显示一个技能
            if(singleSpellData.n!="unit_state"){
                var SingleSpellPanel = SpellMap[key1-1].Children();
                // $.Msg(singleSpellData.n);
                SingleSpellPanel[0].abilityname = singleSpellData.n;  //名
                if (singleSpellData.l) {  //等级 由于测试的时候有两个写法 这里先这样写
                    SingleSpellPanel[1].text = singleSpellData.l;     
                }else{
                    SingleSpellPanel[1].text = singleSpellData.level;     
                }
              

                addSpellInfoHoverEvens(SingleSpellPanel[0],singleSpellData.n);
            }

        }

        // 设置道具
        // $.Msg(items);
        for (const key2 in items) {
            //由于不小心多获取了一个道具 需要判断break一下
            //定位可移除
            if (key2>=7) {
                break;
            }
            var singleSpellData = items[key2];
            // singleSpellData.SetHasClass("Visible", true);  //显示一个道具
            // $.Msg(singleSpellData);
            var SingleSpellPanel = ItemMap[key2-1];
            
            SingleSpellPanel.itemname = singleSpellData;  //名
        }



    }
}


function HideAllElement(){
    for (const key in SpecificTeamDataPanelMap) {
        var target = SpecificTeamDataPanelMap[key]; //第一层 五名玩家
        var targetMap =  target.Children();
        var SpellMap = targetMap[2].Children()[0].Children();
        var ItemMap = targetMap[2].Children()[1].Children();
        for (const key1 in SpellMap) {
            // SpellMap[key1].SetHasClass("Visible", false);  //隐藏技能
            // $.Msg(key1);
            var SingleSpellPanel = SpellMap[key1].Children();
            // $.Msg(SingleSpellPanel[1]);
            SingleSpellPanel[0].abilityname = "player_spell_info_none";  //名
            SingleSpellPanel[1].text = 0;   
          
            addSpellInfoHoverEvens(SingleSpellPanel[0],"player_spell_info_none");

        }

        for (const key1 in ItemMap) {
            // ItemMap[key1].SetHasClass("Visible", false);  //隐藏道具
            ItemMap[key1].itemname = "item_hd_none";
        }
        target.SetHasClass("Visible", false);  //隐藏玩家
    }
}

function removePlayerSpellInfoEvens(spellButton) {

    
    spellButton.SetPanelEvent("onactivate", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });

}

var talentInfo;
// 获取天赋
function CheckTalent(){
    Game.EmitSound( "ui_hero_select_slide" );
    GameContestinfo.SetHasClass("Visible", false);
    playerinfo_vip.SetHasClass("Visible", true);
    playerinfo_detail.SetHasClass("Visible", false);
    playerinfo_item.SetHasClass("Visible", false);
    GameInfoWindowPanel.SetHasClass("Visible", false);
    GeneralPlayerInfoButton.SetHasClass("GeneralPlayerInfoButton_on", false);
    VIPPlayerInfoButton.SetHasClass("VIPPlayerInfoButton_on", false);
    CheckBonusButton.SetHasClass("CheckBonusButton_on", false);
    CheckGameInfoButton.SetHasClass("CheckGameInfoButton_on", false);
    CheckTalentButton.SetHasClass("CheckTalentButton_on", true);
    CheckItemButton.SetHasClass("CheckItemButton_on", false);
    CheckHDGameInfoButton.SetHasClass("CheckItemButton_on", false);

    var playerInfoGoodsWindowPanelPostGameBG = $("#playerInfoGoodsWindowPanelPostGameBG");
    playerInfoGoodsWindowPanelPostGameBG.style.hueRotation="200deg"; 
    playerInfoGoodsWindowPanelPostGameBG.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    if(talentInfo){
        CreateTalentList();
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    };
    GameEvents.SendCustomGameEventToServer("CheckPlayerTalent", event_data);
}
function GetPlayerTalent_feedback(keys) {
    talentInfo = []
    for (const key in keys) {
        talentInfo[talentInfo.length] = key;
    }
    talentInfo.sort();
    // $.Msg(talentInfo);
    CreateTalentList();

}
$.Schedule( 0.5, GoCheckShouldShouldTalentMarket );
// $.Schedule( 0.5, GoCheckShouldShowItemList );

function GoCheckShouldShouldTalentMarket(){
    var event_data = {
		player_id: Game.GetLocalPlayerID(),
	}
	GameEvents.SendCustomGameEventToServer("GetMarketTalentTable",  event_data );
}


$.Schedule( 0.5, UpdatePlayerData );
function UpdatePlayerData() {
    GetPlayerDate();
    $.Schedule( 10, UpdatePlayerData );
}





var CheckTalentMarketButton_show = false;
var talentMarketData  =[];
var talentMarketData_cost = [];
function GetMarketTalentTable_feedback(keys){
    CheckTalentMarketButton.SetHasClass("show",true);
    CheckTalentMarketButton_show = true;
    

    for (const key in keys) {
        if (Object.hasOwnProperty.call(keys, key)) {
            const element = keys[key];
            if(element.name!=null){
                talentMarketData[talentMarketData.length] = element.name;
                talentMarketData_cost[element.name] = element.cost;
            }else{
                talentMarketData[talentMarketData.length] = element;
            }
        }
    }
    talentMarketData.sort();
    // $.Msg(talentMarketData);
}

function CheckTalentMarket(params) {
    if(CheckTalentMarketButton_show){
        Game.EmitSound( "ui_hero_select_slide" );
        GameContestinfo.SetHasClass("Visible", false);
        playerinfo_vip.SetHasClass("Visible", true);
        playerinfo_detail.SetHasClass("Visible", false);
        playerinfo_item.SetHasClass("Visible", false);
        GameInfoWindowPanel.SetHasClass("Visible", false);
        GeneralPlayerInfoButton.SetHasClass("GeneralPlayerInfoButton_on", false);
        VIPPlayerInfoButton.SetHasClass("VIPPlayerInfoButton_on", false);
        CheckBonusButton.SetHasClass("CheckBonusButton_on", false);
        CheckGameInfoButton.SetHasClass("CheckGameInfoButton_on", false);
        CheckTalentButton.SetHasClass("CheckTalentButton_on", true);
        CheckItemButton.SetHasClass("CheckItemButton_on", false);
        CheckHDGameInfoButton.SetHasClass("CheckItemButton_on", false);

        var playerInfoGoodsWindowPanelPostGameBG = $("#playerInfoGoodsWindowPanelPostGameBG");
        playerInfoGoodsWindowPanelPostGameBG.style.hueRotation="200deg"; 
        playerInfoGoodsWindowPanelPostGameBG.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
        CreateTalentMarketList();
    }

}

function CreateTalentList() {
    var ShopGoodsContainer = playerinfo_vip;
    playerinfo_vip.RemoveAndDeleteChildren();  //先清除
    for (let i = 0; i < talentInfo.length; i++) {
        var key = talentInfo[i];
        ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
        ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
        var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片

        image.abilityname = key ;  //设置技能名
        var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
        var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
       
        urlid = "";
        var item_name = "#DOTA_Tooltip_ability_"+key;
        var text = "#DOTA_Tooltip_ability_"+key+"_Description";
        var text2 = "#DOTA_Tooltip_ability_"+key+"_Note0";

       
        var title = $.Localize(item_name);
        // var description = $.Localize(text);
        // description = description.replaceAll("%%", '%');
        let description = GameUI.ReplaceDOTAAbilitySpecialValues(key, $.Localize(text));
        var heroID = key;
        heroID = heroID.replaceAll("heroTalent_", '');
        let reg = /[0-9]+/g;
        heroID = heroID.replace(reg,"");  //删除数字
        if (heroID.charAt(heroID.length-1)=="_") {
            heroID = heroID.substr(0, heroID.length - 1);  //删除最后一个字符
        }
        ShopGoodCostTypoe.text =$.Localize("#"+heroID);
        var heroInfo = $.Localize("#DOTA_HUD_HERO") +$.Localize("#"+heroID);
        heroInfo  ="<font color='#ffef5b'>"+ heroInfo+"</font>";
        // npc_dota_hero_snapfire
        var des = ToColor($.Localize("#DOTA_HUD_TYPE")+$.Localize("#DOTA_HUD_Particle_type_5"),"#5bdeff")+"<br>"+heroInfo +"<br>"+description+"<br><br>"+ $.Localize(text2);

        var text3 = "#DOTA_Tooltip_ability_"+key+"_Note1";
        if($.Localize(text3)!=text3){
            des = des +"<br>"+ $.Localize(text3);
        }
        // des =  GameUI.ReplaceDOTAAbilitySpecialValues(key, des);
        addTalentListInfoEvens(ShopGoodButton,key,title,"",des)
    }

    
}
function CreateTalentMarketList() {
    var ShopGoodsContainer = playerinfo_vip;
    playerinfo_vip.RemoveAndDeleteChildren();  //先清除
    for (let i = 0; i < talentMarketData.length; i++) {
        var key = talentMarketData[i];
        var name = key;
        ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + key);
        ShopGoodPanel.BLoadLayoutSnippet("ShopGood"); //载入模块
        var image = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPictureImage"); //找到图片

        image.abilityname = name ;  //设置技能名
        var ShopGoodButton = ShopGoodPanel.FindChildInLayoutFile("SingleShopGoodPanelButton");
        var ShopGoodCostTypoe = ShopGoodPanel.FindChildInLayoutFile("ShopGoodCostTypoe");
        ShopGoodCostTypoe.text = $.Localize("#DOTA_HUD_Spellsinfo_Platinum_Currency")+":1200"; //拿到类型文本
        if(talentMarketData_cost[name]){
            ShopGoodCostTypoe.text = $.Localize("#DOTA_HUD_Spellsinfo_Platinum_Currency")+":"+talentMarketData_cost[name]; //拿到类型文本
        }
        urlid = "";
        var item_name = "#DOTA_Tooltip_ability_"+name;
        var text = "#DOTA_Tooltip_ability_"+name+"_Description";
        var text2 = "#DOTA_Tooltip_ability_"+name+"_Note0";
    

        var title = $.Localize(item_name);
        let description = GameUI.ReplaceDOTAAbilitySpecialValues(name, $.Localize(text));
        // var description = $.Localize(text);
        // description = description.replaceAll("%%", '%');
        var heroID = name;
        heroID = heroID.replaceAll("heroTalent_", '');
        let reg = /[0-9]+/g;
        heroID = heroID.replace(reg,"");  //删除数字
        if (heroID.charAt(heroID.length-1)=="_") {
            heroID = heroID.substr(0, heroID.length - 1);  //删除最后一个字符
        }
        var heroInfo = $.Localize("#DOTA_HUD_HERO") +$.Localize("#"+heroID)
        heroInfo  ="<font color='#ffef5b'>"+ heroInfo+"</font>";
        // npc_dota_hero_snapfire


        var des = ToColor($.Localize("#DOTA_HUD_TYPE")+$.Localize("#DOTA_HUD_Particle_type_5"),"#5bdeff")+"<br>"+heroInfo +"<br>"+description+"<br><br>"+ $.Localize(text2);

        var text3 = "#DOTA_Tooltip_ability_"+name+"_Note1";
        if($.Localize(text3)!=text3){
            des = des +"<br>"+ $.Localize(text3);
        }

        addMarketTalentEvens(ShopGoodButton,name,title,"",des,false)
    }

    
}
function addTalentListInfoEvens(spellButton,item_name,title,urlid,text) {
    // spellButton.SetPanelEvent("onactivate", Function("Donothing()")); //设置evens
    spellButton.SetPanelEvent("onactivate", function () {
        Donothing();
    });

    // spellButton.SetPanelEvent("onmouseover", function () {
    //     $.DispatchEvent("DOTAShowTitleImageTextTooltip",spellButton,title,urlid,text);
    // });

    // spellButton.SetPanelEvent("onmouseout", function () {
    //     $.DispatchEvent("DOTAHideTitleImageTextTooltip");
    // });
    spellButton.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowAbilityTooltip",spellButton,item_name);
    });

    spellButton.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });
}

function isNull(data){ 
    return (data == "" || data == undefined || data == null) ? "暂无" : data; 
}


const CAMERA_DISTANCE_MIN = 1200;
const CAMERA_DISTANCE_MAX = 3000;

let camera_distance_slider = $("#cameraSliderPanel");
// camera_distance_slider.visible = false;
camera_distance_slider.value = 1200;
let SettingWindowRoot =  $("#SettingWindowRoot");
// SettingWindowRoot.visible = false;
SettingWindowRoot.SetHasClass("show", false);
// $.Schedule( 5.0, changeCamera );
// function changeCamera() {
//     camera_distance_slider.value += 0.1;
//     $.Schedule( 1.0, changeCamera );
// }
var shouldSend = true;
var cameraDistance = 1200; //记录lua的镜头高度
var currentDistanceValue = 1200;
function UpdateCameraDistance() {
    // const distance = Math.floor(CAMERA_DISTANCE_MIN + camera_distance_slider.value * (CAMERA_DISTANCE_MAX - CAMERA_DISTANCE_MIN));
    // $.Msg(camera_distance_slider.value);
    var distance = camera_distance_slider.value;
    GameUI.SetCameraDistance(distance);
    GameUI._G_cameraDistance = distance;
    if(shouldSend==true){
        currentDistanceValue = distance; //更新一下
    }else{
        // 如果无需传送那么说明是lua发过来的 只需要更新即可
        currentDistanceValue = distance; 
        cameraDistance = distance;
    }
}
CheckShouldSend();
// 每2秒做一次检测就行了
function CheckShouldSend(){
   if(currentDistanceValue!=cameraDistance)
   {
        cameraDistance=currentDistanceValue;
        var event_data = {
            player_id: Game.GetLocalPlayerID(),
            cameraZ : cameraDistance,
        }
        GameEvents.SendCustomGameEventToServer("UpdateCameraZ", event_data);
   }
   $.Schedule(2, function () {
    CheckShouldSend();
});
}

CheckCameraZ();
$.Schedule(2, function () {
    CheckCameraZ();
});

function CheckCameraZ(){
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    }
    GameEvents.SendCustomGameEventToServer("CheckCameraZ", event_data);

}

function UpdateCameraDistanceEvent(keys) {
    // $.Msg(keys);
    let newValue = keys.value;
    // $.Msg(newValue);
    shouldSend = false;
    camera_distance_slider.value = newValue;
    shouldSend = true;

}


let SettingWindowPanel = $("#SettingWindowPanel");

var settingStatus = false;

const SettingWindowBack = SettingWindowRoot.FindChildTraverse("SettingWindowBack3");
function OpenSettingMenu(){
    if(settingStatus==false){
        Game.EmitSound( "ui_menu_activate_open" );
        settingStatus = true;
        SettingWindowBack.visible = true;
        SettingWindowPanel.hittest = true;
        SettingWindowRoot.SetHasClass("show", settingStatus);
    }else{
        Game.EmitSound( "ui_menu_activate_close" );
        settingStatus = false;
        SettingWindowBack.visible = false;
        SettingWindowPanel.hittest = false;
        SettingWindowRoot.SetHasClass("show", settingStatus);
    }
    
}
var ParticleWindowPanel = playerParticleMenuwindowROOT.FindChildTraverse("ParticleWindowPanel");
var AttachParticlButton = playerParticleMenuwindowROOT.FindChildTraverse("AttachParticlButton");
var MeleeAttackParticlButton = playerParticleMenuwindowROOT.FindChildTraverse("MeleeAttackParticlButton");
var RangeAttackParticlButton = playerParticleMenuwindowROOT.FindChildTraverse("RangeAttackParticlButton");

var current_menu_index = 2001;
// OpenParticleMenu(current_menu_index);

var currentParticleONpanel = playerParticleMenuwindowROOT.FindChildTraverse("playerParticleMenuwindowROOTPostGameBG1");
function OpenParticleMenu(index) {


    // Spellsinfo_ParticleInfo.SetHasClass("Visible", false); 
    // Spellsinfo_levelInfo.SetHasClass("Visible", false); 
    GetPlayerDate();
    // nowSelectedSpellName = spellname;
    Game.EmitSound( "ui_rolloff_today" );
    current_menu_index = index;
    var particleInfo
    if (index==2001) {
        AttachParticlButton.SetHasClass("AttachParticlButton_on", true);
        MeleeAttackParticlButton.SetHasClass("MeleeAttackParticlButton_on", false);
        RangeAttackParticlButton.SetHasClass("RangeAttackParticlButton_on", false);
        particleInfo = playerData.spellmap.spellmap.Particle.Attach; //拿到特效数据
        currentParticleONpanel.style.hueRotation="0deg"; 
        currentParticleONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    }else if(index==2002){
        AttachParticlButton.SetHasClass("AttachParticlButton_on", false);
        MeleeAttackParticlButton.SetHasClass("MeleeAttackParticlButton_on", true);
        RangeAttackParticlButton.SetHasClass("RangeAttackParticlButton_on", false);
        particleInfo = playerData.spellmap.spellmap.Particle.MeleeAttack; //拿到特效数据
        currentParticleONpanel.style.hueRotation="30deg"; 
        currentParticleONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    }else if(index==2003){
        AttachParticlButton.SetHasClass("AttachParticlButton_on", false);
        MeleeAttackParticlButton.SetHasClass("MeleeAttackParticlButton_on", false);
        RangeAttackParticlButton.SetHasClass("RangeAttackParticlButton_on", true);
        particleInfo = playerData.spellmap.spellmap.Particle.RangeAttack; //拿到特效数据
        currentParticleONpanel.style.hueRotation="220deg"; 
        currentParticleONpanel.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    }
    // $.Msg(particleInfo);
    ParticleWindowPanel.RemoveAndDeleteChildren();  //先清除
    // 特效切换
   var on_Particle_Name = particleInfo.on_Particle;
   var particle_Set = particleInfo.ParticleSet
   //创建默认特效
   var particleName = "ability_particle_0";
   spellPanel = $.CreatePanel("Panel", ParticleWindowPanel, "spellParticlePanel0");
   spellPanel.BLoadLayoutSnippet("spellParticle"); //载入模块
   var image = spellPanel.FindChildInLayoutFile("SingleSpellParticleImage"); //找到图片
   image.abilityname = particleName;  //设置技能名
   var spellButton = spellPanel.FindChildInLayoutFile("ParticleButton");
   addNormalParticleShiftEvens(spellButton,particleName,index);
   var SingleSpellParticlePanelButton = spellPanel.FindChildInLayoutFile("SingleSpellParticlePanelButton");
   addSpellParticleHoverEvens(SingleSpellParticlePanelButton,particleName);
   var ParticleButtonLabel = spellPanel.FindChildInLayoutFile("ParticleButtonLabel");
   var ParticleButtonLabel2 = spellPanel.FindChildInLayoutFile("ParticleButtonLabel2");
   ParticleButtonLabel2.text = $.Localize("#DOTA_HUD_Forver");
   if(on_Particle_Name=="ability_particle_0"){
        ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_locked");
        spellButton.SetHasClass("particleOn",true);
    }else{
        ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_on");
        spellButton.SetHasClass("particleOff",true);
   }


   for (const key in particle_Set) {
        var particleName = key;
        spellPanel = $.CreatePanel("Panel", ParticleWindowPanel, "spellParticlePanel" + (i+1));
        spellPanel.BLoadLayoutSnippet("spellParticle"); //载入模块
        var image = spellPanel.FindChildInLayoutFile("SingleSpellParticleImage"); //找到图片
        image.abilityname = particleName;  //设置技能名
        var spellButton = spellPanel.FindChildInLayoutFile("ParticleButton");
        addNormalParticleShiftEvens(spellButton,particleName,index);
        var SingleSpellParticlePanelButton = spellPanel.FindChildInLayoutFile("SingleSpellParticlePanelButton");
        addSpellParticleHoverEvens(SingleSpellParticlePanelButton,particleName)
        var ParticleButtonLabel = spellPanel.FindChildInLayoutFile("ParticleButtonLabel");
        if(on_Particle_Name==particleName){
            ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_off");
            spellButton.SetHasClass("particleOn",true);
        }else{
            ParticleButtonLabel.text = $.Localize("#DOTA_HUD_Particle_on");
            spellButton.SetHasClass("particleOff",true);
        }
        var ParticleButtonLabel2 = spellPanel.FindChildInLayoutFile("ParticleButtonLabel2");
        var time = particle_Set[key];
        var firstToSecond = time.substr(0,2)
        // $.Msg(firstToSecond);
        if (firstToSecond=="21"||firstToSecond=="22") {
            ParticleButtonLabel2.text = $.Localize("#DOTA_HUD_Forver");
        }else{
            ParticleButtonLabel2.text =particle_Set[key]+"UTC+8";
        }
       
        
    }

}


function addNormalParticleShiftEvens(Button,Name,index) {
    // Button.SetPanelEvent("onactivate", Function("ShiftParticle(\'" + Name + "\')")); //设置evens
    // Button.SetPanelEvent("onactivate", Function("ShiftNormalParticle(   \'" + Name + "\' , \'" + index + "\'      )"));
    Button.SetPanelEvent("onactivate", function () {
        ShiftNormalParticle(Name,index);
    });
}

function ShiftNormalParticle(Name,index) {
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        particleName : Name,
        index :index,
    }
    GameEvents.SendCustomGameEventToServer("ShiftNormalParticle", event_data);
}

function ShiftNormalParticleFeedBack(keys) {
    // $.Msg(keys);
    playerData.spellmap.spellmap.Particle = keys.Particle;
    // GetSpellinfo(nowSelectedSpellName);
    OpenParticleMenu(current_menu_index);
}

function CloseSetting(){
    Game.EmitSound( "ui_menu_activate_close" );
    // SettingWindowRoot.visible = false;
    settingStatus = false;
    SettingWindowBack.visible = false;
    SettingWindowPanel.hittest = false;
    SettingWindowRoot.SetHasClass("show", false);
}
// 关闭队伍游戏数据
function ClosePlayerData(){
    Game.EmitSound( "ui.treasure_unlock.wav" );
    SpecificTeamDataRoot.SetHasClass("Visible", false);
}
// 关闭结算
function CloseplayerGameBonusMenuwindow(){
    playerGameBonusMenuwindowROOT.SetHasClass("Visible", false);

}
function CloseplayerParticlelibraryMenuwindow() {
    playerParticleMenuwindowROOT.SetHasClass("Visible", false);
}


function Donothing(){

}

function ShiftSpellParticleFeedBack(keys) {
    // $.Msg(keys);
    // $.Msg(playerData.spellmap.spellmap.Particle.SpellParticle);
    playerData.spellmap.spellmap.Particle.SpellParticle = keys.spellParticle;
    GetSpellinfo(nowSelectedSpellName);
}
function CreateRandomHotKey(hotkey){
    let key = hotkey;
    const command = `On${key}${Date.now()}`;
    Game.CreateCustomKeyBind(key, `+${command}`);
    Game.AddCommand(
        `+${command}`,
        () => {
            OpenSettingMenu();
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
let ItemList;
function CheckItem() {
    Game.EmitSound( "ui_hero_select_slide" );
    GameContestinfo.SetHasClass("Visible", false);
    playerinfo_vip.SetHasClass("Visible", false);
    playerinfo_detail.SetHasClass("Visible", false);
    playerinfo_item.SetHasClass("Visible", true);
    GameInfoWindowPanel.SetHasClass("Visible", false);
    GeneralPlayerInfoButton.SetHasClass("GeneralPlayerInfoButton_on", false);
    VIPPlayerInfoButton.SetHasClass("VIPPlayerInfoButton_on", false);
    CheckBonusButton.SetHasClass("CheckBonusButton_on", false);
    CheckGameInfoButton.SetHasClass("CheckGameInfoButton_on", false);
    CheckTalentButton.SetHasClass("CheckTalentButton_on", false);
    CheckItemButton.SetHasClass("CheckItemButton_on", true);
    CheckHDGameInfoButton.SetHasClass("CheckItemButton_on", false);

    var playerInfoGoodsWindowPanelPostGameBG = $("#playerInfoGoodsWindowPanelPostGameBG");
    playerInfoGoodsWindowPanelPostGameBG.style.hueRotation="280deg"; 
    playerInfoGoodsWindowPanelPostGameBG.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    if(ItemList){
        CreateTalentList();
        return;
    }
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
    };
    GameEvents.SendCustomGameEventToServer("GetItemList", event_data);
}




function SendItemList_feedback(keys) {
    // $.Msg(keys);
    ItemList = keys;
    CreateItemList();
}

// var physical_weapon = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("physical_weapon");
// var magical_weapon = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("magical_weapon");
// var armor = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("armor");
// var subsidiarity = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("subsidiarity");
// var special = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("special");
let itemListPanel ={};
itemListPanel.level1 = {};
itemListPanel.level1.physical_weapon = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("physical_weapon");
itemListPanel.level1.magical_weapon = magical_weapon = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("magical_weapon");
itemListPanel.level1.armor = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("armor");
itemListPanel.level1.subsidiarity = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("subsidiarity");
itemListPanel.level1.special = playerinfo_item.FindChildTraverse("item_list_level_1").FindChildTraverse("special");

itemListPanel.level2 = {};
itemListPanel.level2.physical_weapon = playerinfo_item.FindChildTraverse("item_list_level_2").FindChildTraverse("physical_weapon");
itemListPanel.level2.magical_weapon = magical_weapon = playerinfo_item.FindChildTraverse("item_list_level_2").FindChildTraverse("magical_weapon");
itemListPanel.level2.armor = playerinfo_item.FindChildTraverse("item_list_level_2").FindChildTraverse("armor");
itemListPanel.level2.subsidiarity = playerinfo_item.FindChildTraverse("item_list_level_2").FindChildTraverse("subsidiarity");
itemListPanel.level2.special = playerinfo_item.FindChildTraverse("item_list_level_2").FindChildTraverse("special");

itemListPanel.level3 = {};
itemListPanel.level3.physical_weapon = playerinfo_item.FindChildTraverse("item_list_level_3").FindChildTraverse("physical_weapon");
itemListPanel.level3.magical_weapon = magical_weapon = playerinfo_item.FindChildTraverse("item_list_level_3").FindChildTraverse("magical_weapon");
itemListPanel.level3.armor = playerinfo_item.FindChildTraverse("item_list_level_3").FindChildTraverse("armor");
itemListPanel.level3.subsidiarity = playerinfo_item.FindChildTraverse("item_list_level_3").FindChildTraverse("subsidiarity");
itemListPanel.level3.special = playerinfo_item.FindChildTraverse("item_list_level_3").FindChildTraverse("special");


itemListPanel.level4 = {};
itemListPanel.level4.physical_weapon = playerinfo_item.FindChildTraverse("item_list_level_4").FindChildTraverse("physical_weapon");
itemListPanel.level4.magical_weapon = magical_weapon = playerinfo_item.FindChildTraverse("item_list_level_4").FindChildTraverse("magical_weapon");
itemListPanel.level4.armor = playerinfo_item.FindChildTraverse("item_list_level_4").FindChildTraverse("armor");
itemListPanel.level4.subsidiarity = playerinfo_item.FindChildTraverse("item_list_level_4").FindChildTraverse("subsidiarity");
itemListPanel.level4.special = playerinfo_item.FindChildTraverse("item_list_level_4").FindChildTraverse("special");


itemListPanel.level5 = {};
itemListPanel.level5.physical_weapon = playerinfo_item.FindChildTraverse("item_list_level_5").FindChildTraverse("physical_weapon");
itemListPanel.level5.magical_weapon = magical_weapon = playerinfo_item.FindChildTraverse("item_list_level_5").FindChildTraverse("magical_weapon");
itemListPanel.level5.armor = playerinfo_item.FindChildTraverse("item_list_level_5").FindChildTraverse("armor");
itemListPanel.level5.subsidiarity = playerinfo_item.FindChildTraverse("item_list_level_5").FindChildTraverse("subsidiarity");
itemListPanel.level5.special = playerinfo_item.FindChildTraverse("item_list_level_5").FindChildTraverse("special");


itemListPanel.level6 = {};
itemListPanel.level6.physical_weapon = playerinfo_item.FindChildTraverse("item_list_level_6").FindChildTraverse("physical_weapon");
itemListPanel.level6.magical_weapon = magical_weapon = playerinfo_item.FindChildTraverse("item_list_level_6").FindChildTraverse("magical_weapon");
itemListPanel.level6.armor = playerinfo_item.FindChildTraverse("item_list_level_6").FindChildTraverse("armor");
itemListPanel.level6.subsidiarity = playerinfo_item.FindChildTraverse("item_list_level_6").FindChildTraverse("subsidiarity");
itemListPanel.level6.special = playerinfo_item.FindChildTraverse("item_list_level_6").FindChildTraverse("special");

itemListPanel.level7 = {};
itemListPanel.level7.physical_weapon = playerinfo_item.FindChildTraverse("item_list_level_7").FindChildTraverse("physical_weapon");
itemListPanel.level7.magical_weapon = magical_weapon = playerinfo_item.FindChildTraverse("item_list_level_7").FindChildTraverse("magical_weapon");
itemListPanel.level7.armor = playerinfo_item.FindChildTraverse("item_list_level_7").FindChildTraverse("armor");
itemListPanel.level7.subsidiarity = playerinfo_item.FindChildTraverse("item_list_level_7").FindChildTraverse("subsidiarity");
itemListPanel.level7.special = playerinfo_item.FindChildTraverse("item_list_level_7").FindChildTraverse("special");



var itemListFinished = false;
function CreateItemList() {
    if(itemListFinished) return ;
    var keys = ItemList;
    itemListFinished = true;
    let data_physical = keys.physical_weapon;
    let data_magical = keys.magical_weapon;
    let data_armor = keys.armor;
    let data_subsidiarity = keys.subsidiarity;
    let data_special = keys.special;
    let index = 0;
    for (let i = 1; i <= 7; i++) {
        let levelText = "level"+i;
        let ShopGoodsContainer = itemListPanel[levelText].physical_weapon;
        let targetData = data_physical[levelText];
        ShopGoodsContainer.RemoveAndDeleteChildren();  //先清除
        for (const key in targetData) {
            if (Object.hasOwnProperty.call(targetData, key)) {
                index++;
                const element = targetData[key];
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + index);
                ShopGoodPanel.BLoadLayoutSnippet("ItemList"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleItemImage"); //找到图片
                image.itemname = element ;  //设置技能名
             
                addItemListEvens(ShopGoodPanel,element,"physical_weapon",i)
            }
           
        }
        ShopGoodsContainer = itemListPanel[levelText].magical_weapon;
        targetData = data_magical[levelText];
        ShopGoodsContainer.RemoveAndDeleteChildren();  //先清除
        for (const key in targetData) {
            if (Object.hasOwnProperty.call(targetData, key)) {
                index++;
                const element = targetData[key];
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + index);
                ShopGoodPanel.BLoadLayoutSnippet("ItemList"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleItemImage"); //找到图片
                image.itemname = element ;  //设置技能名
                
                addItemListEvens(ShopGoodPanel,element,"magical_weapon",i)
            }
        }
        ShopGoodsContainer = itemListPanel[levelText].armor;
        targetData = data_armor[levelText];
        ShopGoodsContainer.RemoveAndDeleteChildren();  //先清除
        for (const key in targetData) {
            if (Object.hasOwnProperty.call(targetData, key)) {
                index++;
                const element = targetData[key];
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + index);
                ShopGoodPanel.BLoadLayoutSnippet("ItemList"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleItemImage"); //找到图片
                image.itemname = element ;  //设置技能名
                addItemListEvens(ShopGoodPanel,element,"armor",i)
            }
        }
        ShopGoodsContainer = itemListPanel[levelText].subsidiarity;
        targetData = data_subsidiarity[levelText];
        ShopGoodsContainer.RemoveAndDeleteChildren();  //先清除
        for (const key in targetData) {
            if (Object.hasOwnProperty.call(targetData, key)) {
                index++;
                const element = targetData[key];
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + index);
                ShopGoodPanel.BLoadLayoutSnippet("ItemList"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleItemImage"); //找到图片
                image.itemname = element ;  //设置技能名
                addItemListEvens(ShopGoodPanel,element,"subsidiarity",i)
            }
        }
        ShopGoodsContainer = itemListPanel[levelText].special;
        targetData = data_special[levelText];
        ShopGoodsContainer.RemoveAndDeleteChildren();  //先清除
        for (const key in targetData) {
            if (Object.hasOwnProperty.call(targetData, key)) {
                index++;
                const element = targetData[key];
                ShopGoodPanel = $.CreatePanel("Panel", ShopGoodsContainer, "ShopGoodPanel" + index);
                ShopGoodPanel.BLoadLayoutSnippet("ItemList"); //载入模块
                var image = ShopGoodPanel.FindChildInLayoutFile("SingleItemImage"); //找到图片
                image.itemname = element ;  //设置技能名
                addItemListEvens(ShopGoodPanel,element,"special",i)
            }
        }
    }



}
function addItemListEvens(spellButton,item_name,item_type,level) {
    spellButton.SetPanelEvent("onactivate", function () {
        TryGetItem(item_name,item_type,level);
    });
    // spellButton.SetPanelEvent("oncontextmenu", function () {
    //     TryGetItem(item_name);
    // });
}

function TryGetItem(itemname,item_type,level) {
	var event_data = {
        player_id: Game.GetLocalPlayerID(),
        itemname : itemname,
        item_type: item_type,
        level: level,
    }
	GameEvents.SendCustomGameEventToServer("TryGetItemFromItemList",  event_data );
	Game.EmitSound( "ui.inv_equip_metalblade" );
}

function GoCheckShouldShowItemList(){
    var event_data = {
		player_id: Game.GetLocalPlayerID(),
	}
	GameEvents.SendCustomGameEventToServer("ShouldGetItemList",  event_data );
}
// var ItemListButton_show = false;
// function ShouldGetItemList_feedback() {
//     CheckItemButton.SetHasClass("show",true);
//     ItemListButton_show = true;
// }

// var ShowinfoButton = $("#playerInfoGoodsWindowPanel").FindChildTraverse("ContestInfoButton");
// function ShowInfohover() {

//     // var item_name_intext = "ChallengeInfo"
//     var urlid = "";
//     // var urlid = "s2r://panorama/images/econ/huds/hud_esp_surge_hud_png.vtex";
//     // urlid = "";
//     var item_name = "#DOTA_Tooltip_ability_"+item_name_intext;
//     var text = "#DOTA_HUD_Contest_rule";
//     $.DispatchEvent("DOTAShowTitleImageTextTooltip",ShowinfoButton,item_name,urlid,$.Localize(text))


// }
// function CloseInfohover() {
//     $.DispatchEvent("DOTAHideTitleImageTextTooltip");
// }



const TIME_SCALE_MIN = 0.1;
const TIME_SCALE_MAX = 1;

let timeScaleSliderPanel_slider = $("#timeScaleSliderPanel");
timeScaleSliderPanel_slider.value = 1;
function UpdateTimeScale() {
    // $.Msg(timeScaleSliderPanel_slider.value);
    
}
function SendTimeChange(){
    // const scale = TIME_SCALE_MIN + timeScaleSliderPanel_slider.value * (TIME_SCALE_MAX - TIME_SCALE_MIN);
    const scale = timeScaleSliderPanel_slider.value*0.01;
    // $.Msg(timeScaleSliderPanel_slider.value);
    var event_data = {
        player_id: Game.GetLocalPlayerID(),
        scale : scale,
    };
    GameEvents.SendCustomGameEventToServer("ChangeTimeScale", event_data);
}

// 创建请求
var TimeRequest = 0;
function CreateTimeScaleRequest(){
	$( "#TimeScale_Panel_Root" ).SetHasClass( "show", true );
    TimeRequest = 1;
}

function ConfirmChangeTimeScale(){
    if(TimeRequest!=1){
        return;
    }
	$( "#TimeScale_Panel_Root" ).SetHasClass( "show", false );
	var event_data = {
		player_id: Game.GetLocalPlayerID(),
		change: 1,
	}
	GameEvents.SendCustomGameEventToServer("SendTimeScalechangeInfo",  event_data );
	TimeRequest = 0;
}

function CancleChangeTimeScale(){
    if(TimeRequest!=1){
        return;
    }
	$( "#TimeScale_Panel_Root" ).SetHasClass( "show", false );
	var event_data = {
		player_id: Game.GetLocalPlayerID(),
		change: 0,
	}
	GameEvents.SendCustomGameEventToServer("SendTimeScalechangeInfo",  event_data );
    TimeRequest = 0;
}

function CancleChangeTimeScaleFeedBack(){
	$( "#TimeScale_Panel_Root" ).SetHasClass( "show", false );
    TimeRequest = 0;
}





function GetCDKBonus(){

    let GetCDKText = playerinfo_detail.FindChildTraverse("GetCDKText");
    if (GetCDKText.text=="") {
        return;
    }
    let data = {
		data :GetCDKText.text,
		player_id: Game.GetLocalPlayerID(),
	}

    playerinfo_detail.FindChildTraverse("GetCDKBonusButton").SetHasClass("Hidden",true);
	GameEvents.SendCustomGameEventToServer("GetCDKbonus", data);
}
function ShowCDKButton() {
    playerinfo_detail.FindChildTraverse("GetCDKBonusButton").SetHasClass("Hidden",false);
}




function CheckHDGameInfo() {
    Game.EmitSound( "ui_hero_select_slide" );
    GameContestinfo.SetHasClass("Visible", false);
    playerinfo_vip.SetHasClass("Visible", false);
    playerinfo_detail.SetHasClass("Visible", false);
    playerinfo_item.SetHasClass("Visible", false);
    GameInfoWindowPanel.SetHasClass("Visible", true);
    GeneralPlayerInfoButton.SetHasClass("GeneralPlayerInfoButton_on", false);
    VIPPlayerInfoButton.SetHasClass("VIPPlayerInfoButton_on", false);
    CheckBonusButton.SetHasClass("CheckBonusButton_on", false);
    CheckGameInfoButton.SetHasClass("CheckGameInfoButton_on", false);
    CheckTalentButton.SetHasClass("CheckTalentButton_on", false);
    CheckItemButton.SetHasClass("CheckItemButton_on", false);
    CheckHDGameInfoButton.SetHasClass("CheckItemButton_on", true);

    var playerInfoGoodsWindowPanelPostGameBG = $("#playerInfoGoodsWindowPanelPostGameBG");
    playerInfoGoodsWindowPanelPostGameBG.style.hueRotation="0deg"; 
    playerInfoGoodsWindowPanelPostGameBG.style.preTransformScale2d = 1+Math.floor(Math.random()*200)*0.01;
    // if(ItemList){
    //     CreateTalentList();
    //     return;
    // }
    // var event_data = {
    //     player_id: Game.GetLocalPlayerID(),
    // };
    // GameEvents.SendCustomGameEventToServer("GetItemList", event_data);
}
{
    if ($.Language()!="schinese") {
        $("#CheckHDGameInfoButton").SetHasClass("hidden",true);
        
    }else{
        let target = GameInfoWindowPanel.FindChildTraverse("buttonList");
        target.RemoveAndDeleteChildren();
        let infoCount = $.Localize("#HUD_Game_Info_Count");
        for (let index = 1; index <= infoCount; index++) {
            let spellPanel = $.CreatePanel("Panel", target, "infoButton" + index);
            spellPanel.BLoadLayoutSnippet("singleButton"); //载入模块
            spellPanel.FindChildTraverse("textInfo").text = $.Localize("#HUD_Game_Info_"+index+"_title");
            // spellPanel.SetDialogVariable("buttonName",$.Localize("#HUD_Game_Info_"+index+"_title"));
            let title = $.Localize("#HUD_Game_Info_"+index+"_title");
            let info =$.Localize("#HUD_Game_Info_"+index);
            let keys ={
                title :title,
                text : info,
                
            }
            SetBaseAdavncedInfoHoverEvent(spellPanel,keys);
      
        }
        
    }
  
}




// 监听反馈
(function () {

    GameEvents.Subscribe("Getplayerdata_feedback", GetplayerdataFeedback); //得到玩家数据反馈
    GameEvents.Subscribe("UpgradeSpellSuccess_feedback", UpgradeSpellSuccessFeedback); //升级技能成功反馈
    GameEvents.Subscribe("UpgradeSpellFailed_feedback", UpgradeSpellFailedFeedback); //升级技能失败反馈
    GameEvents.Subscribe("GetLocalize", GetLocalize); //获取某个字段的本地化
    GameEvents.Subscribe("SetBonus", SetBonus); //给出结算奖励提示

    GameEvents.Subscribe("SetBlackMarket", SetBlackMarket); //给出结算奖励提示
    GameEvents.Subscribe("Buy_GOODS_Confirm_yes", Buy_GOODS_Confirm_yes); //确认购买
    GameEvents.Subscribe("Buy_GOODS_Confirm_no", Buy_GOODS_Confirm_no); //取消购买

    GameEvents.Subscribe("BuySpellSuccessFeedback", BuySpellSuccessFeedback); //取消购买
    // GameEvents.Subscribe("BuyRuneFeedback", BuyRuneFeedback); //取消购买



    

    GameEvents.Subscribe("GetplayerInfo_feedback", GetplayerInfofeedback); //得到玩家数据反馈
    GameEvents.Subscribe("GetPlayerVIPInfo_feedback", GetPlayerVIPInfofeedback); //得到玩家数据反馈
    GameEvents.Subscribe("GetPlayerBonusInfo_feedback", GetPlayerBonusInfo_feedback); //得到玩家数据反馈

    GameEvents.Subscribe("GetGameInfoFeedBack", GetGameInfoFeedBack); //得到排行榜数据
    GameEvents.Subscribe("GetTeamDataFeedBack", GetTeamDataFeedBack); //得到排行榜数据

    GameEvents.Subscribe("ShiftSpellParticleFeedBack", ShiftSpellParticleFeedBack); //得到排行榜数据
    GameEvents.Subscribe("ShiftNormalParticleFeedBack", ShiftNormalParticleFeedBack); //得到排行榜数据

    GameEvents.Subscribe("CheckTimeScaleChange", CreateTimeScaleRequest); //得到排行榜数据
    GameEvents.Subscribe("CloseAllTimeScaleRequest", CancleChangeTimeScaleFeedBack); //得到排行榜数据
    GameEvents.Subscribe("GetPlayerTalent_feedback", GetPlayerTalent_feedback); //得到排行榜数据


    GameEvents.Subscribe("UpdateCameraDistanceEvent_feedback", UpdateCameraDistanceEvent); //得到排行榜数据

    
    GameEvents.Subscribe("GetMarketTalentTable_feedback", GetMarketTalentTable_feedback); //得到排行榜数据
    GameEvents.Subscribe("SendItemList", SendItemList_feedback); //得到排行榜数据
    // GameEvents.Subscribe("ShouldGetItemList_feedback", ShouldGetItemList_feedback); //得到排行榜数据

    
    CreateRandomHotKey("F10");
    // Game.AddCommand( "+OpenSetting", OpenSettingMenu, "", Date.now() );
    GameEvents.Subscribe("GetCoreFeedBack", GetCoreFeedBack); //锻造原石成功

    GameEvents.Subscribe("ShowCDKButton", ShowCDKButton); //得到玩家数据反馈
    // startUpdateHealthBarLoop() 
})();