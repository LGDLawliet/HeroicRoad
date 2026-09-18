---@class CDOTA_Item_Physical : CBaseAnimating
CDOTA_Item_Physical = 
{
}
--Returned the contained item.
--available:server
---@return CDOTA_Item
function CDOTA_Item_Physical:GetContainedItem()end

--Returns the game time when this item was created in the world.
--available:server
---@return float
function CDOTA_Item_Physical:GetCreationTime()end

--Set the contained item.
--available:server
---@param item CDOTA_Item
---@return nil
function CDOTA_Item_Physical:SetContainedItem(item)end

