item_chaotic_ocean_heart = class({})
LinkLuaModifier("modifier_item_chaotic_ocean_heart_arua", "items/item_chaotic_ocean_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_ocean_heart", "items/item_chaotic_ocean_heart", LUA_MODIFIER_MOTION_NONE)


function item_chaotic_ocean_heart:GetIntrinsicModifierName()
	return "modifier_item_chaotic_ocean_heart_arua"
end

----------------
modifier_item_chaotic_ocean_heart_arua = class({})

function modifier_item_chaotic_ocean_heart_arua:IsHidden() return true end
function modifier_item_chaotic_ocean_heart_arua:IsAura() return true end
function modifier_item_chaotic_ocean_heart_arua:GetAuraDuration() return 0.5 end
function modifier_item_chaotic_ocean_heart_arua:GetModifierAura() return "modifier_item_chaotic_ocean_heart" end
function modifier_item_chaotic_ocean_heart_arua:GetAuraRadius() return  self.radius end
function modifier_item_chaotic_ocean_heart_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_chaotic_ocean_heart_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_chaotic_ocean_heart_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_chaotic_ocean_heart_arua:OnCreated(keys)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

------------

modifier_item_chaotic_ocean_heart = advanced_modifier({})

function modifier_item_chaotic_ocean_heart:IsDebuff() return false end
function modifier_item_chaotic_ocean_heart:IsHidden() return false end
function modifier_item_chaotic_ocean_heart:IsPurgable() return false end
function modifier_item_chaotic_ocean_heart:GetTexture()return "item_ocean_heart" end


function modifier_item_chaotic_ocean_heart:OnCreated(keys)
    self.ability = self:GetAbility()
	self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
end


function modifier_item_chaotic_ocean_heart:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_item_chaotic_ocean_heart:AdvancedGetModifierConstantManaRegen()	return self.mana_regen end
