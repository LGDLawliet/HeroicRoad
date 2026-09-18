Middle_Inner_Beast = class({})
-- LinkLuaModifier("modifier_Middle_Inner_Beast_arua", "items/Middle_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Inner_Beast_arua_effect", "skills/Middle_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Inner_Beast", "skills/Middle_Inner_Beast", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function Middle_Inner_Beast:GetIntrinsicModifierName()
	return "modifier_Middle_Inner_Beast"
end




modifier_Middle_Inner_Beast = class({})

function modifier_Middle_Inner_Beast:IsDebuff() return false end
function modifier_Middle_Inner_Beast:IsHidden() return true end
function modifier_Middle_Inner_Beast:IsPurgable() 		return false end
function modifier_Middle_Inner_Beast:IsPurgeException() 	return false end
function modifier_Middle_Inner_Beast:RemoveOnDeath()  return false end
function modifier_Middle_Inner_Beast:IsAura() return true end
function modifier_Middle_Inner_Beast:GetAuraDuration() return 0.5 end
function modifier_Middle_Inner_Beast:GetModifierAura() return "modifier_Middle_Inner_Beast_arua_effect" end
function modifier_Middle_Inner_Beast:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_Middle_Inner_Beast:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Middle_Inner_Beast:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Middle_Inner_Beast:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_Middle_Inner_Beast:GetAuraEntityReject(hEntity)

-- 	if hEntity == self:GetParent() then
-- 		return true
-- 	end
-- 	return false
-- end







modifier_Middle_Inner_Beast_arua_effect = class({})

function modifier_Middle_Inner_Beast_arua_effect:IsDebuff() return false end
function modifier_Middle_Inner_Beast_arua_effect:IsHidden() return false end
function modifier_Middle_Inner_Beast_arua_effect:IsPurgable() return false end
function modifier_Middle_Inner_Beast_arua_effect:OnCreated()
	self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if not self:GetParent():IsRealHero() then
		self.attack_speed = self.attack_speed *0.5
	end
end


function modifier_Middle_Inner_Beast_arua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_Middle_Inner_Beast_arua_effect:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed 
end

function modifier_Middle_Inner_Beast_arua_effect:GetModifierMoveSpeedBonus_Percentage()
	return 20
end