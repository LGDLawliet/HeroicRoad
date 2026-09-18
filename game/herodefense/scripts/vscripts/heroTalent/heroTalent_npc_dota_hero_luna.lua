heroTalent_npc_dota_hero_luna = class({})
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_luna_passive", "heroTalent/heroTalent_npc_dota_hero_luna", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_luna_aura", "heroTalent/heroTalent_npc_dota_hero_luna", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_luna:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_luna_passive"
end
function heroTalent_npc_dota_hero_luna:GetCastRange(vLocation, hTarget)
    return self:GetSpecialValueFor("radius")-self:GetCaster():GetCastRangeBonus()
end



-- 被动效果修饰器
modifier_heroTalent_npc_dota_hero_luna_passive = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_luna_passive:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_luna_passive:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_luna_passive:IsPurgable()return false end

function modifier_heroTalent_npc_dota_hero_luna_passive:GetAuraRadius()return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_heroTalent_npc_dota_hero_luna_passive:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_luna_passive:GetAuraSearchType()return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_heroTalent_npc_dota_hero_luna_passive:GetModifierAura()return "modifier_heroTalent_npc_dota_hero_luna_aura"end
function modifier_heroTalent_npc_dota_hero_luna_passive:IsAura()return not self:GetParent():PassivesDisabled() end
function modifier_heroTalent_npc_dota_hero_luna_passive:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_heroTalent_npc_dota_hero_luna_passive:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_luna_passive:Advanced_GetModifierBaseAttack_BonusDamage()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    return caster:GetLevel() * self:GetAbility():GetSpecialValueFor("attack")
end

-- 光环效果修饰器
modifier_heroTalent_npc_dota_hero_luna_aura = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_luna_aura:IsHidden()return true end
function modifier_heroTalent_npc_dota_hero_luna_aura:IsDebuff()return false end
function modifier_heroTalent_npc_dota_hero_luna_aura:IsPurgable()return false end

function modifier_heroTalent_npc_dota_hero_luna_aura:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_luna_aura:Advanced_GetModifierBaseAttack_BonusDamage()
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    return math.floor(caster:GetLevel() * self:GetAbility():GetSpecialValueFor("attack") * self:GetAbility():GetSpecialValueFor("index")*0.01)
end