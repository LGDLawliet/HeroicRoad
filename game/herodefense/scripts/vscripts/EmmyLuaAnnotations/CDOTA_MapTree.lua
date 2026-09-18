---@class CDOTA_MapTree : CBaseEntity
CDOTA_MapTree = 
{
}
--Cuts down this tree.
--available:server
---@param teamNumberKnownTo int
---@return nil
function CDOTA_MapTree:CutDown(teamNumberKnownTo)end

--Cuts down this tree.
--available:server
---@param regrowAfter float
---@param teamNumberKnownTo int
---@return nil
function CDOTA_MapTree:CutDownRegrowAfter(regrowAfter,teamNumberKnownTo)end

--Grows back the tree if it was cut down.
--available:server
---@return nil
function CDOTA_MapTree:GrowBack()end

--Returns true if the tree is standing, false if it has been cut down.
--available:server
---@return bool
function CDOTA_MapTree:IsStanding()end

