
chaotic_dagger_rain = class({})
function chaotic_dagger_rain:Precache( context )
	-- PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_dagger_rain/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_dagger_rain/chaotic_dagger_rain.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_dagger_rain/chaotic_dagger_rain_3.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_explosion.vpcf", context )
end
function chaotic_dagger_rain:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_dagger_rain:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_dagger_rain:GetManaCostGain()
	local caster = self:GetCaster()
	local keys = {
		ability=self,
		caster = caster,
	}
	local value = GetChaoticSpellManaCostGain(caster,keys)
	return value
end


function chaotic_dagger_rain:OnSpellStart()

	local caster = self:GetCaster()

	local effect_gain = self:GetEffectGain()
	local damage =  (self:GetCaster():GetDamageMax() * self:GetSpecialValueFor("bonus_damage")) * effect_gain

	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_dagger_rain/chaotic_dagger_rain.vpcf", PATTACH_CUSTOMORIGIN, caster )
	
	ParticleManager:SetParticleControl( effect_cast1, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast1, 3, caster:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast1)

	caster:EmitSound("Hero_PhantomAssassin.Dagger.Target")

	local radius = self:GetSpecialValueFor("radius")

	local duration = self:GetSpecialValueFor("duration")

	local caster_origin = caster:GetAbsOrigin()

	local damageTable = {
		attacker		= caster,            
		damage			= damage,
		damage_type		= self:GetAbilityDamageType(),
		damage_flags	= DOTA_DAMAGE_FLAG_NONE,
		ability			= self,
		hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE
	}
	local damage_radius = self:GetSpecialValueFor("damage_radius")

	local dagger_total = self:GetSpecialValueFor("dagger_total") * effect_gain
	local dagger_count = self:GetSpecialValueFor("dagger_count")
	local interval = 1/dagger_count

	caster:GameTimer(0.8,function()

		caster:EmitSound("Hero_Mirana.Starstorm.Cast")
		if not IsValid(self) then
			return
		end

		caster:GameTimer(interval,function()
			if not IsValid(self) then
				return
			end
			if self:GetRuneType()==1 then
				caster_origin = caster:GetAbsOrigin()
			end
			local end_pos = Vector(RandomInt(-radius, radius),RandomInt(-radius, radius),0)

			local damage_pos = Vector(caster_origin.x + end_pos.x,caster_origin.y + end_pos.y,caster_origin.z + end_pos.z)
	
			self:ApplyDagger(caster_origin,damage_pos,end_pos)

			caster:GameTimer(0.9,function()
				if not IsValid(self) then
					return
				end
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), damage_pos, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _ , enemy in pairs(enemies) do
					self:PlayHitEffect(enemy)
					damageTable.victim = enemy
					ApplyDamage(damageTable)
					break
				end
				caster:EmitSound("Hero_PhantomAssassin.Dagger.Target")
			end)
			dagger_total = dagger_total - 1

			if dagger_total>0 then
				return interval
			end
		end)
	end)
end

function chaotic_dagger_rain:ApplyDagger(caster_origin,damage_pos,end_pos)
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_dagger_rain/chaotic_dagger_rain_3.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, caster_origin)
	ParticleManager:SetParticleControl( effect_cast, 1, damage_pos)
	ParticleManager:SetParticleControl( effect_cast, 2, end_pos)
	ParticleManager:SetParticleControl( effect_cast, 3, end_pos)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	self:GetCaster():EmitSound("Hero_PhantomAssassin.Dagger.Cast")
	-- caster:EmitSound("Hero_Mirana.Attack")
end

function chaotic_dagger_rain:PlayHitEffect(taeget)
	local effect_cast_2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
	-- ParticleManager:SetParticleControl( effect_cast_2, 3, damage_pos)
	ParticleManager:SetParticleControlEnt( effect_cast_2, 3, taeget, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(effect_cast_2)
end