chaotic_fire_ball = class({})

LinkLuaModifier("modifier_chaotic_fire_ball_thinker", "chaotic_spell/class_3/chaotic_fire_ball", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_fire_ball_debuff", "chaotic_spell/class_3/chaotic_fire_ball", LUA_MODIFIER_MOTION_NONE)

function chaotic_fire_ball:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_fire_ball/effect_projectile/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/fire_ball/effect_cast/fire_ball_imapct_one.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/fire_ball/effect_cast/fire_ball_lingerimate_linger.vpcf", context )

end

function chaotic_fire_ball:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function chaotic_fire_ball:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function chaotic_fire_ball:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end

function chaotic_fire_ball:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local point2

	if self:GetRuneType() == 3 then
		local radius = self:GetSpecialValueFor("radius")
		point = point + RandomVector( RandomFloat( -radius, radius ) )
		point2 = point + RandomVector( RandomFloat( -radius, radius ) )
	end
	self:ApplyEffect(point)
	if self:GetRuneType() == 3 then
		self:ApplyEffect(point2)
	end
end

function chaotic_fire_ball:ApplyEffect(point)
	local caster = self:GetCaster()
	if not IsServer() then return end
	local casterPos = caster:GetAbsOrigin()
	local vec = point-casterPos	

	local travel_time = (vec:Length2D())/4000
	local speed= vec:Length2D()/travel_time

	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_chaotic_fire_ball_thinker", -- modifier name
		{ travel_time =travel_time+0.5 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))
	local info = {
		Ability = self,	
		--EffectName = "particles/new_effect/unit/brain_worm/acid_bomb/acid_bombsnapfire_lizard_blobs_arced.vpcf",
		EffectName = "particles/rebuild/chaotic_spell/chaotic_fire_ball/effect_projectile/effect.vpcf",
		iMoveSpeed = speed,
		bDodgeable = false,                           -- Optional
		Target = thinker,
		vSourceLoc = attack_lock,                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}

	local sound_cast = "fire_ball.hit"
	EmitSoundOn( sound_cast, caster )

	ProjectileManager:CreateTrackingProjectile( info )
end

function chaotic_fire_ball:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local gain = self:GetEffectGain()
	local damage = (self:GetSpecialValueFor("damage")+self:GetCaster():HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage"))*gain
	local duration =self:GetSpecialValueFor("duration")
	local impact_radius = self:GetSpecialValueFor("radius")

	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
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

	local modifier = target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_chaotic_fire_ball_thinker", -- modifier name
		{
			duration = duration,
			gain = gain,
		} -- kv
	)
	if modifier then
		modifier:PlayEffects( target:GetOrigin() )
	end

	if self:GetRuneType()==1 then
		local rune_1_bonus = self:GetSpecialValueFor("rune_1_bonus")*0.01
		local thinkers = Entities:FindAllByClassnameWithin("npc_dota_thinker", location,  impact_radius)
		local damage_index = 1*gain
		for _, unit in ipairs(thinkers) do
			local modifier = unit:FindModifierByName("modifier_chaotic_Grease_thinker")
			if modifier then
				modifier:FireBallTrigger()
				damage_index = damage_index +rune_1_bonus
			end
		end
		damageTable.damage = damageTable.damage * damage_index
	end

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end
end
-------------------------------------------------------------------
modifier_chaotic_fire_ball_thinker = advanced_modifier({})
function modifier_chaotic_fire_ball_thinker:OnCreated( kv )
	local ability = self:GetAbility()
	self.max_travel = kv.travel_time
	self.radius = ability:GetSpecialValueFor("radius")
	self.rune_2_bonus = ability:GetSpecialValueFor("rune_2_bonus")
	if ability:GetRuneType() == 2 then
		self.radius = self.radius*(1+self.rune_2_bonus*0.01)
	end
	if not IsServer() then return end
	self:GetParent().ability_gain = kv.gain
	self.start = false
end

