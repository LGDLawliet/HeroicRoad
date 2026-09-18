Primary_double_edge = class({})


function Primary_double_edge:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", context )
end

function Primary_double_edge:OnSpellStart(talent3Target)
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if talent3Target then
		target = talent3Target
	end

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		return
	end

	-- load data
	local damage = self:GetSpecialValueFor("base_damage") + caster:GetStrength()*self:GetSpecialValueFor("bonus_damage")
	local radius = self:GetSpecialValueFor("radius")

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		target:GetOrigin(),	nil,
		radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,	false
	)

	-- Precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	-- Apply aoe damage
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	-- Apply self-damage
	if not talent3Target then
		damageTable.victim = caster
		damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		ApplyDamage( damageTable )
	end


	-- Play effects
	self:PlayEffects( target )
end

--------------------------------------------------------------------------------
function Primary_double_edge:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
	local sound_cast = "Hero_Centaur.DoubleEdge"

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end