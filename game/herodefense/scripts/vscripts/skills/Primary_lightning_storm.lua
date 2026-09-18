Primary_lightning_storm = class({})
LinkLuaModifier( "modifier_Primary_lightning_storm", "skills/Primary_lightning_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_lightning_storm_thinker", "skills/Primary_lightning_storm", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function Primary_lightning_storm:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- create thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_lightning_storm_thinker", -- modifier name
		{  }, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local modifier = thinker:FindModifierByName( "modifier_Primary_lightning_storm_thinker" )
	modifier:Cast( target )
end




modifier_Primary_lightning_storm_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_lightning_storm_thinker:IsHidden()	return true end
function modifier_Primary_lightning_storm_thinker:IsPurgable()	return false end

function modifier_Primary_lightning_storm_thinker:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.delay = 0.2
	self.count = self:GetAbility():GetSpecialValueFor( "jump_count" )
	self.radius = 600
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )


	-- init and precache
	self.targets = {}
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbility():GetSpecialValueFor( "damage" )+self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

end

function modifier_Primary_lightning_storm_thinker:Cast( target )
	-- guaranteed on server
	self.current_target = target
	self.started = false
	self:StartIntervalThink( self.delay )
end


function modifier_Primary_lightning_storm_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_lightning_storm_thinker:OnIntervalThink()
	if not self.started then
		self.started = true

		self:Struck( self.current_target )
		return
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self.current_target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	local found = false
	for _,enemy in pairs(enemies) do
		if not self.targets[enemy] then
			found = true
			self.current_target = enemy
			self:Struck( enemy )
			break
		end
	end

	if not found then
		self:SafeDestroy()
	end
end



function modifier_Primary_lightning_storm_thinker:Struck( target )
	if not target:IsMagicImmune() then
		-- damage
		self.damageTable.victim = target
		ApplyDamage( self.damageTable )

		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_Primary_lightning_storm", -- modifier name
			{
				duration = self.duration*StatusResistance,

			} -- kv
		)

		-- track targeted
		self.targets[target] = true

	end

	-- play effects
	self:PlayEffects( target )

	-- count
	self.count = self.count - 1
	if self.count<=0 then
		self:SafeDestroy()
	end
end

function modifier_Primary_lightning_storm_thinker:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf"
	local sound_cast = "Hero_Leshrac.Lightning_Storm"

	-- get data
	local location = target:GetOrigin()
	local height = Vector( 0, 0, 100 )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, location + Vector( 0, 0, 800 ) )
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
	EmitSoundOn( sound_cast, target )
end




modifier_Primary_lightning_storm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_lightning_storm:IsHidden()	return false end
function modifier_Primary_lightning_storm:IsDebuff()	return true end
function modifier_Primary_lightning_storm:IsPurgable()	return true end
function modifier_Primary_lightning_storm:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow" )
	if IsServer() then
		-- references
		
	end
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_lightning_storm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Primary_lightning_storm:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end