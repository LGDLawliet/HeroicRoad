
require("internal/timers")
--------------------------------------------------------------------------------
Middle_Solar_Guardian = class({})
LinkLuaModifier( "modifier_Middle_Solar_Guardian", "skills/Middle_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Solar_Guardian_buff", "skills/Middle_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Solar_Guardian_leap", "skills/Middle_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )



function Middle_Solar_Guardian:GetCastRange()
	local caster = self:GetCaster()
	return 2000-caster:GetCastRangeBonus()

end



--------------------------------------------------------------------------------
-- Custom KV
function Middle_Solar_Guardian:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end


--------------------------------------------------------------------------------
-- Ability Start
function Middle_Solar_Guardian:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local channel = self:GetChannelTime()
	local leaptime = self:GetSpecialValueFor( "airtime_duration" )

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_Solar_Guardian", -- modifier name
		{
			duration = channel+leaptime,
			x = point.x,
			y = point.y,
		} -- kv
	)

	-- store point
	self.point = point
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

end

--------------------------------------------------------------------------------
-- Ability Channeling
function Middle_Solar_Guardian:OnChannelFinish( interrupted )
	-- unit identifier
	local caster = self:GetCaster()

	if interrupted then
		local mod = caster:FindModifierByName( "modifier_Middle_Solar_Guardian" )
		if mod and (not mod:IsNull()) then
			mod:SafeDestroy()
			self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
		end
		return
	end

	-- load data
	local duration = self:GetSpecialValueFor( "airtime_duration" )
	

	-- add leap modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_Solar_Guardian_leap", -- modifier name
		{
			duration = duration,
			x = self.point.x,
			y = self.point.y,
		} -- kv
	)
end


function Middle_Solar_Guardian:Pulse(point, value_multiplier)	
	if not IsServer() then return end
	local damage = (self:GetSpecialValueFor( "base_damage" ) +self:GetSpecialValueFor( "bounus_damage_index" )*self:GetCaster():GetBaseDamageMax())* value_multiplier 
	local heal = (self:GetSpecialValueFor( "base_heal" )+self:GetSpecialValueFor( "bounus_heal_index" )*self:GetCaster():HDGetPrimaryStatValue()) * value_multiplier
	local radius = self:GetSpecialValueFor( "radius" )

	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL ,
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )
	end

	-- find allies
	local allies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,ally in pairs(allies) do
		-- heal
		local healing = HealWithGain(heal,self:GetCaster(),ally,self)

		if ally ~= self:GetCaster() then
			-- effects
			local particle_heal = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_healing_buff.vpcf"
			-- Create Particle
			local heal_fx = ParticleManager:CreateParticle( particle_heal, PATTACH_ABSORIGIN_FOLLOW, ally )
			ParticleManager:ReleaseParticleIndex( heal_fx )
		end

		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_HEAL,
			ally,
			healing,
			self:GetCaster():GetPlayerOwner()
		)
	end
	
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_damage.vpcf"	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_ring_flames.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )	
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )

	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_outer_diamonds.vpcf"
	effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )	
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast2, 1, point )
	ParticleManager:SetParticleControl( effect_cast2, 2, Vector( radius, radius, radius ) )

	particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_ambient_solar_flare.vpcf"
	effect_cast3 = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )		
	ParticleManager:SetParticleControl( effect_cast3, 0, point )
	ParticleManager:SetParticleControl( effect_cast3, 1, point )
	ParticleManager:SetParticleControl( effect_cast3, 2, Vector( radius, radius, radius ) )

	Timers(0.2, function()
		ParticleManager:DestroyParticle(effect_cast, false)
		ParticleManager:ReleaseParticleIndex( effect_cast )
		ParticleManager:DestroyParticle(effect_cast2, false)
		ParticleManager:ReleaseParticleIndex( effect_cast2 )
		ParticleManager:DestroyParticle(effect_cast3, false)
		ParticleManager:ReleaseParticleIndex( effect_cast3 )
	end)	
	
