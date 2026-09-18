---@class CDOTA_Item : CDOTABaseAbility
CDOTA_Item = 
{
}
--
--available:server
---@return bool
function CDOTA_Item:CanBeUsedOutOfInventory()end

--
--available:client
---@return bool
function CDOTA_Item:CanOnlyPlayerHeroPickup()end

--Get the container for this item.
--available:server
---@return CDOTA_Item_Physical,nil
function CDOTA_Item:GetContainer()end

--
--available:server
---@return int
function CDOTA_Item:GetCost()end

--Get the number of charges this item currently has.
--available:both
---@return int
function CDOTA_Item:GetCurrentCharges()end

--Get the initial number of charges this item has.
--available:both
---@return int
function CDOTA_Item:GetInitialCharges()end

--
--available:both
---@return number,DOTAScriptInventorySlot_t
function CDOTA_Item:GetItemSlot()end

--Gets whether item is unequipped or ready.
--available:server
---@return int
function CDOTA_Item:GetItemState()end

--Get the parent for this item.
--available:server
---@return handle
function CDOTA_Item:GetParent()end

--Get the purchaser for this item.
--available:server
---@return CDOTA_BaseNPC,nil
function CDOTA_Item:GetPurchaser()end

--Get the purchase time of this item.
--available:server
---@return float
function CDOTA_Item:GetPurchaseTime()end

--Get the number of secondary charges this item currently has.
--available:both
---@return int
function CDOTA_Item:GetSecondaryCharges()end

--
--available:both
---@return EShareAbility
function CDOTA_Item:GetShareability()end

--
--available:both
---@return bool
function CDOTA_Item:IsAlertableItem()end

--
--available:both
---@return bool
function CDOTA_Item:IsCastOnPickup()end

--
--available:server
---@return bool
function CDOTA_Item:IsCombinable()end

--
--available:both
---@return bool
function CDOTA_Item:IsDisassemblable()end

--
--available:both
---@return bool
function CDOTA_Item:IsDroppable()end

--
--available:both
---@return bool
function CDOTA_Item:IsInBackpack()end

--
--available:both
---@return bool
function CDOTA_Item:IsItem()end

--
--available:both
---@return bool
function CDOTA_Item:IsKillable()end

--
--available:both
---@return bool
function CDOTA_Item:IsMuted()end

--
--available:server
---@return bool
function CDOTA_Item:IsNeutralDrop()end

--
--available:both
---@return bool
function CDOTA_Item:IsPermanent()end

--
--available:both
---@return bool
function CDOTA_Item:IsPurchasable()end

--
--available:both
---@return bool
function CDOTA_Item:IsRecipe()end

--
--available:both
---@return bool
function CDOTA_Item:IsRecipeGenerated()end

--
--available:both
---@return bool
function CDOTA_Item:IsSellable()end

--
--available:both
---@return bool
function CDOTA_Item:IsStackable()end

--
--available:server
---@param autoUse bool
---@param height float
---@param duration float
---@param endPoint Vector
---@return nil
function CDOTA_Item:LaunchLoot(autoUse,height,duration,endPoint)end

--
--available:server
---@param autoUse bool
---@param initialHeight float
---@param launchHeight float
---@param duration float
---@param endPoint Vector
---@return nil
function CDOTA_Item:LaunchLootInitialHeight(autoUse,initialHeight,launchHeight,duration,endPoint)end

--
--available:server
---@param autoUse bool
---@param requiredHeight float
---@param height float
---@param duration float
---@param endPoint Vector
---@return nil
function CDOTA_Item:LaunchLootRequiredHeight(autoUse,requiredHeight,height,duration,endPoint)end

--
--available:server
---@return nil
function CDOTA_Item:OnEquip()end

--
--available:server
---@return nil
function CDOTA_Item:OnUnequip()end

--
--available:both
---@return bool
function CDOTA_Item:RequiresCharges()end

--
--available:server
---@param value bool
---@return nil
function CDOTA_Item:SetCanBeUsedOutOfInventory(value)end

--
--available:server
---@param castOnPickUp bool
---@return nil
function CDOTA_Item:SetCastOnPickup(castOnPickUp)end

--Set the number of charges on this item.
--available:server
---@param charges int
---@return nil
function CDOTA_Item:SetCurrentCharges(charges)end

--
--available:server
---@param droppable bool
---@return nil
function CDOTA_Item:SetDroppable(droppable)end

--Sets whether item is unequipped or ready.
--available:server
---@param state int
---@return nil
function CDOTA_Item:SetItemState(state)end

--
--available:server
---@param onlyPlayerHero bool
---@return nil
function CDOTA_Item:SetOnlyPlayerHeroPickup(onlyPlayerHero)end

--Set the purchaser of record for this item.
--available:server
---@param purchaser CDOTA_BaseNPC|nil
---@return nil
function CDOTA_Item:SetPurchaser(purchaser)end

--Set the purchase time of this item.
--available:server
---@param time float
---@return nil
function CDOTA_Item:SetPurchaseTime(time)end

--Set the number of secondary charges on this item.
--available:server
---@param charges int
---@return nil
function CDOTA_Item:SetSecondaryCharges(charges)end

--
--available:server
---@param sellable bool
---@return nil
function CDOTA_Item:SetSellable(sellable)end

--
--available:server
---@param shareability EShareAbility
---@return nil
function CDOTA_Item:SetShareability(shareability)end

--
--available:server
---@param stacksWithOtherOwners bool
---@return nil
function CDOTA_Item:SetStacksWithOtherOwners(stacksWithOtherOwners)end

--
--available:server
---@return nil
function CDOTA_Item:SpendCharge()end

--
--available:server
---@return bool
function CDOTA_Item:StacksWithOtherOwners()end

--Think this item.
--available:server
---@return nil
function CDOTA_Item:Think()end

