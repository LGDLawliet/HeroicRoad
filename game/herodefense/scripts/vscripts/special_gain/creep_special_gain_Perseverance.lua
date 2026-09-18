creep_special_gain_Perseverance = class({})

LinkLuaModifier("modifier_creep_special_gain_Perseverance", "special_gain/creep_special_gain_Perseverance", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Perseverance:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Perseverance"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_Perseverance = advanced_modifier({})

function modifier_creep_special_gain_Perseverance:IsDebuff() return false end
function modifier_creep_special_gain_Perseverance:IsHidden() return false end
function modifier_creep_special_gain_Perseverance:IsPurgable() return false end
function modifier_creep_special_gain_Perseverance:GetEffectName() return "particles/units/heroes/hero_silencer/silencer_last_word_status_ring_edge.vpcf" end
function modifier_creep_special_gain_Perseverance:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_Perseverance:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creep_special_gain_Perseverance:Advanced_GetModifier_StatusResistance(keys)
	return 40
end

