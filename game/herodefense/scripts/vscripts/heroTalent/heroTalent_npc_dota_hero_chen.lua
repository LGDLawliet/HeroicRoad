heroTalent_npc_dota_hero_chen = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chen", "heroTalent/heroTalent_npc_dota_hero_chen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chen_effect", "heroTalent/heroTalent_npc_dota_hero_chen", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_chen:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_chen"
end

function heroTalent_npc_dota_hero_chen:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_chen = class({})

function modifier_heroTalent_npc_dota_hero_chen:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_chen:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chen:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chen:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_chen:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_chen:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_chen:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_chen_effect" end
function modifier_heroTalent_npc_dota_hero_chen:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_heroTalent_npc_dota_hero_chen:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_chen:GetAuraSearchType()	return DOTA_UNIT_TARGET_BASIC end

function modifier_heroTalent_npc_dota_hero_chen:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end



modifier_heroTalent_npc_dota_hero_chen_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_chen_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_chen_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chen_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chen_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_chen_effect:GetEffectName() return "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_chen_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_heroTalent_npc_dota_hero_chen_effect:Advanced_GetModifierIncomingDamage_Percentage()	return -self:GetAbility():GetSpecialValueFor("incoming_down") end

function modifier_heroTalent_npc_dota_hero_chen_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_chen_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("bonus_outgoing")
end



