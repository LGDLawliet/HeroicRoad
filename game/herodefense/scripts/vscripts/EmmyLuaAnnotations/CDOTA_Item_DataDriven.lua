---@class CDOTA_Item_DataDriven : CDOTA_Item
CDOTA_Item_DataDriven = 
{
}
--Applies a data driven modifier to the target.
--available:server
---@param caster CDOTA_BaseNPC
---@param target CDOTA_BaseNPC
---@param modifierName string
---@param modifierTable table|nil
---@return nil
function CDOTA_Item_DataDriven:ApplyDataDrivenModifier(caster,target,modifierName,modifierTable)end

--Applies a data driven thinker at the location.
--available:server
---@param caster CDOTA_BaseNPC
---@param location Vector
---@param modifierName string
---@param modifierTable table|nil
---@return CDOTA_Buff
function CDOTA_Item_DataDriven:ApplyDataDrivenThinker(caster,location,modifierName,modifierTable)end

