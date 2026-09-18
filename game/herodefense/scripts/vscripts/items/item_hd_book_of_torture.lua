item_hd_book_of_torture = class({})
-- LinkLuaModifier("modifier_item_hd_book_of_torture_arua", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_book_of_torture_arua_effect", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_book_of_torture", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_book_of_torture_active", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_book_of_torture_effect", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_book_of_torture_effect2", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_book_of_torture_active_standby", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_book_of_torture_debuff", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_book_of_torture_thinker", "items/item_hd_book_of_torture", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_book_of_torture:GetIntrinsicModifierName()
	return "modifier_item_hd_book_of_torture"
end






modifier_item_hd_book_of_torture = advanced_modifier({})

function modifier_item_hd_book_of_torture:IsDebuff() return false end
function modifier_item_hd_book_of_torture:IsHidden() return true end
function modifier_item_hd_book_of_torture:IsPurgable() return false end


function modifier_item_hd_book_of_torture:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_StatusNegativeGain = self.ability:GetSpecialValueFor("bonus_StatusNegativeGain")

end


function modifier_item_hd_book_of_torture:DeclareFunctions()
	return {

	}
end


-- advanced_modifier
function modifier_item_hd_book_of_torture:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_NegativeDurationGain,
    }
end
function modifier_item_hd_book_of_torture:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.bonus_StatusNegativeGain
end

