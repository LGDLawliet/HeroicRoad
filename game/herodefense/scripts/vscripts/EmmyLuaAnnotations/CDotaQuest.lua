---@class CDotaQuest : CBaseEntity
CDotaQuest = 
{
}
--Add a subquest to this quest.
--available:server
---@param subquest handle
---@return nil
function CDotaQuest:AddSubquest(subquest)end

--Mark this quest complete.
--available:server
---@return nil
function CDotaQuest:CompleteQuest()end

--Finds a subquest from this quest by index.
--available:server
---@param index int
---@return handle
function CDotaQuest:GetSubquest(index)end

--Finds a subquest from this quest by name.
--available:server
---@param name string
---@return handle
function CDotaQuest:GetSubquestByName(name)end

--Remove a subquest from this quest.
--available:server
---@param subquest handle
---@return nil
function CDotaQuest:RemoveSubquest(subquest)end

--Set the text replace string for this quest.
--available:server
---@param string string
---@return nil
function CDotaQuest:SetTextReplaceString(string)end

--Set a quest value.
--available:server
---@param valueSlot int
---@param value int
---@return nil
function CDotaQuest:SetTextReplaceValue(valueSlot,value)end

