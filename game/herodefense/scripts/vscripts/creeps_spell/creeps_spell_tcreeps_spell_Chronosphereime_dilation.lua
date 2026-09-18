LinkLuaModifier( "modifier_creeps_spell_tcreeps_spell_Chronosphereime_dilation", "creeps_spell/creeps_spell_tcreeps_spell_Chronosphereime_dilation.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if creeps_spell_tcreeps_spell_Chronosphereime_dilation == nil then
	creeps_spell_tcreeps_spell_Chronosphereime_dilation = class({})
end
function creeps_spell_tcreeps_spell_Chronosphereime_dilation:GetIntrinsicModifierName()
	return "modifier_creeps_spell_tcreeps_spell_Chronosphereime_dilation"
end
---------------------------------------------------------------------
--Modifiers
if modifier_creeps_spell_tcreeps_spell_Chronosphereime_dilation == nil then
	modifier_creeps_spell_tcreeps_spell_Chronosphereime_dilation = class({})
end
function modifier_creeps_spell_tcreeps_spell_Chronosphereime_dilation:OnCreated(params)
	if IsServer() then
	end
end
function modifier_creeps_spell_tcreeps_spell_Chronosphereime_dilation:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_creeps_spell_tcreeps_spell_Chronosphereime_dilation:OnDestroy()
	if IsServer() then
	end
end
function modifier_creeps_spell_tcreeps_spell_Chronosphereime_dilation:DeclareFunctions()
	return {
	}
end