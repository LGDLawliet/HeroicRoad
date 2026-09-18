
underlord_challenge_Firestorm = class({})


LinkLuaModifier("modifier_underlord_challenge_Firestorm_effect", "creeps_spell/underlord_challenge_Firestorm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_underlord_challenge_Firestorm_thinker", "creeps_spell/underlord_challenge_Firestorm", LUA_MODIFIER_MOTION_NONE)

function underlord_challenge_Firestorm:Precache( context )

	
	-- PrecacheResource( "particle", "particles/items2_fx/teleport_end.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", context )
	

end

function underlord_challenge_Firestorm:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end


function underlord_challenge_Firestorm:OnAbilityPhaseStart()
	local point = self:GetCursorPosition()

	self:PlayEffects( point )

	return true 
end

function underlord_challenge_Firestorm:OnAbilityPhaseInterrupted()
	self:StopEffects()
end


function underlord_challenge_Firestorm:OnSpellStart()
	self:StopEffects()

	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_underlord_challenge_Firestorm_thinker", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end

--------------------------------------------------------------------------------
function underlord_challenge_Firestorm:PlayEffects( point )
	-- Get Resources
	local particle_cast = "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.Firestorm.Start"

	-- get data
	local radius = self:GetSpecialValueFor( "radius" )

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 2, 2, 2 ) )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function underlord_challenge_Firestorm:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end









modifier_underlord_challenge_Firestorm_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_underlord_challenge_Firestorm_thinker:IsHidden()
	return true
end

function modifier_underlord_challenge_Firestorm_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_underlord_challenge_Firestorm_thinker:OnCreated( kv )
	local caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	local damage = self.ability:GetSpecialValueFor( "bonus_damage" ) * caster:GetDamageMax() 
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.count = self.ability:GetSpecialValueFor( "wave_count" )-1
	self.interval = self.ability:GetSpecialValueFor( "interval" )

	self.burn_duration = self.ability:GetSpecialValueFor( "duration" )
	self.burn_interval = 1
	self.burn_damage = self.ability:GetSpecialValueFor( "health_damage" )

	if not IsServer() then return end

	-- init
	self.wave = 0
	self.damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()
end



function modifier_underlord_challenge_Firestorm_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_underlord_challenge_Firestorm_thinker:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then
		self:SafeDestroy()
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

		-- add debuff
		enemy:AddNewModifier(
			caster, -- player source
			self.ability, -- ability source
			"modifier_underlord_challenge_Firestorm_effect", -- modifier name
			{
				duration = self.burn_duration,
				interval = self.burn_interval,
				damage = self.burn_damage,
			} -- kv
		)
	end

	self:PlayEffects()
	self.wave = self.wave + 1
	if self.wave>=self.count then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_underlord_challenge_Firestorm_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.Firestorm"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end








modifier_underlord_challenge_Firestorm_effect = class({})


function modifier_underlord_challenge_Firestorm_effect:IsHidden()	return false end
function modifier_underlord_challenge_Firestorm_effect:IsDebuff()	return true end
function modifier_underlord_challenge_Firestorm_effect:IsStunDebuff()	return false end
function modifier_underlord_challenge_Firestorm_effect:IsPurgable()	return false end


function modifier_underlord_challenge_Firestorm_effect:OnCreated( kv )
	-- references
	if not IsServer() then return end
	local interval = kv.interval
	self.damage_pct = kv.damage/100

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		-- damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )
end

function modifier_underlord_challenge_Firestorm_effect:OnRefresh( kv )
	if not IsServer() then return end
	self.damage_pct = kv.damage/100
end

function modifier_underlord_challenge_Firestorm_effect:OnRemoved()
end

function modifier_underlord_challenge_Firestorm_effect:OnDestroy()
end


function modifier_underlord_challenge_Firestorm_effect:OnIntervalThink()
	local ablity = self:GetAbility()
	if not ablity or ablity:IsNull() then
		self:SafeDestroy()
		return
	end
	local damage = self:GetParent():GetMaxHealth() * self.damage_pct

	self.damageTable.damage = damage
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_underlord_challenge_Firestorm_effect:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf"
end

function modifier_underlord_challenge_Firestorm_effect:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end