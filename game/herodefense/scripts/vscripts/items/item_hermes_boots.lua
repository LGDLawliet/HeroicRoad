LinkLuaModifier( "modifier_item_hermes_boots", "items/item_hermes_boots.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_hermes_boots == nil then
	item_hermes_boots = class({})
end
function item_hermes_boots:GetIntrinsicModifierName()
	return "modifier_item_hermes_boots"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_hermes_boots == nil then
	modifier_item_hermes_boots = class({})
end
function modifier_item_hermes_boots:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_hermes_boots:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_hermes_boots:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_hermes_boots:DeclareFunctions()
	return {
	}
end