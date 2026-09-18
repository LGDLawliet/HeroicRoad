---@class CDOTA_Ability_Lua : CDOTABaseAbility
CDOTA_Ability_Lua = 
{
}
--Determine whether an issued command with no target is valid.
--available:both
---@return UnitFilterResult
function CDOTA_Ability_Lua:CastFilterResult()end

--Determine whether an issued command on a location is valid.
--available:both
---@param location Vector
---@return UnitFilterResult
function CDOTA_Ability_Lua:CastFilterResultLocation(location)end

--Determine whether an issued command on a target is valid.
--available:both
---@param target CDOTA_BaseNPC
---@return UnitFilterResult
function CDOTA_Ability_Lua:CastFilterResultTarget(target)end

--Allows code overriding of the ability texture shown in the HUD.
--available:client
---@return string
function CDOTA_Ability_Lua:GetAbilityTextureName()end

--Controls the size of the AOE casting cursor.
--available:both
---@return float
function CDOTA_Ability_Lua:GetAOERadius()end

--Returns abilities that are stolen simultaneously, or otherwise related in functionality.
--available:server
---@return string
function CDOTA_Ability_Lua:GetAssociatedPrimaryAbilities()end

--Returns other abilities that are stolen simultaneously, or otherwise related in functionality.  Generally hidden abilities.
--available:server
---@return string
function CDOTA_Ability_Lua:GetAssociatedSecondaryAbilities()end

--Return cast behavior type of this ability.
--available:both
---@return DOTA_ABILITY_BEHAVIOR
function CDOTA_Ability_Lua:GetBehavior()end

--Return casting animation of this ability.
--available:server
---@return GameActivity_t
function CDOTA_Ability_Lua:GetCastAnimation()end

--Return cast point of this ability.
--available:both
---@return float
function CDOTA_Ability_Lua:GetCastPoint()end

--Return cast range of this ability.
--available:both
---@param location Vector
---@param target CDOTA_BaseNPC|nil
---@return int
function CDOTA_Ability_Lua:GetCastRange(location,target)end

--Return channel animation of this ability.
--available:server
---@return GameActivity_t
function CDOTA_Ability_Lua:GetChannelAnimation()end

--Return mana cost at the given level per second while channeling (-1 is current).
--available:both
---@param level int
---@return int
function CDOTA_Ability_Lua:GetChannelledManaCostPerSecond(level)end

--Return the channel time of this ability.
--available:both
---@return float
function CDOTA_Ability_Lua:GetChannelTime()end

--Return who hears speech when this spell is cast.
--available:server
---@return int
function CDOTA_Ability_Lua:GetConceptRecipientType()end

--Return cooldown of this ability.
--available:both
---@param level int
---@return float
function CDOTA_Ability_Lua:GetCooldown(level)end

--Return the error string of a failed command with no target.
--available:both
---@return string
function CDOTA_Ability_Lua:GetCustomCastError()end

--Return the error string of a failed command on a location.
--available:both
---@param location Vector
---@return string
function CDOTA_Ability_Lua:GetCustomCastErrorLocation(location)end

--Return the error string of a failed command on a target.
--available:both
---@param target CDOTA_BaseNPC
---@return string
function CDOTA_Ability_Lua:GetCustomCastErrorTarget(target)end

--Return gold cost at the given level (-1 is current).
--available:both
---@param level int
---@return int
function CDOTA_Ability_Lua:GetGoldCost(level)end

--Returns the name of the modifier applied passively by this ability.
--available:server
---@return string
function CDOTA_Ability_Lua:GetIntrinsicModifierName()end

--Return mana cost at the given level (-1 is current).
--available:both
---@param level int
---@return int
function CDOTA_Ability_Lua:GetManaCost(level)end

--Return the animation rate of the cast animation.
--available:server
---@return float
function CDOTA_Ability_Lua:GetPlaybackRateOverride()end

--Returns true if this ability can be used when not on the action panel.
--available:server
---@return bool
function CDOTA_Ability_Lua:IsHiddenAbilityCastable()end

--Returns true if this ability is hidden when stolen by Spell Steal.
--available:server
---@return bool
function CDOTA_Ability_Lua:IsHiddenWhenStolen()end

--Returns true if this ability is refreshed by Refresher Orb.
--available:server
---@return bool
function CDOTA_Ability_Lua:IsRefreshable()end

