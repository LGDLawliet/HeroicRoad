---@class CDOTA_Modifier_Lua : CDOTA_Buff
CDOTA_Modifier_Lua = 
{
}
--True/false if this modifier is active on illusions.
--available:both
---@return bool
function CDOTA_Modifier_Lua:AllowIllusionDuplicate()end

--
--available:both
---@return bool
function CDOTA_Modifier_Lua:CanParentBeAutoAttacked()end

--True/false if this buff is removed when the duration expires.
--available:both
---@return bool
function CDOTA_Modifier_Lua:DestroyOnExpire()end

--Return the types of attributes applied to this modifier.
--available:both
---@return DOTAModifierAttribute_t
function CDOTA_Modifier_Lua:GetAttributes()end

--Returns aura stickiness.
--available:both
---@return float
function CDOTA_Modifier_Lua:GetAuraDuration()end

--Return true/false if this entity should receive the aura under specific conditions.
--available:both
---@param entity CDOTA_BaseNPC
---@return bool
function CDOTA_Modifier_Lua:GetAuraEntityReject(entity)end

--Return the range around the parent this aura tries to apply its buff.
--available:both
---@return int
function CDOTA_Modifier_Lua:GetAuraRadius()end

--Return the unit flags this aura respects when placing buffs.
--available:both
---@return DOTA_UNIT_TARGET_FLAGS
function CDOTA_Modifier_Lua:GetAuraSearchFlags()end

--Return the teams this aura applies its buff to.
--available:both
---@return DOTA_UNIT_TARGET_TEAM
function CDOTA_Modifier_Lua:GetAuraSearchTeam()end

--Return the unit classifications this aura applies its buff to.
--available:both
---@return DOTA_UNIT_TARGET_TYPE
function CDOTA_Modifier_Lua:GetAuraSearchType()end

--Return the attach type of the particle system from GetEffectName.
--available:both
---@return ParticleAttachment_t
function CDOTA_Modifier_Lua:GetEffectAttachType()end

--Return the name of the particle system that is created while this modifier is active.
--available:both
---@return string
function CDOTA_Modifier_Lua:GetEffectName()end

--Return the name of the hero effect particle system that is created while this modifier is active.
--available:both
---@return string
function CDOTA_Modifier_Lua:GetHeroEffectName()end

--The name of the secondary modifier that will be applied by this modifier (if it is an aura).
--available:both
---@return string
function CDOTA_Modifier_Lua:GetModifierAura()end

--Return the priority order this modifier will be applied over others.
--available:both
---@return modifierpriority
function CDOTA_Modifier_Lua:GetPriority()end

--Return the name of the status effect particle system that is created while this modifier is active.
--available:both
---@return string
function CDOTA_Modifier_Lua:GetStatusEffectName()end

--Return the name of the buff icon to be shown for this modifier.
--available:both
---@return string
function CDOTA_Modifier_Lua:GetTexture()end

--Relationship of this hero effect with those from other buffs (higher is more likely to be shown).
--available:both
---@return modifierpriority
function CDOTA_Modifier_Lua:HeroEffectPriority()end

--True/false if this modifier is an aura.
--available:both
---@return bool
function CDOTA_Modifier_Lua:IsAura()end

--True/false if this aura provides buffs when the parent is dead.
--available:both
---@return bool
function CDOTA_Modifier_Lua:IsAuraActiveOnDeath()end

--True/false if this modifier should be displayed as a debuff.
--available:both
---@return bool
function CDOTA_Modifier_Lua:IsDebuff()end

--True/false if this modifier should be displayed on the buff bar.
--available:both
---@return bool
function CDOTA_Modifier_Lua:IsHidden()end

--
--available:both
---@return bool
function CDOTA_Modifier_Lua:IsPermanent()end

--True/false if this modifier can be purged.
--available:both
---@return bool
function CDOTA_Modifier_Lua:IsPurgable()end

--True/false if this modifier can be purged by strong dispels.
--available:both
---@return bool
function CDOTA_Modifier_Lua:IsPurgeException()end

