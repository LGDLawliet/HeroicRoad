heroTalent_npc_dota_hero_earth_spirit = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_earth_spirit", "heroTalent/heroTalent_npc_dota_hero_earth_spirit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_earth_spirit_effect", "heroTalent/heroTalent_npc_dota_hero_earth_spirit", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_earth_spirit:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_earth_spirit"
end



modifier_heroTalent_npc_dota_hero_earth_spirit = class({})

function modifier_heroTalent_npc_dota_hero_earth_spirit:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_earth_spirit:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_earth_spirit:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_earth_spirit:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_earth_spirit:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_earth_spirit:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_earth_spirit:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_earth_spirit_effect" end
function modifier_heroTalent_npc_dota_hero_earth_spirit:GetAuraRadius()	return -1  end
function modifier_heroTalent_npc_dota_hero_earth_spirit:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_earth_spirit:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end

function modifier_heroTalent_npc_dota_hero_earth_spirit:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end



modifier_heroTalent_npc_dota_hero_earth_spirit_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:GetEffectName() return "particles/units/heroes/hero_earth_spirit/espirit_stoneremnant_base.vpcf" end
function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:GetModifierMagicalResistanceBonus()
	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
	if self:GetParent()==self:GetCaster() then
		return 2*self.bonus_magic_resist
	end
	return self.bonus_magic_resist
end



function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_earth_spirit_effect:Advanced_GetModifierPhysicalArmorBonus()
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	if self:GetParent()==self:GetCaster() then
		return 2*self.bonus_armor
	end
	return self.bonus_armor
end