---@class CDOTAPlayer : CBaseAnimating
CDOTAPlayer = 
{
}
--Attempt to spawn the appropriate couriers for this mode.
--available:server
---@param hero CDOTA_BaseNPC_Hero
---@return nil
function CDOTAPlayer:CheckForCourierSpawning(hero)end

--Get the player's hero.
--available:server
---@return CDOTA_BaseNPC_Hero
function CDOTAPlayer:GetAssignedHero()end

--Get the player's official PlayerID; notably is -1 when the player isn't yet on a team.
--available:server
---@return PlayerID
function CDOTAPlayer:GetPlayerID()end

--Randoms this player's hero.
--available:server
---@return nil
function CDOTAPlayer:MakeRandomHeroSelection()end

--Sets this player's hero .
--available:server
---@param hero handle
---@return nil
function CDOTAPlayer:SetAssignedHeroEntity(hero)end

--Set the kill cam unit for this hero.
--available:server
---@param entity CDOTA_BaseNPC
---@return nil
function CDOTAPlayer:SetKillCamUnit(entity)end

--Set the music status for this player, note this will only really apply if dota_music_battle_enable is off.
--available:server
---@param musicStatus int
---@param intensity float
---@return nil
function CDOTAPlayer:SetMusicStatus(musicStatus,intensity)end

--Sets this player's hero selection.
--available:server
---@param heroName string
---@return nil
function CDOTAPlayer:SetSelectedHero(heroName)end

--Spawn a courier for this player at the given position.
--available:server
---@param location Vector
---@return CDOTA_Unit_Courier
function CDOTAPlayer:SpawnCourierAtPosition(location)end

