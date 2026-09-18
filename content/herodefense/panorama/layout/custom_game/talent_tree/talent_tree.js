$.Msg("talent_tree.js loaded");
GameEvents.Subscribe("SendTalentPoint", SendTalentPoint);
GameEvents.Subscribe("OpenTalentTree", OpenTalentTree);

const container = $("#talent-tree-container");
const talentTreeRoot = container.GetParent();

const talentPoints = {}; // 存储每个天赋点的当前等级
let availableSkillPoints = 78; // 可用技能点
createTalentTree();

function createTalentTree() {
    // 创建技能点数显示面板
    const skillPointsPanel = $("#skill-points-label");
    const pointsText = $.Language() === "schinese" 
    ? `可分配天赋点数 : ${availableSkillPoints}` 
    : `Talent Points: ${availableSkillPoints}`;
    skillPointsPanel.text = pointsText;
    const toggleButton = $("#toggle-button");
    const toggleButtonText = $("#toggle-button-text");
    toggleButtonText.text = $.Localize("#DOTA_HUD_Talent_Tree_Toggle_Ready");
    
    // 添加切换按钮点击事件
    // toggleButton.SetPanelEvent('onactivate', toggleBorderOnPoints);

    const rows = 10;
    const cols = 18;
    const buttonState = [
        // Example 12x9 array with 0s and 1s
        [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0],
        [0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0]
    
    ];

   
    
    talentTreeRoot.style.visibility = "collapse";
    if (!container) {
        $.Msg("Error: 'talent-tree-container' not found.");
        return;
    }
    for (let i = 0; i < rows; i++) {
        for (let j = 0; j < cols; j++) {
                const button = $.CreatePanel('Button', container, `${i}_${j}`);
                // 创建内部文本容器
                const textPanel = $.CreatePanel('Label', button, 'TalentButtonText_'+i+'_'+j);
                textPanel.AddClass('talent-button-text');
                
                if(buttonState[i][j] === 1){
                    button.AddClass('talent-button');
                }else{
                    button.AddClass('transparent-button');
                    button.style.width = 85*(1-buttonState[i][j])+'px';
                }
                button.style.zIndex = rows*cols-(i+1)*(j+1)+1;
                button.SetPanelEvent('onmouseover', () => showTooltip(button, i, j));
                button.SetPanelEvent('onmouseout', () => hideTooltip(button));
                // 将文本设置到内部Panel
                const talentKey = `${i}_${j}`;
                talentPoints[talentKey] = 0;
                const localizedText = $.Localize(`#DOTA_HUD_Talent_Tree_Button_${i}_${j}`);
                textPanel.text = `${localizedText}\n\n${talentPoints[talentKey]}`;
                
                // 初始化点数存储
                button.SetAttributeInt("row", i);
                button.SetAttributeInt("col", j);
                
                // 添加点击事件
                button.SetPanelEvent('onactivate', () => handleTalentClick(i, j, true));
                button.SetPanelEvent('oncontextmenu', () => handleTalentClick(i, j, false));
        }
    }
}

function showTooltip(button, row, col) {
    const tooltip = $.CreatePanel('Label', button, 'tooltip'+row+col);
    tooltip.AddClass('tooltip');
    tooltip.text = getLocalizedText(row, col);
    tooltip.text = $.Localize("#DOTA_HUD_Talent_Tree_Tooltip_"+row+"_"+col);
    $.Msg("showTooltip"+tooltip.id);
    button.SetAttributeString('tooltip', tooltip.id);

}

function hideTooltip(button) {
    
    const tooltipId = button.GetAttributeString('tooltip', '');
    $.Msg("hideTooltip"+tooltipId);
    if (tooltipId) {
        const tooltip = $(`#${tooltipId}`);
        if (tooltip) {
            tooltip.DeleteAsync(0);
        }
        button.SetAttributeString('tooltip', '');
    }
}

function getLocalizedText(row, col) {
    // Placeholder for localization logic
    // This function should read from a file or localization resource
    return `Skill info for (${row}, ${col})`;
}

function toggleTalentTree() {
    const container = $("#talent-tree-container");
    if (!container) {
        $.Msg("Error: 'talent-tree-container' not found.");
        return;
    }
    const currentOpacity = container.style.opacity || '1';
    container.style.opacity = currentOpacity === '1' ? '0' : '1';
}

