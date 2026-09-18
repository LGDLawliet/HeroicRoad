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
Primary_Celestial_Hammer = class({})
LinkLuaModifier( "modifier_Primary_Celestial_Hammer", "skills/Primary_Celestial_Hammer", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_Primary_Celestial_Hammer_nohammer", "skills/Primary_Celestial_Hammer", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_Primary_Celestial_Hammer_nohammer_buff", "skills/Primary_Celestial_Hammer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Celestial_Hammer_thinker", "skills/Primary_Celestial_Hammer", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_Primary_Celestial_Hammer_thinker2", "skills/Primary_Celestial_Hammer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Celestial_Hammer_trail", "skills/Primary_Celestial_Hammer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Celestial_Hammer_debuff", "skills/Primary_Celestial_Hammer", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier("modifier_frost_boss_pull", "creeps_spell/frost_boss", LUA_MODIFIER_MOTION_HORIZONTAL )  --拉扯 
--------------------------------------------------------------------------------
-- Init Abilities


function Primary_Celestial_Hammer:Spawn()
	if not IsServer() then return end
	self.thinkers = {}
end

-- function Primary_Celestial_Hammer:OnUpgrade()
-- 	local sub = self:GetCaster():FindAbilityByName( "Primary_Converge" )
-- 	if not sub then
-- 		sub = self:GetCaster():AddAbility( "Primary_Converge" )
-- 	end

-- 	sub:SetLevel( self:GetLevel() )
-- end

--------------------------------------------------------------------------------
-- Ability Cast Filter
--既然是扔锤子技能 扔出去了总不能扔第二次
function Primary_Celestial_Hammer:CastFilterResultLocation( vLoc )
	-- check nohammer
	if self:GetCaster():HasModifier( "modifier_Primary_Celestial_Hammer_nohammer" ) then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function Primary_Celestial_Hammer:GetCustomCastErrorLocation( vLoc )
	-- check nohammer
	if self:GetCaster():HasModifier( "modifier_Primary_Celestial_Hammer_nohammer" ) then
		-- return "#dota_hud_error_nohammer"
		return "dota_hud_no_hammer"
	end
	return ""
end

function Primary_Celestial_Hammer:GetCastRange(vLocation, hTarget)
	if IsServer() then return 900000 end
	return self:GetSpecialValueFor( "range" )
end

--------------------------------------------------------------------------------
-- Ability Start
function Primary_Celestial_Hammer:OnSpellStart()
	-- self.pull_list = {}
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local name = ""
	local radius = self:GetSpecialValueFor( "projectile_radius" )
	local speed = self:GetSpecialValueFor( "projectile_speed" )
	local distance = self:GetSpecialValueFor( "range" )

	-- get direction
	local direction = point-caster:GetOrigin()
	local len = direction:Length2D()
	direction.z = 0
	direction = direction:Normalized()

	distance = math.min( distance, len )

	-- create thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Celestial_Hammer_thinker", -- modifier name
		{}, -- kv
		caster:GetOrigin(),
		self:GetCaster():GetTeamNumber(),
		false
	)

	-- create linear projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
	
		-- bDeleteOnHit = true,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	
		EffectName = name,
		fDistance = distance,
		fStartRadius = radius,
		fEndRadius = radius,
		vVelocity = direction * speed,
	}
	local data = {
		cast = 1,    --1是发出2是收回 3跟4是圣光回响
		targets = {},
		thinker = thinker,
	}
	local id = ProjectileManager:CreateLinearProjectile( info )
	thinker.id = id  --将创建的投掷物ID赋给thinker
	self.projectiles[id] = data  --同时将一个包含thinker的表也赋给这个等下
	-- self.pull_list[id] = {}      --拉扯表
	table.insert( self.thinkers, thinker )	--将thinker插入马甲表里

	-- swap with sub-ability
	--切换激活技能
	local ability = caster:FindAbilityByName( "Primary_Converge" )
	if ability then
		ability:SetActivated( true )

		caster:SwapAbilities(
			"Primary_Celestial_Hammer",
			"Primary_Converge",
			false,
			true
		)

		ability:StartCooldown( ability:GetCooldown( -1 ) )
	end

	-- set no hammer
	--当然你得给自己加个没锤子的buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Celestial_Hammer_nohammer", -- modifier name
		{} -- kv
	)


	-- play effects
	data.effect = self:PlayEffects1( caster:GetOrigin(), distance, direction * speed )

