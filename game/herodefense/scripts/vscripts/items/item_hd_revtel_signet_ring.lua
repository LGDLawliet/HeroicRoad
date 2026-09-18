item_hd_revtel_signet_ring = class({})

LinkLuaModifier("modifier_item_hd_revtel_signet_ring", "items/item_hd_revtel_signet_ring", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_revtel_signet_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_revtel_signet_ring"
end






modifier_item_hd_revtel_signet_ring = class({})

function modifier_item_hd_revtel_signet_ring:IsDebuff() return false end
function modifier_item_hd_revtel_signet_ring:IsHidden() return true end
function modifier_item_hd_revtel_signet_ring:IsPurgable() return false end
function modifier_item_hd_revtel_signet_ring:IsPurgeException() return false end
function modifier_item_hd_revtel_signet_ring:RemoveOnDeath() return false end