Primary_lucent_beam = class({})



function Primary_lucent_beam:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", context )
end


function Primary_lucent_beam:OnAbilityPhaseStart()
	-- play effects
	self:PlayEffects1()
	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function Primary_lucent_beam:OnSpellStart()
	-- unit identifier
	-- local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	self:CreateSingleLucent(target)
	-- load data
	
end
function Primary_lucent_beam:CreateSingleLucent(target)
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
end

function Primary_lucent_beam:CreateSingleLucent_luna(target)
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueFor("base_damage")+caster:GetAgility()*self:GetSpecialValueFor("bonus_damage")

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage*0.3,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)

	self:PlayEffects2( target )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function Primary_lucent_beam:PlayEffects1()
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

function Primary_lucent_beam:PlayEffects2( target )
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