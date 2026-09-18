---@class CCustomGameEventManager
CCustomGameEventManager = 
{
}
--Register a callback to be called when a particular custom event arrives. Returns a listener ID that can be used to unregister later.
--available:server
---@param eventName string
---@param listener function
---@return CustomGameEventListenerID
function CCustomGameEventManager:RegisterListener(eventName,listener)end

--
--available:server
---@param eventName string
---@param eventData table
---@return nil
function CCustomGameEventManager:Send_ServerToAllClients(eventName,eventData)end

--
--available:server
---@param player CDOTAPlayer
---@param eventName string
---@param eventData table
---@return nil
function CCustomGameEventManager:Send_ServerToPlayer(player,eventName,eventData)end

--
--available:server
---@param team DOTATeam_t
---@param eventName string
---@param eventData table
---@return nil
function CCustomGameEventManager:Send_ServerToTeam(team,eventName,eventData)end

--Unregister a specific listener.
--available:server
---@param listenerId CustomGameEventListenerID
---@return nil
function CCustomGameEventManager:UnregisterListener(listenerId)end

