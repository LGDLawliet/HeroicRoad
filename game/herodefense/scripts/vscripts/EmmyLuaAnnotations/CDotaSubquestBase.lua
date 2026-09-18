---@class CDotaSubquestBase : CBaseEntity
CDotaSubquestBase = 
{
}
--Mark this subquest complete.
--available:server
---@return nil
function CDotaSubquestBase:CompleteSubquest()end

--Set the text replace string for this subquest.
--available:server
---@param string string
---@return nil
function CDotaSubquestBase:SetTextReplaceString(string)end

--Set a subquest value.
--available:server
---@param valueSlot int
---@param value int
---@return nil
function CDotaSubquestBase:SetTextReplaceValue(valueSlot,value)end

