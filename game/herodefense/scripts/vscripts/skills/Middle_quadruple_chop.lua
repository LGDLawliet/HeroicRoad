Middle_quadruple_chop = class({})

-- LinkLuaModifier( "modifier_Middle_quadruple_chop", "skills/Middle_quadruple_chop", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能


function Middle_quadruple_chop:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	local min_dist = 200
	local max_dist = 1000
	local radius = 250


	local direction = (point-origin)
	local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )
	FindClearSpaceForUnit( caster, target, true )


	local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	origin,	target,	nil,	radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	
	)
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}

	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	for _,enemy in pairs(enemies) do

		caster:PerformAttack( enemy, true, true, true, false, false, false, true )


		-- self:PlayEffects2( enemy )
	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	
	local damage = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetAgility()
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	local count = self:GetSpecialValueFor("effect_count")
	local blade_count = 4 + self:GetCurrentAbilityCharges()
	self:SetCurrentAbilityCharges(0)
	
	
	for i = 1, blade_count, 1 do
	
		Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			vDir.z = 0
			vDir = vDir:Normalized()
			local pos_0 = target +Vector(RandomInt(-400, 400),RandomInt(-400, 400),0)
			local pos_1 = pos_0 + vDir * 600
			local pos_2 = pos_0 - vDir * 600
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), pos_1, pos_2, nil, 150,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

			for i, hTarget in pairs(tTargets) do
				damageTable.victim = hTarget
				ApplyDamage(damageTable)
				if i>=count then
					break
				end
			end

			local iPtclID = ParticleManager:CreateParticle('particles/rebuild/spell/quadruple_chop_2/quadruple_chop.vpcf', PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iPtclID, 0, pos_2)
			ParticleManager:SetParticleControl(iPtclID, 1, pos_1)
			ParticleManager:SetParticleControl( iPtclID, 60, Vector(255,0,0) )
			ParticleManager:SetParticleControl( iPtclID, 61, Vector(1,0,0) )
			ParticleManager:ReleaseParticleIndex(iPtclID)
			caster:EmitSound("Hero_Centaur.DoubleEdge.TI9")
		end)

	end
	

	self:PlayEffects1( origin, target )
end

--------------------------------------------------------------------------------
function Middle_quadruple_chop:PlayEffects1( origin, target )
	
	local particle_cast = "particles/rebuild/spell/quadruple_chop_2/quadruple_chop.vpcf"
	local sound_start = "Hero_VoidSpirit.AstralStep.Start"
	local sound_end = "Hero_VoidSpirit.AstralStep.End"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(255,0,0) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

-- function Middle_quadruple_chop:PlayEffects2( target )

-- 	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf"


-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )
-- end


