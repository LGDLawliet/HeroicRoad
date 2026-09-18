---@class CEntities
CEntities = 
{
}
--Creates an entity by classname.
--available:server
---@param className string
---@return CBaseEntity
function CEntities:CreateByClassname(className)end

--Finds all entities by class name. Returns an array containing all the found entities.
--available:server
---@param className string
---@return CBaseEntity[]
function CEntities:FindAllByClassname(className)end

--Find entities by class name within a radius.
--available:server
---@param className string
---@param location Vector
---@param radius float
---@return CBaseEntity[]
function CEntities:FindAllByClassnameWithin(className,location,radius)end

--Find entities by model name.
--available:server
---@param modelName string
---@return CBaseEntity[]
function CEntities:FindAllByModel(modelName)end

--Find all entities by name. Returns an array containing all the found entities in it.
--available:server
---@param name string
---@return CBaseEntity[]
function CEntities:FindAllByName(name)end

--Find entities by name within a radius.
--available:server
---@param name string
---@param location Vector
---@param radius float
---@return CBaseEntity[]
function CEntities:FindAllByNameWithin(name,location,radius)end

--Find entities by targetname.
--available:server
---@param target string
---@return CBaseEntity[]
function CEntities:FindAllByTarget(target)end

--Find entities within a radius.
--available:server
---@param location Vector
---@param radius float
---@return CBaseEntity[]
function CEntities:FindAllInSphere(location,radius)end

--Find entities by class name. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search.
--available:server
---@param previous CBaseEntity|nil
---@param className string
---@return CBaseEntity,nil
function CEntities:FindByClassname(previous,className)end

--Find entities by class name nearest to a point.
--available:server
---@param className string
---@param location Vector
---@param radius float
---@return CBaseEntity,nil
function CEntities:FindByClassnameNearest(className,location,radius)end

--Find entities by class name within a radius. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search.
--available:server
---@param previous CBaseEntity|nil
---@param className string
---@param location Vector
---@param radius float
---@return CBaseEntity,nil
function CEntities:FindByClassnameWithin(previous,className,location,radius)end

--Find entities by model name. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search.
--available:server
---@param previous CBaseEntity|nil
---@param modelName string
---@return CBaseEntity,nil
function CEntities:FindByModel(previous,modelName)end

--Find entities by model name within a radius. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search.
--available:server
---@param previous CBaseEntity|nil
---@param modelName string
---@param location Vector
---@param radius float
---@return CBaseEntity,nil
function CEntities:FindByModelWithin(previous,modelName,location,radius)end

--Find entities by name. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search.
--available:server
---@param previous CBaseEntity|nil
---@param name string
---@return CBaseEntity,nil
function CEntities:FindByName(previous,name)end

--Find entities by name nearest to a point.
--available:server
---@param name string
---@param location Vector
---@param radius float
---@return CBaseEntity,nil
function CEntities:FindByNameNearest(name,location,radius)end

--Find entities by name within a radius. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search.
--available:server
---@param previous CBaseEntity|nil
---@param name string
---@param location Vector
---@param radius float
---@return CBaseEntity,nil
function CEntities:FindByNameWithin(previous,name,location,radius)end

--Find entities by targetname. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search.
--available:server
---@param previous CBaseEntity|nil
---@param target string
---@return CBaseEntity,nil
function CEntities:FindByTarget(previous,target)end

--Find entities within a radius. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search.
--available:server
---@param previous CBaseEntity|nil
---@param location Vector
---@param radius float
---@return CBaseEntity,nil
function CEntities:FindInSphere(previous,location,radius)end

--Begin an iteration over the list of entities.
--available:both
---@return CBaseEntity
function CEntities:First()end

--Get the local player.
--available:server
---@return CDOTAPlayer
function CEntities:GetLocalPlayer()end

--Continue an iteration over the list of entities, providing reference to a previously found entity.
--available:both
---@param previous CBaseEntity|nil
---@return CBaseEntity,nil
function CEntities:Next(previous)end