--True/false if this modifier is considered a stun for purge reasons.
--available:both
---@return bool
function CDOTA_Modifier_Lua:IsStunDebuff()end

--Runs when the modifier is created.
--available:both
---@param params table
---@return nil
function CDOTA_Modifier_Lua:OnCreated(params)end

--Runs when the modifier is destroyed (after unit loses modifier).
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnDestroy()end

--Runs when the think interval occurs.
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnIntervalThink()end

--Runs when the modifier is refreshed.
--available:both
---@param params table
---@return nil
function CDOTA_Modifier_Lua:OnRefresh(params)end

--Runs when the modifier is destroyed (before unit loses modifier).
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnRemoved()end

--Runs when stack count changes (param is old count).
--available:both
---@param stackCount int
---@return nil
function CDOTA_Modifier_Lua:OnStackCountChanged(stackCount)end

--True/false if this modifier is removed when the parent dies.
--available:both
---@return bool
function CDOTA_Modifier_Lua:RemoveOnDeath()end

--
--available:both
---@param hasCustomData bool
---@return nil
function CDOTA_Modifier_Lua:SetHasCustomTransmitterData(hasCustomData)end

--Apply the overhead offset to the attached effect.
--available:both
---@return bool
function CDOTA_Modifier_Lua:ShouldUseOverheadOffset()end

--Relationship of this status effect with those from other buffs (higher is more likely to be shown).
--available:both
---@return modifierpriority
function CDOTA_Modifier_Lua:StatusEffectPriority()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:BotAttackScoreBonus()end

--Return a map of enabled/disabled states.
--available:both
---@return table
function CDOTA_Modifier_Lua:CheckState()end

--Return a list of modifier functions this modifier implements.
--available:both
---@return modifierfunction[]
function CDOTA_Modifier_Lua:DeclareFunctions()end

