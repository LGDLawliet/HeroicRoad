--特效优化 √

LinkLuaModifier( "modifier_Advanced_Unstable_Concoction", "skills/Advanced_Unstable_Concoction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Unstable_Concoction_debuff", "skills/Advanced_Unstable_Concoction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Unstable_Concoction_twice", "skills/Advanced_Unstable_Concoction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Unstable_Concoction_u235", "skills/Advanced_Unstable_Concoction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_stunned_long", "modifier/generic/modifier_generic_stunned_long", LUA_MODIFIER_MOTION_NONE )



LinkLuaModifier( "modifier_Advanced_Unstable_Concoction_unlock1", "skills/Advanced_Unstable_Concoction", LUA_MODIFIER_MOTION_NONE )

Advanced_Unstable_Concoction = class({})


function Advanced_Unstable_Concoction:UnlockFirstCore(key)
    local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Unstable_Concoction_unlock1",{})
	-- self:SetLevel(0)
	-- self:SetLevel(1)
	return true
end
function Advanced_Unstable_Concoction:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Unstable_Concoction:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_howl_unlock3",{})
	return true
end
function Advanced_Unstable_Concoction:CheckKV(key)
	local table = {
	

		max_damage=0.1,
	}
	local value = table[key] or -1
	return value

end


function Advanced_Unstable_Concoction:GetBehavior()
	if self:GetUnlock(1)==1 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return self.BaseClass.GetBehavior(self)
end

function Advanced_Unstable_Concoction:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "brew_explosion" )

	-- add brewing modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Unstable_Concoction", -- modifier name
		{ duration = duration } -- kv
	)

	-- check sister ability
	local ability = caster:FindAbilityByName( "Advanced_Unstable_Concoction_Throw" )
	if not ability then
		ability = caster:AddAbility( "Advanced_Unstable_Concoction_Throw" )
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

function Advanced_Unstable_Concoction:GetCooldown(iLevel)
	local advanced_level = self:GetSpecialValueFor("advanced_level")
	--LV20解锁快速调剂
	if advanced_level>=20 then
		return 12
	end
	return 17
end


