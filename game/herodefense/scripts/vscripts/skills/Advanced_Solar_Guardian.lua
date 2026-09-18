
require("internal/timers")
--------------------------------------------------------------------------------
Advanced_Solar_Guardian = class({})
LinkLuaModifier( "modifier_Advanced_Solar_Guardian", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Solar_Guardian_buff", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Solar_Guardian_leap", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Solar_Guardian_sky", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Solar_Guardian_slow", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Solar_Guardian_delay", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_Solar_Guardian_unlock1", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Solar_Guardian_unlock2", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Solar_Guardian_unlock3", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Solar_Guardian_unlock3_effect", "skills/Advanced_Solar_Guardian", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities

function Advanced_Solar_Guardian:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/solar_guardian/unlock3/effect.vpcf", context )

end


function Advanced_Solar_Guardian:CheckKV(key)
	local table = {
		base_heal=5,
		base_damage=5,
		bounus_heal_index=0.04,
		bounus_damage_index=0.04,
		land_bounus_damage=0.15,
		radius=10,
		land_damage=10,
	}
	local value = table[key] or -1
	return value

end

function Advanced_Solar_Guardian:CheckKVFixedOverride(key)
	if key=="AbilityCharges" then
		if self:GetSpecialValueFor("advanced_level")>=15 then
			return 2
		end
	end

	return -999999
end

function Advanced_Solar_Guardian:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Solar_Guardian_unlock1",{})
	return true
end
function Advanced_Solar_Guardian:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Solar_Guardian_unlock2",{})
	return true
end
function Advanced_Solar_Guardian:UnlockThirdCore(key)
	local caster = self:GetCaster()
	
	-- if _G.Fortunes_end_unlock3 or caster:GetUnitName()~="npc_dota_hero_oracle" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	-- self.totalcost = 0
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Solar_Guardian_unlock3",{})
	-- _G.Fortunes_end_unlock3 = true
	return true

end

function Advanced_Solar_Guardian:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_POINT +DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	
		end
		
	end


	return self.BaseClass.GetBehavior(self)
end

function Advanced_Solar_Guardian:CreateSinglePulse(pos,damage_index)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local damage = (self:GetSpecialValueFor( "base_damage" )+(self:GetSpecialValueFor( "bounus_damage_index" ))  *caster:GetBaseDamageMax())
	local heal = (self:GetSpecialValueFor( "base_heal" )+(self:GetSpecialValueFor( "bounus_heal_index" ))   *caster:HDGetPrimaryStatValue())
	if damage_index then
		damage = damage * damage_index
		heal = heal * damage_index
	end


	local radius = self:GetSpecialValueFor( "radius" ) 


	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}



	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
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
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_healing_buff.vpcf"


	
	for _,ally in pairs(allies) do

		if ally:GetHealthPercent()<100 then
			local healing = HealWithGain(heal,caster,ally,self)
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, ally )
			ParticleManager:ReleaseParticleIndex( effect_cast )
	
			SendOverheadEventMessage(
				nil,
				OVERHEAD_ALERT_HEAL,
				ally,
				healing,
				caster:GetPlayerOwner()
			)
		end

	end

	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_damage.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.Damage"



	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 1, pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( pos, sound_cast, caster )

