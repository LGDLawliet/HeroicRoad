-- Session-local implementation of the addon's business API. No HTTP or file IO.
local Store = {}
Store.__index = Store

local function copy(value)
    if type(value) ~= "table" then return value end
    local result = {}
    for k, v in pairs(value) do result[k] = copy(v) end
    return result
end

local money = {gold=true, platinum=true, reliableExp=true, core1=true, core2=true, core3=true}
local function merge(target, patch, additive)
    for k, v in pairs(patch or {}) do
        if k ~= "token" and k ~= "steamId" and k ~= "steamID" then
            if money[k] then
                local number = assert(tonumber(v), "Invalid currency: " .. k)
                target[k] = additive and ((tonumber(target[k]) or 0) + number) or number
            else
                target[k] = copy(v)
            end
        end
    end
end

local function upsert(list, field, value)
    assert(value[field] ~= nil, "Missing " .. field)
    for _, item in ipairs(list) do
        if tostring(item[field]) == tostring(value[field]) then merge(item, value, false); return item end
    end
    local item = copy(value)
    list[#list + 1] = item
    return item
end

local function rebind(value, steamId)
    if type(value) ~= "table" then return end
    for key, child in pairs(value) do
        if key == "steamId" or key == "steamID" then value[key] = steamId
        elseif key == "dota2Id" or key == "dota2ID" then
            -- SteamID64 cannot safely be converted to a Lua double. Subtract its
            -- constant prefix in decimal strings, keeping all 17 digits exact.
            local base, borrow, digits = "76561197960265728", 0, {}
            for i = 17, 1, -1 do
                local digit = tonumber(steamId:sub(i,i)) - tonumber(base:sub(i,i)) - borrow
                borrow = digit < 0 and 1 or 0
                digits[i] = tostring((digit + 10) % 10)
            end
            value[key] = tonumber(table.concat(digits))
        else rebind(child, steamId) end
    end
end

function Store.new(document)
    assert(document.schemaVersion == 1 and document.complete == true, "Archive incomplete")
    local responses = assert(document.responses, "Missing archive responses")
    for _, path in ipairs({"user/login", "rune/findBySteamId", "blackMarket/get",
        "weeklyFreeSpells/get", "rewards/findAvailableRewards"}) do
        assert(type(responses[path]) == "table" and tonumber(responses[path].rtnCode) == 200,
            "Invalid archive response: " .. path)
    end
    assert(type(responses["user/login"].playerInfo) == "table", "Missing playerInfo")
    assert(type(responses["rune/findBySteamId"].runeInfos) == "table", "Missing runeInfos")
    return setmetatable({document=copy(document), players={}, nextRuneId=1, matches={}}, Store)
end

function Store:player(steamId)
    assert(type(steamId) == "string" and steamId:match("^%d+$") and #steamId == 17,
        "Missing valid player SteamID64")
    if not self.players[steamId] then
        local login = copy(self.document.responses["user/login"])
        rebind(login, steamId)
        login.playerInfo.steamId = steamId
        for _, field in ipairs({"playerSpellsList", "privilegeRecordList", "seasonRankings",
            "specialEffectRecords", "customizeList"}) do login[field] = login[field] or {} end
        for field in pairs(money) do login.playerInfo[field] = tonumber(login.playerInfo[field]) or 0 end
        login.playerInfo.cameraZ = tonumber(login.playerInfo.cameraZ) or 1400
        local runes = copy(self.document.responses["rune/findBySteamId"].runeInfos)
        rebind(runes, steamId)
        for _, rune in ipairs(runes) do
            -- ID is scoped by player, as in the existing runeSet tables.
            rune.runeId = assert(tonumber(rune.runeId), "Invalid rune ID")
            rune.isEquip = tonumber(rune.isEquip) or 0
            rune.modifyCount = tonumber(rune.modifyCount) or 0
            rune.rarity = tonumber(rune.rarity) or 1
            rune.locked = tonumber(rune.locked) or 0
            self.nextRuneId = math.max(self.nextRuneId, rune.runeId + 1)
        end
        self.players[steamId] = {login=login, runes=runes,
            rewards=copy(self.document.responses["rewards/findAvailableRewards"].rewardsIssueRecords or {})}
    end
    return self.players[steamId]
end

local function success(data)
    data = data or {}
    data.rtnCode = 200
    return copy(data)
end

local function identity(data)
    return data.steamId or (data.playerInfo or {}).steamId
        or ((data.runeInfos or {})[1] or {}).steamId
        or ((data.customizeList or {})[1] or {}).steamId
end

function Store:request(path, data)
    data = data or {}
    -- Global endpoints never require a player record.
    if path == "blackMarket/get" or path == "weeklyFreeSpells/get" then
        return copy(self.document.responses[path])
    elseif path == "blackMarket/refresh" or path == "specialEffect/refresh" then
        return success() -- frozen exported market; no remote rotation
    elseif path == "time/get" then
        return success({data={t=self.document.capturedAtEpochMs}})
    elseif path == "error/saveErrorData" then
        return success() -- do not upload telemetry or echo its payload
    elseif path == "matchRecord/saveMatchRecord" then
        self.matches[#self.matches+1] = copy(data)
        return success()
    elseif path == "matchRecord/findMatchRecord" then
        return success({resMap={}}) -- online competition is unavailable locally
    elseif path == "matchRecord/findByTeamId" then
        return success({individualMatchRecords={}})
    elseif path == "user/delAll" or path == "specialEffect/sendEffect"
        or path:match("^alipay/") or path:match("^paypal/") or path:match("^cdKey/") then
        return {rtnCode=403, message="This online-only operation is disabled in local archive mode"}
    elseif path == "specialEffect/useEffect" then
        for _, equipped in ipairs(data.specialEffectRecordList or {}) do
            local player = self:player(equipped.steamId)
            for _, effect in ipairs(player.login.specialEffectRecords) do
                if tostring(effect.effectType) == tostring(equipped.effectType) then
                    effect.isEquip = effect.effectName == equipped.effectName and 1 or 0
                end
            end
        end
        return success()
    end

    local steamId = identity(data)
    local player = self:player(steamId)
    local login = player.login
    if path == "user/login" then return success(login)
    elseif path == "user/settlement" or path == "user/settlementAdd" then
        merge(login.playerInfo, data.playerInfo, path == "user/settlementAdd")
        -- Callers send absolute spell XP even on settlementAdd (currency is delta).
        for _, spell in ipairs(data.playerSpellsList or {}) do
            upsert(login.playerSpellsList, "spellName", spell)
        end
        return success({playerInfo=login.playerInfo})
    elseif path == "customize/saveOrUpdate" then
        for _, record in ipairs(data.customizeList or {}) do
            local saved = upsert(login.customizeList, "customizeKey", record)
            if tonumber(data.isEncourage) == 1 then
                saved.recordDate = saved.recordDate or self.document.responses["blackMarket/get"].sysTime
            end
        end
        for field in pairs(money) do
            if data[field] ~= nil then login.playerInfo[field] = assert(tonumber(data[field])) end
        end
        return success()
    elseif path == "trading/buyPrivilege" or path == "trading/buySpecialEffect" then
        for field in pairs(money) do
            if data[field] ~= nil then login.playerInfo[field] = assert(tonumber(data[field])) end
        end
        -- Local purchases are permanent; the captured template itself is unchanged.
        if path == "trading/buyPrivilege" then
            local privilege = upsert(login.privilegeRecordList, "privilegeName", {
                steamId=steamId, privilegeName=assert(data.privilegeName), endDate="9999-12-31 23:59:59"})
            return success({privilegeRecord=privilege})
        end
        local effect = upsert(login.specialEffectRecords, "effectName", {
            steamId=steamId, effectName=assert(data.specialEffectName),
            effectType=data.specialEffectType, endDate="9999-12-31 23:59:59", isEquip=0})
        return success({specialEffectRecord=effect})
    elseif path == "rewards/findAvailableRewards" then
        return success({rewardsIssueRecords=player.rewards})
    elseif path == "rewards/receiveRewardsByIdAndDota2Ids" then
        for _, id in ipairs(data.ids or {}) do
            for i = #player.rewards, 1, -1 do
                local reward = player.rewards[i]
                if tostring(reward.id) == tostring(id) then
                    for _, field in ipairs({"gold", "platinum", "reliableExp"}) do
                        login.playerInfo[field] = login.playerInfo[field] + (tonumber(reward[field]) or 0)
                    end
                    table.remove(player.rewards, i)
                end
            end
        end
        return success({playerInfo=login.playerInfo})
    elseif path == "rune/findBySteamId" then return success({runeInfos=player.runes})
    elseif path == "rune/save" then
        -- Purchases may include costs as deltas, in the same request as rune creation.
        merge(login.playerInfo, data.playerInfo, true)
        local added = {}
        for _, incoming in ipairs(data.runeInfos or {}) do
            local rune = copy(incoming)
            rune.runeId, rune.steamId = self.nextRuneId, steamId
            self.nextRuneId = self.nextRuneId + 1
            rune.isEquip, rune.modifyCount, rune.locked = rune.isEquip or 0, rune.modifyCount or 0, rune.locked or 0
            player.runes[#player.runes+1] = rune
            added[#added+1] = rune
        end
        return success({runeInfos=added})
    elseif path == "rune/equipRune" then
        local target
        for _, rune in ipairs(player.runes) do
            if tostring(rune.runeId) == tostring(data.runeId) then target = rune end
        end
        assert(target, "Rune does not belong to this player")
        for _, rune in ipairs(player.runes) do
            if rune.correspondingSkill == target.correspondingSkill then
                rune.isEquip = rune == target and 1 or 0
            end
        end
        return success()
    elseif path == "rune/edit" then
        for _, incoming in ipairs(data.runeInfos or {}) do
            local found = false
            for _, rune in ipairs(player.runes) do
                if tostring(rune.runeId) == tostring(incoming.runeId) then found = true end
            end
            assert(found, "Unknown rune")
        end
        merge(login.playerInfo, data.playerInfo, true)
        for _, incoming in ipairs(data.runeInfos or {}) do upsert(player.runes, "runeId", incoming) end
        return success()
    elseif path == "rune/delete" then
        for _, item in ipairs(data.runeIds or {}) do
            local found = false
            for i, rune in ipairs(player.runes) do
                if tostring(rune.runeId) == tostring(item.runeId) then found = true; break end
            end
            assert(found, "Unknown rune")
        end
        for _, item in ipairs(data.runeIds or {}) do
            for i = #player.runes, 1, -1 do
                if tostring(player.runes[i].runeId) == tostring(item.runeId) then table.remove(player.runes, i) end
            end
        end
        merge(login.playerInfo, data.playerInfo, true)
        return success()
    end
    error("Unsupported local route: " .. tostring(path))
end

return Store
