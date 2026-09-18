Advanced_Time_Lock = class({})
LinkLuaModifier("modifier_Advanced_Time_Lock", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Lock_freeze", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Time_Lock_freeze_limit", "skills/Primary_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Lock_time_ripple", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Lock_time_curse", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)


function Advanced_Time_Lock:GetIntrinsicModifierName()
    return "modifier_Advanced_Time_Lock"
end
function Advanced_Time_Lock:CheckKV(key)
	local table = {
		bonus_attack = 0.5,
		chance = 0.3,
		time_index = 0.5,
	}
	local value = table[key] or -1
	return value

end
function Advanced_Time_Lock:UnlockFirstCore(key)
	return false
end
function Advanced_Time_Lock:UnlockSecondCore(key)
	return false
end
function Advanced_Time_Lock:UnlockThirdCore(key)
	return false
end
-------------------------------------------

modifier_Advanced_Time_Lock = advanced_modifier({})

function modifier_Advanced_Time_Lock:IsHidden() return false end
function modifier_Advanced_Time_Lock:IsDebuff() return false end
function modifier_Advanced_Time_Lock:IsPurgable() return false end
function modifier_Advanced_Time_Lock:RemoveOnDeath() return false end
function modifier_Advanced_Time_Lock:DestroyOnExpire() return false end

function modifier_Advanced_Time_Lock:OnCreated()
    self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
    if IsServer() then
        self.chain_count = 0
    end
end
function modifier_Advanced_Time_Lock:OnDestroy()
    if IsServer() then
        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetOrigin(),
            nil,
            100000,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
        )
        for _,enemy in pairs(enemies) do
            local modifier = enemy:FindModifierByNameAndCaster("modifier_Advanced_Time_Lock_time_ripple", self:GetParent())
            if modifier then
                modifier:Destroy()
            end
        end
    end
end
function modifier_Advanced_Time_Lock:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil}
    }
    return funcs
end

function modifier_Advanced_Time_Lock:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
    }
    return funcs
end

function modifier_Advanced_Time_Lock:GetModifierPreAttack_BonusDamagePostCrit(params) 
    self.index = self:GetAbility():GetSpecialValueFor("bonus_attack")*0.01
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    return self:GetParent():GetAverageTrueAttackDamage(nil)*self.index
end

function modifier_Advanced_Time_Lock:OnAttackLanded(keys)
    if IsServer() then
        local attacker = self:GetParent()
        local target = keys.target
        if attacker == keys.attacker and not target:IsBuilding() and not attacker:PassivesDisabled() and not attacker:IsInSpecialAttack() then
			attacker:GameTimer(0.4,function()

            local ability = self:GetAbility()
            local chance = ability:GetSpecialValueFor("chance")
            local duration = ability:GetSpecialValueFor("duration")
			local time_duration = ability:GetSpecialValueFor("time_duration")
            local random = math.random

            if chance >= random(1,100) and self.chain_count < 5 then
                self.chain_count = self.chain_count + 1
				self.time_damage = keys.damage
				self.time_index = ability:GetSpecialValueFor("time_index")*0.01

                -- 添加时间锁定眩晕
                local limit = target:HasModifier("modifier_Time_Lock_freeze_limit")
                if not limit then
                    local modifierStatusNegativeGain = attacker:GetModifierStatusNegativeGainIndex(0.3)
                    local statusResistance = target:GetHDStatusResistanceIndex(0.6) * modifierStatusNegativeGain
                    target:AddNewModifier(attacker, ability, "modifier_Advanced_Time_Lock_freeze", {duration = duration * statusResistance})
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
                -- lv10双击
                if self:GetAbility().advanced_level >= 20 then
                    local random = math.random
                    if 20 >= random(1,100) then
                        local modifier_keys = {
                            duration = 0.1,
                            iSpecialAttack = 1,
                            iDisableApplyModifier = 1,
                            iDisableCleave = 1,
                            iDisableSplit = 1,
                        }
                        local talent = attacker:HasAbility("heroTalent_npc_dota_hero_faceless_void_3")
                        if talent then
                            modifier_keys.iDisableApplyModifier = 0
                            modifier_keys.iDisableCleave = 0
                        end
                        local attackEffectRecord = attacker:AddAttackEffectModifier(self,modifier_keys)
                        attacker:PerformAttack(target, talent, talent, true, true, false, false, true)
                        
                        if IsValid(attackEffectRecord) then
                            attackEffectRecord:Destroy()
                        end
                    end
                end
				-- 添加时间涟漪、乱流污染
                target:AddNewModifier(attacker, ability, "modifier_Advanced_Time_Lock_time_ripple", {duration = time_duration , damage = self.time_damage*self.time_index})
                target:AddNewModifier(attacker, ability, "modifier_Advanced_Time_Lock_time_curse", {duration = 3600})
                if self:GetAbility().advanced_level >= 20 then
                    if self.chain_count >= 3 then
                        print("判定次数打标")
                        local time_stop = attacker:FindAbilityByName("Primary_Chronosphere") or attacker:FindAbilityByName("Middle_Chronosphere") or attacker:FindAbilityByName("Advanced_Chronosphere")
                        if time_stop and self:GetRemainingTime() <= 0 then
                            print("不在冷却中")
                            local pos = target:GetAbsOrigin()
                            time_stop:OnSpellStart(pos)
                            self:SetDuration(80, true)
                            print("时间结界！释放！")
                        end
                    end
                end
                -- 播放特效和音效
                self:PlayEffects(target)
                -- 在短暂延迟后重置连锁计数
                attacker:GameTimer(0.1, function()
                    self.chain_count = 0
                end)
            else
                self.chain_count = 0
            end

			end)
        end
    end
