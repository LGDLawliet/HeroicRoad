---comment
---@param table table
function Boss_entry_send(table)
    print("已发送"..table[1])
    CustomGameEventManager:Send_ServerToAllClients("Boss_entry_send", {table = table})
end

---comment
---@param duration number
---@param strength number
function CameraShake(duration,strength)
    CustomGameEventManager:Send_ServerToAllClients("CameraShake", {duration = duration,strength = strength})
end
