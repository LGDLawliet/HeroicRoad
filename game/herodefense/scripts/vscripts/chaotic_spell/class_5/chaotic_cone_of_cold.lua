LinkLuaModifier("modifier_chaotic_cone_of_cold_debuff", "chaotic_spell/class_5/chaotic_cone_of_cold", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_cone_of_cold_rune2", "chaotic_spell/class_5/chaotic_cone_of_cold", LUA_MODIFIER_MOTION_NONE)
chaotic_cone_of_cold = class({})

function chaotic_cone_of_cold:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

function chaotic_cone_of_cold:GetCooldown(iLevel)
	local cd =  self:GetSpecialValueFor("cd")
	if self:GetRuneType()==3 then
		cd = cd * (1-self:GetSpecialValueFor("rune_3_cd")*0.01)
	end
	return cd
end

function chaotic_cone_of_cold:GetBehavior()
	if self:GetRuneType()==3 then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL
	end
	return self.BaseClass.GetBehavior(self)
end

function chaotic_cone_of_cold:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end
	return UF_SUCCESS
end

function chaotic_cone_of_cold:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_sector_finder.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	local end_width = self:GetSpecialValueFor("end_width")+50
	local start_width = self:GetSpecialValueFor("start_width")+75

	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(end_width,start_width,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
	if self:GetRuneType()==1 then
		self.effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( self.effect_cast2, 3, Vector(end_width,start_width,0))
		ParticleManager:SetParticleControl( self.effect_cast2, 4, Vector(0,128,255))
		ParticleManager:SetParticleControl( self.effect_cast2, 6, Vector(1,1,1))
	end
end
function chaotic_cone_of_cold:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()
	local distance = self:GetSpecialValueFor("distance")
	local end_width = self:GetSpecialValueFor("end_width")
	local target_pos = caster_loc + direction* (distance +end_width*0.5)
	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	if self.effect_cast2 then
		local second_target_pos = target_pos+ direction* (distance +end_width*0.5)
		ParticleManager:SetParticleControl( self.effect_cast2, 0,target_pos)
		ParticleManager:SetParticleControl( self.effect_cast2, 1, target_pos)
		ParticleManager:SetParticleControl( self.effect_cast2, 2, second_target_pos)
	end
end

function chaotic_cone_of_cold:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
	if self.effect_cast2 then
		ParticleManager:DestroyParticle( self.effect_cast2, true ) 
		ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
	end
end

function chaotic_cone_of_cold:GetCastRange()
	if IsServer() then
		return 30000
	end
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("distance") - caster:GetCastRangeBonus()

end

function chaotic_cone_of_cold:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_cone_of_cold/frozen_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_cone_of_cold/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_cone_of_cold/main_effect/b.vpcf", context )
	PrecacheResource( "particle", "particles/ui_mouseactions/custom_sector_finder.vpcf", context )
end

function chaotic_cone_of_cold:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	local distance = self:GetSpecialValueFor("distance")

	caster:EmitSound("hero_Crystal.frostbite")
	caster:EmitSound("Hero_Lich.SinisterGaze.Target")
	
	local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():HDGetPrimaryStatValue()
	local freezing = self:GetSpecialValueFor( "freezing" )*self:GetCaster():HDGetPrimaryStatValue()

	if self:GetRuneType() == 2 then
		damage = damage + freezing
		freezing = 0
	end

	local end_width = self:GetSpecialValueFor("end_width")
	local start_width = self:GetSpecialValueFor("start_width")
	local speed = 1200
	self:PlayEffect(caster_loc,direction)
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "",
	    fDistance = distance-(end_width*0.5),
	    fStartRadius = start_width,
	    fEndRadius =end_width,
		vVelocity = direction * speed,
		ExtraData = {
			damage = damage*self:GetEffectGain(),
			freezing = freezing,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)
	if self:GetRuneType()==1 then
		caster:GameTimer(0.35, function()
			if IsValid(self) then
				caster:EmitSound("hero_Crystal.frostbite")
				caster:EmitSound("Hero_Lich.SinisterGaze.Target")
				local new_start_pos = caster:GetAbsOrigin()+ direction* (distance +end_width*0.5)
				info.vSpawnOrigin = new_start_pos
				ProjectileManager:CreateLinearProjectile(info)
				self:PlayEffect(new_start_pos,direction)
			end
		end)	
	end
end


function chaotic_cone_of_cold:OnProjectileHit_ExtraData( target, location,keys)
	if not target then return end
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	self:PlayEffectTarget(target)
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = keys.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
	}
	ApplyDamage(damageTable)


	if IsValid(target) and target:IsAlive() then
		if self:GetRuneType() == 2 then
			target:AddNewModifier(caster, self, "modifier_chaotic_cone_of_cold_rune2", {duration = self:GetSpecialValueFor("rune_2_fly")})
		end

		if keys.freezing > 0 then
			target:Freezing(caster, self, keys.freezing)
		end
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
		local StatusResistance = target:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self, "modifier_chaotic_cone_of_cold_debuff", {duration = duration*StatusResistance})
	end
