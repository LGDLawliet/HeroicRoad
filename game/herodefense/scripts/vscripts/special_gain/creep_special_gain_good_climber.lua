creep_special_gain_good_climber = class({})

LinkLuaModifier("modifier_creep_special_gain_good_climber", "special_gain/creep_special_gain_good_climber", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_good_climber:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_good_climber"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_good_climber = advanced_modifier({})

function modifier_creep_special_gain_good_climber:IsDebuff() return false end
function modifier_creep_special_gain_good_climber:IsHidden() return false end
function modifier_creep_special_gain_good_climber:IsPurgable() return false end
function modifier_creep_special_gain_good_climber:GetEffectName() return "particles/econ/items/broodmother/brood_ti9/brood_ti9_legs_ambient.vpcf" end
function modifier_creep_special_gain_good_climber:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_good_climber:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
end

function modifier_creep_special_gain_good_climber:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_creep_special_gain_good_climber:Advanced_GetModifier_FlyingPathing()	
	return 1
end


