item_hd_ring_of_protection = class({})
-- LinkLuaModifier("modifier_item_hd_ring_of_protection_arua", "items/item_hd_ring_of_protection", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ring_of_protection_arua_effect", "items/item_hd_ring_of_protection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ring_of_protection", "items/item_hd_ring_of_protection", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ring_of_protection_active", "items/item_hd_ring_of_protection", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ring_of_protection_active_standby", "items/item_hd_ring_of_protection", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ring_of_protection_active_debuff", "items/item_hd_ring_of_protection", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_ring_of_protection:GetIntrinsicModifierName()
	return "modifier_item_hd_ring_of_protection"
end





modifier_item_hd_ring_of_protection = advanced_modifier({})

function modifier_item_hd_ring_of_protection:IsDebuff() return false end
function modifier_item_hd_ring_of_protection:IsHidden() return true end
function modifier_item_hd_ring_of_protection:IsPurgable() return false end
-- function modifier_item_hd_ring_of_protection:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_ring_of_protection:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_ring_of_protection:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")

    self:StartIntervalThink(1)
end

function modifier_item_hd_ring_of_protection:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_Electrostatic_Armor") or self:GetCaster():FindAbilityByName("Middle_Electrostatic_Armor") or self:GetCaster():FindAbilityByName("Advanced_Electrostatic_Armor") then
		self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration") + self.ability:GetSpecialValueFor("bonus_health_regeneration_extra")
    else
        self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
    end
end

function modifier_item_hd_ring_of_protection:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end


function modifier_item_hd_ring_of_protection:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end



