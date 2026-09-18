
modifier_generic_stunned_long = class({})

function modifier_generic_stunned_long:IsDebuff()			return true end
function modifier_generic_stunned_long:IsHidden() 			return false end
function modifier_generic_stunned_long:IsPurgable() 		return true end
function modifier_generic_stunned_long:IsPurgeException() 	return true end
function modifier_generic_stunned_long:IsStunDebuff() return true end
function modifier_generic_stunned_long:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_generic_stunned_long:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_generic_stunned_long:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_generic_stunned_long:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_generic_stunned_long:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