end








modifier_Middle_Solar_Guardian = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Solar_Guardian:IsHidden()return false end
function modifier_Middle_Solar_Guardian:IsDebuff()return false end
function modifier_Middle_Solar_Guardian:IsPurgable()return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Solar_Guardian:OnCreated( kv )


	if not IsServer() then return end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.damage = (self:GetAbility():GetSpecialValueFor( "base_damage" ) +self:GetAbility():GetSpecialValueFor( "bounus_damage_index" )*self:GetCaster():GetBaseDamageMax())
	self.heal = (self:GetAbility():GetSpecialValueFor( "base_heal" )+self:GetAbility():GetSpecialValueFor( "bounus_heal_index" )*self:GetCaster():HDGetPrimaryStatValue())

	self.interval = self:GetAbility():GetSpecialValueFor( "pulse_interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()

	self.point = Vector( kv.x, kv.y, 0 )

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2( self.point, self.radius )
end

function modifier_Middle_Solar_Guardian:OnRefresh( kv )	
end

function modifier_Middle_Solar_Guardian:OnRemoved()
end

function modifier_Middle_Solar_Guardian:OnDestroy()
	if not IsServer() then return end
	FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )

	-- stop effects
	local sound_cast1 = "Hero_Dawnbreaker.Solar_Guardian.Channel"
	local sound_cast2 = "Hero_Dawnbreaker.Solar_Guardian.Target"
	StopSoundOn( sound_cast1, self.parent )
	StopSoundOn( sound_cast2, self.parent )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Middle_Solar_Guardian:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_Solar_Guardian:OnIntervalThink()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- find allies
	local allies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,ally in pairs(allies) do
		-- heal
		local healing = HealWithGain(self.heal,self:GetCaster(),ally,self.ability)

		-- effects
		self:PlayEffects4( ally )
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_HEAL,
			ally,
			healing,
			self.parent:GetPlayerOwner()
		)
	end

	-- play effects
	self:PlayEffects3( self.point, self.radius )

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_Solar_Guardian:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.Channel"
	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	
end

function modifier_Middle_Solar_Guardian:PlayEffects2( point, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_aoe.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.Target"

	-- Get Data
	point = GetGroundPosition( point, self.parent )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self.parent )
end

function modifier_Middle_Solar_Guardian:PlayEffects3( point, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_damage.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.Damage"

	-- Get Data
	point = GetGroundPosition( point, self.parent )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self.parent )
end

function modifier_Middle_Solar_Guardian:PlayEffects4( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_healing_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end



-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_Middle_Solar_Guardian_leap = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Solar_Guardian_leap:IsHidden()return true end
function modifier_Middle_Solar_Guardian_leap:IsDebuff()return false end
function modifier_Middle_Solar_Guardian_leap:IsPurgable()return false end

function modifier_Middle_Solar_Guardian_leap:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Solar_Guardian_leap:OnCreated( kv )

	if not IsServer() then return end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.damage = self.ability:GetSpecialValueFor( "land_damage" )+self.ability:GetSpecialValueFor("land_bounus_damage")*self:GetCaster():GetBaseDamageMax()
	self.duration = self.ability:GetSpecialValueFor( "land_stun_duration" )

	-- ability properties
	self.abilityDamageType = self.ability:GetAbilityDamageType()

	-- get data
	local arc_height = 2500 * kv.duration
	self.point = Vector( kv.x, kv.y, 0 )
	self.interrupted = false

	-- add arc
	local arc = self.parent:AddNewModifier(
		self.parent, -- player source
		self.ability, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			duration = kv.duration,
			height = arc_height,
			isStun = false,
			isForward = true,
		} -- kv
	)
	arc:SetEndCallback(function( interrupted )
		if interrupted then
			self.interrupted = interrupted
			self:SafeDestroy()
		end
	end)



	self:StartIntervalThink( kv.duration/2 )

	-- play effects
	self:PlayEffects1()
