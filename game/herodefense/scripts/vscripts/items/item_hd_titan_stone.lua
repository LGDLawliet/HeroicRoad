item_hd_titan_stone = class({})
-- LinkLuaModifier("modifier_item_hd_titan_stone_arua", "items/item_hd_titan_stone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_titan_stone_arua_effect", "items/item_hd_titan_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_titan_stone", "items/item_hd_titan_stone", LUA_MODIFIER_MOTION_NONE)


function item_hd_titan_stone:GetIntrinsicModifierName()
	return "modifier_item_hd_titan_stone"
end


modifier_item_hd_titan_stone = advanced_modifier({})

function modifier_item_hd_titan_stone:IsDebuff() return false end
function modifier_item_hd_titan_stone:IsHidden() return true end
function modifier_item_hd_titan_stone:IsPurgable() return false end



function modifier_item_hd_titan_stone:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_status_resistance")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	self.bonus_basic_damage = self.ability:GetSpecialValueFor("bonus_basic_damage")
end



function modifier_item_hd_titan_stone:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_item_hd_titan_stone:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end
function modifier_item_hd_titan_stone:GetModifierBaseAttack_BonusDamage() return self.bonus_basic_damage end


function modifier_item_hd_titan_stone:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_item_hd_titan_stone:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

