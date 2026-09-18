Middle_timber_chain = class({})

require("internal/timers")
LinkLuaModifier( "modifier_Middle_timber_chain", "skills/Middle_timber_chain", LUA_MODIFIER_MOTION_HORIZONTAL )

function Middle_timber_chain:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timber_dmg.vpcf", context )
end


function Middle_timber_chain:CastFilterResultTarget(target)
	-- check nohammer
	if IsClient() then
		return
	end
	if target==self:GetCaster() then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end
function Middle_timber_chain:GetCustomCastErrorTarget(target)
	if IsClient() then
		return
	end
	return "#Spells_CustomCastError_NOT_SELF"
end
function Middle_timber_chain:GetCastRange(vLocation, hTarget)
	-- if IsServer() then return 900000 end
	return self:GetSpecialValueFor( "range" )
end
function Middle_timber_chain:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = caster:GetCursorCastTarget()
	local point =target:GetOrigin()
	-- load data
	local projectile_speed = 3000
	if caster:HasAbility("heroTalent_npc_dota_hero_shredder_2") then
		projectile_speed = projectile_speed * 1.5
	end
	local projectile_distance = self:GetSpecialValueFor( "range" )
	local projectile_radius = self:GetSpecialValueFor( "radius" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	local vision = 100

	local effect = self:PlayEffects( caster:GetOrigin() + projectile_direction * projectile_distance, projectile_speed, projectile_distance/projectile_speed )

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    EffectName = "",
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = vision,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}

	-- register projectile
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	local ExtraData = {
		effect = effect,
		target = target,
	}
	self.projectiles[ projectile ] = ExtraData
end
function Middle_timber_chain:Spawn()
	self.projectiles = {}
end


function Middle_timber_chain:OnProjectileThinkHandle( handle )
	-- get data
	local ExtraData = self.projectiles[ handle ]
	local location = ProjectileManager:GetLinearProjectileLocation( handle )

	-- search for tree
	local target = ExtraData.target

	if CalculateDistance(target,location)<=250 then
		local point = target:GetOrigin()
		local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_shredder_2")
		if ability and ability:GetAutoCastState() then
			self:ModifyEffectsTalent(ExtraData.effect,target)
			ProjectileManager:DestroyLinearProjectile( handle )
			self.projectiles[ handle ] = nil

			-- add vision
			AddFOWViewer( self:GetCaster():GetTeamNumber(), point, 400, 1, true )
			point = self:GetCaster():GetOrigin()
			target:AddNewModifier(
					self:GetCaster(), -- player source
					self, -- ability source
					"modifier_Middle_timber_chain", -- modifier name
					{
						duration = 3,
						point_x = point.x,
						point_y = point.y,
						point_Z = point.z,
						effect = ExtraData.effect,
					} -- kv
			)

			return
		end
		-- snag
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_Middle_timber_chain", -- modifier name
			{
				duration = 3,
				point_x = point.x,
				point_y = point.y,
				point_Z = point.z,
				effect = ExtraData.effect,
			} -- kv
		)

		-- modify effects
		self:ModifyEffects2( ExtraData.effect, point )

		-- destroy projectile
		ProjectileManager:DestroyLinearProjectile( handle )
		self.projectiles[ handle ] = nil

		-- add vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), point, 400, 1, true )
	end
end

function Middle_timber_chain:OnProjectileHitHandle( target, location, handle )
	local ExtraData = self.projectiles[ handle ]
	if not ExtraData then return end

	self:ModifyEffects1( ExtraData.effect )
	self.projectiles[ handle ] = nil
end

function Middle_timber_chain:PlayEffects( point, speed, duration )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf"
	local sound_cast = "Hero_Shredder.TimberChain.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( speed, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( duration*2 + 0.3, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )

	return effect_cast
end

