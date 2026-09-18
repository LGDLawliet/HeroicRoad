LinkLuaModifier("modifier_creeps_spell_origina_circle_attack", "creeps_spell/creeps_spell_origina_circle_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_origina_circle_attack_buff", "creeps_spell/creeps_spell_origina_circle_attack", LUA_MODIFIER_MOTION_NONE)
creeps_spell_origina_circle_attack = class({})

function creeps_spell_origina_circle_attack:GetIntrinsicModifierName() return "modifier_creeps_spell_origina_circle_attack" end

function creeps_spell_origina_circle_attack:OnSpellStart()
    local caster = self:GetCaster()
    self.casting = caster:AddNewModifier(caster, self, "modifier_creeps_spell_origina_circle_attack_buff", {duration = self:GetSpecialValueFor("delay")})
end

function creeps_spell_origina_circle_attack:OnChannelFinish(bInterrupted)
    local caster = self:GetCaster()

    -- 如果被打断，则不执行伤害效果
    if bInterrupted then
        if self.casting then
            self.casting:Destroy()
        end
        return
    end
end

---------------------------------------------------------------------------------------------------
modifier_creeps_spell_origina_circle_attack = class({})
function modifier_creeps_spell_origina_circle_attack:IsHidden() return true end
function modifier_creeps_spell_origina_circle_attack:IsPurgable() return false end
function modifier_creeps_spell_origina_circle_attack:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end
function modifier_creeps_spell_origina_circle_attack:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local ability = self:GetAbility() 
        -- 如果技能不存在或在冷却中，则不执行
        if not parent:IsAlive() or not ability or not ability:IsCooldownReady() then
            return
        end
        
        local radius = ability:GetSpecialValueFor("radius")
        
        -- 查找范围内的敌方单位
        local units = FindUnitsInRadius(
            parent:GetTeamNumber(),
            parent:GetOrigin(),
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false
        )
        
        -- 如果范围内有敌方单位，则自动施法
        if #units > 0 then
            if parent:IsIdle() or (parent:GetCurrentActiveAbility() == nil) then
                parent:CastAbilityNoTarget(ability, parent:GetPlayerOwnerID())
            end
        end
    end
end

---------------------------------------------------------------------------------------------------
modifier_creeps_spell_origina_circle_attack_buff = advanced_modifier({})

function modifier_creeps_spell_origina_circle_attack_buff:IsHidden() return true end
function modifier_creeps_spell_origina_circle_attack_buff:IsPurgable() return false end
function modifier_creeps_spell_origina_circle_attack_buff:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
    return state
end
function modifier_creeps_spell_origina_circle_attack_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end
function modifier_creeps_spell_origina_circle_attack_buff:GetOverrideAnimation()
    return ACT_DOTA_ATTACK
end
function modifier_creeps_spell_origina_circle_attack_buff:OnCreated()
    if IsServer() then
        local parent = self:GetParent()
        local ability = self:GetAbility()
        local particle_cast = "particles/rebuild/circle_follow_effects/circle_attack.vpcf"
        local radius = ability:GetSpecialValueFor("radius")+40
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
        ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            3,
            parent,
            PATTACH_ABSORIGIN_FOLLOW,
            "attach_hitloc",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )
        ParticleManager:SetParticleControlForward( effect_cast, 3, parent:GetForwardVector() )
        self.effect_cast = effect_cast
    end
end

function modifier_creeps_spell_origina_circle_attack_buff:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        local ability = self:GetAbility()
        -- 播放结束特效
        if self.effect_cast then
            ParticleManager:DestroyParticle( self.effect_cast, true )
            ParticleManager:ReleaseParticleIndex( self.effect_cast )
        end
        if not ability or not parent:IsAlive() then
            return
        end
        -- 通过自身的剩余持续时间来检测是否是被打断的
        if self:GetRemainingTime() > 0 then
            return
        end
        
        local radius = ability:GetSpecialValueFor("radius")
        local damage = ability:GetSpecialValueFor("damage")*parent:GetAverageTrueAttackDamage(nil)
        local units = FindUnitsInRadius(
            parent:GetTeamNumber(),
            parent:GetOrigin(),
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false
        )
        local damage_table = {
            attacker = parent,
            damage = damage,
            damage_type = ability:GetAbilityDamageType(),
            ability = ability
        }
        for _, unit in ipairs(units) do
            damage_table.victim = unit
            ApplyDamage(damage_table)
        end
    end
end