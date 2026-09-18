item_hd_ninja_gear = class({})
LinkLuaModifier("modifier_item_hd_ninja_gear", "items/item_hd_ninja_gear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ninja_gear_vision", "items/item_hd_ninja_gear", LUA_MODIFIER_MOTION_NONE)

function item_hd_ninja_gear:GetIntrinsicModifierName()
	return "modifier_item_hd_ninja_gear"
end

modifier_item_hd_ninja_gear = advanced_modifier({})

function modifier_item_hd_ninja_gear:IsDebuff() return false end
function modifier_item_hd_ninja_gear:IsHidden() return true end
function modifier_item_hd_ninja_gear:IsPurgable() return false end
function modifier_item_hd_ninja_gear:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_ninja_gear:GetEffectName() return "particles/new_effect/status/new_status_effect_soul_03.vpcf"
end

function modifier_item_hd_ninja_gear:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
end


function modifier_item_hd_ninja_gear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	}
end
function modifier_item_hd_ninja_gear:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end

function modifier_item_hd_ninja_gear:Advanced_GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_ninja_gear:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end


modifier_item_hd_ninja_gear_vision = advanced_modifier({})

function modifier_item_hd_ninja_gear_vision:IsDebuff() return true end
function modifier_item_hd_ninja_gear_vision:IsHidden() return true end
function modifier_item_hd_ninja_gear_vision:IsPurgable() return false end
function modifier_item_hd_ninja_gear_vision:CheckState()
	return{
		[MODIFIER_STATE_PROVIDES_VISION] = true
	}
end