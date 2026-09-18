Middle_hoof_stomp = class({})


function Middle_hoof_stomp:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function Middle_hoof_stomp:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor( "damage" )+ caster:GetStrength()*self:GetSpecialValueFor("damage_index")
	local stun_duration = self:GetSpecialValueFor("duration")

	-- find affected units
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- for each caught enemies
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

	local talen3 = caster:FindAbilityByName("heroTalent_npc_dota_hero_centaur_3")
	if talen3 and self:GetDouble_edge() then
		local double_edge=  self:GetDouble_edge()
		local default = true
		for _,enemy in pairs(enemies) do
			-- Apply Damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			if #enemies<=3 then
				if enemy:GetHDStatusResistanceIndex(1)>1 then
					StatusResistance = enemy:GetHDStatusResistanceIndex(0.4)*ModifierStatusNegativeGain
				end
				StatusResistance = StatusResistance*1.3
			end
			
			-- Apply stun debuff
			enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = stun_duration *StatusResistance} )
			if enemy:IsAlive() then
				if default then
					default = false
					double_edge:OnSpellStart(enemy)
				elseif caster:RollRandom(talen3:GetSpecialValueFor("chance"),1) then
					double_edge:OnSpellStart(enemy)
				end
			end
		end
	else
		for _,enemy in pairs(enemies) do
			-- Apply Damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			if #enemies<=3 then
				if enemy:GetHDStatusResistanceIndex(1)>1 then
					StatusResistance =  enemy:GetHDStatusResistanceIndex(0.4)*ModifierStatusNegativeGain
				end
				StatusResistance = StatusResistance*1.3
			end
			
			-- Apply stun debuff
			enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = stun_duration *StatusResistance} )
		end

	end
	


	-- Play effects
	self:PlayEffects()
end

function Middle_hoof_stomp:PlayEffects()

	local caster = self:GetCaster()
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
	local sound_cast = "Hero_Centaur.HoofStomp"
	local radius = self:GetSpecialValueFor("radius")


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hoof_L",
		caster:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hoof_R",
		caster:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( caster:GetOrigin(), sound_cast, caster )
end




function Middle_hoof_stomp:GetDouble_edge()
	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_double_edge")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_double_edge")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_double_edge")
			end
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_double_edge")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_double_edge")
				if not self.ability then
					self.ability = self:GetCaster():FindAbilityByName("Primary_double_edge")
				end
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end
