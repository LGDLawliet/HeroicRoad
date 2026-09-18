item_hd_ring_of_flowing_wind = class({})
-- LinkLuaModifier("modifier_item_hd_ring_of_flowing_wind_arua", "items/item_hd_ring_of_flowing_wind", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ring_of_flowing_wind_arua_effect", "items/item_hd_ring_of_flowing_wind", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ring_of_flowing_wind", "items/item_hd_ring_of_flowing_wind", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function item_hd_ring_of_flowing_wind:GetIntrinsicModifierName()
	return "modifier_item_hd_ring_of_flowing_wind"
end


modifier_item_hd_ring_of_flowing_wind = advanced_modifier({})

function modifier_item_hd_ring_of_flowing_wind:IsDebuff() return false end
function modifier_item_hd_ring_of_flowing_wind:IsHidden() return true end
function modifier_item_hd_ring_of_flowing_wind:IsPurgable() return false end


function modifier_item_hd_ring_of_flowing_wind:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.bonus_cast_speed = self.ability:GetSpecialValueFor("bonus_cast_speed")
	self.bonus_cd = self.ability:GetSpecialValueFor("bonus_cd")
end

function modifier_item_hd_ring_of_flowing_wind:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	}
end

function modifier_item_hd_ring_of_flowing_wind:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end



function modifier_item_hd_ring_of_flowing_wind:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_CastPoint,
		advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
	return funcs
end

function modifier_item_hd_ring_of_flowing_wind:Advanced_GetModifier_CastPoint() 

	return self.bonus_cast_speed
end
function modifier_item_hd_ring_of_flowing_wind:Advanced_GetModifierCooldownReduction() 

	return self.bonus_cd
end