function Advanced_Unstable_Concoction:CastToTarget(target)
	
	local caster =  self:GetCaster()
	local ability = caster:FindAbilityByName("Advanced_Unstable_Concoction_Throw")
	if not ability then
		return
	end
	local projectile_name = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf"
	local projectile_speed = ability:GetSpecialValueFor( "movement_speed" )
	local projectile_vision = ability:GetSpecialValueFor( "vision_range" )
	local max_brew = ability:GetSpecialValueFor( "brew_time" )
	


	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = ability,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
		ExtraData = {
			brew_time = max_brew,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Throw"
	EmitSoundOn( sound_cast, caster )
end

function Advanced_Unstable_Concoction:CastToTarget_acid_sparay(target)
	
	local caster =  self:GetCaster()
	local ability = caster:FindAbilityByName("Advanced_Unstable_Concoction_Throw")
	if not ability then
		ability = caster:AddAbility( "Advanced_Unstable_Concoction_Throw" )
		ability:SetLevel(1)
		caster:SwapAbilities(
		"Advanced_Unstable_Concoction_Throw",
		"Advanced_Unstable_Concoction",
		false,
		true
		)
		return
	end
	local projectile_name = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf"
	local projectile_speed = ability:GetSpecialValueFor( "movement_speed" )
	local projectile_vision = ability:GetSpecialValueFor( "vision_range" )
	local max_brew = ability:GetSpecialValueFor( "brew_time" )
	


	-- create projectile
	local info = {
		Target = target,
		Source = target,
		Ability = ability,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
		ExtraData = {
			brew_time = max_brew,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Throw"
	EmitSoundOn( sound_cast, caster )
end

Advanced_Unstable_Concoction_Throw = class({})


function Advanced_Unstable_Concoction_Throw:GetAOERadius()
	return self:GetSpecialValueFor( "midair_explosion_radius" )
end

--------------------------------------------------------------------------------
-- Ability Event
function Advanced_Unstable_Concoction_Throw:OnUpgrade()
	-- if somehow a player got cornered enough to level up Concoction during throw, sync level
	local ability = self:GetCaster():FindAbilityByName( "Advanced_Unstable_Concoction" )
	ability:SetLevel( self:GetLevel() )
end


--------------------------------------------------------------------------------
-- Ability Start
function Advanced_Unstable_Concoction_Throw:OnSpellStart()
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

	local modifier = caster:FindModifierByName( "modifier_Advanced_Unstable_Concoction" )
	if modifier then
		 -- cast by sister ability
		brew_time = math.min( GameRules:GetGameTime()-modifier:GetCreationTime(), max_brew )
		modifier:SafeDestroy()

	elseif Advanced_Unstable_Concoction_Throw.reflected_brew_time then
		-- reflected
		brew_time = Advanced_Unstable_Concoction_Throw.reflected_brew_time

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
	local ability = caster:FindAbilityByName( "Advanced_Unstable_Concoction" )
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
function Advanced_Unstable_Concoction_Throw:OnProjectileHit_ExtraData( target, location, ExtraData )
	if not target then return end
	if not IsServer() then
		return
	end

	local ability = self:GetCaster():FindAbilityByName( "Advanced_Unstable_Concoction" )
	if ability then
		self.advanced_level = ability.advanced_level
	end
	-- obtain data
	local brew_time = ExtraData.brew_time

	-- unique reflect interaction
	-- store brew time to static class variable
	self.reflected_brew_time = brew_time

	-- check if the ability GOT TRIGGERED BY SOMETHING TRIVIAL
	local TRIGGERED = target:TriggerSpellAbsorb( self )

	-- clean up static variable
	self.reflected_brew_time = nil

	-- calm down if you GOT TRIGGERED
	if TRIGGERED then return end

	-- load data
	local max_brew = self:GetSpecialValueFor( "brew_time" )
	--LV20解锁快速调剂
	if self.advanced_level>=20 then
		max_brew = max_brew*0.5
	end
	local abilitySource = ability or self

	local min_stun = abilitySource:GetSpecialValueFor( "min_stun" )
	local max_stun = abilitySource:GetSpecialValueFor( "max_stun" )
	local min_damage = abilitySource:GetSpecialValueFor( "min_damage" )*self:GetCaster():GetBaseDamageMax()
	local max_damage = (abilitySource:GetSpecialValueFor( "max_damage" ))*self:GetCaster():GetBaseDamageMax()
	local radius = abilitySource:GetSpecialValueFor( "midair_explosion_radius" )
    

	-- calculate stun and damage
	local gain = brew_time/max_brew
	local stun = (brew_time/max_brew)*(max_stun-min_stun) + min_stun
	local damage = (brew_time/max_brew)*(max_damage-min_damage) + min_damage
	
	--LV15解锁化学反应
	if self.advanced_level>=15 then
		target:AddNewModifier(
			self:GetCaster(), -- player source
			abilitySource, -- ability source
			"modifier_Advanced_Unstable_Concoction_debuff", -- modifier name
			{ } -- kv
		)
	end

	--添加辐射
	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local time_index = 2
	--LV5解锁辐射+
	if self.advanced_level>=5 then
		time_index = 3
	end
	local u235_duration = stun*time_index*StatusResistance
	if ability.unlock3 then
		u235_duration = 20
	end
	target:AddNewModifier(
		self:GetCaster(), -- player source
		ability, -- ability source
		"modifier_Advanced_Unstable_Concoction_u235", -- modifier name
		{ duration = u235_duration ,gain = gain} -- kv
	)

		--再调配
		target:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_Advanced_Unstable_Concoction_twice", -- modifier name
			{ duration = 5.5 ,gain = gain} -- kv
		)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
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
			self, -- ability source
			"modifier_generic_stunned_long", -- modifier name
			{ duration = stun *StatusResistance} -- kv
		)
	end

	-- Play effects
	self:PlayEffects( target )
end

------------------------------------------------------------------------------
function Advanced_Unstable_Concoction_Throw:PlayEffects( target )
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
modifier_Advanced_Unstable_Concoction = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Unstable_Concoction:IsHidden()
	return true
end

function modifier_Advanced_Unstable_Concoction:IsDebuff()
	return false
end

function modifier_Advanced_Unstable_Concoction:IsStunDebuff()
	return false
end

function modifier_Advanced_Unstable_Concoction:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Unstable_Concoction:OnCreated( kv )
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

function modifier_Advanced_Unstable_Concoction:OnRefresh( kv )
	
end

function modifier_Advanced_Unstable_Concoction:OnRemoved()
end

function modifier_Advanced_Unstable_Concoction:OnDestroy()
	if not IsServer() then return end

	-- play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Fuse"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Unstable_Concoction:OnIntervalThink()
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
			{ duration = self.max_stun*StatusResistance } -- kv
		)
	end

	-- switch ability layout
	local ability = self:GetCaster():FindAbilityByName( "Advanced_Unstable_Concoction_Throw" )
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
function modifier_Advanced_Unstable_Concoction:PlayEffects1( target )
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