end
function Advanced_Solar_Guardian:CreateSingleFinalPulse(pos)
	local caster = self:GetCaster()

	local radius = self:GetSpecialValueFor( "radius" )
	local damage = self:GetSpecialValueFor( "land_damage" )+(self:GetSpecialValueFor("land_bounus_damage"))*caster:GetBaseDamageMax()
	-- local duration = self:GetSpecialValueFor( "land_stun_duration" )
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage*2,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}



	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
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



	local units = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	for _,unit in pairs(units) do
		-- stun

		unit:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_Solar_Guardian_buff", -- modifier name
			{ duration = self:GetSpecialValueFor("damage_up_duration") *ModifierStatusGain} -- kv
		)
	end

	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_landing.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.Impact"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 1, pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( pos, sound_cast, caster )
	
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
	caster:EmitSound(land_voiceline[RandomInt(1, #land_voiceline)])

end
-- function Advanced_Solar_Guardian:Spawn()
-- 	if not IsServer() then return end
-- 	local this = self
-- 	Timers(2, function()
-- 		if IsValidEntity(this) and this:GetCaster():FindAbilityByName("Advanced_Solar_Guardian_charges") then
-- 			this:RefreshIntrinsicModifier()
-- 			return nil			
-- 		else
-- 			return 2
-- 		end
-- 	end)	
-- end


function Advanced_Solar_Guardian:GetCastRange()
	local caster = self:GetCaster()
	return 2000-caster:GetCastRangeBonus()

end

function Advanced_Solar_Guardian:GetChannelTime()
	-- if not IsServer() then return end
	-- 该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if advanced_level>=5 then
		return 0.85
	end
	return 1.7
end

-- function Advanced_Solar_Guardian:GetChannelTime()
-- 	-- if not IsServer() then return end
-- 	-- 该技能需要从网表拿等级数据 自定义变量拿不到该值
-- 	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
-- 	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
-- 	if advanced_level>=5 then
-- 		return 0.85
-- 	end
-- 	return 1.7
-- end



--------------------------------------------------------------------------------
-- Custom KV
function Advanced_Solar_Guardian:GetAOERadius()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	return self:GetSpecialValueFor( "radius" )
end


--------------------------------------------------------------------------------
-- Ability Start
function Advanced_Solar_Guardian:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local channel = self:GetChannelTime()                          --持续施法时间 1.7or0.85
	local leaptime = self:GetSpecialValueFor( "airtime_duration" ) --滞空时间 0.8
	
	--LV5解锁极速升天
	if self.advanced_level>=5 then
		leaptime=leaptime*0.75
	end
	local time = channel+leaptime
	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Solar_Guardian", -- modifier name
		{
			duration = time,
			x = point.x,
			y = point.y,
		} -- kv
	)

	-- store point
	self.point = point
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)


	-- --LV15解锁副能量源
	-- if self.advanced_level<15 then
	-- 	self:SetCurrentAbilityCharges(0)
	-- end

end

--------------------------------------------------------------------------------
-- Ability Channeling
function Advanced_Solar_Guardian:OnChannelFinish( interrupted )
	-- unit identifier
	local caster = self:GetCaster()

	if interrupted then
		local mod = caster:FindModifierByName( "modifier_Advanced_Solar_Guardian" )
		if mod and (not mod:IsNull()) then
			mod:SafeDestroy()
			self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
		end
		return
	end

	-- load data
	local duration = self:GetSpecialValueFor( "airtime_duration" )
	--LV5解锁极速升天
	if self.advanced_level>=5 then
		duration = duration *0.75
	end

	-- add leap modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Solar_Guardian_leap", -- modifier name
		{
			duration = duration,
			x = self.point.x,
			y = self.point.y,
		} -- kv
	)
end


function Advanced_Solar_Guardian:Pulse(point, value_multiplier)	
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








modifier_Advanced_Solar_Guardian = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Solar_Guardian:IsHidden()return false end
function modifier_Advanced_Solar_Guardian:IsDebuff()return false end
function modifier_Advanced_Solar_Guardian:IsPurgable()return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Solar_Guardian:OnCreated( kv )


	if not IsServer() then return end


	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	--获取技能等级
	self.advanced_level = self.ability.advanced_level

	-- references
	self.damage = (self.ability:GetSpecialValueFor( "base_damage" )+(self.ability:GetSpecialValueFor( "bounus_damage_index" ))  *self:GetCaster():GetBaseDamageMax())
	self.heal = (self.ability:GetSpecialValueFor( "base_heal" )+(self.ability:GetSpecialValueFor( "bounus_heal_index" ))   *self:GetCaster():HDGetPrimaryStatValue())

	self.interval = self.ability:GetSpecialValueFor( "pulse_interval" )
	self.radius = self.ability:GetSpecialValueFor( "radius" ) 
	--LV5解锁极速升天
	if self.advanced_level>=5 then
		self.interval=self.interval*0.75
	end
	-- ability properties
	self.abilityDamageType = self.ability:GetAbilityDamageType()

	self.point = Vector( kv.x, kv.y, 0 )

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}

	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2( self.point, self.radius )
