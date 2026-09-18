Middle_astral_imprisonment = class({})
LinkLuaModifier( "modifier_Middle_astral_imprisonment", "skills/Middle_astral_imprisonment", LUA_MODIFIER_MOTION_NONE )

function Middle_astral_imprisonment:GetAOERadius() return self:GetSpecialValueFor("radius") end



function Middle_astral_imprisonment:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb(self) then
		return
	end
	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	local StatusResistance = 1


	if IsEnemy(caster,target) then
		StatusResistance = target:GetHDStatusResistanceIndex(1)
	end
	-- add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_astral_imprisonment", -- modifier name
		{ duration = math.max(duration*StatusResistance,0.1) } -- kv
	)

	-- play effects
	local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.Cast"
	EmitSoundOn( sound_cast, caster )
end




modifier_Middle_astral_imprisonment = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_astral_imprisonment:IsHidden()	return false end
function modifier_Middle_astral_imprisonment:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_Middle_astral_imprisonment:IsStunDebuff()	return true end
function modifier_Middle_astral_imprisonment:IsPurgable()	return true end
function modifier_Middle_astral_imprisonment:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_astral_imprisonment:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)+self:GetCaster():GetMana()*0.25
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
		local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_obsidian_destroyer_3")
	if ability then
		damage = damage + ability:GetBonusDamage(self:GetAbility():GetAbilityName())
	end
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- play effects
	self:GetParent():AddNoDraw()
	self:PlayEffects()
end

function modifier_Middle_astral_imprisonment:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)+self:GetCaster():GetMana()*0.25
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_obsidian_destroyer_3")
	if ability then
		damage = damage + ability:GetBonusDamage(self:GetAbility():GetAbilityName())
	end
	self.damageTable.damage = damage
end



function modifier_Middle_astral_imprisonment:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )


	end
	local effect_cast_damage = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast_damage, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast_damage, 1, Vector(self.radius,0,0) )
	ParticleManager:ReleaseParticleIndex(effect_cast_damage)
	-- play effects
	self:GetParent():RemoveNoDraw()
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	StopSoundOn( sound_loop, self:GetCaster() )

	local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.End"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Middle_astral_imprisonment:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_astral_imprisonment:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf"
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"

	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_loop, self:GetCaster() )
end