Middle_lucent_beam = class({})
LinkLuaModifier("modifier_Middle_lucent_beam_thinker", "skills/Middle_lucent_beam", LUA_MODIFIER_MOTION_NONE)


require('internal/timers')   --计时器功能
function Middle_lucent_beam:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/luna_impact/eclipse_impact_notarget_moonfall.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/indicator/circular/luna_aura/base.vpcf", context )
end
function Middle_lucent_beam:GetAOERadius()
	return 200
end

function Middle_lucent_beam:OnAbilityPhaseStart()
	-- play effects
	self:PlayEffects1()
	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function Middle_lucent_beam:OnSpellStart()
	-- unit identifier
	-- local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	self:CreateSingleLucent(target)

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function Middle_lucent_beam:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(0.4,0,0) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- ParticleManager:SetParticleControlEnt(
	-- 	effect_cast,
	-- 	2,
	-- 	self:GetCaster(),
	-- 	PATTACH_POINT_FOLLOW,
	-- 	"attach_attack1",
	-- 	Vector(0,0,0), -- unknown
	-- 	true -- unknown, true
	-- )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Middle_lucent_beam:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Cast"
	local sound_target = "Hero_Luna.LucentBeam.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	-- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		6,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end



function Middle_lucent_beam:CreateSingleLucent(target)
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueFor("base_damage")+caster:GetAgility()*self:GetSpecialValueFor("bonus_damage")

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = duration*StatusResistance } -- kv
	)

	-- effects
	self:PlayEffects2( target )


	local point = target:GetOrigin()
	local radius = 200
	local wave_count = 1
	local interval = 1
	local delay = 1
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/indicator/circular/luna_aura/base.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(radius, 0, 0 ) )
	
	local duration = wave_count*interval
	Timers:CreateTimer(delay, function()
		if effect_cast then
			ParticleManager:DestroyParticle(effect_cast, true)
			ParticleManager:ReleaseParticleIndex( effect_cast )
		end
	end
	)


	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_lucent_beam_thinker", -- modifier name
		{duration =duration +5,delay = delay}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end


function Middle_lucent_beam:CreateSingleLucent_luna(target)
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueFor("base_damage")+caster:GetAgility()*self:GetSpecialValueFor("bonus_damage")

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)
	-- effects
	self:PlayEffects2( target )


	local point = target:GetOrigin()
	local radius = 200
	local wave_count = 1
	local interval = 1
	local delay = 1
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/indicator/circular/luna_aura/base.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(radius, 0, 0 ) )
	
	local duration = wave_count*interval
	Timers:CreateTimer(delay, function()
		if effect_cast then
			ParticleManager:DestroyParticle(effect_cast, true)
			ParticleManager:ReleaseParticleIndex( effect_cast )
		end
	end
	)
end


modifier_Middle_lucent_beam_thinker = class({})


function modifier_Middle_lucent_beam_thinker:IsHidden()	return true end
function modifier_Middle_lucent_beam_thinker:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_lucent_beam_thinker:OnCreated( keys )




	if not IsServer() then return end

	local caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	local damage =  self.ability:GetSpecialValueFor("base_damage")+caster:GetAgility()*self.ability:GetSpecialValueFor("bonus_damage")
	self.radius = 200
	self.count = 1
	self.interval = 1
	local delay = keys.delay or 1
	self.delay_on = false
	self.wave = 0
	self.damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage*0.6,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
	}

	self:StartIntervalThink( delay )
	
end



function modifier_Middle_lucent_beam_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_lucent_beam_thinker:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then
		self:SafeDestroy()
		return
	end
	if self.ability:IsNull() then
		return
	end

	if not self.delay_on then
		self.delay_on = true
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
		return
	end




	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	self:PlayEffects()
	self.wave = self.wave + 1
	if self.wave>=self.count then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_lucent_beam_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/luna_impact/eclipse_impact_notarget_moonfall.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 5, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end