end

function modifier_Advanced_Solar_Guardian:OnRefresh( kv )	
end

function modifier_Advanced_Solar_Guardian:OnRemoved()
end

function modifier_Advanced_Solar_Guardian:OnDestroy()
	if not IsServer() then return end
	FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )

	-- stop effects
	local sound_cast1 = "Hero_Dawnbreaker.Solar_Guardian.Channel"
	local sound_cast2 = "Hero_Dawnbreaker.Solar_Guardian.Target"
	StopSoundOn( sound_cast1, self.parent )
	StopSoundOn( sound_cast2, self.parent )

	--LV20解锁圣所
	--新LV10天罚余波
	if self.advanced_level>=10 then
		self.parent:AddNewModifier(
		self.parent, -- player source
		self.ability, -- ability source
		"modifier_Advanced_Solar_Guardian_delay", -- modifier name
		{
			duration = 3.5,
			x = self.point.x,
			y = self.point.y,
		} -- kv
	)
	end


end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_Solar_Guardian:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Solar_Guardian:OnIntervalThink()
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
function modifier_Advanced_Solar_Guardian:PlayEffects1()
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

function modifier_Advanced_Solar_Guardian:PlayEffects2( point, radius )
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

function modifier_Advanced_Solar_Guardian:PlayEffects3( point, radius )
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

function modifier_Advanced_Solar_Guardian:PlayEffects4( target )
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
modifier_Advanced_Solar_Guardian_leap = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Solar_Guardian_leap:IsHidden()return true end
function modifier_Advanced_Solar_Guardian_leap:IsDebuff()return false end
function modifier_Advanced_Solar_Guardian_leap:IsPurgable()return false end

function modifier_Advanced_Solar_Guardian_leap:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Solar_Guardian_leap:OnCreated( kv )

	if not IsServer() then return end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.advanced_level = self.ability.advanced_level
	-- references
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.damage = self.ability:GetSpecialValueFor( "land_damage" )+(self.ability:GetSpecialValueFor("land_bounus_damage"))*self:GetCaster():GetBaseDamageMax()
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

function modifier_Advanced_Solar_Guardian_leap:OnRefresh( kv )
end

function modifier_Advanced_Solar_Guardian_leap:OnRemoved()
end

function modifier_Advanced_Solar_Guardian_leap:OnDestroy()
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

	local limit_end = self.parent:GetHealth()
	--LV10解锁原初之光+已作废
	if self.advanced_level>=10 then
		limit_end = limit_end*0.8
	end
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
--新高阶效果：击飞2秒追加
		enemy:AddNewModifier(
			self.parent, -- player source
			self.ability, -- ability source
			"modifier_Advanced_Solar_Guardian_sky", -- modifier name
			{ duration = self:GetAbility():GetSpecialValueFor("sky_duration")} -- kv
		)

		if enemy:GetHealth()<limit_end then
			TrueKill(self:GetCaster(),enemy,self:GetAbility())
		end
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
			"modifier_Advanced_Solar_Guardian_buff", -- modifier name
			{ duration = self:GetAbility():GetSpecialValueFor("damage_up_duration") *ModifierStatusGain} -- kv
		)
	end

	-- play effects
	self:PlayEffects2( self.point, self.radius )
	FindClearSpaceForUnit( self.parent, self.parent:GetAbsOrigin(), true )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Solar_Guardian_leap:OnIntervalThink()
	-- move position to target
	self.point.z = self.parent:GetOrigin().z
	self.parent:SetOrigin( self.point )	
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_Advanced_Solar_Guardian_leap:GetEffectName()
-- 	return "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_airtime_buff.vpcf"
-- end

-- function modifier_Advanced_Solar_Guardian_leap:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

function modifier_Advanced_Solar_Guardian_leap:PlayEffects1()
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