end



--------------------------------------------------------------------------------
-- Projectile
Primary_Celestial_Hammer.projectiles = {}
Primary_Celestial_Hammer.thinkers = {}
function Primary_Celestial_Hammer:OnProjectileThinkHandle( handle )  --handle就是投掷物ID 在上面设置了self.projectiles[id]== data 所以我们可以借此获取到thinker
	local data = self.projectiles[handle]
	if data.thinker:IsNull() then return end

	if data.cast==1 or data.cast==3 then
		local location = ProjectileManager:GetLinearProjectileLocation( handle )
		-- move thinker along projectile
		data.thinker:SetOrigin( location )  --更新thinker的位置

		-- destroy trees
		-- local radius = self:GetSpecialValueFor( "projectile_radius" )
		-- GridNav:DestroyTreesAroundPoint( location, radius, false ) --不需要摧毁树木

	elseif data.cast==2 or data.cast == 4 then
		local location = ProjectileManager:GetTrackingProjectileLocation( handle )
		local radius = self:GetSpecialValueFor( "projectile_radius" )

		-- move thinker along projectile
		data.thinker:SetOrigin( location )

		-- find enemies not yet hit
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			location,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _,enemy in pairs(enemies) do
			if not data.targets[enemy] then
				data.targets[enemy] = true   --第一次见到这种写法 学到了

				-- hammer hit
				self:HammerHit( enemy, location )									
			end
		end

		-- destroy trees
		-- local radius = self:GetSpecialValueFor( "projectile_radius" )
		-- GridNav:DestroyTreesAroundPoint( location, radius, false ) --并不需要摧毁树木
	end
end

function Primary_Celestial_Hammer:OnProjectileHitHandle( target, location, handle )
	local data = self.projectiles[handle]
	if not handle then return end

	if data.cast==1 then
		if target then
			self:HammerHit( target, location )
			-- if self:GetCaster():HasAbility("Primary_Celestial_Hammer_skewer") then
			-- 	target:AddNewModifier(self:GetCaster(), self, "modifier_frost_boss_pull", {proj = handle})	
			-- 	table.insert(self.pull_list[handle], target)	
			-- end
			return false
		end

		-- if self:GetCaster():HasAbility("Primary_Celestial_Hammer_skewer") then			
		-- 	for _,pulled in pairs(self.pull_list[handle]) do
		-- 		pulled:RemoveModifierByName("modifier_frost_boss_pull")				
		-- 	end
		-- 	self.pull_list[handle] = {}
		-- end

		-- set thinker origin
		local loc = GetGroundPosition( location, self:GetCaster() )
		data.thinker:SetOrigin( loc )

		-- begin delay
		local mod = data.thinker:FindModifierByName( "modifier_Primary_Celestial_Hammer_thinker" )
		mod:Delay()

		-- stop effect
		self:StopEffects( data.effect )

		-- destroy handle
		self.projectiles[handle] = nil  --因为stopeffects已经销毁了特效 
	
	elseif data.cast==2 then
		local caster = self:GetCaster()

		-- destroy thinker
		for i,thinker in pairs(self.thinkers) do
			if thinker == data.thinker then
				table.remove( self.thinkers, i )
				break
			end
		end
		local mod = data.thinker:FindModifierByName( "modifier_Primary_Celestial_Hammer_thinker" )
		mod:SafeDestroy()

		-- reset sub-ability
		local ability = caster:FindAbilityByName( "Primary_Converge" )
		if ability then
			caster:SwapAbilities(
				"Primary_Celestial_Hammer",
				"Primary_Converge",
				true,
				false
			)
		end

		-- remove nohammer
		local nohammer = caster:FindModifierByName( "modifier_Primary_Celestial_Hammer_nohammer" )
		if nohammer then
			nohammer:Decrement()
		end

		-- destroy converge modifier
		local converge = caster:FindModifierByName( "modifier_Primary_Celestial_Hammer" )
		if converge then
			converge:SafeDestroy()
			self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
		end

		-- destroy handle
		self.projectiles[handle] = nil

		-- play effects
		self:PlayEffects3()
	end
