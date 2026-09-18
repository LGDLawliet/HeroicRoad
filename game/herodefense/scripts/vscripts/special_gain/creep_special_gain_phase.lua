creep_special_gain_phase = class({})

LinkLuaModifier("modifier_creep_special_gain_phase", "special_gain/creep_special_gain_phase", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_phase:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_phase"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_phase = class({})

function modifier_creep_special_gain_phase:IsDebuff() return false end
function modifier_creep_special_gain_phase:IsHidden() return false end
function modifier_creep_special_gain_phase:IsPurgable() return false end
function modifier_creep_special_gain_phase:GetEffectName() return "particles/units/heroes/hero_morphling/morphling_ambient_new_.vpcf" end
function modifier_creep_special_gain_phase:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_phase:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	

	
end

function modifier_creep_special_gain_phase:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}

	return state
end