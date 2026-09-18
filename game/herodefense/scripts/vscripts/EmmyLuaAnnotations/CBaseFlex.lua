---@class CBaseFlex : CBaseAnimating
CBaseFlex = 
{
}
--Returns the instance of the oldest active scene entity (if any).
--available:server
---@return CSceneEntity,nil
function CBaseFlex:GetCurrentScene()end

--Returns the instance of the scene entity at the specified index.
--available:server
---@param index int
---@return CSceneEntity,nil
function CBaseFlex:GetSceneByIndex(index)end

--Play specified vcd file.
--available:server
---@param scene string
---@param delay float
---@return float
function CBaseFlex:ScriptPlayScene(scene,delay)end

