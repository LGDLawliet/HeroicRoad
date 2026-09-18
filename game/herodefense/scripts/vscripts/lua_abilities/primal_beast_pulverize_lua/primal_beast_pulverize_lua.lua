LinkLuaModifier( "modifier_primal_beast_pulverize_lua", "lua_abilities/primal_beast_pulverize_lua/primal_beast_pulverize_lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if primal_beast_pulverize_lua == nil then
	primal_beast_pulverize_lua = class({})
end
function primal_beast_pulverize_lua:GetIntrinsicModifierName()
	return "modifier_primal_beast_pulverize_lua"
end
---------------------------------------------------------------------
--Modifiers
if modifier_primal_beast_pulverize_lua == nil then
	modifier_primal_beast_pulverize_lua = class({})
end
function modifier_primal_beast_pulverize_lua:OnCreated(params)
	if IsServer() then
	end
end
function modifier_primal_beast_pulverize_lua:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_primal_beast_pulverize_lua:OnDestroy()
	if IsServer() then
	end
end
function modifier_primal_beast_pulverize_lua:DeclareFunctions()
	return {
	}
end