LinkLuaModifier( "modifier_chaotic_static_storm", "chaotic_spell/class_8/chaotic_static_storm.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if chaotic_static_storm == nil then
	chaotic_static_storm = class({})
end
function chaotic_static_storm:GetIntrinsicModifierName()
	return "modifier_chaotic_static_storm"
end
---------------------------------------------------------------------
--Modifiers
if modifier_chaotic_static_storm == nil then
	modifier_chaotic_static_storm = class({})
end
function modifier_chaotic_static_storm:OnCreated(params)
	if IsServer() then
	end
end
function modifier_chaotic_static_storm:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_chaotic_static_storm:OnDestroy()
	if IsServer() then
	end
end
function modifier_chaotic_static_storm:DeclareFunctions()
	return {
	}
end