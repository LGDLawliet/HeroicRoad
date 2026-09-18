-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
LinkLuaModifier( "modifier_Primary_Unstable_Concoction", "skills/Primary_Unstable_Concoction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_long", "modifier/generic/modifier_generic_stunned_long", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------------
Primary_Unstable_Concoction = class({})

--------------------------------------------------------------------------------
-- Ability Start
function Primary_Unstable_Concoction:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "brew_explosion" )

	-- add brewing modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Unstable_Concoction", -- modifier name
		{ duration = duration } -- kv
	)

	-- check sister ability
	local ability = caster:FindAbilityByName( "Primary_Unstable_Concoction_Throw" )
	if not ability then
		ability = caster:AddAbility( "Primary_Unstable_Concoction_Throw" )
		ability:SetStolen( true )
	end

	-- check ability level
	ability:SetLevel( self:GetLevel() )

	-- switch ability layout
	caster:SwapAbilities(
		self:GetAbilityName(),
		ability:GetAbilityName(),
		false,
		true
	)
end

--------------------------------------------------------------------------------
-- THROW
--------------------------------------------------------------------------------
Primary_Unstable_Concoction_Throw = class({})

--------------------------------------------------------------------------------
-- Custom KV
function Primary_Unstable_Concoction_Throw:GetAOERadius()
	return self:GetSpecialValueFor( "midair_explosion_radius" )
end

--------------------------------------------------------------------------------
-- Ability Event
function Primary_Unstable_Concoction_Throw:OnUpgrade()
	-- if somehow a player got cornered enough to level up Concoction during throw, sync level
	local ability = self:GetCaster():FindAbilityByName( "Primary_Unstable_Concoction" )
	ability:SetLevel( self:GetLevel() )
end


--------------------------------------------------------------------------------
-- Ability Start
function Primary_Unstable_Concoction_Throw:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local max_brew = self:GetSpecialValueFor( "brew_time" )
	local projectile_name = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "movement_speed" )
	local projectile_vision = self:GetSpecialValueFor( "vision_range" )

	-- obtain brewing time
	local brew_time

	local modifier = caster:FindModifierByName( "modifier_Primary_Unstable_Concoction" )
	if modifier then
		 -- cast by sister ability
		brew_time = math.min( GameRules:GetGameTime()-modifier:GetCreationTime(), max_brew )
		modifier:SafeDestroy()

	elseif Primary_Unstable_Concoction_Throw.reflected_brew_time then
		-- reflected
		brew_time = Primary_Unstable_Concoction_Throw.reflected_brew_time

	elseif self.stored_brew_time then
		-- recast ( Multicast, Soul bind )
		brew_time = self.stored_brew_time

	else
		-- unknown
		brew_time = 0
	end

	--  store brew time in instance variable for later recast (e.g. Multicast)
	self.brew_time = brew_time

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
		ExtraData = {
			brew_time = brew_time,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Throw"
	EmitSoundOn( sound_cast, caster )

	-- switch ability layout
	local ability = caster:FindAbilityByName( "Primary_Unstable_Concoction" )
	if not ability then return end -- reflected

	caster:SwapAbilities(
		self:GetAbilityName(),
		ability:GetAbilityName(),
		false,
		true
	)
end

--------------------------------------------------------------------------------
-- Projectile
function Primary_Unstable_Concoction_Throw:OnProjectileHit_ExtraData( target, location, ExtraData )
	if not target then return end
	if not IsServer() then
		return
	end

	-- obtain data
	local brew_time = ExtraData.brew_time

	-- unique reflect interaction
	-- store brew time to static class variable
	Primary_Unstable_Concoction_Throw.reflected_brew_time = brew_time

	-- check if the ability GOT TRIGGERED BY SOMETHING TRIVIAL
	local TRIGGERED = target:TriggerSpellAbsorb( self )

	-- clean up static variable
	Primary_Unstable_Concoction_Throw.reflected_brew_time = nil

	-- calm down if you GOT TRIGGERED
	if TRIGGERED then return end

	local modifier = self:GetCaster():FindModifierByName( "modifier_Primary_Unstable_Concoction" )
	local ability = self
	if modifier then
		ability = modifier:GetAbility()
	end
	-- load data
	local max_brew = ability:GetSpecialValueFor( "brew_time" )
	local min_stun = ability:GetSpecialValueFor( "min_stun" )
	local max_stun = ability:GetSpecialValueFor( "max_stun" )
	local min_damage = ability:GetSpecialValueFor( "min_damage" )*self:GetCaster():GetBaseDamageMax()
	local max_damage = ability:GetSpecialValueFor( "max_damage" )*self:GetCaster():GetBaseDamageMax()
	local radius = ability:GetSpecialValueFor( "midair_explosion_radius" )
    

	-- calculate stun and damage
	local stun = (brew_time/max_brew)*(max_stun-min_stun) + min_stun
	local damage = (brew_time/max_brew)*(max_damage-min_damage) + min_damage


	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = ability, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- find units in radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		-- debuff
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			ability, -- ability source
			"modifier_generic_stunned_long", -- modifier name
			{ duration = stun *StatusResistance} -- kv
		)
	end

	-- Play effects
	self:PlayEffects( target )
