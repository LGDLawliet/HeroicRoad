LinkLuaModifier("modifier_creeps_spell_Astral_Step_charge_counter", "creeps_spell/creeps_spell_Astral_Step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Astral_Step_attack", "creeps_spell/creeps_spell_Astral_Step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Astral_Step_debuff", "creeps_spell/creeps_spell_Astral_Step.lua", LUA_MODIFIER_MOTION_NONE)
--如果技能消失，可能是忘记新添技能至kv，打开npc_abilities_custom，在开头加入#base kv.txt导入该文件即可。
if creeps_spell_Astral_Step == nil then
    creeps_spell_Astral_Step = class({})
end
function creeps_spell_Astral_Step:GetCastRange(vLocation, hTarget)
    if IsServer() then
        return 0
    end
    return self:GetSpecialValueFor("max_travel_distance")
end

function creeps_spell_Astral_Step:IsHiddenWhenStolen()
    return false
end
function creeps_spell_Astral_Step:GetIntrinsicModifierName()
    return 'modifier_creeps_spell_Astral_Step_charge_counter'
end
function creeps_spell_Astral_Step:OnSpellStart()
    local hCaster = self:GetCaster()
    local vTarget = self:GetCursorPosition()
    hCaster:EmitSound('Hero_VoidSpirit.AstralStep.Start')
    local caster_loc = hCaster:GetAbsOrigin()
    --设置充能


    -- if self:GetCurrentAbilityCharges()>0 then
    --     self:EndCooldown()
    -- end
    --范围打击
    local radius = self:GetSpecialValueFor("radius")
    local min_travel_distance = self:GetSpecialValueFor("min_travel_distance")
    local max_travel_distance = self:GetSpecialValueFor("max_travel_distance")
    local pop_damage_delay = self:GetSpecialValueFor("pop_damage_delay")
    local hBuffCounter = hCaster:FindModifierByName(self:GetIntrinsicModifierName())
    hBuffCounter.bCrit = 0 
    local ability = self:GetCaster():FindAbilityByName("creeps_spell_Aether_Remnant")
    local vDir = (vTarget - hCaster:GetAbsOrigin()):Normalized()
    local fDis = math.min(max_travel_distance, math.max((vTarget - hCaster:GetAbsOrigin()):Length2D(), min_travel_distance))
    local vE = hCaster:GetAbsOrigin() + vDir * fDis

    local buff = hCaster:AddNewModifier(hCaster, self, 'modifier_creeps_spell_Astral_Step_attack', { duration = 0.1 })
    local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), vE, nil, radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

    local modifier_keys = {
        duration = 0.1,
        iSpecialAttack = 1,
        iDisableApplyModifier = 1,
        iDisableCleave = 0,
        iDisableSplit = 0,

    }
    local attackEffectRecord = hCaster:AddAttackEffectModifier(self,modifier_keys)

    for _, hTarget in pairs(tTargets) do
        --造成攻击
        hCaster:PerformAttack(hTarget,false, true, true, true, false, false, true)
        --减速
        hTarget:AddNewModifier(hCaster, self, 'modifier_creeps_spell_Astral_Step_debuff', { duration = pop_damage_delay+RandomFloat(0, 1) })
        --仅二阶段激活
        if hCaster.pattern_2 and hTarget:IsRealHero() then
            hCaster:SetCursorPosition(caster_loc)
            ability:OnSpellStart()
        end
        
    end


    if IsValid(attackEffectRecord) then
        attackEffectRecord:Destroy()
    end


    hBuffCounter.bCrit = false
    buff:SafeDestroy()
