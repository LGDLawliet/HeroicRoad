LinkLuaModifier( "modifier_item_hd_broom_handle", "items/item_hd_broom_handle.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_hd_broom_handle == nil then
	item_hd_broom_handle = class({})
end
function item_hd_broom_handle:GetIntrinsicModifierName()
	return "modifier_item_hd_broom_handle"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_hd_broom_handle == nil then
	modifier_item_hd_broom_handle = class({})
end
function modifier_item_hd_broom_handle:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_hd_broom_handle:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_hd_broom_handle:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_hd_broom_handle:DeclareFunctions()
	return {
	}
end