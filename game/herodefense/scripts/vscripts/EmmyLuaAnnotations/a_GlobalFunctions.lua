--Add temporary vision for a given team.
--available:server
---@param teamId DOTATeam_t
---@param location Vector
---@param radius float
---@param duration float
---@param obstructedVision bool
---@return ViewerID
function AddFOWViewer(teamId,location,radius,duration,obstructedVision)end

--Returns the number of degrees difference between two yaw angles.
--available:both
---@param arg1 float
---@param arg2 float
---@return float
function AngleDiff(arg1,arg2)end

--Generate a vector given a QAngles.
--available:both
---@param arg1 QAngle
---@return Vector
function AnglesToVector(arg1)end

--
--available:both
---@param arg1 string
---@param arg2 string
---@return nil
function AppendToLogFile(arg1,arg2)end

--Damage an npc.
--available:server
---@param options ApplyDamageOptions
---@return float
function ApplyDamage(options)end

--Constructs a quaternion representing a rotation by angle around the specified vector axis.
--available:both
---@param arg1 Vector
---@param arg2 float
---@return Quaternion
function AxisAngleToQuaternion(arg1,arg2)end

--Compute the closest point on the OBB of an entity.
--available:both
---@param arg1 handle
---@param arg2 Vector
---@return Vector
function CalcClosestPointOnEntityOBB(arg1,arg2)end

--Compute the distance between two entity OBB. A negative return value indicates an input error. A return value of zero indicates that the OBBs are overlapping.
--available:both
---@param arg1 handle
---@param arg2 handle
---@return float
function CalcDistanceBetweenEntityOBB(arg1,arg2)end

--
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 Vector
---@return float
function CalcDistanceToLineSegment2D(arg1,arg2,arg3)end

--Create all I/O events for a particular entity.
--available:both
---@param arg1 ehandle
---@return nil
function CancelEntityIOEvents(arg1)end

--Centers each players' camera on a unit.
--available:server
---@param playerId PlayerID
---@param unit CBaseEntity|nil
---@return nil
function CenterCameraOnUnit(playerId,unit)end

--
--available:server
---@param team DOTATeam_t
---@return nil
function ClearTeamCustomHealthbarColor(team)end

--Allocate a damageinfo object, used as an argument to TakeDamage(). Call DestroyDamageInfo( hInfo ) to free the object.
--available:server
---@param arg1 handle
---@param arg2 handle
---@param arg3 Vector
---@param arg4 Vector
---@param arg5 float
---@param arg6 int
---@return CTakeDamageInfo
function CreateDamageInfo(arg1,arg2,arg3,arg4,arg5,arg6)end

--Pass table - Inputs: entity, effect.
--available:both
---@param arg1 handle
---@return bool
function CreateEffect(arg1)end

--Creates a DOTA hero by its dota_npc_units.txt name and sets it as the given player's controlled hero.
--available:server
---@param heroName string
---@param player CDOTAPlayer
---@return CDOTA_BaseNPC_Hero
function CreateHeroForPlayer(heroName,player)end

--Create an HTTP request.
--available:both
---@param method string
---@param url string
---@return CScriptHTTPRequest
function CreateHTTPRequest(method,url)end

--Create an HTTP request.
--available:both
---@param method string
---@param url string
---@return CScriptHTTPRequest
function CreateHTTPRequestScriptVM(method,url)end

--Create illusions of the passed hero that belong to passed unit using passed modifier data.
--available:server
---@param owner CBaseEntity
---@param heroToCopy CDOTA_BaseNPC_Hero
---@param modifierKeys CreateIllusionsModifierKeys
---@param numIllusions int
---@param padding int
---@param scramblePosition bool
---@param findClearSpace bool
---@return CDOTA_BaseNPC_Hero[]
function CreateIllusions(owner,heroToCopy,modifierKeys,numIllusions,padding,scramblePosition,findClearSpace)end

--Create a DOTA item.
--available:server
---@param itemName string
---@param owner CDOTAPlayer|nil
---@param purchaser CDOTAPlayer|nil
---@return CDOTA_Item,nil
function CreateItem(itemName,owner,purchaser)end

