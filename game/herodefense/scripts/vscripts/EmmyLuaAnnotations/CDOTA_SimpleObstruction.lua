---@class CDOTA_SimpleObstruction : CBaseEntity
CDOTA_SimpleObstruction = 
{
}
--Returns whether the obstruction is currently active.
--available:server
---@return bool
function CDOTA_SimpleObstruction:IsEnabled()end

--Enable or disable the obstruction.
--available:server
---@param enabled bool
---@param force bool
---@return nil
function CDOTA_SimpleObstruction:SetEnabled(enabled,force)end

