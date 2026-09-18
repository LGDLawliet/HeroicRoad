---@class CDOTA_BaseNPC_Building : CDOTA_BaseNPC
CDOTA_BaseNPC_Building = 
{
}
--Get the invulnerability count for a building.
--available:server
---@return int
function CDOTA_BaseNPC_Building:GetInvulnCount()end

--Set the invulnerability counter of this building.
--available:server
---@param invulnCount int
---@return nil
function CDOTA_BaseNPC_Building:SetInvulnCount(invulnCount)end

