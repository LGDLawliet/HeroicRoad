item_chaotic_sobi_mask = class({})

LinkLuaModifier("modifier_item_chaotic_sobi_mask", "items/item_chaotic_sobi_mask", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_sobi_mask:GetIntrinsicModifierName()
	return "modifier_item_chaotic_sobi_mask"
end



modifier_item_chaotic_sobi_mask = advanced_modifier({})

function modifier_item_chaotic_sobi_mask:IsDebuff() return false end
function modifier_item_chaotic_sobi_mask:IsHidden() return true end
function modifier_item_chaotic_sobi_mask:IsPurgable() return false end

function modifier_item_chaotic_sobi_mask:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
end


function modifier_item_chaotic_sobi_mask:AdvancedGetModifierConstantManaRegen()	
	return self.mana_regen
end

function modifier_item_chaotic_sobi_mask:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end




