LinkLuaModifier( "modifier_hd_tidehunter_ravage", "skills/HeroAbility/tidehunter/hd_tidehunter_ravage.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if hd_tidehunter_ravage == nil then
	hd_tidehunter_ravage = class({})
end
function hd_tidehunter_ravage:GetIntrinsicModifierName()
	return "modifier_hd_tidehunter_ravage"
end
---------------------------------------------------------------------
--Modifiers
if modifier_hd_tidehunter_ravage == nil then
	modifier_hd_tidehunter_ravage = class({})
end
function modifier_hd_tidehunter_ravage:OnCreated(params)
	if IsServer() then
	end
end
function modifier_hd_tidehunter_ravage:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_hd_tidehunter_ravage:OnDestroy()
	if IsServer() then
	end
end
function modifier_hd_tidehunter_ravage:DeclareFunctions()
	return {
	}
end