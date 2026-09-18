
chaotic_rune3_tir = class({})
LinkLuaModifier("modifier_chaotic_rune3_tir", "chaotic_spell/class_1/chaotic_rune3_tir", LUA_MODIFIER_MOTION_NONE)

function chaotic_rune3_tir:GetIntrinsicModifierName() return "modifier_chaotic_rune3_tir" end



modifier_chaotic_rune3_tir = advanced_modifier({})

function modifier_chaotic_rune3_tir:IsDebuff() return false end
function modifier_chaotic_rune3_tir:IsPurgable()	return false end
function modifier_chaotic_rune3_tir:RemoveOnDeath() return false end
function modifier_chaotic_rune3_tir:IsPurgeException() return false end
function modifier_chaotic_rune3_tir:IsHidden() return true end
function modifier_chaotic_rune3_tir:OnCreated(keys)
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_spell_damage = self:GetAbility():GetSpecialValueFor("bonus_spell_damage")
	self.bonus_mana_atb = self:GetAbility():GetSpecialValueFor("bonus_mana_atb")
	self.bonus_spell_damage_lvl = self:GetAbility():GetSpecialValueFor("bonus_spell_damage_lvl")
	if IsServer() then
		self.mana = self.bonus_mana + self.bonus_mana_atb*self:GetParent():GetLevel()
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_rune3_tir:OnIntervalThink()
	self.mana = self.bonus_mana + self.bonus_mana_atb*self:GetParent():GetLevel()
end
function modifier_chaotic_rune3_tir:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_MANA_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
	}
	if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
	end
	if self:GetAbility():GetRuneType()==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION)
	end
	if self:GetAbility():GetRuneType()==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT)
	end

    return funcs
end

-- MODIFIER_EVENT_ON_LEARN_NEW_SPELL = {self:GetParent(),nil},
-- MODIFIER_EVENT_ON_Sell_SPELL = {self:GetParent(),nil},
-- function modifier_chaotic_rune3_tir:AdvancedOnLearnNewSpell(keys)
-- 	if keys.unit==self:GetParent() then
-- 		local ability = keys.ability
-- 	end
-- end

-- function modifier_chaotic_rune3_tir:AdvancedOnSellSpell(keys)
-- 	if keys.unit==self:GetParent() then
-- 		local ability_name = keys.ability_name
-- 	end
-- end

function modifier_chaotic_rune3_tir:AdvancedGetModifierManaBonus()
	return self.mana
end


function modifier_chaotic_rune3_tir:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell_damage + self.bonus_spell_damage_lvl*self:GetParent():GetLevel()
end

function modifier_chaotic_rune3_tir:Advanced_GetModifierBonusStats_Strength()

	return self:GetAbility():GetSpecialValueFor("rune_1_atb")
end
function modifier_chaotic_rune3_tir:Advanced_GetModifierBonusStats_Agility()

	return self:GetAbility():GetSpecialValueFor("rune_1_atb")
end
function modifier_chaotic_rune3_tir:Advanced_GetModifierBonusStats_Intellect()

	return self:GetAbility():GetSpecialValueFor("rune_1_atb")
end

function modifier_chaotic_rune3_tir:Advanced_GetModifierCooldownReduction()

	return self:GetAbility():GetSpecialValueFor("rune_2_cooldown")
end

function modifier_chaotic_rune3_tir:AdvancedGetModifierConstantManaRegen()

	return self:GetAbility():GetSpecialValueFor("rune_3_manaregen")
end