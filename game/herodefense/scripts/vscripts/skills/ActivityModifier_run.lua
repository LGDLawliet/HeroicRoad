LinkLuaModifier( "modifier_ActivityModifier_run", "skills/ActivityModifier_run.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if ActivityModifier_run == nil then
	ActivityModifier_run = class({})
end
function ActivityModifier_run:GetIntrinsicModifierName()
	return "modifier_ActivityModifier_run"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ActivityModifier_run == nil then
	modifier_ActivityModifier_run = class({})
end
function modifier_ActivityModifier_run:OnCreated(params)
	if IsServer() then
	end
end
function modifier_ActivityModifier_run:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_ActivityModifier_run:OnDestroy()
	if IsServer() then
	end
end
function modifier_ActivityModifier_run:DeclareFunctions()
	return {
	}
end