// 新增点击处理函数
// 定义每个天赋点的最大值
const talentMaxPoints = {
    "0_2": 1,"0_6": 1,"0_10": 1,"0_16": 1,
    "1_1": 5,"1_2": 5,"1_3": 5,"1_5": 5,"1_6": 5,"1_7": 5,"1_9": 5,"1_10": 5,"1_11": 5,"1_13": 5,"1_14": 5,"1_15": 5,
    "3_1": 5,"3_2": 5,"3_3": 5,"3_5": 5,"3_6": 5,"3_7": 5,"3_9": 5,"3_10": 5,"3_11": 5,"3_13": 5,"3_14": 5,"3_15": 5,
    "5_1": 5,"5_2": 5,"5_3": 5,"5_5": 5,"5_6": 5,"5_7": 5,"5_9": 5,"5_10": 5,"5_11": 5,"5_13": 5,"5_14": 5,"5_15": 5,
    "7_1": 5,"7_2": 5,"7_3": 5,"7_5": 5,"7_6": 5,"7_7": 5,"7_9": 5,"7_10": 5,"7_11": 5,"7_13": 5,"7_14": 5,"7_15": 5,
    "9_1": 1,"9_3": 1,"9_5": 1,"9_7": 1,"9_9": 1,"9_11": 1,"9_13": 1,"9_15": 1,
};

// 在 talentMaxPoints 下方添加互斥组定义
const mutexGroups = {
    "group1": ["0_2", "0_6", "0_10", "0_16"],  // 示例互斥组
    // 可以继续添加其他互斥组
};

function handleTalentClick(row, col, isLeftClick) {
    const container = $("#talent-tree-container");
    const talentKey = `${row}_${col}`;
    const button = container.FindChild(`${row}_${col}`);
    const skillPointsLabel = $("#skill-points-label");
    
    // 新增互斥检查（仅在左键点击时检查）
    if (isLeftClick) {
        const conflictPoints = checkMutexConflict(talentKey);
        if (conflictPoints.length > 0) {
            showMutexMessage(conflictPoints);
            return;
        }
    }

    // 新增行解锁验证（第0行不需要验证）
    if (row > 0) {
        // 检查当前行之前的所有行是否都满足条件
        let unlockFailed = false;
        let failedRow = -1;
        let failedRowPoints = 0;
        let failedRowMax = 0;
        
        for (let i = 0; i < row; i++) {
            const rowPoints = getRowTotalPoints(i);
            const rowMax = getRowMaxPoints(i);
            if (rowPoints < rowMax) {
                unlockFailed = true;
                failedRow = i;
                failedRowPoints = rowPoints;
                failedRowMax = rowMax;
                break;
            }
        }
        
        if (unlockFailed) {
            // 显示浮动提示
            $.Msg("showUnlockMessage");
            const messagePanel = $.CreatePanel('Panel', talentTreeRoot, 'UnlockMessage');
            messagePanel.AddClass('floating-message');
            $.Msg(messagePanel);
            const messageText = $.Language() === "schinese" 
                ? `需要在第${failedRow}行分配 ${failedRowMax} 点（当前 ${failedRowPoints} 点）`
                : `Requires ${failedRowMax} points in row ${failedRow} (Current: ${failedRowPoints})`;
                
            const textLabel = $.CreatePanel('Label', messagePanel, 'MessageText');
            textLabel.text = messageText;
            textLabel.AddClass('message-text');
            
            // 3秒后淡出并删除
            $.Schedule(3.0, () => {
                $.Msg("deleteUnlockMessage");
                messagePanel.DeleteAsync(0);
            });
            
            // 更新技能点显示（恢复原样）
            const pointsText = $.Language() === "schinese" 
                ? `可分配天赋点数 : ${availableSkillPoints}` 
                : `Talent Points: ${availableSkillPoints}`;
            skillPointsLabel.text = pointsText;
            return;
        }
    }

    $.Msg("handleTalentClick"+talentKey);
    if (isLeftClick) {
        // 左键增加点数，检查是否达到上限
        if (availableSkillPoints > 0 && (talentMaxPoints[talentKey] === undefined || talentPoints[talentKey] < talentMaxPoints[talentKey])) {
            talentPoints[talentKey]++;
            availableSkillPoints--;
            updateTalentDisplay(button);
        }
    } else {
        // 右键减少点数
        if (talentPoints[talentKey] > 0) {
            talentPoints[talentKey]--;
            availableSkillPoints++;
            updateTalentDisplay(button);
        }
    }
    var event_data = {
		player_id: Game.GetLocalPlayerID(),
		position : talentKey,
        point : talentPoints[talentKey],
	}
	GameEvents.SendCustomGameEventToServer("CheckTalentTree",  event_data );
    // 更新技能点显示
    
}

