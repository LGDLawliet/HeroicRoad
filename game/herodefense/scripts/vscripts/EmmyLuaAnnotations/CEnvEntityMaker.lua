---@class CEnvEntityMaker : CBaseEntity
CEnvEntityMaker = 
{
}
--Create an entity at the location of the maker.
--available:server
---@return nil
function CEnvEntityMaker:SpawnEntity()end

--Create an entity at the location of a specified entity instance.
--available:server
---@param entity handle
---@return nil
function CEnvEntityMaker:SpawnEntityAtEntityOrigin(entity)end

--Create an entity at a specified location and orientaton, orientation is Euler angle in degrees.
--available:server
---@param vecAlternateOrigin Vector
---@param vecAlternateAngles Vector
---@return nil
function CEnvEntityMaker:SpawnEntityAtLocation(vecAlternateOrigin,vecAlternateAngles)end

--Create an entity at the location of a named entity.
--available:server
---@param name string
---@return nil
function CEnvEntityMaker:SpawnEntityAtNamedEntityOrigin(name)end

