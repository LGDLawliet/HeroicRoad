---@class CBasePlayer : CBaseCombatCharacter
CBasePlayer = 
{
}
--Returns the player's user id.
--available:server
---@return int
function CBasePlayer:GetUserID()end

--Returns true if the player is in noclip mode.
--available:server
---@return bool
function CBasePlayer:IsNoclipping()end

