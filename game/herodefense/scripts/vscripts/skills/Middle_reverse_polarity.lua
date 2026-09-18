Middle_reverse_polarity = class({})

LinkLuaModifier("modifier_Middle_reverse_polarity_debuff", "skills/Middle_reverse_polarity", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能


Middle_reverse_polarity = Middle_reverse_polarity or class({})

--------------------------------------------------------------------------------
-- Init Abilities
function Middle_reverse_polarity:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", context )
end
function Middle_reverse_polarity:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
--------------------------------------------------------------------------------
-- Ability Phase Start
function Middle_reverse_polarity:OnAbilityPhaseStart()
	-- play effects
	self:PlayEffects1()

	return true -- if success
end

function Middle_reverse_polarity:OnAbilityPhaseInterrupted()
	-- stop effects
	self:StopEffects( true )
end

--------------------------------------------------------------------------------
-- Ability Start
function Middle_reverse_polarity:OnSpellStart()
	self:StopEffects( false )

	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor( "radius" )
	-- local damage = self:GetSpecialValueFor( "polarity_damage" )
	local duration = self:GetSpecialValueFor( "duration" )
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
	local auto_cast = 0
	if self:GetAutoCastState() then
		auto_cast = 1
		
	end
	for i,enemy in pairs(enemies) do

		local origin = enemy:GetOrigin()
		FindClearSpaceForUnit( enemy, pos, true )
		enemy:AddNewModifier(caster, self,"modifier_Middle_reverse_polarity_debuff", { duration = duration,auto_cast=auto_cast })


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
function Middle_reverse_polarity:PlayEffects1()
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

function Middle_reverse_polarity:StopEffects( interrupted )
	-- stop particle
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- stop sound
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"
	StopSoundOn( sound_cast, self:GetCaster() )
end

function Middle_reverse_polarity:PlayEffects2( target, origin )
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




modifier_Middle_reverse_polarity_debuff = advanced_modifier({})

function modifier_Middle_reverse_polarity_debuff:IsDebuff()			return true end
function modifier_Middle_reverse_polarity_debuff:IsHidden() 			return false end
function modifier_Middle_reverse_polarity_debuff:IsPurgable() 		return false end
function modifier_Middle_reverse_polarity_debuff:IsPurgeException() 	return true end
function modifier_Middle_reverse_polarity_debuff:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	} 

	return funcs
end
function modifier_Middle_reverse_polarity_debuff:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_Middle_reverse_polarity_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Middle_reverse_polarity_debuff:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

function modifier_Middle_reverse_polarity_debuff:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end
function modifier_Middle_reverse_polarity_debuff:OnCreated(keys)
	self.bonus_armor =0
	self.magic_resistance =0
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if IsServer() then
		
		if keys.auto_cast==1 then
			self:SetStackCount(1)
		end
	end
	if self:GetStackCount()==1 then
		self.magic_resistance =-30
	else
		self.bonus_armor = -10
	end
end
function modifier_Middle_reverse_polarity_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return self.bonus_damage
end

function modifier_Middle_reverse_polarity_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierIncomingDamage_Percentage()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierPhysicalArmorBonus()
	end
end

function modifier_Middle_reverse_polarity_debuff:GetModifierMagicalResistanceBonus(keys)
	return self.magic_resistance
end

function modifier_Middle_reverse_polarity_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_Middle_reverse_polarity_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end