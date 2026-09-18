---@class ProjectileManager
ProjectileManager = 
{
}
--Update speed.
--available:server
---@param ability CDOTABaseAbility
---@param speed int
---@return nil
function ProjectileManager:ChangeTrackingProjectileSpeed(ability,speed)end

--Creates a linear projectile and returns the projectile ID.
--available:server
---@param options CreateLinearProjectileOptions
---@return ProjectileID
function ProjectileManager:CreateLinearProjectile(options)end

--Creates a tracking projectile.
--available:server
---@param options CreateTrackingProjectileOptions
---@return ProjectileID
function ProjectileManager:CreateTrackingProjectile(options)end

--Destroys the linear projectile matching the argument ID.
--available:server
---@param projectile ProjectileID
---@return nil
function ProjectileManager:DestroyLinearProjectile(projectile)end

--Destroy a tracking projectile early.
--available:server
---@param projectile ProjectileID
---@return nil
function ProjectileManager:DestroyTrackingProjectile(projectile)end

--Returns current location of projectile.
--available:server
---@param projectile ProjectileID
---@return Vector
function ProjectileManager:GetLinearProjectileLocation(projectile)end

--Returns current radius of projectile.
--available:server
---@param projectile ProjectileID
---@return float
function ProjectileManager:GetLinearProjectileRadius(projectile)end

--Returns a vector representing the current velocity of the projectile.
--available:server
---@param projectile ProjectileID
---@return Vector
function ProjectileManager:GetLinearProjectileVelocity(projectile)end

--Returns current location of projectile.
--available:server
---@param projectile ProjectileID
---@return Vector
function ProjectileManager:GetTrackingProjectileLocation(projectile)end

--Is this a valid projectile?
--available:server
---@param value int
---@return bool
function ProjectileManager:IsValidProjectile(value)end

--Makes the specified unit dodge projectiles.
--available:server
---@param unit CDOTA_BaseNPC
---@return nil
function ProjectileManager:ProjectileDodge(unit)end

--Update velocity.
--available:server
---@param projectile ProjectileID
---@param direction Vector
---@param speed float
---@return nil
function ProjectileManager:UpdateLinearProjectileDirection(projectile,direction,speed)end