end

--------------------------------------------------------------------------------
-- Helper
function Primary_Celestial_Hammer:HammerHit( target, location )
	local damage = self:GetSpecialValueFor( "hammer_damage" ) * self:GetCaster():GetBaseDamageMax()

	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}
	ApplyDamage(damageTable)

	--创造幻象 不需要
	-- if self:GetCaster():HasAbility("Primary_Celestial_Hammer_illusion") and RollPseudoRandomPercentage(self:GetCaster():FindAbilityByName("Primary_Celestial_Hammer_illusion"):GetLevelSpecialValueFor("chance",1),DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetCaster())  then
	-- 	local illusion_damage_pct = self:GetCaster():FindAbilityByName("Primary_Celestial_Hammer_illusion"):GetLevelSpecialValueFor("illusion_damage_pct",1)				
	-- 	local illusion_incoming_dmg = self:GetCaster():FindAbilityByName("Primary_Celestial_Hammer_illusion"):GetLevelSpecialValueFor("illusion_incoming_dmg",1)	
		
	-- 	local modifierKeys = {}
	-- 	modifierKeys.outgoing_damage = illusion_damage_pct - 100
	-- 	modifierKeys.incoming_damage = illusion_incoming_dmg
	-- 	modifierKeys.duration = 9
		
	-- 	local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), modifierKeys, 1, 70, true, true)
	-- 	illusion[1]:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
	-- 	illusion[1]:AddNewModifier(self:GetCaster(), self, "modifier_phased", {})
	-- 	illusion[1]:AddNewModifier(self:GetCaster(), self, "modifier_no_healthbar", {})
	-- 	illusion[1]:SetControllableByPlayer(-1, true)			
	-- 	FindClearSpaceForUnit(illusion[1], location, false)
	-- end

	-- play effects
	self:PlayEffects2( target )
end

function Primary_Celestial_Hammer:Converge()
	local caster = self:GetCaster()

	local target
	for i,thinker in ipairs(self.thinkers) do
		target = thinker
		break
	end
	if not target then return end

	-- find projectile if exist
	if self.projectiles[target.id] then
		-- stop effect
		self:StopEffects( self.projectiles[target.id].effect )

		-- destroy projectile
		self.projectiles[target.id] = nil
		ProjectileManager:DestroyLinearProjectile( target.id )
	end

	-- set thinker to return
	local mod = target:FindModifierByName( "modifier_Primary_Celestial_Hammer_thinker" )
	mod:Return()


	-- add travel modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Celestial_Hammer", -- modifier name
		{
			target = target:entindex(),
		} -- kv
	)

	-- play effects
	local sound_cast = "Hero_Dawnbreaker.Converge.Cast"
	EmitSoundOn( sound_cast, caster )
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)

	converge_voiceline = {
			"dawnbreaker_valora_call_01",
			"dawnbreaker_valora_call_02",
			"dawnbreaker_valora_call_03",
			"dawnbreaker_valora_call_04",
			"dawnbreaker_valora_call_05",
			"dawnbreaker_valora_call_06",
			"dawnbreaker_valora_call_06_02",
			"dawnbreaker_valora_call_07",
			"dawnbreaker_valora_call_07_02",
			"dawnbreaker_valora_call_08",
			"dawnbreaker_valora_call_18",			
	}
	self:GetCaster():EmitSound(converge_voiceline[RandomInt(1, #converge_voiceline)])			
end

--------------------------------------------------------------------------------
-- Effects
function Primary_Celestial_Hammer:PlayEffects1( start, distance, velocity )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_celestial_hammer_projectile.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Celestial_Hammer.Cast"

	-- Get Data
	local min_rate = 1
	local duration = distance/velocity:Length2D()
	local rotation = 0.5

	local rate = rotation/duration
	while rate<min_rate do
		rotation = rotation + 1
		rate = rotation/duration
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, start )
	ParticleManager:SetParticleControl( effect_cast, 1, velocity )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( rate, 0, 0 ) )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )

	return effect_cast
