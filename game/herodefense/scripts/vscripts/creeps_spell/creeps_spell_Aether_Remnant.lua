LinkLuaModifier("modifier_creeps_spell_Aether_Remnant", "creeps_spell/creeps_spell_Aether_Remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Aether_Remnant_pull", "creeps_spell/creeps_spell_Aether_Remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Aether_Remnant_pull_debuff", "creeps_spell/creeps_spell_Aether_Remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Aether_Remnant_truesight", "creeps_spell/creeps_spell_Aether_Remnant", LUA_MODIFIER_MOTION_NONE)
--Abilities
require("internal/timers")
if creeps_spell_Aether_Remnant == nil then
    creeps_spell_Aether_Remnant = class({})
end
function creeps_spell_Aether_Remnant:IsHiddenWhenStolen()
    return false
end
function creeps_spell_Aether_Remnant:OnSpellStart()
    local hCaster = self:GetCaster()
    local vTarget = self:GetCursorPosition()

    hCaster:EmitSound('Hero_VoidSpirit.AetherRemnant.Cast')
    hCaster:EmitSound('Hero_VoidSpirit.AetherRemnant')

    local projectile_speed = self:GetSpecialValueFor("projectile_speed")
    local watch_path_vision_radius = self:GetSpecialValueFor("watch_path_vision_radius")

    local vDir = (vTarget - hCaster:GetAbsOrigin()):Normalized()
    self.remnant = self:GetCaster():FindAbilityByName("creeps_spell_Aether_Remnant")
    --发射守卫
    local hSB=CreateModifierThinker(hCaster, self.remnant, "modifier_dummy_unit", nil, vTarget, hCaster:GetTeamNumber(), false)
    local tInfo = {
        Ability = self,
        Source = hCaster,
        EffectName = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf",
        vSpawnOrigin = hCaster:GetAbsOrigin(),
        vVelocity = vDir * projectile_speed,
        fDistance = (vTarget - hCaster:GetAbsOrigin()):Length2D(),
        fStartRadius = 0,
        fEndRadius = 0,
        bProvidesVision = true,
        iVisionTeamNumber = hCaster:GetTeamNumber(),
        iVisionRadius = watch_path_vision_radius,
        ExtraData =        {
            entid = hSB:entindex()
        }
    }
    ProjectileManager:CreateLinearProjectile(tInfo)
  
end

function creeps_spell_Aether_Remnant:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
    if nil == hTarget then
        local hSB = EntIndexToHScript(ExtraData.entid)
        if not IsValid(hSB) then
            return
        end
        local hCaster = self:GetCaster()
        local vTarget = self:GetCursorPosition()

        local duration = self:GetSpecialValueFor("duration")
        local activation_delay = self:GetSpecialValueFor("activation_delay")
        hSB:SetForwardVector(hCaster:GetForwardVector())
        --守卫抬手特效
        local iPtclID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pre.vpcf", PATTACH_ABSORIGIN, hSB)
        ParticleManager:SetParticleControlOrientation(iPtclID, 0, hCaster:GetForwardVector(), Vector(0, 0, 0), Vector(0, 0, 0))
        ParticleManager:SetParticleControlEnt(iPtclID, 1, hCaster, PATTACH_ABSORIGIN, nil, hCaster:GetAbsOrigin(), true)

        --监测BUFF
        -- hSB:GameTimer(activation_delay, function()
        --     ParticleManager:DestroyParticle(iPtclID, false)
        --     hSB:AddNewModifier(hCaster, self, "modifier_creeps_spell_Aether_Remnant", { duration = duration })
        -- end)
        Timers:CreateTimer(activation_delay, function()
            ParticleManager:DestroyParticle(iPtclID, false)
            hSB:AddNewModifier(hCaster, self, "modifier_creeps_spell_Aether_Remnant", { duration = duration })
            
        end)
   

    end
end
-- Creating collection: particles/status_fx/status_effect_terrorblade_reflection.vpcf
-- Creating collection: particles/units/heroes/hero_spectre/spectre_dispersion.vpcf
---------------------------------------------------------------------
-- Modifiers
if modifier_creeps_spell_Aether_Remnant == nil then
    modifier_creeps_spell_Aether_Remnant = class({})
