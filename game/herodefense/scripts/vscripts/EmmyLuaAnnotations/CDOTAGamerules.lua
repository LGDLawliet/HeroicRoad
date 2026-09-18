---@class CDOTAGamerules
CDOTAGamerules = 
{
}
--Spawn a bot player of the passed hero name, player name, and team.
--available:server
---@param heroName string
---@param playerName string
---@param team DOTATeam_t
---@param entityScript string
---@param arg5 bool
---@return CDOTA_BaseNPC_Hero,nil
function CDOTAGamerules:AddBotPlayerWithEntityScript(heroName,playerName,team,entityScript,arg5)end

--Event-only.
--available:server
---@param nameSuffix string
---@param stars uint
---@param maxStars uint
---@param extraData1 uint
---@param extraData2 uint
---@param extraData3 uint
---@param extraData4 uint
---@param extraData5 uint
---@param extraData6 uint
---@return bool
function CDOTAGamerules:AddEventMetadataLeaderboardEntry(nameSuffix,stars,maxStars,extraData1,extraData2,extraData3,extraData4,extraData5,extraData6)end

--Event-only.
--available:server
---@param nameSuffix string
---@param score uint
---@param extraData1 uint
---@param extraData2 uint
---@param extraData3 uint
---@param extraData4 uint
---@param extraData5 uint
---@param extraData6 uint
---@return bool
function CDOTAGamerules:AddEventMetadataLeaderboardEntryRawScore(nameSuffix,score,extraData1,extraData2,extraData3,extraData4,extraData5,extraData6)end

--Add an item to the whitelist.
--available:server
---@param itemName string
---@return nil
function CDOTAGamerules:AddItemToWhiteList(itemName)end

--Add a point on the minimap.
--available:server
---@param arg1 int
---@param arg2 Vector
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 float
---@return nil
function CDOTAGamerules:AddMinimapDebugPoint(arg1,arg2,arg3,arg4,arg5,arg6,arg7)end

