--特效优化 √
--------------------------------------------------------------------------------
Advanced_Macropyre = class({})
LinkLuaModifier( "modifier_Advanced_Macropyre", "skills/Advanced_Macropyre", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Macropyre_thinker", "skills/Advanced_Macropyre", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Macropyre_count", "skills/Advanced_Macropyre", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Macropyre_count_for_damage", "skills/Advanced_Macropyre", LUA_MODIFIER_MOTION_NONE )
require("internal/timers")

function Advanced_Macropyre:CheckKV(key)
	local table = {

	


		basic_damage = 2,
		intelligence_index = 0.02,




	}
	local value = table[key] or -1
	return value

end
function Advanced_Macropyre:UnlockFirstCore(key)
	return true
end
function Advanced_Macropyre:UnlockSecondCore(key)
	return true
end
function Advanced_Macropyre:UnlockThirdCore(key)
	return true
end
function Advanced_Macropyre:Precache( context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/midnight_pulse/effect2/effect.vpcf", context )
end
function Advanced_Macropyre:GetBehavior()
	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_POINT+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return DOTA_ABILITY_BEHAVIOR_POINT
	end
end
function Advanced_Macropyre:GetCastRange( vLocation, hTarget )
	return self:GetSpecialValueFor( "cast_range" )
end

function Advanced_Macropyre:MakeMacropyreAt(start,point, duration)
	if not IsServer() then return end	
	local caster = self:GetCaster()
	local dir = point - start
	dir.z = 0
	dir = dir:Normalized()		
	-- create thinker
	
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Macropyre_thinker", -- modifier name
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
			autoCast = self:GetAutoCastState(),	
		}, -- kv
		start,
		caster:GetTeamNumber(),
		false
	)	
	table.insert(self.all_pyres, thinker:FindModifierByName("modifier_Advanced_Macropyre_thinker"))
end




function Advanced_Macropyre:RefreshPyres(target)	
	if not IsServer() then return end
	if not target or target:IsNull() then
		return
	end
	local bonus_time = self:GetSpecialValueFor("bonus_time")
	--LV10解锁传火+
	if self.advanced_level>=10 then
		bonus_time = bonus_time +0.25
	end
	local target_modifier = target:FindModifierByName("modifier_Advanced_Macropyre_thinker")
	if target_modifier~=nil then
		for _,pyre in pairs(self.all_pyres) do
			if pyre==target_modifier then
				pyre:RefreshMacropyre(bonus_time)
				break
			end
			
		end
	end
	
end





--------------------------------------------------------------------------------
function Advanced_Macropyre:Spawn()
	if not self.all_pyres then self.all_pyres = {} end
	self.unlockCount = 0
end

-- Ability Start
function Advanced_Macropyre:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )
	
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	--LV15解锁增幅化
	if self.advanced_level>=15 then
		local SpellAmplification = caster:GetSpellAmplification(false)
		SpellAmplification = SpellAmplification/10
		SpellAmplification = SpellAmplification-SpellAmplification%1
		if SpellAmplification>0 then
			self.duration  = self.duration +SpellAmplification
		end
	end


	local range = self:GetCastRange( point, nil ) + caster:GetCastRangeBonus()
	range = math.max(range,100)
	local dir = (point - caster:GetAbsOrigin()):Normalized()
	dir.z = 0
	point = caster:GetAbsOrigin() + dir * range

	local startpoint = caster:GetOrigin() + dir * self:GetSpecialValueFor("start_distance")

	self.path_duration = self:GetSpecialValueFor( "duration" )
	if self.unlock3 then
		self.path_duration = 18
	end

	self:MakeMacropyreAt(startpoint, point, self.path_duration)
	caster:EmitSoundParams("Hero_Jakiro.Macropyre.Cast", 0, 0.55, 0)
end


function Advanced_Macropyre:Unlock1Effect(target)
	local caster = self:GetCaster()
	if self.unlockCount>=6 then
		return
	end
	if target:IsAlive() and caster:GetRandomEffect(20,INT_TYPE,1)  > RandomInt(1, 100) then
		local ability = caster:FindAbilityByName("Advanced_Liquid_Fire")
		if ability then
			self.unlockCount  = self.unlockCount + 1
			ability:AddDebuff(caster,target)
			Timers:CreateTimer(1, function()
				self.unlockCount = self.unlockCount - 1
			end)
		end
	end
	
end


