---@class CDOTA_BaseNPC_Creature : CDOTA_BaseNPC
CDOTA_BaseNPC_Creature = 
{
}
--Add the specified item drop to this creature.
--available:server
---@param dropData table
---@return nil
function CDOTA_BaseNPC_Creature:AddItemDrop(dropData)end

--Level the creature up by the specified number of levels.
--available:server
---@param levels int
---@return nil
function CDOTA_BaseNPC_Creature:CreatureLevelUp(levels)end

--Set creature's current disable resistance.
--available:server
---@return float
function CDOTA_BaseNPC_Creature:GetDisableResistance()end

--Set creature's current disable resistance from ultimates.
--available:server
---@return float
function CDOTA_BaseNPC_Creature:GetUltimateDisableResistance()end

--Is this unit a champion?
--available:server
---@return bool
function CDOTA_BaseNPC_Creature:IsChampion()end

--Is this creature respawning?
--available:server
---@return bool
function CDOTA_BaseNPC_Creature:IsReincarnating()end

--Remove all item drops from this creature.
--available:server
---@return nil
function CDOTA_BaseNPC_Creature:RemoveAllItemDrops()end

--Set the armor gained per level on this creature.
--available:server
---@param armorGain float
---@return nil
function CDOTA_BaseNPC_Creature:SetArmorGain(armorGain)end

--Set the attack time gained per level on this creature.
--available:server
---@param attackTimeGain float
---@return nil
function CDOTA_BaseNPC_Creature:SetAttackTimeGain(attackTimeGain)end

--Set the bounty gold gained per level on this creature.
--available:server
---@param bountyGain int
---@return nil
function CDOTA_BaseNPC_Creature:SetBountyGain(bountyGain)end

--Flag this unit as a champion creature.
--available:server
---@param isChampion bool
---@return nil
function CDOTA_BaseNPC_Creature:SetChampion(isChampion)end

--Set the damage gained per level on this creature.
--available:server
---@param damageGain int
---@return nil
function CDOTA_BaseNPC_Creature:SetDamageGain(damageGain)end

--Set creature's current disable resistance.
--available:server
---@param disableResistance float
---@return nil
function CDOTA_BaseNPC_Creature:SetDisableResistance(disableResistance)end

--Set the disable resistance gained per level on this creature.
--available:server
---@param disableResistanceGain float
---@return nil
function CDOTA_BaseNPC_Creature:SetDisableResistanceGain(disableResistanceGain)end

--Set the hit points gained per level on this creature.
--available:server
---@param hpGain int
---@return nil
function CDOTA_BaseNPC_Creature:SetHPGain(hpGain)end

--Set the hit points regen gained per level on this creature.
--available:server
---@param hpRegenGain float
---@return nil
function CDOTA_BaseNPC_Creature:SetHPRegenGain(hpRegenGain)end

--Set the magic resistance gained per level on this creature.
--available:server
---@param magicResistanceGain float
---@return nil
function CDOTA_BaseNPC_Creature:SetMagicResistanceGain(magicResistanceGain)end

--Set the mana points gained per level on this creature.
--available:server
---@param manaGain int
---@return nil
function CDOTA_BaseNPC_Creature:SetManaGain(manaGain)end

--Set the mana points regen gained per level on this creature.
--available:server
---@param manaRegenGain float
---@return nil
function CDOTA_BaseNPC_Creature:SetManaRegenGain(manaRegenGain)end

--Set the move speed gained per level on this creature.
--available:server
---@param moveSpeedGain int
---@return nil
function CDOTA_BaseNPC_Creature:SetMoveSpeedGain(moveSpeedGain)end

--Set whether creatures require reaching their end path before becoming idle.
--available:server
---@param requiresReachingEndPath bool
---@return nil
function CDOTA_BaseNPC_Creature:SetRequiresReachingEndPath(requiresReachingEndPath)end

--Set creature's current disable resistance from ultimates.
--available:server
---@param ultDisableResistance float
---@return nil
function CDOTA_BaseNPC_Creature:SetUltimateDisableResistance(ultDisableResistance)end

--Set the XP gained per level on this creature.
--available:server
---@param xpGain int
---@return nil
function CDOTA_BaseNPC_Creature:SetXPGain(xpGain)end

