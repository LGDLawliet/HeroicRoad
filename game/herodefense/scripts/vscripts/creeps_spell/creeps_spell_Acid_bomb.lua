creeps_spell_Acid_bomb = class({})

LinkLuaModifier( "modifier_creeps_spell_Acid_bomb_thinker", "creeps_spell/creeps_spell_Acid_bomb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_Acid_bomb_debuff", "creeps_spell/creeps_spell_Acid_bomb", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function creeps_spell_Acid_bomb:GetAOERadius()
	return 300
end

--------------------------------------------------------------------------------
-- Ability Start
function creeps_spell_Acid_bomb:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()



	if not IsServer() then return end
	local casterPos = caster:GetAbsOrigin()
	local vec = point-casterPos
	

	local travel_time = (vec:Length2D())/2000+0.5
	local speed= vec:Length2D()/travel_time

	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_creeps_spell_Acid_bomb_thinker", -- modifier name
		{ travel_time =travel_time }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	

	-- local vDirection = point - caster:GetAbsOrigin()
    -- vDirection.z = 0
	-- local info = {
    --     Ability = self,
    --     vSpawnOrigin = attack_lock,
	-- 	EffectName = "particles/new_effect/unit/brain_worm/acid_bomb/acid_bombsnapfire_lizard_blobs_arced.vpcf",
    --     vVelocity = vDirection:Normalized() * 1000,
    --     fDistance = vDirection:Length2D(),
    --     fStartRadius = 0,
    --     fEndRadius = 0,
    --     Source =caster,
    --     iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    --     iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    --     iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    --     bProvidesVision = false,
    --     iVisionTeamNumber =caster:GetTeamNumber(),
    --     -- iVisionRadius = tHashtable.ball_lightning_vision_radius,
    --     -- ExtraData =        {
    --     --     hashtable_index = GetHashtableIndex(tHashtable),
    --     -- }
    -- }

    -- ProjectileManager:CreateLinearProjectile(info)
	

	Timers:CreateTimer(0.3, function()
		local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_mouth"))
		attack_lock.z = attack_lock.z -10
		local unit = CreateUnitByName("npc_attack_unit", attack_lock, true, caster, caster, caster:GetTeamNumber())
		unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.5})
		unit:SetOrigin(attack_lock)
		Timers:CreateTimer(0.5, function()
			unit:ForceKill(false)
		end)
		local info = {
			-- Target = target,
			-- vSpawnOrigin = attack_lock,
			Source = unit,
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
function creeps_spell_Acid_bomb:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor("damage")*self:GetCaster():GetDamageMax()
	local duration =self:GetSpecialValueFor("duration")
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
		"modifier_creeps_spell_Acid_bomb_thinker", -- modifier name
		{
			duration = duration,
			slow = 1,
		} -- kv
	)

	-- destroy trees
	GridNav:DestroyTreesAroundPoint( location, impact_radius, true )



	-- play effects
	self:PlayEffects( target:GetOrigin() )
end

--------------------------------------------------------------------------------
function creeps_spell_Acid_bomb:PlayEffects( loc )
	-- Get Resources
	local particle_cast = "particles/new_effect/unit/brain_worm/acid_bomb/impact.vpcf"
	local particle_cast2 = "particles/new_effect/unit/brain_worm/acid_bomb/imate_linger.vpcf"
	local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(self:GetSpecialValueFor("duration"),0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end









modifier_creeps_spell_Acid_bomb_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications

--------------------------------------------------------------------------------
-- Initializations
function modifier_creeps_spell_Acid_bomb_thinker:OnCreated( kv )
	-- references
	self.max_travel = kv.travel_time
	self.radius =self:GetAbility():GetSpecialValueFor("radius")
	self.linger =self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end

	-- dont start aura right off
	self.start = false

	-- create aoe finder particle
	self:PlayEffects( kv.travel_time )
end

function modifier_creeps_spell_Acid_bomb_thinker:OnRefresh( kv )
	-- references
	self.max_travel= kv.travel_time
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.linger =self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end

	-- start aura
	self.start = true

	-- stop aoe finder particle
	self:StopEffects()
end

function modifier_creeps_spell_Acid_bomb_thinker:OnRemoved()
end

function modifier_creeps_spell_Acid_bomb_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_creeps_spell_Acid_bomb_thinker:IsAura()	return self.start end
function modifier_creeps_spell_Acid_bomb_thinker:GetModifierAura()	return "modifier_creeps_spell_Acid_bomb_debuff" end
function modifier_creeps_spell_Acid_bomb_thinker:GetAuraRadius()	return self.radius end
function modifier_creeps_spell_Acid_bomb_thinker:GetAuraDuration()	return self.linger end
function modifier_creeps_spell_Acid_bomb_thinker:GetAuraDuration() return 0.1 end
function modifier_creeps_spell_Acid_bomb_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creeps_spell_Acid_bomb_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_creeps_spell_Acid_bomb_thinker:PlayEffects( time )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )

	-- self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster(), DOTA_TEAM_GOODGUYS )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius*(self.max_travel/time) ) )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time, 0, 0 ) )
end

function modifier_creeps_spell_Acid_bomb_thinker:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end





modifier_creeps_spell_Acid_bomb_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_Acid_bomb_debuff:IsHidden()	return false end
function modifier_creeps_spell_Acid_bomb_debuff:IsDebuff()	return true end
function modifier_creeps_spell_Acid_bomb_debuff:IsStunDebuff()	return false end
function modifier_creeps_spell_Acid_bomb_debuff:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creeps_spell_Acid_bomb_debuff:OnCreated( kv )
	-- references\
	if not self:GetAbility() then
		self.slow = 0
		return
	end
	local interval = 0.5
	self.slow = -self:GetAbility():GetSpecialValueFor("slow")
	self.dps = self:GetAbility():GetSpecialValueFor("damage_delay")*self:GetCaster():GetDamageMax()*interval
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.dps,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creeps_spell_Acid_bomb_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_creeps_spell_Acid_bomb_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_creeps_spell_Acid_bomb_debuff:OnIntervalThink()
	-- apply damage
	ApplyDamage( self.damageTable )

	-- play overhead
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creeps_spell_Acid_bomb_debuff:GetEffectName()
	return "particles/new_effect/unit/brain_worm/acid_bomb/hero_snapfire_burn_debuff.vpcf"
end

function modifier_creeps_spell_Acid_bomb_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- function modifier_creeps_spell_Acid_bomb_debuff:GetStatusEffectName()
-- 	return "particles/status_fx/status_effect_snapfire_magma.vpcf"
-- end

-- function modifier_creeps_spell_Acid_bomb_debuff:StatusEffectPriority()
-- 	return MODIFIER_PRIORITY_NORMAL
-- end

function modifier_creeps_spell_Acid_bomb_debuff:CheckState()
	local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true,[MODIFIER_STATE_SILENCED] = true}

	return state
end