end

function Primary_Celestial_Hammer:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_celestial_hammer_aoe_impact.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Celestial_Hammer.Damage"

	-- Get Data
	local radius = self:GetSpecialValueFor( "projectile_radius" )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

function Primary_Celestial_Hammer:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_converge.vpcf"

	-- Get Data
	local radius = self:GetSpecialValueFor( "projectile_radius" )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		hTarget,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function Primary_Celestial_Hammer:StopEffects( effect )
	ParticleManager:DestroyParticle( effect, false )
	ParticleManager:ReleaseParticleIndex( effect )
end

--------------------------------------------------------------------------------
-- Sub-ability: Converge
Primary_Converge = class({})

function Primary_Converge:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	local main = caster:FindAbilityByName( "Primary_Celestial_Hammer" )
	if main then
		main:Converge()
	end

	-- set as inactive
	self:SetActivated( false )
end

--修饰器一栏
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
modifier_Primary_Celestial_Hammer_nohammer = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Celestial_Hammer_nohammer:IsHidden()return true end
function modifier_Primary_Celestial_Hammer_nohammer:IsDebuff()return false end
function modifier_Primary_Celestial_Hammer_nohammer:IsPurgable()return false end
function modifier_Primary_Celestial_Hammer_nohammer:GetActivityTranslationModifiers()return "no_hammer" end  --锤子丢出去了就没锤子了

function modifier_Primary_Celestial_Hammer_nohammer:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_Primary_Celestial_Hammer_nohammer:OnCreated( kv )
	if not IsServer() then return end
	self:IncrementStackCount()


end

function modifier_Primary_Celestial_Hammer_nohammer:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Primary_Celestial_Hammer_nohammer:OnRemoved()
end

function modifier_Primary_Celestial_Hammer_nohammer:Decrement()
	self:DecrementStackCount()
	if self:GetStackCount()<1 then
		self:SafeDestroy()
	end
end


modifier_Primary_Celestial_Hammer_thinker = class({})



require("internal/timers")

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Celestial_Hammer_thinker:IsHidden()return true end
function modifier_Primary_Celestial_Hammer_thinker:IsDebuff()return false end
function modifier_Primary_Celestial_Hammer_thinker:IsPurgable()return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Celestial_Hammer_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.name = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_celestial_hammer_return.vpcf"
	self.speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	self.delay = self:GetAbility():GetSpecialValueFor( "pause_duration" )
	self.duration = self:GetAbility():GetSpecialValueFor( "flare_debuff_duration" )
	self.vision = 200
	self.interval = 0.1

	-- NOTE: arbitrary decision to mimic original spell
	self.max_return = 1.5

	if not IsServer() then return end

	-- play effects
	local sound_loop = "Hero_Dawnbreaker.Celestial_Hammer.Projectile"
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_Primary_Celestial_Hammer_thinker:OnRefresh( kv )
end

function modifier_Primary_Celestial_Hammer_thinker:OnRemoved()
end

