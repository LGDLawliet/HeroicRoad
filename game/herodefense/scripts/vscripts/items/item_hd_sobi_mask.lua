item_hd_sobi_mask = class({})

LinkLuaModifier("modifier_item_hd_sobi_mask", "items/item_hd_sobi_mask", LUA_MODIFIER_MOTION_NONE)

function item_hd_sobi_mask:GetIntrinsicModifierName()
	return "modifier_item_hd_sobi_mask"
end



modifier_item_hd_sobi_mask = advanced_modifier({})

function modifier_item_hd_sobi_mask:IsDebuff() return false end
function modifier_item_hd_sobi_mask:IsHidden() return true end
function modifier_item_hd_sobi_mask:IsPurgable() return false end

function modifier_item_hd_sobi_mask:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self:StartIntervalThink(1)
end

function modifier_item_hd_sobi_mask:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_Arcane_Aura") or self:GetCaster():FindAbilityByName("Middle_Arcane_Aura") or self:GetCaster():FindAbilityByName("Advanced_Arcane_Aura") then
		self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration") + self.ability:GetSpecialValueFor("bonus_mana_regeneration_extra")
	else
		self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	end
end

function modifier_item_hd_sobi_mask:AdvancedGetModifierConstantManaRegen()	
	return self.bonus_mana_regeneration
end

function modifier_item_hd_sobi_mask:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end