end
function modifier_creeps_spell_Aether_Remnant:IsHidden()
    return true
end
function modifier_creeps_spell_Aether_Remnant:IsPurgable()
    return false
end
function modifier_creeps_spell_Aether_Remnant:OnCreated(params)
    if IsServer() then
        -- self.think_interval = self:GetAbility():GetSpecialValueFor('think_interval')
        self.think_interval = 1 / 30
        self.start_radius = self:GetAbility():GetSpecialValueFor('start_radius')
        self.end_radius = self:GetAbility():GetSpecialValueFor('end_radius')
        self.radius = self:GetAbility():GetSpecialValueFor('radius')
        self.remnant_watch_distance = self:GetAbility():GetSpecialValueFor('remnant_watch_distance')
        self.remnant_watch_radius = self:GetAbility():GetSpecialValueFor('remnant_watch_radius')
        self.watch_path_vision_radius = self:GetAbility():GetSpecialValueFor('remnant_watch_radius')
        self.pull_duration = self:GetAbility():GetSpecialValueFor('pull_duration')

        self.iPtclID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(self.iPtclID, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControlEnt(self.iPtclID, 3, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetAbsOrigin(), false)

        self:UpdateForward()
        self:AddParticle(self.iPtclID, false, false, -1, false, false)
        self:StartIntervalThink(self.think_interval)
        self:GetParent():EmitSound('Hero_VoidSpirit.AetherRemnant.Spawn_lp')

        --真视范围
        -- self:GetParent():AddNewModifier(self:GetCaster(), self:GetParent(), 'modifier_creeps_spell_Aether_Remnant_truesight', nil)
    end
end
function modifier_creeps_spell_Aether_Remnant:OnDestroy()
    if IsServer() then
        local hParent = self:GetParent()
        local caster = self:GetCaster()
        if not caster or caster:IsNull() then
            return
        end
        hParent:StopSound('Hero_VoidSpirit.AetherRemnant.Spawn_lp')
        if IsValid(self.hTarget) then
            --拉人
            local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
            local StatusResistance =self.hTarget:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
            hParent:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_Aether_Remnant_pull", {
                duration = self.pull_duration*StatusResistance,
                entid_target = self.hTarget:entindex(),
            })
            for i = self.remnant_watch_distance / self.watch_path_vision_radius, 0, -1 do
                AddFOWViewer(hParent:GetTeamNumber(), hParent:GetAbsOrigin() + hParent:GetForwardVector() * self.watch_path_vision_radius * i
                , self.watch_path_vision_radius, self:GetAbility():GetSpecialValueFor("pull_duration"), false)
            end
        else
            --当持续时间到后销毁自身的载体（父类/状态携带者）
            hParent:EmitSound('Hero_VoidSpirit.AetherRemnant.Destroy')
            hParent:Destroy()
        end
    end
end
function modifier_creeps_spell_Aether_Remnant:UpdateForward()
    local hParent = self:GetParent()
    local hCaster = self:GetCaster()

    --朝向敌人

    -- local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 1500,
    --  DOTA_UNIT_TARGET_TEAM_ENEMY,
    --   DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
    --    DOTA_UNIT_TARGET_FLAG_NONE,
    --     FIND_CLOSEST, false)

        local tTargets = FindUnitsInLine(hParent:GetTeamNumber(), hParent:GetAbsOrigin(),
        hParent:GetAbsOrigin() + hParent:GetForwardVector() * self.remnant_watch_distance,
        nil, self.remnant_watch_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0)
            
    for _, hTarget in ipairs(tTargets) do
        if IsValid(hTarget) and hTarget:IsAlive() then
            hParent:SetForwardVector(hTarget:GetAbsOrigin() - hParent:GetAbsOrigin())
            break
        end
    end

    ParticleManager:SetParticleControlOrientation(self.iPtclID, 0, hParent:GetForwardVector(), hParent:GetRightVector(), hParent:GetUpVector())
    ParticleManager:SetParticleControl(self.iPtclID, 1, hParent:GetAbsOrigin() + hParent:GetForwardVector() * self.remnant_watch_distance)
    -- ParticleManager:SetParticleControlOrientation(self.iPtclID, 2, hParent:GetForwardVector(), hParent:GetRightVector(), hParent:GetUpVector())
