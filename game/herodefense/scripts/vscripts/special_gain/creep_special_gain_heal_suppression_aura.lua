creep_special_gain_heal_suppression_aura = class({})

LinkLuaModifier("modifier_creep_special_gain_heal_suppression_aura", "special_gain/creep_special_gain_heal_suppression_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_heal_suppression", "special_gain/creep_special_gain_heal_suppression_aura", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_heal_suppression_aura:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_heal_suppression_aura"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_heal_suppression_aura = class({})

function modifier_creep_special_gain_heal_suppression_aura:IsDebuff() return false end
function modifier_creep_special_gain_heal_suppression_aura:IsHidden() return false end
function modifier_creep_special_gain_heal_suppression_aura:IsPurgable() return false end
function modifier_creep_special_gain_heal_suppression_aura:GetEffectName() 	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf" end
function modifier_creep_special_gain_heal_suppression_aura:GetStatusEffectName() 	return "particles/status_fx/status_effect_necrolyte_spirit.vpcf" end
function modifier_creep_special_gain_heal_suppression_aura:IsAura()	return not self:GetParent():PassivesDisabled() end
function modifier_creep_special_gain_heal_suppression_aura:GetModifierAura()	return  "modifier_creep_special_gain_heal_suppression" end
function modifier_creep_special_gain_heal_suppression_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creep_special_gain_heal_suppression_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_ALL end
function modifier_creep_special_gain_heal_suppression_aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor( "radius" ) end
function modifier_creep_special_gain_heal_suppression_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end



modifier_creep_special_gain_heal_suppression = advanced_modifier({})

--------------------------------------------------------------------------------
function modifier_creep_special_gain_heal_suppression:IsDebuff() return true end
function modifier_creep_special_gain_heal_suppression:IsHidden() return false end
function modifier_creep_special_gain_heal_suppression:IsPurgable()	return false end
-- function modifier_creep_special_gain_heal_suppression:GetEffectName()	return "particles/items4_fx/spirit_vessel_damage.vpcf" end

function modifier_creep_special_gain_heal_suppression:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end




-- advanced_modifier
function modifier_creep_special_gain_heal_suppression:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_creep_special_gain_heal_suppression:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -30
end
