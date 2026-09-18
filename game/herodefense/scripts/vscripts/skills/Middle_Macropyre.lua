
--------------------------------------------------------------------------------
Middle_Macropyre = class({})
LinkLuaModifier( "modifier_Middle_Macropyre", "skills/Middle_Macropyre", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Macropyre_thinker", "skills/Middle_Macropyre", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Macropyre_count", "skills/Middle_Macropyre", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Macropyre_count_for_damage", "skills/Middle_Macropyre", LUA_MODIFIER_MOTION_NONE )

function Middle_Macropyre:GetCastRange( vLocation, hTarget )
	return self:GetSpecialValueFor( "cast_range" ) + self:GetCaster():GetCastRangeBonus()
end

function Middle_Macropyre:MakeMacropyreAt(start,point, duration)
	if not IsServer() then return end	
	local caster = self:GetCaster()
	local dir = point - start
	dir.z = 0
	dir = dir:Normalized()		
	-- create thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_Macropyre_thinker", -- modifier name
		{
			duration = duration,
			-- x = dir.x,
			-- y = dir.y,
			fromx = start.x,
			fromy = start.y,
			fromz = start.z,
			tox = point.x,
			toy = point.y,
			toz = point.z,			
		}, -- kv
		start,
		caster:GetTeamNumber(),
		false
	)	
	table.insert(self.all_pyres, thinker:FindModifierByName("modifier_Middle_Macropyre_thinker"))
end







--------------------------------------------------------------------------------
function Middle_Macropyre:Spawn()
	if not self.all_pyres then self.all_pyres = {} end
end

-- Ability Start
function Middle_Macropyre:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )	
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()


	local range = self:GetCastRange( point, nil ) + caster:GetCastRangeBonus()
	range = math.max(range,100)
	local dir = (point - caster:GetAbsOrigin()):Normalized()
	dir.z = 0
	point = caster:GetAbsOrigin() + dir * range

	local startpoint = caster:GetOrigin() + dir * self:GetSpecialValueFor("start_distance")

	self.path_duration = self:GetSpecialValueFor( "duration" )

	self:MakeMacropyreAt(startpoint, point, self.path_duration)

	-- if caster:HasAbility("pathfinder_jakiro_macropyre_burning_man") then
	-- 	local midpoint = caster:GetAbsOrigin() + (point - caster:GetAbsOrigin()):Normalized() * ((point - caster:GetAbsOrigin()):Length2D() / 2)
	-- 	local thirdpoint = caster:GetAbsOrigin() + (point - caster:GetAbsOrigin()):Normalized() * ((point - caster:GetAbsOrigin()):Length2D() * 0.6)
	-- 	local lastpoint = caster:GetAbsOrigin() + (point - caster:GetAbsOrigin()):Normalized() * ((point - caster:GetAbsOrigin()):Length2D() * 0.9)
	-- 	local left = QAngle(0, 90, 0)
	-- 	local right = QAngle(0, -90, 0)
	-- 	local left_hand = RotatePosition(thirdpoint, left, point)
	-- 	local right_hand = RotatePosition(thirdpoint, right, point)
	-- 	self:MakeMacropyreAt(left_hand, right_hand, self.path_duration)
	-- 	local from = lastpoint
	-- 	for i = 1,4 do 
	-- 		local qangle = QAngle(0, 90, 0)		
	-- 		local left = RotatePosition(point, qangle, from)
	-- 		self:MakeMacropyreAt(left, from, self.path_duration)
	-- 		from = left
	-- 	end
	-- 	left = QAngle(0, 130, 0)
	-- 	right = QAngle(0, -155, 0)
	-- 	local left_leg = RotatePosition(caster:GetAbsOrigin(), left, thirdpoint)
	-- 	local right_leg = RotatePosition(caster:GetAbsOrigin(), right, thirdpoint)

	-- 	self:MakeMacropyreAt(caster:GetAbsOrigin(), left_leg, self.path_duration)
	-- 	self:MakeMacropyreAt(caster:GetAbsOrigin(), right_leg, self.path_duration)
	-- end
	-- play effects
	caster:EmitSoundParams("Hero_Jakiro.Macropyre.Cast", 0, 0.55, 0)
end
--------------------------------------------------------------------------
--thinker
modifier_Middle_Macropyre_thinker = class({})
require("internal/timers")
--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Macropyre_thinker:IsHidden()     return false  end
function modifier_Middle_Macropyre_thinker:IsDebuff()     return false  end
function modifier_Middle_Macropyre_thinker:IsStunDebuff() return false end
function modifier_Middle_Macropyre_thinker:IsPurgable()   return false end
--------------------------------------------------------------------------------
-- Initializations


