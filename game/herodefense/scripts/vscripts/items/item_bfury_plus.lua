LinkLuaModifier( "modifier_item_bfury_plus", "items/item_bfury_plus.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_bfury_plus == nil then
	item_bfury_plus = class({})
end
function item_bfury_plus:GetIntrinsicModifierName()
	return "modifier_item_bfury_plus"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_bfury_plus == nil then
	modifier_item_bfury_plus = class({})
end
function modifier_item_bfury_plus:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_bfury_plus:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_bfury_plus:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_bfury_plus:DeclareFunctions()
	return {
	}
end