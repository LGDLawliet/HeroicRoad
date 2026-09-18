---@class CDOTA_BaseNPC_Hero : CDOTA_BaseNPC
CDOTA_BaseNPC_Hero = 
{
}
--
--available:server
---@param xp float
---@param reason EDOTA_ModifyXP_Reason
---@param applyBotDifficultyScaling bool
---@param incrementTotal bool
---@return bool
function CDOTA_BaseNPC_Hero:AddExperience(xp,reason,applyBotDifficultyScaling,incrementTotal)end

--Spend the gold and buyback with this hero.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:Buyback()end

--Recalculate all stats after the hero gains stats.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:CalculateStatBonus()end

--Returns boolean value result of buyback gold limit time less than game time.
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:CanEarnGold()end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:ClearLastHitMultikill()end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:ClearLastHitStreak()end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:ClearStreak()end

--Gets the current unspent ability points.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetAbilityPoints()end

--
--available:server
---@return CDOTA_BaseNPC[]
function CDOTA_BaseNPC_Hero:GetAdditionalOwnedUnits()end

--
--available:both
---@return float
function CDOTA_BaseNPC_Hero:GetAgility()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetAgilityGain()end

--Value is stored in PlayerResource.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetAssists()end

--
--available:server
---@param index int
---@return int
function CDOTA_BaseNPC_Hero:GetAttacker(index)end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetBaseAgility()end

--Hero damage is also affected by attributes.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetBaseDamageMax()end

--Hero damage is also affected by attributes.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetBaseDamageMin()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetBaseIntellect()end

--Returns the base mana regen.
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetBaseManaRegen()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetBaseStrength()end

--
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetBonusDamageFromPrimaryStat()end

--Return float value for the amount of time left on cooldown for this hero's buyback.
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetBuybackCooldownTime()end

--Return integer value for the gold cost of a buyback.
--available:server
---@param returnOldValues bool
---@return int
function CDOTA_BaseNPC_Hero:GetBuybackCost(returnOldValues)end

--Returns the amount of time gold gain is limited after buying back.
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetBuybackGoldLimitTime()end

--Returns the amount of XP.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetCurrentXP()end

--
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetDeathGoldCost()end

--Value is stored in PlayerResource.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetDeaths()end

--Value is stored in PlayerResource.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetDenies()end

--Returns gold amount for the player owning this hero.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetGold()end

--
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetGoldBounty()end

--
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetHeroID()end

--Hero attack speed is also affected by agility.
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetIncreasedAttackSpeed()end

--
--available:both
---@return float
function CDOTA_BaseNPC_Hero:GetIntellect()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetIntellectGain()end

--Value is stored in PlayerResource.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetKills()end

--Value is stored in PlayerResource.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetLastHits()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetMostRecentDamageTime()end

--
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetMultipleKillCount()end

--
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetNumAttackers()end

--
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetNumItemsInInventory()end

--
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetNumItemsInStash()end

--Hero armor is affected by attributes.
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetPhysicalArmorBaseValue()end

--Returns player ID of the player owning this hero.
--available:server
---@return PlayerID
function CDOTA_BaseNPC_Hero:GetPlayerID()end

--
--available:server
---@return Attributes
function CDOTA_BaseNPC_Hero:GetPrimaryAttribute()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetPrimaryStatValue()end

--If hero is under Replicate effect, returns original hero entity.
--available:server
---@return CDOTA_BaseNPC_Hero,nil
function CDOTA_BaseNPC_Hero:GetReplicatingOtherHero()end

--Is this hero prevented from respawning?
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:GetRespawnsDisabled()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetRespawnTime()end

--Value is stored in PlayerResource.
--available:server
---@return int
function CDOTA_BaseNPC_Hero:GetStreak()end

--
--available:both
---@return float
function CDOTA_BaseNPC_Hero:GetStrength()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetStrengthGain()end

--
--available:server
---@return float
function CDOTA_BaseNPC_Hero:GetTimeUntilRespawn()end

--Get wearable entity in slot (slot).
--available:server
---@param slotType DOTASlotType_t
---@return CBaseFlex,nil
function CDOTA_BaseNPC_Hero:GetTogglableWearable(slotType)end

--
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:HasAnyAvailableInventorySpace()end

--
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:HasFlyingVision()end

--
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:HasOwnerAbandoned()end

--
--available:server
---@param itemName string
---@param includeStashCombines bool
---@param allowSelling bool
---@return int
function CDOTA_BaseNPC_Hero:HasRoomForItem(itemName,includeStashCombines,allowSelling)end

--Levels up the hero, true or false to play effects.
--available:server
---@param playEffects bool
---@return nil
function CDOTA_BaseNPC_Hero:HeroLevelUp(playEffects)end

--Value is stored in PlayerResource.
--available:server
---@param killerId PlayerID
---@return nil
function CDOTA_BaseNPC_Hero:IncrementAssists(killerId)end

--Value is stored in PlayerResource.
--available:server
---@param killerId PlayerID
---@return nil
function CDOTA_BaseNPC_Hero:IncrementDeaths(killerId)end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:IncrementDenies()end

--Passed ID is for the victim, killer ID is ID of the current hero.  Value is stored in PlayerResource.
--available:server
---@param victimId PlayerID
---@return nil
function CDOTA_BaseNPC_Hero:IncrementKills(victimId)end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:IncrementLastHitMultikill()end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:IncrementLastHits()end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:IncrementLastHitStreak()end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:IncrementNearbyCreepDeaths()end

