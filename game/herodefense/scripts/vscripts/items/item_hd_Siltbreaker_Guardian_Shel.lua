item_hd_Siltbreaker_Guardian_Shel = class({})
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Guardian_Shel_arua", "items/item_hd_Siltbreaker_Guardian_Shel", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Guardian_Shel_arua_effect", "items/item_hd_Siltbreaker_Guardian_Shel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Guardian_Shel", "items/item_hd_Siltbreaker_Guardian_Shel", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_Siltbreaker_Guardian_Shel:GetIntrinsicModifierName()
	return "modifier_item_hd_Siltbreaker_Guardian_Shel"
end




modifier_item_hd_Siltbreaker_Guardian_Shel = advanced_modifier({})

function modifier_item_hd_Siltbreaker_Guardian_Shel:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Guardian_Shel:IsHidden() return true end
function modifier_item_hd_Siltbreaker_Guardian_Shel:IsPurgable() return false end


function modifier_item_hd_Siltbreaker_Guardian_Shel:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_move = -self.ability:GetSpecialValueFor("bonus_move")

	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_status_resistance")
end



function modifier_item_hd_Siltbreaker_Guardian_Shel:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end


function modifier_item_hd_Siltbreaker_Guardian_Shel:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end
function modifier_item_hd_Siltbreaker_Guardian_Shel:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end

function modifier_item_hd_Siltbreaker_Guardian_Shel:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end
function modifier_item_hd_Siltbreaker_Guardian_Shel:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end



function modifier_item_hd_Siltbreaker_Guardian_Shel:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