function modifier_Advanced_Solar_Guardian_leap:PlayEffects2( point, radius )
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





modifier_Advanced_Solar_Guardian_buff = advanced_modifier({})

function modifier_Advanced_Solar_Guardian_buff:IsDebuff()			return false end
function modifier_Advanced_Solar_Guardian_buff:IsHidden() 			return false end
function modifier_Advanced_Solar_Guardian_buff:IsPurgable() 		    return false end
function modifier_Advanced_Solar_Guardian_buff:IsPurgeException() 	return false end
function modifier_Advanced_Solar_Guardian_buff:RemoveOnDeath()       return false end
function modifier_Advanced_Solar_Guardian_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end





-- advanced_modifier
function modifier_Advanced_Solar_Guardian_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_Solar_Guardian_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("damage_up")
end









--LV20圣所
--新LV10天罚余波
modifier_Advanced_Solar_Guardian_delay = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Solar_Guardian_delay:IsHidden()return true end
function modifier_Advanced_Solar_Guardian_delay:IsDebuff()return false end
function modifier_Advanced_Solar_Guardian_delay:IsPurgable()return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Solar_Guardian_delay:OnCreated( kv )


	if not IsServer() then return end


	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	--获取技能等级
	self.advanced_level = self.ability.advanced_level

	-- references
	self.damage = 1.8*((self.ability:GetSpecialValueFor( "base_damage" ) +(self.ability:GetSpecialValueFor( "bounus_damage_index" ))  *self:GetCaster():GetBaseDamageMax()))
	self.heal = 1.8*((self.ability:GetSpecialValueFor( "base_heal" )+(self.ability:GetSpecialValueFor( "bounus_heal_index" ))   *self:GetCaster():HDGetPrimaryStatValue()))

	self.interval = 1.7
	self.radius = 1.8*self.ability:GetSpecialValueFor( "radius" ) 
	
	-- ability properties
	self.abilityDamageType = self.ability:GetAbilityDamageType()

	self.point = Vector( kv.x, kv.y, 0 )

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
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

function modifier_Advanced_Solar_Guardian_delay:OnRefresh( kv )	
end

function modifier_Advanced_Solar_Guardian_delay:OnRemoved()
end

function modifier_Advanced_Solar_Guardian_delay:OnDestroy()
	if not IsServer() then return end
	FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )

	-- stop effects
	local sound_cast1 = "Hero_Dawnbreaker.Solar_Guardian.Channel"
	local sound_cast2 = "Hero_Dawnbreaker.Solar_Guardian.Target"
	StopSoundOn( sound_cast1, self.parent )
	StopSoundOn( sound_cast2, self.parent )



end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Solar_Guardian_delay:OnIntervalThink()
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
		--新LV20天罚余波+
		if self.advanced_level>=20 then
			enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Advanced_Solar_Guardian_slow",{duration = 2})
		end
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
function modifier_Advanced_Solar_Guardian_delay:PlayEffects1()
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

function modifier_Advanced_Solar_Guardian_delay:PlayEffects2( point, radius )
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

function modifier_Advanced_Solar_Guardian_delay:PlayEffects3( point, radius )
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

