item_hd_Kaya_and_Sange = class({})

LinkLuaModifier("modifier_item_hd_Kaya_and_Sange", "items/item_hd_Kaya_and_Sange", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function item_hd_Kaya_and_Sange:GetIntrinsicModifierName()
	return "modifier_item_hd_Kaya_and_Sange"
end



modifier_item_hd_Kaya_and_Sange = advanced_modifier({})

function modifier_item_hd_Kaya_and_Sange:IsDebuff() return false end
function modifier_item_hd_Kaya_and_Sange:IsHidden() return true end
function modifier_item_hd_Kaya_and_Sange:IsPurgable() return false end
-- function modifier_item_hd_Kaya_and_Sange:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_Kaya_and_Sange:OnCreated(keys)
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_int = ability:GetSpecialValueFor("bonus_int")
	self.bonus_status_resistance = ability:GetSpecialValueFor("bonus_status_resistance")
	self.bonus_Mana_regeneration = ability:GetSpecialValueFor("bonus_Mana_regeneration")
	self.bonus_spell_damage_amplification = ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.bonus_regeneration_amplification = ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self.bonus_heal_amplification = ability:GetSpecialValueFor("bonus_heal_amplification")

end



function modifier_item_hd_Kaya_and_Sange:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_hd_Kaya_and_Sange:GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_item_hd_Kaya_and_Sange:GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_item_hd_Kaya_and_Sange:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_damage_amplification
end


function modifier_item_hd_Kaya_and_Sange:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return self.bonus_regeneration_amplification
end


function modifier_item_hd_Kaya_and_Sange:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return self.bonus_Mana_regeneration
end

-- advanced_modifier
function modifier_item_hd_Kaya_and_Sange:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_item_hd_Kaya_and_Sange:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end

function modifier_item_hd_Kaya_and_Sange:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return self.bonus_regeneration_amplification
end
function modifier_item_hd_Kaya_and_Sange:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

