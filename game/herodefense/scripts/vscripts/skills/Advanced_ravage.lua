LinkLuaModifier("modifier_Advanced_ravage_debuff", "skills/Advanced_ravage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_ravage_pull", "skills/Advanced_ravage", LUA_MODIFIER_MOTION_NONE)
Advanced_ravage = Advanced_ravage or class({})

function Advanced_ravage:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", context)
    PrecacheResource("particle", "particles/rebuild/spell/Advanced_ravage/main_effect.vpcf", context)
    PrecacheResource("particle", "particles/rebuild/from_p2/round_duration/water_effect_1/water_suck.vpcf", context)
end

function Advanced_ravage:CheckKV(key)
	local table = {
		damage = 20,
		bonus_damage = 20
	}
	local value = table[key] or -1
	return value
end

function Advanced_ravage:UnlockFirstCore(key)
	return true
end
function Advanced_ravage:UnlockSecondCore(key)
	return true
end
function Advanced_ravage:UnlockThirdCore(key)
	return true
end

function Advanced_ravage:GetChannelTime()
    local caster = self:GetCaster()
    local max_time = self:GetSpecialValueFor("channel_time")
    if self:GetSpecialValueFor("advanced_level") >= 15 then
        max_time = max_time + 1
    end
    return max_time
end

function Advanced_ravage:GetCastRange(location, target)
    return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function Advanced_ravage:OnSpellStart()
    local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_TELEPORT)
    caster:AddNewModifier(caster, self, "modifier_Advanced_ravage_pull", {duration = self:GetChannelTime() + 0.1})
    self.timer = GameRules:GetGameTime()
end

function Advanced_ravage:OnChannelFinish(bInterrupted)
    if not IsValid(self) then return end
    local level = self:GetSpecialValueFor("advanced_level")
    local caster = self:GetCaster()
    caster:RemoveGesture(ACT_DOTA_TELEPORT)
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
    caster:RemoveModifierByName("modifier_Advanced_ravage_pull")
    local timer = GameRules:GetGameTime()
    local pull_time_index = (timer - self.timer)/self:GetChannelTime()
    local max_damage_pct = self:GetSpecialValueFor("damage_pct_max")
    if level >= 15 then
        max_damage_pct = max_damage_pct + 50
        if pull_time_index >= 1 then
            pull_time_index = 1
            --@param keys.target 目标单位
            --@param keys.ability 被减cd的技能
            --@param keys.cdr 冷却减少百分比
            --@param keys.unrefresh_pct 不可刷新刷新冷却减少效率
            CooldownReduce_Pct({
                target = caster,
                ability = self,
                cdr = 25,
            })
        end
    end
    local damage_pct = max_damage_pct * pull_time_index


    self:CastEffect({
        damage_pct = damage_pct,
    })

    if level >= 20 then
        caster:GameTimer(5, function()
            if IsValid(self) then
                self:CastEffect({
                    damage_pct = 50,
                    allow_stun = 0,
                })
            end
        end)

        caster:GameTimer(10, function()
            if IsValid(self) then
                self:CastEffect({
                    damage_pct = 50,
                    allow_stun = 0,
                })
            end
        end)
    end
end

--radius_pct，选填，半径百分比，默认100
--allow_stun，选填，允许眩晕，默认1
--damage_pct，选填，伤害百分比，默认100
function Advanced_ravage:CastEffect(keys)
    local caster = self:GetCaster()
    caster:RemoveGesture(ACT_DOTA_TELEPORT)
    local radius_pct = keys.radius_pct or 100
    local allow_stun = keys.allow_stun or 1
    local damage_pct = keys.damage_pct or 100

    local radius = self:GetCastRange() * radius_pct*0.01
    local total_duration = self:GetSpecialValueFor("total_duration")
    local duration = self:GetSpecialValueFor("duration")
    local damage = (self:GetSpecialValueFor("damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage")*0.01)*(1+damage_pct*0.01)

    local speed = radius / total_duration
    local width = 250

    local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius*0.1, 1, 1))
    ParticleManager:SetParticleControl(effect_cast, 5, Vector(radius, 1, speed))
    for i = 2, 4 do
        local pos = radius / 5 * i
        ParticleManager:SetParticleControl(effect_cast, i, Vector(pos, 1, 1))
    end
    ParticleManager:ReleaseParticleIndex(effect_cast)
    caster:EmitSound("Ability.Ravage")

    local thinker = CreateModifierThinker(
        caster,
        self,
        "modifier_generic_ring_lua",
        {
            start_radius = 0,
            end_radius = radius,
            speed = speed,
            width = width,
            target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
            target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        },
        caster:GetAbsOrigin(),
        caster:GetTeamNumber(),
        false
    )
    
    local ring = thinker:FindModifierByName("modifier_generic_ring_lua")
    ring:SetCallback(function(enemy)
        if not IsValid(self) then return end
        self:ApplyEffect({
            target = enemy,
            allow_stun = allow_stun,
            damage = damage,
            duration = duration,
        })
    end)