end

function chaotic_cone_of_cold:PlayEffect(start_pos,dir)
	local particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_cone_of_cold/cast_effect/effect.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, start_pos+Vector(0,0,64))
	ParticleManager:SetParticleControlForward( particle,0,dir)
	ParticleManager:ReleaseParticleIndex(particle)

	local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_cone_of_cold/main_effect/b.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 0, start_pos )
	ParticleManager:SetParticleControl( pfx, 1, start_pos + dir*600 )
	ParticleManager:SetParticleControl( pfx, 2, Vector(1.3,0,0) )
	DestroyParticleByDelay(pfx,3)
end

function chaotic_cone_of_cold:PlayEffectTarget(target)
	local particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_cone_of_cold/frozen_effect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
end


modifier_chaotic_cone_of_cold_debuff = advanced_modifier({})
function modifier_chaotic_cone_of_cold_debuff:IsDebuff()				return true  end
function modifier_chaotic_cone_of_cold_debuff:IsPurgable() 			return true end
function modifier_chaotic_cone_of_cold_debuff:IsPurgeException() 	    return true end
function modifier_chaotic_cone_of_cold_debuff:IsHidden()				return false end
function modifier_chaotic_cone_of_cold_debuff:OnCreated(keys)
	self.move_speed_reduction = -self:GetAbility():GetSpecialValueFor("move_slow")
	self.attack_slow = -self:GetAbility():GetSpecialValueFor("attack_slow")
	self.frozen_duration = GameRules:GetGameTime() + self:GetAbility():GetSpecialValueFor("frozen_duration")
end

function modifier_chaotic_cone_of_cold_debuff:CheckState()
	local state = {}
	if self.frozen_duration>=GameRules:GetGameTime() then
		state[MODIFIER_STATE_FROZEN] = true
	end
	return state
end

function modifier_chaotic_cone_of_cold_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_cone_of_cold_debuff:GetModifierMoveSpeedBonus_Constant() 
	if not self:GetAbility() then self:Destroy() return end
	return   self.move_speed_reduction 
end
function modifier_chaotic_cone_of_cold_debuff:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then self:Destroy() return end
	return  self.attack_slow
end
function modifier_chaotic_cone_of_cold_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:GetModifierMoveSpeedBonus_Constant()
	elseif self._tooltip == 2 then
		return self:GetModifierAttackSpeedBonus_Constant()
	end
end


modifier_chaotic_cone_of_cold_rune2 = advanced_modifier({})

function modifier_chaotic_cone_of_cold_rune2:IsDebuff()				return true end
function modifier_chaotic_cone_of_cold_rune2:IsHidden() 			return true end
function modifier_chaotic_cone_of_cold_rune2:IsPurgable() 			return false end
function modifier_chaotic_cone_of_cold_rune2:IsPurgeException() 	return false end
function modifier_chaotic_cone_of_cold_rune2:IsStunDebuff() 		return true end
function modifier_chaotic_cone_of_cold_rune2:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_chaotic_cone_of_cold_rune2:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_chaotic_cone_of_cold_rune2:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_chaotic_cone_of_cold_rune2:OnRefresh(keys) self:OnCreated(keys) end
function modifier_chaotic_cone_of_cold_rune2:IsMotionController() return true end
function modifier_chaotic_cone_of_cold_rune2:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_chaotic_cone_of_cold_rune2:OnCreated(keys)
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self:GetParent():GetName() ~= "npc_dota_thinker" then
				self:SafeDestroy()
			end
		end
	end
end

function modifier_chaotic_cone_of_cold_rune2:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 200
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
end

function modifier_chaotic_cone_of_cold_rune2:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)

		self.pos = nil
		self.distance = nil 
	end
end