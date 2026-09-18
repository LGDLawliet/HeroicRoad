LinkLuaModifier( "modifier_Middle_chaotic_magic_missile", "skills/Middle_chaotic_magic_missile.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if Middle_chaotic_magic_missile == nil then
	Middle_chaotic_magic_missile = class({})
end
function Middle_chaotic_magic_missile:GetIntrinsicModifierName()
	return "modifier_Middle_chaotic_magic_missile"
end
---------------------------------------------------------------------
--Modifiers
if modifier_Middle_chaotic_magic_missile == nil then
	modifier_Middle_chaotic_magic_missile = class({})
end
function modifier_Middle_chaotic_magic_missile:OnCreated(params)
	if IsServer() then
	end
end
function modifier_Middle_chaotic_magic_missile:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_Middle_chaotic_magic_missile:OnDestroy()
	if IsServer() then
	end
end
function modifier_Middle_chaotic_magic_missile:DeclareFunctions()
	return {
	}
end