item_hd_nether_shawl = class({})

LinkLuaModifier("modifier_item_hd_nether_shawl", "items/item_hd_nether_shawl", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_nether_shawl_active", "items/item_hd_nether_shawl", LUA_MODIFIER_MOTION_NONE)

function item_hd_nether_shawl:GetIntrinsicModifierName()
	return "modifier_item_hd_nether_shawl"
end

function item_hd_nether_shawl:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end


modifier_item_hd_nether_shawl = advanced_modifier({})

function modifier_item_hd_nether_shawl:IsDebuff() return false end
function modifier_item_hd_nether_shawl:IsHidden() return true end
function modifier_item_hd_nether_shawl:IsPurgable() return false end

function modifier_item_hd_nether_shawl:IsAura() return true end
function modifier_item_hd_nether_shawl:GetAuraDuration() return 0.5 end
function modifier_item_hd_nether_shawl:GetModifierAura() return "modifier_item_hd_nether_shawl_active" end
function modifier_item_hd_nether_shawl:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_item_hd_nether_shawl:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_nether_shawl:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_nether_shawl:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



function modifier_item_hd_nether_shawl:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_armor = -self.ability:GetSpecialValueFor("armor_down")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resist")
end



function modifier_item_hd_nether_shawl:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end


function modifier_item_hd_nether_shawl:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_amp end
function modifier_item_hd_nether_shawl:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end


function modifier_item_hd_nether_shawl:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_item_hd_nether_shawl:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


modifier_item_hd_nether_shawl_active = class({})

function modifier_item_hd_nether_shawl_active:IsDebuff() return true end
function modifier_item_hd_nether_shawl_active:IsHidden() return false end
function modifier_item_hd_nether_shawl_active:IsPurgable() return false end


function modifier_item_hd_nether_shawl_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性

	}
end

function modifier_item_hd_nether_shawl_active:GetModifierMagicalResistanceBonus()   return -self:GetAbility():GetSpecialValueFor("bonus_magic_resist") end