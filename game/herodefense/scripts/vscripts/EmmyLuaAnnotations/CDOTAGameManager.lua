---@class CDOTAGameManager
CDOTAGameManager = 
{
}
--Get the hero unit.
--available:both
---@param heroName string
---@return table
function CDOTAGameManager:GetHeroDataByName_Script(heroName)end

--Get the hero ID given the hero name.
--available:both
---@param heroName string
---@return int
function CDOTAGameManager:GetHeroIDByName(heroName)end

--Get the hero name given a hero ID.
--available:both
---@param heroId int
---@return string
function CDOTAGameManager:GetHeroNameByID(heroId)end

--Get the hero name given a unit name.
--available:both
---@param unitName string
---@return string
function CDOTAGameManager:GetHeroNameForUnitName(unitName)end

--Get the hero unit name given the hero ID.
--available:both
---@param heroId int
---@return string
function CDOTAGameManager:GetHeroUnitNameByID(heroId)end

