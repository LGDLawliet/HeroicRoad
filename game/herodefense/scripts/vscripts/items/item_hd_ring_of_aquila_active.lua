item_hd_ring_of_aquila_active = class({})

LinkLuaModifier("modifier_item_hd_ring_of_aquila_active_arua_effect", "items/item_hd_ring_of_aquila_active", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ring_of_aquila_active_passive", "items/item_hd_ring_of_aquila_active", LUA_MODIFIER_MOTION_NONE)

function item_hd_ring_of_aquila_active:GetIntrinsicModifierName()
	return "modifier_item_hd_ring_of_aquila_active_passive"
end

function item_hd_ring_of_aquila_active:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end


modifier_item_hd_ring_of_aquila_active_passive = advanced_modifier({})

function modifier_item_hd_ring_of_aquila_active_passive:IsDebuff() return false end
function modifier_item_hd_ring_of_aquila_active_passive:IsHidden() return true end
function modifier_item_hd_ring_of_aquila_active_passive:IsPurgable() return false end
function modifier_item_hd_ring_of_aquila_active_passive:IsPurgeException()return false end
function modifier_item_hd_ring_of_aquila_active_passive:RemoveOnDeath () return false end

function modifier_item_hd_ring_of_aquila_active_passive:IsAura() return true end
function modifier_item_hd_ring_of_aquila_active_passive:GetAuraDuration() return 0.5 end
function modifier_item_hd_ring_of_aquila_active_passive:GetModifierAura() return "modifier_item_hd_ring_of_aquila_active_arua_effect" end
function modifier_item_hd_ring_of_aquila_active_passive:GetAuraRadius() return self.radius end
function modifier_item_hd_ring_of_aquila_active_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_hd_ring_of_aquila_active_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_ring_of_aquila_active_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_item_hd_ring_of_aquila_active_passive:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_all = self.ability:GetSpecialValueFor("bonus_all")
	self.radius = self.ability:GetSpecialValueFor("radius")
end



function modifier_item_hd_ring_of_aquila_active_passive:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
	}
end


function modifier_item_hd_ring_of_aquila_active_passive:Advanced_GetModifierBonusStats_Strength()	return self.bonus_all end
function modifier_item_hd_ring_of_aquila_active_passive:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_all end
function modifier_item_hd_ring_of_aquila_active_passive:Advanced_GetModifierBonusStats_Agility()	return self.bonus_all end
-----------------------------------------

modifier_item_hd_ring_of_aquila_active_arua_effect = advanced_modifier({})

function modifier_item_hd_ring_of_aquila_active_arua_effect:IsDebuff() return false end
function modifier_item_hd_ring_of_aquila_active_arua_effect:IsHidden() return false end
function modifier_item_hd_ring_of_aquila_active_arua_effect:IsPurgable() return false end
function modifier_item_hd_ring_of_aquila_active_arua_effect:GetTexture()return "item_ring_of_aquila_active" end
function modifier_item_hd_ring_of_aquila_active_arua_effect:OnCreated(keys)
	self.bonus_armor = 0
	self.bonus_damage = 0
	if self:GetAbility() then
		self.bonus_armor = self:GetAbility():GetSpecialValueFor("active_armor")
		self.bonus_damage = self:GetAbility():GetSpecialValueFor("active_damage")
	end
end
function modifier_item_hd_ring_of_aquila_active_arua_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end
function modifier_item_hd_ring_of_aquila_active_arua_effect:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_hd_ring_of_aquila_active_arua_effect:Advanced_GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end