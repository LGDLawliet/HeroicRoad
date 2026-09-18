Middle_laser = class({})
LinkLuaModifier( "modifier_Middle_laser", "skills/Middle_laser", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Phase Start
function Middle_laser:OnAbilityPhaseStart()
	-- effects
	local sound_cast = "Hero_Tinker.LaserAnim"
	EmitSoundOn( sound_cast, self:GetCaster() )

	return true -- if success
end

function Middle_laser:GetAOERadius()
	return 350
end

function Middle_laser:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local talent4 = self:FindTalent4()
	if talent4 and talent4:IsCooldownReady() then
		talent4:StartCooldown(self:GetCooldownTimeRemaining())
		self:EndCooldown()
	end

	-- cancel if Linken
	if target:TriggerSpellAbsorb( self ) then
		return
	end

	-- load data

	local duration = self:GetSpecialValueFor("duration")
	local damage = self:GetSpecialValueFor("damage")+ self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)

	-- get targets
	local targets = {}
	table.insert( targets, target )
	local count = 1
	if talent4 then
		count = count + talent4:GetSpecialValueFor("bonus_bounce")
	end

	for i = 1, count, 1 do
		self:Refract( targets )
	end

	-- precache damage


	local damage = {
		-- victim = hTarget,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	for _, unit in ipairs(targets) do
		local units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, 350, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(units) do
			-- apply damage
			damage.victim = enemy
			ApplyDamage( damage )
		end

		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		unit:AddNewModifier(caster, self, "modifier_Middle_laser", { duration = duration *StatusResistance} 	)
	end
	


	-- effects
	self:PlayEffects( targets )
end

function Middle_laser:Refract( targets )
	-- load data


	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		targets[#targets]:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		800,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		FIND_FARTHEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- check for valid closest not-yet-affected next target 
	local next_target = nil
	for _,enemy in pairs(enemies) do
		local candidate = true
		for _,target in pairs(targets) do
			if enemy==target then
				candidate = false
				break
			end
		end
		if candidate then
			next_target = enemy
			break
		end
	end

	-- recursive
	if next_target then
		table.insert( targets, next_target )
	end
end

--------------------------------------------------------------------------------
function Middle_laser:PlayEffects( targets )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_tinker_rebuild/tinker_laser.vpcf"
	local sound_cast = "Hero_Tinker.Laser"
	local sound_target = "Hero_Tinker.LaserImpact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		9,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		targets[1],
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, targets[1] )

	if #targets>1 then
		for i=2,#targets do
			-- Create Particle
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt(
				effect_cast,
				9,
				targets[i-1],
				PATTACH_POINT_FOLLOW,
				"attach_hitloc",
				Vector(0,0,0), -- unknown
				true -- unknown, true
			)
			ParticleManager:SetParticleControlEnt(
				effect_cast,
				1,
				targets[i],
				PATTACH_POINT_FOLLOW,
				"attach_hitloc",
				Vector(0,0,0), -- unknown
				true -- unknown, true
			)
			ParticleManager:ReleaseParticleIndex( effect_cast )

			-- create sound
			EmitSoundOn( sound_target, targets[i] )
		end
	end
end


function Middle_laser:FindTalent4()
	if not self.talent4 then
		self.talent4 = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_tinker_4")
	end
	return self.talent4
end




modifier_Middle_laser = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_laser:IsHidden()	return false end
function modifier_Middle_laser:IsDebuff()	return true end
function modifier_Middle_laser:IsStunDebuff()	return false end
function modifier_Middle_laser:IsPurgable()	return true end

function modifier_Middle_laser:OnCreated( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end

function modifier_Middle_laser:OnRefresh( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_laser:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

function modifier_Middle_laser:GetModifierMiss_Percentage()
	return self.miss_rate
end