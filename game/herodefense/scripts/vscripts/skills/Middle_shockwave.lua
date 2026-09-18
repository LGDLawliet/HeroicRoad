Middle_shockwave = class({})
LinkLuaModifier( "modifier_Middle_shockwave", "skills/Middle_shockwave", LUA_MODIFIER_MOTION_NONE )

function Middle_shockwave:OnAbilityPhaseStart()
	if not IsServer() then return end

	-- play effects
	self:PlayEffects1()

	return true
end

function Middle_shockwave:OnAbilityPhaseInterrupted()
	if not IsServer() then return end

	-- stop effects
	self:StopEffects1( true )
end

function Middle_shockwave:Spawn()
	self.active_proj = {}
end

--------------------------------------------------------------------------------
-- Ability Start
function Middle_shockwave:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	if point ==caster:GetAbsOrigin() then
		point = point +caster:GetForwardVector()
	end

	-- stop effects
	self:StopEffects1( false )

	-- load data
	local name = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
	local distance = self:GetCastRange( point, nil )
	local radius = 200
	local speed = 1200

	local direction = point - caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = name,
	    fDistance = distance,
	    fStartRadius = radius,
	    fEndRadius = radius,
		vVelocity = direction * speed,
	}
	local particle = ProjectileManager:CreateLinearProjectile(info)
	self.active_proj[particle] = {
		bonus_projectile = 1,
		sourcePos = caster:GetAbsOrigin(),
		startPos = caster:GetAbsOrigin(),
		damage_index = 1,
	}
	-- play effects
	local sound_cast = "Hero_Magnataur.ShockWave.Particle"
	EmitSoundOn( sound_cast, caster )
end

function Middle_shockwave:OnProjectileHitHandle( target, location, handle )
	if IsServer() then
		local caster = self:GetCaster()

		if not target then
			print(handle)
			if self.active_proj[handle].bonus_projectile >0 then
				local name = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
				local point = self.active_proj[handle].sourcePos
				if point==location then
					point = point + caster:GetForwardVector()
				end
				local distance = self:GetCastRange(point, nil )
				local radius = 200
				local speed = 1200
			
				local direction = point - location
				direction.z = 0
				direction = direction:Normalized()
			
				-- create projectile
				local info = {
					Source = caster,
					Ability = self,
					vSpawnOrigin =location,
					
					bDeleteOnHit = false,
					
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					
					EffectName = name,
					fDistance = distance,
					fStartRadius = radius,
					fEndRadius = radius,
					vVelocity = direction * speed,


					bHasFrontalCone = false,
					bReplaceExisting = false,
				}
	
				local particle = ProjectileManager:CreateLinearProjectile(info)
				self.active_proj[particle] = {
					sourcePos = point,
					damage_index = 0.5,
					startPos = self.active_proj[handle].startPos,
					bonus_projectile = self.active_proj[handle].bonus_projectile-1,
				}
			end
			self.active_proj[handle] = nil

			return true
		end


		

		-- get data
		
		local damage = (self:GetSpecialValueFor( "damage" )+self:GetSpecialValueFor( "bonus_damage" )*caster:GetStrength())*self.active_proj[handle].damage_index
		local duration = self:GetSpecialValueFor( "slow_duration" )
	
		local pull_duration = 0.4
		local pull_distance = 200
	
		-- pull
		local mod = target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				target_x = self.active_proj[handle].startPos.x,
				target_y = self.active_proj[handle].startPos.y,
				duration = pull_duration,
				distance = pull_distance,
				activity = ACT_DOTA_FLAIL,
			} -- kv
		)
	

		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	
		-- slow
		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Middle_shockwave", -- modifier name
			{ duration = duration*StatusResistance } -- kv
		)
	
		-- play effects
		self:PlayEffects2( target, mod )
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
	end
end
--------------------------------------------------------------------------------
-- Effects
function Middle_shockwave:PlayEffects2( target, mod )
	if not mod then
		return
	end
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_shockwave_hit.vpcf"
	local sound_cast = "Hero_Magnataur.ShockWave.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	mod:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

function Middle_shockwave:PlayEffects1()
	local caster = self:GetCaster()

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf"
	local sound_cast = "Hero_Magnataur.ShockWave.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, caster )
end

function Middle_shockwave:StopEffects1( interrupted )
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	local sound_cast = "Hero_Magnataur.ShockWave.Cast"
	StopSoundOn( sound_cast, self:GetCaster() )
end




modifier_Middle_shockwave = class({})


function modifier_Middle_shockwave:IsHidden()	return false end
function modifier_Middle_shockwave:IsDebuff()	return true end
function modifier_Middle_shockwave:IsStunDebuff()	return false end
function modifier_Middle_shockwave:IsPurgable()	return true end
function modifier_Middle_shockwave:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow" )
	if not IsServer() then return end
end


function modifier_Middle_shockwave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Middle_shockwave:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end


function modifier_Middle_shockwave:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf"
end

function modifier_Middle_shockwave:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end