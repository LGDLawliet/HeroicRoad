creep_special_gain_Perseverance2 = class({})

LinkLuaModifier("modifier_creep_special_gain_Perseverance2", "special_gain/creep_special_gain_Perseverance2", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Perseverance2:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Perseverance2"
end



require('internal/timers')   --计时器功能
modifier_creep_special_gain_Perseverance2 = advanced_modifier({})

function modifier_creep_special_gain_Perseverance2:IsDebuff() return false end
function modifier_creep_special_gain_Perseverance2:IsHidden() return false end
function modifier_creep_special_gain_Perseverance2:IsPurgable() return false end
function modifier_creep_special_gain_Perseverance2:GetEffectName() return "particles/units/heroes/hero_silencer/silencer_last_word_status_ring_edge.vpcf" end
function modifier_creep_special_gain_Perseverance2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_Perseverance2:OnCreated()
  if IsServer() then
    self.bonus_status = self:GetAbility():GetSpecialValueFor("bonus_status")
    self.incoming_down =  self:GetAbility():GetSpecialValueFor("incoming_down")
    self.incoming_down_summon =  self:GetAbility():GetSpecialValueFor("incoming_down_summon")
  end
end


function modifier_creep_special_gain_Perseverance2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance,
    advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_creep_special_gain_Perseverance2:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status
end

function modifier_creep_special_gain_Perseverance2:Advanced_GetModifierIncomingDamage_Percentage(keys)
  if IsServer() then
    if keys.attacker:IsRealHero() then
      return -self.incoming_down
    else
      return  -self.incoming_down_summon
    end
  end
  return 0
end

