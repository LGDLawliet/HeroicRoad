---@class CCustomNetTableManager
CCustomNetTableManager = 
{
}
--
--available:both
---@param tableName string
---@param keyName string
---@return table
function CCustomNetTableManager:GetTableValue(tableName,keyName)end

--
--available:server
---@param tableName string
---@param keyName string
---@param value handle
---@return bool
function CCustomNetTableManager:SetTableValue(tableName,keyName,value)end

