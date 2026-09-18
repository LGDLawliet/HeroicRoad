item_hd_buckler_active = class({})
LinkLuaModifier("modifier_item_hd_buckler_active_arua", "items/item_hd_buckler_active", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_buckler_active", "items/item_hd_buckler_active", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_buckler_active_disarm", "items/item_hd_buckler_active", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_buckler_active_active_lifesteal", "items/item_hd_buckler_active", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_buckler_active:GetIntrinsicModifierName()
	return "modifier_item_hd_buckler_active_arua"
end






modifier_item_hd_buckler_active_arua = advanced_modifier({})

function modifier_item_hd_buckler_active_arua:IsHidden() return true end
function modifier_item_hd_buckler_active_arua:IsAura() return true end
function modifier_item_hd_buckler_active_arua:GetAuraDuration() return 0.5 end
function modifier_item_hd_buckler_active_arua:GetModifierAura() return "modifier_item_hd_buckler_active" end
function modifier_item_hd_buckler_active_arua:GetAuraRadius() return self.radius end
function modifier_item_hd_buckler_active_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_buckler_active_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_buckler_active_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_item_hd_buckler_active_arua:OnCreated(keys)
    self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end









modifier_item_hd_buckler_active = advanced_modifier({})

function modifier_item_hd_buckler_active:IsDebuff() return false end
function modifier_item_hd_buckler_active:IsHidden() return false end
function modifier_item_hd_buckler_active:IsPurgable() return false end
-- function modifier_item_hd_buckler_active:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_buckler_active:GetTexture()return "item_buckler_active" end


function modifier_item_hd_buckler_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
    self:StartIntervalThink(1)
end

function modifier_item_hd_buckler_active:OnIntervalThink(keys)
    if IsValid(self.ability) then
        if self:GetCaster():FindAbilityByName("Primary_Warcry") or self:GetCaster():FindAbilityByName("Middle_Warcry") or self:GetCaster():FindAbilityByName("Advanced_Warcry") then
            self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor_override")
        else
            self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
        end
    end
    
end

function modifier_item_hd_buckler_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_buckler_active:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end