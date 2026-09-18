item_hd_keen_optic = class({})
-- LinkLuaModifier("modifier_item_hd_keen_optic_arua", "items/item_hd_keen_optic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_keen_optic_arua_effect", "items/item_hd_keen_optic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_keen_optic", "items/item_hd_keen_optic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_keen_optic_active", "items/item_hd_keen_optic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_keen_optic_active_standby", "items/item_hd_keen_optic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_keen_optic_active_debuff", "items/item_hd_keen_optic", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_keen_optic:GetIntrinsicModifierName()
	return "modifier_item_hd_keen_optic"
end





modifier_item_hd_keen_optic = advanced_modifier({})

function modifier_item_hd_keen_optic:IsDebuff() return false end
function modifier_item_hd_keen_optic:IsHidden() return true end
function modifier_item_hd_keen_optic:IsPurgable() return false end

function modifier_item_hd_keen_optic:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
    self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
    self:StartIntervalThink(1)
end

function modifier_item_hd_keen_optic:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_chaos_form") or self:GetCaster():FindAbilityByName("Middle_chaos_form") or self:GetCaster():FindAbilityByName("Advanced_chaos_form") then
		self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration") + self.ability:GetSpecialValueFor("bonus_mana_regeneration_extra")
        self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range") + self.ability:GetSpecialValueFor("bonus_spell_range_extra")
    else
        self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
        self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
    end
end

function modifier_item_hd_keen_optic:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end

function modifier_item_hd_keen_optic:Advanced_GetModifierCastRangeBonusStacking(keys)
	return self.bonus_spell_range
end




function modifier_item_hd_keen_optic:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,

    }
end
