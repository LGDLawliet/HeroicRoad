---@class CPointTemplate : CBaseEntity
CPointTemplate = 
{
}
--Deletes any spawn groups that this point_template has spawned. Note: The point_template will not be deleted by this.
--available:server
---@return nil
function CPointTemplate:DeleteCreatedSpawnGroups()end

--Spawns all of the entities the point_template is pointing at.
--available:server
---@return nil
function CPointTemplate:ForceSpawn()end

--Get the list of the most recent spawned entities.
--available:server
---@return handle
function CPointTemplate:GetSpawnedEntities()end

--Set a callback for when the template spawns entities. The spawned entities will be passed in as an array.
--available:server
---@param callbackFunc handle
---@param callbackScope handle
---@return nil
function CPointTemplate:SetSpawnCallback(callbackFunc,callbackScope)end

