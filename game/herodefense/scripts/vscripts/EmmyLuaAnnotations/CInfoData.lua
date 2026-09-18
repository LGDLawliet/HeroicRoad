---@class CInfoData : CBaseEntity
CInfoData = 
{
}
--Query color data for this key.
--available:server
---@param tok string
---@param default Vector
---@return Vector
function CInfoData:QueryColor(tok,default)end

--Query float data for this key.
--available:server
---@param tok string
---@param default float
---@return float
function CInfoData:QueryFloat(tok,default)end

--Query int data for this key.
--available:server
---@param tok string
---@param default int
---@return int
function CInfoData:QueryInt(tok,default)end

--Query number data for this key.
--available:server
---@param tok string
---@param default float
---@return float
function CInfoData:QueryNumber(tok,default)end

--Query string data for this key.
--available:server
---@param tok string
---@param default string
---@return string
function CInfoData:QueryString(tok,default)end

--Query vector data for this key.
--available:server
---@param tok string
---@param default Vector
---@return Vector
function CInfoData:QueryVector(tok,default)end