function modifier_Primary_Celestial_Hammer_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_Celestial_Hammer_thinker:OnIntervalThink()
	if not self.converge then
		self:Return()
		return
	end

	-- create trail
	local thinker = CreateModifierThinker(
		self.caster, -- player source
		self.ability, -- ability source
		"modifier_Primary_Celestial_Hammer_trail", -- modifier name
		{
			duration = self.duration,
			x = self.prev_pos.x,
			y = self.prev_pos.y,
		}, -- kv
		self.parent:GetOrigin(),
		self.caster:GetTeamNumber(),
		false
	)
	self.prev_pos = self.parent:GetOrigin()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_Primary_Celestial_Hammer_thinker:Delay()
	self:PlayEffects1()
	self:StartIntervalThink( self.delay )	

	-- if self:GetCaster():HasAbility("Primary_Celestial_Hammer_skewer") and not self:GetCaster():PassivesDisabled() then
	-- 	local sound = "Hero_Leshrac.Split_Earth"
	-- 	EmitSoundOn( sound, self:GetParent() )

	-- 	local attack_stun = self:GetCaster():FindAbilityByName("Primary_Celestial_Hammer_skewer"):GetLevelSpecialValueFor("attack_stun",1)
	-- 	local radius = self:GetCaster():FindAbilityByName("Primary_Celestial_Hammer_skewer"):GetLevelSpecialValueFor("radius",1)
	-- 	local enemies = FindUnitsInRadius(
	-- 			self:GetCaster():GetTeamNumber(),	-- int, your team number
	-- 			self:GetParent():GetAbsOrigin(),	-- point, center point
	-- 			nil,	-- handle, cacheUnit. (not known)
	-- 			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	-- 			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
	-- 			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
	-- 			0,	-- int, flag filter
	-- 			0,	-- int, order filter
	-- 			false	-- bool, can grow cache
	-- 		)
	-- 	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
	-- 	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	-- 	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,0,0) )
	-- 	ParticleManager:ReleaseParticleIndex(effect_cast)
	-- 	for _,enemy in pairs(enemies) do	
	-- 		enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = attack_stun * (1 - enemy:GetStatusResistance())})

	-- 		local knockback =
	-- 			{
	-- 				knockback_duration = 0.35,
	-- 				duration = 0.35,
	-- 				knockback_distance = radius / 9,
	-- 				knockback_height = 110,
	-- 				center_x = self:GetParent():GetAbsOrigin().x,
	-- 				center_y = self:GetParent():GetAbsOrigin().y,
	-- 				center_z = self:GetParent():GetAbsOrigin().z,
	-- 			}
	-- 		enemy:RemoveModifierByName("modifier_knockback")
	-- 		enemy:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback)

	-- 		self:GetCaster():PerformAttack( enemy, true, true, true, true, false, false, true )			

	-- 		Timers(0.35, function()
	-- 			FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), false)
	-- 		end)
	-- 	end
	-- end

	-- add viewer
	AddFOWViewer( self.caster:GetTeamNumber(), self.parent:GetOrigin(), self.vision, self.delay, false)
end

function modifier_Primary_Celestial_Hammer_thinker:Return()
	if self.converge then return end

	self.converge = true
	self.prev_pos = self.parent:GetOrigin()
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()

	-- calculate speed
	self.distance = (self.parent:GetOrigin()-self.caster:GetOrigin()):Length2D()
	if self.distance > self.speed*self.max_return then
		self.speed = self.distance/self.max_return
	end
	
	-- create projectile
	local info = {
		Target = self.caster,
		Source = self.parent,
		Ability = self.ability,	
		
		EffectName = self.name,
		iMoveSpeed = self.speed,
		bDodgeable = false,
	}
	local data = {
		cast = 2,
		targets = {},
		thinker = self.parent,
	}
	local id = ProjectileManager:CreateTrackingProjectile(info)
	self.ability.projectiles[id] = data

	-- play effects
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_Celestial_Hammer_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_celestial_hammer_grounded.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Celestial_Hammer.Impact"

	-- Get Data
	local direction = self:GetParent():GetOrigin()-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	self.effect_cast = effect_cast

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
end

