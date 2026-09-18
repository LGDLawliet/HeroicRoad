LinkLuaModifier( "modifier_Primary_summon_Forge_Spirit", "creeps_spell/Primary_summon_Forge_Spirit.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if Primary_summon_Forge_Spirit == nil then
	Primary_summon_Forge_Spirit = class({})
end
function Primary_summon_Forge_Spirit:GetIntrinsicModifierName()
	return "modifier_Primary_summon_Forge_Spirit"
end
---------------------------------------------------------------------
--Modifiers
if modifier_Primary_summon_Forge_Spirit == nil then
	modifier_Primary_summon_Forge_Spirit = class({})
end
function modifier_Primary_summon_Forge_Spirit:OnCreated(params)
	if IsServer() then
	end
end
function modifier_Primary_summon_Forge_Spirit:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_Primary_summon_Forge_Spirit:OnDestroy()
	if IsServer() then
	end
end
function modifier_Primary_summon_Forge_Spirit:DeclareFunctions()
	return {
	}
end