--Create a physical item at a given location, can start in air (but doesn't clear a space).
--available:server
---@param location Vector
---@param item CDOTA_Item|nil
---@return CDOTA_Item_Physical
function CreateItemOnPositionForLaunch(location,item)end

--Create a physical item at a given location.
--available:server
---@param location Vector
---@param item CDOTA_Item|nil
---@return CDOTA_Item_Physical
function CreateItemOnPositionSync(location,item)end

--Create a modifier not associated with an NPC.
--available:server
---@param caster CDOTA_BaseNPC|nil
---@param ability CDOTABaseAbility|nil
---@param modifierName string
---@param paramTable table|nil
---@param origin Vector
---@param teamNumber DOTATeam_t
---@param phantomBlocker bool
---@return handle
function CreateModifierThinker(caster,ability,modifierName,paramTable,origin,teamNumber,phantomBlocker)end

--Create a rune of the specified type.
--available:server
---@param location Vector
---@param runeType DOTA_RUNES
---@return CBaseAnimating
function CreateRune(location,runeType)end

--Create a scene entity to play the specified scene.
--available:server
---@param arg1 string
---@return CSceneEntity
function CreateSceneEntity(arg1)end

--Create a temporary tree, uses a default tree model.
--available:server
---@param location Vector
---@param duration float
---@return CBaseAnimating
function CreateTempTree(location,duration)end

--Create a temporary tree, specifying the tree model name.
--available:server
---@param location Vector
---@param duration float
---@param modelName string
---@return CBaseAnimating
function CreateTempTreeWithModel(location,duration,modelName)end

--Creates and returns an AABB trigger.
--available:server
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 Vector
---@return CBaseTrigger
function CreateTrigger(arg1,arg2,arg3)end

--Creates and returns an AABB trigger thats bigger than the radius provided.
--available:server
---@param vecOrigin Vector
---@param radius float
---@return CBaseTrigger
function CreateTriggerRadiusApproximate(vecOrigin,radius)end

--Creates a separate random number stream.
--available:both
---@param seed int
---@return CScriptUniformRandomStream
function CreateUniformRandomStream(seed)end

--Creates a unit by its dota_npc_units.txt name.\nThe spawned unit will not be controllable by default. You can use unit.SetControllableByPlayer() to change this.\nWarning: mass synchronous unit spawning may be slow. Prefer CreateUnitByNameAsync unless synchronous access is required.
--available:server
---@param unitName string
---@param location Vector
---@param findClearSpace bool
---@param npcOwner CBaseEntity|nil
---@param entityOwner CBaseEntity|nil
---@param team DOTATeam_t
---@return CDOTA_BaseNPC
function CreateUnitByName(unitName,location,findClearSpace,npcOwner,entityOwner,team)end

--Creates a unit by its dota_npc_units.txt name.\nThe spawned unit will not be controllable by default. You can use unit.SetControllableByPlayer() to change this.
--available:server
---@param unitName string
---@param location Vector
---@param findClearSpace bool
---@param npcOwner CBaseEntity|nil
---@param entityOwner CBaseEntity|nil
---@param team DOTATeam_t
---@param callback function
---@return SpawnGroupHandle
function CreateUnitByNameAsync(unitName,location,findClearSpace,npcOwner,entityOwner,team,callback)end

--Creates a DOTA unit by its dota_npc_units.txt name from a table of entity key values and a position to spawn at.
--available:server
---@param arg1 handle
---@param arg2 Vector
---@return handle
function CreateUnitFromTable(arg1,arg2)end

--Cross product between two vectors.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@return Vector
function CrossVectors(arg1,arg2)end

--Gets the value of the given cvar, as a float.
--available:both
---@param arg1 string
---@return float
function cvar_getf(arg1)end

--Sets the value of the given cvar, as a float.
--available:both
---@param arg1 string
---@param arg2 float
---@return bool
function cvar_setf(arg1,arg2)end

--Breaks in the debugger.
--available:both
---@return nil
function DebugBreak()end

--Creates a test unit controllable by the specified player.
--available:server
---@param playerOwner CDOTAPlayer
---@param unitName string
---@param team DOTATeam_t
---@param arg4 bool
---@param callback function
---@return int
function DebugCreateUnit(playerOwner,unitName,team,arg4,callback)end

--Draw a debug overlay box.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 Vector
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 float
---@return nil
function DebugDrawBox(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Draw a debug forward box.
--available:both
---@param cent Vector
---@param min Vector
---@param max Vector
---@param forward Vector
---@param rgb Vector
---@param a float
---@param duration float
---@return nil
function DebugDrawBoxDirection(cent,min,max,forward,rgb,a,duration)end

--Draw a debug circle.
--available:both
---@param center Vector
---@param rgb Vector
---@param a float
---@param rad float
---@param ztest bool
---@param duration float
---@return nil
function DebugDrawCircle(center,rgb,a,rad,ztest,duration)end

--Try to clear all the debug overlay info.
--available:both
---@return nil
function DebugDrawClear()end

--Draw a debug overlay line.
--available:both
---@param origin Vector
---@param target Vector
---@param r int
---@param g int
---@param b int
---@param ztest bool
---@param duration float
---@return nil
function DebugDrawLine(origin,target,r,g,b,ztest,duration)end

--Draw a debug line using color vec.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 Vector
---@param arg4 bool
---@param arg5 float
---@return nil
function DebugDrawLine_vCol(arg1,arg2,arg3,arg4,arg5)end

--Draw text with a line offset.
--available:both
---@param x float
---@param y float
---@param lineOffset int
---@param text string
---@param r int
---@param g int
---@param b int
---@param a int
---@param duration float
---@return nil
function DebugDrawScreenTextLine(x,y,lineOffset,text,r,g,b,a,duration)end

--Draw a debug sphere.
--available:both
---@param center Vector
---@param rgb Vector
---@param a float
---@param rad float
---@param ztest bool
---@param duration float
---@return nil
function DebugDrawSphere(center,rgb,a,rad,ztest,duration)end

--Draw text in 3d.
--available:both
---@param origin Vector
---@param text string
---@param viewCheck bool
---@param duration float
---@return nil
function DebugDrawText(origin,text,viewCheck,duration)end

--Draw pretty debug text.
--available:both
---@param x float
---@param y float
---@param lineOffset int
---@param text string
---@param r int
---@param g int
---@param b int
---@param a int
---@param duration float
---@param font string
---@param size int
---@param bold bool
---@return nil
function DebugScreenTextPretty(x,y,lineOffset,text,r,g,b,a,duration,font,size,bold)end

--Print out a table (and subtables) to the console.
--available:both
---@param table table|nil
---@return nil
function DeepPrintTable(table)end

--Free a damageinfo object that was created with CreateDamageInfo().
--available:server
---@param damageInfo CTakeDamageInfo
---@return nil
function DestroyDamageInfo(damageInfo)end

--
--available:server
---@param attacker CDOTA_BaseNPC
---@param target CDOTA_BaseNPC
---@param ability CDOTABaseAbility|nil
---@param damage float
---@param startRadius float
---@param endRadius float
---@param distance float
---@param effectName string
---@return int
function DoCleaveAttack(attacker,target,ability,damage,startRadius,endRadius,distance,effectName)end

--Generate and entity i/o event.
--available:server
---@param arg1 string
---@param arg2 string
---@param arg3 string
---@param arg4 float
---@param arg5 handle
---@param arg6 handle
---@return nil
function DoEntFire(arg1,arg2,arg3,arg4,arg5,arg6)end

--Generate and entity i/o event.
--available:server
---@param arg1 handle
---@param arg2 string
---@param arg3 string
---@param arg4 float
---@param arg5 handle
---@param arg6 handle
---@return nil
function DoEntFireByInstanceHandle(arg1,arg2,arg3,arg4,arg5,arg6)end

--Execute a script (internal).
--available:both
---@param arg1 string
---@param arg2 handle
---@return bool
function DoIncludeScript(arg1,arg2)end

--Asserts the passed in value. Prints out a message and brings up the assert dialog.
--available:both
---@param arg1 bool
---@param arg2 string
---@return nil
function DoScriptAssert(arg1,arg2)end

--Spawn a .vmap at the target location.
--available:server
---@param mapName string
---@param location Vector
---@param deferCompletion bool
---@param onReadyToSpawn function
---@param onSpawnComplete function
---@param context table|nil
---@return SpawnGroupHandle
function DOTA_SpawnMapAtPosition(mapName,location,deferCompletion,onReadyToSpawn,onSpawnComplete,context)end

--
--available:server
---@param arg1 Vector
---@param arg2 Vector
---@return float
function DotProduct(arg1,arg2)end

--Generate a string guaranteed to be unique across the life of the script VM, with an optional root string. Useful for adding data to tables when not sure what keys are already in use in that table.
--available:both
---@param seed string
---@return string
function DoUniqueString(seed)end

--Drop a neutral item for the team of the hero at the given tier.
--available:server
---@param itemName string
---@param location Vector
---@param unit CDOTA_BaseNPC
---@param tier int
---@param arg5 bool
---@return CDOTA_Item_Physical
function DropNeutralItemAtPositionForHero(itemName,location,unit,tier,arg5)end

--A function to re-lookup a function by name every time.
--available:both
---@param context table
---@param name string
---@return unknown
function Dynamic_Wrap(context,name)end

--Emit an announcer sound for all players.
--available:server
---@param soundName string
---@return nil
function EmitAnnouncerSound(soundName)end

--Emit an announcer sound for a player.
--available:server
---@param soundName string
---@param playerId PlayerID
---@return nil
function EmitAnnouncerSoundForPlayer(soundName,playerId)end

--Emit an announcer sound for a team.
--available:server
---@param soundName string
---@param team DOTATeam_t
---@return nil
function EmitAnnouncerSoundForTeam(soundName,team)end

--Emit an announcer sound for a team at a specific location.
--available:server
---@param soundName string
---@param team DOTATeam_t
---@param location Vector
---@return nil
function EmitAnnouncerSoundForTeamOnLocation(soundName,team,location)end

--Play named sound for all players.
--available:server
---@param soundName string
---@return nil
function EmitGlobalSound(soundName)end

--Play named sound on Entity.
--available:both
---@param soundName string
---@param entity CBaseEntity
---@return nil
function EmitSoundOn(soundName,entity)end

--Play named sound only on the client for the passed in player.
--available:both
---@param soundName string
---@param arg2 handle
---@return nil
function EmitSoundOnClient(soundName,arg2)end

--Emit a sound on an entity for only a specific player.
--available:server
---@param arg1 string
---@param arg2 handle
---@param arg3 int
---@return nil
function EmitSoundOnEntityForPlayer(arg1,arg2,arg3)end

--Emit a sound on a location from a unit, only for players allied with that unit.
--available:server
---@param location Vector
---@param soundName string
---@param caster CBaseEntity
---@return nil
function EmitSoundOnLocationForAllies(location,soundName,caster)end

--Emit a sound on a location for only a specific player.
--available:server
---@param arg1 string
---@param arg2 Vector
---@param arg3 int
---@return nil
function EmitSoundOnLocationForPlayer(arg1,arg2,arg3)end

--Emit a sound on a location from a unit.
--available:server
---@param location Vector
---@param soundName string
---@param caster CDOTA_BaseNPC
---@return nil
function EmitSoundOnLocationWithCaster(location,soundName,caster)end

--Turn an entity index integer to an HScript representing that entity's script instance.
--available:both
---@param entityIndex EntityIndex
---@return CBaseEntity,nil
function EntIndexToHScript(entityIndex)end

--Issue an order from a script table.
--available:server
---@param order ExecuteOrderOptions
---@return nil
function ExecuteOrderFromTable(order)end

--Smooth curve decreasing slower as it approaches zero.
--available:both
---@param arg1 float
---@param arg2 float
---@param arg3 float
---@return float
function ExponentialDecay(arg1,arg2,arg3)end

--Finds a clear random position around a given target unit, using the target unit's padded collision radius.
--available:server
---@param arg1 handle
---@param arg2 handle
---@param arg3 int
---@return bool
function FindClearRandomPositionAroundUnit(arg1,arg2,arg3)end

--Place a unit somewhere not already occupied.
--available:server
---@param unit CDOTA_BaseNPC
---@param location Vector
---@param arg3 bool
---@return bool
function FindClearSpaceForUnit(unit,location,arg3)end

--Find a spawn point for the given team.
--available:server
---@param team DOTATeam_t
---@return CBaseEntity,nil
function FindSpawnEntityForTeam(team)end

--Find units that intersect the given line with the given flags.
--available:server
---@param team DOTATeam_t
---@param startPos Vector
---@param endPos Vector
---@param cacheUnit CBaseEntity|nil
---@param width float
---@param teamFilter DOTA_UNIT_TARGET_TEAM
---@param typeFilter DOTA_UNIT_TARGET_TYPE
---@param flagFilter DOTA_UNIT_TARGET_FLAGS
---@return CDOTA_BaseNPC[]
function FindUnitsInLine(team,startPos,endPos,cacheUnit,width,teamFilter,typeFilter,flagFilter)end

--Finds the units in a given radius with the given flags.
--available:server
---@param team DOTATeam_t
---@param location Vector
---@param cacheUnit CBaseEntity|nil
---@param radius float
---@param teamFilter DOTA_UNIT_TARGET_TEAM
---@param typeFilter DOTA_UNIT_TARGET_TYPE
---@param flagFilter DOTA_UNIT_TARGET_FLAGS
---@param order FindOrder
---@param canGrowCache bool
---@return CDOTA_BaseNPC[]
function FindUnitsInRadius(team,location,cacheUnit,radius,teamFilter,typeFilter,flagFilter,order,canGrowCache)end

--Fire Entity's Action Input w/no data.
--available:both
---@param arg1 ehandle
---@param arg2 string
---@return nil
function FireEntityIOInputNameOnly(arg1,arg2)end

--Fire Entity's Action Input with passed String - you own the memory.
--available:both
---@param arg1 ehandle
---@param arg2 string
---@param arg3 string
---@return nil
function FireEntityIOInputString(arg1,arg2,arg3)end

--Fire Entity's Action Input with passed Vector - you own the memory.
--available:both
---@param arg1 ehandle
---@param arg2 string
---@param arg3 Vector
---@return nil
function FireEntityIOInputVec(arg1,arg2,arg3)end

--Fire a game event.
--available:both
---@param eventName string
---@param eventData table
---@return nil
function FireGameEvent(eventName,eventData)end

--Fire a game event without broadcasting to the client.
--available:both
---@param eventName string
---@param eventData table
---@return nil
function FireGameEventLocal(eventName,eventData)end

--Get the time spent on the server in the last frame.
--available:both
---@return float
function FrameTime()end

--Gets the ability texture name for an ability.
--available:both
---@param abilityName string
---@return string
function GetAbilityTextureNameForAbility(abilityName)end

--Returns the currently active spawn group handle.
--available:both
---@return SpawnGroupHandle
function GetActiveSpawnGroupHandle()end

--
--available:server
---@param version string
---@return string
function GetDedicatedServerKey(version)end

--
--available:server
---@param version string
---@return string
function GetDedicatedServerKeyV2(version)end

--Get the enity index for a tree id specified as the entindex_target of a DOTA_UNIT_ORDER_CAST_TARGET_TREE.
--available:server
---@param treeId uint
---@return EntityIndex
function GetEntityIndexForTreeId(treeId)end

--Returns the engines current frame count.
--available:both
---@return int
function GetFrameCount()end

--
--available:server
---@param location Vector
---@param unitHull CDOTA_BaseNPC|nil
---@return float
function GetGroundHeight(location,unitHull)end

--Returns the supplied position moved to the ground. Second parameter is an NPC for measuring movement collision hull offset.
--available:server
---@param location Vector
---@param unitHull CDOTA_BaseNPC|nil
---@return Vector
function GetGroundPosition(location,unitHull)end

--Get the cost of an item by name.
--available:server
---@param arg1 string
---@return int
function GetItemCost(arg1)end

--
--available:server
---@param arg1 int
---@param arg2 int
---@return int
function GetItemDefOwnedCount(arg1,arg2)end

--
--available:server
---@param arg1 int
---@param arg2 int
---@return int
function GetItemDefQuantity(arg1,arg2)end

--Get the local player on a listen server.
--available:both
---@return CDOTAPlayer
function GetListenServerHost()end

--
--available:server
---@return table
function GetLobbyEventGameDetails()end

--Get the local player ID.
--available:client
---@return PlayerID
function GetLocalPlayerID()end

--Get the local player team.
--available:client
---@return DOTATeam_t
function GetLocalPlayerTeam()end

--Get the name of the map.
--available:both
---@return string
function GetMapName()end

--Get the longest delay for all events attached to an output.
--available:both
---@param arg1 ehandle
---@param arg2 string
---@return float
function GetMaxOutputDelay(arg1,arg2)end

--Get Angular Velocity for VPHYS or normal object. Returns a vector of the axis of rotation, multiplied by the degrees of rotation per second.
--available:both
---@param arg1 handle
---@return Vector
function GetPhysAngularVelocity(arg1)end

--Get Velocity for VPHYS or normal object.
--available:both
---@param arg1 handle
---@return Vector
function GetPhysVelocity(arg1)end

--Given the item tier and the team, roll for the name of a valid neutral item drop, considering previous drops and consumables.
--available:server
---@param tier int
---@param team DOTATeam_t
---@return string
function GetPotentialNeutralItemDrop(tier,team)end

--Get the current real world date.
--available:server
---@return string
function GetSystemDate()end

--Get the current real world time.
--available:server
---@return string
function GetSystemTime()end

--Get system time in milliseconds.
--available:server
---@return double
function GetSystemTimeMS()end

--
--available:server
---@param arg1 int
---@param arg2 int
---@param arg3 int
---@param arg4 Vector
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@return Vector
function GetTargetAOELocation(arg1,arg2,arg3,arg4,arg5,arg6,arg7)end

--
--available:server
---@param arg1 int
---@param arg2 int
---@param arg3 int
---@param arg4 Vector
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@return Vector
function GetTargetLinearLocation(arg1,arg2,arg3,arg4,arg5,arg6,arg7)end

--
--available:server
---@param team DOTATeam_t
---@return int
function GetTeamHeroKills(team)end

--
--available:server
---@param team DOTATeam_t
---@return string
function GetTeamName(team)end

--Given and entity index of a tree, get the tree id for use for use with with unit orders.
--available:server
---@param entityIndex EntityIndex
---@return int
function GetTreeIdForEntityIndex(entityIndex)end

--Gets the world's maximum X position.
--available:server
---@return float
function GetWorldMaxX()end

--Gets the world's maximum Y position.
--available:server
---@return float
function GetWorldMaxY()end

--Gets the world's minimum X position.
--available:server
---@return float
function GetWorldMinX()end

--Gets the world's minimum Y position.
--available:server
---@return float
function GetWorldMinY()end

--Get amount of XP required to reach the next level.
--available:server
---@param level int
---@return int
function GetXPNeededToReachNextLevel(level)end

--
--available:both
---@param arg1 string
---@param arg2 string
---@return nil
function InitLogFile(arg1,arg2)end

--Returns true if this is lua running from the client.dll.
--available:both
---@return bool
function IsClient()end

--Returns true if this server is a dedicated server.
--available:both
---@return bool
function IsDedicatedServer()end

--Returns true if this is lua running within tools mode.
--available:both
---@return bool
function IsInToolsMode()end

--Ask fog of war if a location is visible to a certain team.
--available:server
---@param team DOTATeam_t
---@param location Vector
---@return bool
function IsLocationVisible(team,location)end

--Is this entity a mango tree? (hEntity).
--available:server
---@param entity CBaseEntity
---@return bool
function IsMangoTree(entity)end

--Returns true if the entity is valid and marked for deletion.
--available:both
---@param entity CBaseEntity
---@return bool
function IsMarkedForDeletion(entity)end

--Returns true if this is lua running from the server.dll.
--available:both
---@return bool
function IsServer()end

--Returns true if the unit is in a valid position in the gridnav.
--available:server
---@param unit CBaseEntity
---@return bool
function IsUnitInValidPosition(unit)end

--Checks to see if the given hScript is a valid entity.
--available:both
---@param entity table|nil
---@return bool
function IsValidEntity(entity)end

--Lerp between two vectors by a float factor returning new vector.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 float
---@return Vector
function LerpVectors(arg1,arg2,arg3)end

--Set the limit on the pathfinding search space.
--available:server
---@param arg1 float
---@return nil
function LimitPathingSearchDepth(arg1)end

--Link a lua-defined modifier with the associated class.
--available:both
---@param className string
---@param filePath string
---@param luaModifierType LuaModifierType
---@return nil
function LinkLuaModifier(className,filePath,luaModifierType)end

--Register as a listener for a game event from script.
--available:both
---@param eventName string
---@param listener function
---@param context table|nil
---@return EventListenerID
function ListenToGameEvent(eventName,listener,context)end

--Creates a table from the specified keyvalues text file.
--available:both
---@param filePath string
---@return table
function LoadKeyValues(filePath)end

--Creates a table from the specified keyvalues string.
--available:both
---@param kvString string
---@return table
function LoadKeyValuesFromString(kvString)end

--Get the current local time.
--available:both
---@return LocalTime
function LocalTime()end

--Checks to see if the given hScript is a valid entity.
--available:both
---@param arg1 string
---@return int
function MakeStringToken(arg1)end

--Triggers the creation of entities in a manually-completed spawn group.
--available:both
---@param handle SpawnGroupHandle
---@return nil
function ManuallyTriggerSpawnGroupCompletion(handle)end

--Start a minimap event.
--available:server
---@param team DOTATeam_t
---@param entity CBaseEntity
---@param xCoord int
---@param yCoord int
---@param eventType DOTAMinimapEvent_t
---@param eventDuration int
---@return nil
function MinimapEvent(team,entity,xCoord,yCoord,eventType,eventDuration)end

--Print a message.
--available:both
---@param message string
---@return nil
function Msg(message)end

--Pause or unpause the game.
--available:server
---@param paused bool
---@return nil
function PauseGame(paused)end

--Get a script instance of a player by index.
--available:both
---@param entityIndex EntityIndex
---@return CDOTAPlayer,nil
function PlayerInstanceFromIndex(entityIndex)end

--Precache an entity from KeyValues in table.
--available:both
---@param arg1 string
---@param arg2 handle
---@param context CScriptPrecacheContext
---@return nil
function PrecacheEntityFromTable(arg1,arg2,context)end

--Precache a list of entity KeyValues tables.
--available:both
---@param arg1 handle
---@param context CScriptPrecacheContext
---@return nil
function PrecacheEntityListFromTable(arg1,context)end

--Asynchronously precaches a DOTA item by its dota_npc_items.txt name, provides a callback when it's finished.
--available:server
---@param itemName string
---@param callback function
---@return nil
function PrecacheItemByNameAsync(itemName,callback)end

--Precaches a DOTA item by its dota_npc_items.txt name.
--available:server
---@param itemName string
---@param context CScriptPrecacheContext
---@return nil
function PrecacheItemByNameSync(itemName,context)end

--Manually precache a single model.
--available:server
---@param modelName string
---@param context CScriptPrecacheContext
---@return nil
function PrecacheModel(modelName,context)end

--Manually precache a single resource.
--available:server
---@param arg1 string
---@param arg2 string
---@param context CScriptPrecacheContext
---@return nil
function PrecacheResource(arg1,arg2,context)end

--Asynchronously precaches a DOTA unit by its dota_npc_units.txt name, provides a callback when it's finished.
--available:server
---@param unitName string
---@param callback function
---@param playerId PlayerID|nil
---@return nil
function PrecacheUnitByNameAsync(unitName,callback,playerId)end

--Precaches a DOTA unit by its dota_npc_units.txt name.
--available:server
---@param unitName string
---@param context CScriptPrecacheContext
---@param playerId PlayerID|nil
---@return nil
function PrecacheUnitByNameSync(unitName,context,playerId)end

--Precaches a DOTA unit from a table of entity key values.
--available:server
---@param arg1 handle
---@param callback function
---@return nil
function PrecacheUnitFromTableAsync(arg1,callback)end

--Precaches a DOTA unit from a table of entity key values.
--available:server
---@param arg1 handle
---@param context CScriptPrecacheContext
---@return nil
function PrecacheUnitFromTableSync(arg1,context)end

--Print a console message with a linked console command.
--available:both
---@param message string
---@param tooltip string
---@return nil
function PrintLinkedConsoleMessage(message,tooltip)end

--Get a random float within a range.
--available:both
---@param min float
---@param max float
---@return float
function RandomFloat(min,max)end

--Get a random int within a range.
--available:both
---@param min int
---@param max int
---@return int
function RandomInt(min,max)end

--Get a random 2D vector of the given length.
--available:server
---@param length float
---@return Vector
function RandomVector(length)end

--Register a custom animation script to run when a model loads.
--available:server
---@param arg1 string
---@param arg2 string
---@return nil
function RegisterCustomAnimationScriptForModel(arg1,arg2)end

--Create a C proxy for a script-based spawn group filter.
--available:both
---@param arg1 string
---@return nil
function RegisterSpawnGroupFilterProxy(arg1)end

--Reloads the MotD file.
--available:both
---@return nil
function ReloadMOTD()end

--Remove temporary vision for a given team.
--available:server
---@param teamId DOTATeam_t
---@param viewerId ViewerID
---@return nil
function RemoveFOWViewer(teamId,viewerId)end

--Remove the C proxy for a script-based spawn group filter.
--available:both
---@param arg1 string
---@return nil
function RemoveSpawnGroupFilterProxy(arg1)end

--Check and fix units that have been assigned a position inside collision radius of other NPCs.
--available:server
---@param location Vector
---@param radius float
---@return nil
function ResolveNPCPositions(location,radius)end

--Rolls a number from 1 to 100 and returns true if the roll is less than or equal to the number specified.
--available:server
---@param successPercentage int
---@return bool
function RollPercentage(successPercentage)end

--
--available:server
---@param chance uint
---@param pseudoRandomId PseudoRandom
---@param unit CDOTA_BaseNPC
---@return bool
function RollPseudoRandomPercentage(chance,pseudoRandomId,unit)end

--Rotate a QAngle by another QAngle.
--available:both
---@param arg1 QAngle
---@param arg2 QAngle
---@return QAngle
function RotateOrientation(arg1,arg2)end

--Rotate a Vector around a point.
--available:both
---@param arg1 Vector
---@param arg2 QAngle
---@param arg3 Vector
---@return Vector
function RotatePosition(arg1,arg2,arg3)end

--Rotates a quaternion by the specified angle around the specified vector axis.
--available:both
---@param arg1 Quaternion
---@param arg2 Vector
---@param arg3 float
---@return Quaternion
function RotateQuaternionByAxisAngle(arg1,arg2,arg3)end

--Find the delta between two QAngles.
--available:both
---@param arg1 QAngle
---@param arg2 QAngle
---@return QAngle
function RotationDelta(arg1,arg2)end

--Converts delta QAngle to an angular velocity Vector.
--available:both
---@param arg1 QAngle
---@param arg2 QAngle
---@return Vector
function RotationDeltaAsAngularVelocity(arg1,arg2)end

--Add a rule to the decision database.
--available:both
---@param arg1 handle
---@return bool
function rr_AddDecisionRule(arg1)end

--Commit the result of QueryBestResponse back to the given entity to play. Call with params.
--available:both
---@param entity handle
---@param airesponse handle
---@return bool
function rr_CommitAIResponse(entity,airesponse)end

--Retrieve a table of all available expresser targets, in the form { name : handle, name: handle }.
--available:both
---@return handle
function rr_GetResponseTargets()end

--Params: (entity, query) : tests 'query' against entity's response system and returns the best response found (or null if none found).
--available:both
---@param arg1 handle
---@param arg2 handle
---@param arg3 handle
---@return bool
function rr_QueryBestResponse(arg1,arg2,arg3)end

--Have Entity say string, and teamOnly or not.
--available:server
---@param entity CBaseEntity|nil
---@param message string
---@param teamOnly bool
---@return nil
function Say(entity,message,teamOnly)end

--Start a screenshake.
--available:both
---@param center Vector
---@param amplitude float
---@param frequency float
---@param duration float
---@param radius float
---@param command number|number
---@param airShake bool
---@return nil
function ScreenShake(center,amplitude,frequency,duration,radius,command,airShake)end

--
--available:server
---@param sendToPlayer CDOTAPlayer|nil
---@param messageType DOTA_OVERHEAD_ALERT
---@param targetEntity CDOTA_BaseNPC
---@param value int
---@param sourcePlayer CDOTAPlayer|nil
---@return nil
function SendOverheadEventMessage(sendToPlayer,messageType,targetEntity,value,sourcePlayer)end

--Send a string to the console as a client command.
--available:both
---@param arg1 string
---@return nil
function SendToConsole(arg1)end

--Send a string to the console as a server command.
--available:server
---@param arg1 string
---@return nil
function SendToServerConsole(arg1)end

--Sets an opvar value for all players.
--available:both
---@param arg1 string
---@param arg2 string
---@param arg3 string
---@param arg4 float
---@return nil
function SetOpvarFloatAll(arg1,arg2,arg3,arg4)end

--Sets an opvar value for a single player.
--available:both
---@param arg1 string
---@param arg2 string
---@param arg3 string
---@param arg4 float
---@param arg5 handle
---@return nil
function SetOpvarFloatPlayer(arg1,arg2,arg3,arg4,arg5)end

--Set Angular Velocity for VPHYS or normal object, from a vector of the axis of rotation, multiplied by the degrees of rotation per second.
--available:both
---@param arg1 handle
---@param arg2 Vector
---@return nil
function SetPhysAngularVelocity(arg1,arg2)end

--Set the current quest name.
--available:both
---@param arg1 string
---@return nil
function SetQuestName(arg1)end

--Set the current quest phase.
--available:both
---@param arg1 int
---@return nil
function SetQuestPhase(arg1)end

--Set rendering on/off for an ehandle.
--available:both
---@param arg1 ehandle
---@param arg2 bool
---@return nil
function SetRenderingEnabled(arg1,arg2)end

--
--available:server
---@param team DOTATeam_t
---@param r int
---@param g int
---@param b int
---@return nil
function SetTeamCustomHealthbarColor(team,r,g,b)end

--Supports localized strings - %s1 = PlayerName, %s2 = Value, %s3 = TeamName.
--available:server
---@param message string
---@param playerId PlayerID
---@param value int
---@param time float
---@return nil
function ShowCustomHeaderMessage(message,playerId,value,time)end

--Show a generic popup dialog for all players.
--available:server
---@param arg1 string
---@param arg2 string
---@param arg3 string
---@param arg4 string
---@param arg5 int
---@return nil
function ShowGenericPopup(arg1,arg2,arg3,arg4,arg5)end

--Show a generic popup dialog to a specific player.
--available:server
---@param arg1 handle
---@param arg2 string
---@param arg3 string
---@param arg4 string
---@param arg5 string
---@param arg6 int
---@return nil
function ShowGenericPopupToPlayer(arg1,arg2,arg3,arg4,arg5,arg6)end

--Print a hud message on all clients.
--available:server
---@param arg1 string
---@return nil
function ShowMessage(arg1)end

--
--available:server
---@param origin Vector
---@param radius float
---@return CDOTA_ShopTrigger
function SpawnDOTAShopTriggerRadiusApproximate(origin,radius)end

--Asynchronously spawns a single entity from a table.
--available:both
---@param arg1 string
---@param arg2 handle
---@param arg3 handle
---@param arg4 handle
---@return nil
function SpawnEntityFromTableAsynchronous(arg1,arg2,arg3,arg4)end

--Synchronously spawns a single entity from a table.
--available:both
---@param baseclass string
---@param data table
---@return CBaseEntity
function SpawnEntityFromTableSynchronous(baseclass,data)end

--Hierarchically spawn an entity group from a set of spawn tables.
--available:both
---@param arg1 handle
---@param arg2 bool
---@param arg3 handle
---@return bool
function SpawnEntityGroupFromTable(arg1,arg2,arg3)end

--Asynchronously spawn an entity group from a list of spawn tables. A callback will be triggered when the spawning is complete.
--available:both
---@param arg1 handle
---@param arg2 handle
---@return int
function SpawnEntityListFromTableAsynchronous(arg1,arg2)end

--Synchronously spawn an entity group from a list of spawn tables.
--available:both
---@param arg1 handle
---@return handle
function SpawnEntityListFromTableSynchronous(arg1)end

--Very basic interpolation of v0 to v1 over t on [0,1].
--available:both
---@param arg1 Quaternion
---@param arg2 Quaternion
---@param arg3 float
---@return Quaternion
function SplineQuaternions(arg1,arg2,arg3)end

--Very basic interpolation of v0 to v1 over t on [0,1].
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 float
---@return Vector
function SplineVectors(arg1,arg2,arg3)end

--Start a sound event.
--available:both
---@param arg1 string
---@param arg2 handle
---@return nil
function StartSoundEvent(arg1,arg2)end

--Start a sound event from position.
--available:both
---@param soundName string
---@param position Vector
---@return nil
function StartSoundEventFromPosition(soundName,position)end

--Start a sound event from position with reliable delivery.
--available:both
---@param soundName string
---@param position Vector
---@return nil
function StartSoundEventFromPositionReliable(soundName,position)end

--Start a sound event from position with optional delivery.
--available:both
---@param soundName string
---@param position Vector
---@return nil
function StartSoundEventFromPositionUnreliable(soundName,position)end

--Start a sound event with reliable delivery.
--available:both
---@param arg1 string
---@param arg2 handle
---@return nil
function StartSoundEventReliable(arg1,arg2)end

--Start a sound event with optional delivery.
--available:both
---@param arg1 string
---@param arg2 handle
---@return nil
function StartSoundEventUnreliable(arg1,arg2)end

--Pass entity and effect name.
--available:both
---@param arg1 handle
---@param arg2 string
---@return nil
function StopEffect(arg1,arg2)end

--Stop named sound for all players.
--available:server
---@param arg1 string
---@return nil
function StopGlobalSound(arg1)end

--Stop listening to all game events within a specific context.
--available:both
---@param arg1 handle
---@return nil
function StopListeningToAllGameEvents(arg1)end

--Stop listening to a particular game event.
--available:both
---@param listenerId EventListenerID
---@return bool
function StopListeningToGameEvent(listenerId)end

--Stops a sound event with optional delivery.
--available:both
---@param arg1 string
---@param arg2 handle
---@return nil
function StopSoundEvent(arg1,arg2)end

--Stop named sound on Entity.
--available:both
---@param arg1 string
---@param arg2 handle
---@return nil
function StopSoundOn(arg1,arg2)end

--Get the current server time.
--available:both
---@return float
function Time()end

--
--available:both
---@param query TraceCollideableInputs
---@return bool
function TraceCollideable(query)end

--
--available:both
---@param query TraceHullInputs
---@return bool
function TraceHull(query)end

--
--available:both
---@param query TraceLineInputs
---@return bool
function TraceLine(query)end

--Check if a unit passes a set of filters.
--available:both
---@param npc CDOTA_BaseNPC
---@param teamFilter DOTA_UNIT_TARGET_TEAM
---@param typeFilter DOTA_UNIT_TARGET_TYPE
---@param flagFilter DOTA_UNIT_TARGET_FLAGS
---@param team DOTATeam_t
---@return UnitFilterResult
function UnitFilter(npc,teamFilter,typeFilter,flagFilter,team)end

--Unload a spawn group by name.
--available:both
---@param arg1 string
---@return nil
function UnloadSpawnGroup(arg1)end

--Unload a spawn group by handle.
--available:both
---@param handle SpawnGroupHandle
---@return nil
function UnloadSpawnGroupByHandle(handle)end

--
--available:server
---@param eventPointData handle
---@return nil
function UpdateEventPoints(eventPointData)end

--Returns the number of degrees difference between two yaw angles.
--available:server
---@param arg1 float
---@param arg2 float
---@return float
function UTIL_AngleDiff(arg1,arg2)end

--Sends colored text to one client.
--available:server
---@param arg1 int
---@param arg2 string
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@return nil
function UTIL_MessageText(arg1,arg2,arg3,arg4,arg5,arg6)end

--Sends colored text to one client. (Valid context keys: player_id, value, team_id).
--available:server
---@param arg1 int
---@param arg2 string
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 handle
---@return nil
function UTIL_MessageText_WithContext(arg1,arg2,arg3,arg4,arg5,arg6,arg7)end

--Sends colored text to all clients.
--available:server
---@param arg1 string
---@param arg2 int
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@return nil
function UTIL_MessageTextAll(arg1,arg2,arg3,arg4,arg5)end

--Sends colored text to all clients. (Valid context keys: player_id, value, team_id).
--available:server
---@param arg1 string
---@param arg2 int
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 handle
---@return nil
function UTIL_MessageTextAll_WithContext(arg1,arg2,arg3,arg4,arg5,arg6)end

--Removes the specified entity.
--available:both
---@param entity CBaseEntity|nil
---@return nil
function UTIL_Remove(entity)end

--Immediately removes the specified entity.
--available:both
---@param entity CBaseEntity|nil
---@return nil
function UTIL_RemoveImmediate(entity)end

--Clear all message text on one client.
--available:server
---@param arg1 int
---@return nil
function UTIL_ResetMessageText(arg1)end

--Clear all message text from all clients.
--available:server
---@return nil
function UTIL_ResetMessageTextAll()end

--
--available:server
---@param arg1 Vector
---@return QAngle
function VectorAngles(arg1)end

--Get Qangles (with no roll) for a Vector.
--available:both
---@param arg1 Vector
---@return QAngle
function VectorToAngles(arg1)end

--Print a warning.
--available:both
---@param message string
---@return nil
function Warning(message)end

