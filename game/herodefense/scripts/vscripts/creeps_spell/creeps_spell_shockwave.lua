creeps_spell_shockwave = class({})
LinkLuaModifier( "modifier_creeps_spell_shockwave", "creeps_spell/creeps_spell_shockwave", LUA_MODIFIER_MOTION_NONE )

function creeps_spell_shockwave:OnAbilityPhaseStart()
	if not IsServer() then return end
	self:PlayEffects1()
	return true
end

function creeps_spell_shockwave:OnAbilityPhaseInterrupted()
	if not IsServer() then return end
	self:StopEffects1( true )
end


function creeps_spell_shockwave:OnSpellStart()

	local caster = self:GetCaster()
	
	local origin = caster:GetOrigin()
	-- 预防目标位置等于自身位置导致的bug
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end
	local point = self:GetCursorPosition()

	self:StopEffects1( false )

	local name = "particles/units/heroes/hero_magnataur/magnataur_shockwave_rebuild.vpcf"
	local distance = self:GetCastRange( point, nil )
	local radius = self:GetSpecialValueFor("radius")
	local speed = 1500

	local direction = point - origin
	direction.z = 0
	direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = origin,
		
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
	ProjectileManager:CreateLinearProjectile(info)
	if _G.GAME_DIFFICULTY>=4 then
		local newpos1 = RotatePosition(origin, QAngle(0, 60, 0), point)
		local newpos2 = RotatePosition(origin, QAngle(0, -60, 0), point)
		direction = newpos1 - origin
		direction.z = 0
		direction = direction:Normalized()
		info.vVelocity = direction*speed
		ProjectileManager:CreateLinearProjectile(info)
		direction = newpos2 - origin
		direction.z = 0
		direction = direction:Normalized()
		info.vVelocity = direction*speed
		ProjectileManager:CreateLinearProjectile(info)
	end

	local sound_cast = "Hero_Magnataur.ShockWave.Particle"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function creeps_spell_shockwave:OnProjectileHit( target, location )
	if not target then return end

	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")*caster:GetDamageMax()
	local duration = self:GetSpecialValueFor("duration")

	local pull_duration = 0.3
	local pull_distance = 200


	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)


	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance =  target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	-- slow
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_creeps_spell_shockwave", -- modifier name
		{ duration = duration*StatusResistance } -- kv
	)
    if target:IsAlive() then
        -- pull
        local mod = target:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_generic_arc_lua", -- modifier name
            {
                target_x = location.x,
                target_y = location.y,
                duration = pull_duration,
                distance = pull_distance,
                activity = ACT_DOTA_FLAIL,
            } -- kv
        )
        -- play effects
		if mod and not mod:IsNull() then
			self:PlayEffects2( target, mod )
		end
	   
    end

	

	return false
end

--------------------------------------------------------------------------------
-- Effects
function creeps_spell_shockwave:PlayEffects2( target, mod )
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

function creeps_spell_shockwave:PlayEffects1()
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

function creeps_spell_shockwave:StopEffects1( interrupted )
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	local sound_cast = "Hero_Magnataur.ShockWave.Cast"
	StopSoundOn( sound_cast, self:GetCaster() )
end



modifier_creeps_spell_shockwave = class({})


function modifier_creeps_spell_shockwave:IsHidden()	return false end
function modifier_creeps_spell_shockwave:IsDebuff()	return true end
function modifier_creeps_spell_shockwave:IsStunDebuff()	return false end
function modifier_creeps_spell_shockwave:IsPurgable()	return true end
function modifier_creeps_spell_shockwave:GetEffectName()	return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf" end
function modifier_creeps_spell_shockwave:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creeps_spell_shockwave:OnCreated( kv )

	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow" )

	if not IsServer() then return end
end



function modifier_creeps_spell_shockwave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_creeps_spell_shockwave:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end


