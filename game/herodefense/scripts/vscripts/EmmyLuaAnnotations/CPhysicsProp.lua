---@class CPhysicsProp : CBaseAnimating
CPhysicsProp = 
{
}
--Disable motion for the prop.
--available:server
---@return nil
function CPhysicsProp:DisableMotion()end

--Enable motion for the prop.
--available:server
---@return nil
function CPhysicsProp:EnableMotion()end

--Enable/disable dynamic vs dynamic continuous collision traces.
--available:server
---@param isDynamicVsDynamicContinuousEnabled bool
---@return nil
function CPhysicsProp:SetDynamicVsDynamicContinuous(isDynamicVsDynamicContinuousEnabled)end