function modifier_Advanced_Solar_Guardian_delay:PlayEffects4( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_healing_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end








modifier_Advanced_Solar_Guardian_unlock1 = class({})


function modifier_Advanced_Solar_Guardian_unlock1:IsHidden()	return true end
function modifier_Advanced_Solar_Guardian_unlock1:IsDebuff()	return false end
function modifier_Advanced_Solar_Guardian_unlock1:IsStunDebuff()	return false end
function modifier_Advanced_Solar_Guardian_unlock1:RemoveOnDeath()	return false end
function modifier_Advanced_Solar_Guardian_unlock1:DestroyOnExpire()	return false end
function modifier_Advanced_Solar_Guardian_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Solar_Guardian_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Solar_Guardian_unlock1:OnCreated()
	if IsServer() then
		self.time = GameRules:GetGameTime()
	end
end
function modifier_Advanced_Solar_Guardian_unlock1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Solar_Guardian_unlock1:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
		return
	end
	if not keys.target or keys.target:IsNull() then
		return
	end
	if GameRules:GetGameTime()>=self.time then
		
		if caster:HasAbility("Advanced_Luminosity") then
			ability:CreateSingleFinalPulse(keys.target:GetOrigin())
			self.time = GameRules:GetGameTime()+5
		else
			ability:CreateSinglePulse(keys.target:GetOrigin())
			self.time = GameRules:GetGameTime()+1
		end
		
	end
	
	
	
end







modifier_Advanced_Solar_Guardian_unlock2 = class({})


function modifier_Advanced_Solar_Guardian_unlock2:IsHidden()	return true end
function modifier_Advanced_Solar_Guardian_unlock2:IsDebuff()	return false end
function modifier_Advanced_Solar_Guardian_unlock2:IsStunDebuff()	return false end
function modifier_Advanced_Solar_Guardian_unlock2:RemoveOnDeath()	return false end
function modifier_Advanced_Solar_Guardian_unlock2:DestroyOnExpire()	return false end
function modifier_Advanced_Solar_Guardian_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Solar_Guardian_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Solar_Guardian_unlock2:OnCreated()
	if IsServer() then
		self.currentOrder = 0
		self.ability = self:GetAbility()
		self.parent = self:GetCaster()
		self.time = GameRules:GetGameTime()
		self.damageTable = {
			-- victim = target,
			attacker = self.parent,
			-- damage = self.damage,
			damage_type = self.ability:GetAbilityDamageType(),
			ability = self.ability, --Optional.
		}
	end
end
function modifier_Advanced_Solar_Guardian_unlock2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end
function modifier_Advanced_Solar_Guardian_unlock2:OnOrder( params )
	if not IsServer() then
		return
	end
	if not self:GetParent():IsRealHero() or self:GetParent():PassivesDisabled() then
		return
	end

	if params.unit~=self:GetParent() then return end

	if self.parent:IsRooted() then
		return  
	end
	if not self:GetAbility():GetAutoCastState() then
		return
	end
	-- local cooldown = ability:GetCooldownTimeRemaining()
	if self.time>=GameRules:GetGameTime() then
		return
	end
	-- right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self.currentOrder = self.currentOrder +1
		Timers:CreateTimer(0.3, function()
			self.currentOrder = self.currentOrder - 1
		end)
		if self.currentOrder>=2 then
		
			local units = FindUnitsInRadius(self.parent:GetTeamNumber(), params.new_pos, nil, 500, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
			if #units>=1 then
				self.time = GameRules:GetGameTime() + 5
				self:SpellToTarget( params.new_pos )
			end
		end
		
	end
end

function modifier_Advanced_Solar_Guardian_unlock2:SpellToTarget(pos)
	if IsServer() then



		self.radius = self.ability:GetSpecialValueFor( "radius" )
		local damage = self.ability:GetSpecialValueFor( "land_damage" )+(self.ability:GetSpecialValueFor("land_bounus_damage"))*self:GetCaster():GetBaseDamageMax()
		self.duration = self.ability:GetSpecialValueFor( "land_stun_duration" )
		self.damageTable.damage = damage
		local duration = 1
		local arc_height = 2500*duration
		self.point =pos

		local distance = (self.point - self.parent:GetOrigin()):Length2D()

		-- add arc
		local arc = self.parent:AddNewModifier(
			self.parent, -- player source
			self.ability, -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				target_x = self.point.x,
				target_y = self.point.y,
				distance = distance,
				duration = duration,
				height = arc_height,
				isStun = false,
				isForward = true,
			} -- kv
		)

	
		self:StartIntervalThink( duration )
	
		-- play effects
		self:PlayEffects1()
	end

end


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Solar_Guardian_unlock2:OnIntervalThink()
	if not self.parent:IsAlive() then
		return
	end

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

	-- ApplyDamage(damageTable)
	local limit_end = self.parent:GetMaxHealth()*0.2
	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- stun
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(
			self.parent, -- player source
			self.ability, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration * StatusResistance} -- kv
		)
		if enemy:GetHealth()<limit_end then
			enemy:Kill(self.ability, self.parent)
		end
	end



	local units = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
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
			"modifier_Advanced_Solar_Guardian_buff", -- modifier name
			{ duration = 10*ModifierStatusGain} -- kv
		)
	end

	-- play effects
	self:PlayEffects2( self.point, self.radius )
	FindClearSpaceForUnit( self.parent, self.point, true )

	self:StartIntervalThink(-1)