end


--target，必填，目标
--damage
--duration
--allow_stun，选填，允许眩晕，默认1
function Advanced_ravage:ApplyEffect(keys)
    local caster = self:GetCaster()
    local target = keys.target
    local allow_stun = keys.allow_stun or 1
    local duration = keys.duration
    local damage = keys.damage
    if allow_stun ~= 1 then
        duration = 0
    end

    local damage_table = {
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self,
        hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
    }
    local height = 350
    local knock_duration = 0.5

    local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(effect_cast, 0, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast)
    EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Tidehunter.RavageDamage", caster)


    damage_table.victim = target
    ApplyDamage(damage_table)

    local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
    local StatusResistance = target:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
    local stun_duration = math.max(duration * StatusResistance, self:GetSpecialValueFor("duration_min"))
    target:AddNewModifier(caster, self, "modifier_Advanced_ravage_debuff", {duration = stun_duration})


    local jumpKeys = {
        caster = caster,
        ability = self,
        height = height,
        duration = knock_duration,
        turn = false
    }
    target:FlyAway(jumpKeys)
end
------------
modifier_Advanced_ravage_pull = modifier_Advanced_ravage_pull or advanced_modifier({})

function modifier_Advanced_ravage_pull:IsHidden() return true end
function modifier_Advanced_ravage_pull:IsPurgable() return false end

function modifier_Advanced_ravage_pull:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        self.radius = self:GetAbility():GetSpecialValueFor("suck_radius")
        self.pull_speed = 400
        self.level = self:GetAbility():GetSpecialValueFor("advanced_level")
        if self.level >= 10 then
            self.pull_speed = caster:IsLowAttackPriority() and 400 or 1200
        end

        if self:GetAbility():GetUnlock(1) == 1 or self:GetAbility().unlock1 then
            self.pull_speed = self.pull_speed + 1200
            self.radius = self.radius + 2500
        end
        local pfx = ParticleManager:CreateParticle("particles/rebuild/from_p2/round_duration/water_effect_1/water_suck.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAbsOrigin()+Vector(0,0,64) )
		ParticleManager:SetParticleControl( pfx, 1, Vector( 200, self.radius, self.radius ) )
        ParticleManager:SetParticleControl( pfx, 59, Vector( self.radius, 0, 0 ) )
        self:AddParticle(pfx, false, false, -1, false, false)
        
        self:StartIntervalThink(0.03)
    end
end

function modifier_Advanced_ravage_pull:OnIntervalThink()
    local caster = self:GetParent()
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    for _, enemy in pairs(enemies) do
        if CalculateDistance(caster, enemy) > 80 then

            local final_distance = self.pull_speed * 0.03
            local direction = (caster:GetAbsOrigin() - enemy:GetAbsOrigin()):Normalized()
            enemy:GiveSpeed(caster, self:GetAbility(), direction, final_distance, self.pull_speed,true)
        end
    end
end

function modifier_Advanced_ravage_pull:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_Advanced_ravage_pull:ADDeclareFunctions()
    local funcs = {}
    if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 and not self:GetParent():IsLowAttackPriority() then
        table.insert(funcs, advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
    end
    return funcs
end

function modifier_Advanced_ravage_pull:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then return end
    return -80
end
--------------
modifier_Advanced_ravage_debuff = modifier_Advanced_ravage_debuff or advanced_modifier({})

function modifier_Advanced_ravage_debuff:IsHidden() return false end
function modifier_Advanced_ravage_debuff:IsDebuff() return true end
function modifier_Advanced_ravage_debuff:IsPurgable() return false end
function modifier_Advanced_ravage_debuff:IsPurgeException() return true end

function modifier_Advanced_ravage_debuff:OnCreated()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
end

function modifier_Advanced_ravage_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_Advanced_ravage_debuff:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end

function modifier_Advanced_ravage_debuff:ADDeclareFunctions()
    local funcs = {}
    if self:GetAbility():GetSpecialValueFor("advanced_level") >= 5 then
        table.insert(funcs, advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
    end
    return funcs
end

function modifier_Advanced_ravage_debuff:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then return end
    return 30
end

function modifier_Advanced_ravage_debuff:OnDestroy()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    if IsServer() then

    end
end

function modifier_Advanced_ravage_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_Advanced_ravage_debuff:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self:GetStackCount()
    end
end
