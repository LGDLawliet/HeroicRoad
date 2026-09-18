LinkLuaModifier( "modifier_item_str_ring", "items/item_str_ring.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_str_ring == nil then
	item_str_ring = class({})
end
function item_str_ring:GetIntrinsicModifierName()
	return "modifier_item_str_ring"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_str_ring == nil then
	modifier_item_str_ring = class({})
end
function modifier_item_str_ring:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_str_ring:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_str_ring:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_str_ring:DeclareFunctions()
	return {
	}
end