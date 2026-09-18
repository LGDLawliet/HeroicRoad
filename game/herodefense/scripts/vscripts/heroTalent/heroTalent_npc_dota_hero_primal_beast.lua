heroTalent_npc_dota_hero_primal_beast =heroTalent_npc_dota_hero_primal_beast or class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_primal_beast", "heroTalent/heroTalent_npc_dota_hero_primal_beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_primal_beast_effect", "heroTalent/heroTalent_npc_dota_hero_primal_beast", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_primal_beast:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", context )
end
function heroTalent_npc_dota_hero_primal_beast:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_primal_beast:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_primal_beast:IsStealable() 				return true end
function heroTalent_npc_dota_hero_primal_beast:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_primal_beast:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_primal_beast" end
function heroTalent_npc_dota_hero_primal_beast:GetCastRange()
	local caster = self:GetCaster()
	return 230 - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_primal_beast = modifier_heroTalent_npc_dota_hero_primal_beast or class({})

function modifier_heroTalent_npc_dota_hero_primal_beast:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_primal_beast:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_primal_beast:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_primal_beast:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_primal_beast:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_primal_beast:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self:GetParent():SetHullRadius(5)
		self.parent = self:GetParent()
		self.ability = self:GetAbility()

		self.radius = 400
		self.step_distance = 140

		self.attack_damage = 0.3

	
		self.abilityDamageType = self:GetAbility():GetAbilityDamageType()

		self.distance = 0
		self.currentpos = self.parent:GetOrigin()


		self:StartIntervalThink( 0.1 )

	end
end



function modifier_heroTalent_npc_dota_hero_primal_beast:OnIntervalThink(keys)
	local caster = self:GetCaster()
	if not caster:IsAlive() then
		return
	end
	local ability =  self:GetAbility()
	if not ability:GetAutoCastState() then
		return
	end

	local pos = self.parent:GetOrigin()
	local dist = (pos-self.currentpos):Length2D()
	self.currentpos = pos

	self.distance = self.distance + dist
	if self.distance > self.step_distance then
		self:Trample()
		self.distance = 0
	end
end

function modifier_heroTalent_npc_dota_hero_primal_beast:Trample()
	
	local pos = self.parent:GetOrigin()
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damage = self.parent:GetAverageTrueAttackDamage(self.parent)*self.attack_damage
	local damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
	}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
			enemy,
			damage,
			nil
		)
	end
	-- self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 3)
	self:PlayEffects()
end



function modifier_heroTalent_npc_dota_hero_primal_beast:DeclareFunctions()
	if IsServer() then
		-- if self:GetAbility():GetAutoCastState() then
		-- 	return {
		-- 		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		-- 	}
		-- end
		return {
			MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		}
		
	end
	return


	
end




function modifier_heroTalent_npc_dota_hero_primal_beast:GetActivityTranslationModifiers()
	return "heavy_steps"
end

function modifier_heroTalent_npc_dota_hero_primal_beast:CheckState()
	if IsServer() then
		if self:GetAbility():GetAutoCastState() then
			return {
				[MODIFIER_STATE_DISARMED] = true,
				[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
				-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			}
		end
		
	end


	return 
end



function modifier_heroTalent_npc_dota_hero_primal_beast:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf"
	local sound_cast = "Hero_PrimalBeast.Trample"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )

	-- ParticleManager:ReleaseParticleIndex( effect_cast )
	DestroyParticleByDelay(effect_cast, 3)

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end