end

function modifier_Advanced_Time_Lock:PlayEffects(target)
    local particle_name = "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf"
    local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:ReleaseParticleIndex(particle)
    target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
end

-------------------------------------------

modifier_Advanced_Time_Lock_freeze = class({})

function modifier_Advanced_Time_Lock_freeze:IsDebuff() return true end
function modifier_Advanced_Time_Lock_freeze:IsStunDebuff() return true end
function modifier_Advanced_Time_Lock_freeze:IsPurgable() return false end
function modifier_Advanced_Time_Lock_freeze:IsHidden() return true end
function modifier_Advanced_Time_Lock_freeze:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true
    }
end

function modifier_Advanced_Time_Lock_freeze:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_Advanced_Time_Lock_freeze:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_Advanced_Time_Lock_freeze:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function modifier_Advanced_Time_Lock_freeze:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end

-------------------------------------------

modifier_Advanced_Time_Lock_time_ripple = advanced_modifier({})

function modifier_Advanced_Time_Lock_time_ripple:IsHidden() return true end
function modifier_Advanced_Time_Lock_time_ripple:IsDebuff() return true end
function modifier_Advanced_Time_Lock_time_ripple:IsPurgable() return false end

function modifier_Advanced_Time_Lock_time_ripple:OnCreated(keys)
    self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
    if IsServer() then
		self.damage = keys.damage or 0
        self:StartIntervalThink(1.0)
        --self:OnIntervalThink()
    end
end
function modifier_Advanced_Time_Lock_time_ripple:OnRefresh(keys)
    self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
    if IsServer() then
		self.damage = keys.damage or 0
    end
end

function modifier_Advanced_Time_Lock_time_ripple:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local parent = self:GetParent()
        local ability = self:GetAbility()
        local radius = ability:GetSpecialValueFor("radius")

        local enemies = FindUnitsInRadius(
            parent:GetTeamNumber(),
            parent:GetOrigin(),
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
        )
		local i = 0
        for _, enemy in pairs(enemies) do

            local damage = self.damage or 0
            ApplyDamage({
               	victim = enemy,
                attacker = caster,
            	damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability,
				damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_REFLECTION,
				hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT
            })
            -- lv5时间涟漪造成眩晕
            if self.advanced_level >= 5 then
                enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.2})
            end
			i = i + 1

			if i >= 2 then
				break
			end
        end

        -- 使用虚空假面的时间膨胀特效
        self.particle = ParticleManager:CreateParticle("particles/econ/items/puck/puck_alliance_set/puck_phase_shift_aproset.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
        --ParticleManager:SetParticleControl(particle, 3, Vector(radius, 0, 0))
        --ParticleManager:DestroyParticle(particle,1)

        -- 播放时间锁定的音效
        parent:EmitSound("Hero_FacelessVoid.TimeDilation.Cast")
    end
end
function modifier_Advanced_Time_Lock_time_ripple:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_DISABLE_HEALING
    }
end
function modifier_Advanced_Time_Lock_time_ripple:GetDisableHealing()
    if self.advanced_level >= 20 then
        return 1 
    end
    return 0
end
function modifier_Advanced_Time_Lock_time_ripple:OnDestroy(keys)
    if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle,true)
		end
    end
end

-------------------------------------------

modifier_Advanced_Time_Lock_time_curse = advanced_modifier({})

function modifier_Advanced_Time_Lock_time_curse:IsHidden() return true end
function modifier_Advanced_Time_Lock_time_curse:IsDebuff() return true end
function modifier_Advanced_Time_Lock_time_curse:IsPurgable() return false end

function modifier_Advanced_Time_Lock_time_curse:OnCreated(table)
    self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.down = self:GetAbility():GetSpecialValueFor("down")
end
function modifier_Advanced_Time_Lock_time_curse:OnRefresh(table)
    self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.down = self:GetAbility():GetSpecialValueFor("down")
end

function modifier_Advanced_Time_Lock_time_curse:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_StatusResistance,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_Advanced_Time_Lock_time_curse:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return -self.down
end
function modifier_Advanced_Time_Lock_time_curse:Advanced_GetModifier_StatusResistance()
	return -self.down
end
function modifier_Advanced_Time_Lock_time_curse:Advanced_GetModifierIncomingDamage_Percentage()
	if self.advanced_level >= 15 then
        return 10
    end
    return 0 
end