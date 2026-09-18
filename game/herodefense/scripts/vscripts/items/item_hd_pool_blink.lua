item_hd_pool_blink = class({})


LinkLuaModifier("modifier_item_hd_pool_blink", "items/item_hd_pool_blink", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function item_hd_pool_blink:GetIntrinsicModifierName()
	return "modifier_item_hd_pool_blink"
end




modifier_item_hd_pool_blink = advanced_modifier({})

function modifier_item_hd_pool_blink:IsDebuff() return false end
function modifier_item_hd_pool_blink:IsHidden() return true end
function modifier_item_hd_pool_blink:IsPurgable() return false end
function modifier_item_hd_pool_blink:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE
    }
end
function modifier_item_hd_pool_blink:Advanced_GetModifier_DefaultMoveCastRange(keys)
	return 200
end
