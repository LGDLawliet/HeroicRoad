
-- require('internal/timers')   --计时器功能
Primary_brain_sap = class({})

function Primary_brain_sap:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_sap.vpcf", context )
end
function Primary_brain_sap:GetCastRange(vLocation, hTarget)
	local base_range = self.BaseClass.GetCastRange(self,vLocation, hTarget)
	if self.talent or self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_bane_2") then
		self.talent = true
		base_range = base_range +200
	end
	return base_range
end
function Primary_brain_sap:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		return
	end
	local damage = self:GetSpecialValueFor("base_damage") +  self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)

	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_bane_2") then
		damage = damage *1.2
	end

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	local real_damage = ApplyDamage(damageTable)
	if real_damage>0 then
		local gain = caster:GetModifierLifeStealGain(1)
		local flLifesteal = real_damage *gain
		caster:Heal( flLifesteal, self )
	end

	-- Play effects
	self:PlayEffects( target )
end

--------------------------------------------------------------------------------
function Primary_brain_sap:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_bane/bane_sap.vpcf"
	local sound_cast = "Hero_Bane.BrainSap"
	local sound_target = "Hero_Bane.BrainSap.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end