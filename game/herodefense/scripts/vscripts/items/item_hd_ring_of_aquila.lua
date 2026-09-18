item_hd_ring_of_aquila = class({})
-- LinkLuaModifier("modifier_item_hd_ring_of_aquila_arua", "items/item_hd_ring_of_aquila", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ring_of_aquila_arua_effect", "items/item_hd_ring_of_aquila", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ring_of_aquila_passive", "items/item_hd_ring_of_aquila", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_ring_of_aquila:GetIntrinsicModifierName()
	return "modifier_item_hd_ring_of_aquila_passive"
end
function item_hd_ring_of_aquila:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end



modifier_item_hd_ring_of_aquila_passive = class({})

function modifier_item_hd_ring_of_aquila_passive:IsDebuff() return false end
function modifier_item_hd_ring_of_aquila_passive:IsHidden() return true end
function modifier_item_hd_ring_of_aquila_passive:IsPurgable() return false end
function modifier_item_hd_ring_of_aquila_passive:IsPurgeException()return false end
function modifier_item_hd_ring_of_aquila_passive:RemoveOnDeath () return false end
-- function modifier_item_hd_shield_of_aquila:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_ring_of_aquila_passive:IsAura() return true end
function modifier_item_hd_ring_of_aquila_passive:GetAuraDuration() return 0.5 end
function modifier_item_hd_ring_of_aquila_passive:GetModifierAura() return "modifier_item_hd_ring_of_aquila_arua_effect" end
function modifier_item_hd_ring_of_aquila_passive:GetAuraRadius() return self.radius end
function modifier_item_hd_ring_of_aquila_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_hd_ring_of_aquila_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_ring_of_aquila_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_item_hd_ring_of_aquila_passive:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
	self.radius = self.ability:GetSpecialValueFor("radius")
end




function modifier_item_hd_ring_of_aquila_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
	}
end


function modifier_item_hd_ring_of_aquila_passive:GetModifierBonusStats_Strength()	return self.bonus_atb end
function modifier_item_hd_ring_of_aquila_passive:GetModifierBonusStats_Intellect()	return self.bonus_atb end
function modifier_item_hd_ring_of_aquila_passive:GetModifierBonusStats_Agility()	return self.bonus_atb end

function modifier_item_hd_ring_of_aquila_passive:GetModifierPreAttack_BonusDamage() return self.attack end
function modifier_item_hd_ring_of_aquila_passive:GetModifierPhysicalArmorBonus() return self.armor end

modifier_item_hd_ring_of_aquila_arua_effect = advanced_modifier({})

function modifier_item_hd_ring_of_aquila_arua_effect:IsDebuff() return false end
function modifier_item_hd_ring_of_aquila_arua_effect:IsHidden() return false end
function modifier_item_hd_ring_of_aquila_arua_effect:IsPurgable() return false end
function modifier_item_hd_ring_of_aquila_arua_effect:GetTexture()return "item_ring_of_aquila" end




function modifier_item_hd_ring_of_aquila_arua_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end
function modifier_item_hd_ring_of_aquila_arua_effect:Advanced_GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then self:Destroy() return end
    return self:GetAbility():GetSpecialValueFor("attack")
end
function modifier_item_hd_ring_of_aquila_arua_effect:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then self:Destroy() return end
    return self:GetAbility():GetSpecialValueFor("armor")
end