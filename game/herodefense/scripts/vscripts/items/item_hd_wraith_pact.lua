LinkLuaModifier( "modifier_item_hd_wraith_pact", "items/item_hd_wraith_pact.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_hd_wraith_pact == nil then
	item_hd_wraith_pact = class({})
end
function item_hd_wraith_pact:GetIntrinsicModifierName()
	return "modifier_item_hd_wraith_pact"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_hd_wraith_pact == nil then
	modifier_item_hd_wraith_pact = class({})
end
function modifier_item_hd_wraith_pact:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_hd_wraith_pact:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_hd_wraith_pact:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_hd_wraith_pact:DeclareFunctions()
	return {
	}
end