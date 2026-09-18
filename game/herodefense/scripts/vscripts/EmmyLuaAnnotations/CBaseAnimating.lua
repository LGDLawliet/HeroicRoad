---@class CBaseAnimating : CBaseModelEntity
CBaseAnimating = 
{
}
--Returns the duration in seconds of the active sequence.
--available:server
---@return float
function CBaseAnimating:ActiveSequenceDuration()end

--Get the cycle of the animation.
--available:server
---@return float
function CBaseAnimating:GetCycle()end

--Get the value of the given animGraph parameter.
--available:server
---@param param string
---@return table
function CBaseAnimating:GetGraphParameter(param)end

--Returns the name of the active sequence.
--available:server
---@return string
function CBaseAnimating:GetSequence()end

--Ask whether the main sequence is done playing.
--available:server
---@return bool
function CBaseAnimating:IsSequenceFinished()end

--Sets the active sequence by name, resetting the current cycle.
--available:server
---@param sequenceName string
---@return nil
function CBaseAnimating:ResetSequence(sequenceName)end

--Returns the duration in seconds of the given sequence name.
--available:server
---@param sequenceName string
---@return float
function CBaseAnimating:SequenceDuration(sequenceName)end

--Set the cycle of the animation.
--available:server
---@param cycle float
---@return nil
function CBaseAnimating:SetCycle(cycle)end

--Pass the desired look target in world space to the graph.
--available:server
---@param value Vector
---@return nil
function CBaseAnimating:SetGraphLookTarget(value)end

--Set the specific param value, type is inferred from the type in script.
--available:server
---@param param string
---@param svArg table
---@return nil
function CBaseAnimating:SetGraphParameter(param,svArg)end

--Set the specific param on or off.
--available:server
---@param name string
---@param value bool
---@return nil
function CBaseAnimating:SetGraphParameterBool(name,value)end

--Pass the enum (int) value to the specified param.
--available:server
---@param name string
---@param value int
---@return nil
function CBaseAnimating:SetGraphParameterEnum(name,value)end

--Pass the float value to the specified param.
--available:server
---@param name string
---@param value float
---@return nil
function CBaseAnimating:SetGraphParameterFloat(name,value)end

--Pass the int value to the specified param.
--available:server
---@param name string
---@param value int
---@return nil
function CBaseAnimating:SetGraphParameterInt(name,value)end

--Pass the vector value to the specified param in the graph.
--available:server
---@param name string
---@param value Vector
---@return nil
function CBaseAnimating:SetGraphParameterVector(name,value)end

--Set the specified pose parameter to the specified value.
--available:server
---@param name string
---@param value float
---@return float
function CBaseAnimating:SetPoseParameter(name,value)end

--Sets the active sequence by name, keeping the current cycle.
--available:server
---@param sequenceName string
---@return nil
function CBaseAnimating:SetSequence(sequenceName)end

--Stop the current animation by setting playback rate to 0.0.
--available:server
---@return nil
function CBaseAnimating:StopAnimation()end

