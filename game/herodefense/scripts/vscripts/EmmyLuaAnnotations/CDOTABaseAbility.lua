---@class CDOTABaseAbility : CBaseEntity
CDOTABaseAbility = 
{
}
--
--available:server
---@return bool
function CDOTABaseAbility:CanAbilityBeUpgraded()end

--
--available:server
---@return bool
function CDOTABaseAbility:CastAbility()end

--
--available:server
---@return bool
function CDOTABaseAbility:ContinueCasting()end

--
--available:server
---@param location Vector
---@param radius float
---@param duration float
---@return nil
function CDOTABaseAbility:CreateVisibilityNode(location,radius,duration)end

--
--available:server
---@return nil
function CDOTABaseAbility:DecrementModifierRefCount()end

--
--available:server
---@param interrupted bool
---@return nil
function CDOTABaseAbility:EndChannel(interrupted)end

--Clear the cooldown remaining on this ability.
--available:server
---@return nil
function CDOTABaseAbility:EndCooldown()end

--
--available:server
---@return int
function CDOTABaseAbility:GetAbilityDamage()end

--
--available:server
---@return DAMAGE_TYPES
function CDOTABaseAbility:GetAbilityDamageType()end

--
--available:server
---@return int
function CDOTABaseAbility:GetAbilityIndex()end

--Gets the key values definition for this ability.
--available:server
---@return table
function CDOTABaseAbility:GetAbilityKeyValues()end

--Returns the name of this ability.
--available:both
---@return string
function CDOTABaseAbility:GetAbilityName()end

--
--available:server
---@return DOTA_UNIT_TARGET_FLAGS
function CDOTABaseAbility:GetAbilityTargetFlags()end

--
--available:server
---@return DOTA_UNIT_TARGET_TEAM
function CDOTABaseAbility:GetAbilityTargetTeam()end

--
--available:server
---@return DOTA_UNIT_TARGET_TYPE
function CDOTABaseAbility:GetAbilityTargetType()end

--
--available:server
---@return int
function CDOTABaseAbility:GetAbilityType()end

--
--available:server
---@return bool
function CDOTABaseAbility:GetAnimationIgnoresModelScale()end

--
--available:server
---@return int
function CDOTABaseAbility:GetAOERadius()end

--
--available:server
---@return string
function CDOTABaseAbility:GetAssociatedPrimaryAbilities()end

--
--available:server
---@return string
function CDOTABaseAbility:GetAssociatedSecondaryAbilities()end

--
--available:server
---@return bool
function CDOTABaseAbility:GetAutoCastState()end

--
--available:server
---@return float
function CDOTABaseAbility:GetBackswingTime()end

--
--available:server
---@return DOTA_ABILITY_BEHAVIOR
function CDOTABaseAbility:GetBehavior()end

--Get ability behavior flags as an int for compatability.
--available:both
---@return DOTA_ABILITY_BEHAVIOR
function CDOTABaseAbility:GetBehaviorInt()end

--
--available:both
---@return CDOTA_BaseNPC
function CDOTABaseAbility:GetCaster()end

--
--available:server
---@return float
function CDOTABaseAbility:GetCastPoint()end

--Gets the cast range of the ability.
--available:server
---@param location Vector|nil
---@param target CDOTA_BaseNPC|nil
---@return int
function CDOTABaseAbility:GetCastRange(location,target)end

--
--available:server
---@param level int
---@return int
function CDOTABaseAbility:GetChannelledManaCostPerSecond(level)end

--
--available:server
---@return float
function CDOTABaseAbility:GetChannelStartTime()end

--
--available:server
---@return float
function CDOTABaseAbility:GetChannelTime()end

--
--available:server
---@return CDOTA_BaseNPC,nil
function CDOTABaseAbility:GetCloneSource()end

--
--available:server
---@return int
function CDOTABaseAbility:GetConceptRecipientType()end

--Get the cooldown duration for this ability at a given level, not the amount of cooldown actually left.
--available:server
---@param level int
---@return float
function CDOTABaseAbility:GetCooldown(level)end

--
--available:server
---@return float
function CDOTABaseAbility:GetCooldownTime()end

--
--available:server
---@return float
function CDOTABaseAbility:GetCooldownTimeRemaining()end

--
--available:both
---@return int
function CDOTABaseAbility:GetCurrentAbilityCharges()end

--
--available:server
---@return Vector
function CDOTABaseAbility:GetCursorPosition()end

