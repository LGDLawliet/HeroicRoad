Middle_Chaos_Meteor = class({})
LinkLuaModifier( "modifier_Middle_Chaos_Meteor_thinker", "skills/Middle_Chaos_Meteor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Chaos_Meteor_debuff", "skills/Middle_Chaos_Meteor", LUA_MODIFIER_MOTION_NONE )


function Middle_Chaos_Meteor:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	if point==caster:GetAbsOrigin() then
		point = point + caster:GetForwardVector()
	end
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_Chaos_Meteor_thinker", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end







modifier_Middle_Chaos_Meteor_thinker = class({})

function modifier_Middle_Chaos_Meteor_thinker:IsHidden()	return true end


function modifier_Middle_Chaos_Meteor_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local ability = self:GetAbility()
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = 1.3
		self.radius = ability:GetSpecialValueFor("radius")
		if self:GetCaster():GetRandomEffect(35,INT_TYPE,1) >=RandomInt(1, 100) then
			self.radius = self.radius *2
		end
		self.distance = ability:GetSpecialValueFor("distance")
		self.speed = 200
	
		
		self.interval = 0.3




		-- variables
		self.fallen = false
		self.damageTable = {
			-- victim = target,
			damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false),
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		}

		self.effect_unit = {}


		-- Start interval
		self:StartIntervalThink( self.delay )

		-- play effects
		self:PlayEffects1()
	end
end



function modifier_Middle_Chaos_Meteor_thinker:OnDestroy( kv )
	if IsServer() then
		-- add vision
	
		-- stop effects
		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_Chaos_Meteor_thinker:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
		
		self:PlayEffects2()
	else
		-- move & damages
		self:Move_Burn()
	end
end

function modifier_Middle_Chaos_Meteor_thinker:Burn()
	if not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
	
	for _,enemy in pairs(enemies) do
		if not self.effect_unit[enemy] then
			self.effect_unit[enemy] =true
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Chaos_Meteor_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance})
		end
	


	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_Middle_Chaos_Meteor_thinker:Move_Burn()
	if not self:GetCaster() then
		return
	end
	local parent = self:GetParent()
	if not parent or not self:GetAbility() then
		self:SafeDestroy()
		return
	end

	-- set position
	local target = self.direction*self.speed*self.interval
	parent:SetOrigin( parent:GetOrigin() + target )

	-- Burn
	self:Burn()
	
	-- check distance for next step
	if (parent:GetOrigin() - self.parent_origin + target):Length2D()>self.distance then
		self:SafeDestroy()
		return
	end
end

function modifier_Middle_Chaos_Meteor_thinker:PlayEffects1()
	if not self:GetCaster() then
		return
	end
	
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/chaos_meteor/chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius*1.5/275, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_Middle_Chaos_Meteor_thinker:PlayEffects2()
	if not self:GetCaster() then
		return
	end
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/chaos_meteor_move/invoker_chaos_meteor.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControl( effect_cast, 1, self.direction * self.speed )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius*1.5/275, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- -- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )
	EmitSoundOn( sound_loop, self:GetParent() )
end










modifier_Middle_Chaos_Meteor_debuff = class({})

function modifier_Middle_Chaos_Meteor_debuff:IsDebuff()			return true end
function modifier_Middle_Chaos_Meteor_debuff:IsHidden() 			return false end
function modifier_Middle_Chaos_Meteor_debuff:IsPurgable() 			return true end
function modifier_Middle_Chaos_Meteor_debuff:IsPurgeException() 	return true end
function modifier_Middle_Chaos_Meteor_debuff:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
end

function modifier_Middle_Chaos_Meteor_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_Middle_Chaos_Meteor_debuff:OnCreated()
	if IsServer() then

		self.dmg = self:GetAbility():GetSpecialValueFor("tick_damage") +self:GetAbility():GetSpecialValueFor("bonus_tick_damage")*self:GetCaster():GetIntellect(false)
		self:StartIntervalThink(1)

	end
end


function modifier_Middle_Chaos_Meteor_debuff:OnIntervalThink()
	
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	if self:GetParent():IsMagicImmune() then
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.dmg,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	ApplyDamage(damageTable)
end