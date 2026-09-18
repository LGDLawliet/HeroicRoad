
modifier_generic_stunned_short = class({})

function modifier_generic_stunned_short:IsDebuff()			return true end
function modifier_generic_stunned_short:IsHidden() 			return false end
function modifier_generic_stunned_short:IsPurgable() 		return true end
function modifier_generic_stunned_short:IsPurgeException() 	return true end
function modifier_generic_stunned_short:IsStunDebuff() return true end
function modifier_generic_stunned_short:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_generic_stunned_short:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_generic_stunned_short:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_generic_stunned_short:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_generic_stunned_short:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

