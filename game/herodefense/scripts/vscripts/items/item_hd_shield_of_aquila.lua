item_hd_shield_of_aquila = class({})

LinkLuaModifier("modifier_item_hd_shield_of_aquila_arua_effect", "items/item_hd_shield_of_aquila", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shield_of_aquila_passive", "items/item_hd_shield_of_aquila", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_shield_of_aquila:GetIntrinsicModifierName()
	return "modifier_item_hd_shield_of_aquila_passive"
end




modifier_item_hd_shield_of_aquila_passive = advanced_modifier({})

function modifier_item_hd_shield_of_aquila_passive:IsDebuff() return false end
function modifier_item_hd_shield_of_aquila_passive:IsHidden() return true end
function modifier_item_hd_shield_of_aquila_passive:IsPurgable() return false end
function modifier_item_hd_shield_of_aquila_passive:IsPurgeException()return false end
function modifier_item_hd_shield_of_aquila_passive:RemoveOnDeath () return false end
-- function modifier_item_hd_shield_of_aquila:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_shield_of_aquila_passive:IsAura() return true end
function modifier_item_hd_shield_of_aquila_passive:RemoveOnDeath() return false end
function modifier_item_hd_shield_of_aquila_passive:GetAuraDuration() return 0.5 end
function modifier_item_hd_shield_of_aquila_passive:GetModifierAura() return "modifier_item_hd_shield_of_aquila_arua_effect" end
function modifier_item_hd_shield_of_aquila_passive:GetAuraRadius() return 1200 end
function modifier_item_hd_shield_of_aquila_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_shield_of_aquila_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_shield_of_aquila_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end




function modifier_item_hd_shield_of_aquila_passive:OnCreated(keys)
    local ability = self:GetAbility()
    -- self.caster = self:GetCaster()
    -- local parent = self:GetParent()
	self.bonus_str = ability:GetSpecialValueFor("bonus_all_attribute")
	self.bonus_agi = ability:GetSpecialValueFor("bonus_all_attribute")
	self.bonus_int = ability:GetSpecialValueFor("bonus_all_attribute")
	self.bonus_armor =ability:GetSpecialValueFor("bonus_armor")


    if IsServer() then

	end

end


function modifier_item_hd_shield_of_aquila_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
	}
end
function modifier_item_hd_shield_of_aquila_passive:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_shield_of_aquila_passive:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_shield_of_aquila_passive:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_shield_of_aquila_passive:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_shield_of_aquila_passive:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

modifier_item_hd_shield_of_aquila_arua_effect = advanced_modifier({})

function modifier_item_hd_shield_of_aquila_arua_effect:IsDebuff() return false end
function modifier_item_hd_shield_of_aquila_arua_effect:IsHidden() return false end
function modifier_item_hd_shield_of_aquila_arua_effect:IsPurgable() return false end
function modifier_item_hd_shield_of_aquila_arua_effect:GetTexture()return "item_shield_of_aquila" end
function modifier_item_hd_shield_of_aquila_arua_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_hd_shield_of_aquila_arua_effect:GetModifierConstantManaRegen()	return 5 end
function modifier_item_hd_shield_of_aquila_arua_effect:GetModifierPreAttack_BonusDamage()	return 40 end

function modifier_item_hd_shield_of_aquila_arua_effect:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

function modifier_item_hd_shield_of_aquila_arua_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_shield_of_aquila_arua_effect:Advanced_GetModifierPhysicalArmorBonus()
    return 10
end