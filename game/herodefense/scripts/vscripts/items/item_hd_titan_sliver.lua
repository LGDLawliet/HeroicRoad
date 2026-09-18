item_hd_titan_sliver = class({})
-- LinkLuaModifier("modifier_item_hd_titan_sliver_arua", "items/item_hd_titan_sliver", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_titan_sliver_arua_effect", "items/item_hd_titan_sliver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_titan_sliver", "items/item_hd_titan_sliver", LUA_MODIFIER_MOTION_NONE)


function item_hd_titan_sliver:GetIntrinsicModifierName()
	return "modifier_item_hd_titan_sliver"
end


modifier_item_hd_titan_sliver = advanced_modifier({})

function modifier_item_hd_titan_sliver:IsDebuff() return false end
function modifier_item_hd_titan_sliver:IsHidden() return true end
function modifier_item_hd_titan_sliver:IsPurgable() return false end



function modifier_item_hd_titan_sliver:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_status_resistance")

	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	self.bonus_basic_damage = self.ability:GetSpecialValueFor("bonus_basic_damage")

end


function modifier_item_hd_titan_sliver:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_item_hd_titan_sliver:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end
function modifier_item_hd_titan_sliver:GetModifierBaseAttack_BonusDamage() return self.bonus_basic_damage end


function modifier_item_hd_titan_sliver:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_item_hd_titan_sliver:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