function Advanced_Macropyre:Unlock2Effect(target)
	local caster = self:GetCaster()
	if self.unlockCount>=6 then
		return
	end
	if target:IsAlive() and caster:GetRandomEffect(30,INT_TYPE,1)  > RandomInt(1, 100) then
		local ability = caster:FindAbilityByName("Advanced_Liquid_Frost")
		if ability then
			self.unlockCount  = self.unlockCount + 1
			ability:AddDebuff(caster,target)
			Timers:CreateTimer(1, function()
				self.unlockCount = self.unlockCount - 1
			end)
		end
	end
	
end





--------------------------------------------------------------------------
--thinker
modifier_Advanced_Macropyre_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Macropyre_thinker:IsHidden()     return false  end
function modifier_Advanced_Macropyre_thinker:IsDebuff()     return false  end
function modifier_Advanced_Macropyre_thinker:IsStunDebuff() return false end
function modifier_Advanced_Macropyre_thinker:IsPurgable()   return false end
--------------------------------------------------------------------------------
-- Initializations


function modifier_Advanced_Macropyre_thinker:OnCreated( kv )	
	if not IsServer() then return end

	self.bonus_time_chance = 35
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	self.ability = self:GetAbility()
	if self.ability.unlock3 then
		self.unlock3 = true
		self.fire = 0
		self.ice = 0
	end
	self.advanced_level = self.ability.advanced_level
	-- references
	self.radius = self.ability:GetSpecialValueFor( "path_radius" )
	self.duration = self.ability:GetSpecialValueFor( "damage_duration" )	
	self.interval = self.ability:GetSpecialValueFor( "burn_interval" )
	self.range = self.ability:GetCastRange( self.parent:GetAbsOrigin(), nil ) + self.caster:GetCastRangeBonus()
	self.range = math.max(self.range,100)
	self.damage = self.ability:GetSpecialValueFor( "basic_damage" ) + self.caster:GetIntellect(false) * (self.ability:GetSpecialValueFor( "intelligence_index" ))
	self.target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	--LV20解锁篡火
	-- print(kv.autoCast)
	if kv.autoCast==1 then
		self.damage = self.damage*1.75
		self.target_team = DOTA_UNIT_TARGET_ALL
	end
	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()


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
function modifier_Advanced_Macropyre_thinker:OnRefresh( kv ) end
function modifier_Advanced_Macropyre_thinker:OnRemoved()     end
function modifier_Advanced_Macropyre_thinker:OnDestroy()
	if not IsServer() then return end
	if self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end
	StopSoundOn( "hero_jakiro.macropyre", self:GetParent() )
	local ability = self:GetAbility()
	-- if not ability or ability:IsNull() then
	-- 	self:SafeDestroy()
	-- 	return
	-- end
	-- local ability = self:GetAbility()
	-- local parnet = self:GetParent()
	if ability then
		for i,pyre in pairs(ability.all_pyres) do
			if pyre==self then
				ability.all_pyres[i]=nil
				break
			end
		end
	end

	-- StopSoundOn( "hero_jakiro.macropyre", self:GetParent() )
	UTIL_Remove( self:GetParent() )