--
--available:both
---@param event ModifierAttackEvent
---@return number,number
function CDOTA_Modifier_Lua:GetAbsoluteNoDamageMagical(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return number,number
function CDOTA_Modifier_Lua:GetAbsoluteNoDamagePhysical(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return number,number
function CDOTA_Modifier_Lua:GetAbsoluteNoDamagePure(event)end

--
--available:both
---@param event ModifierAbilityEvent
---@return number,number
function CDOTA_Modifier_Lua:GetAbsorbSpell(event)end

--
--available:both
---@return string
function CDOTA_Modifier_Lua:GetActivityTranslationModifiers()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetAllowEtherealAttack()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetAlwaysAllowAttack()end

--
--available:both
---@return string
function CDOTA_Modifier_Lua:GetAttackSound()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetBonusDayVision()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetBonusNightVision()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetBonusNightVisionUnique()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetBonusVisionPercentage()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetDisableAutoAttack()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetDisableHealing()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetFixedDayVision()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetFixedNightVision()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetForceDrawOnMinimap()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetIsIllusion()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetMinHealth()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierAbilityLayout()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierAttackPointConstant()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierAttackRangeBonus()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierAttackRangeBonusPercentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierAttackRangeBonusUnique()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierAttackRangeOverride()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierAttackSpeedBaseOverride()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierAttackSpeedBonus_Constant()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierAttackSpeedReductionPercentage()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierAvoidDamage(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return number,number
function CDOTA_Modifier_Lua:GetModifierAvoidSpell(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierBaseAttack_BonusDamage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierBaseAttackTimeConstant()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierBaseAttackTimeConstant_Adjust()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierBaseDamageOutgoing_Percentage(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierBaseDamageOutgoing_PercentageUnique(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierBaseRegen()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierBonusDamageOutgoing_Percentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierBonusStats_Agility()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierBonusStats_Agility_Percentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierBonusStats_Intellect()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierBonusStats_Intellect_Percentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierBonusStats_Strength()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierBonusStats_Strength_Percentage()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierCanAttackTrees()end

--
--available:both
---@param event ModifierAbilityEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierCastRangeBonus(event)end

--
--available:both
---@param event ModifierAbilityEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierCastRangeBonusStacking(event)end

--
--available:both
---@param event ModifierAbilityEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierCastRangeBonusTarget(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierChangeAbilityValue()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierConstantDeathGoldCost()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierConstantHealthRegen()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierConstantManaRegen()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierConstantManaRegenUnique()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierConstantRespawnTime()end

--
--available:both
---@param event ModifierAbilityEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierCooldownReduction_Constant(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierDamageOutgoing_Percentage(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierDamageOutgoing_Percentage_Illusion(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierDamageOutgoing_Percentage_Illusion_Amplify()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierDisableTurning()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierDodgeProjectile()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierEvasion_Constant(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierExtraHealthBonus()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierExtraHealthPercentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierExtraManaBonus()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierExtraManaPercentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierExtraStrengthBonus()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierFixedAttackRate()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierHealAmplify_PercentageSource()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierHealAmplify_PercentageTarget()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierHealthBonus()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierHealthRegenPercentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierHealthRegenPercentageUnique()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierHPRegenAmplify_Percentage()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierIgnoreCastAngle()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierIgnoreCooldown()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierIgnoreMovespeedLimit()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierIgnorePhysicalArmor(event)end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierIllusionLabel()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierIncomingDamage_Percentage(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierIncomingPhysicalDamage_Percentage(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierIncomingPhysicalDamageConstant(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierIncomingSpellDamageConstant(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierInvisibilityAttackBehaviorException()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierInvisibilityLevel()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierLifestealRegenAmplify_Percentage()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierMagical_ConstantBlock(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierMagicalResistanceBaseReduction()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierMagicalResistanceBonus(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierMagicalResistanceBonusIllusions()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierMagicalResistanceDecrepifyUnique(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierMagicalResistanceDirectModification(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierManaBonus()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierManacostReduction_Constant()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierManaDrainAmplify_Percentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMaxAttackRange()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMiss_Percentage()end

--
--available:both
---@return string
function CDOTA_Modifier_Lua:GetModifierModelChange()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierModelScale()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeed_Absolute()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierMoveSpeed_AbsoluteMax()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeed_AbsoluteMin()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeed_Limit()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeedBonus_Constant()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierMoveSpeedBonus_Constant_Unique()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeedBonus_Constant_Unique_2()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeedBonus_Percentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeedBonus_Percentage_Unique()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeedBonus_Percentage_Unique_2()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeedBonus_Special_Boots()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeedBonus_Special_Boots_2()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMoveSpeedOverride()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierMoveSpeedReductionPercentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMPRegenAmplify_Percentage()end

--Total amplify value is clamped to 0.
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierMPRestoreAmplify_Percentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierNegativeEvasion_Constant()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierNoVisionOfAttacker()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierOverrideAbilitySpecial()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierOverrideAbilitySpecialValue()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierOverrideAttackDamage()end

--
--available:both
---@param event ModifierAbilityEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPercentageCasttime(event)end

--
--available:both
---@param event ModifierAbilityEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPercentageCooldown(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierPercentageCooldownOngoing()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPercentageExpRateBoost()end

--
--available:both
---@param event ModifierAbilityEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPercentageManacost(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPercentageManacostStacking()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPercentageRespawnTime()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPersistentInvisibility()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPhysical_ConstantBlock(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPhysical_ConstantBlockSpecial()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPhysical_ConstantBlockUnavoidablePreArmor(event)end

--Values above 100% are ignored.
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPhysicalArmorBase_Percentage()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPhysicalArmorBonus(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPhysicalArmorBonusUnique(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPhysicalArmorBonusUniqueActive(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierPhysicalArmorTotal_Percentage()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPreAttack(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPreAttack_BonusDamage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPreAttack_BonusDamage_Proc()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierPreAttack_BonusDamage_Target()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPreAttack_BonusDamagePostCrit(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierPreAttack_CriticalStrike(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierPreAttack_Target_CriticalStrike()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierProcAttack_BonusDamage_Magical(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierProcAttack_BonusDamage_Physical(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierProcAttack_BonusDamage_Pure(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierProcAttack_Feedback(event)end

--
--available:both
---@return string
function CDOTA_Modifier_Lua:GetModifierProjectileName()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierProjectileSpeedBonus()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierProjectileSpeedBonusPercentage()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierProvidesFOWVision()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierRadarCooldownReduction()end

--Always applies scepter when this property is active
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierScepter()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierSpellAmplify_Percentage(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierSpellAmplify_PercentageUnique()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierSpellLifestealRegenAmplify_Percentage()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierSpellsRequireHP()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierStackingRespawnTime()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierStatusResistance()end

--
--available:both
---@param event ModifierUnitEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierStatusResistanceCaster(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierStatusResistanceStacking()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetModifierStrongIllusion()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierSuperIllusion()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierSuperIllusionWithUltimate()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierTempestDouble()end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierTotal_ConstantBlock(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return float
function CDOTA_Modifier_Lua:GetModifierTotalDamageOutgoing_Percentage(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierTotalPercentageManaRegen()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierTurnRate_Override()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetModifierTurnRate_Percentage()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierUnitDisllowUpgrading()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetModifierUnitStatsNeedsRefresh()end

--
--available:both
---@return GameActivity_t
function CDOTA_Modifier_Lua:GetOverrideAnimation()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetOverrideAnimationRate()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetOverrideAnimationWeight()end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:GetOverrideAttackMagical()end

--
--available:both
---@param event ModifierAbilityEvent
---@return number,number
function CDOTA_Modifier_Lua:GetReflectSpell(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetSuppressCleave()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetSuppressTeleport()end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:GetTriggerCosmeticAndEndAttack()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetUnitLifetimeFraction()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:GetVisualZDelta()end

--
--available:both
---@param event ModifierAbilityEvent
---@return nil
function CDOTA_Modifier_Lua:OnAbilityEndChannel(event)end

--
--available:both
---@param event ModifierAbilityEvent
---@return nil
function CDOTA_Modifier_Lua:OnAbilityExecuted(event)end

--
--available:both
---@param event ModifierAbilityEvent
---@return nil
function CDOTA_Modifier_Lua:OnAbilityFullyCast(event)end

--
--available:both
---@param event ModifierAbilityEvent
---@return nil
function CDOTA_Modifier_Lua:OnAbilityStart(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttack(event)end

--Happens even if attack can't be issued.
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttackAllied(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttackCancelled(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttacked(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttackFail(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttackFinished(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttackLanded(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttackRecord(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttackRecordDestroy(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnAttackStart(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnBreakInvisibility()end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnBuildingKilled(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnDamageCalculated(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnDamagePrevented()end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnDeath(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnDominated(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnHealReceived(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnHealthGained(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnHeroKilled(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnManaGained(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnModelChanged(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnModifierAdded()end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnOrder(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnProcessCleave()end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnProjectileDodge(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnProjectileObstructionHit()end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnRespawn(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnSetLocation(event)end

--
--available:both
---@return nil
function CDOTA_Modifier_Lua:OnSpellTargetReady()end

--
--available:both
---@param event ModifierAbilityEvent
---@return nil
function CDOTA_Modifier_Lua:OnSpentMana(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnStateChanged(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnTakeDamage(event)end

--
--available:both
---@param event ModifierAttackEvent
---@return nil
function CDOTA_Modifier_Lua:OnTakeDamageKillCredit(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnTeleported(event)end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnTeleporting(event)end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:OnTooltip()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:OnTooltip2()end

--
--available:both
---@param event ModifierUnitEvent
---@return nil
function CDOTA_Modifier_Lua:OnUnitMoved(event)end

--
--available:both
---@return number,number
function CDOTA_Modifier_Lua:PreserveParticlesOnModelChanged()end

--
--available:both
---@return float
function CDOTA_Modifier_Lua:ReincarnateTime()end

