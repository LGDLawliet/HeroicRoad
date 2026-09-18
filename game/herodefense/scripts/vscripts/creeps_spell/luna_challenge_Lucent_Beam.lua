
luna_challenge_Lucent_Beam = class({})

require('internal/timers')   --计时器功能
LinkLuaModifier("modifier_luna_challenge_Lucent_Beam_effect", "creeps_spell/luna_challenge_Lucent_Beam", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_luna_challenge_Lucent_Beam_thinker", "creeps_spell/luna_challenge_Lucent_Beam", LUA_MODIFIER_MOTION_NONE)

function luna_challenge_Lucent_Beam:Precache( context )

	
	-- PrecacheResource( "particle", "particles/items2_fx/teleport_end.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/indicator/circular/luna_aura/base.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/luna_impact/eclipse_impact_notarget_moonfall.vpcf", context )

	

end

function luna_challenge_Lucent_Beam:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end


function luna_challenge_Lucent_Beam:OnSpellStart()
	

	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	caster:EmitSound("Hero_Luna.LucentBeam.Cast")
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/indicator/circular/luna_aura/base.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(self:GetSpecialValueFor( "radius" ), 0, 0 ) )
	
	local duration = self:GetSpecialValueFor("wave_count")*self:GetSpecialValueFor("interval")
	Timers:CreateTimer(duration+1.5, function()
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
		"modifier_luna_challenge_Lucent_Beam_thinker", -- modifier name
		{duration =duration +5}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end







modifier_luna_challenge_Lucent_Beam_thinker = class({})


function modifier_luna_challenge_Lucent_Beam_thinker:IsHidden()	return true end
function modifier_luna_challenge_Lucent_Beam_thinker:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_luna_challenge_Lucent_Beam_thinker:OnCreated( kv )
	local caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	local damage = self.ability:GetSpecialValueFor( "bonus_damage" ) * caster:GetDamageMax() 
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.count = self.ability:GetSpecialValueFor( "wave_count" )
	self.interval = self.ability:GetSpecialValueFor( "interval" )
	local delay = 1.5


	if not IsServer() then return end

	self.delay_on = false
	self.wave = 0
	self.damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
	}

	self:StartIntervalThink( delay )
	
end



function modifier_luna_challenge_Lucent_Beam_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_luna_challenge_Lucent_Beam_thinker:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then
		self:SafeDestroy()
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
function modifier_luna_challenge_Lucent_Beam_thinker:PlayEffects()
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