// 新增辅助函数：获取某行总已分配点数
function getRowTotalPoints(targetRow) {
    let total = 0;
    for (const key in talentPoints) {
        const [row] = key.split('_');
        if (parseInt(row) === targetRow) {
            total += talentPoints[key];
        }
    }
    return total;
}

// 新增辅助函数：获取某行最大可分配点数
function getRowMaxPoints(targetRow) {
    // 根据你的需求定义每行需要多少点才能解锁下一行
    const rowRequirements = {
        0: 4,   // 第0行需要4点才能解锁第1行
        1: 12,  // 第1行需要12点才能解锁第2行
        2: 20,
        3: 28,
        4: 36,
        5: 44,
        6: 52,
        7: 60,
        8: 68
    };
    return rowRequirements[targetRow] || 0;
}

// 新增显示更新函数
function updateTalentDisplay(button) {
    const row = button.GetAttributeInt("row", -1);
    const col = button.GetAttributeInt("col", -1);
    const talentKey = `${row}_${col}`;
    
    // 通过类名查找子元素
    const textPanel = $("#TalentButtonText_"+row+"_"+col);
    
    if (textPanel) {
        const localizedText = $.Localize(`#DOTA_HUD_Talent_Tree_Button_${row}_${col}`);
        textPanel.text = `${localizedText}\n\n${talentPoints[talentKey]}`;
    }
}

// Call the function to create the talent tree

function SendTalentPoint(event_data){
   availableSkillPoints = event_data.available_point;
   const skillPointsLabel = $("#skill-points-label");
   const pointsText = $.Language() === "schinese" 
        ? `可分配天赋点数 : ${availableSkillPoints}` 
        : `Talent Points: ${availableSkillPoints}`;
    skillPointsLabel.text = pointsText;
}

function OpenTalentTree(event_data){
    $.Msg("OpenTalentTree");
    const container = $("#talent-tree-container");
    const talentTreeRoot = container.GetParent();
    if (!talentTreeRoot) {
        $.Msg("Error: 'talent-tree-container' not found.");
        return;
    }
    // Toggle visibility of the talent tree container
    if (talentTreeRoot.style.visibility === "collapse") {
        talentTreeRoot.style.visibility = "visible";
    } else {
        talentTreeRoot.style.visibility = "collapse";
    }
}

$.Schedule(1.0, function() {
    talentTreeRoot.style.visibility = "collapse";
});

// 新增切换边框功能
let borderVisible = false;
function toggleBorderOnPoints() {
    $.Msg("toggleBorderOnPoints");
    const container = $("#talent-tree-container");
    const allButtons = container.Children();
    
    allButtons.forEach(button => {
        const row = button.GetAttributeInt("row", -1);
        const col = button.GetAttributeInt("col", -1);
        const talentKey = `${row}_${col}`;
        button
        if (talentPoints[talentKey] > 0) {
            if (!borderVisible) {
                
                // $.Msg("亮起来");
                button.SetPanelEvent('onactivate', ()=>{
                   
                });
                button.SetPanelEvent('oncontextmenu', ()=>{
                   
                });
                button.AddClass('selected-border');
            }
        }
    });
    
    borderVisible = !borderVisible;
    GameEvents.SendCustomGameEventToServer("TalentTreeReady", {
        player_id: Game.GetLocalPlayerID(),
        ready: true
    });
}

// 新增互斥检查函数
function checkMutexConflict(talentKey) {
    const group = getMutexGroup(talentKey);
    if (!group) return [];
    
    return group.filter(key => 
        key !== talentKey && 
        talentPoints[key] > 0
    );
}

// 新增获取互斥组函数
function getMutexGroup(talentKey) {
    for (const group in mutexGroups) {
        if (mutexGroups[group].includes(talentKey)) {
            return mutexGroups[group];
        }
    }
    return null;
}

// 新增互斥提示显示函数
function showMutexMessage(conflictPoints) {
    const messagePanel = $.CreatePanel('Panel', talentTreeRoot, 'MutexMessage');
    messagePanel.AddClass('floating-message');
    
    const conflictList = conflictPoints.map(key => {
        const [row, col] = key.split('_');
        return $.Localize(`#DOTA_HUD_Talent_Tree_Button_${row}_${col}`);
    }).join(", ");

    const messageText = $.Language() === "schinese" 
        ? `无法同时学习：${conflictList}`
        : `Cannot learn together: ${conflictList}`;

    const textLabel = $.CreatePanel('Label', messagePanel, 'MutexMessageText');
    textLabel.text = messageText;
    textLabel.AddClass('message-text');
    
    $.Schedule(3.0, () => {
        messagePanel.DeleteAsync(0);
    });
}
