$.Msg("英雄建议已加载");
function FindDotaHud(string){
    var rootPanel = $.GetContextPanel();
    while (rootPanel.GetParent()) {
        rootPanel = rootPanel.GetParent();
    }
    return rootPanel.FindChildTraverse(string)
}

// 需要显示建议的英雄ID列表，
const suggestedHeroIds = [83, 84, 10, 76, 52, 67, 11, 41, 25, 21, 69, 92, 81, 93, 22, 44, 4, 135, 62, 47, 18, 3, 96, 6, 112, 91, 34, 50, 86, 155, 75
    ,100,104,35,109,31,57,54,29
];


// 延迟3秒后执行英雄建议逻辑
$.Schedule(1.0, function() {
    FindDotaHud('HeroGrid').
        FindChildrenWithClassTraverse('HeroCard').
        forEach(item => {
            let heroimage = item.FindChildTraverse('HeroImage');
            if (suggestedHeroIds.includes(heroimage.heroid)) {
                item.AddClass('AllHeroChallenge');
                item.AddClass('Suggested')
            }
        });
});

// 监听英雄选择事件
GameEvents.Subscribe('dota_player_update_selected_hero', function(data) {
    FindDotaHud('HeroGrid');
});