--Add a point on the minimap for a specific team.
--available:server
---@param arg1 int
---@param arg2 Vector
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 float
---@param arg8 int
---@return nil
function CDOTAGamerules:AddMinimapDebugPointForTeam(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Begin night stalker night.
--available:server
---@param duration float
---@return nil
function CDOTAGamerules:BeginNightstalkerNight(duration)end

--Begin temporary night.
--available:server
---@param duration float
---@return nil
function CDOTAGamerules:BeginTemporaryNight(duration)end

--Fills all the teams with bots if cheat mode is enabled.
--available:server
---@return nil
function CDOTAGamerules:BotPopulate()end

--Kills the ancient, etc.
--available:server
---@return nil
function CDOTAGamerules:Defeated()end

--True when we have waited some time after end of the game and not received signout.
--available:server
---@return bool
function CDOTAGamerules:DidMatchSignoutTimeOut()end

--Enabled (true) or disable (false) auto launch for custom game setup.
--available:server
---@param enabled bool
---@return nil
function CDOTAGamerules:EnableCustomGameSetupAutoLaunch(enabled)end

--Sends a minimap ping to all players on the team.
--available:server
---@param team DOTATeam_t
---@param xCoord float
---@param yCoord float
---@param entity CBaseEntity|nil
---@param type number|number|number|number|number|number|number
---@return nil
function CDOTAGamerules:ExecuteTeamPing(team,xCoord,yCoord,entity,type)end

--Indicate that the custom game setup phase is complete, and advance to the game.
--available:server
---@return nil
function CDOTAGamerules:FinishCustomGameSetup()end

--Spawn the next wave of creeps.
--available:server
---@return nil
function CDOTAGamerules:ForceCreepSpawn()end

--Transition game state to DOTA_GAMERULES_STATE_GAME_IN_PROGRESS.
--available:server
---@return nil
function CDOTAGamerules:ForceGameStart()end

--Get the announcer for a team.
--available:server
---@param team DOTATeam_t
---@return CDOTA_BaseNPC,nil
function CDOTAGamerules:GetAnnouncer(team)end

--Returns the hero unit names banned in this game, if any.
--available:both
---@return string[]
function CDOTAGamerules:GetBannedHeroes()end

--Returns the difficulty level of the custom game mode.
--available:both
---@return int
function CDOTAGamerules:GetCustomGameDifficulty()end

--Get whether a team is selectable during game setup.
--available:server
---@param team DOTATeam_t
---@return int
function CDOTAGamerules:GetCustomGameTeamMaxPlayers(team)end

--Returns difficulty level of the custom game mode.
--available:both
---@return int
function CDOTAGamerules:GetDifficulty()end

--Returns the actual DOTA in-game clock time.
--available:both
---@param includePreGame bool
---@param includeNegativeTime bool
---@return float
function CDOTAGamerules:GetDOTATime(includePreGame,includeNegativeTime)end

--Gets the Xth dropped item.
--available:server
---@param index int
---@return CDOTA_Item_Physical,nil
function CDOTAGamerules:GetDroppedItem(index)end

--Returns the number of seconds elapsed since the last frame was renderered. This time doesn't count up when the game is paused.
--available:both
---@return float
function CDOTAGamerules:GetGameFrameTime()end

--Get the game mode entity.
--available:server
---@return CDOTABaseGameMode
function CDOTAGamerules:GetGameModeEntity()end

--Get a string value from the game session config (map options).
--available:server
---@param arg1 string
---@param arg2 string
---@return string
function CDOTAGamerules:GetGameSessionConfigValue(arg1,arg2)end

--Returns the number of seconds elapsed since map start. This time doesn't count up when the game is paused.
--available:both
---@return float
function CDOTAGamerules:GetGameTime()end

--Get the stock count of the item.
--available:both
---@param team DOTATeam_t
---@param itemName string
---@param playerId PlayerID
---@return int
function CDOTAGamerules:GetItemStockCount(team,itemName,playerId)end

--Get the time it takes to add a new item to stock.
--available:both
---@param team DOTATeam_t
---@param itemName string
---@param playerId PlayerID
---@return float
function CDOTAGamerules:GetItemStockDuration(team,itemName,playerId)end

--Get the time an item will be added to stock.
--available:both
---@param team DOTATeam_t
---@param itemName string
---@param playerId PlayerID
---@return float
function CDOTAGamerules:GetItemStockTime(team,itemName,playerId)end

--Get the MatchID for this game.
--available:server
---@return Uint64
function CDOTAGamerules:GetMatchID()end

--Have we received the post match signout message that includes reward information.
--available:server
---@return bool
function CDOTAGamerules:GetMatchSignoutComplete()end

--Gets next bounty rune spawn time.
--available:server
---@return float
function CDOTAGamerules:GetNextBountyRuneSpawnTime()end

--Gets next rune spawn time.
--available:server
---@return float
function CDOTAGamerules:GetNextRuneSpawnTime()end

--For New Bloom, get total damage taken by the Nian / Year Beast.
--available:server
---@return int
function CDOTAGamerules:GetNianTotalDamageTaken()end

--Gets the player's custom game account record, as it looked at the start of this session.
--available:server
---@param playerId PlayerID
---@return table
function CDOTAGamerules:GetPlayerCustomGameAccountRecord(playerId)end

--Get time remaining between state changes.
--available:server
---@return float
function CDOTAGamerules:GetStateTransitionTime()end

--Get the time of day.
--available:server
---@return float
function CDOTAGamerules:GetTimeOfDay()end

--Get Weather Wind Direction Vector.
--available:both
---@return Vector
function CDOTAGamerules:GetWeatherWindDirection()end

--Increase an item's stock count, clamped to item max.
--available:server
---@param team DOTATeam_t
---@param itemName string
---@param count int
---@param playerId PlayerID
---@return nil
function CDOTAGamerules:IncreaseItemStock(team,itemName,count,playerId)end

--Are cheats enabled on the server.
--available:both
---@return bool
function CDOTAGamerules:IsCheatMode()end

--Is it day time?
--available:server
---@return bool
function CDOTAGamerules:IsDaytime()end

--Returns whether the game is paused.
--available:server
---@return bool
function CDOTAGamerules:IsGamePaused()end

--Returns whether hero respawn is enabled.
--available:server
---@return bool
function CDOTAGamerules:IsHeroRespawnEnabled()end

--Are we in the ban phase of hero pick?
--available:server
---@return bool
function CDOTAGamerules:IsInBanPhase()end

--Query an item in the whitelist.
--available:server
---@param itemName string
---@return bool
function CDOTAGamerules:IsItemInWhiteList(itemName)end

--Is it night stalker night-time?
--available:server
---@return bool
function CDOTAGamerules:IsNightstalkerNight()end

--Is it temporarily night-time?
--available:server
---@return bool
function CDOTAGamerules:IsTemporaryNight()end

--Lock (true) or unlock (false) team assignemnt. If team assignment is locked players cannot change teams.
--available:server
---@param locked bool
---@return nil
function CDOTAGamerules:LockCustomGameSetupTeamAssignment(locked)end

--Makes the specified team lose.
--available:server
---@param team DOTATeam_t
---@return nil
function CDOTAGamerules:MakeTeamLose(team)end

--Like ModifyGold, but will use the gold filter if SetFilterMoreGold has been set true.
--available:server
---@param playerId PlayerID
---@param goldChange int
---@param reliable bool
---@param reason EDOTA_ModifyGold_Reason
---@return int
function CDOTAGamerules:ModifyGoldFiltered(playerId,goldChange,reliable,reason)end

--Returns the number of items currently dropped on the ground.
--available:server
---@return int
function CDOTAGamerules:NumDroppedItems()end

--Whether a player has custom game host privileges (shuffle teams, etc.).
--available:server
---@param player CDOTAPlayer
---@return bool
function CDOTAGamerules:PlayerHasCustomGameHostPrivileges(player)end

--Updates custom hero, unit and ability KeyValues in memory with the latest values from disk.
--available:server
---@return nil
function CDOTAGamerules:Playtesting_UpdateAddOnKeyValues()end

--Prepare Dota lane style spawners with a given interval.
--available:server
---@param arg1 float
---@return nil
function CDOTAGamerules:PrepareSpawners(arg1)end

--Removes a fake client.
--available:server
---@param playerId PlayerID
---@return nil
function CDOTAGamerules:RemoveFakeClient(playerId)end

--Remove an item from the whitelist.
--available:server
---@param itemName string
---@return nil
function CDOTAGamerules:RemoveItemFromWhiteList(itemName)end

--Restart after killing the ancient, etc.
--available:server
---@return nil
function CDOTAGamerules:ResetDefeated()end

--Restart gametime from 0.
--available:server
---@return nil
function CDOTAGamerules:ResetGameTime()end

--Restart at custom game setup.
--available:server
---@return nil
function CDOTAGamerules:ResetToCustomGameSetup()end

--Restart the game at hero selection.
--available:server
---@return nil
function CDOTAGamerules:ResetToHeroSelection()end

--Sends a message on behalf of a player.
--available:server
---@param arg1 string
---@param arg2 int
---@param arg3 int
---@return nil
function CDOTAGamerules:SendCustomMessage(arg1,arg2,arg3)end

--Sends a message on behalf of a player to the specified team.
--available:server
---@param arg1 string
---@param arg2 int
---@param arg3 int
---@param arg4 int
---@return nil
function CDOTAGamerules:SendCustomMessageToTeam(arg1,arg2,arg3,arg4)end

--Scale the creep icons on the minimap.
--available:server
---@param scale float
---@return nil
function CDOTAGamerules:SetCreepMinimapIconScale(scale)end

--Sets whether the regular Dota creeps spawn.
--available:server
---@param arg1 bool
---@return nil
function CDOTAGamerules:SetCreepSpawningEnabled(arg1)end

--Sets a callback to handle saving custom game account records (callback is passed a Player ID and should return a flat simple table).
--available:server
---@param arg1 handle
---@param arg2 handle
---@return nil
function CDOTAGamerules:SetCustomGameAccountRecordSaveFunction(arg1,arg2)end

--Sets a flag to enable/disable the default music handling code for custom games.
--available:server
---@param allow bool
---@return nil
function CDOTAGamerules:SetCustomGameAllowBattleMusic(allow)end

--Sets a flag to enable/disable the default music handling code for custom games.
--available:server
---@param allow bool
---@return nil
function CDOTAGamerules:SetCustomGameAllowHeroPickMusic(allow)end

--Sets a flag to enable/disable the default music handling code for custom games.
--available:server
---@param allow bool
---@return nil
function CDOTAGamerules:SetCustomGameAllowMusicAtGameStart(allow)end

--Sets a flag to enable/disable the casting secondary abilities from units other than the player's own hero.
--available:server
---@param arg1 bool
---@return nil
function CDOTAGamerules:SetCustomGameAllowSecondaryAbilitiesOnOtherUnits(arg1)end

--Set number of hero bans each team gets.
--available:server
---@param arg1 int
---@return nil
function CDOTAGamerules:SetCustomGameBansPerTeam(arg1)end

--Set the difficulty level of the custom game mode.
--available:server
---@param difficulty int
---@return nil
function CDOTAGamerules:SetCustomGameDifficulty(difficulty)end

--Sets the game end delay.
--available:server
---@param delay float
---@return nil
function CDOTAGamerules:SetCustomGameEndDelay(delay)end

--Set the amount of time to wait for auto launch.
--available:server
---@param delay float
---@return nil
function CDOTAGamerules:SetCustomGameSetupAutoLaunchDelay(delay)end

--Set the amount of remaining time, in seconds, for custom game setup. 0 = finish immediately, -1 = wait forever.
--available:server
---@param remainingTime float
---@return nil
function CDOTAGamerules:SetCustomGameSetupRemainingTime(remainingTime)end

--Setup (pre-gameplay) phase timeout. 0 = instant, -1 = forever (until FinishCustomGameSetup is called).
--available:server
---@param timeout float
---@return nil
function CDOTAGamerules:SetCustomGameSetupTimeout(timeout)end

--Set whether a team is selectable during game setup.
--available:server
---@param team DOTATeam_t
---@param maxPlayers int
---@return nil
function CDOTAGamerules:SetCustomGameTeamMaxPlayers(team,maxPlayers)end

--Sets the victory message.
--available:server
---@param message string
---@return nil
function CDOTAGamerules:SetCustomVictoryMessage(message)end

--Sets the victory message duration.
--available:server
---@param duration float
---@return nil
function CDOTAGamerules:SetCustomVictoryMessageDuration(duration)end

--Event-only.
--available:server
---@param metadataTable handle
---@return bool
function CDOTAGamerules:SetEventMetadataCustomTable(metadataTable)end

--Event-only.
--available:server
---@param metadataTable handle
---@return bool
function CDOTAGamerules:SetEventSignoutCustomTable(metadataTable)end

--Sets whether to filter more gold events than normal.
--available:server
---@param arg1 bool
---@return nil
function CDOTAGamerules:SetFilterMoreGold(arg1)end

--Sets whether First Blood has been triggered.
--available:server
---@param active bool
---@return nil
function CDOTAGamerules:SetFirstBloodActive(active)end

--Freeze the game time.
--available:server
---@param frozen bool
---@return nil
function CDOTAGamerules:SetGameTimeFrozen(frozen)end

--Makes the specified team win.
--available:server
---@param team DOTATeam_t
---@return nil
function CDOTAGamerules:SetGameWinner(team)end

--Set Glyph cooldown for team.
--available:server
---@param team DOTATeam_t
---@param cooldown float
---@return nil
function CDOTAGamerules:SetGlyphCooldown(team,cooldown)end

--Set the auto gold increase per timed interval.
--available:server
---@param amount int
---@return nil
function CDOTAGamerules:SetGoldPerTick(amount)end

--Set the time interval between auto gold increases.
--available:server
---@param time float
---@return nil
function CDOTAGamerules:SetGoldTickTime(time)end

--Scale the hero minimap icons on the minimap.
--available:server
---@param scale float
---@return nil
function CDOTAGamerules:SetHeroMinimapIconScale(scale)end

--Control if the normal DOTA hero respawn rules apply.
--available:server
---@param enabled bool
---@return nil
function CDOTAGamerules:SetHeroRespawnEnabled(enabled)end

--Sets the amount of time players have to pick their hero.
--available:server
---@param selectionTime float
---@return nil
function CDOTAGamerules:SetHeroSelectionTime(selectionTime)end

--Sets amount of penalty time before randoming a hero.
--available:server
---@param arg1 float
---@return nil
function CDOTAGamerules:SetHeroSelectPenaltyTime(arg1)end

--Sets whether the multikill, streak, and first-blood banners appear at the top of the screen.
--available:server
---@param hideHeaders bool
---@return nil
function CDOTAGamerules:SetHideKillMessageHeaders(hideHeaders)end

--Set whether custom and event games should ignore Lobby teams when assigning players to teams. Defaults to true.
--available:server
---@param arg1 bool
---@return nil
function CDOTAGamerules:SetIgnoreLobbyTeamsInCustomGame(arg1)end

--Set the stock count of the item.
--available:server
---@param count int
---@param team DOTATeam_t
---@param itemName string
---@param playerId PlayerID
---@return nil
function CDOTAGamerules:SetItemStockCount(count,team,itemName,playerId)end

--Sets next bounty rune spawn time.
--available:server
---@param arg1 float
---@return nil
function CDOTAGamerules:SetNextBountyRuneSpawnTime(arg1)end

--Sets next rune spawn time.
--available:server
---@param arg1 float
---@return nil
function CDOTAGamerules:SetNextRuneSpawnTime(arg1)end

--Show this unit's health on the overlay health bar.
--available:server
---@param unit CDOTA_BaseNPC
---@param style int
---@return nil
function CDOTAGamerules:SetOverlayHealthBarUnit(unit,style)end

--Sets the amount of time players have between the game ending and the server disconnecting them.
--available:server
---@param time float
---@return nil
function CDOTAGamerules:SetPostGameTime(time)end

--Sets the amount of time players have between picking their hero and game start.
--available:server
---@param time float
---@return nil
function CDOTAGamerules:SetPreGameTime(time)end

--Scale the rune icons on the minimap.
--available:server
---@param minimapRuneIconScale float
---@return nil
function CDOTAGamerules:SetRuneMinimapIconScale(minimapRuneIconScale)end

--Sets the amount of time between rune spawns.
--available:server
---@param time float
---@return nil
function CDOTAGamerules:SetRuneSpawnTime(time)end

--Mark this game as safe to leave.
--available:server
---@param safeToLeave bool
---@return nil
function CDOTAGamerules:SetSafeToLeave(safeToLeave)end

--When true, players can repeatedly pick the same hero.
--available:server
---@param enabled bool
---@return nil
function CDOTAGamerules:SetSameHeroSelectionEnabled(enabled)end

--Sets the amount of time players have between the strategy phase and entering the pre-game phase.
--available:server
---@param time float
---@return nil
function CDOTAGamerules:SetShowcaseTime(time)end

--Set whether to speak a Spawn concept instead of a Respawn concept on respawn.
--available:server
---@param arg1 bool
---@return nil
function CDOTAGamerules:SetSpeechUseSpawnInsteadOfRespawnConcept(arg1)end

--Set the starting gold amount.
--available:server
---@param amount int
---@return nil
function CDOTAGamerules:SetStartingGold(amount)end

--Sets the amount of time players have between the hero selection and entering the showcase phase.
--available:server
---@param time float
---@return nil
function CDOTAGamerules:SetStrategyTime(time)end

--Set the time of day.
--available:server
---@param time float
---@return nil
function CDOTAGamerules:SetTimeOfDay(time)end

--Sets the tree regrow time in seconds.
--available:server
---@param time float
---@return nil
function CDOTAGamerules:SetTreeRegrowTime(time)end

--Heroes will use the basic NPC functionality for determining their bounty, rather than DOTA specific formulas.
--available:server
---@param useBaseGoldBounties bool
---@return nil
function CDOTAGamerules:SetUseBaseGoldBountyOnHeroes(useBaseGoldBounties)end

--Allows heroes in the map to give a specific amount of XP (this value must be set).
--available:server
---@param useCustomXPValues bool
---@return nil
function CDOTAGamerules:SetUseCustomHeroXPValues(useCustomXPValues)end

--When true, all items are available at as long as any shop is in range.
--available:server
---@param useUniversalShopMode bool
---@return nil
function CDOTAGamerules:SetUseUniversalShopMode(useUniversalShopMode)end

--Set Weather Wind Direction Vector.
--available:server
---@param arg1 Vector
---@return nil
function CDOTAGamerules:SetWeatherWindDirection(arg1)end

--Item whitelist functionality enable/disable.
--available:server
---@param whiteListEnabled bool
---@return nil
function CDOTAGamerules:SetWhiteListEnabled(whiteListEnabled)end

--Spawn and release the next creep wave from Dota lane style spawners.
--available:server
---@return nil
function CDOTAGamerules:SpawnAndReleaseCreeps()end

--Spawn and release the next set of neutral camps.
--available:server
---@return nil
function CDOTAGamerules:SpawnNeutralCreeps()end

--Get the current Gamerules state.
--available:both
---@return DOTA_GameState
function CDOTAGamerules:State_Get()end