function modifier_Advanced_Unstable_Concoction:PlayEffects2()
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




--辐射

modifier_Advanced_Unstable_Concoction_u235		= class({})

function modifier_Advanced_Unstable_Concoction_u235:IsHidden()		return false end
function modifier_Advanced_Unstable_Concoction_u235:IsPurgable()		return false  end
function modifier_Advanced_Unstable_Concoction_u235:IsPurgeException()		return true  end
function modifier_Advanced_Unstable_Concoction_u235:RemoveOnDeath()	return false end

function modifier_Advanced_Unstable_Concoction_u235:OnCreated(keys)
	if IsClient() then return end

	local damage = self:GetCaster():GetMaxHealth()*0.05*keys.gain
	if self:GetAbility().unlock3 then
		damage = self:GetCaster():GetMaxHealth()*0.1*keys.gain
	end
	-- print("damage="..damage)
	-- print("gain="..keys.gain)
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	if damage and damage >0 then
		self:StartIntervalThink(1)
		
	end
end

function modifier_Advanced_Unstable_Concoction_u235:OnIntervalThink()
	if IsClient() then
		return
	end


	-- ApplyDamage(damageTable)

	-- find units in radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		self:PlayEffects2( enemy )
	end

end



function modifier_Advanced_Unstable_Concoction_u235:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_tick_damage.vpcf"
	local sound_target = "Hero_Grimstroke.InkSwell.Damage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	


	-- Create Sound
	EmitSoundOn( sound_target, target )
end




--------------------------------------------------------------------------------
modifier_Advanced_Unstable_Concoction_twice = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Unstable_Concoction_twice:IsHidden()	return true end
function modifier_Advanced_Unstable_Concoction_twice:IsDebuff() 	return false end
function modifier_Advanced_Unstable_Concoction_twice:IsStunDebuff() 	return false end
function modifier_Advanced_Unstable_Concoction_twice:IsPurgable()	return false end
function modifier_Advanced_Unstable_Concoction_twice:IsPurgeException()	return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Unstable_Concoction_twice:OnCreated( kv )
	-- references


	if not IsServer() then return end

	-- self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.gain = kv.gain
	self.tick_interval = 0.5
	self.tick = kv.duration
	self.tick_halfway = true
	-- Start interval
	self:StartIntervalThink( self.tick_interval )
	-- play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Fuse"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_Advanced_Unstable_Concoction_twice:OnRefresh( kv )
	
end

function modifier_Advanced_Unstable_Concoction_twice:OnRemoved()
end