--Returns true if this ability can be stolen by Spell Steal.
--available:server
---@return bool
function CDOTA_Ability_Lua:IsStealable()end

--Cast time did not complete successfully.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnAbilityPhaseInterrupted()end

--Cast time begins (return true for successful cast).
--available:server
---@return bool
function CDOTA_Ability_Lua:OnAbilityPhaseStart()end

--The ability was pinged.
--available:server
---@param playerId PlayerID
---@param ctrlHeld bool
---@return nil
function CDOTA_Ability_Lua:OnAbilityPinged(playerId,ctrlHeld)end

--Channel finished.
--available:server
---@param interrupted bool
---@return nil
function CDOTA_Ability_Lua:OnChannelFinish(interrupted)end

--Channeling is taking place.
--available:server
---@param interval float
---@return nil
function CDOTA_Ability_Lua:OnChannelThink(interval)end

--Caster (hero only) gained a level, skilled an ability, or received a new stat bonus.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnHeroCalculateStatBonus()end

--A hero has died in the vicinity (ie Urn), takes table of params.
--available:server
---@param unit CDOTA_BaseNPC
---@param attacker CDOTA_BaseNPC
---@param event table
---@return nil
function CDOTA_Ability_Lua:OnHeroDiedNearby(unit,attacker,event)end

--Caster gained a level.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnHeroLevelUp()end

--Caster inventory changed.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnInventoryContentsChanged()end

--Caster equipped item.
--available:server
---@param item CDOTA_Item
---@return nil
function CDOTA_Ability_Lua:OnItemEquipped(item)end

--Caster died.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnOwnerDied()end

--Caster respawned or spawned for the first time.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnOwnerSpawned()end

--Projectile has collided with a given target or reached its destination. If 'true` is returned, projectile would be destroyed.
--available:server
---@param target CDOTA_BaseNPC|nil
---@param location Vector
---@return bool,nil
function CDOTA_Ability_Lua:OnProjectileHit(target,location)end

--Projectile has collided with a given target or reached its destination. If 'true` is returned, projectile would be destroyed.
--available:server
---@param target CDOTA_BaseNPC|nil
---@param location Vector
---@param extraData table
---@return bool,nil
function CDOTA_Ability_Lua:OnProjectileHit_ExtraData(target,location,extraData)end

--Projectile has collided with a given target or reached its destination. If 'true` is returned, projectile would be destroyed.
--available:server
---@param target CDOTA_BaseNPC|nil
---@param location Vector
---@param projectileHandle ProjectileID
---@return bool,nil
function CDOTA_Ability_Lua:OnProjectileHitHandle(target,location,projectileHandle)end

--Projectile is actively moving.
--available:server
---@param location Vector
---@return nil
function CDOTA_Ability_Lua:OnProjectileThink(location)end

--Projectile is actively moving.
--available:server
---@param location Vector
---@param extraData table
---@return nil
function CDOTA_Ability_Lua:OnProjectileThink_ExtraData(location,extraData)end

--Projectile is actively moving.
--available:server
---@param projectileHandle ProjectileID
---@return nil
function CDOTA_Ability_Lua:OnProjectileThinkHandle(projectileHandle)end

--Cast time finished, spell effects begin.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnSpellStart()end

--Special behavior when stolen by Spell Steal.
--available:server
---@param sourceAbility CDOTABaseAbility
---@return nil
function CDOTA_Ability_Lua:OnStolen(sourceAbility)end

--Ability is toggled on/off.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnToggle()end

--Special behavior when lost by Spell Steal.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnUnStolen()end

--Ability gained a level.
--available:server
---@return nil
function CDOTA_Ability_Lua:OnUpgrade()end

--Returns true if this ability will generate magic stick charges for nearby enemies.
--available:server
---@return bool
function CDOTA_Ability_Lua:ProcsMagicStick()end

--Returns true if this ability should return to the default toggle state when its parent respawns.
--available:server
---@return bool
function CDOTA_Ability_Lua:ResetToggleOnRespawn()end

--Return the type of speech used.
--available:server
---@return int
function CDOTA_Ability_Lua:SpeakTrigger()end

--Called first when ability entity is created.
--available:both
---@return nil
function CDOTA_Ability_Lua:Init()end

--
--available:server
---@param context CScriptPrecacheContext
---@return nil
function CDOTA_Ability_Lua:Precache(context)end

--Called when ability entity is created, after Init.
--available:both
---@return nil
function CDOTA_Ability_Lua:Spawn()end

