item_hd_reaver = class({})

LinkLuaModifier("modifier_item_hd_reaver", "items/item_hd_reaver", LUA_MODIFIER_MOTION_NONE)


function item_hd_reaver:GetIntrinsicModifierName()
	return "modifier_item_hd_reaver"
end



modifier_item_hd_reaver = class({})

function modifier_item_hd_reaver:IsDebuff() return false end
function modifier_item_hd_reaver:IsHidden() return true end
function modifier_item_hd_reaver:IsPurgable() return false end


function modifier_item_hd_reaver:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_scale = self.ability:GetSpecialValueFor("bonus_scale")
end



function modifier_item_hd_reaver:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end


function modifier_item_hd_reaver:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_reaver:GetModifierModelScale()	return self.bonus_str end