function modifier_Primary_Celestial_Hammer_thinker:PlayEffects2()
	if self.effect_cast then
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end

	local sound_cast = "Hero_Dawnbreaker.Celestial_Hammer.Return"
	EmitSoundOn( sound_cast, self.parent )
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
modifier_Primary_Celestial_Hammer = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Celestial_Hammer:IsHidden()
	return true
end

function modifier_Primary_Celestial_Hammer:IsDebuff()
	return false
end

function modifier_Primary_Celestial_Hammer:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Celestial_Hammer:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	self.speed_pct = self:GetAbility():GetSpecialValueFor( "travel_speed_pct" )
	self.duration = self:GetAbility():GetSpecialValueFor( "flare_debuff_duration" )
	self.interval = 0.1


	if not IsServer() then return end

	self.hit_list = {}

	-- NOTE: arbitrary decision to mimic original spell
	self.max_range = self:GetAbility():GetSpecialValueFor( "range" )
	self.origin = self.parent:GetOrigin()

	self.prev_pos = self.parent:GetOrigin()
	self.actual_speed = self.speed*self.speed_pct/100
	self.target = EntIndexToHScript( kv.target )

	-- set forward
	local direction = self.target:GetOrigin()-self.parent:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	self.parent:SetForwardVector( direction )

	-- move
	if not self:ApplyHorizontalMotionController() then
		self:SafeDestroy()
		return
	end

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()

	-- play effects
	self:PlayEffects()
end

function modifier_Primary_Celestial_Hammer:OnRefresh( kv )
end

function modifier_Primary_Celestial_Hammer:OnRemoved()
end

function modifier_Primary_Celestial_Hammer:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_Celestial_Hammer:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

function modifier_Primary_Celestial_Hammer:GetModifierDisableTurning()
	return 1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Primary_Celestial_Hammer:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_Celestial_Hammer:OnIntervalThink()
	if not IsValid(self.ability) then
		return
	end
	-- create trail
	local thinker = CreateModifierThinker(
		self.parent, -- player source
		self.ability, -- ability source
		"modifier_Primary_Celestial_Hammer_trail", -- modifier name
		{
			duration = self.duration,
			x = self.prev_pos.x,
			y = self.prev_pos.y,
		}, -- kv
		self.parent:GetOrigin(),
		self.parent:GetTeamNumber(),
		false
	)
	self.prev_pos = self.parent:GetOrigin()	
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_Primary_Celestial_Hammer:UpdateHorizontalMotion( me, dt )
	local dist = (self.origin-me:GetOrigin()):Length2D()
	if dist>self.max_range then
		self:SafeDestroy()
		return
	end

	local pos = me:GetOrigin() + me:GetForwardVector() * self.actual_speed * dt

	pos = GetGroundPosition( pos, me )
	me:SetOrigin( pos )
end

function modifier_Primary_Celestial_Hammer:OnHorizontalMotionInterrupted()
	self:SafeDestroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_Celestial_Hammer:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_converge_trail.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.parent:GetForwardVector() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		true, -- bHeroEffect
		false -- bOverheadEffect
	)
end


function modifier_Primary_Celestial_Hammer:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_Primary_Celestial_Hammer:Advanced_GetModifier_FlyingPathing()	
	return 1
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
modifier_Primary_Celestial_Hammer_trail = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Celestial_Hammer_trail:IsHidden()
	return true
end

function modifier_Primary_Celestial_Hammer_trail:IsDebuff()
	return false
end

