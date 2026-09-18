---@class CDOTA_Unit_Diretide_Portal : CDOTA_BaseNPC_Building
CDOTA_Unit_Diretide_Portal = 
{
}
--
--available:server
---@return handle
function CDOTA_Unit_Diretide_Portal:GetPartnerPortal()end

--
--available:server
---@return nil
function CDOTA_Unit_Diretide_Portal:ResetPortal()end

--
--available:server
---@param runeType int
---@return nil
function CDOTA_Unit_Diretide_Portal:SetInvasionRuneType(runeType)end

--
--available:server
---@param portal handle
---@return nil
function CDOTA_Unit_Diretide_Portal:SetPartnerPortal(portal)end

--
--available:server
---@param active bool
---@return nil
function CDOTA_Unit_Diretide_Portal:SetPortalActive(active)end