function Middle_timber_chain:ModifyEffects1( effect )
	-- retract
	ParticleManager:SetParticleControlEnt(
		effect,
		1,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect )

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Retract"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Middle_timber_chain:ModifyEffects2( effect, point )
	-- set particle location
	ParticleManager:SetParticleControl( effect, 1, point )

	-- increase effect duration
	ParticleManager:SetParticleControl( effect, 3, Vector( 64, 0, 0 ) )

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Retract"
	local sound_target = "Hero_Shredder.TimberChain.Impact"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( point, sound_target, self:GetCaster() )
end




function Middle_timber_chain:ModifyEffectsTalent(effect,target)
	ParticleManager:SetParticleControlEnt(
		effect,
		1,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	local sound_cast = "Hero_Shredder.TimberChain.Retract"
	local sound_target = "Hero_Shredder.TimberChain.Impact"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target:GetOrigin(), sound_target, self:GetCaster() )
end






modifier_Middle_timber_chain = class({})


function modifier_Middle_timber_chain:IsHidden()	return true end
function modifier_Middle_timber_chain:IsDebuff()	return false end
function modifier_Middle_timber_chain:IsStunDebuff()	return false end
function modifier_Middle_timber_chain:IsPurgable()	return false end
function modifier_Middle_timber_chain:OnCreated( kv )
	if not IsServer() then return end

	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():HDGetPrimaryStatValue()*self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.speed = 3000
	if self:GetCaster():HasAbility("heroTalent_npc_dota_hero_shredder_2") then
		self.speed = self.speed * 1.5
		damage = damage * 1.5
	end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.point = Vector( kv.point_x, kv.point_y, kv.point_z )
	self.effect = kv.effect

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- init
	self.proximity = 80
	self.caught_enemies = {}
	self.caught_target_count = 0

	-- start motion controller
	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end

function modifier_Middle_timber_chain:OnRefresh( kv )
	if not IsServer() then return end
	local old_effect = self.effect

	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():HDGetPrimaryStatValue()*self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	-- self.speed = 3000
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.point = Vector( kv.point_x, kv.point_y, kv.point_z )
	self.effect = kv.effect

	-- update damage
	self.damageTable.damage = damage

	-- init
	self.caught_enemies = {}
	self.caught_target_count = 0
	-- destroy previous effect
	ParticleManager:DestroyParticle( old_effect, false )
	ParticleManager:ReleaseParticleIndex( old_effect )
end

function modifier_Middle_timber_chain:OnRemoved()
end

function modifier_Middle_timber_chain:OnDestroy()
	if not IsServer() then return end

	-- remove effect
	ParticleManager:DestroyParticle( self.effect, false )
	ParticleManager:ReleaseParticleIndex( self.effect )

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Impact"
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Middle_timber_chain:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_Middle_timber_chain:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local direction = (self.point-origin)
	direction.z = 0
	direction = direction:Normalized()

	-- set origin
	local target = origin + direction * self.speed * dt
	me:SetOrigin( target )

	if self.caught_target_count<=10 then
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			origin,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	
		for _,enemy in pairs(enemies) do
			-- check if already hit
			if not self.caught_enemies[enemy] then
				self.caught_enemies[enemy] = true
				self.caught_target_count =  self.caught_target_count +1
				-- damage
				self.damageTable.victim = enemy
				ApplyDamage( self.damageTable )
	
				-- play effects
				self:PlayEffects( enemy )
			end
		end
	end


	-- destroy if stunned
	if me:IsStunned() then
		me:RemoveHorizontalMotionController( self )
		self:Destroy()
	end

	-- destroy if reached target
	if (self.point-origin):Length2D()<self.proximity then
		-- destroy tree
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 20, true )

		-- set position
		self:GetParent():SetOrigin( self.point )

		-- destroy
		me:RemoveHorizontalMotionController( self )
		self:Destroy()
	end

end

function modifier_Middle_timber_chain:OnHorizontalMotionInterrupted()
	-- destroy
	self:GetParent():RemoveHorizontalMotionController( self )
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_timber_chain:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_timber_dmg.vpcf"
	local sound_cast = "Hero_Shredder.TimberChain.Damage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end