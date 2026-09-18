---@class CScriptPrecacheContext
CScriptPrecacheContext = 
{
}
--Precaches a specific resource.
--available:both
---@param resource string
---@return nil
function CScriptPrecacheContext:AddResource(resource)end

--Reads a spawn key.
--available:both
---@param key string
---@return table
function CScriptPrecacheContext:GetValue(key)end

