item_hd_advanced_keen_optic = class({})

LinkLuaModifier("modifier_item_hd_advanced_keen_optic", "items/item_hd_advanced_keen_optic", LUA_MODIFIER_MOTION_NONE)
function item_hd_advanced_keen_optic:GetIntrinsicModifierName()
	return "modifier_item_hd_advanced_keen_optic"
end





modifier_item_hd_advanced_keen_optic = advanced_modifier({})

function modifier_item_hd_advanced_keen_optic:IsDebuff() return false end
function modifier_item_hd_advanced_keen_optic:IsHidden() return true end
function modifier_item_hd_advanced_keen_optic:IsPurgable() return false end


function modifier_item_hd_advanced_keen_optic:OnCreated(keys)
 
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("attack_range")
	self.bonus_spell_range = self:GetAbility():GetSpecialValueFor("cast_range")
end



function modifier_item_hd_advanced_keen_optic:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.bonus_attack_range or 0 end

function modifier_item_hd_advanced_keen_optic:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
end
function modifier_item_hd_advanced_keen_optic:Advanced_GetModifierCastRangeBonusStacking(keys)
    return self.bonus_spell_range
end
