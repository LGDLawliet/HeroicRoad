creeps_spell_fellomen_bad_21 = class({})




function creeps_spell_fellomen_bad_21:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps/spell/fellomen_bad_21/effect.vpcf", context )

	
end





function creeps_spell_fellomen_bad_21:OnProjectileHit( target, location )
	if not target then return end
    local level = GetLevel("modifier_FellOmen_Bad_21")

	-- load data
	local damage = math.min((10+2*level)*0.01,0.5)
	local duration =1.5
	local impact_radius = 300

	local caster= self:GetCaster()
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
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
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	
	for _,enemy in pairs(enemies) do
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self, "modifier_stunned", {duration= duration*StatusResistance})
		damageTable.damage = enemy:GetMaxHealth()*damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/creeps/spell/fellomen_bad_21/effect.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_main_fx, 0, location)
	ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(300, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_main_fx)
	EmitSoundOnLocationWithCaster(location,"Hero_Invoker.ChaosMeteor.Impact",caster)
end




