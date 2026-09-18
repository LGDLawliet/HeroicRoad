-- 至圣斩
-- 被动加攻击力
LinkLuaModifier("modifier_chaotic_holy_slash_passive", "chaotic_spell/class_1/chaotic_holy_slash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_holy_slash_heal_prevention", "chaotic_spell/class_1/chaotic_holy_slash", LUA_MODIFIER_MOTION_NONE)
chaotic_holy_slash = class({})
function chaotic_holy_slash:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context )

end
function chaotic_holy_slash:GetIntrinsicModifierName()
    return "modifier_chaotic_holy_slash_passive"
end
function chaotic_holy_slash:GetHealthCost()
    local lvl_index = math.min(math.floor(self:GetCaster():GetLevel()/self:GetSpecialValueFor("line")),9)
    if self:GetRuneType() == 2 then
        return self:GetCaster():GetMaxHealth()*0.03 + self:GetCaster():GetMaxHealth()*0.01*lvl_index
    else
        return self:GetCaster():GetMaxHealth()*0.06 + self:GetCaster():GetMaxHealth()*0.02*lvl_index
    end
end
function chaotic_holy_slash:GetCastRange()
    return self:GetCaster():Script_GetAttackRange()
end
function chaotic_holy_slash:OnSpellStart(target)
    local caster = self:GetCaster()
    local target = target or self:GetCursorTarget()
    
    self:ApplyHolySlashEffect(caster, target)
end

function chaotic_holy_slash:ApplyHolySlashEffect(attacker, target)
    if not IsServer() then return end
    if attacker:IsRangedAttacker() then return end

    local lvl_index = math.min(math.floor(self:GetCaster():GetLevel()/self:GetSpecialValueFor("line")),9)
    local cd = self:GetSpecialValueFor("cd") - lvl_index*self:GetSpecialValueFor("cd_down")
    --print(lvl_index)

    -- 添加金色闪光特效
    local particle_flash = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle_flash, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_flash, 1, Vector(100, 100, 100))
    ParticleManager:ReleaseParticleIndex(particle_flash)

    -- 添加金色圣光打击特效（使用全能骑士的净化特效）
    local particle_hit = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle_hit, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_hit, 1, Vector(70, 70, 70))  -- 调整大小
    ParticleManager:ReleaseParticleIndex(particle_hit)

    -- 播放音效
    target:EmitSound("Hero_Omniknight.Purification")

    ApplyDamage({
        victim = target,
        attacker = attacker,
        damage = (self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*lvl_index)*self:GetCaster():GetAverageTrueAttackDamage(nil),
        damage_type = self:GetAbilityDamageType(),
        ability = self,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
        hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT
    })
    if self:GetRuneType() == 1 then
        local undying = target:FindModifierByName("modifier_chaotic_era_undying")
        if undying then
            undying:SafeDestroy()
        end
    end
    
    -- 施加2秒禁疗效果
    target:AddNewModifier(attacker, self, "modifier_chaotic_holy_slash_heal_prevention", {duration = self:GetSpecialValueFor("duration")})
    
    -- 进入冷却状态
    self:StartCooldown(cd)
end


modifier_chaotic_holy_slash_passive = advanced_modifier({})
function modifier_chaotic_holy_slash_passive:IsHidden()
    return true
end
function modifier_chaotic_holy_slash_passive:IsPurgable()
    return false
end

function modifier_chaotic_holy_slash_passive:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
end

function modifier_chaotic_holy_slash_passive:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if self:GetAbility():GetRuneType() == 2 then
        return self:GetAbility():GetSpecialValueFor("bonus_attack")*(1+self:GetAbility():GetSpecialValueFor("rune_2_bonus_attack")*0.01)
    else
        return self:GetAbility():GetSpecialValueFor("bonus_attack")
    end
end

function modifier_chaotic_holy_slash_passive:OnAttackLanded(event)
    if not IsServer() then return end
    local ability = self:GetAbility()
    local attacker = event.attacker
    if attacker == self:GetParent() and ability:GetAutoCastState() and ability:IsCooldownReady() and not attacker:IsRangedAttacker() then
        --self:GetAbility():ApplyHolySlashEffect(event.attacker, event.target)
        ability:OnSpellStart(event.target)
        ability:UseResources(true, true, true, true)
        if ability:GetRuneType() == 3 and event.attacker:IsInSpecialAttack() then
            local newcooldown = ability:GetCooldownTimeRemaining() * (1-ability:GetSpecialValueFor("rune_3_cd_down")*0.01)
            ability:StartCooldown(newcooldown)
        end
    end
end

-- 禁疗效果

modifier_chaotic_holy_slash_heal_prevention = class({})

function modifier_chaotic_holy_slash_heal_prevention:IsHidden()
    return true
end

function modifier_chaotic_holy_slash_heal_prevention:IsDebuff()
    return true
end

function modifier_chaotic_holy_slash_heal_prevention:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DISABLE_HEALING
    }
end

function modifier_chaotic_holy_slash_heal_prevention:GetDisableHealing()
    return 1
end

