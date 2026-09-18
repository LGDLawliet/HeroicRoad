LinkLuaModifier( "modifier_Primary_split_earth", "creeps_spell/Primary_split_earth.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if Primary_split_earth == nil then
	Primary_split_earth = class({})
end
function Primary_split_earth:GetIntrinsicModifierName()
	return "modifier_Primary_split_earth"
end
---------------------------------------------------------------------
--Modifiers
if modifier_Primary_split_earth == nil then
	modifier_Primary_split_earth = class({})
end
function modifier_Primary_split_earth:OnCreated(params)
	if IsServer() then
	end
end
function modifier_Primary_split_earth:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_Primary_split_earth:OnDestroy()
	if IsServer() then
	end
end
function modifier_Primary_split_earth:DeclareFunctions()
	return {
	}
end