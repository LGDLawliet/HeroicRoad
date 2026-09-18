---@class CDOTA_BaseNPC_Shop : CDOTA_BaseNPC_Building
CDOTA_BaseNPC_Shop = 
{
}
--Get the DOTA_SHOP_TYPE.
--available:server
---@return DOTA_SHOP_TYPE
function CDOTA_BaseNPC_Shop:GetShopType()end

--Set the DOTA_SHOP_TYPE.
--available:server
---@param shopType DOTA_SHOP_TYPE
---@return nil
function CDOTA_BaseNPC_Shop:SetShopType(shopType)end

