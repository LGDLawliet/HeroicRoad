item_hd_mantle = class({})

LinkLuaModifier("modifier_item_hd_mantle", "items/item_hd_mantle", LUA_MODIFIER_MOTION_NONE)
function item_hd_mantle:GetIntrinsicModifierName()
	return "modifier_item_hd_mantle"
end




modifier_item_hd_mantle = advanced_modifier({})

function modifier_item_hd_mantle:IsDebuff() return false end
function modifier_item_hd_mantle:IsHidden() return true end
function modifier_item_hd_mantle:IsPurgable() return false end

function modifier_item_hd_mantle:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self:StartIntervalThink(1)
end

function modifier_item_hd_mantle:OnIntervalThink(keys)
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int") - self.ability:GetSpecialValueFor("bonus_int_eachlvl")*self:GetParent():GetLevel()
end

function modifier_item_hd_mantle:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_item_hd_mantle:Advanced_GetModifierBonusStats_Strength(keys)
	return self.bonus_str
end

function modifier_item_hd_mantle:Advanced_GetModifierBonusStats_Intellect(keys)
	return self.bonus_int
end
