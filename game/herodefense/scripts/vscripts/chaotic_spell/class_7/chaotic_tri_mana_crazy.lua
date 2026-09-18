LinkLuaModifier( "modifier_chaotic_tri_mana_crazy", "chaotic_spell/class_7/chaotic_tri_mana_crazy.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if chaotic_tri_mana_crazy == nil then
	chaotic_tri_mana_crazy = class({})
end
function chaotic_tri_mana_crazy:GetIntrinsicModifierName()
	return "modifier_chaotic_tri_mana_crazy"
end
---------------------------------------------------------------------
--Modifiers
if modifier_chaotic_tri_mana_crazy == nil then
	modifier_chaotic_tri_mana_crazy = class({})
end
function modifier_chaotic_tri_mana_crazy:OnCreated(params)
	if IsServer() then
	end
end
function modifier_chaotic_tri_mana_crazy:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_chaotic_tri_mana_crazy:OnDestroy()
	if IsServer() then
	end
end
function modifier_chaotic_tri_mana_crazy:DeclareFunctions()
	return {
	}
end