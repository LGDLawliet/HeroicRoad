LinkLuaModifier("modifier_Middle_ravage_debuff", "skills/Middle_ravage", LUA_MODIFIER_MOTION_NONE)

Middle_ravage = Middle_ravage or class({})

function Middle_ravage:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", context)
end

function Middle_ravage:GetCastRange(location, target)
    return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function Middle_ravage:OnSpellStart()
    local caster = self:GetCaster()

    self:CastEffect({})
end

--radius_pct，选填，半径百分比，默认100
--allow_stun，选填，允许眩晕，默认1
function Middle_ravage:CastEffect(keys)
    local caster = self:GetCaster()
    local radius_pct = keys.radius_pct or 100
    local allow_stun = keys.allow_stun or 1

    local radius = self:GetCastRange() * radius_pct*0.01
    local total_duration = self:GetSpecialValueFor("total_duration")
    local duration = self:GetSpecialValueFor("duration")
    local damage = (self:GetSpecialValueFor("damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage")*0.01)

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
function Middle_ravage:ApplyEffect(keys)
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
    target:AddNewModifier(caster, self, "modifier_Middle_ravage_debuff", {duration = stun_duration})


    local jumpKeys = {
        caster = caster,
        ability = self,
        height = height,
        duration = knock_duration,
        turn = false
    }
    target:FlyAway(jumpKeys)
end


--------------
modifier_Middle_ravage_debuff = modifier_Middle_ravage_debuff or advanced_modifier({})

function modifier_Middle_ravage_debuff:IsHidden() return false end
function modifier_Middle_ravage_debuff:IsDebuff() return true end
function modifier_Middle_ravage_debuff:IsPurgable() return false end
function modifier_Middle_ravage_debuff:IsPurgeException() return true end

function modifier_Middle_ravage_debuff:OnCreated()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
end

function modifier_Middle_ravage_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_Middle_ravage_debuff:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end

function modifier_Middle_ravage_debuff:OnDestroy()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    if IsServer() then

    end
end

function modifier_Middle_ravage_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_Middle_ravage_debuff:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self:GetStackCount()
    end
end
