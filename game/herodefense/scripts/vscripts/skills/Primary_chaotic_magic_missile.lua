LinkLuaModifier( "modifier_Primary_chaotic_magic_missile", "skills/Primary_chaotic_magic_missile.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if Primary_chaotic_magic_missile == nil then
	Primary_chaotic_magic_missile = class({})
end
function Primary_chaotic_magic_missile:GetIntrinsicModifierName()
	return "modifier_Primary_chaotic_magic_missile"
end
---------------------------------------------------------------------
--Modifiers
if modifier_Primary_chaotic_magic_missile == nil then
	modifier_Primary_chaotic_magic_missile = class({})
end
function modifier_Primary_chaotic_magic_missile:OnCreated(params)
	if IsServer() then
	end
end
function modifier_Primary_chaotic_magic_missile:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_Primary_chaotic_magic_missile:OnDestroy()
	if IsServer() then
	end
end
function modifier_Primary_chaotic_magic_missile:DeclareFunctions()
	return {
	}
end