function modifier_Middle_Macropyre_thinker:OnCreated( kv )	
	if not IsServer() then return end

	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	self.ability = self:GetAbility()
	-- references
	self.radius = self.ability:GetSpecialValueFor( "path_radius" )
	self.duration = self.ability:GetSpecialValueFor( "damage_duration" )	
	self.interval = self.ability:GetSpecialValueFor( "burn_interval" )
	self.range = self.ability:GetCastRange( self.parent:GetAbsOrigin(), nil ) + self.caster:GetCastRangeBonus()
	self.range = math.max(self.range,100)
	self.damage = self.ability:GetSpecialValueFor( "basic_damage" ) + self.caster:GetIntellect(false) * self.ability:GetSpecialValueFor( "intelligence_index" )
	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	-- calculate stuff
	-- local start_range = 234
	-- self.direction = Vector( kv.x, kv.y, 0 )
	-- self.startpoint = self.parent:GetOrigin() + self.direction * start_range
	-- self.endpoint = self.startpoint + self.direction * self.range

	self.startpoint = Vector(kv.fromx, kv.fromy, kv.fromz)
	self.endpoint = Vector(kv.tox, kv.toy, kv.toz)
	
	local dir = (self.endpoint - self.startpoint)	
	dir.z = 0
	self.direction = dir:Normalized()

	-- destroy trees along line
	local step = 0
	while step < self.range do
		local loc = self.startpoint + self.direction * step
		GridNav:DestroyTreesAroundPoint( loc, self.radius, true )
		step = step + self.radius
	end
	-- Start interval
	self:StartIntervalThink( self.interval )
	-- play effects
	self:PlayEffects()
