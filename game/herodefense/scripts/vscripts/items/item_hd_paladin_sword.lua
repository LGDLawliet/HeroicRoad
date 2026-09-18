item_hd_paladin_sword = class({})

LinkLuaModifier("modifier_item_hd_paladin_sword", "items/item_hd_paladin_sword", LUA_MODIFIER_MOTION_NONE)


function item_hd_paladin_sword:GetIntrinsicModifierName()
	return "modifier_item_hd_paladin_sword"
end

modifier_item_hd_paladin_sword = advanced_modifier({})

function modifier_item_hd_paladin_sword:IsDebuff() return false end
function modifier_item_hd_paladin_sword:IsHidden() return true end
function modifier_item_hd_paladin_sword:IsPurgable() return false end

function modifier_item_hd_paladin_sword:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")
end

-- advanced_modifier
function modifier_item_hd_paladin_sword:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end
function modifier_item_hd_paladin_sword:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self.bonus_regeneration_amplification
end
function modifier_item_hd_paladin_sword:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return self.bonus_regeneration_amplification
end
function modifier_item_hd_paladin_sword:Advanced_GetModifier_LifeSteal_AttackDamage(keys)
	return self.bonus_life_steal
end
function modifier_item_hd_paladin_sword:Advanced_GetModifierPreAttack_BonusDamage() 
	return self.bonus_damage 
end