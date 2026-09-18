
LinkLuaModifier("modifier_Primary_presence_of_the_dark_lord_aura", "skills/Primary_presence_of_the_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_presence_of_the_dark_lord_debuff", "skills/Primary_presence_of_the_dark_lord", LUA_MODIFIER_MOTION_NONE)


Primary_presence_of_the_dark_lord	= Primary_presence_of_the_dark_lord or class({})
require("internal/timers")

-- function Primary_presence_of_the_dark_lord:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/effect.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", context )
-- end
function Primary_presence_of_the_dark_lord:GetIntrinsicModifierName()
	return "modifier_Primary_presence_of_the_dark_lord_aura"
end



modifier_Primary_presence_of_the_dark_lord_aura =modifier_Primary_presence_of_the_dark_lord_aura or  class({})
function modifier_Primary_presence_of_the_dark_lord_aura:IsDebuff()	return false end
function modifier_Primary_presence_of_the_dark_lord_aura:IsHidden()	return true end
function modifier_Primary_presence_of_the_dark_lord_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	
	return true
end

function modifier_Primary_presence_of_the_dark_lord_aura:GetModifierAura()
	return "modifier_Primary_presence_of_the_dark_lord_debuff"
end
function modifier_Primary_presence_of_the_dark_lord_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_Primary_presence_of_the_dark_lord_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_Primary_presence_of_the_dark_lord_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_Primary_presence_of_the_dark_lord_aura:GetAuraRadius()
	return self.aura_radius
end
function modifier_Primary_presence_of_the_dark_lord_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_Primary_presence_of_the_dark_lord_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end




modifier_Primary_presence_of_the_dark_lord_debuff =modifier_Primary_presence_of_the_dark_lord_debuff or  advanced_modifier({})

function modifier_Primary_presence_of_the_dark_lord_debuff:IsDebuff()	return true end
function modifier_Primary_presence_of_the_dark_lord_debuff:IsHidden()	return false end
function modifier_Primary_presence_of_the_dark_lord_debuff:IsPurgable() return false end
function modifier_Primary_presence_of_the_dark_lord_debuff:IsPurgeException() return false end
function modifier_Primary_presence_of_the_dark_lord_debuff:OnCreated( kv )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" )
end

function modifier_Primary_presence_of_the_dark_lord_debuff:OnRefresh( kv )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" )
end


function modifier_Primary_presence_of_the_dark_lord_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Primary_presence_of_the_dark_lord_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Primary_presence_of_the_dark_lord_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Primary_presence_of_the_dark_lord_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor_reduction
end