function modifier_Advanced_Unstable_Concoction_twice:OnDestroy()
	if not IsServer() then return end

	-- play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Fuse"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Unstable_Concoction_twice:OnIntervalThink()
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
	local damage_index= 2
	--LV10解锁再调制+
	if self:GetAbility().advanced_level >=10 then
		damage_index = 3
	end
	local damage = self:GetParent():GetDamageMax()*damage_index*self.gain
	local maxdamage = self:GetCaster():GetDamageMax()*5*self.gain
	damage = math.min(damage, maxdamage)
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- find units in radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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

	end


	-- Play effects
	self:PlayEffects1( self:GetParent() )

	-- destroy
	self:SafeDestroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_Unstable_Concoction_twice:PlayEffects1( target )
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

function modifier_Advanced_Unstable_Concoction_twice:PlayEffects2()
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




modifier_Advanced_Unstable_Concoction_debuff = advanced_modifier({})

function modifier_Advanced_Unstable_Concoction_debuff:IsDebuff()			return true end
function modifier_Advanced_Unstable_Concoction_debuff:IsHidden() 			return false end
function modifier_Advanced_Unstable_Concoction_debuff:IsPurgable() 		    return false end
function modifier_Advanced_Unstable_Concoction_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Unstable_Concoction_debuff:RemoveOnDeath()       return false end
function modifier_Advanced_Unstable_Concoction_debuff:OnCreated(keys)
	self.armor_reduce = -7
	self.magical_reduce = -6
	local ability = self:GetAbility()
	if ability:GetUnlock(2)==2 then
		self.armor_reduce = -70
		self.magical_reduce = 0
	end
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Unstable_Concoction_debuff:OnRefresh(keys)
	local ability = self:GetAbility()
	if ability:GetUnlock(2)==2 then
		self.armor_reduce = -70
		self.magical_reduce = 0
	end
	if IsServer() then
		local max = 5
		if ability.unlock2 then
			max = 4
		end
		self:SetStackCount(math.min(self:GetStackCount()+1,max))
		
	end
end

function modifier_Advanced_Unstable_Concoction_debuff:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
}
end

function modifier_Advanced_Unstable_Concoction_debuff:GetModifierMagicalResistanceBonus()	return self.magical_reduce*self:GetStackCount() end

function modifier_Advanced_Unstable_Concoction_debuff:Advanced_GetModifierPhysicalArmorBonus()	return self.armor_reduce*self:GetStackCount() end


function modifier_Advanced_Unstable_Concoction_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end











modifier_Advanced_Unstable_Concoction_unlock1 = class({})

function modifier_Advanced_Unstable_Concoction_unlock1:IsDebuff()			return false end
function modifier_Advanced_Unstable_Concoction_unlock1:IsHidden() 			return true end
function modifier_Advanced_Unstable_Concoction_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Unstable_Concoction_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Unstable_Concoction_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Unstable_Concoction_unlock1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Unstable_Concoction_unlock1:OnIntervalThink()
	local caster = self:GetCaster()

	if not caster:IsAlive() then
		return
	end
	local ability = caster:FindAbilityByName("Advanced_Unstable_Concoction_Throw")
	if not ability then
		ability = caster:AddAbility( "Advanced_Unstable_Concoction_Throw" )
		ability:SetLevel(1)
		caster:SwapAbilities(
		"Advanced_Unstable_Concoction_Throw",
		"Advanced_Unstable_Concoction",
		false,
		true
	)
		return
	end
	local ability_base =  caster:FindAbilityByName("Advanced_Unstable_Concoction")
	if not ability_base then
		return
	end
	if ability_base:IsCooldownReady() then
		local radius = math.max(ability:GetCastRange(caster:GetOrigin(), caster)+caster:GetCastRangeBonus(),100)
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
		)

		for _, unit in ipairs(enemies) do
			ability_base:CastToTarget(unit)
			ability_base:StartCooldown(3)
			break
		end
	end
	
end

