LinkLuaModifier( "modifier_highroller", "heroTalent/talent/highroller.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if highroller == nil then
	highroller = class({})
end
function highroller:GetIntrinsicModifierName()
	return "modifier_highroller"
end
---------------------------------------------------------------------
--Modifiers
if modifier_highroller == nil then
	modifier_highroller = class({})
end
function modifier_highroller:OnCreated(params)
	if IsServer() then
	end
end
function modifier_highroller:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_highroller:OnDestroy()
	if IsServer() then
	end
end
function modifier_highroller:DeclareFunctions()
	return {
	}
end