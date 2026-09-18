
modifier_custom_ActivityTranslationModifiers = class({})
function modifier_custom_ActivityTranslationModifiers:IsHidden()	return true end
function modifier_custom_ActivityTranslationModifiers:IsPurgable()	return false end
function modifier_custom_ActivityTranslationModifiers:RemoveOnDeath() return false end
function modifier_custom_ActivityTranslationModifiers:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_ActivityTranslationModifiers:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end
function modifier_custom_ActivityTranslationModifiers:Init(name)
	self.activity = name
end

function modifier_custom_ActivityTranslationModifiers:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_custom_ActivityTranslationModifiers:GetActivityTranslationModifiers()	
	return self.activity
end