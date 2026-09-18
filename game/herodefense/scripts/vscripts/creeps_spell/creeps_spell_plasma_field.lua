LinkLuaModifier( "modifier_creeps_spell_plasma_field", "creeps_spell/creeps_spell_plasma_field.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if creeps_spell_plasma_field == nil then
	creeps_spell_plasma_field = class({})
end
function creeps_spell_plasma_field:GetIntrinsicModifierName()
	return "modifier_creeps_spell_plasma_field"
end
---------------------------------------------------------------------
--Modifiers
if modifier_creeps_spell_plasma_field == nil then
	modifier_creeps_spell_plasma_field = class({})
end
function modifier_creeps_spell_plasma_field:OnCreated(params)
	if IsServer() then
	end
end
function modifier_creeps_spell_plasma_field:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_creeps_spell_plasma_field:OnDestroy()
	if IsServer() then
	end
end
function modifier_creeps_spell_plasma_field:DeclareFunctions()
	return {
	}
end