function modifier_Primary_Celestial_Hammer_trail:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Celestial_Hammer_trail:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "flare_radius" )

	if not IsServer() then return end

	self.prev_pos = Vector( kv.x, kv.y, 0 )
	self.prev_pos = GetGroundPosition( self.prev_pos, self:GetParent() )

	-- play effects
	self:PlayEffects( kv.duration )
end

function modifier_Primary_Celestial_Hammer_trail:OnRefresh( kv )
	
end

function modifier_Primary_Celestial_Hammer_trail:OnRemoved()
end

function modifier_Primary_Celestial_Hammer_trail:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_Primary_Celestial_Hammer_trail:IsAura()
	return true
end

function modifier_Primary_Celestial_Hammer_trail:GetModifierAura()
	return "modifier_Primary_Celestial_Hammer_debuff"
end

function modifier_Primary_Celestial_Hammer_trail:GetAuraRadius()
	return self.radius
end

function modifier_Primary_Celestial_Hammer_trail:GetAuraDuration()
	return 0.5
end

function modifier_Primary_Celestial_Hammer_trail:GetAuraSearchTeam()
	if self:GetCaster():HasAbility("Primary_Celestial_Hammer_trail_heal") and not self:GetCaster():PassivesDisabled() then
		return DOTA_UNIT_TARGET_TEAM_BOTH
	end
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_Primary_Celestial_Hammer_trail:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_Primary_Celestial_Hammer_trail:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_Celestial_Hammer_trail:PlayEffects( duration )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_converge_burning_trail.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self.prev_pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end



modifier_Primary_Celestial_Hammer_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Celestial_Hammer_debuff:IsHidden()
	return false
end

function modifier_Primary_Celestial_Hammer_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Celestial_Hammer_debuff:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	self.interval = self:GetAbility():GetSpecialValueFor( "burn_interval" )
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" )

	if not IsServer() then return end
	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage*self.interval*self:GetCaster():HDGetPrimaryStatValue(),
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()
end

function modifier_Primary_Celestial_Hammer_debuff:OnRefresh( kv )
	
end

function modifier_Primary_Celestial_Hammer_debuff:OnRemoved()
end

function modifier_Primary_Celestial_Hammer_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_Celestial_Hammer_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Primary_Celestial_Hammer_debuff:GetModifierMoveSpeedBonus_Constant()
	if IsServer() and self:GetCaster():HasAbility("Primary_Celestial_Hammer_trail_heal") and not self:GetCaster():PassivesDisabled() then
		if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
			return self.slow
		end
	end
	return -self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_Celestial_Hammer_debuff:OnIntervalThink()
	
	if IsServer() and self:GetCaster():HasAbility("Primary_Celestial_Hammer_trail_heal") and not self:GetCaster():PassivesDisabled() and self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then		
		self:GetParent():Heal(self.damageTable.damage, self:GetAbility())
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_HEAL,
			self:GetParent(),
			self.damageTable.damage,
			self:GetParent():GetPlayerOwner()
		)
	else
		ApplyDamage( self.damageTable )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_Celestial_Hammer_debuff:GetEffectName()
	return "particles/units/heroes/hero_dawnbreaker/dawnbreaker_converge_debuff.vpcf"
end

function modifier_Primary_Celestial_Hammer_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end






modifier_Primary_Celestial_Hammer_nohammer_buff = advanced_modifier({})

function modifier_Primary_Celestial_Hammer_nohammer_buff:IsDebuff()			return false end
function modifier_Primary_Celestial_Hammer_nohammer_buff:IsHidden() 			return false end
function modifier_Primary_Celestial_Hammer_nohammer_buff:IsPurgable() 		    return false end
function modifier_Primary_Celestial_Hammer_nohammer_buff:IsPurgeException() 	return false end
function modifier_Primary_Celestial_Hammer_nohammer_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_Primary_Celestial_Hammer_nohammer_buff:Advanced_GetModifierAttackSpeedPercentage() 
    return 30
end

function modifier_Primary_Celestial_Hammer_nohammer_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end
