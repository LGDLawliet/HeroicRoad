heroTalent_npc_dota_hero_furion = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_furion", "heroTalent/heroTalent_npc_dota_hero_furion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_furion_effect", "heroTalent/heroTalent_npc_dota_hero_furion", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_furion:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_furion"
end



modifier_heroTalent_npc_dota_hero_furion = class({})

function modifier_heroTalent_npc_dota_hero_furion:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_furion:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_furion:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_furion:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_furion:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_furion:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return true
end

function modifier_heroTalent_npc_dota_hero_furion:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_furion_effect" end
function modifier_heroTalent_npc_dota_hero_furion:GetAuraRadius()	return -1  end
function modifier_heroTalent_npc_dota_hero_furion:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_furion:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end

function modifier_heroTalent_npc_dota_hero_furion:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end



modifier_heroTalent_npc_dota_hero_furion_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_furion_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_furion_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_furion_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_furion_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_furion_effect:OnCreated()
	self.hp_regen_up = self:GetAbility():GetSpecialValueFor("hp_regen_up")
end
-- advanced_modifier
function modifier_heroTalent_npc_dota_hero_furion_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_furion_effect:AdvancedGetModifierConstantHealthRegenAmpPercentage(keys)
	return self.hp_regen_up
end
