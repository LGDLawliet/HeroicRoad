
modifier_generic_animation_frozen = class({})

function modifier_generic_animation_frozen:IsDebuff()			return false end
function modifier_generic_animation_frozen:IsHidden() 			return true end
function modifier_generic_animation_frozen:IsPurgable() 		return false end
function modifier_generic_animation_frozen:IsPurgeException() 	return false end
function modifier_generic_animation_frozen:IsStunDebuff() return false end
function modifier_generic_animation_frozen:CheckState() local state = {[MODIFIER_STATE_FROZEN] = true,  } return state end