end
function modifier_creeps_spell_Aether_Remnant:OnIntervalThink()
    local hParent = self:GetParent()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        self:SafeDestroy()
        return
    end

    self:UpdateForward()

    --视野
    for i = self.remnant_watch_distance / self.watch_path_vision_radius, 0, -1 do
        AddFOWViewer(hParent:GetTeamNumber(), hParent:GetAbsOrigin() + hParent:GetForwardVector() * self.watch_path_vision_radius * i
        , self.watch_path_vision_radius, self.think_interval, false)
    end

    --监测范围
    local tTargets = FindUnitsInLine(hParent:GetTeamNumber(), hParent:GetAbsOrigin(),
    hParent:GetAbsOrigin() + hParent:GetForwardVector() * self.remnant_watch_distance,
    nil, self.remnant_watch_radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0)

    for _, hTarget in pairs(tTargets) do
        if IsValid(hTarget) and hTarget:IsAlive() and not hTarget:HasModifier('modifier_creeps_spell_Aether_Remnant_pull_debuff') then
            self.hTarget = hTarget
            self:SafeDestroy()
            break
        end
    end
end

--
if modifier_creeps_spell_Aether_Remnant_pull == nil then
    modifier_creeps_spell_Aether_Remnant_pull = class({})
end
function modifier_creeps_spell_Aether_Remnant_pull:IsHidden()return true end
function modifier_creeps_spell_Aether_Remnant_pull:IsPurgable()return false end
function modifier_creeps_spell_Aether_Remnant_pull:OnCreated(params)
    if IsServer() then
        self.hTarget = EntIndexToHScript(params.entid_target)
        local hAblt = self:GetAbility()
        if not IsValid(self.hTarget) or not IsValid(hAblt) then
            return
        end

        local hParent = self:GetParent()
        local hCaster = self:GetCaster()
        self.impact_damage = self:GetAbility():GetSpecialValueFor("damage")*self:GetCaster():GetBaseDamageMax()

        -- self.iPtclID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf", PATTACH_CUSTOMORIGIN, nil)
        -- self:AddParticle(self.iPtclID, false, false, -1, false, false)
        -- ParticleManager:SetParticleControlEnt(self.iPtclID, 0, hCaster, PATTACH_ABSORIGIN, nil, hCaster:GetAbsOrigin(), false)
        -- ParticleManager:SetParticleControlEnt(self.iPtclID, 1, self.hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, self.hTarget:GetAbsOrigin(), false)
        -- ParticleManager:SetParticleControlEnt(self.iPtclID, 2, self.hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, self.hTarget:GetAbsOrigin(), false)
        -- ParticleManager:SetParticleControl(self.iPtclID, 3, hParent:GetAbsOrigin())

        -- local parent_pos =hParent:GetAbsOrigin()
        -- local enemies_pos =self.hTarget:GetAbsOrigin()
        -- self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf", PATTACH_CUSTOMORIGIN, nil)
        -- --0号位绑定单位的模型将是其显示模型
        -- ParticleManager:SetParticleControlEnt(self.pfx, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(parent_pos.x,parent_pos.y,parent_pos.z+100), true)
        -- ParticleManager:SetParticleControlEnt(self.pfx, 1, self.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(enemies_pos.x,enemies_pos.y,enemies_pos.z+100), true)
        -- ParticleManager:SetParticleControlEnt(self.pfx, 2, self.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(enemies_pos.x,enemies_pos.y,enemies_pos.z+100), true)
        -- ParticleManager:SetParticleControlEnt(self.pfx, 3, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc",Vector(parent_pos.x,parent_pos.y,parent_pos.z+100), true)



        --伤害
        ApplyDamage({
            ability = hAblt,
            attacker = hCaster,
            victim = self.hTarget,
            damage = self.impact_damage,
            damage_type = hAblt:GetAbilityDamageType()
        })
        --拉拽BUFF
        self.hTarget:AddNewModifier(hParent, hAblt, 'modifier_creeps_spell_Aether_Remnant_pull_debuff', { duration = self:GetAbility():GetSpecialValueFor("pull_duration"), entid = hParent:entindex() })
        self.hTarget:EmitSound('Hero_VoidSpirit.AetherRemnant.Target')

    end
end
function modifier_creeps_spell_Aether_Remnant_pull:OnDestroy()
    if IsServer() then
        self:GetParent():EmitSound('Hero_VoidSpirit.AetherRemnant.Destroy')
        UTIL_Remove( self:GetParent() )
    end
end

--拉拽DEBUFF
if modifier_creeps_spell_Aether_Remnant_pull_debuff == nil then
    modifier_creeps_spell_Aether_Remnant_pull_debuff = class({})
end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:IsDebuff()return true end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:IsHidden()return false end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:IsPurgable()return false end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:IsStunDebuff()return true end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:GetStatusEffectName()
    return 'particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf'
end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:StatusEffectPriority()
    return 10
end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:OnCreated(params)
    if IsServer() then
        local hParent = self:GetParent()
        local hCaster = self:GetAbility():GetCaster()
        self.hSB = EntIndexToHScript(params.entid)
        hParent:EmitSound('Hero_VoidSpirit.AetherRemnant.Triggered')

        self.pull_destination = self:GetAbility():GetSpecialValueFor('pull_destination')
        self.remnant_watch_distance = self:GetAbility():GetSpecialValueFor('remnant_watch_distance')
        self.remnant_watch_radius = self:GetAbility():GetSpecialValueFor('remnant_watch_radius')

        local fDis = (hParent:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D()
        local slow = 60
        slow = slow + (1 - (fDis / (self.remnant_watch_distance + self.remnant_watch_radius))) * (100 - slow)
        self.fMoveSpeed = hParent:GetIdealSpeed() * (100 - slow) * 0.01
        fDis = self.fMoveSpeed * self:GetAbility():GetSpecialValueFor("pull_duration")
        local vDir = (self.hSB:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
        local vTarget = hParent:GetAbsOrigin() + vDir * fDis

        self.hForceTarget = hParent:GetForceAttackTarget()

        if hCaster:IsAlive() then
            local order = {
                UnitIndex = hParent:entindex(),
                OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                Position = vTarget
            }
            ExecuteOrderFromTable(order)
        end

        --取出马甲单位在上面
        --进行添加特效
        local parent_pos =self.hSB:GetAbsOrigin()
        local enemies_pos =hParent:GetAbsOrigin()
        self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf", PATTACH_CUSTOMORIGIN, nil)
                -- --0号位绑定单位的模型将是其显示模型
        ParticleManager:SetParticleControlEnt(self.pfx, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(parent_pos.x,parent_pos.y,parent_pos.z+100), true)
        ParticleManager:SetParticleControlEnt(self.pfx, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(enemies_pos.x,enemies_pos.y,enemies_pos.z+100), true)
        ParticleManager:SetParticleControlEnt(self.pfx, 2, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(enemies_pos.x,enemies_pos.y,enemies_pos.z+100), true)
        ParticleManager:SetParticleControlEnt(self.pfx, 3, self.hSB, PATTACH_POINT_FOLLOW, "attach_hitloc",Vector(parent_pos.x,parent_pos.y,parent_pos.z+150), true)

    end
end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.pfx,false)
        GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.remnant_watch_radius, true)
        self:GetParent():StopSound('Hero_VoidSpirit.AetherRemnant.Triggered')
    end
end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:CheckState()
    return {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,  --强制类 不需要改
        [MODIFIER_STATE_HEXED] = true,
        [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
    }
end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    }
end
function modifier_creeps_spell_Aether_Remnant_pull_debuff:GetModifierMoveSpeed_Absolute()
    return self.fMoveSpeed
end


