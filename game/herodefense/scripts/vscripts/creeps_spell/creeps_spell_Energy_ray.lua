require('internal/timers')   --计时器功能
creeps_spell_Energy_ray = creeps_spell_Energy_ray or class({})

function creeps_spell_Energy_ray:IsHiddenWhenStolen() 		return false end
function creeps_spell_Energy_ray:IsRefreshable() 			return true  end
function creeps_spell_Energy_ray:IsStealable() 			return true  end
function creeps_spell_Energy_ray:IsNetherWardStealable() 	return true  end


LinkLuaModifier("modifier_creeps_spell_Energy_ray_caster_dummy", "creeps_spell/creeps_spell_Energy_ray", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Energy_ray_debuff", "creeps_spell/creeps_spell_Energy_ray", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Energy_ray_buff", "creeps_spell/creeps_spell_Energy_ray", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Energy_ray:OnSpellStart()

	

	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end	

	local caster	= self:GetCaster()
	local ability	= self



	local pathLength					= 1500

	local forwardMoveSpeed				= 0
	local turnRateInitial				= 0.1
	local turnRate						= 0.1
	local initialTurnDuration			= 1
	local vision_radius					= 200
	local modifierCasterName			= "modifier_creeps_spell_Energy_ray_caster_dummy"

	local casterOrigin	= caster:GetAbsOrigin()

	

	caster.sun_ray_is_moving = false
	caster.sun_ray_hp_at_start = caster:GetHealth()

	-- Create particle FX
	local particleName = "particles/new_effect/unit/brain_worm/brain_worm_ray.vpcf"

	-- Attach a loop sound to the endcap
	local endcapSoundName = "Hero_Phoenix.SunRay.Beam"
	StartSoundEvent( endcapSoundName, caster )
	StartSoundEvent("Hero_Phoenix.SunRay.Cast", caster)

	--
	-- Note: The turn speed
	--
	--  Original's actual turn speed = 277.7735 (at initial) and 22.2218 [deg/s].
	--  We can achieve this weird value by using this formula.
	--	  actual_turn_rate = turn_rate / (0.0333..) * 0.03
	--
	--  And, initial turn buff ends when the delta yaw gets 0 or 0.75 seconds elapsed.
	--
	turnRateInitial	= turnRateInitial	/ (1/30) * 0.03
	turnRate		= turnRate			/ (1/30) * 0.03

	-- Update
	local deltaTime = 0.02

	local lastAngles = caster:GetAngles()
	local isInitialTurn = true
	local elapsedTime = 0.0

	local dir = 0
	local count = 0
	-- caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.8)
	caster:AddNewModifier(caster, ability, "modifier_creeps_spell_Energy_ray_buff", { duration = 2.7})
	Timers:CreateTimer(0.5, function()
		caster:AddNewModifier(caster, ability, modifierCasterName, { duration = 2.2})
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, nil )
		local attach_point = caster:ScriptLookupAttachment( "attach_head" )
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
		ParticleManager:SetParticleControl(pfx, 9, caster:GetAttachmentOrigin(attach_point))
		local casterOrigin	= caster:GetAbsOrigin()
		local casterForward	= caster:GetForwardVector()
		local endcapPos = casterOrigin + casterForward * pathLength
		ParticleManager:SetParticleControl( pfx, 1, endcapPos )
		caster:SetContextThink( DoUniqueString( "updateSunRay" ), function ( )

			if GameRules:IsGamePaused() then
				return deltaTime
			end

			ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
			ParticleManager:SetParticleControl(pfx, 9, caster:GetAttachmentOrigin(attach_point))
			local casterOrigin	= caster:GetAbsOrigin()
			local casterForward	= caster:GetForwardVector()
			local endcapPos = casterOrigin + casterForward * pathLength
			endcapPos = GetGroundPosition( endcapPos, nil )

			local pos = RotatePosition(casterOrigin, QAngle(0,-0.8*count, 0), endcapPos)
			local direction = (pos - caster:GetAbsOrigin()):Normalized()
			local end_pos = casterOrigin + direction * pathLength
			-- endcapPos.z = endcapPos.z + 92
			pathLength = pathLength+20
			if count>=20 then
				dir = 1
			end
			if dir==0 then
				count = count +1
			else
				count = count -1
			end
			
			-- -- Update particle FX
			-- print(end_pos)

			ParticleManager:SetParticleControl( pfx, 1, end_pos )


			-- OnInterrupted :
			--  Destroy FXs and the thinkers.
			if not caster:HasModifier( modifierCasterName ) then
				ParticleManager:DestroyParticle( pfx, false )
				ParticleManager:ReleaseParticleIndex(pfx)
				StopSoundEvent( endcapSoundName, caster )
				caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
				return nil
			end



			local deltaYawMax

			if isInitialTurn then
				deltaYawMax = turnRateInitial * deltaTime
			else
				deltaYawMax = turnRate * deltaTime
			end

			-- Calculate the delta yaw
			local currentAngles	= caster:GetAngles()
			local deltaYaw		= RotationDelta( lastAngles, currentAngles ).y
			local deltaYawAbs	= math.abs( deltaYaw )

			if deltaYawAbs > deltaYawMax  then
				-- Clamp delta yaw
				local yawSign = (deltaYaw < 0) and -1 or 1
				local yaw = lastAngles.y + deltaYawMax * yawSign

				currentAngles.y = yaw	-- Never forget!

				-- Update the yaw
				-- caster:SetAngles( currentAngles.x, currentAngles.y, currentAngles.z )
			end

			lastAngles = currentAngles

			-- Update the turning state.
			elapsedTime = elapsedTime + deltaTime

			if isInitialTurn then
				if deltaYawAbs == 0 then
					isInitialTurn = false
				end
				if elapsedTime >= initialTurnDuration then
					isInitialTurn = false
				end
			end

			-- Current position & direction
			local casterOrigin	= caster:GetAbsOrigin()
			local casterForward	= caster:GetForwardVector()

			-- Move forward
			if caster.sun_ray_is_moving and not GameRules:IsGamePaused() then
				casterOrigin = casterOrigin + casterForward * forwardMoveSpeed * deltaTime
				casterOrigin = GetGroundPosition( casterOrigin, caster )
				caster:SetAbsOrigin( casterOrigin )
			end





			-- Dmg and heal
			local units = FindUnitsInLine(caster:GetTeamNumber(),
				caster:GetAbsOrigin() + caster:GetForwardVector() * 32 ,
				end_pos,
				nil,
				200,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE)
			for _,unit in pairs(units) do
				unit:AddNewModifier(caster, ability, "modifier_creeps_spell_Energy_ray_debuff", { duration = 0.2 } )
			end



			return deltaTime

			end, 0.0 )

	end)


