
Primary_light_strike_array = class({})

LinkLuaModifier( "modifier_Primary_light_strike_array", "skills/Primary_light_strike_array", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function Primary_light_strike_array:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

-- Ability Start
function Primary_light_strike_array:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "delay" )

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_light_strike_array", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end


function Primary_light_strike_array:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", context )
end



modifier_Primary_light_strike_array = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_light_strike_array:IsHidden()	return true end
function modifier_Primary_light_strike_array:IsPurgable()	return false end


function modifier_Primary_light_strike_array:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()

	self.stun = ability:GetSpecialValueFor( "duration" )
	self.damage = ability:GetSpecialValueFor( "damage" ) +  ability:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	self.radius = ability:GetSpecialValueFor( "radius" )
	self:PlayEffects1()
end


function modifier_Primary_light_strike_array:OnDestroy()
	if not IsServer() then return end
	-- destroy trees
	
	local ability = self:GetAbility()
	if not ability then
		UTIL_Remove( self:GetParent() )
		return
	end
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, false )
	local caster = self:GetCaster()
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}


	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			ability, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.stun *StatusResistance} -- kv
		)
	end

	-- play effects
	self:PlayEffects2()

	-- remove thinker
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_light_strike_array:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf"
	local sound_cast = "Ability.PreLightStrikeArray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_Primary_light_strike_array:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
	local sound_cast = "Ability.LightStrikeArray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end