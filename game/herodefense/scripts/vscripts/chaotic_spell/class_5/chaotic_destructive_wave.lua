LinkLuaModifier("modifier_chaotic_destructive_wave_debuff", "chaotic_spell/class_5/chaotic_destructive_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_destructive_wave_rune_1_debuff", "chaotic_spell/class_5/chaotic_destructive_wave", LUA_MODIFIER_MOTION_NONE)


chaotic_destructive_wave = class({})


function chaotic_destructive_wave:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_destructive_wave:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end
	return UF_SUCCESS
end


function chaotic_destructive_wave:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_aoe.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	ParticleManager:SetParticleControlEnt( self.effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "" , self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.effect_cast, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "" , self:GetCaster():GetAbsOrigin(), true )

	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(self:GetSpecialValueFor("radius"),0,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end


function chaotic_destructive_wave:UpdateCustomIndicator( loc )
	-- local caster = self:GetCaster()
	-- local pos = loc
	-- local caster_loc = caster:GetAbsOrigin()
	-- if pos==caster_loc then
	-- 	pos = pos +caster:GetForwardVector()*500
	-- end
	-- local direction 	= (pos - caster_loc):Normalized()

	-- local target_pos = caster_loc + direction* (self:GetSpecialValueFor("distance") +self:GetSpecialValueFor("end_width")*0.5)

	-- ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	-- ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	-- ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	-- ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(self:GetSpecialValueFor("end_width"),self:GetSpecialValueFor("start_width"),0))
	-- ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	-- ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_destructive_wave:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end


function chaotic_destructive_wave:GetCastRange()
	if IsServer() then
		return 30000
	end
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

function chaotic_destructive_wave:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_destructive_wave/effect_beam/effect_shared.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_destructive_wave/cast_effect/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast_hit.vpcf", context )
	

end

function chaotic_destructive_wave:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	-- local distance = self:GetSpecialValueFor("distance")
	-- local target_pos = caster_loc + direction* distance

	caster:EmitSound("chaotic_destructive_wave")
	caster:EmitSound("Hero_OgreMagi.Fireblast.Target")


	self:PlayEffect()

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	local gain = self:GetEffectGain()
	local damageTable = {
		attacker	= self:GetCaster(),
		-- victim = target,
		damage		= (self:GetSpecialValueFor("base_damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage"))*gain,
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}

	local knockback =
	{
		dir_x = direction.x,
		dir_y = direction.y,
		duration = 0.6,
		distance = self:GetSpecialValueFor("knockback_distance"),
		height = 230,
		activity = ACT_DOTA_FLAIL,
		notRemoveOnDeath = 1,
	} -- kv




	local stun_chance = self:GetSpecialValueFor("stun_chance")
	local stun_duration = self:GetSpecialValueFor("stun_duration") *caster:GetModifierStatusNegativeGainIndex(1)
	-- local max_count = self:GetSpecialValueFor("max_count")

	for _, unit in ipairs(enemies) do
		-- max_count = max_count - 1
		local arc =unit:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_arc_lua", -- modifier name
			knockback
		)
		damageTable.victim = unit
		self:PlayEffectTarget(unit)
		if self:GetRuneType()==1 then
			local buff = unit:AddNewModifier(caster, self, "modifier_chaotic_destructive_wave_rune_1_debuff", {duration = 0.01})
			ApplyDamage(damageTable)
			unit:RemoveModifierByName("modifier_chaotic_destructive_wave_rune_1_debuff")
		else
			ApplyDamage(damageTable)
		end
		

		if IsValid(unit) and unit:IsAlive() then
			if caster:RollRandom(stun_chance,1)  then
				local duration = stun_duration * unit:GetHDStatusResistanceIndex()
				unit:AddNewModifier(caster,self, "modifier_stunned", {duration = duration})
			end
		end

	end



end







function chaotic_destructive_wave:PlayEffect()
	local caster = self:GetCaster()
	local particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_destructive_wave/cast_effect/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()+Vector(0,0,64))
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin()+Vector(0,0,64))
	-- ParticleManager:SetParticleControlForward( particle,0,dir)
	-- ParticleManager:ReleaseParticleIndex(particle)
	DestroyParticleByDelay(particle,3)




	local particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_destructive_wave/effect_beam/effect_shared.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()+Vector(0,0,64))
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin()+Vector(0,0,64))
	-- ParticleManager:SetParticleControlForward( particle,0,dir)
	DestroyParticleByDelay(particle,3)


	
end






function chaotic_destructive_wave:PlayEffectTarget(target)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt( particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(particle)
end







modifier_chaotic_destructive_wave_rune_1_debuff = class({})

function modifier_chaotic_destructive_wave_rune_1_debuff:IsDebuff()			return true end
function modifier_chaotic_destructive_wave_rune_1_debuff:IsHidden() 			return false end
function modifier_chaotic_destructive_wave_rune_1_debuff:IsPurgable() 		return false end
function modifier_chaotic_destructive_wave_rune_1_debuff:IsPurgeException() 	return false end
function modifier_chaotic_destructive_wave_rune_1_debuff:OnCreated(keys)
	self.rune_1_bonus = -self:GetAbility():GetSpecialValueFor("rune_1_bonus")
end
function modifier_chaotic_destructive_wave_rune_1_debuff:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	} 
end

function modifier_chaotic_destructive_wave_rune_1_debuff:GetModifierMagicalResistanceBonus() 
	return self.rune_1_bonus
end