end

------------------------------------------------------------------------------
function Primary_Unstable_Concoction_Throw:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf"
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Stun"

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
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end




--------------------------------------------------------------------------------
modifier_Primary_Unstable_Concoction = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Unstable_Concoction:IsHidden()
	return true
end

function modifier_Primary_Unstable_Concoction:IsDebuff()
	return false
end

function modifier_Primary_Unstable_Concoction:IsStunDebuff()
	return false
end

function modifier_Primary_Unstable_Concoction:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Unstable_Concoction:OnCreated( kv )
	-- references


	if not IsServer() then return end
	self.min_stun = self:GetAbility():GetSpecialValueFor( "min_stun" )
	self.max_stun = self:GetAbility():GetSpecialValueFor( "max_stun" )
	self.min_damage = self:GetAbility():GetSpecialValueFor( "min_damage" )*self:GetCaster():GetBaseDamageMax()
	self.max_damage = self:GetAbility():GetSpecialValueFor( "max_damage" )*self:GetCaster():GetBaseDamageMax()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.tick_interval = 0.5
	self.tick = kv.duration
	self.tick_halfway = true

	-- Start interval
	self:StartIntervalThink( self.tick_interval )

	-- play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Fuse"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_Primary_Unstable_Concoction:OnRefresh( kv )
	
end

function modifier_Primary_Unstable_Concoction:OnRemoved()
end

function modifier_Primary_Unstable_Concoction:OnDestroy()
	if not IsServer() then return end

	-- play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Fuse"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_Unstable_Concoction:OnIntervalThink()
	-- tick
	self.tick = self.tick - self.tick_interval
	if self.tick>0 then
		-- play tick effects
		self.tick_halfway = not self.tick_halfway
		self:PlayEffects2()
		return
	end

	-- explode on head
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.max_damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- find units in radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		-- debuff
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_stunned_long", -- modifier name
			{ duration = self.max_stun*StatusResistance } -- kv
		)
	end

	-- also damages and stuns caster if not invulnerable
	if not self:GetParent():IsInvulnerable() then
		damageTable.victim = self:GetParent()
		ApplyDamage( damageTable )

		-- debuff
		local StatusResistance = self:GetParent():GetHDStatusResistanceIndex(1)
		self:GetParent():AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_stunned_long", -- modifier name
			{ duration = self.max_stun *StatusResistance} -- kv
		)
	end

	-- switch ability layout
	local ability = self:GetCaster():FindAbilityByName( "Primary_Unstable_Concoction_Throw" )
	self:GetCaster():SwapAbilities(
		self:GetAbility():GetAbilityName(),
		ability:GetAbilityName(),
		true,
		false
	)

	-- remove if stolen
	if ability:IsStolen() then
		self:GetCaster():RemoveAbilityByHandle( ability )
	end

	-- Play effects
	self:PlayEffects1( self:GetParent() )

	-- destroy
	self:SafeDestroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_Unstable_Concoction:PlayEffects1( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf"
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Stun"

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
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

function modifier_Primary_Unstable_Concoction:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"

	-- Get data
	local time = math.floor( self.tick )
	local mid = 1
	if self.tick_halfway then mid = 8 end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, time, mid ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 2, 0, 0 ) )

	if time<1 then
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ) )
	end

	ParticleManager:ReleaseParticleIndex( effect_cast )
end