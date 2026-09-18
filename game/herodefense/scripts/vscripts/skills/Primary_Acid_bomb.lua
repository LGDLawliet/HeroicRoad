Primary_Acid_bomb = class({})

LinkLuaModifier( "modifier_Primary_Acid_bomb_thinker", "skills/Primary_Acid_bomb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Acid_bomb_debuff", "skills/Primary_Acid_bomb", LUA_MODIFIER_MOTION_NONE )

function Primary_Acid_bomb:Precache( context )
	PrecacheResource( "particle", "particles/new_effect/unit/brain_worm/acid_bomb/acid_bombsnapfire_lizard_blobs_arced.vpcf", context )
	PrecacheResource( "particle", "particles/new_effect/unit/brain_worm/acid_bomb/impact.vpcf", context )
	PrecacheResource( "particle", "particles/new_effect/unit/brain_worm/acid_bomb/imate_linger.vpcf", context )
	


	
end
function Primary_Acid_bomb:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function Primary_Acid_bomb:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()



	if not IsServer() then return end
	local casterPos = caster:GetAbsOrigin()
	local vec = point-casterPos
	

	local travel_time = (vec:Length2D())/2000+0.3
	local speed= vec:Length2D()/travel_time

	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Acid_bomb_thinker", -- modifier name
		{ travel_time =travel_time }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	
	

	Timers:CreateTimer(0.3, function()
		if not self or self:IsNull() then
			return
		end
		local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))
		-- attack_lock.z = attack_lock.z -10
		-- local unit = CreateUnitByName("npc_attack_unit", attack_lock, true, caster, caster, caster:GetTeamNumber())
		-- unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.5})
		-- unit:SetOrigin(attack_lock)
		-- Timers:CreateTimer(0.5, function()
		-- 	unit:ForceKill(false)
		-- end)
		local info = {
			-- Target = target,
			-- vSpawnOrigin = attack_lock,
			-- Source = unit,

			Ability = self,	
			EffectName = "particles/new_effect/unit/brain_worm/acid_bomb/acid_bombsnapfire_lizard_blobs_arced.vpcf",
			iMoveSpeed = speed,
			bDodgeable = false,                           -- Optional
			Target = thinker,
			vSourceLoc = attack_lock,                -- Optional (HOW)
			bDrawsOnMinimap = false,                          -- Optional
			bVisibleToEnemies = true,                         -- Optional
			bProvidesVision = true,                           -- Optional
			iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
		}
	
		local sound_cast = "Hero_Snapfire.MortimerBlob.Launch"
		EmitSoundOn( sound_cast, caster )
	
		-- launch projectile
		ProjectileManager:CreateTrackingProjectile( info )
	end)

	

end

--------------------------------------------------------------------------------
-- Projectile
function Primary_Acid_bomb:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*self:GetSpecialValueFor("bonus_damage")
	local duration =3
	local impact_radius = self:GetSpecialValueFor("radius")


	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		impact_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	-- start aura on thinker
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_Primary_Acid_bomb_thinker", -- modifier name
		{
			duration = duration,
			slow = 1,
		} -- kv
	)



	-- play effects
	self:PlayEffects( target:GetOrigin() )
end

--------------------------------------------------------------------------------
function Primary_Acid_bomb:PlayEffects( loc )
	-- Get Resources
	local particle_cast = "particles/new_effect/unit/brain_worm/acid_bomb/impact.vpcf"
	local particle_cast2 = "particles/new_effect/unit/brain_worm/acid_bomb/imate_linger.vpcf"
	-- local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(3,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end









modifier_Primary_Acid_bomb_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Acid_bomb_thinker:OnCreated( kv )
	-- references
	self.max_travel = kv.travel_time
	self.radius =self:GetAbility():GetSpecialValueFor("radius")
	self.linger =self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end

	-- dont start aura right off
	self.start = false

	-- create aoe finder particle
	-- self:PlayEffects( kv.travel_time )
end

function modifier_Primary_Acid_bomb_thinker:OnRefresh( kv )
	-- references
	self.max_travel= kv.travel_time
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.linger =self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end

	-- start aura
	self.start = true

	-- stop aoe finder particle
	-- self:StopEffects()
end

function modifier_Primary_Acid_bomb_thinker:OnRemoved()
end

function modifier_Primary_Acid_bomb_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_Primary_Acid_bomb_thinker:IsAura()	return self.start end
function modifier_Primary_Acid_bomb_thinker:GetModifierAura()	return "modifier_Primary_Acid_bomb_debuff" end
function modifier_Primary_Acid_bomb_thinker:GetAuraRadius()	return self.radius end
function modifier_Primary_Acid_bomb_thinker:GetAuraDuration()	return self.linger end
function modifier_Primary_Acid_bomb_thinker:GetAuraDuration() return 0.1 end
function modifier_Primary_Acid_bomb_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Primary_Acid_bomb_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-- function modifier_Primary_Acid_bomb_thinker:PlayEffects( time )
-- 	-- Get Resources
-- 	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"

-- 	-- Create Particle
-- 	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )

-- 	-- self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster(), DOTA_TEAM_GOODGUYS )
-- 	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
-- 	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius*(self.max_travel/time) ) )
-- 	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time, 0, 0 ) )
-- end

-- function modifier_Primary_Acid_bomb_thinker:StopEffects()
-- 	ParticleManager:DestroyParticle( self.effect_cast, true )
-- 	ParticleManager:ReleaseParticleIndex( self.effect_cast )
-- end





modifier_Primary_Acid_bomb_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Acid_bomb_debuff:IsHidden()	return false end
function modifier_Primary_Acid_bomb_debuff:IsDebuff()	return true end
function modifier_Primary_Acid_bomb_debuff:IsStunDebuff()	return false end
function modifier_Primary_Acid_bomb_debuff:IsPurgable()	return false end
function modifier_Primary_Acid_bomb_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Acid_bomb_debuff:OnCreated( kv )
	-- references\
	if not self:GetAbility() then
		self.slow = 0
		return
	end
	local interval = 0.5
	local ability = self:GetAbility()
	self.slow = -ability:GetSpecialValueFor("move_slow")
	-- self.dps = ability:GetSpecialValueFor("damage_delay")*self:GetCaster():GetDamageMax()*interval
	local damage = ability:GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage*interval*ability:GetSpecialValueFor("damage_per_tick")*0.01,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_Acid_bomb_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Primary_Acid_bomb_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_Acid_bomb_debuff:OnIntervalThink()
	-- apply damage
	ApplyDamage( self.damageTable )

	-- play overhead
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_Acid_bomb_debuff:GetEffectName()
	return "particles/new_effect/unit/brain_worm/acid_bomb/hero_snapfire_burn_debuff.vpcf"
end

function modifier_Primary_Acid_bomb_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- function modifier_Primary_Acid_bomb_debuff:CheckState()
-- 	local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true,[MODIFIER_STATE_SILENCED] = true}

-- 	return state
-- end