--
    --位移
    local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf', PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(iPtclID, 0, hCaster:GetAbsOrigin())
    ParticleManager:SetParticleControl(iPtclID, 1, vE)
    ParticleManager:ReleaseParticleIndex(iPtclID)
    hCaster:SetAbsOrigin(vE)
    FindClearSpaceForUnit(hCaster, vE, true)
    hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/void_spirit_attack_travel_strike_blur.vpcf', PATTACH_ABSORIGIN, hCaster)
    ParticleManager:SetParticleControl(iPtclID, 0, hCaster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(iPtclID)
end
-- function creeps_spell_Astral_Step:RefreshCharges()
--     local hBuffCounter = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
--     if hBuffCounter ~= nil then
--         hBuffCounter:SetStackCount(hBuffCounter.max_charges)
--         hBuffCounter:StartIntervalThink(-1)
--         hBuffCounter:SetDuration(-1, true)
--     end
-- end
---------------------------------------------------------------------
-- Modifiers
--添加动作
if modifier_creeps_spell_Astral_Step_charge_counter == nil then
    modifier_creeps_spell_Astral_Step_charge_counter = class({})
end
function modifier_creeps_spell_Astral_Step_charge_counter:IsHidden()return true end
function modifier_creeps_spell_Astral_Step_charge_counter:IsPurgable() 		return false end
function modifier_creeps_spell_Astral_Step_charge_counter:IsPurgeException() 	return false end
function modifier_creeps_spell_Astral_Step_charge_counter:RemoveOnDeath()  return false end
function modifier_creeps_spell_Astral_Step_charge_counter:DestroyOnExpire()return false end


function modifier_creeps_spell_Astral_Step_charge_counter:OnCreated(params)
    if not IsServer() then
        return
    end
    self:GetParent():AddActivityModifier('run_fast')

end


--debuff
if modifier_creeps_spell_Astral_Step_debuff == nil then
    modifier_creeps_spell_Astral_Step_debuff = class({})
end
function modifier_creeps_spell_Astral_Step_debuff:IsDebuff()
    return true
end
function modifier_creeps_spell_Astral_Step_debuff:IsPurgable()
    return true
end
function modifier_creeps_spell_Astral_Step_debuff:GetStatusEffectName()
    return 'particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf'
end
function modifier_creeps_spell_Astral_Step_debuff:StatusEffectPriority()
    return 10
end
-- function modifier_creeps_spell_Astral_Step_debuff:GetEffectName()
--     return 'particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf'
-- end
-- function modifier_creeps_spell_Astral_Step_debuff:GetEffectAttachType()
--     return PATTACH_CENTER_FOLLOW
-- end
function modifier_creeps_spell_Astral_Step_debuff:GetEffectName()
    return 'particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf'
end
function modifier_creeps_spell_Astral_Step_debuff:GetEffectAttachType()
    return PATTACH_CENTER_FOLLOW
end
function modifier_creeps_spell_Astral_Step_debuff:ShouldUseOverheadOffset()
    return true
end
function modifier_creeps_spell_Astral_Step_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_creeps_spell_Astral_Step_debuff:OnCreated(params)
    self.pop_damage = self:GetAbility():GetSpecialValueFor("pop_damage")
    self.movement_slow_pct = self:GetAbility():GetSpecialValueFor("movement_slow_pct")
    if IsServer() then
        local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf', PATTACH_POINT_FOLLOW, self:GetParent())
        -- ParticleManager:SetParticleControlEnt(iPtclID, 0, self:GetParent(), PATTACH_POINT, 'attach_hitloc', self:GetParent():GetAbsOrigin() + RandomVector(self:GetParent():GetModelRadius() * 0.5), true)
        -- ParticleManager:SetParticleControlOrientation(iPtclID, 0, RandomVector(1), RandomVector(1), RandomVector(1))
        self:AddParticle(iPtclID, false, false, -1, false, true)
    end
end
function modifier_creeps_spell_Astral_Step_debuff:OnDestroy()
    if IsServer() then
        --造成伤害
        local tDamage = {
            attacker = self:GetCaster(),
            victim = self:GetParent(),
            ability = self:GetAbility(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage = self.pop_damage / 2,
        }
        ApplyDamage(tDamage)
        tDamage.damage_type = DAMAGE_TYPE_PURE
        ApplyDamage(tDamage)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.pop_damage, nil)
        local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf', PATTACH_POINT_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(iPtclID)
    end
end
function modifier_creeps_spell_Astral_Step_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end
function modifier_creeps_spell_Astral_Step_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -self.movement_slow_pct
end


-- Modifiers
--致命
if modifier_creeps_spell_Astral_Step_attack == nil then
    modifier_creeps_spell_Astral_Step_attack = advanced_modifier({})
end
function modifier_creeps_spell_Astral_Step_attack:IsHidden()return true end
function modifier_creeps_spell_Astral_Step_attack:IsPurgable()return false end
function modifier_creeps_spell_Astral_Step_attack:RemoveOnDeath()return false end
function modifier_creeps_spell_Astral_Step_attack:DestroyOnExpire()return false end

-- advanced_modifier
function modifier_creeps_spell_Astral_Step_attack:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end
function modifier_creeps_spell_Astral_Step_attack:Advanced_GetModifierCriticalStrike(keys)
    if self:GetParent() == keys.attacker then
        local damage_mul = self:GetAbility():GetSpecialValueFor("damage")
        return damage_mul 
    end
end