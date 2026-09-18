---@class CFoWBlockerRegion : CBaseEntity
CFoWBlockerRegion = 
{
}
--Sets or clears a blocker rectangle.
--available:server
---@param mins Vector
---@param maxs Vector
---@param clearRegion bool
---@return nil
function CFoWBlockerRegion:AddRectangularBlocker(mins,maxs,clearRegion)end

--Sets or clears a blocker rectangle outline.
--available:server
---@param mins Vector
---@param maxs Vector
---@param clearRegion bool
---@return nil
function CFoWBlockerRegion:AddRectangularOutlineBlocker(mins,maxs,clearRegion)end

