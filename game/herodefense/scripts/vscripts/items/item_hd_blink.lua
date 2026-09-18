item_hd_blink =item_hd_blink or  class({})
-- LinkLuaModifier("modifier_item_hd_blink_arua", "items/item_hd_blink", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_blink_arua_effect", "items/item_hd_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_blink", "items/item_hd_blink", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_blink_active", "items/item_hd_blink", LUA_MODIFIER_MOTION_NONE)


-- function item_hd_blink:Precache( context )
-- 	PrecacheResource( "particle", "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", context )

-- end
function item_hd_blink:GetIntrinsicModifierName()
	return "modifier_item_hd_blink"
end



modifier_item_hd_blink = modifier_item_hd_blink or class({})

function modifier_item_hd_blink:IsDebuff() return false end
function modifier_item_hd_blink:IsHidden() return true end
function modifier_item_hd_blink:IsPurgable() return false end
function modifier_item_hd_blink:IsPurgeException() return false end
function modifier_item_hd_blink:RemoveOnDeath() return false end