--
--available:server
---@return CDOTA_BaseNPC,nil
function CDOTABaseAbility:GetCursorTarget()end

--
--available:server
---@return bool
function CDOTABaseAbility:GetCursorTargetingNothing()end

--
--available:server
---@return float
function CDOTABaseAbility:GetDuration()end

--
--available:server
---@param level int
---@return float
function CDOTABaseAbility:GetEffectiveCooldown(level)end

--
--available:server
---@param level int
---@return int
function CDOTABaseAbility:GetGoldCost(level)end

--
--available:server
---@param level int
---@return int
function CDOTABaseAbility:GetGoldCostForUpgrade(level)end

--
--available:server
---@return int
function CDOTABaseAbility:GetHeroLevelRequiredToUpgrade()end

--
--available:server
---@return string
function CDOTABaseAbility:GetIntrinsicModifierName()end

--Get the current level of the ability.
--available:both
---@return int
function CDOTABaseAbility:GetLevel()end

--Gets a value from this ability's special value block for passed level.
--available:both
---@param name string
---@param level int
---@return float
function CDOTABaseAbility:GetLevelSpecialValueFor(name,level)end

--Gets a value from this ability's special value block for passed level, ignoring MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL.
--available:both
---@param name string
---@param level int
---@return float
function CDOTABaseAbility:GetLevelSpecialValueNoOverride(name,level)end

--
--available:server
---@param level int
---@return int
function CDOTABaseAbility:GetManaCost(level)end

--
--available:server
---@return int
function CDOTABaseAbility:GetMaxLevel()end

--
--available:server
---@return float
function CDOTABaseAbility:GetModifierValue()end

--
--available:server
---@return float
function CDOTABaseAbility:GetModifierValueBonus()end

--
--available:server
---@return float
function CDOTABaseAbility:GetPlaybackRateOverride()end

--
--available:server
---@return string
function CDOTABaseAbility:GetSharedCooldownName()end

--Gets a value from this ability's special value block for its current level.
--available:both
---@param name string
---@return float
function CDOTABaseAbility:GetSpecialValueFor(name)end

--
--available:server
---@return string
function CDOTABaseAbility:GetStolenActivityModifier()end

--Whether or not this ability is toggled.
--available:both
---@return bool
function CDOTABaseAbility:GetToggleState()end

--
--available:server
---@return bool
function CDOTABaseAbility:GetUpgradeRecommended()end

--
--available:server
---@param xp float
---@return bool
function CDOTABaseAbility:HeroXPChange(xp)end

--
--available:server
---@return nil
function CDOTABaseAbility:IncrementModifierRefCount()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsActivated()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsAttributeBonus()end

--Returns whether the ability is currently channeling.
--available:server
---@return bool
function CDOTABaseAbility:IsChanneling()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsCooldownReady()end

--
--available:server
---@param entity CBaseEntity
---@return bool
function CDOTABaseAbility:IsCosmetic(entity)end

--Returns whether the ability can be cast.
--available:server
---@return bool
function CDOTABaseAbility:IsFullyCastable()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsHidden()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsHiddenAsSecondaryAbility()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsHiddenWhenStolen()end

--Returns whether the ability is currently casting.
--available:server
---@return bool
function CDOTABaseAbility:IsInAbilityPhase()end

--Whether or not this ability is an item.
--available:both
---@return bool
function CDOTABaseAbility:IsItem()end

--
--available:server
---@param issuerPlayerId PlayerID
---@return bool
function CDOTABaseAbility:IsOwnersGoldEnough(issuerPlayerId)end

--
--available:server
---@return bool
function CDOTABaseAbility:IsOwnersGoldEnoughForUpgrade()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsOwnersManaEnough()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsPassive()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsRefreshable()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsSharedWithTeammates()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsStealable()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsStolen()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsToggle()end

--
--available:server
---@return bool
function CDOTABaseAbility:IsTrained()end

--Mark the ability button for this ability as needing a refresh.
--available:server
---@return nil
function CDOTABaseAbility:MarkAbilityButtonDirty()end

--
--available:server
---@return int
function CDOTABaseAbility:NumModifiersUsingAbility()end

--
--available:server
---@return nil
function CDOTABaseAbility:OnAbilityPhaseInterrupted()end

--
--available:server
---@return bool
function CDOTABaseAbility:OnAbilityPhaseStart()end

--
--available:server
---@param playerId PlayerID
---@param ctrlHeld bool
---@return nil
function CDOTABaseAbility:OnAbilityPinged(playerId,ctrlHeld)end