end



function modifier_Advanced_Solar_Guardian_unlock2:PlayEffects1()
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

function modifier_Advanced_Solar_Guardian_unlock2:PlayEffects2( point, radius )
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
end



modifier_Advanced_Solar_Guardian_unlock3= class({})

function modifier_Advanced_Solar_Guardian_unlock3:IsDebuff()			return false end
function modifier_Advanced_Solar_Guardian_unlock3:IsHidden() 			return true end
function modifier_Advanced_Solar_Guardian_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Solar_Guardian_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Solar_Guardian_unlock3:RemoveOnDeath() return false end

function modifier_Advanced_Solar_Guardian_unlock3:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		local caster = self:GetCaster()
		if caster:PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Solar_Guardian_unlock3_effect", {})

	end
end






modifier_Advanced_Solar_Guardian_unlock3_effect= class({})

function modifier_Advanced_Solar_Guardian_unlock3_effect:IsDebuff()			return false end
function modifier_Advanced_Solar_Guardian_unlock3_effect:IsHidden() 			return true end
function modifier_Advanced_Solar_Guardian_unlock3_effect:IsPurgable() 		return false end
function modifier_Advanced_Solar_Guardian_unlock3_effect:IsPurgeException() 	return false end
function modifier_Advanced_Solar_Guardian_unlock3_effect:OnCreated(keys)
	if IsServer() then
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/solar_guardian/unlock3/effect.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( effect_cast, 0,self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		-- buff particle
		self:AddParticle(
			effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)
		self:StartIntervalThink(9)
	end
end
function modifier_Advanced_Solar_Guardian_unlock3_effect:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	ability:CreateSinglePulse(self:GetParent():GetOrigin())
end

modifier_Advanced_Solar_Guardian_sky = advanced_modifier({})

function modifier_Advanced_Solar_Guardian_sky:IsDebuff()				return true end
function modifier_Advanced_Solar_Guardian_sky:IsHidden() 			return true end
function modifier_Advanced_Solar_Guardian_sky:IsPurgable() 			return false end
function modifier_Advanced_Solar_Guardian_sky:IsPurgeException() 	return true end
function modifier_Advanced_Solar_Guardian_sky:IsStunDebuff() 		return true end
function modifier_Advanced_Solar_Guardian_sky:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_Solar_Guardian_sky:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Advanced_Solar_Guardian_sky:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_Advanced_Solar_Guardian_sky:OnRefresh(keys) self:OnCreated(keys) end
function modifier_Advanced_Solar_Guardian_sky:IsMotionController() return true end
function modifier_Advanced_Solar_Guardian_sky:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Advanced_Solar_Guardian_sky:OnCreated(keys)
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self:GetParent():GetName() ~= "npc_dota_thinker" then
				self:SafeDestroy()
			end
		end
	end
end

function modifier_Advanced_Solar_Guardian_sky:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 200
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
end

function modifier_Advanced_Solar_Guardian_sky:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)

		self.pos = nil
		self.distance = nil 
	end
end


modifier_Advanced_Solar_Guardian_slow = advanced_modifier({})

function modifier_Advanced_Solar_Guardian_slow:IsDebuff()				return true end
function modifier_Advanced_Solar_Guardian_slow:IsHidden() 			return true end
function modifier_Advanced_Solar_Guardian_slow:IsPurgable() 			return false end
function modifier_Advanced_Solar_Guardian_slow:IsPurgeException() 	return false end

function modifier_Advanced_Solar_Guardian_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_Advanced_Solar_Guardian_slow:GetModifierMoveSpeedBonus_Percentage() return -50 end
