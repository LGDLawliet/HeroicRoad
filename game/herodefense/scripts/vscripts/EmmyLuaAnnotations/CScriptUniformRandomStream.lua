---@class CScriptUniformRandomStream
CScriptUniformRandomStream = 
{
}
--
--available:both
---@param minVal float
---@param maxVal float
---@return float
function CScriptUniformRandomStream:RandomFloat(minVal,maxVal)end

--
--available:both
---@param minVal float
---@param maxVal float
---@param exponent float
---@return float
function CScriptUniformRandomStream:RandomFloatExp(minVal,maxVal,exponent)end

--
--available:both
---@param minVal int
---@param maxVal int
---@return int
function CScriptUniformRandomStream:RandomInt(minVal,maxVal)end

--
--available:both
---@param percentage int
---@return bool
function CScriptUniformRandomStream:RollPercentage(percentage)end

