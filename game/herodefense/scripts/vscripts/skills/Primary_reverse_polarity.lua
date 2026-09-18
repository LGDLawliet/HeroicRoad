Primary_reverse_polarity = class({})

LinkLuaModifier("modifier_Primary_reverse_polarity_debuff", "skills/Primary_reverse_polarity", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能


Primary_reverse_polarity = Primary_reverse_polarity or class({})

--------------------------------------------------------------------------------
-- Init Abilities
function Primary_reverse_polarity:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", context )
end
function Primary_reverse_polarity:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
--------------------------------------------------------------------------------
-- Ability Phase Start
function Primary_reverse_polarity:OnAbilityPhaseStart()
	-- play effects
	self:PlayEffects1()

	return true -- if success
end

function Primary_reverse_polarity:OnAbilityPhaseInterrupted()
	-- stop effects
	self:StopEffects( true )
end

--------------------------------------------------------------------------------
-- Ability Start
function Primary_reverse_polarity:OnSpellStart()
	self:StopEffects( false )

	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor( "radius" )
	-- local damage = self:GetSpecialValueFor( "polarity_damage" )
	local duration = self:GetSpecialValueFor( "duration" )
	-- precache damage
	-- local damageTable = {
	-- 	-- victim = target,
	-- 	attacker = caster,
	-- 	damage = damage,
	-- 	damage_type = DAMAGE_TYPE_MAGICAL,
	-- 	ability = self, --Optional.
	-- }
	-- ApplyDamage(damageTable)

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local pos = caster:GetOrigin() + caster:GetForwardVector() * 150
	for i,enemy in pairs(enemies) do

		local origin = enemy:GetOrigin()
		FindClearSpaceForUnit( enemy, pos, true )
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Primary_reverse_polarity_debuff", -- modifier name
			{ duration = duration } -- kv
		)


		self:PlayEffects2( enemy, origin )
		if i>=10 then
			break
		end
	end


	local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Effects
function Primary_reverse_polarity:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

	-- Get data
	local radius = self:GetSpecialValueFor( "radius" )
	local castpoint = self:GetCastPoint()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( castpoint, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, self:GetCaster():GetForwardVector() )

	self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Primary_reverse_polarity:StopEffects( interrupted )
	-- stop particle
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- stop sound
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"
	StopSoundOn( sound_cast, self:GetCaster() )
end

function Primary_reverse_polarity:PlayEffects2( target, origin )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, origin )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end




modifier_Primary_reverse_polarity_debuff = advanced_modifier({})

function modifier_Primary_reverse_polarity_debuff:IsDebuff()			return true end
function modifier_Primary_reverse_polarity_debuff:IsHidden() 			return false end
function modifier_Primary_reverse_polarity_debuff:IsPurgable() 		return false end
function modifier_Primary_reverse_polarity_debuff:IsPurgeException() 	return true end
function modifier_Primary_reverse_polarity_debuff:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TOOLTIP
	} 
end
function modifier_Primary_reverse_polarity_debuff:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_Primary_reverse_polarity_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Primary_reverse_polarity_debuff:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

function modifier_Primary_reverse_polarity_debuff:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end
function modifier_Primary_reverse_polarity_debuff:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	-- if IsServer() then
	-- 	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	-- end
end
function modifier_Primary_reverse_polarity_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return self.bonus_damage
end
function modifier_Primary_reverse_polarity_debuff:OnTooltip(keys)
	return self:Advanced_GetModifierIncomingDamage_Percentage(keys)
end

function modifier_Primary_reverse_polarity_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end