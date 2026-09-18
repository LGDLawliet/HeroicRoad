creep_special_gain_Rage = class({})

LinkLuaModifier("modifier_creep_special_gain_Rage", "special_gain/creep_special_gain_Rage", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Rage:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Rage"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_Rage = advanced_modifier({})

function modifier_creep_special_gain_Rage:IsDebuff() return false end
function modifier_creep_special_gain_Rage:IsHidden()return false end
function modifier_creep_special_gain_Rage:IsPurgable() return false end
function modifier_creep_special_gain_Rage:GetEffectName() return "particles/econ/courier/courier_red_horn/courier_red_horn_ambient.vpcf" end
function modifier_creep_special_gain_Rage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_Rage:Advanced_GetModifierCriticalStrike( keys )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if keys.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if 20>=RandomInt(0, 100) then
			local damage_mul =220
			return damage_mul
		end
	end
end

function modifier_creep_special_gain_Rage:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end