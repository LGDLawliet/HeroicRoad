LinkLuaModifier("modifier_chaotic_splinter_blast_debuff", "chaotic_spell/class_6/chaotic_splinter_blast", LUA_MODIFIER_MOTION_NONE)

chaotic_splinter_blast = class({})

function chaotic_splinter_blast:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf", context)
    PrecacheResource("particle", "particles/rebuild/chaotic_spell/chaotic_crystal_nova/effect.vpcf", context)
end

function chaotic_splinter_blast:GetAOERadius()
    local radius = self:GetSpecialValueFor("radius")
	if self:GetRuneType() == 1 then
		radius = radius*self:GetSpecialValueFor("rune_1_radius")*0.01
	end
	return radius
end

function chaotic_splinter_blast:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local rune_type = self:GetRuneType()
	local freezing = self:GetSpecialValueFor("freezing") + self:GetSpecialValueFor("bonus_freezing")*caster:HDGetPrimaryStatValue()
    caster:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Cast")

    local info = {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
        iMoveSpeed = 1600,
        vSourceLoc = caster:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = false,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 10,
        bProvidesVision = true,
        ExtraData = {
			rune_type = rune_type,
			freezing = freezing,
			hit_type = 1
		}
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

function chaotic_splinter_blast:OnProjectileHit_ExtraData(target, location, keys)
    if not target then return end
    local caster = self:GetCaster()
    local hit_type = keys.hit_type
    local rune_type = keys.rune_type or 0

    if hit_type == 1 then
        -- 主弹道命中，处理主目标和分裂弹道
        local is_ally = target:GetTeamNumber() == caster:GetTeamNumber()
        local radius = self:GetSpecialValueFor("radius")
        local max_targets = self:GetSpecialValueFor("max")
        local mana_index = self:GetSpecialValueFor("mana_index")*0.01
        local freezing = keys.freezing or 0

        if is_ally or target == caster then
            local mana_restore = freezing*mana_index
            target:GiveMana(mana_restore)
            SendOverheadEventMessage(target, OVERHEAD_ALERT_MANA_ADD, target, mana_restore, nil)
        else
            target:Freezing(caster, self, freezing)
            target:AddNewModifier(caster, self, "modifier_hd_freezing_frozen", {duration = 3})
        end

        if rune_type == 1 then
            -- 不朽1：延迟爆炸，碎裂伤害部分转为冻伤
            local rune_1_delay = self:GetSpecialValueFor("rune_1_delay")
            local rune_1_index = self:GetSpecialValueFor("rune_1_index")*0.01
            local rune_1_radius = radius*self:GetSpecialValueFor("rune_1_radius")*0.01
            local pos = target:GetAbsOrigin()
            local blast_freezing = (self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue())*rune_1_index
            caster:GameTimer(rune_1_delay, function()
                if not IsValid(self) then return end
                if target:IsAlive() then
                    pos = target:GetAbsOrigin()
                end
                self:PlayEffectMain(pos, rune_1_radius)
                local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, rune_1_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                for i, unit in ipairs(enemies) do
                    unit:Freezing(caster, self, blast_freezing)
                end
            end)
        else
            -- 普通：立即碎裂爆炸，分裂弹道
            local pos = target:GetAbsOrigin()
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for i, unit in ipairs(enemies) do
                if unit ~= target then
                    self:Blast_projectile(target, unit)
                    if i >= max_targets then break end
                end
            end
        end

    elseif hit_type == 0 then
		
        local damage = keys.damage or 0
        ApplyDamage({
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self,
            hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
        })
    end
end

function chaotic_splinter_blast:PlayEffectMain(pos, radius)
	local caster = self:GetCaster()
    local particle_cast = "particles/rebuild/chaotic_spell/chaotic_crystal_nova/effect.vpcf"
    local sound_cast = "Hero_Crystal.CrystalNova"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(effect_cast, 0, pos)
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius*2, 0, radius*2))
    ParticleManager:ReleaseParticleIndex(effect_cast)
    EmitSoundOnLocationWithCaster(pos, sound_cast, caster)
end

function chaotic_splinter_blast:Blast_projectile(origin_target, target)
	if not IsServer() then return end
	if not target then return end
	if not origin_target then return end
	
	local caster = self:GetCaster()
    local rune_type = self:GetRuneType()
	local damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue()

    local info = {
        Target = target,
        Source = origin_target,
        Ability = self,
        EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
        iMoveSpeed = 1600,
        vSourceLoc = origin_target:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = false,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 10,
        bProvidesVision = true,
        ExtraData = {
			rune_type = rune_type,
			damage = damage,
			hit_type = 0
		}
    }
    ProjectileManager:CreateTrackingProjectile(info)
end
