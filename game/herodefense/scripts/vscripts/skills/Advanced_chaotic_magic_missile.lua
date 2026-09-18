LinkLuaModifier( "modifier_Advanced_chaotic_magic_missile", "skills/Advanced_chaotic_magic_missile.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if Advanced_chaotic_magic_missile == nil then
	Advanced_chaotic_magic_missile = class({})
end
function Advanced_chaotic_magic_missile:GetIntrinsicModifierName()
	return "modifier_Advanced_chaotic_magic_missile"
end
---------------------------------------------------------------------
--Modifiers
if modifier_Advanced_chaotic_magic_missile == nil then
	modifier_Advanced_chaotic_magic_missile = class({})
end
function modifier_Advanced_chaotic_magic_missile:OnCreated(params)
	if IsServer() then
	end
end
function modifier_Advanced_chaotic_magic_missile:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_Advanced_chaotic_magic_missile:OnDestroy()
	if IsServer() then
	end
end
function modifier_Advanced_chaotic_magic_missile:DeclareFunctions()
	return {
	}
end