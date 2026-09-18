LinkLuaModifier( "modifier_nevermore_necromastery_demon", "creeps_spell/nevermore_necromastery_demon.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if nevermore_necromastery_demon == nil then
	nevermore_necromastery_demon = class({})
end
function nevermore_necromastery_demon:GetIntrinsicModifierName()
	return "modifier_nevermore_necromastery_demon"
end
---------------------------------------------------------------------
--Modifiers
if modifier_nevermore_necromastery_demon == nil then
	modifier_nevermore_necromastery_demon = class({})
end
function modifier_nevermore_necromastery_demon:OnCreated(params)
	if IsServer() then
	end
end
function modifier_nevermore_necromastery_demon:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_nevermore_necromastery_demon:OnDestroy()
	if IsServer() then
	end
end
function modifier_nevermore_necromastery_demon:DeclareFunctions()
	return {
	}
end