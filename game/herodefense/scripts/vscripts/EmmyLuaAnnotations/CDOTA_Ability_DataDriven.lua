---@class CDOTA_Ability_DataDriven : CDOTABaseAbility
CDOTA_Ability_DataDriven = 
{
}
--Applies a data driven modifier to the target.
--available:server
---@param caster CDOTA_BaseNPC
---@param target CDOTA_BaseNPC
---@param modifierName string
---@param modifierTable table|nil
---@return CDOTA_Buff
function CDOTA_Ability_DataDriven:ApplyDataDrivenModifier(caster,target,modifierName,modifierTable)end

--Applies a data driven thinker at the location.
--available:server
---@param caster CDOTA_BaseNPC
---@param location Vector
---@param modifierName string
---@param modifierTable table|nil
---@return CDOTA_Buff
function CDOTA_Ability_DataDriven:ApplyDataDrivenThinker(caster,location,modifierName,modifierTable)end

