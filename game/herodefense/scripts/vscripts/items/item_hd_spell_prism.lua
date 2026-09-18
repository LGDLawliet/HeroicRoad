item_hd_spell_prism = class({})

LinkLuaModifier("modifier_item_hd_spell_prism", "items/item_hd_spell_prism", LUA_MODIFIER_MOTION_NONE)


function item_hd_spell_prism:GetIntrinsicModifierName()
	return "modifier_item_hd_spell_prism"
end




modifier_item_hd_spell_prism = advanced_modifier({})

function modifier_item_hd_spell_prism:IsDebuff() return false end
function modifier_item_hd_spell_prism:IsHidden() return true end
function modifier_item_hd_spell_prism:IsPurgable() return false end


function modifier_item_hd_spell_prism:OnCreated(keys)
    local ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = ability:GetSpecialValueFor("bonus_int")


	self.bonus_mana_regeneration = ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_cooldown  = ability:GetSpecialValueFor("bonus_cooldown")

end



function modifier_item_hd_spell_prism:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		-- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,              --冷却时间


		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,         --技能伤害
	
	}
end


function modifier_item_hd_spell_prism:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_spell_prism:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_spell_prism:GetModifierBonusStats_Agility()	return self.bonus_agi end

function modifier_item_hd_spell_prism:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
-- function modifier_item_hd_spell_prism:GetModifierPercentageCooldown()    return self.bonus_cooldown end

function modifier_item_hd_spell_prism:Advanced_GetModifierSpellAmplifyBonus()  
	return self:GetParent():GetHealthPercent()==100 and 40 or -15
end


function modifier_item_hd_spell_prism:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_spell_prism:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end