end
function modifier_Middle_Macropyre_thinker:OnRefresh( kv ) end
function modifier_Middle_Macropyre_thinker:OnRemoved()     end
function modifier_Middle_Macropyre_thinker:OnDestroy()
	if not IsServer() then return end
	if self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end
	StopSoundOn( "hero_jakiro.macropyre", self:GetParent() )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	for i,pyre in pairs(self:GetAbility().all_pyres) do
		self:GetAbility().all_pyres[i] = nil
	end
	-- StopSoundOn( "hero_jakiro.macropyre", self:GetParent() )
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_Macropyre_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	-- if self.caster:HasAbility("pathfinder_jakiro_macropyre_heal") then
	-- 	target_team = DOTA_UNIT_TARGET_TEAM_BOTH
	-- end
	local enemies = FindUnitsInLine(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.startpoint,	-- point, center point
		self.endpoint,
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		-- self.abilityTargetTeam,	-- int, team filter
		target_team,
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags	-- int, flag filter
	)
	local count_buffs = self.caster:FindAllModifiersByName("modifier_Middle_Macropyre_count")
	for _,enemy in pairs(enemies) do
		-- add modifier
	
		enemy:AddNewModifier(
			self.caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_Middle_Macropyre", -- modifier name
			{
				duration = self.duration,
				interval = self.interval,
				damage = self.damage * (1+((#enemies + #count_buffs * 1.5) * self.ability:GetSpecialValueFor("bonus_damage") *0.01)),
				damage_type = self.abilityDamageType,
			} -- kv
		)
		enemy:AddNewModifier(
			self.caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_Middle_Macropyre_count_for_damage", -- modifier name
			{
				duration = self.duration,
			} -- kv
		)
	end

	--复燃
	-- if IsServer() and self.caster:HasAbility("pathfinder_jakiro_macropyre_eternal") then
	-- 	local allies = FindUnitsInLine(
	-- 		self.caster:GetTeamNumber(),	-- int, your team number
	-- 		self.startpoint,	-- point, center point
	-- 		self.endpoint,
	-- 		nil,	-- handle, cacheUnit. (not known)
	-- 		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	-- 		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
	-- 		DOTA_UNIT_TARGET_HERO,
	-- 		0
	-- 	)	
	-- 	for _,ally in pairs(allies) do
	-- 		if ally == self.caster then
	-- 			self:GetAbility():RefreshPyres()
	-- 			break
	-- 		end
	-- 	end
	-- end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_Macropyre_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/items/jakiro/jakiro_ti10_immortal/jakiro_ti10_macropyre.vpcf"
	local sound_cast = "hero_jakiro.macropyre"
	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self.parent )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self.startpoint )
	ParticleManager:SetParticleControl( self.effect_cast, 1, self.endpoint )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( 999, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	self.parent:EmitSoundParams(sound_cast, 0, 0.4, 0)
	-- EmitSoundOn( sound_cast, self.parent )
end

------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_Middle_Macropyre = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Macropyre:IsHidden()return false end
function modifier_Middle_Macropyre:IsDebuff()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return false
	else
		return true
	end
end

function modifier_Middle_Macropyre:IsStunDebuff()return false  end
function modifier_Middle_Macropyre:IsPurgable()return false end

function modifier_Middle_Macropyre:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- --传火
-- function modifier_Middle_Macropyre:OnDeath( kv )
-- 	if kv.unit ~= self:GetParent()  or kv.unit:GetHealth() ~= 0 then return end
-- 	-- local macropyre = self:GetCaster():FindAbilityByName("Middle_Macropyre")
-- 	self:GetAbility():RefreshPyres()


-- 	self:GetCaster():AddNewModifier(
-- 		self:GetCaster(), -- player source
-- 		self:GetAbility(), -- ability source
-- 		"modifier_Middle_Macropyre_count", -- modifier name
-- 		{
-- 			-- duration = self:GetAbility():GetSpecialValueFor("bonus_damage_count_duration"),
-- 			duration = self:GetAbility():GetSpecialValueFor("bonus_damage_count_duration"),
-- 		} -- kv
-- 	)
-- 	-- if self:GetCaster():HasAbility("pathfinder_jakiro_macropyre_cooldown_reduction") and not macropyre:IsCooldownReady() then
-- 	-- 	local full_cooldown = macropyre:GetCooldown(self:GetAbility():GetLevel())
-- 	-- 	local reduce_amount = full_cooldown / 100 * self:GetCaster():FindAbilityByName("pathfinder_jakiro_macropyre_cooldown_reduction"):GetLevelSpecialValueFor("cd_percent",1)
-- 	-- 	local current_cooldown = macropyre:GetCooldownTimeRemaining()
-- 	-- 	local new_cooldown = current_cooldown - reduce_amount
-- 	-- 	macropyre:EndCooldown()
-- 	-- 	macropyre:StartCooldown(math.max(new_cooldown,0))
-- 	-- end
-- end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Macropyre:OnCreated( kv )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not IsServer() then return end
	local interval = kv.interval
	local damage = kv.damage
	local damage_type = kv.damage_type
	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = damage_type,
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	self:StartIntervalThink( interval )
end

function modifier_Middle_Macropyre:OnRefresh( kv )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not IsServer() then return end
	local damage = kv.damage
	local damage_type = kv.damage_type
	-- update damage
	self.damageTable.damage = damage
	self.damageTable.damage_type = damage_type
end
function modifier_Middle_Macropyre:OnRemoved() end
function modifier_Middle_Macropyre:OnDestroy() end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_Macropyre:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	-- apply damage
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		ApplyDamage( self.damageTable )
	end
	--涅槃天赋
	-- elseif self:GetParent():IsHero() then
	-- 	if self:GetCaster():HasAbility("pathfinder_jakiro_macropyre_heal") then
	-- 		local heal_amount = self.damageTable.damage / 100 * self:GetCaster():FindAbilityByName("pathfinder_jakiro_macropyre_heal"):GetLevelSpecialValueFor("heal_percent", 1)
	-- 		self:GetParent():Heal(heal_amount, self:GetAbility())
	-- 		self.healfx = ParticleManager:CreateParticle( "particles/econ/items/undying/fall20_undying_head/fall20_undying_soul_rip_heal_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- 		ParticleManager:SetParticleControl(self.healfx, 0, self:GetParent():GetAbsOrigin())		
	-- 		ParticleManager:ReleaseParticleIndex( self.healfx )				
	-- 	end
	-- end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_Macropyre:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_Middle_Macropyre:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------
modifier_Middle_Macropyre_count = class({})

function modifier_Middle_Macropyre_count:IsDebuff()				return false end
function modifier_Middle_Macropyre_count:IsHidden() 			    return true end
function modifier_Middle_Macropyre_count:IsPurgable() 			return false end
function modifier_Middle_Macropyre_count:IsPurgeException() 	    return false end
function modifier_Middle_Macropyre_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_Middle_Macropyre_count_for_damage = class({})
function modifier_Middle_Macropyre_count_for_damage:IsHidden() 			    return true end
function modifier_Middle_Macropyre_count_for_damage:IsStunDebuff()return false  end
function modifier_Middle_Macropyre_count_for_damage:IsPurgable()  return false end
function modifier_Middle_Macropyre_count_for_damage:IsPurgeException() 	    return false end
function modifier_Middle_Macropyre_count_for_damage:DeclareFunctions()return {MODIFIER_EVENT_ON_DEATH,} end

function modifier_Middle_Macropyre_count_for_damage:OnDeath( kv )
	if kv.unit ~= self:GetParent()  or kv.unit:GetHealth() ~= 0 then return end
	-- local macropyre = self:GetCaster():FindAbilityByName("Middle_Macropyre")
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_Middle_Macropyre_count", -- modifier name
		{
			-- duration = self:GetAbility():GetSpecialValueFor("bonus_damage_count_duration"),
			duration = self:GetAbility():GetSpecialValueFor("bonus_damage_count_duration"),
		} -- kv
	)
	-- if self:GetCaster():HasAbility("pathfinder_jakiro_macropyre_cooldown_reduction") and not macropyre:IsCooldownReady() then
	-- 	local full_cooldown = macropyre:GetCooldown(self:GetAbility():GetLevel())
	-- 	local reduce_amount = full_cooldown / 100 * self:GetCaster():FindAbilityByName("pathfinder_jakiro_macropyre_cooldown_reduction"):GetLevelSpecialValueFor("cd_percent",1)
	-- 	local current_cooldown = macropyre:GetCooldownTimeRemaining()
	-- 	local new_cooldown = current_cooldown - reduce_amount
	-- 	macropyre:EndCooldown()
	-- 	macropyre:StartCooldown(math.max(new_cooldown,0))
	-- end
end