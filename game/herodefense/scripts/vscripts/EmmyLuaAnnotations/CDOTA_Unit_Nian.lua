---@class CDOTA_Unit_Nian : CDOTA_BaseNPC_Creature
CDOTA_Unit_Nian = 
{
}
--Is the Nian horn?
--available:server
---@return handle
function CDOTA_Unit_Nian:GetHorn()end

--Is the Nian's tail broken?
--available:server
---@return handle
function CDOTA_Unit_Nian:GetTail()end

--Is the Nian's horn broken?
--available:server
---@return bool
function CDOTA_Unit_Nian:IsHornAlive()end

--Is the Nian's tail broken?
--available:server
---@return bool
function CDOTA_Unit_Nian:IsTailAlive()end

