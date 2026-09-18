Primary_Time_Lock = class({})
LinkLuaModifier("modifier_Primary_Time_Lock", "skills/Primary_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Time_Lock_freeze", "skills/Primary_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Time_Lock_freeze_limit", "skills/Primary_Time_Lock", LUA_MODIFIER_MOTION_NONE)
function Primary_Time_Lock:GetIntrinsicModifierName()
    return "modifier_Primary_Time_Lock"
end

-------------------------------------------

modifier_Primary_Time_Lock = advanced_modifier({})

function modifier_Primary_Time_Lock:IsHidden() return true end
function modifier_Primary_Time_Lock:IsDebuff() return false end
function modifier_Primary_Time_Lock:IsPurgable() return false end
function modifier_Primary_Time_Lock:RemoveOnDeath() return false end

function modifier_Primary_Time_Lock:OnCreated()
    if IsServer() then
        self.chain_count = 0
    end
end

function modifier_Primary_Time_Lock:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil}
    }
    return funcs
end

function modifier_Primary_Time_Lock:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
    }
    return funcs
end

function modifier_Primary_Time_Lock:GetModifierPreAttack_BonusDamagePostCrit(params) 
    self.index = self:GetAbility():GetSpecialValueFor("bonus_attack")*0.01
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    return self:GetParent():GetAverageTrueAttackDamage(nil)*self.index
end

function modifier_Primary_Time_Lock:OnAttackLanded(keys)
    if IsServer() then
        local attacker = self:GetParent()
        local target = keys.target
        if attacker == keys.attacker and not target:IsBuilding() and not attacker:PassivesDisabled() and not attacker:IsInSpecialAttack() then
            local ability = self:GetAbility()
            local chance = ability:GetSpecialValueFor("chance")
            local duration = ability:GetSpecialValueFor("duration")
            local random = math.random

            if chance >= random(1,100) and self.chain_count < 5 then
                self.chain_count = self.chain_count + 1

				
				
                -- 添加时间锁定效果
				local limit = target:HasModifier("modifier_Time_Lock_freeze_limit")
				if not limit then
                	local modifierStatusNegativeGain = attacker:GetModifierStatusNegativeGainIndex(0.3)
                	local statusResistance = target:GetHDStatusResistanceIndex(0.6) * modifierStatusNegativeGain
                	target:AddNewModifier(attacker, ability, "modifier_Primary_Time_Lock_freeze", {duration = duration * statusResistance})
					target:AddNewModifier(attacker, ability, "modifier_Time_Lock_freeze_limit", {duration = 1})
				end
                
                -- 造成额外的普通攻击
                local modifier_keys = {
                    duration = 0.1,
                    iSpecialAttack = 0,
                    iDisableApplyModifier = 0,
                    iDisableCleave = 0,
                    iDisableSplit = 1,
                }
            
                local attackEffectRecord = attacker:AddAttackEffectModifier(self,modifier_keys)
                attacker:PerformAttack(target, true, true, true, true, false, false, true)
                if IsValid(attackEffectRecord) then
                    attackEffectRecord:Destroy()
                end
                
                -- 播放特效和音效
                self:PlayEffects(target)

                -- 在短暂延迟后重置连锁计数
                Timers:CreateTimer(0.1, function()
                    self.chain_count = 0
                end)
            else
                self.chain_count = 0
            end
        end
    end
end

function modifier_Primary_Time_Lock:PlayEffects(target)
    local particle_name = "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf"
    local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:ReleaseParticleIndex(particle)
    target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
end

-------------------------------------------

modifier_Primary_Time_Lock_freeze = class({})

function modifier_Primary_Time_Lock_freeze:IsDebuff() return true end
function modifier_Primary_Time_Lock_freeze:IsStunDebuff() return true end
function modifier_Primary_Time_Lock_freeze:IsPurgable() return false end
function modifier_Primary_Time_Lock_freeze:IsHidden() return true end
function modifier_Primary_Time_Lock_freeze:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true
    }
end

function modifier_Primary_Time_Lock_freeze:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_Primary_Time_Lock_freeze:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_Primary_Time_Lock_freeze:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function modifier_Primary_Time_Lock_freeze:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end
-------------------------------------------

modifier_Time_Lock_freeze_limit = class({})

function modifier_Time_Lock_freeze_limit:IsDebuff() return false end
function modifier_Time_Lock_freeze_limit:IsStunDebuff() return false end
function modifier_Time_Lock_freeze_limit:IsPurgable() return false end
function modifier_Time_Lock_freeze_limit:IsHidden() return true end