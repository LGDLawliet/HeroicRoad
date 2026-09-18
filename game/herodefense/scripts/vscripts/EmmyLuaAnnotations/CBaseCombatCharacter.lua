---@class CBaseCombatCharacter : CBaseFlex
CBaseCombatCharacter = 
{
}
--Returns an array of all the equipped weapons.
--available:server
---@return table
function CBaseCombatCharacter:GetEquippedWeapons()end

--Gets the number of weapons currently equipped.
--available:server
---@return int
function CBaseCombatCharacter:GetWeaponCount()end

