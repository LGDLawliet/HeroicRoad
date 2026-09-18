chaotic_crystal_nova = class({})
LinkLuaModifier( "modifier_chaotic_crystal_nova", "chaotic_spell/class_2/chaotic_crystal_nova", LUA_MODIFIER_MOTION_NONE )

function chaotic_crystal_nova:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_crystal_nova/effect.vpcf", context )
end

function chaotic_crystal_nova:GetAOERadius()
    return self:GetSpecialValueFor( "radius" )
end

function chaotic_crystal_nova:OnSpellStart()
    local point = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor( "radius" )
    self:PlayEffects(point, radius, 1)

    if self:GetRuneType() == 1 then
        local delay = self:GetSpecialValueFor("rune_1_delay")
        local index = self:GetSpecialValueFor("rune_1_index") * 0.01
        self:GetCaster():GameTimer(delay, function()
            if IsValid(self) then
                self:PlayEffects(point, radius, index)
            end
        end)
    end
end

function chaotic_crystal_nova:PlayEffects(point, radius, index)
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local damage = self:GetSpecialValueFor("damage")
    local bonus_damage = self:GetSpecialValueFor("bonus_damage")
    local freezing = self:GetSpecialValueFor("freezing")
    local move = self:GetSpecialValueFor("move")
    local abilityDamageType = self:GetAbilityDamageType()

    local total_damage = (damage + bonus_damage * caster:HDGetPrimaryStatValue()) * index
    local freeze_value = freezing * caster:HDGetPrimaryStatValue() * index
    local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
    
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        point,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false
    )
    for _,enemy in pairs(enemies) do
        
        local damageTable = {
            victim = enemy,
            attacker = caster,
            damage = total_damage,
            damage_type = abilityDamageType,
            ability = self,
            hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
        }
        ApplyDamage(damageTable)

        if enemy:IsAlive() then
            enemy:Freezing(caster, self, freeze_value)
            local StatusResistance = enemy:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
            enemy:AddNewModifier(caster, self, "modifier_chaotic_crystal_nova", {duration = duration*StatusResistance, move = move,})
        end
    end

    local particle_cast = "particles/rebuild/chaotic_spell/chaotic_crystal_nova/effect.vpcf"
    local sound_cast = "Hero_Crystal.CrystalNova"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(effect_cast, 0, point)
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius*2, 0, radius*2))
    ParticleManager:ReleaseParticleIndex(effect_cast)
    EmitSoundOnLocationWithCaster(point, sound_cast, caster)
end

-------------------------------------------------------------------
modifier_chaotic_crystal_nova = advanced_modifier({})

function modifier_chaotic_crystal_nova:IsHidden() return false end
function modifier_chaotic_crystal_nova:IsDebuff() return true end
function modifier_chaotic_crystal_nova:IsPurgable() return true end

function modifier_chaotic_crystal_nova:OnCreated()
    self.move = self:GetAbility():GetSpecialValueFor("move")
end

function modifier_chaotic_crystal_nova:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT }
end

function modifier_chaotic_crystal_nova:GetModifierMoveSpeedBonus_Constant()
    if not self:GetAbility() then self:Destroy() return end
    return -self.move
end
