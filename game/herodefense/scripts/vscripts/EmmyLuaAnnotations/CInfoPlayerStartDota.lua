---@class CInfoPlayerStartDota : CPointEntity
CInfoPlayerStartDota = 
{
}
--Returns whether the object is currently active.
--available:server
---@return bool
function CInfoPlayerStartDota:IsEnabled()end

--Enable or disable the obstruction.
--available:server
---@param enabled bool
---@return nil
function CInfoPlayerStartDota:SetEnabled(enabled)end

