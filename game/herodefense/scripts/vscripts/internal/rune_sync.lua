-- Keep rune inventories and equipped bonuses below individual message limits.
local Sync = {}
local transfers = {}
local publishedEquipment = {}
local CHUNK_BYTES = 6000

function Sync.EquipmentKey(playerId, abilityName)
    return "equip_" .. tostring(playerId) .. "_" .. abilityName
end

function Sync.GetEquipped(playerId, abilityName)
    local data = CustomNetTables:GetTableValue("RuneData", Sync.EquipmentKey(playerId, abilityName))
    if data and data.runeId then return data end
end

function Sync.PublishEquipment(playerId, equipped)
    local previous = publishedEquipment[playerId] or {}
    local current = {}
    for abilityName, rune in pairs(equipped or {}) do
        local encoded = json.encode(rune)
        current[abilityName] = encoded
        if previous[abilityName] ~= encoded then
            CustomNetTables:SetTableValue("RuneData", Sync.EquipmentKey(playerId, abilityName), rune)
        end
    end
    for abilityName in pairs(previous) do
        if not current[abilityName] then
            CustomNetTables:SetTableValue("RuneData", Sync.EquipmentKey(playerId, abilityName), {})
        end
    end
    publishedEquipment[playerId] = current
end

function Sync.SendInventory(playerId, inventory, onComplete)
    local player = PlayerResource:GetPlayer(playerId)
    if not player then return end
    local chunks, entries, size = {}, {}, 2
    local function flush()
        chunks[#chunks + 1] = "[" .. table.concat(entries, ",") .. "]"
        entries, size = {}, 2
    end
    for _, group in pairs(inventory or {}) do
        for _, rune in pairs(group.runeSet or {}) do
            -- Serialize individual records: runeSet uses sparse database IDs.
            local encoded = json.encode(rune)
            if #entries > 0 and size + #encoded + 1 > CHUNK_BYTES then flush() end
            entries[#entries + 1] = encoded
            size = size + #encoded + 1
        end
    end
    if #entries > 0 or #chunks == 0 then flush() end
    local transferId = (transfers[playerId] or 0) + 1
    transfers[playerId] = transferId
    local part = 1
    local function sendNext()
        if transfers[playerId] ~= transferId or PlayerResource:GetPlayer(playerId) ~= player then return end
        CustomGameEventManager:Send_ServerToPlayer(player, "GetChaoticEraRuneData__Feedback", {
            transferId=transferId, part=part, total=#chunks, payload=chunks[part],
        })
        part = part + 1
        if part <= #chunks then return 0.03 end
        if onComplete then onComplete() end
    end
    -- Pace large inventories instead of overflowing one event or a single frame.
    Timers:CreateTimer(0, sendNext)
end

return Sync
