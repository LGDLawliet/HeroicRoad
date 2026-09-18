---@class CDOTA_Modifier_Lua_Vertical_Motion : CDOTA_Modifier_Lua
CDOTA_Modifier_Lua_Vertical_Motion = 
{
}
--Starts the vertical motion controller effects for this buff.  Returns true if successful.
--available:server
---@return bool
function CDOTA_Modifier_Lua_Vertical_Motion:ApplyVerticalMotionController()end

--Get the priority.
--available:server
---@return modifierpriority
function CDOTA_Modifier_Lua_Vertical_Motion:GetMotionPriority()end

--Called when the motion gets interrupted.
--available:both
---@return nil
function CDOTA_Modifier_Lua_Vertical_Motion:OnVerticalMotionInterrupted()end

--Set the priority.
--available:server
---@param motionPriority modifierpriority
---@return nil
function CDOTA_Modifier_Lua_Vertical_Motion:SetMotionPriority(motionPriority)end

--Perform any motion from the given interval on the NPC.
--available:both
---@param me CDOTA_BaseNPC
---@param dt float
---@return nil
function CDOTA_Modifier_Lua_Vertical_Motion:UpdateVerticalMotion(me,dt)end

