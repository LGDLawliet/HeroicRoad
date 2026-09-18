item_hd_vambrace_int = class({})
-- LinkLuaModifier("modifier_item_hd_vambrace_int_arua", "items/item_hd_vambrace_int", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_int_arua_effect", "items/item_hd_vambrace_int", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_vambrace_int", "items/item_hd_vambrace_int", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_int_active", "items/item_hd_vambrace_int", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_int_active_standby", "items/item_hd_vambrace_int", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_int_active_debuff", "items/item_hd_vambrace_int", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_vambrace_int:GetIntrinsicModifierName()
	return "modifier_item_hd_vambrace_int"
end




modifier_item_hd_vambrace_int = advanced_modifier({})

function modifier_item_hd_vambrace_int:IsDebuff() return false end
function modifier_item_hd_vambrace_int:IsHidden() return true end
function modifier_item_hd_vambrace_int:IsPurgable() return false end


function modifier_item_hd_vambrace_int:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")

    if IsServer() then

	end
end


function modifier_item_hd_vambrace_int:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

	}
end


function modifier_item_hd_vambrace_int:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_vambrace_int:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_vambrace_int:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_vambrace_int:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification end

function modifier_item_hd_vambrace_int:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end