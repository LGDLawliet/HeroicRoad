Middle_assassinate = class({})
LinkLuaModifier( "modifier_Middle_assassinate", "skills/Middle_assassinate", LUA_MODIFIER_MOTION_NONE )
function Middle_assassinate:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", context )
	PrecacheResource( "particle", "particles/units/unit_greevil/loot_greevil_death.vpcf", context )
end


function Middle_assassinate:GetCastAnimation()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_sniper" then
		return ACT_DOTA_CAST_ABILITY_4
	end
	return ACT_DOTA_ATTACK
end
function Middle_assassinate:GetAOERadius()
	return 400
end

function Middle_assassinate:OnAbilityPhaseInterrupted()
	if self.modifier then
		self.modifier:SafeDestroy()
		self.modifier = nil
	end
end

function Middle_assassinate:OnAbilityPhaseStart()
	if self.modifier then
		self.modifier:SafeDestroy()
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local debuff_duration = 4

	self.modifier = target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_assassinate", -- modifier name
		{ duration = debuff_duration } -- kv
	)

	-- play effects
	local sound_cast = "Ability.AssassinateLoad"
	caster:EmitSound(sound_cast)

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function Middle_assassinate:OnSpellStart()
	if self.modifier then
		self.modifier:SafeDestroy()
		self.modifier = nil
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	-- local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
	local projectile_speed = 3000

	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
		ExtraData = {}
	}
	ProjectileManager:CreateTrackingProjectile(info)
	self.modifier = nil

	-- effects
	local sound_cast = "Ability.Assassinate"
	EmitSoundOn( sound_cast, caster )
	local sound_target = "Hero_Sniper.AssassinateProjectile"
	EmitSoundOn( sound_target, target )
end
--------------------------------------------------------------------------------
-- Projectile
function Middle_assassinate:OnProjectileHit_ExtraData( target, location, extradata )
	-- cancel if gone
	if (not target) or target:IsInvulnerable() or target:IsOutOfGame() or target:TriggerSpellAbsorb( self ) then
		return
	end
	local radius = 400
	local pos = target:GetAbsOrigin()
	local caster = self:GetCaster()

	local stun_duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
	local pfx = ParticleManager:CreateParticle( "particles/units/unit_greevil/loot_greevil_death.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( pfx, 0, pos  )
	ParticleManager:SetParticleControl( pfx, 1, pos  )
	ParticleManager:ReleaseParticleIndex(pfx)


	-- apply damage
	local damage = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetDamageMax()
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_sniper_2") then
		damage = damage + caster:GetAverageTrueAttackDamage(nil)
	end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	target:Interrupt()
	local units = FindUnitsInRadius(caster:GetTeamNumber(),pos, nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	damageTable.damage = damage *0.5
	for _, unit in ipairs(units) do
		if unit~=target then
			damageTable.victim = unit
			ApplyDamage(damageTable)
		end

	end

	-- effects
	local sound_cast = "Hero_Sniper.AssassinateDamage"
	EmitSoundOn( sound_cast, target )
end













modifier_Middle_assassinate = class({})

function modifier_Middle_assassinate:IsHidden()	return true end
function modifier_Middle_assassinate:IsDebuff()	return true end
function modifier_Middle_assassinate:IsPurgable()	return false end
function modifier_Middle_assassinate:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_Middle_assassinate:OnCreated( kv )
	if IsServer() then
		self:PlayEffects()
	end
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_assassinate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end
function modifier_Middle_assassinate:GetModifierProvidesFOWVision()
	return true
end


function modifier_Middle_assassinate:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end


function modifier_Middle_assassinate:PlayEffects()

	local particle_cast = "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf"
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber() )
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		true
	)
end