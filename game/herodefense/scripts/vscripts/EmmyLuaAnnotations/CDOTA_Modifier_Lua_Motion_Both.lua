---@class CDOTA_Modifier_Lua_Motion_Both : CDOTA_Modifier_Lua
CDOTA_Modifier_Lua_Motion_Both = 
{
}
--Starts the horizontal motion controller effects for this buff.  Returns true if successful.
--available:server
---@return bool
function CDOTA_Modifier_Lua_Motion_Both:ApplyHorizontalMotionController()end

--Starts the vertical motion controller effects for this buff.  Returns true if successful.
--available:server
---@return bool
function CDOTA_Modifier_Lua_Motion_Both:ApplyVerticalMotionController()end

--Get the priority.
--available:server
---@return modifierpriority
function CDOTA_Modifier_Lua_Motion_Both:GetPriority()end

--Called when the motion gets interrupted.
--available:both
---@return nil
function CDOTA_Modifier_Lua_Motion_Both:OnHorizontalMotionInterrupted()end

--Called when the motion gets interrupted.
--available:both
---@return nil
function CDOTA_Modifier_Lua_Motion_Both:OnVerticalMotionInterrupted()end

--Set the priority.
--available:server
---@param motionPriority modifierpriority
---@return nil
function CDOTA_Modifier_Lua_Motion_Both:SetPriority(motionPriority)end

--Perform any motion from the given interval on the NPC.
--available:both
---@param me CDOTA_BaseNPC
---@param dt float
---@return nil
function CDOTA_Modifier_Lua_Motion_Both:UpdateHorizontalMotion(me,dt)end

--Perform any motion from the given interval on the NPC.
--available:both
---@param me CDOTA_BaseNPC
---@param dt float
---@return nil
function CDOTA_Modifier_Lua_Motion_Both:UpdateVerticalMotion(me,dt)end

