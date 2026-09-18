---@class CSceneEntity : CBaseEntity
CSceneEntity = 
{
}
--Adds a team (by index) to the broadcast list.
--available:server
---@param arg1 int
---@return nil
function CSceneEntity:AddBroadcastTeamTarget(arg1)end

--Cancel scene playback.
--available:server
---@return nil
function CSceneEntity:Cancel()end

--Returns length of this scene in seconds.
--available:server
---@return float
function CSceneEntity:EstimateLength()end

--Get the camera.
--available:server
---@return handle
function CSceneEntity:FindCamera()end

--Given an entity reference, such as !target, get actual entity from scene object.
--available:server
---@param arg1 string
---@return handle
function CSceneEntity:FindNamedEntity(arg1)end

--If this scene is currently paused.
--available:server
---@return bool
function CSceneEntity:IsPaused()end

--If this scene is currently playing.
--available:server
---@return bool
function CSceneEntity:IsPlayingBack()end

--Given a dummy scene name and a vcd string, load the scene.
--available:server
---@param arg1 string
---@param arg2 string
---@return bool
function CSceneEntity:LoadSceneFromString(arg1,arg2)end

--Removes a team (by index) from the broadcast list.
--available:server
---@param arg1 int
---@return nil
function CSceneEntity:RemoveBroadcastTeamTarget(arg1)end

--Start scene playback, takes activatorEntity as param.
--available:server
---@param arg1 handle
---@return nil
function CSceneEntity:Start(arg1)end

