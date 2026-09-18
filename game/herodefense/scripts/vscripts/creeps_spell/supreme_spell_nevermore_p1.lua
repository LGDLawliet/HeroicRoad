LinkLuaModifier( "modifier_supreme_spell_nevermore_p1", "creeps_spell/supreme_spell_nevermore_p1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if supreme_spell_nevermore_p1 == nil then
	supreme_spell_nevermore_p1 = class({})
end
function supreme_spell_nevermore_p1:GetIntrinsicModifierName()
	return "modifier_supreme_spell_nevermore_p1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_supreme_spell_nevermore_p1 == nil then
	modifier_supreme_spell_nevermore_p1 = class({})
end
function modifier_supreme_spell_nevermore_p1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_supreme_spell_nevermore_p1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_supreme_spell_nevermore_p1:OnDestroy()
	if IsServer() then
	end
end
function modifier_supreme_spell_nevermore_p1:DeclareFunctions()
	return {
	}
end