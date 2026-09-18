item_chaotic_glimmerdark_shield = class({})
LinkLuaModifier("modifier_item_chaotic_glimmerdark_shield", "items/item_chaotic_glimmerdark_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_glimmerdark_shield_active", "items/item_chaotic_glimmerdark_shield", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_glimmerdark_shield:GetIntrinsicModifierName()
    return "modifier_item_chaotic_glimmerdark_shield"
end
function item_chaotic_glimmerdark_shield:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_chaotic_glimmerdark_shield_active", {duration = self:GetSpecialValueFor("duration")})
end
---------------------------------
modifier_item_chaotic_glimmerdark_shield = advanced_modifier({})
function modifier_item_chaotic_glimmerdark_shield:IsDebuff() return false end
function modifier_item_chaotic_glimmerdark_shield:IsHidden() return true end
function modifier_item_chaotic_glimmerdark_shield:IsPurgable() return false end

function modifier_item_chaotic_glimmerdark_shield:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
end
function modifier_item_chaotic_glimmerdark_shield:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_chaotic_glimmerdark_shield:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
---------------------------------
modifier_item_chaotic_glimmerdark_shield_active = advanced_modifier({})
function modifier_item_chaotic_glimmerdark_shield_active:IsDebuff() return false end
function modifier_item_chaotic_glimmerdark_shield_active:IsHidden() return false end
function modifier_item_chaotic_glimmerdark_shield_active:IsPurgable() return false end

function modifier_item_chaotic_glimmerdark_shield_active:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.armor = self.ability:GetSpecialValueFor("armor")
end
function modifier_item_chaotic_glimmerdark_shield_active:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE
    }
end
function modifier_item_chaotic_glimmerdark_shield_active:Advanced_GetModifierPhysicalArmorBonusPercentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.armor
end
