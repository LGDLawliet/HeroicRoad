item_hd_magic_stick = class({})
-- LinkLuaModifier("modifier_item_hd_magic_stick_arua", "items/item_hd_magic_stick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_magic_stick", "items/item_hd_magic_stick", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_magic_stick_disarm", "items/item_hd_magic_stick", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_magic_stick_active_lifesteal", "items/item_hd_magic_stick", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_magic_stick_active_shield", "items/item_hd_magic_stick", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_magic_stick:GetIntrinsicModifierName()
	return "modifier_item_hd_magic_stick"
end










modifier_item_hd_magic_stick = advanced_modifier({})

function modifier_item_hd_magic_stick:IsDebuff() return false end
function modifier_item_hd_magic_stick:IsHidden() return true end
function modifier_item_hd_magic_stick:IsPurgable() return false end
-- function modifier_item_hd_magic_stick:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_magic_stick:OnCreated(keys)
    self.ability = self:GetAbility()


	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")

end

-- advanced_modifier
function modifier_item_hd_magic_stick:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_item_hd_magic_stick:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end
