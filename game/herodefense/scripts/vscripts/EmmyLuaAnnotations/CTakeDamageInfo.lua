---@class CTakeDamageInfo
CTakeDamageInfo = 
{
}
--
--available:server
---@param addAmount float
---@return nil
function CTakeDamageInfo:AddDamage(addAmount)end

--
--available:server
---@param bitsDamageType int
---@return nil
function CTakeDamageInfo:AddDamageType(bitsDamageType)end

--
--available:server
---@return bool
function CTakeDamageInfo:AllowFriendlyFire()end

--
--available:server
---@return bool
function CTakeDamageInfo:BaseDamageIsValid()end

--
--available:server
---@return bool
function CTakeDamageInfo:CanBeBlocked()end

--
--available:server
---@return int
function CTakeDamageInfo:GetAmmoType()end

--
--available:server
---@return handle
function CTakeDamageInfo:GetAttacker()end

--
--available:server
---@return float
function CTakeDamageInfo:GetBaseDamage()end

--
--available:server
---@return float
function CTakeDamageInfo:GetDamage()end

--
--available:server
---@return int
function CTakeDamageInfo:GetDamageCustom()end

--
--available:server
---@return Vector
function CTakeDamageInfo:GetDamageForce()end

--
--available:server
---@return Vector
function CTakeDamageInfo:GetDamagePosition()end

--
--available:server
---@return float
function CTakeDamageInfo:GetDamageTaken()end

--
--available:server
---@return int
function CTakeDamageInfo:GetDamageType()end

--
--available:server
---@return handle
function CTakeDamageInfo:GetInflictor()end

--
--available:server
---@return float
function CTakeDamageInfo:GetMaxDamage()end

--
--available:server
---@return float
function CTakeDamageInfo:GetOriginalDamage()end

--
--available:server
---@return float
function CTakeDamageInfo:GetRadius()end

--
--available:server
---@return Vector
function CTakeDamageInfo:GetReportedPosition()end

--
--available:server
---@return float
function CTakeDamageInfo:GetStabilityDamage()end

--
--available:server
---@param bitsToTest int
---@return bool
function CTakeDamageInfo:HasDamageType(bitsToTest)end

--
--available:server
---@param scaleAmount float
---@return nil
function CTakeDamageInfo:ScaleDamage(scaleAmount)end

--
--available:server
---@param allow bool
---@return nil
function CTakeDamageInfo:SetAllowFriendlyFire(allow)end

--
--available:server
---@param ammoType int
---@return nil
function CTakeDamageInfo:SetAmmoType(ammoType)end

--
--available:server
---@param attacker handle
---@return nil
function CTakeDamageInfo:SetAttacker(attacker)end

--
--available:server
---@param block bool
---@return nil
function CTakeDamageInfo:SetCanBeBlocked(block)end

--
--available:server
---@param damage float
---@return nil
function CTakeDamageInfo:SetDamage(damage)end

--
--available:server
---@param damageCustom int
---@return nil
function CTakeDamageInfo:SetDamageCustom(damageCustom)end

--
--available:server
---@param damageForce Vector
---@return nil
function CTakeDamageInfo:SetDamageForce(damageForce)end

--
--available:server
---@param damagePosition Vector
---@return nil
function CTakeDamageInfo:SetDamagePosition(damagePosition)end

--
--available:server
---@param damageTaken int
---@return nil
function CTakeDamageInfo:SetDamageTaken(damageTaken)end

--
--available:server
---@param bitsDamageType int
---@return nil
function CTakeDamageInfo:SetDamageType(bitsDamageType)end

--
--available:server
---@param maxDamage float
---@return nil
function CTakeDamageInfo:SetMaxDamage(maxDamage)end

--
--available:server
---@param originalDamage float
---@return nil
function CTakeDamageInfo:SetOriginalDamage(originalDamage)end

--
--available:server
---@param radius float
---@return nil
function CTakeDamageInfo:SetRadius(radius)end

--
--available:server
---@param reportedPosition Vector
---@return nil
function CTakeDamageInfo:SetReportedPosition(reportedPosition)end

--
--available:server
---@param stabilityDamage float
---@return nil
function CTakeDamageInfo:SetStabilityDamage(stabilityDamage)end