--Value is stored in PlayerResource.
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:IncrementStreak()end

--
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:IsBuybackDisabledByReapersScythe()end

--
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:IsReincarnating()end

--
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:IsStashEnabled()end

--
--available:server
---@param hero CDOTA_BaseNPC_Hero
---@param inflictor CDOTABaseAbility|nil
---@return nil
function CDOTA_BaseNPC_Hero:KilledHero(hero,inflictor)end

--Adds passed value to base attribute value, then calls CalculateStatBonus.
--available:server
---@param newAgility float
---@return nil
function CDOTA_BaseNPC_Hero:ModifyAgility(newAgility)end

--Gives this hero some gold.
--available:server
---@param goldChange int
---@param reliable bool
---@param reason EDOTA_ModifyGold_Reason
---@return int
function CDOTA_BaseNPC_Hero:ModifyGold(goldChange,reliable,reason)end

--Gives this hero some gold, using the gold filter if extra filtering is on.
--available:server
---@param goldChange int
---@param reliable bool
---@param reason EDOTA_ModifyGold_Reason
---@return int
function CDOTA_BaseNPC_Hero:ModifyGoldFiltered(goldChange,reliable,reason)end

--Adds passed value to base attribute value, then calls CalculateStatBonus.
--available:server
---@param newIntellect float
---@return nil
function CDOTA_BaseNPC_Hero:ModifyIntellect(newIntellect)end

--Adds passed value to base attribute value, then calls CalculateStatBonus.
--available:server
---@param newStrength float
---@return nil
function CDOTA_BaseNPC_Hero:ModifyStrength(newStrength)end

--
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:PerformTaunt()end

--
--available:server
---@return nil
function CDOTA_BaseNPC_Hero:RecordLastHit()end

--Respawn this hero.
--available:server
---@param buyBack bool
---@param respawnPenalty bool
---@return nil
function CDOTA_BaseNPC_Hero:RespawnHero(buyBack,respawnPenalty)end

--Sets the current unspent ability points.
--available:server
---@param points int
---@return nil
function CDOTA_BaseNPC_Hero:SetAbilityPoints(points)end

--
--available:server
---@param agility float
---@return nil
function CDOTA_BaseNPC_Hero:SetBaseAgility(agility)end

--
--available:server
---@param intellect float
---@return nil
function CDOTA_BaseNPC_Hero:SetBaseIntellect(intellect)end

--
--available:server
---@param strength float
---@return nil
function CDOTA_BaseNPC_Hero:SetBaseStrength(strength)end

--
--available:server
---@param difficulty int
---@return nil
function CDOTA_BaseNPC_Hero:SetBotDifficulty(difficulty)end

--Sets the buyback cooldown time.
--available:server
---@param time float
---@return nil
function CDOTA_BaseNPC_Hero:SetBuybackCooldownTime(time)end

--
--available:server
---@param buybackDisabled bool
---@return nil
function CDOTA_BaseNPC_Hero:SetBuyBackDisabledByReapersScythe(buybackDisabled)end

--Set the amount of time gold gain is limited after buying back.
--available:server
---@param time float
---@return nil
function CDOTA_BaseNPC_Hero:SetBuybackGoldLimitTime(time)end

--Sets a custom experience value for this hero.  Note, GameRules boolean must be set for this to work!
--available:server
---@param value int
---@return nil
function CDOTA_BaseNPC_Hero:SetCustomDeathXP(value)end

--Sets the gold amount for the player owning this hero.
--available:server
---@param gold int
---@param reliable bool
---@return nil
function CDOTA_BaseNPC_Hero:SetGold(gold,reliable)end

--
--available:server
---@param playerId PlayerID
---@return nil
function CDOTA_BaseNPC_Hero:SetPlayerID(playerId)end

--Set this hero's primary attribute value.
--available:server
---@param primaryAttribute Attributes
---@return nil
function CDOTA_BaseNPC_Hero:SetPrimaryAttribute(primaryAttribute)end

--
--available:server
---@param origin Vector
---@return nil
function CDOTA_BaseNPC_Hero:SetRespawnPosition(origin)end

--Prevent this hero from respawning.
--available:server
---@param disableRespawns bool
---@return nil
function CDOTA_BaseNPC_Hero:SetRespawnsDisabled(disableRespawns)end

--
--available:server
---@param enabled bool
---@return nil
function CDOTA_BaseNPC_Hero:SetStashEnabled(enabled)end

--
--available:server
---@param time float
---@return nil
function CDOTA_BaseNPC_Hero:SetTimeUntilRespawn(time)end

--
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:ShouldDoFlyHeightVisual()end

--
--available:server
---@param cost int
---@param reason EDOTA_ModifyGold_Reason
---@return nil
function CDOTA_BaseNPC_Hero:SpendGold(cost,reason)end

--This upgrades the passed ability if it exists and the hero has enough ability points.
--available:server
---@param ability CDOTABaseAbility
---@return nil
function CDOTA_BaseNPC_Hero:UpgradeAbility(ability)end

--
--available:server
---@return bool
function CDOTA_BaseNPC_Hero:WillReincarnate()end

