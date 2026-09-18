LinkLuaModifier( "modifier_item_hd_artifact_ironwood_tree", "items/item_hd_artifact_ironwood_tree.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_hd_artifact_ironwood_tree == nil then
	item_hd_artifact_ironwood_tree = class({})
end
function item_hd_artifact_ironwood_tree:GetIntrinsicModifierName()
	return "modifier_item_hd_artifact_ironwood_tree"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_hd_artifact_ironwood_tree == nil then
	modifier_item_hd_artifact_ironwood_tree = class({})
end
function modifier_item_hd_artifact_ironwood_tree:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_hd_artifact_ironwood_tree:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_hd_artifact_ironwood_tree:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_hd_artifact_ironwood_tree:DeclareFunctions()
	return {
	}
end