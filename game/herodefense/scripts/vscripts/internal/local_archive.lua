-- One transport for all add-on business requests. Normal play is entirely in Lua.
require("internal/json")
local Store = require("internal/local_archive_store")
local Archive = {pending={}, state="new"}

local function later(fn)
    Timers:CreateTimer(0, function() fn() end)
end

local function notify(message)
    print("[LocalArchive] " .. message)
    if GameRules and GameRules.SendCustomMessage then
        GameRules:SendCustomMessage("[LocalArchive] " .. message, 0, 0)
    end
end

local function decode(body)
    local ok, value = pcall(function() return JSON:decode(body) end)
    if ok and type(value) == "table" then return value end
    return nil
end

local function playerSteamId(data)
    local id = data.steamId or (data.playerInfo or {}).steamId
        or ((data.runeInfos or {})[1] or {}).steamId
    if id then return tostring(id) end
    if data.dota2Id then
        for i = 0, (DOTA_MAX_TEAM_PLAYERS or 24)-1 do
            if tostring(PlayerResource:GetSteamAccountID(i)) == tostring(data.dota2Id) then
                return tostring(PlayerResource:GetSteamID(i))
            end
        end
    end
end

local function release(data)
    local steamId = playerSteamId(data)
    for i = 0, (DOTA_MAX_TEAM_PLAYERS or 24)-1 do
        if steamId and tostring(PlayerResource:GetSteamID(i)) == steamId then
            if _G.GAME_CAN_BUY then _G.GAME_CAN_BUY[i] = true end
            if chaotic_era and chaotic_era.SetPlayerEquiping then chaotic_era:SetPlayerEquiping(i, false) end
        end
    end
end

function Archive.route(url)
    if url:find("api.m.taobao.com", 1, true) then return "time/get" end
    return url:match("^https?://[^/]+/(.+)$")
end

function Archive:deliver(request)
    local data = decode(request.body or "{}")
    if not data then
        notify("请求数据不是有效 JSON，操作已停止。")
        return
    end
    if data.dota2Id then data.steamId = playerSteamId(data) end
    local path = Archive.route(request.url)
    local ok, result = pcall(function() return self.store:request(path, data) end)
    local status = 200
    if not ok then
        status, result = 400, {rtnCode=400, message="Local archive operation failed"}
        notify("本地操作失败：" .. tostring(path) .. "。未访问远端。")
        release(data)
    elseif tonumber(result.rtnCode) ~= 200 then
        status = tonumber(result.rtnCode) or 400
        release(data)
        notify("本地模式不支持此在线操作：" .. tostring(path))
    end
    request.callback({StatusCode=status, Body=json.encode(result)})
end

function Archive:ready(document)
    local ok, store = pcall(Store.new, document)
    if not ok then self:fail("本地档案校验失败，请检查地图文件。"); return end
    self.store, self.state = store, "ready"
    local pending = self.pending
    self.pending = {}
    notify("本地档案已就绪；所有业务请求使用独立的局内副本。")
    for _, request in ipairs(pending) do later(function() self:deliver(request) end) end
end

function Archive:fail(message)
    self.state = "failed"
    -- Do not feed failure into legacy unbounded retry loops, and never fall back online.
    self.pending = {}
    notify(message .. " 请结束本局，修复后重新启动地图。")
end

function Archive:send(request)
    if self.state == "ready" then self:deliver(request); return end
    if self.state == "failed" then return end
    self.pending[#self.pending+1] = request
    if self.state ~= "new" then return end
    local ok, document = pcall(require, "internal/local_archive_data")
    if not ok then self:fail("本地档案缺失或损坏，请检查地图文件。"); return end
    self:ready(document)
end

function Archive.CreateRequest(method, url)
    local request = {method=method, url=url}
    function request:SetHTTPRequestHeaderValue() end
    function request:SetHTTPRequestRawPostBody(_, body) self.body = body end
    function request:Send(callback)
        self.callback = callback
        later(function() Archive:send(self) end)
    end
    return request
end

return Archive
