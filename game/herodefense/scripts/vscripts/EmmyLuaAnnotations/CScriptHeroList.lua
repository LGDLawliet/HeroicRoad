---@class CScriptHeroList
CScriptHeroList = 
{
}
--Returns all the heroes in the world.
--available:server
---@return CDOTA_BaseNPC_Hero[]
function CScriptHeroList:GetAllHeroes()end

--Get the Nth hero in the Hero List.
--available:server
---@param nth int
---@return CDOTA_BaseNPC_Hero,nil
function CScriptHeroList:GetHero(nth)end

--Returns the number of heroes in the world.
--available:server
---@return int
function CScriptHeroList:GetHeroCount()end

