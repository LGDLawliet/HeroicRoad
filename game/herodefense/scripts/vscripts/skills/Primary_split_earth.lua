Primary_split_earth = class({})
LinkLuaModifier( "modifier_Primary_split_earth", "skills/Primary_split_earth", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function Primary_split_earth:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function Primary_split_earth:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_split_earth", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end



modifier_Primary_split_earth = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_split_earth:IsHidden()	return true end
function modifier_Primary_split_earth:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_split_earth:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	-- local damage = self:GetAbility():GetSpecialValueFor("damage")+self:GetAbility():GetSpecialValueFor("damage_index")*self:GetCaster():GetIntellect(false)
	local damage = self:GetAbility():GetSpecialValueFor("damage")


	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end


function modifier_Primary_split_earth:OnDestroy()
	if not IsServer() then return end

	local caster = self:GetCaster()
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
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.8)
	
	for _,enemy in pairs(enemies) do
		-- stun
		local StatusResistance = enemy:GetHDStatusResistanceIndex(0.2)*ModifierStatusNegativeGain--吃0.5
		enemy:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			--{ duration = self.duration*StatusResistance } -- kv吃状态抗性影响
			{ duration = self.duration*StatusResistance}
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_split_earth:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local sound_cast = "Hero_Leshrac.Split_Earth"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end