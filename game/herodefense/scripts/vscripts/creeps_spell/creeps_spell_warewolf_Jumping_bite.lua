
--------------------------------------------------------------------------------
creeps_spell_warewolf_Jumping_bite = class({})
LinkLuaModifier( "modifier_creeps_spell_warewolf_Jumping_bite", "creeps_spell/creeps_spell_warewolf_Jumping_bite", LUA_MODIFIER_MOTION_BOTH )

LinkLuaModifier( "modifier_creeps_spell_warewolf_Jumping_bite_debuff", "creeps_spell/creeps_spell_warewolf_Jumping_bite", LUA_MODIFIER_MOTION_NONE )


function creeps_spell_warewolf_Jumping_bite:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/league_teleport_2014/teleport_start_dust_league.vpcf", context )
end




function creeps_spell_warewolf_Jumping_bite:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	-- pounce
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_creeps_spell_warewolf_Jumping_bite", -- modifier name
		{unit_entindex	= hTarget:entindex()} -- kv
	)


end


modifier_creeps_spell_warewolf_Jumping_bite = class({})

function modifier_creeps_spell_warewolf_Jumping_bite:IsHidden()	return true end
function modifier_creeps_spell_warewolf_Jumping_bite:IsDebuff()	return false end
function modifier_creeps_spell_warewolf_Jumping_bite:IsStunDebuff()	return false end
function modifier_creeps_spell_warewolf_Jumping_bite:IsPurgable()	return true end
function modifier_creeps_spell_warewolf_Jumping_bite:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_creeps_spell_warewolf_Jumping_bite:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end
function modifier_creeps_spell_warewolf_Jumping_bite:GetOverrideAnimationRate()
	return 1
end

function modifier_creeps_spell_warewolf_Jumping_bite:OnCreated( kv )
	self.parent = self:GetParent()

	-- references


	if not IsServer() then return end

	self.target = EntIndexToHScript(kv.unit_entindex)


	local distance = CalculateDistance(self.target ,self.parent)
	if distance==0 then
		self:SafeDestroy()
		return
	end

	local duration =1.5
	local speed = distance/duration
	self.radius = 450   --检测范围



	local height = 150

	self.arc = self.parent:AddNewModifier(
		self.parent, -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			speed = speed,
			duration = duration,
			distance = distance,
			height = height,
		} -- kv
	)
	self.arc:SetEndCallback(function( interrupted )
		-- destroy this modifier when arc ends
		if self:IsNull() then return end
		self.arc = nil
		self:SafeDestroy()
	end)

	-- set duration
	self:SetDuration( duration, true )

	-- set inactive
	self:GetAbility():SetActivated( false )

	-- Start interval
	self:StartIntervalThink( 1.1 )
	-- self:OnIntervalThink()

	-- play effects
	self:PlayEffects()
end


function modifier_creeps_spell_warewolf_Jumping_bite:OnDestroy()
	if not IsServer() then return end

	-- set active
	self:GetAbility():SetActivated( true )




	-- destroy arc modifier
	if self.arc and not self.arc:IsNull() then
		self.arc:SafeDestroy()
	end
end

function modifier_creeps_spell_warewolf_Jumping_bite:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end


function modifier_creeps_spell_warewolf_Jumping_bite:OnIntervalThink()

	self:StartIntervalThink(-1)
	if not self.target or self.target:IsNull() or not self.target:IsAlive() then
		return
	end
	local target
	local pos = self.parent:GetAbsOrigin() + self.parent:GetForwardVector()*200
	local dis = CalculateDistance(pos, self.target)
	if dis<=self.radius then
		target = self.target
	end

	if not target then return end

	local ability = self:GetAbility()

	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
	local StatusResistance = self.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	target:AddNewModifier(
		self.parent, -- player source
		ability, -- ability source
		"modifier_creeps_spell_warewolf_Jumping_bite_debuff", -- modifier name
		{
			duration = ability:GetSpecialValueFor("duration")*StatusResistance
		} 
	)
	local damageTable = {
		victim =target,
		attacker = self.parent,
		damage = self.parent:GetBaseDamageMax() * ability:GetSpecialValueFor("damage"),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = ability, --Optional.
		}
	ApplyDamage(damageTable)


end



function modifier_creeps_spell_warewolf_Jumping_bite:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/events/league_teleport_2014/teleport_start_dust_league.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl(effect_cast, 0,  self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex( effect_cast )

end







modifier_creeps_spell_warewolf_Jumping_bite_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_warewolf_Jumping_bite_debuff:IsHidden()	return false end
function modifier_creeps_spell_warewolf_Jumping_bite_debuff:IsDebuff()	return true end
function modifier_creeps_spell_warewolf_Jumping_bite_debuff:IsStunDebuff()	return false end
function modifier_creeps_spell_warewolf_Jumping_bite_debuff:IsPurgable()	return true end

function modifier_creeps_spell_warewolf_Jumping_bite_debuff:OnCreated( kv )
	-- references
	local ability=self:GetAbility()
	self.ms_slow = -ability:GetSpecialValueFor("speed_slow")

	if not IsServer() then return end
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creeps_spell_warewolf_Jumping_bite_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	}

	return funcs
end


function modifier_creeps_spell_warewolf_Jumping_bite_debuff:GetModifierMoveSpeedBonus_Percentage()	return self.ms_slow end





