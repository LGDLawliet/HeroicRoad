LinkLuaModifier( "modifier_wisp_spirits_out", "heroTalent/wisp_spirits_out.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wisp_spirits_out == nil then
	wisp_spirits_out = class({})
end
function wisp_spirits_out:GetIntrinsicModifierName()
	return "modifier_wisp_spirits_out"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wisp_spirits_out == nil then
	modifier_wisp_spirits_out = class({})
end
function modifier_wisp_spirits_out:OnCreated(params)
	if IsServer() then
	end
end
function modifier_wisp_spirits_out:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_wisp_spirits_out:OnDestroy()
	if IsServer() then
	end
end
function modifier_wisp_spirits_out:DeclareFunctions()
	return {
	}
end