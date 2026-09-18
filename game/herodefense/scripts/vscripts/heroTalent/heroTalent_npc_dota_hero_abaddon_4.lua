-- 自定义技能
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_abaddon_4_passive", "heroTalent/heroTalent_npc_dota_hero_abaddon_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_abaddon_4_debuff", "heroTalent/heroTalent_npc_dota_hero_abaddon_4", LUA_MODIFIER_MOTION_NONE)
heroTalent_npc_dota_hero_abaddon_4 = class({})
function heroTalent_npc_dota_hero_abaddon_4:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/dragon_slave/unlock3/effect_lock_upheaval_hellborn.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/talent/abaddon_4/dragon.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf", context )
end
-- 被动效果
function heroTalent_npc_dota_hero_abaddon_4:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_abaddon_4_passive"
end

-- 主动效果
function heroTalent_npc_dota_hero_abaddon_4:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local ability = self
    local damage = ability:GetSpecialValueFor("radius_damage")*caster:GetStrength()
    local radius = ability:GetSpecialValueFor("radius")
    local duration = ability:GetSpecialValueFor("duration")

    -- 对目标和周围敌人造成伤害
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                      target:GetAbsOrigin(),
                                      nil,
                                      radius,
                                      DOTA_UNIT_TARGET_TEAM_ENEMY,
                                      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                      DOTA_UNIT_TARGET_FLAG_NONE,
                                      FIND_ANY_ORDER,
                                      false)

    for _, enemy in pairs(enemies) do
        ApplyDamage({
            victim = enemy,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability,
            hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
        })

        -- 添加状态效果
        enemy:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_abaddon_4_debuff", {duration = duration})
    end
    
    caster:EmitSound("Hero_Abaddon.Curse.Proc")
    self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/dragon_slave/unlock3/effect_lock_upheaval_hellborn.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( self.effect_cast, 0, target:GetAbsOrigin()  )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(radius,0,0) )
    ParticleManager:DestroyParticle(self.effect_cast,false)
    ParticleManager:ReleaseParticleIndex(self.effect_cast)
end


--------------------------------------------------------------------------------
-- Projectile
function heroTalent_npc_dota_hero_abaddon_4:OnProjectileHitHandle( target, location, projectile )
    if not IsServer() then return end 
	if not target then return end
    local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_abaddon_4_passive")
	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = (self:GetSpecialValueFor("damage")*self:GetCaster():GetStrength())*modifier.ProjectileTable[projectile],
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
	}
	ApplyDamage( damageTable )

	modifier.ProjectileTable[projectile] = modifier.ProjectileTable[projectile] +0.04
	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()

	-- play effects
	modifier:PlayEffects( target, direction )
end
-- 被动效果修饰器

modifier_heroTalent_npc_dota_hero_abaddon_4_passive = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_abaddon_4_passive:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_abaddon_4_passive:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_abaddon_4_passive:ADDeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}}
end

function modifier_heroTalent_npc_dota_hero_abaddon_4_passive:OnAttackLanded(event)
    if not IsServer() then return end
    if event.attacker ~= self:GetParent() then return end
    if event.attacker:IsInSpecialAttack() then return end

    local random = math.random
    local chance = self:GetAbility():GetSpecialValueFor("chance")
    local target = event.target

    if chance >= random(1,100) then
        self:Dragon(target)
    end
end

function modifier_heroTalent_npc_dota_hero_abaddon_4_passive:Dragon(target)
	-- unit identifier
	local caster = self:GetParent()
	local target = target
	local point = target:GetAbsOrigin()

	if not self.ProjectileTable then
		self.ProjectileTable = {}
	end
	-- load data
	local projectile_name = "particles/rebuild/talent/abaddon_4/dragon.vpcf"
	local projectile_distance = self:GetAbility():GetSpecialValueFor( "length" )
	local projectile_speed = 1200
	local projectile_start_radius = self:GetAbility():GetSpecialValueFor("width")
	local projectile_end_radius = self:GetAbility():GetSpecialValueFor("width")

	-- get direction
	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self:GetAbility(),
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	local particle = ProjectileManager:CreateLinearProjectile(info)
    print("创建成功！")
    print(projectile_start_radius)
    print(projectile_end_radius)
	self.ProjectileTable[particle] = 1
	-- Play effects
	local sound_cast = "Hero_Lina.DragonSlave.Cast"
	local sound_projectile = "Hero_Lina.DragonSlave"

	EmitSoundOn( sound_projectile, self:GetCaster() )
end



--------------------------------------------------------------------------------
function modifier_heroTalent_npc_dota_hero_abaddon_4_passive:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end





-- 主动效果debuff修饰器

modifier_heroTalent_npc_dota_hero_abaddon_4_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_abaddon_4_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_abaddon_4_debuff:IsPurgable() return true end
function modifier_heroTalent_npc_dota_hero_abaddon_4_debuff:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_heroTalent_npc_dota_hero_abaddon_4_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_abaddon_4_debuff:ADDeclareFunctions()
    return {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end

function modifier_heroTalent_npc_dota_hero_abaddon_4_debuff:Advanced_GetModifierIncomingDamage_Percentage(event)
    if event.inflictor and event.inflictor:GetName() == "heroTalent_npc_dota_hero_abaddon_4" then
        return self:GetAbility():GetSpecialValueFor("index")*self:GetCaster():GetLevel()  -- 增加100%的伤害，即翻倍
    end
    return 0
end