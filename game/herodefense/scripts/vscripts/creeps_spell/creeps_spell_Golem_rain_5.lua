
creeps_spell_Golem_rain_5 = class({})

LinkLuaModifier("modifier_creeps_spell_Golem_rain_5", "creeps_spell/creeps_spell_Golem_rain_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Golem_rain_5_thinker", "creeps_spell/creeps_spell_Golem_rain_5", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Golem_rain_5:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", context )
end
function creeps_spell_Golem_rain_5:GetIntrinsicModifierName()
	return "modifier_creeps_spell_Golem_rain_5"
end

function creeps_spell_Golem_rain_5:OnAbilityPhaseStart()
	local point = self:GetCursorPosition()
	self:PlayEffects( point )
	return true 
end

function creeps_spell_Golem_rain_5:OnAbilityPhaseInterrupted()
	self:StopEffects()
end


function creeps_spell_Golem_rain_5:OnSpellStart()
	self:StopEffects()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_creeps_spell_Golem_rain_5_thinker", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end

function creeps_spell_Golem_rain_5:PlayEffects( point )
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

function creeps_spell_Golem_rain_5:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end
---------------------------------------
modifier_creeps_spell_Golem_rain_5 = advanced_modifier({})

function modifier_creeps_spell_Golem_rain_5:IsHidden()return true end
function modifier_creeps_spell_Golem_rain_5:IsPurgable()return false end
function modifier_creeps_spell_Golem_rain_5:OnCreated()
	self.find = 600
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_creeps_spell_Golem_rain_5:OnIntervalThink()
	local caster = self:GetParent()
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.find, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST , false)
	if #units>0 and self:GetAbility():IsCooldownReady() then
		local point = units[1]:GetAbsOrigin()
		CreateModifierThinker(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_creeps_spell_Golem_rain_5_thinker", -- modifier name
			{}, -- kv
			point,
			caster:GetTeamNumber(),
			false
		)
		self:GetAbility():UseResources(true, true, true, true)
	end
end
----------------------------------
modifier_creeps_spell_Golem_rain_5_thinker = class({})


function modifier_creeps_spell_Golem_rain_5_thinker:IsHidden()
	return true
end

function modifier_creeps_spell_Golem_rain_5_thinker:IsPurgable()
	return false
end


function modifier_creeps_spell_Golem_rain_5_thinker:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	local damage = self.ability:GetSpecialValueFor( "bonus_damage" ) * caster:GetAverageTrueAttackDamage(nil) 
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.count = self.ability:GetSpecialValueFor( "wave_count" )-1
	self.interval = self.ability:GetSpecialValueFor( "interval" )

	

	self.wave = 0
	self.damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
	}
	-- ApplyDamage(damageTable)

	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()
end


function modifier_creeps_spell_Golem_rain_5_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end


function modifier_creeps_spell_Golem_rain_5_thinker:OnIntervalThink()

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
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	self:PlayEffects()
	self.wave = self.wave + 1
	if self.wave>self.count then
		self:Destroy()
	end
end


function modifier_creeps_spell_Golem_rain_5_thinker:PlayEffects()

	local particle_cast = "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.Firestorm"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOn( sound_cast, self.parent )
end
