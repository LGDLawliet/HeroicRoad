leshrac_challenge_pulse_nova = leshrac_challenge_pulse_nova or class({})
LinkLuaModifier( "modifier_leshrac_challenge_pulse_nova", "creeps_spell/leshrac_challenge_pulse_nova", LUA_MODIFIER_MOTION_NONE )


function leshrac_challenge_pulse_nova:GetIntrinsicModifierName() return "modifier_leshrac_challenge_pulse_nova" end

function leshrac_challenge_pulse_nova:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", context )

end

modifier_leshrac_challenge_pulse_nova = modifier_leshrac_challenge_pulse_nova or class({})
function modifier_leshrac_challenge_pulse_nova:IsHidden()	return true end
function modifier_leshrac_challenge_pulse_nova:IsDebuff()	return false end
function modifier_leshrac_challenge_pulse_nova:IsPurgable()	return false end
function modifier_leshrac_challenge_pulse_nova:OnCreated( kv )
	if not IsServer() then return end
	-- references
	
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage_index = 1
	local interval = 1

	-- precache
	self.parent = self:GetParent()
	self:OnIntervalThink()
	self:StartIntervalThink( interval )
	local sound_loop = "Hero_Leshrac.Pulse_Nova"
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_leshrac_challenge_pulse_nova:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "Hero_Leshrac.Pulse_Nova"
	StopSoundOn( sound_loop, self.parent )
end

function modifier_leshrac_challenge_pulse_nova:OnIntervalThink()
	if self.parent:IsNull() or not self.parent:IsAlive() then
		return
	end
	-- spend mana
	local ability = self:GetAbility()
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local damage = ability:GetSpecialValueFor( "damage" )*self.parent:GetDamageMax()*self.damage_index
	self.damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		self:PlayEffects( enemy )
	end


	self.radius = math.min(self.radius+4,1100)
	self.damage_index = math.min(self.damage_index+0.02,5)
end

function modifier_leshrac_challenge_pulse_nova:GetEffectName()
	return "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf"
end

function modifier_leshrac_challenge_pulse_nova:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_leshrac_challenge_pulse_nova:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
	local sound_cast = "Hero_Leshrac.Pulse_Nova_Strike"

	-- radius
	local radius = 100

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOn( sound_cast, target )
end
