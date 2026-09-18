creep_special_gain_mana_gain = class({})

LinkLuaModifier("modifier_creep_special_gain_mana_gain", "special_gain/creep_special_gain_mana_gain", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_mana_gain:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_mana_gain"
end



modifier_creep_special_gain_mana_gain = advanced_modifier({})

function modifier_creep_special_gain_mana_gain:IsDebuff() return false end
function modifier_creep_special_gain_mana_gain:IsHidden() return false end
function modifier_creep_special_gain_mana_gain:IsPurgable() return false end
function modifier_creep_special_gain_mana_gain:GetEffectName() return "particles/units/heroes/hero_visage/visage_ambient.vpcf" end
function modifier_creep_special_gain_mana_gain:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_mana_gain:OnCreated(keys)
	self.bonus_spell_damage_gain = self:GetAbility():GetSpecialValueFor("bonus_spell_damage_gain")
end


function modifier_creep_special_gain_mana_gain:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_creep_special_gain_mana_gain:Advanced_GetModifierSpellAmplifyBonus() 	return self.bonus_spell_damage_gain end


