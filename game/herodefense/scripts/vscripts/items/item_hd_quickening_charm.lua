item_hd_quickening_charm = class({})
-- LinkLuaModifier("modifier_item_hd_quickening_charm_arua", "items/item_hd_quickening_charm", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_quickening_charm_arua_effect", "items/item_hd_quickening_charm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_quickening_charm", "items/item_hd_quickening_charm", LUA_MODIFIER_MOTION_NONE)


function item_hd_quickening_charm:GetIntrinsicModifierName()
	return "modifier_item_hd_quickening_charm"
end



modifier_item_hd_quickening_charm = advanced_modifier({})

function modifier_item_hd_quickening_charm:IsDebuff() return false end
function modifier_item_hd_quickening_charm:IsHidden() return true end
function modifier_item_hd_quickening_charm:IsPurgable() return false end


function modifier_item_hd_quickening_charm:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_move = ability:GetSpecialValueFor("bonus_move")
	self.bonus_casttime = ability:GetSpecialValueFor("bonus_casttime")
	self.bonus_cooldown = ability:GetSpecialValueFor("bonus_cooldown")
end



function modifier_item_hd_quickening_charm:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,              --施法前摇
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE

	}
end



function modifier_item_hd_quickening_charm:GetModifierMoveSpeedBonus_Percentage()	return self.bonus_move end
function modifier_item_hd_quickening_charm:GetModifierPercentageCasttime()   return self.bonus_casttime end  



function modifier_item_hd_quickening_charm:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
		
    }
end
function modifier_item_hd_quickening_charm:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end