function modifier_chaotic_fire_ball_thinker:OnRefresh( kv )
	self.max_travel= kv.travel_time
	local ability = self:GetAbility()
	self.radius = ability:GetSpecialValueFor("radius")
	self.rune_2_bonus = ability:GetSpecialValueFor("rune_2_bonus")
	if ability:GetRuneType() == 2 then
		self.radius = self.radius*(1+self.rune_2_bonus*0.01)
	end
	if not IsServer() then return end
	self.start = true
end

function modifier_chaotic_fire_ball_thinker:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle( self.thinkerParticle,true)
	UTIL_Remove( self:GetParent() )
end

function modifier_chaotic_fire_ball_thinker:IsAura()	return self.start and self:GetAbility() end
function modifier_chaotic_fire_ball_thinker:GetModifierAura()	return "modifier_chaotic_fire_ball_debuff" end
function modifier_chaotic_fire_ball_thinker:GetAuraRadius()	return self.radius end
function modifier_chaotic_fire_ball_thinker:GetAuraDuration()	return 0.5 end
function modifier_chaotic_fire_ball_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_chaotic_fire_ball_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_chaotic_fire_ball_thinker:PlayEffects( loc )
    local particle_cast = "particles/rebuild/chaotic_spell/fire_ball/effect_cast/fire_ball_imapct_one.vpcf"
	local particle_cast2 = "particles/rebuild/chaotic_spell/fire_ball/effect_cast/fire_ball_lingerimate_linger.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	self.thinkerParticle = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.thinkerParticle, 0, loc )
	ParticleManager:SetParticleControl( self.thinkerParticle, 1, loc )
	ParticleManager:SetParticleControl( self.thinkerParticle, 10, Vector(self.radius,1,1) )
	ParticleManager:SetParticleControl( self.thinkerParticle, 61, Vector(3,0,0) )
	self:AddParticle(self.thinkerParticle,  false, false, -1,  false, false)
	local sound_location = "chaotic_fire_ball_hit"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end


modifier_chaotic_fire_ball_debuff = advanced_modifier({})
function modifier_chaotic_fire_ball_debuff:IsHidden()	return true end
function modifier_chaotic_fire_ball_debuff:IsDebuff()	return true end
function modifier_chaotic_fire_ball_debuff:IsStunDebuff()	return false end
function modifier_chaotic_fire_ball_debuff:IsPurgable()	return false end
function modifier_chaotic_fire_ball_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chaotic_fire_ball_debuff:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()
	self.burn_damage = ability:GetSpecialValueFor("burn_damage")
	self.burn_bonus_damage = ability:GetSpecialValueFor("burn_bonus_damage")
	self.rune_2_incoming = ability:GetSpecialValueFor("rune_2_incoming")
	self.rune_2_bonus = ability:GetSpecialValueFor("rune_2_bonus")
	
	if self:GetAbility():GetRuneType() == 2 then
		self.burn_damage = self.burn_damage*(1+self.rune_2_bonus*0.01)
		self.burn_bonus_damage = self.burn_bonus_damage*(1+self.rune_2_bonus*0.01)
	end
	self.gain = 1
	if self:GetAuraOwner() then
		self.gain = self:GetAuraOwner().ability_gain or 1
	end
	self:StartIntervalThink( 1 )
	self:OnIntervalThink()
end

function modifier_chaotic_fire_ball_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if ability then
		local caster = self:GetCaster()
		local burning = (self.burn_damage + caster:HDGetPrimaryStatValue()*self.burn_bonus_damage)*self.gain
		self:GetParent():Burning(caster,ability,burning)
	end
end
function modifier_chaotic_fire_ball_debuff:ADDeclareFunctions()
	local funcs = {}
	if self:GetAbility():GetRuneType() == 2 then
		table.insert(funcs, advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
	return funcs
end
function modifier_chaotic_fire_ball_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	if not self:GetAbility() then return end
	if IsDotDamage(keys) then
		return self.rune_2_incoming
	end
end