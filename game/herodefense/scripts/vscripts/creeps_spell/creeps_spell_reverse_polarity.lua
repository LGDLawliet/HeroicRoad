creeps_spell_reverse_polarity = class({})


function creeps_spell_reverse_polarity:OnAbilityPhaseStart()
	-- play effects
	self:PlayEffects1()

	return true -- if success
end

function creeps_spell_reverse_polarity:OnSpellStart()
	self:StopEffects( false )
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	FindClearSpaceForUnit( caster, point, true )
	self:PlayEffects2( caster, caster:GetOrigin() )


	local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
	EmitSoundOn( sound_cast, caster )

	local vTargetPos = caster:GetOrigin()
	local vLeadingOffset = caster:GetForwardVector() * 2000
	vTargetPos = vTargetPos + vLeadingOffset
	local center = Vector(-300,-1053,896)
	if CalculateDistance(caster,center)>2200 then

		vTargetPos =center
		caster:FaceTowards(center)
	end
	local ability = caster:FindAbilityByName("creeps_spell_skewer")
	caster:SetCursorPosition(vTargetPos)
	ability:OnSpellStart()
	-- ExecuteOrderFromTable({
	-- 	UnitIndex = caster:entindex(),
	-- 	OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
	-- 	Position = vTargetPos,
	-- 	AbilityIndex = caster:FindAbilityByName("creeps_spell_skewer"):entindex(),
	-- 	Queue = false,
	-- })
	


end



function creeps_spell_reverse_polarity:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

	-- Get data
	local radius = 300
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


function creeps_spell_reverse_polarity:StopEffects( interrupted )
	-- stop particle
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- stop sound
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"
	StopSoundOn( sound_cast, self:GetCaster() )
end

function creeps_spell_reverse_polarity:PlayEffects2( target, origin )
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