end



modifier_creeps_spell_Energy_ray_caster_dummy = modifier_creeps_spell_Energy_ray_caster_dummy or class({})

function modifier_creeps_spell_Energy_ray_caster_dummy:IsDebuff()			return false end
function modifier_creeps_spell_Energy_ray_caster_dummy:IsHidden() 			return true  end
function modifier_creeps_spell_Energy_ray_caster_dummy:IsPurgable() 		return false end
function modifier_creeps_spell_Energy_ray_caster_dummy:IsPurgeException() 	return false end
function modifier_creeps_spell_Energy_ray_caster_dummy:IsStunDebuff() 		return false end
function modifier_creeps_spell_Energy_ray_caster_dummy:RemoveOnDeath() 	return true  end

function modifier_creeps_spell_Energy_ray_caster_dummy:DeclareFunctions()
	local funcs = { 
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,

	}
	return funcs
end

function modifier_creeps_spell_Energy_ray_caster_dummy:CheckState()
	return{ [MODIFIER_STATE_DISARMED] = true,
		}
end


function modifier_creeps_spell_Energy_ray_caster_dummy:GetOverrideAnimationRate()
	return 0.9
end


function modifier_creeps_spell_Energy_ray_caster_dummy:GetEffectName()
	return "particles/units/brain_worm/brain_worm_ray_ambent.vpcf"