--
--available:server
---@param interrupted bool
---@return nil
function CDOTABaseAbility:OnChannelFinish(interrupted)end

--
--available:server
---@param interval float
---@return nil
function CDOTABaseAbility:OnChannelThink(interval)end

--
--available:server
---@return nil
function CDOTABaseAbility:OnHeroCalculateStatBonus()end

--
--available:server
---@return nil
function CDOTABaseAbility:OnHeroLevelUp()end

--
--available:server
---@return nil
function CDOTABaseAbility:OnOwnerDied()end

--
--available:server
---@return nil
function CDOTABaseAbility:OnOwnerSpawned()end

--
--available:server
---@return nil
function CDOTABaseAbility:OnSpellStart()end

--
--available:server
---@return nil
function CDOTABaseAbility:OnToggle()end

--
--available:server
---@return nil
function CDOTABaseAbility:OnUpgrade()end

--
--available:server
---@return nil
function CDOTABaseAbility:PayGoldCost()end

--
--available:server
---@return nil
function CDOTABaseAbility:PayGoldCostForUpgrade()end

--
--available:server
---@return nil
function CDOTABaseAbility:PayManaCost()end

--
--available:server
---@return bool
function CDOTABaseAbility:PlaysDefaultAnimWhenStolen()end

--
--available:server
---@return bool
function CDOTABaseAbility:ProcsMagicStick()end

--
--available:server
---@return bool
function CDOTABaseAbility:RefCountsModifiers()end

--
--available:server
---@return nil
function CDOTABaseAbility:RefreshCharges()end

--Returns true if ability has intrinsic modifier.
--available:server
---@return bool
function CDOTABaseAbility:RefreshIntrinsicModifier()end

--
--available:server
---@return nil
function CDOTABaseAbility:RefundManaCost()end

--
--available:server
---@return bool
function CDOTABaseAbility:ResetToggleOnRespawn()end

--
--available:server
---@param index int
---@return nil
function CDOTABaseAbility:SetAbilityIndex(index)end

--
--available:server
---@param activated bool
---@return nil
function CDOTABaseAbility:SetActivated(activated)end

--
--available:server
---@param channeling bool
---@return nil
function CDOTABaseAbility:SetChanneling(channeling)end

--
--available:server
---@param charges int
---@return nil
function CDOTABaseAbility:SetCurrentAbilityCharges(charges)end

--
--available:server
---@param frozenCooldown bool
---@return nil
function CDOTABaseAbility:SetFrozenCooldown(frozenCooldown)end

--
--available:server
---@param hidden bool
---@return nil
function CDOTABaseAbility:SetHidden(hidden)end

--
--available:server
---@param inAbilityPhase bool
---@return nil
function CDOTABaseAbility:SetInAbilityPhase(inAbilityPhase)end

--Sets the level of this ability.
--available:server
---@param level int
---@return nil
function CDOTABaseAbility:SetLevel(level)end

--
--available:server
---@param castPoint float
---@return nil
function CDOTABaseAbility:SetOverrideCastPoint(castPoint)end

--
--available:server
---@param refCounts bool
---@return nil
function CDOTABaseAbility:SetRefCountsModifiers(refCounts)end

--
--available:server
---@param stealable bool
---@return nil
function CDOTABaseAbility:SetStealable(stealable)end

--
--available:server
---@param stolen bool
---@return nil
function CDOTABaseAbility:SetStolen(stolen)end

--
--available:server
---@param upgradeRecommended bool
---@return nil
function CDOTABaseAbility:SetUpgradeRecommended(upgradeRecommended)end

--
--available:server
---@return bool
function CDOTABaseAbility:ShouldUseResources()end

--
--available:server
---@param concept int
---@return nil
function CDOTABaseAbility:SpeakAbilityConcept(concept)end

--
--available:server
---@return unknown
function CDOTABaseAbility:SpeakTrigger()end

--
--available:server
---@param cooldown float
---@return nil
function CDOTABaseAbility:StartCooldown(cooldown)end

--
--available:server
---@return nil
function CDOTABaseAbility:ToggleAbility()end

--
--available:server
---@return nil
function CDOTABaseAbility:ToggleAutoCast()end

--
--available:server
---@param supressSpeech bool
---@return nil
function CDOTABaseAbility:UpgradeAbility(supressSpeech)end

--
--available:server
---@param mana bool
---@param gold bool
---@param cooldown bool
---@return nil
function CDOTABaseAbility:UseResources(mana,gold,cooldown)end

