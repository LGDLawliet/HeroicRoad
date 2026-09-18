item_chaotic_necronomicon_3 = class({})

LinkLuaModifier("modifier_item_chaotic_necronomicon_3", "items/item_chaotic_necronomicon_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_necronomicon_3_summon_vanguard", "items/item_chaotic_necronomicon_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_necronomicon_3_summon_guard", "items/item_chaotic_necronomicon_3", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_necronomicon_3:GetIntrinsicModifierName()
    return "modifier_item_chaotic_necronomicon_3"
end
function item_chaotic_necronomicon_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/shadow_demon_2/effect.vpcf", context )
end
modifier_item_chaotic_necronomicon_3 = advanced_modifier({})

function modifier_item_chaotic_necronomicon_3:IsDebuff() return false end
function modifier_item_chaotic_necronomicon_3:IsHidden() return true end
function modifier_item_chaotic_necronomicon_3:IsPurgable() return false end

function modifier_item_chaotic_necronomicon_3:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")
    self.bonus_summon_time_intensity = self.ability:GetSpecialValueFor("bonus_summon_time_intensity")
end

function modifier_item_chaotic_necronomicon_3:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
        MODIFIER_EVENT_ON_SUMMON = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_necronomicon_3:Advanced_GetModifier_Summon_Intensity()
    return self.bonus_summon_intensity
end

function modifier_item_chaotic_necronomicon_3:Advanced_GetModifier_SummonTime_Intensity()
    return self.bonus_summon_time_intensity
end

function modifier_item_chaotic_necronomicon_3:AdvancedOnSummon(keys)
    if not IsServer() then return end
    if keys.unit ~= self.parent then return end
    if not IsValid(keys.target) then return end

    -- 先锋强化（减伤+死亡爆炸）
    keys.target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_necronomicon_3_summon_vanguard", {})
    -- 后卫强化（增伤+首次弱驱散）
    keys.target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_necronomicon_3_summon_guard", {})
end

--------------------------------------------------------------------------------
-- 召唤物效果：受到伤害减少；死亡时以最大生命值一定比例爆炸（伤害由召唤者造成，并受80%召唤增强影响）
modifier_item_chaotic_necronomicon_3_summon_vanguard = advanced_modifier({})

function modifier_item_chaotic_necronomicon_3_summon_vanguard:IsDebuff() return false end
function modifier_item_chaotic_necronomicon_3_summon_vanguard:IsHidden() return true end
function modifier_item_chaotic_necronomicon_3_summon_vanguard:IsPurgable() return false end
function modifier_item_chaotic_necronomicon_3_summon_vanguard:RemoveOnDeath() return false end

function modifier_item_chaotic_necronomicon_3_summon_vanguard:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()

    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.damage_pct = self.ability:GetSpecialValueFor("damage")*0.01-- 以百分比描述

    if IsServer() then
        self.damagetable = {
            --victim = enemy,
            attacker = self.caster,
            --damage = final_damage,
            damage_type = self.ability:GetAbilityDamageType(),
            ability = self.ability,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
            hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
        }
    end
end

function modifier_item_chaotic_necronomicon_3_summon_vanguard:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = { nil, self:GetParent() },
    }
end

function modifier_item_chaotic_necronomicon_3_summon_vanguard:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return -self.incoming
end

function modifier_item_chaotic_necronomicon_3_summon_vanguard:OnDeath(keys)
    if not IsServer() then return end
    if not self:GetAbility() then self:Destroy() return end
    if keys.unit ~= self.parent then return end
    if not IsValid(self.caster) then return end

    local owner = self.caster
    local origin = self.parent:GetAbsOrigin()
    local team = owner:GetTeamNumber()

    local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/talent/shadow_demon_2/effect.vpcf", PATTACH_ABSORIGIN, self.parent)
    ParticleManager:SetParticleControl(particle_cast_fx, 0, origin)
    DestroyParticleByDelay(particle_cast_fx,3)
    self.parent:EmitSound("Hero_ShadowDemon.DemonicPurge.Damage")

    local intensity_gain = owner:GetSummonIntensityIndex(0.8)
    local base = self.parent:GetMaxHealth()*self.damage_pct
    local final_damage = base*intensity_gain

    local enemies = FindUnitsInRadius(
        team,
        origin,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in ipairs(enemies) do
        self.damagetable.victim = enemy
        self.damagetable.damage = final_damage
        ApplyDamage(self.damagetable)
    end
end

-- 召唤物效果：造成伤害增加；第一次攻击命中时对目标施加一次弱驱散
modifier_item_chaotic_necronomicon_3_summon_guard = advanced_modifier({})

function modifier_item_chaotic_necronomicon_3_summon_guard:IsDebuff() return false end
function modifier_item_chaotic_necronomicon_3_summon_guard:IsHidden() return true end
function modifier_item_chaotic_necronomicon_3_summon_guard:IsPurgable() return false end
function modifier_item_chaotic_necronomicon_3_summon_guard:RemoveOnDeath() return false end

function modifier_item_chaotic_necronomicon_3_summon_guard:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()

    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_necronomicon_3_summon_guard:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_necronomicon_3_summon_guard:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.outgoing
end

function modifier_item_chaotic_necronomicon_3_summon_guard:OnAttackLanded(keys)
    if not IsServer() then return end
    if not self:GetAbility() then self:Destroy() return end
    
    if keys.attacker ~= self.parent then return end
    local target = keys.target
    if not IsValid(target) then return end
    if target.first_hit_done then return end

    target:Purge(true, false, false, false, false)
    target.first_hit_done = true
end