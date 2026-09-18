
wolf_challenge_claw_lunge = class({})
LinkLuaModifier( "modifier_wolf_challenge_claw_lunge", "creeps_spell/wolf_challenge_claw_lunge", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function wolf_challenge_claw_lunge:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:StartGesture( ACT_DOTA_CAST_ABILITY_2 )
		caster:EmitSound("Hero_Lycan.Howl")

		local caster_pos = caster:GetAbsOrigin()
		local point = self:GetCursorPosition()
		if point == caster_pos then
			point = point + caster:GetForwardVector()
		end
		local norm = (point - caster_pos):Normalized()
		point.z = point.z +64
		local target_point = caster:GetAbsOrigin() + norm * 1300
		target_point.z = target_point.z+64
		local fx = ParticleManager:CreateParticle("particles/indicator/new_custom_indicator_range_1.vpcf", PATTACH_WORLDORIGIN, caster)
		-- ParticleManager:SetParticleControlEnt(fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", point, true)
		ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(fx, 2, Vector(2.4,0,0))
		ParticleManager:SetParticleControl(fx, 1, target_point)

		Timers:CreateTimer(1.4, function()
			
			ParticleManager:DestroyParticle( fx, true ) 
			ParticleManager:ReleaseParticleIndex(fx)

	
	
		end)
	end

	return true
end

--------------------------------------------------------------------------------

function wolf_challenge_claw_lunge:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_2 )
		-- ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function wolf_challenge_claw_lunge:OnSpellStart()
	if IsServer() then
		-- ParticleManager:DestroyParticle( self.nPreviewFX, true )
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_2 )

		self.lunge_speed = 1600
		self.lunge_width = 200
		self.lunge_distance = 1300
		self.lunge_damage = self:GetCaster():GetDamageMax()*7
		
		--EmitSoundOn( "Hero_Venomancer.PreAttack", self:GetCaster() )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end
		if vPos == self:GetCaster():GetAbsOrigin() then
			vPos = vPos + self:GetCaster():GetForwardVector()
		end


		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.vProjectileLocation = self:GetCaster():GetOrigin() -- + ( vDirection * 100 )

		local info = {
			EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
			Ability = self,
			vSpawnOrigin = self.vProjectileLocation, 
			fStartRadius = self.lunge_width,
			fEndRadius = self.lunge_width,
			vVelocity = vDirection * self.lunge_speed,
			fDistance = self.lunge_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		}

		ProjectileManager:CreateLinearProjectile( info )

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_wolf_challenge_claw_lunge", {} )
		--EmitSoundOn( "Hero_Bristleback.QuillSpray.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function wolf_challenge_claw_lunge:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			if hTarget:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = hTarget,
					attacker = self:GetCaster(),
					damage = self.lunge_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self,
				}
				ApplyDamage( damageInfo )
			end
		else
			local hBuff = self:GetCaster():FindModifierByName( "modifier_wolf_challenge_claw_lunge" )
			if hBuff ~= nil then
				hBuff:SafeDestroy()
			end
		end
	end

	return false
end

--------------------------------------------------------------------------------

function wolf_challenge_claw_lunge:OnProjectileThink( vLocation )
	if IsServer() then
		self.vProjectileLocation = vLocation
	end
end

--------------------------------------------------------------------------------






modifier_wolf_challenge_claw_lunge = class({})

--------------------------------------------------------------------------------

function modifier_wolf_challenge_claw_lunge:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then 
			self:SafeDestroy()
			return
		end

		self.lunge_width = 250
	end
end

--------------------------------------------------------------------------------

function modifier_wolf_challenge_claw_lunge:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

--------------------------------------------------------------------------------

function modifier_wolf_challenge_claw_lunge:IsHidden()	return true end
function modifier_wolf_challenge_claw_lunge:IsPurgable()	return false end
function modifier_wolf_challenge_claw_lunge:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		local pos = self:GetParent():GetAbsOrigin()
		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x+RandomInt(10, 200),pos.y+RandomInt(10, 200),pos.z) ,true)
	end
end

--------------------------------------------------------------------------------

function modifier_wolf_challenge_claw_lunge:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end


--------------------------------------------------------------------------------

function modifier_wolf_challenge_claw_lunge:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_wolf_challenge_claw_lunge:GetOverrideAnimation( params )
	return ACT_DOTA_RUN
end

--------------------------------------------------------------------------------

function modifier_wolf_challenge_claw_lunge:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		me:SetOrigin( self:GetAbility().vProjectileLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_wolf_challenge_claw_lunge:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end