end

function modifier_creeps_spell_Energy_ray_caster_dummy:OnCreated()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	-- caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	-- caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.9)
	StartSoundEvent("Hero_Phoenix.SunRay.Loop", caster)



end


function modifier_creeps_spell_Energy_ray_caster_dummy:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	caster:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	StartSoundEvent("Hero_Phoenix.SunRay.Stop", caster)
	StopSoundEvent( "Hero_Phoenix.SunRay.Loop", caster)
	if self.pfx_sunray_flare then
		ParticleManager:DestroyParticle(self.pfx_sunray_flare, false)
		ParticleManager:ReleaseParticleIndex(self.pfx_sunray_flare)
	end
	-- Swap sub ability
	caster.sun_ray_is_moving = false

	caster:SetContextThink( DoUniqueString("waitToFindClearSpace"), function ( )

			if not caster:HasModifier("modifier_naga_siren_song_of_the_siren") then
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin() , false)
				return nil
			end

			return 0.1
	end, 0 )
end




modifier_creeps_spell_Energy_ray_debuff = modifier_creeps_spell_Energy_ray_debuff or class({})

function modifier_creeps_spell_Energy_ray_debuff:IsDebuff()				return false end
function modifier_creeps_spell_Energy_ray_debuff:IsHidden() 				return true end
function modifier_creeps_spell_Energy_ray_debuff:IsPurgable() 				return false end
function modifier_creeps_spell_Energy_ray_debuff:IsPurgeException() 		return false end
function modifier_creeps_spell_Energy_ray_debuff:IsStunDebuff() 			return false end
function modifier_creeps_spell_Energy_ray_debuff:RemoveOnDeath() 			return true end
function modifier_creeps_spell_Energy_ray_debuff:IgnoreTenacity() 			return true end

function modifier_creeps_spell_Energy_ray_debuff:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf" end

function modifier_creeps_spell_Energy_ray_debuff:CheckState()
	local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true,[MODIFIER_STATE_SILENCED] = true}

	return state
end
function modifier_creeps_spell_Energy_ray_debuff:OnCreated()


	if not IsServer() then
		return
	end
	self.damage = self:GetCaster():GetDamageMax()*0.2


	self:StartIntervalThink( 0.1 )
end



function modifier_creeps_spell_Energy_ray_debuff:OnIntervalThink()
	if not IsServer() then
		return
	end

	local ability = self:GetAbility()
	local caster = self:GetCaster()


	if not caster:HasModifier("modifier_creeps_spell_Energy_ray_caster_dummy") then
		return
	end

	
	local enemy = self:GetParent()

	local total_damage = self.damage

	local damageTable = {
		victim = enemy,
		attacker = caster,
		damage = total_damage,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = ability, --Optional.
		}
	ApplyDamage(damageTable)


	-- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf", PATTACH_ABSORIGIN, enemy )
	-- ParticleManager:SetParticleControlEnt( pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
	-- ParticleManager:DestroyParticle( pfx, false )
	-- ParticleManager:ReleaseParticleIndex( pfx )



end






modifier_creeps_spell_Energy_ray_buff = advanced_modifier({})

function modifier_creeps_spell_Energy_ray_buff:IsDebuff() return false end
function modifier_creeps_spell_Energy_ray_buff:IsHidden() return true end
function modifier_creeps_spell_Energy_ray_buff:IsPurgable() return false end

function modifier_creeps_spell_Energy_ray_buff:Advanced_GetModifierIncomingDamage_Percentage()return -80 end

function modifier_creeps_spell_Energy_ray_buff:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}

	return state
end


function modifier_creeps_spell_Energy_ray_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
	return funcs
end
function modifier_creeps_spell_Energy_ray_buff:Advanced_GetModifier_StatusResistance(keys)
	return 150
end

