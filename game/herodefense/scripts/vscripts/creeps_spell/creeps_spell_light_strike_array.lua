creeps_spell_light_strike_array = class({})

require('internal/timers')
function creeps_spell_light_strike_array:GetCastRange()
	-- local caster =self:GetCaster()
	return self:GetSpecialValueFor("range")

end
-- function creeps_spell_light_strike_array:RequiresFacing() return false end
function creeps_spell_light_strike_array:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

--------------------------------------------------------------------------------
-- Ability Start
function creeps_spell_light_strike_array:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf"
	local sound_cast = "Ability.PreLightStrikeArray"
	local radius = self:GetSpecialValueFor( "radius" )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle(  particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( point, sound_cast, caster )
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self:GetSpecialValueFor( "bonus_damage" )*caster:GetDamageMax(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	local ability = self
	Timers:CreateTimer(0.5, function()
		local particle_cast = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
		local sound_cast = "Ability.LightStrikeArray"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, point)
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		EmitSoundOnLocationWithCaster( point, sound_cast, caster )
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			point,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		for _,enemy in pairs(enemies) do
			-- damage
			damageTable.victim = enemy
			ApplyDamage( damageTable )
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			-- stun
			enemy:AddNewModifier(
				caster, -- player source
				ability, -- ability source
				"modifier_stunned", -- modifier name
				{ duration = duration*StatusResistance } -- kv
			)
		end
	

	end)

end