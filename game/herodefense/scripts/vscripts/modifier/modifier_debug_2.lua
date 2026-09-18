modifier_debug_2 = class({})

function modifier_debug_2:IsDebuff()			return false end
function modifier_debug_2:IsHidden() 			return true end
function modifier_debug_2:IsPurgable() 		return false end
function modifier_debug_2:IsPurgeException() 	return false end
function modifier_debug_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end
function modifier_debug_2:GetModifierModelChange()
	return "models/heroes/tiny/tiny_01/tiny_01.vmdl"
end
