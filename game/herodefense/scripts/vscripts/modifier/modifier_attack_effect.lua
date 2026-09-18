
--------------------------------------------------------------------------------
modifier_attack_effect = advanced_modifier({})
function modifier_attack_effect:IsHidden()return true end
function modifier_attack_effect:IsDebuff()return false end
function modifier_attack_effect:IsStunDebuff()return false end
function modifier_attack_effect:IsPurgable()return false end
function modifier_attack_effect:IsPurgeException() 	return false end
function modifier_attack_effect:RemoveOnDeath() return false end
function modifier_attack_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_attack_effect:OnCreated(keys)
	if IsServer() then
		self.iSpecialAttack = keys.iSpecialAttack or 0
		self.iDisableApplyModifier = keys.iDisableApplyModifier or 0
		self.iDisableCleave =keys.iDisableCleave or 0
		self.iDisableSplit = keys.iDisableSplit or 0
	end
end
function modifier_attack_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_SpecialAttack,
		advanced_MODIFIER_PROPERTY_DisableApplyModifier,
		advanced_MODIFIER_PROPERTY_DisableCleave,
		advanced_MODIFIER_PROPERTY_DisableSplit,
    }
end
function modifier_attack_effect:Advanced_GetModifier_SpecialAttack(keys)
	return self.iSpecialAttack or 0
end
function modifier_attack_effect:Advanced_GetModifier_DisableApplyModifier(keys)
	return self.iDisableApplyModifier or 0
end
function modifier_attack_effect:Advanced_GetModifier_DisableCleave(keys)
	return self.iDisableCleave or 0
end
function modifier_attack_effect:Advanced_GetModifier_DisableSplit(keys)
	return self.iDisableSplit or 0
end


