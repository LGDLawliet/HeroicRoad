
creeps_spell_laguna_blade = class({})

function creeps_spell_laguna_blade:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_creeps_spell_fatalistic_homology_buff") then
		return 2
	end
	return 20
end
function creeps_spell_laguna_blade:GetCastPoint()
	if self:GetCaster():HasModifier("modifier_creeps_spell_fatalistic_homology_buff") then
		return 0.5
	end
	return self.BaseClass.GetCastPoint(self)
end
function creeps_spell_laguna_blade:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:StartGesture( ACT_DOTA_CAST_ABILITY_4 )


		local caster_pos = caster:GetAbsOrigin()
		local point = self:GetCursorPosition()
		if point == caster_pos then
			point = point + caster:GetForwardVector()
		end
		local norm = (point - caster_pos):Normalized()
		point.z = point.z +64
		local target_point = caster:GetAbsOrigin() + norm * self:GetSpecialValueFor("range")
		target_point.z = target_point.z+64
		local fx = ParticleManager:CreateParticle("particles/indicator/new_custom_indicator_range_1.vpcf", PATTACH_WORLDORIGIN, caster)
		-- ParticleManager:SetParticleControlEnt(fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", point, true)
		ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(fx, 2, Vector(1.5,0,0))
		ParticleManager:SetParticleControl(fx, 1, target_point)
		local delay = 1
		if caster:HasModifier("modifier_creeps_spell_fatalistic_homology_buff") then
			delay = 0.5
		end

		Timers:CreateTimer(delay, function()
			
			ParticleManager:DestroyParticle( fx, true ) 
			ParticleManager:ReleaseParticleIndex(fx)

	
	
		end)
	end

	return true
end
function creeps_spell_laguna_blade:GetCastRange()
	-- local caster =self:GetCaster()
	return self:GetSpecialValueFor("range")

end
--------------------------------------------------------------------------------

function creeps_spell_laguna_blade:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )
		-- ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

-- function creeps_spell_laguna_blade:RequiresFacing() return false end

function creeps_spell_laguna_blade:OnSpellStart()
	if IsServer() then
		-- ParticleManager:DestroyParticle( self.nPreviewFX, true )
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )

		self.lunge_speed = 1600
		self.lunge_width = 200
		self.lunge_distance = 1300
		self.lunge_damage = self:GetCaster():GetDamageMax()*7
		
		--EmitSoundOn( "Hero_Venomancer.PreAttack", self:GetCaster() )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end
		if vPos == self:GetCaster():GetAbsOrigin() then
			vPos = vPos + self:GetCaster():GetForwardVector()
		end


		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		local end_pos = self:GetCaster():GetOrigin()+vDirection*self:GetSpecialValueFor("range")
		end_pos.z = end_pos.z+64

		self.vProjectileLocation = self:GetCaster():GetOrigin() -- + ( vDirection * 100 )
		self:GetCaster():EmitSound("Ability.LagunaBladeImpact")
		local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(head_particle, 1, end_pos)
		-- No reason for this CP besides that I like colours
		-- ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
		ParticleManager:ReleaseParticleIndex(head_particle)

		local tTargets = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), end_pos, nil, 300,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE)

		
		local damage = self:GetCaster():GetDamageMax()*self:GetSpecialValueFor("bonus_damage")
		local damageTable = {
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
			}
		for _, enemy in pairs(tTargets) do


			damageTable.victim = enemy
			ApplyDamage(damageTable)
	
		end

		--EmitSoundOn( "Hero_Bristleback.QuillSpray.Cast", self:GetCaster() )
	end
end

