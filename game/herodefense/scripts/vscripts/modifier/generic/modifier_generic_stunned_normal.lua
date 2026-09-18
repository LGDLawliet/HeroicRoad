
modifier_generic_stunned_normal = class({})

function modifier_generic_stunned_normal:IsDebuff()			return true end
function modifier_generic_stunned_normal:IsHidden() 			return false end
function modifier_generic_stunned_normal:IsPurgable() 		return true end
function modifier_generic_stunned_normal:IsPurgeException() 	return true end
function modifier_generic_stunned_normal:IsStunDebuff() return true end
function modifier_generic_stunned_normal:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_generic_stunned_normal:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_generic_stunned_normal:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_generic_stunned_normal:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_generic_stunned_normal:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

