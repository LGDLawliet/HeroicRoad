---@param eventSourceIndex number
---@param event_data event_data
---@class event_data
---@field player_id number
---@field position string
---@field point number
---@field available_point number
function uimanager:_CheckTalentTree(eventSourceIndex, event_data)
    local player = PlayerResource:GetPlayer(event_data.player_id)
    if not player then return end
    
    local hero = player:GetAssignedHero()
    local current_points = hero.talent_points[event_data.position] or 0
    local available_points = hero:GetAvailableSkillPoints()
    
    if event_data.point > current_points then
        if available_points < 1 then return end
        hero:SpendSkillPoint()
        hero.talent_points[event_data.position] = current_points + 1
    elseif event_data.point < current_points then
        hero:RefundSkillPoint()
        hero.talent_points[event_data.position] = current_points - 1
    end
    
    self:_SendTalentPoint(event_data.player_id, hero:GetAvailableSkillPoints())
end

function uimanager:_SendTalentPoint(player_id, available_point)
    local player = PlayerResource:GetPlayer(player_id)
    if not player then
        return
    end

    
    CustomGameEventManager:Send_ServerToPlayer(player, "SendTalentPoint", {available_point = available_point})
end

function uimanager:OpenTalentTree(player_id)
    local player = PlayerResource:GetPlayer(player_id)
    if not player then
        return
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "OpenTalentTree", {})
end

function uimanager:RefreshTalentTree(player_id)
    local player = PlayerResource:GetPlayer(player_id)
    if not player then
        return
    end
    
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end
    
    -- 重置所有天赋点
    local total_points = 0
    if hero.talent_points then
        for position, points in pairs(hero.talent_points) do
            total_points = total_points + points
        end
        hero.talent_points = {}
    else
        hero.talent_points = {}
    end
    
    -- 恢复所有技能点
    hero:SetAvailableSkillPoints(hero:GetAvailableSkillPoints() + total_points)
    
    -- 通知客户端刷新
    self:_SendTalentPoint(player_id, hero:GetAvailableSkillPoints())
end

---@param eventSourceIndex number
---@param event_data ReadyEvent_data
---@class ReadyEvent_data
---@field player_id number
---@field ready boolean
function uimanager:_TalentTreeReady(eventSourceIndex, event_data)
    local player = PlayerResource:GetPlayer(event_data.player_id)
    if not player then
        return
    end

end

-- 为CDOTA_BaseNPC添加技能点相关函数
function CDOTA_BaseNPC:GetAvailableSkillPoints()
    if not self.available_skill_points then
        self.available_skill_points = 0
    end
    return self.available_skill_points
end

function CDOTA_BaseNPC:SetAvailableSkillPoints(points)
    self.available_skill_points = points
end

function CDOTA_BaseNPC:SpendSkillPoint()
    if not self.available_skill_points then
        self.available_skill_points = 0
    end
    
    if self.available_skill_points > 0 then
        self.available_skill_points = self.available_skill_points - 1
        return true
    end
    return false
end

function CDOTA_BaseNPC:RefundSkillPoint()
    if not self.available_skill_points then
        self.available_skill_points = 0
    end
    
    self.available_skill_points = self.available_skill_points + 1
    return true
end

function CDOTA_BaseNPC:AddSkillPoints(points)
    if not self.available_skill_points then
        self.available_skill_points = 0
    end
    
    self.available_skill_points = self.available_skill_points + points
end