end
function modifier_Advanced_Macropyre_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if self.unlock3 then
		if RandomInt(1, 2)==1 then
			self.fire = math.min(self.fire +1 ,20)
		else
			self.ice = math.min(self.ice + 1,20)
		end
		
		local enemies = FindUnitsInLine(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.startpoint,	-- point, center point
		self.endpoint,
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		-- self.abilityTargetTeam,	-- int, team filter
		self.target_team,
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags	-- int, flag filter
		)
		local count_buffs = self.caster:FindAllModifiersByName("modifier_Advanced_Macropyre_count")
		local bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
		if self.ability.advanced_level>=5 then
			bonus_damage = 5
		end
		for _,enemy in pairs(enemies) do
			-- add modifier
		
			enemy:AddNewModifier(
				self.caster, -- player source
				self:GetAbility(), -- ability source
				"modifier_Advanced_Macropyre", -- modifier name
				{
					duration = self.duration,
					interval = self.interval,
					damage = self.damage * (1+((#enemies + #count_buffs * 1.5) * bonus_damage *0.01))*(1+self.fire*0.1),
					damage_type = self.abilityDamageType,
					ice = self.ice,
				} -- kv
			)
			enemy:AddNewModifier(
				self:GetParent(), -- player source
				self:GetAbility(), -- ability source
				"modifier_Advanced_Macropyre_count_for_damage", -- modifier name
				{
					duration = self.duration,
				} -- kv
			)
		end
	else
		local enemies = FindUnitsInLine(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.startpoint,	-- point, center point
		self.endpoint,
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		-- self.abilityTargetTeam,	-- int, team filter
		self.target_team,
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags	-- int, flag filter
	)
	local count_buffs = self.caster:FindAllModifiersByName("modifier_Advanced_Macropyre_count")
	local bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	if self.ability.advanced_level>=5 then
		bonus_damage = 5
	end
	for _,enemy in pairs(enemies) do
		-- add modifier
	
		enemy:AddNewModifier(
			self.caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_Advanced_Macropyre", -- modifier name
			{
				duration = self.duration,
				interval = self.interval,
				damage = self.damage * (1+((#enemies + #count_buffs * 1.5) * bonus_damage *0.01)),
				damage_type = self.abilityDamageType,
			} -- kv
		)
		enemy:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_Advanced_Macropyre_count_for_damage", -- modifier name
			{
				duration = self.duration,
			} -- kv
		)
	end
	end
	

end
function modifier_Advanced_Macropyre_thinker:PlayEffects()
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
function modifier_Advanced_Macropyre_thinker:RefreshMacropyre(duration)
	if self.bonus_time_chance>0 then
		self.bonus_time_chance = self.bonus_time_chance - duration
		self:SetDuration(self:GetRemainingTime()+duration, false)
	end
end
------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_Advanced_Macropyre = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Macropyre:IsHidden()return false end
function modifier_Advanced_Macropyre:IsDebuff()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return false
	else
		return true
	end
end

function modifier_Advanced_Macropyre:IsStunDebuff()return false  end
function modifier_Advanced_Macropyre:IsPurgable()return false end

function modifier_Advanced_Macropyre:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Macropyre:OnCreated( kv )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not IsServer() then return end
	if kv.ice then
		self:SetStackCount(kv.ice)		
	end
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
	if ability.unlock1 then
		self.unlock1 = true
	end
	if ability.unlock2 then
		self.unlock2 = true
	end

	self:StartIntervalThink( interval )
end

function modifier_Advanced_Macropyre:OnRefresh( kv )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not IsServer() then return end
	local damage = kv.damage
	-- print(damage)
	local damage_type = kv.damage_type
	-- update damage
	self.damageTable.damage = damage
	self.damageTable.damage_type = damage_type
end
function modifier_Advanced_Macropyre:OnRemoved() end
function modifier_Advanced_Macropyre:OnDestroy() end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Macropyre:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	-- apply damage
	ApplyDamage( self.damageTable )
	if self.unlock1 then
		ability:Unlock1Effect(self:GetParent())
	end
	if self.unlock2 then
		ability:Unlock2Effect(self:GetParent())
	end

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_Macropyre:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_Advanced_Macropyre:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Advanced_Macropyre:DeclareFunctions() 
	if self:GetAbility():GetUnlock(3)==3 then
		return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
	end

end
function modifier_Advanced_Macropyre:GetModifierMagicalResistanceBonus() return -self:GetStackCount()*5 end
--------------------------------------
modifier_Advanced_Macropyre_count = class({})

function modifier_Advanced_Macropyre_count:IsDebuff()				return false end
function modifier_Advanced_Macropyre_count:IsHidden() 			    return true end
function modifier_Advanced_Macropyre_count:IsPurgable() 			return false end
function modifier_Advanced_Macropyre_count:IsPurgeException() 	    return false end
function modifier_Advanced_Macropyre_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_Advanced_Macropyre_count_for_damage = class({})
function modifier_Advanced_Macropyre_count_for_damage:IsHidden() 			    return true end
function modifier_Advanced_Macropyre_count_for_damage:IsStunDebuff()return false  end
function modifier_Advanced_Macropyre_count_for_damage:IsPurgable()  return false end
function modifier_Advanced_Macropyre_count_for_damage:IsPurgeException() 	    return false end
function modifier_Advanced_Macropyre_count_for_damage:DeclareFunctions()return {MODIFIER_EVENT_ON_DEATH,} end
function modifier_Advanced_Macropyre_count_for_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
--传火
function modifier_Advanced_Macropyre_count_for_damage:OnDeath( kv )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if kv.unit ~= self:GetParent()  or kv.unit:GetHealth() ~= 0 then return end
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then
		return
	end
	-- local macropyre = self:GetCaster():FindAbilityByName("Advanced_Macropyre")
	self:GetAbility():RefreshPyres(caster)

	caster:AddNewModifier(
		self:GetAbility():GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_Advanced_Macropyre_count", -- modifier name
		{
			-- duration = self:GetAbility():GetSpecialValueFor("bonus_damage_count_duration"),
			duration = self:GetAbility():GetSpecialValueFor("bonus_damage_count_duration"),
		} -- kv
	)

end