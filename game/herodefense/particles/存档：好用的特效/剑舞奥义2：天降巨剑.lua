function Advanced_Blade_Fury:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(0.2)
	local bDuration = self:GetSpecialValueFor("duration")*gain
	--LV20解锁坚毅
	if self.advanced_level>=20 then
		bDuration = bDuration*1.6
	end
	if self.unlock2 then
		local target_point 	= self:GetCursorPosition()
		local damageTable = {
			-- victim = target,
			attacker = caster,
			damage = caster:GetAverageTrueAttackDamage(nil)*2,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}

		for i = 1, 2, 1 do
			local new_pos = target_point + Vector(RandomInt(-300, 300),RandomInt(-300, 300),0)
			local thinker = CreateModifierThinker(
				caster, -- player source
				self, -- ability source
				"modifier_Advanced_Blade_Fury_thinker", 
				{duration = bDuration+0.5}, -- kv
				new_pos,
				caster:GetTeamNumber(),
				false
			)
			local units = FindUnitsInRadius(
				caster:GetTeamNumber(),	-- int, your team number
				new_pos,	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				0,	-- int, flag filter
				FIND_CLOSEST ,	-- int, order filter
				false	-- bool, can grow cache
			)
			for _,unit in pairs(units) do
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end

		end
		local thinker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_Blade_Fury_thinker", 
			{duration = bDuration+0.5}, -- kv
			target_point,
			caster:GetTeamNumber(),
			false
		)
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target_point,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			FIND_CLOSEST ,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _,unit in pairs(units) do
			damageTable.victim = unit
			ApplyDamage(damageTable)
		end
		return
	end





	if self.unlock1 then
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			FIND_CLOSEST ,	-- int, order filter
			false	-- bool, can grow cache
		)

	local count = 3
	for _,unit in pairs(units) do
		if unit~=caster then
			self:AddBladeFury(unit,bDuration)
			count = count - 1
			if count<=0 then
				break
			end
		end
	end
	end
	self:AddBladeFury(caster,bDuration)
end



function Advanced_Blade_Fury:AddBladeFury(target,bDuration)
	local caster = self:GetCaster()
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Blade_Fury", -- modifier name
		{ duration = bDuration } -- kv
	)

	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Blade_Fury_Wind_Blade", -- modifier name
		{ duration = bDuration } -- kv
	)

	if self.advanced_level>=20 then
		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_Blade_Fury_buff", -- modifier name
			{ duration = bDuration } -- kv
		)
	
	end
end



modifier_Advanced_Blade_Fury_thinker= modifier_Advanced_Blade_Fury_thinker or advanced_modifier({})

function modifier_Advanced_Blade_Fury_thinker:IsHidden()		return true end
function modifier_Advanced_Blade_Fury_thinker:IsPurgable()		return false end
function modifier_Advanced_Blade_Fury_thinker:RemoveOnDeath()	return false end
function modifier_Advanced_Blade_Fury_thinker:OnCreated(keys)
	if IsServer() then
		local particle_cast = "particles/rebuild/spell/blade_fury/unlock2/effect_crimson_jugger.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetParent() )
		local pos = self:GetParent():GetOrigin()
		ParticleManager:SetParticleControl( effect_cast, 0, pos )
		ParticleManager:SetParticleControl( effect_cast,60, Vector(self:GetRemainingTime(), 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		self:GetParent():EmitSound("DOTA_Item.AbyssalBlade.Activate")
		self:StartIntervalThink(0.5)
	end
end
function modifier_Advanced_Blade_Fury_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end


function modifier_Advanced_Blade_Fury_thinker:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	parent:AddNewModifier(
		caster, -- player source
		ability, -- ability source
		"modifier_Advanced_Blade_Fury_Wind_Blade", -- modifier name
		{ duration = self:GetRemainingTime() } -- kv
	)
	parent:AddNewModifier(
		caster, -- player source
		ability, -- ability source
		"modifier_Advanced_Blade_Fury", -- modifier name
		{ duration = self:GetRemainingTime() } -- kv
	)
end