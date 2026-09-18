---@class Convars
Convars = 
{
}
--Returns the convar as a boolean flag.
--available:both
---@param name string
---@return bool,nil
function Convars:GetBool(name)end

--Returns the player who issued this console command.
--available:both
---@return CDOTAPlayer
function Convars:GetCommandClient()end

--Returns the DOTA player who issued this console command.
--available:both
---@return CDOTAPlayer
function Convars:GetDOTACommandClient()end

--Returns the convar as a float. May return null if no such convar.
--available:both
---@param name string
---@return float,nil
function Convars:GetFloat(name)end

--Returns the convar as an int. May return null if no such convar.
--available:both
---@param name string
---@return int,nil
function Convars:GetInt(name)end

--Returns the convar as a string. May return null if no such convar.
--available:both
---@param name string
---@return string,nil
function Convars:GetStr(name)end

--Register a console command.
--available:both
---@param name string
---@param callback function
---@param helpString string
---@param flags ConVarFlags
---@return nil
function Convars:RegisterCommand(name,callback,helpString,flags)end

--Register a new console variable.
--available:both
---@param name string
---@param defaultValue string
---@param helpString string
---@param flags ConVarFlags
---@return nil
function Convars:RegisterConvar(name,defaultValue,helpString,flags)end

--Sets the value of the convar to the bool.
--available:both
---@param name string
---@param value bool
---@return nil
function Convars:SetBool(name,value)end

--Sets the value of the convar to the float.
--available:both
---@param name string
---@param value float
---@return nil
function Convars:SetFloat(name,value)end

--Sets the value of the convar to the int.
--available:both
---@param name string
---@param value int
---@return nil
function Convars:SetInt(name,value)end

--Sets the value of the convar to the string.
--available:both
---@param name string
---@param value string
---@return nil
function Convars:SetStr(name,value)end

