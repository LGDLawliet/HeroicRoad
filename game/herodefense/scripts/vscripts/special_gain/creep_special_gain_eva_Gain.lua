creep_special_gain_eva_Gain = class({})


LinkLuaModifier("modifier_creep_special_gain_eva_Gain", "special_gain/creep_special_gain_eva_Gain", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_eva_Gain_talent", "creep_special_gain_eva_Gain", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_eva_Gain:IsHiddenWhenStolen() 		return false end
function creep_special_gain_eva_Gain:IsRefreshable() 			return true end
function creep_special_gain_eva_Gain:IsStealable() 				return true end
function creep_special_gain_eva_Gain:IsNetherWardStealable()		return true end

function creep_special_gain_eva_Gain:GetIntrinsicModifierName() return "modifier_creep_special_gain_eva_Gain" end



modifier_creep_special_gain_eva_Gain = class({})

function modifier_creep_special_gain_eva_Gain:IsDebuff()			return false end
function modifier_creep_special_gain_eva_Gain:IsHidden() 			return false end
function modifier_creep_special_gain_eva_Gain:IsPurgable() 		return false end
function modifier_creep_special_gain_eva_Gain:IsPurgeException() 	return false end
function modifier_creep_special_gain_eva_Gain:GetEffectName() return "particles/basic_extend/status_effect_blur_creeps.vpcf" end
function modifier_creep_special_gain_eva_Gain:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_eva_Gain:DeclareFunctions() return {MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_creep_special_gain_eva_Gain:GetModifierEvasion_Constant() return self:GetParent():IsEvadeDisabled() and 0 or self:GetAbility():GetSpecialValueFor("evasion") end
