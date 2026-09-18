---@class CDOTA_CustomUIManager
CDOTA_CustomUIManager = 
{
}
--Create a new custom UI HUD element for the specified player(s).
--available:server
---@param playerId PlayerID
---@param elementId string
---@param layoutFileName string
---@param dialogVariables handle
---@return nil
function CDOTA_CustomUIManager:DynamicHud_Create(playerId,elementId,layoutFileName,dialogVariables)end

--Destroy a custom hud element.
--available:server
---@param playerId PlayerID
---@param elementId string
---@return nil
function CDOTA_CustomUIManager:DynamicHud_Destroy(playerId,elementId)end

--Add or modify dialog variables for an existing custom hud element.
--available:server
---@param playerId PlayerID
---@param elementId string
---@param dialogVariables handle
---@return nil
function CDOTA_CustomUIManager:DynamicHud_SetDialogVariables(playerId,elementId,dialogVariables)end

--Toggle the visibility of an existing custom hud element.
--available:server
---@param playerId PlayerID
---@param elementId string
---@param visible bool
---@return nil
function CDOTA_CustomUIManager:DynamicHud_SetVisible(playerId,elementId,visible)end

