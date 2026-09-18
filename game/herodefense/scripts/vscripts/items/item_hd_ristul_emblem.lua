item_hd_ristul_emblem = class({})

LinkLuaModifier("modifier_item_hd_ristul_emblem", "items/item_hd_ristul_emblem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ristul_emblem_debuff", "items/item_hd_ristul_emblem", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_ristul_emblem:GetIntrinsicModifierName()
	return "modifier_item_hd_ristul_emblem"
end


modifier_item_hd_ristul_emblem = advanced_modifier({})

function modifier_item_hd_ristul_emblem:IsDebuff() return false end
function modifier_item_hd_ristul_emblem:IsHidden() return true end
function modifier_item_hd_ristul_emblem:IsPurgable() return false end
function modifier_item_hd_ristul_emblem:IsPurgeException() return false end
function modifier_item_hd_ristul_emblem:RemoveOnDeath() return false end
function modifier_item_hd_ristul_emblem:DestroyOnExpire() return false end
function modifier_item_hd_ristul_emblem:IsAura() return true end
function modifier_item_hd_ristul_emblem:GetAuraDuration() return 0.5 end
function modifier_item_hd_ristul_emblem:GetModifierAura() return "modifier_item_hd_ristul_emblem_debuff" end
function modifier_item_hd_ristul_emblem:GetAuraRadius() return 800 end
function modifier_item_hd_ristul_emblem:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_ristul_emblem:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_ristul_emblem:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_hd_ristul_emblem:OnCreated(keys)
	self.bonus_str =  self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_hd_ristul_emblem:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,


	}
end

function modifier_item_hd_ristul_emblem:GetModifierBonusStats_Strength()return self.bonus_str end
function modifier_item_hd_ristul_emblem:GetModifierMagicalResistanceBonus()return -40 end
function modifier_item_hd_ristul_emblem:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_ristul_emblem:Advanced_GetModifierPhysicalArmorBonus()
    return -20
end


modifier_item_hd_ristul_emblem_debuff = advanced_modifier({})

function modifier_item_hd_ristul_emblem_debuff:IsDebuff() return true end
function modifier_item_hd_ristul_emblem_debuff:IsHidden() return false end
function modifier_item_hd_ristul_emblem_debuff:IsPurgable() return false end
function modifier_item_hd_ristul_emblem_debuff:IsPurgeException() return false end

function modifier_item_hd_ristul_emblem_debuff:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP

	}
end

function modifier_item_hd_ristul_emblem_debuff:GetModifierMagicalResistanceBonus()return -20 end

function modifier_item_hd_ristul_emblem_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

function modifier_item_hd_ristul_emblem_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_ristul_emblem_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -10
end