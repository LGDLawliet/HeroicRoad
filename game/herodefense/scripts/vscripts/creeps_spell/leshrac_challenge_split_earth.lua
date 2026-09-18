leshrac_challenge_split_earth = leshrac_challenge_split_earth or class({})
LinkLuaModifier( "modifier_leshrac_challenge_split_earth", "creeps_spell/leshrac_challenge_split_earth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_challenge_split_earth_torment", "creeps_spell/leshrac_challenge_split_earth", LUA_MODIFIER_MOTION_NONE )


function leshrac_challenge_split_earth:GetIntrinsicModifierName() return "modifier_leshrac_challenge_split_earth_torment" end

function leshrac_challenge_split_earth:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/leshrac/leshrac_tormented_staff_retro/leshrac_split_retro_tormented.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf", context )

end
function leshrac_challenge_split_earth:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end


function leshrac_challenge_split_earth:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_leshrac_challenge_split_earth", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end



modifier_leshrac_challenge_split_earth = modifier_leshrac_challenge_split_earth or class({})
function modifier_leshrac_challenge_split_earth:IsHidden()	return true end
function modifier_leshrac_challenge_split_earth:IsPurgable()	return false end
function modifier_leshrac_challenge_split_earth:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor("damage")*self:GetCaster():GetDamageMax()


	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	local delay = self:GetAbility():GetSpecialValueFor("delay")
	self:StartIntervalThink(delay)
	self.count = 6
	-- ApplyDamage(damageTable)
end
function modifier_leshrac_challenge_split_earth:OnIntervalThink()
	local caster = self:GetCaster()
	if not caster or not caster:IsAlive() then
		self:SetDuration(0.1, false)
		return
	end
	self:StartIntervalThink(5)
	self.count = self.count - 1
	if self.count<=0 then
		self:SetDuration(0.1, false)
	end
	
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
		-- stun
		local StatusResistance =enemy:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
		enemy:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration*StatusResistance } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end
	self:PlayEffects()
	if self.count>=1 then
		local pos=self:GetParent():GetAbsOrigin()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf", PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, pos )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius+100, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		self.radius = self.radius + 150
	
	end





	-- UTIL_Remove( self:GetParent() )
end

function modifier_leshrac_challenge_split_earth:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_leshrac_challenge_split_earth:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/items/leshrac/leshrac_tormented_staff_retro/leshrac_split_retro_tormented.vpcf"
	local sound_cast = "Hero_Leshrac.Split_Earth"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end



modifier_leshrac_challenge_split_earth_torment =  modifier_leshrac_challenge_split_earth_torment or class({})

function modifier_leshrac_challenge_split_earth_torment:IsHidden() return true end
function modifier_leshrac_challenge_split_earth_torment:IsAura() return true end
function modifier_leshrac_challenge_split_earth_torment:IsPurgable() 		return false end
function modifier_leshrac_challenge_split_earth_torment:IsPurgeException() 	return false end
function modifier_leshrac_challenge_split_earth_torment:RemoveOnDeath()  return false end

function modifier_leshrac_challenge_split_earth_torment:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_leshrac_challenge_split_earth_torment:GetActivityTranslationModifiers()	
	return "torment" 
end
