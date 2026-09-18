

-- 兽的技能修饰
function uimanager:_SpellModifySend(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    local TargetPlayerHero = player:GetAssignedHero() 
    if not TargetPlayerHero then
        return
    end
    local spell = event_data.spell
    local ability = TargetPlayerHero:FindAbilityByName(spell)
    local options = event_data.options
    if ability then
        ability:CheckSpellModify(options)
    end
    -- PrintTable(options)
    -- print(ability)
    
    
end


