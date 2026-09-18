item_hd_Yasha_and_Kaya = class({})

LinkLuaModifier("modifier_item_hd_Yasha_and_Kaya", "items/item_hd_Yasha_and_Kaya", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function item_hd_Yasha_and_Kaya:GetIntrinsicModifierName()
	return "modifier_item_hd_Yasha_and_Kaya"
end



modifier_item_hd_Yasha_and_Kaya = advanced_modifier({})

function modifier_item_hd_Yasha_and_Kaya:IsDebuff() return false end
function modifier_item_hd_Yasha_and_Kaya:IsHidden() return true end
function modifier_item_hd_Yasha_and_Kaya:IsPurgable() return false end
-- function modifier_item_hd_Yasha_and_Kaya:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_Yasha_and_Kaya:OnCreated(keys)
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local parent = self:GetParent()
	-- self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = ability:GetSpecialValueFor("bonus_int")
	-- self.bonus_status_resistance = ability:GetSpecialValueFor("bonus_status_resistance")
	self.bonus_Mana_regeneration = ability:GetSpecialValueFor("bonus_Mana_regeneration")
	self.bonus_spell_damage_amplification = ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move = ability:GetSpecialValueFor("bonus_move")
	-- self.bonus_regeneration_amplification = ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self.bonus_heal_amplification = ability:GetSpecialValueFor("bonus_heal_amplification")
    if IsServer() then




	end

end




function modifier_item_hd_Yasha_and_Kaya:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end


function modifier_item_hd_Yasha_and_Kaya:GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_item_hd_Yasha_and_Kaya:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_item_hd_Yasha_and_Kaya:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_item_hd_Yasha_and_Kaya:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move
end
function modifier_item_hd_Yasha_and_Kaya:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_damage_amplification
end




function modifier_item_hd_Yasha_and_Kaya:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return self.bonus_Mana_regeneration
end


-- advanced_modifier
function modifier_item_hd_Yasha_and_Kaya:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_item_hd_Yasha_and_Kaya:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end


