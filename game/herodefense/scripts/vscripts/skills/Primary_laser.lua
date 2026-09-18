Primary_laser = class({})
LinkLuaModifier( "modifier_Primary_laser", "skills/Primary_laser", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Phase Start
function Primary_laser:OnAbilityPhaseStart()
	-- effects
	local sound_cast = "Hero_Tinker.LaserAnim"
	EmitSoundOn( sound_cast, self:GetCaster() )

	return true -- if success
end
function Primary_laser:GetAOERadius()
	return 350
end
--------------------------------------------------------------------------------
-- Ability Start
function Primary_laser:OnSpellStart()

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
	local targets = {}
	table.insert( targets, target )
	-- precache damage
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 350, 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local damage = {
		-- victim = hTarget,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}
	for _,enemy in pairs(units) do
		-- apply damage
		damage.victim = enemy
		ApplyDamage( damage )
	end
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_Primary_laser", { duration = duration *StatusResistance} 	)

	-- effects
	self:PlayEffects( targets )
end

function Primary_laser:PlayEffects( targets )
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


function Primary_laser:FindTalent4()
	if not self.talent4 then
		self.talent4 = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_tinker_4")
	end
	return self.talent4
end
-------

-- heroTalent_npc_dota_hero_tinker_4




modifier_Primary_laser = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_laser:IsHidden()	return false end
function modifier_Primary_laser:IsDebuff()	return true end
function modifier_Primary_laser:IsStunDebuff()	return false end
function modifier_Primary_laser:IsPurgable()	return true end

function modifier_Primary_laser:OnCreated( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end

function modifier_Primary_laser:OnRefresh( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_laser:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

function modifier_Primary_laser:GetModifierMiss_Percentage()
	return self.miss_rate
end