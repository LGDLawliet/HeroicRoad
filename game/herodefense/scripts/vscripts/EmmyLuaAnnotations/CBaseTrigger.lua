---@class CBaseTrigger : CBaseEntity
CBaseTrigger = 
{
}
--Disable's the trigger.
--available:server
---@return nil
function CBaseTrigger:Disable()end

--Enable the trigger.
--available:server
---@return nil
function CBaseTrigger:Enable()end

--Checks whether the passed entity is touching the trigger.
--available:server
---@param ent CBaseEntity
---@return bool
function CBaseTrigger:IsTouching(ent)end

