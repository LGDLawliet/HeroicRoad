LinkLuaModifier( "modifier_ActivityModifier_dis_2022", "skills/ActivityModifier_dis_2022.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if ActivityModifier_dis_2022 == nil then
	ActivityModifier_dis_2022 = class({})
end
function ActivityModifier_dis_2022:GetIntrinsicModifierName()
	return "modifier_ActivityModifier_dis_2022"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ActivityModifier_dis_2022 == nil then
	modifier_ActivityModifier_dis_2022 = class({})
end
function modifier_ActivityModifier_dis_2022:OnCreated(params)
	if IsServer() then
	end
end
function modifier_ActivityModifier_dis_2022:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_ActivityModifier_dis_2022:OnDestroy()
	if IsServer() then
	end
end
function modifier_ActivityModifier_dis_2022:DeclareFunctions()
	return {
	}
end