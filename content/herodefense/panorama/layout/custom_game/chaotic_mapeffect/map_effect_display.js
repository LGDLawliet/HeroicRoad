(function() {
  $.Msg('MapEffectDisplay loaded');

  const container = $.GetContextPanel().FindChildInLayoutFile('MapEffectList');
  
  function UpdateMapEffects() {
    const data = CustomNetTables.GetTableValue('game_config', 'chaoticEra_mapEffect_record');
    $.Msg(data);
    // 检查 data 是否存在
    if (!data) return;
    
    // 每次更新时删除所有面板
    container.RemoveAndDeleteChildren();

    // 遍历 data 对象，按次序创建面板
    for (const key in data) {
      if (data.hasOwnProperty(key)) {
        const effectName = data[key];
        // 生成唯一的 id，这里使用 key 作为 id 的一部分确保唯一性
        const panelId = `MapEffectPanel_${key}`; 
        // 创建面板时指定 id
        const panel = $.CreatePanel('Panel', container, panelId); 
        panel.BLoadLayoutSnippet('MapEffectSnippet');
        // 创建 Label 组件来存储文字
        const label = $.CreatePanel('Label', panel, `EffectNameLabel_${key}`);
        label.AddClass('text-center')
        label.text = $.Localize("#"+effectName);
      }
    }
  }
  
  CustomNetTables.SubscribeNetTableListener('game_config', UpdateMapEffects);
  UpdateMapEffects();
})();