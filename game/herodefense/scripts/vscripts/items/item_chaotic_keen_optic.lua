item_chaotic_keen_optic = class({})

LinkLuaModifier("modifier_item_chaotic_keen_optic", "items/item_chaotic_keen_optic", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_keen_optic:GetIntrinsicModifierName()
	return "modifier_item_chaotic_keen_optic"
end
---------------------------------

modifier_item_chaotic_keen_optic = advanced_modifier({})

function modifier_item_chaotic_keen_optic:IsDebuff() return false end
function modifier_item_chaotic_keen_optic:IsHidden() return true end
function modifier_item_chaotic_keen_optic:IsPurgable() return false end

function modifier_item_chaotic_keen_optic:OnCreated(keys)
    self.ability = self:GetAbility()
	self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
    self.bonus_cast_range = self.ability:GetSpecialValueFor("bonus_cast_range")
end

function modifier_item_chaotic_keen_optic:AdvancedGetModifierConstantManaRegen()	return self.mana_regen end
function modifier_item_chaotic_keen_optic:Advanced_GetModifierCastRangeBonusStacking(keys)
	return self.bonus_cast_range
end

function modifier_item_chaotic_keen_optic:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,

    }
end
