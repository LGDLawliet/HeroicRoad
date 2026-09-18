item_hd_lizard_armor_small = class({})

LinkLuaModifier("modifier_item_hd_lizard_armor_small", "items/item_hd_lizard_armor_small", LUA_MODIFIER_MOTION_NONE)


function item_hd_lizard_armor_small:GetIntrinsicModifierName()
	return "modifier_item_hd_lizard_armor_small"
end


modifier_item_hd_lizard_armor_small = advanced_modifier({})

function modifier_item_hd_lizard_armor_small:IsDebuff() return false end
function modifier_item_hd_lizard_armor_small:IsHidden() return true end
function modifier_item_hd_lizard_armor_small:IsPurgable() return false end

function modifier_item_hd_lizard_armor_small:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	self.block = self.ability:GetSpecialValueFor("block")
end


function modifier_item_hd_lizard_armor_small:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性	
	}
end
function modifier_item_hd_lizard_armor_small:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
	}
end
function modifier_item_hd_lizard_armor_small:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end
function modifier_item_hd_lizard_armor_small:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_type~=DAMAGE_TYPE_MAGICAL  then
		return 0
	end

	return self.block
end



	




