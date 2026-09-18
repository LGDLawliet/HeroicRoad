Primary_assassinate = class({})
LinkLuaModifier( "modifier_Primary_assassinate", "skills/Primary_assassinate", LUA_MODIFIER_MOTION_NONE )
function Primary_assassinate:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", context )
end


function Primary_assassinate:GetCastAnimation()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_sniper" then
		return ACT_DOTA_CAST_ABILITY_4
	end
	return ACT_DOTA_ATTACK
end


function Primary_assassinate:OnAbilityPhaseInterrupted()
	if self.modifier then
		self.modifier:SafeDestroy()
		self.modifier = nil
	end
end

function Primary_assassinate:OnAbilityPhaseStart()
	if self.modifier then
		self.modifier:SafeDestroy()
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local debuff_duration = 4

	self.modifier = target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_assassinate", -- modifier name
		{ duration = debuff_duration } -- kv
	)

	-- play effects
	local sound_cast = "Ability.AssassinateLoad"
	caster:EmitSound(sound_cast)

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function Primary_assassinate:OnSpellStart()
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
function Primary_assassinate:OnProjectileHit_ExtraData( target, location, extradata )
	-- cancel if gone
	if (not target) or target:IsInvulnerable() or target:IsOutOfGame() or target:TriggerSpellAbsorb( self ) then
		return
	end
	local caster = self:GetCaster()

	local stun_duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})


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


	-- effects
	local sound_cast = "Hero_Sniper.AssassinateDamage"
	EmitSoundOn( sound_cast, target )
end













modifier_Primary_assassinate = class({})

function modifier_Primary_assassinate:IsHidden()	return true end
function modifier_Primary_assassinate:IsDebuff()	return true end
function modifier_Primary_assassinate:IsPurgable()	return false end
function modifier_Primary_assassinate:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_Primary_assassinate:OnCreated( kv )
	if IsServer() then
		self:PlayEffects()
	end
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_assassinate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end
function modifier_Primary_assassinate:GetModifierProvidesFOWVision()
	return true
end


function modifier_Primary_assassinate:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end


function modifier_Primary_assassinate:PlayEffects()

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