end

function modifier_Middle_Solar_Guardian_leap:OnRefresh( kv )
end

function modifier_Middle_Solar_Guardian_leap:OnRemoved()
end

function modifier_Middle_Solar_Guardian_leap:OnDestroy()
	if not IsServer() then return end
	if self.interrupted then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}
	-- ApplyDamage(damageTable)

	
	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		-- stun
		local StatusResistance = enemy:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
		enemy:AddNewModifier(
			self.parent, -- player source
			self.ability, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration * StatusResistance} -- kv
		)


	end

	local units = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local ModifierStatusGain = self:GetCaster():GetModifierDurationGainIndex(1)
	for _,unit in pairs(units) do
		-- stun
		unit:AddNewModifier(
			self.parent, -- player source
			self.ability, -- ability source
			"modifier_Middle_Solar_Guardian_buff", -- modifier name
			{ duration = self:GetAbility():GetSpecialValueFor("damage_up_duration") *ModifierStatusGain} -- kv
		)
	end

	-- play effects
	self:PlayEffects2( self.point, self.radius )
	FindClearSpaceForUnit( self.parent, self.parent:GetAbsOrigin(), true )
	
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_Solar_Guardian_leap:OnIntervalThink()
	-- move position to target
	self.point.z = self.parent:GetOrigin().z
	self.parent:SetOrigin( self.point )	
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_Middle_Solar_Guardian_leap:GetEffectName()
-- 	return "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_airtime_buff.vpcf"
-- end

-- function modifier_Middle_Solar_Guardian_leap:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

function modifier_Middle_Solar_Guardian_leap:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_airtime_buff.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.BlastOff"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
end

function modifier_Middle_Solar_Guardian_leap:PlayEffects2( point, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_landing.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.Impact"

	-- Get Data
	point = GetGroundPosition( point, self.parent )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self.parent )
	self:GetParent():StartGestureFadeWithSequenceSettings(ACT_DOTA_OVERRIDE_ABILITY_4)

	local land_voiceline = {
		"dawnbreaker_valora_fury_01",
		"dawnbreaker_valora_fury_02",
		"dawnbreaker_valora_fury_03",
		"dawnbreaker_valora_fury_04",
		"dawnbreaker_valora_fury_05",
		"dawnbreaker_valora_fury_06",
		"dawnbreaker_valora_fury_07",
		"dawnbreaker_valora_fury_08",
		"dawnbreaker_valora_fury_09",
		"dawnbreaker_valora_fury_10",
		"dawnbreaker_valora_fury_11",
		"dawnbreaker_valora_fury_12",
		"dawnbreaker_valora_fury_13",
		"dawnbreaker_valora_fury_14",
		"dawnbreaker_valora_fury_15",
		"dawnbreaker_valora_fury_16",
		"dawnbreaker_valora_fury_17",
		"dawnbreaker_valora_fury_18",
		"dawnbreaker_valora_fury_19",
		"dawnbreaker_valora_fury_20",
		"dawnbreaker_valora_fury_21",
		"dawnbreaker_valora_fury_22",				
	}
	self:GetParent():EmitSound(land_voiceline[RandomInt(1, #land_voiceline)])
end





modifier_Middle_Solar_Guardian_buff = advanced_modifier({})

function modifier_Middle_Solar_Guardian_buff:IsDebuff()			return false end
function modifier_Middle_Solar_Guardian_buff:IsHidden() 			return false end
function modifier_Middle_Solar_Guardian_buff:IsPurgable() 		    return false end
function modifier_Middle_Solar_Guardian_buff:IsPurgeException() 	return false end
function modifier_Middle_Solar_Guardian_buff:RemoveOnDeath()       return false end
function modifier_Middle_Solar_Guardian_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


-- advanced_modifier
function modifier_Middle_Solar_Guardian_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
	return funcs
end

function modifier_Middle_Solar_Guardian_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)

	return self:GetAbility():GetSpecialValueFor("damage_up")
end




