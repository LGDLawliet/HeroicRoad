
modifier_generic_stunned_cant_purge = class({})

function modifier_generic_stunned_cant_purge:IsDebuff()			return true end
function modifier_generic_stunned_cant_purge:IsHidden() 			return false end
function modifier_generic_stunned_cant_purge:IsPurgable() 		return false end
function modifier_generic_stunned_cant_purge:IsPurgeException() 	return false end
function modifier_generic_stunned_cant_purge:IsStunDebuff() return true end
function modifier_generic_stunned_cant_purge:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_generic_stunned_cant_purge:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_generic_stunned_cant_purge:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_generic_stunned_cant_purge:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_generic_stunned_cant_purge:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

