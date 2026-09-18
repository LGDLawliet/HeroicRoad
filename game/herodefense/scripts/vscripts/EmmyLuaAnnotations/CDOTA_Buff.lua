---@class CDOTA_Buff
CDOTA_Buff = 
{
}
--
--available:both
---@param index int
---@param destroyImmediately bool
---@param statusEffect bool
---@param priority int
---@param heroEffect bool
---@param overheadEffect bool
---@return nil
function CDOTA_Buff:AddParticle(index,destroyImmediately,statusEffect,priority,heroEffect,overheadEffect)end

--Decrease this modifier's stack count by 1.
--available:both
---@return nil
function CDOTA_Buff:DecrementStackCount()end

--Run all associated destroy functions, then remove the modifier.
--available:both
---@return nil
function CDOTA_Buff:Destroy()end

--
--available:both
---@return bool
function CDOTA_Buff:DestroyOnExpire()end

--Run all associated refresh functions on this modifier as if it was re-applied.
--available:both
---@return nil
function CDOTA_Buff:ForceRefresh()end

--Get the ability that generated the modifier.
--available:both
---@return CDOTABaseAbility,nil
function CDOTA_Buff:GetAbility()end

--Returns aura stickiness (default 0.5).
--available:both
---@return float
function CDOTA_Buff:GetAuraDuration()end

--Returns the owner of the aura modifier, that applied this modifier. Always `nil` on the client.
--available:both
---@return CDOTA_BaseNPC,nil
function CDOTA_Buff:GetAuraOwner()end

--Get the owner of the ability responsible for the modifier.
--available:both
---@return CDOTA_BaseNPC,nil
function CDOTA_Buff:GetCaster()end

--
--available:both
---@return string
function CDOTA_Buff:GetClass()end

--
--available:both
---@return float
function CDOTA_Buff:GetCreationTime()end

--
--available:both
---@return float
function CDOTA_Buff:GetDieTime()end

--
--available:both
---@return float
function CDOTA_Buff:GetDuration()end

--
--available:both
---@return float
function CDOTA_Buff:GetElapsedTime()end

--
--available:both
---@return float
function CDOTA_Buff:GetLastAppliedTime()end

--
--available:both
---@return string
function CDOTA_Buff:GetName()end

--Get the unit the modifier is parented to.
--available:both
---@return CDOTA_BaseNPC
function CDOTA_Buff:GetParent()end

--
--available:both
---@return float
function CDOTA_Buff:GetRemainingTime()end

--
--available:both
---@return int
function CDOTA_Buff:GetSerialNumber()end

--
--available:both
---@return int
function CDOTA_Buff:GetStackCount()end

--
--available:both
---@param _function modifierfunction
---@return bool
function CDOTA_Buff:HasFunction(_function)end

--Increase this modifier's stack count by 1.
--available:both
---@return nil
function CDOTA_Buff:IncrementStackCount()end

--
--available:both
---@return bool
function CDOTA_Buff:IsDebuff()end

--
--available:both
---@return bool
function CDOTA_Buff:IsHexDebuff()end

--
--available:both
---@return bool
function CDOTA_Buff:IsStunDebuff()end

--
--available:server
---@return nil
function CDOTA_Buff:SendBuffRefreshToClients()end

--
--available:both
---@param duration float
---@param informClient bool
---@return nil
function CDOTA_Buff:SetDuration(duration,informClient)end

--
--available:both
---@param count int
---@return nil
function CDOTA_Buff:SetStackCount(count)end

--Start this modifier's think function (OnIntervalThink) with the given interval (float).  To stop, call with -1.
--available:both
---@param interval float
---@return nil
function CDOTA_Buff:StartIntervalThink(interval)end

