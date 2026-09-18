item_hd_travel_boots = class({})

LinkLuaModifier("modifier_item_hd_travel_boots", "items/item_hd_travel_boots", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function item_hd_travel_boots:GetIntrinsicModifierName()
	return "modifier_item_hd_travel_boots"
end






modifier_item_hd_travel_boots = advanced_modifier({})

function modifier_item_hd_travel_boots:IsDebuff() return false end
function modifier_item_hd_travel_boots:IsHidden() return true end
function modifier_item_hd_travel_boots:IsPurgable() return false end


function modifier_item_hd_travel_boots:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
end



function modifier_item_hd_travel_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度
	}
end


function modifier_item_hd_travel_boots:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end






-- advanced_modifier
function modifier_item_hd_travel_boots:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE
    }
end
function modifier_item_hd_travel_boots:Advanced_GetModifier_DefaultMoveCastRange(keys)
	return 300
end
