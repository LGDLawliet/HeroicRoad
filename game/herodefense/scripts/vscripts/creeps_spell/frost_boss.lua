

LinkLuaModifier("modifier_frost_boss_passive", "pathfinder/frost_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frost_boss_nova", "pathfinder/frost_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frost_boss_creeper_aura", "pathfinder/frost_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frost_boss_creeper_effect", "pathfinder/frost_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frost_boss_pull", "pathfinder/frost_boss", LUA_MODIFIER_MOTION_HORIZONTAL )
--------------------------------------------------------------------------------
require("libraries.timers")

function Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_vo_night_stalker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context )	
end



frost_boss_massive_nova = class({})
function frost_boss_massive_nova:OnAbilityPhaseStart()		
	self:GetCaster():EmitSound("hero_Crystal.freezingField.wind")	
	self.nFXIndex = ParticleManager:CreateParticle( "particles/world_outpost/world_outpost_channel.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )	
	self.nFXIndex2 = ParticleManager:CreateParticle( "particles/world_outpost/world_outpost_channel.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true )

	return true
end

function frost_boss_massive_nova:OnChannelFinish(bInterrupted)
	if IsServer() and self.nFXIndex then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
	if IsServer() and self.nFXIndex2 then
		ParticleManager:DestroyParticle(self.nFXIndex2, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex2)
	end
end

function frost_boss_massive_nova:OnSpellStart()			
	self.interval = 0.1
	self.internal_timer = 0
end


function frost_boss_massive_nova:OnChannelInterrupted()
end

function frost_boss_massive_nova:OnChannelThink(flInterval)
	self.internal_timer = self.internal_timer + flInterval
	if self.internal_timer > self.interval then
		self.internal_timer = 0
		local range = self:GetSpecialValueFor("range")
		local count = 2
		local spell = self:GetCaster():FindAbilityByName("frost_boss_nova")

		local pos = self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(0, range))
		for i=0,count do
			Timers:CreateTimer(0.5 * i, function()
				local bSound = false
				if RandomInt(1,10) == 1 then
					bSound = true
				end
				spell:MakeNova(pos + RandomVector(RandomFloat(0,500)),bSound)
			end)			
		end		
	end
end


---------------------------------------------
---------------------------------------------



frost_boss_creeper = class({})
function frost_boss_creeper:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Lich.SinisterGaze.Target")
	local pos = self:GetCaster():GetAbsOrigin() + RandomVector(RandomFloat(300,500))
	local hUnit = CreateUnitByName( "frost_boss_summon", pos, true, nil, nil, DOTA_TEAM_BADGUYS )
		

	local spawnFX = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(spawnFX, 0, pos)
	ParticleManager:ReleaseParticleIndex(spawnFX)

	local spell = self
	Timers:CreateTimer(2, function()
		hUnit:AddNewModifier(spell:GetCaster(), spell, "modifier_frost_boss_creeper_aura", {})
	end)	

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 12000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false )

	if #enemies > 0 then
		hUnit:MoveToTargetToAttack( enemies[1] )			
	end
end


modifier_frost_boss_creeper_aura = class({})
function modifier_frost_boss_creeper_aura:IsHidden()					return true end

function modifier_frost_boss_creeper_aura:IsAura()						return true end
function modifier_frost_boss_creeper_aura:IsAuraActiveOnDeath() 		return true end
function modifier_frost_boss_creeper_aura:RemoveOnDeath() 				return true end

function modifier_frost_boss_creeper_aura:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false,
	}

	return state
end

function modifier_frost_boss_creeper_aura:GetAuraRadius()				
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_frost_boss_creeper_aura:GetAuraSearchTeam()			
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_frost_boss_creeper_aura:GetAuraSearchType()			
	return DOTA_UNIT_TARGET_HERO
end

function modifier_frost_boss_creeper_aura:GetModifierAura()			
	return "modifier_frost_boss_creeper_effect" 
end

function modifier_frost_boss_creeper_aura:GetAuraEntityReject(hTarget)	return hTarget:IsMagicImmune() end

function modifier_frost_boss_creeper_aura:OnCreated(table)			
	if not IsServer() then return end
	self.spawnFX = ParticleManager:CreateParticle("particles/nightstalker_creeper_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControlEnt( self.spawnFX, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl(self.spawnFX, 0, self:GetParent():GetAbsOrigin())

	local radius = self:GetAbility():GetSpecialValueFor("radius")
	ParticleManager:SetParticleControl(self.spawnFX, 2, Vector(radius,radius,radius))
	self:AddParticle(self.spawnFX, false, false, -1, true, false)	
	ParticleManager:ReleaseParticleIndex(self.spawnFX)
end

function modifier_frost_boss_creeper_aura:GetEffectName()	
	return "particles/econ/courier/courier_trail_winter_2012/courier_trail_winter_2012.vpcf"
end




modifier_frost_boss_creeper_effect = class({})

function modifier_frost_boss_creeper_effect:IsHidden()	return false end

function modifier_frost_boss_creeper_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }
end

function modifier_frost_boss_creeper_effect:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("miss_chance")
end

function modifier_frost_boss_creeper_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed_slow")
end

function modifier_frost_boss_creeper_effect:GetEffectName()	
	return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf"	
end

function modifier_frost_boss_creeper_effect:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

---------------------------------------------
---------------------------------------------

frost_boss_nova = class({})
function frost_boss_nova:OnSpellStart()
	if not IsServer() then return end
	local range = self:GetSpecialValueFor("range")
	local count = self:GetLevelSpecialValueFor("count", self:GetLevel() - 1)
	local radius = self:GetSpecialValueFor("radius")

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	local max_target = 3
	local current_count = 0
	for _,enemy in pairs(enemies) do
		if current_count < max_target then
			current_count = current_count + 1
			local spell = self
			local target = enemy
			for i=0,count do
				Timers:CreateTimer(0.5 * i, function()
					spell:MakeNova(target:GetAbsOrigin() + RandomVector(RandomFloat(-radius / 2 * count - 1, radius / 2 * count - 1)), true)
				end)			
			end		
		end
	end
end

function frost_boss_nova:MakeNova(location, bSound)
	local damage = self:GetLevelSpecialValueFor("damage", self:GetLevel() - 1)
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetLevelSpecialValueFor("duration", self:GetLevel() - 1)
	local delay = self:GetSpecialValueFor("delay")

	local warningFX1 = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons_j.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(warningFX1, 0, location)
	ParticleManager:SetParticleControl(warningFX1, 1, Vector(radius, 0, 0))

	local warningFX2 = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons_m.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(warningFX2, 2, location)
	ParticleManager:SetParticleControl(warningFX2, 2, Vector(radius, 0, 0))	

	if bSound == true then
		self:GetCaster():EmitSoundParams("Hero_Lich.IceAge", 0, 0.5, 0)
	end

	Timers:CreateTimer(delay, function() 
		ParticleManager:DestroyParticle(warningFX1, false)
		ParticleManager:ReleaseParticleIndex(warningFX1)
		ParticleManager:DestroyParticle(warningFX2, false)
		ParticleManager:ReleaseParticleIndex(warningFX2)

		local fx = ParticleManager:CreateParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(fx, 0, location)
		ParticleManager:ReleaseParticleIndex(fx)

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		for _,enemy in pairs(enemies) do
			local damageTable = {
				victim			= enemy,
				damage			= damage,
				damage_type		= self:GetAbilityDamageType(),				
				attacker		= self:GetCaster(),
				ability			= self,
			}	
			if not enemy:IsMagicImmune() then
				ApplyDamage(damageTable)
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_frost_boss_nova", {duration = duration})
			end

			local hUnit = CreateUnitByName( "frost_boss_summon", enemy:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )

			local knockback =
			{
				knockback_duration = 0.2,
				duration = 0.2,
				knockback_distance = 200,
				knockback_height = 200,
				center_x = enemy:GetAbsOrigin().x,
				center_y = enemy:GetAbsOrigin().y,
				center_z = enemy:GetAbsOrigin().z,
			}
			hUnit:RemoveModifierByName("modifier_knockback")
			hUnit:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback)		
			Timers(0.35, function()
				FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), false)
			end)

			local spell = self
			Timers:CreateTimer(2, function()
				hUnit:AddNewModifier(spell:GetCaster(), spell, "modifier_frost_boss_creeper_aura", {})
			end)	

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			if #enemies > 0 then
				hUnit:MoveToTargetToAttack( enemies[1] )			
			end
		end

		if bSound == true then			
			self:GetCaster():EmitSoundParams("Ability.FrostNova", 0, 0.5, 0)
		end
	end)
end

modifier_frost_boss_nova								= class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return true end,			
})

function modifier_frost_boss_nova:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT  ,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE ,
	}

	return funcs
end

function modifier_frost_boss_nova:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attackspeed_slow")
end

function modifier_frost_boss_nova:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetLevelSpecialValueFor("movespeed_slow", self:GetAbility():GetLevel() - 1)
end

function modifier_frost_boss_nova:GetStatusEffectName()
	return "particles/units/heroes/hero_tusk/tusk_frozen_sigil_status_ice.vpcf"
end

--------------------------------------------------------------
--------------------------------------------------------------


frost_boss_pull = class({})

function frost_boss_pull:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("start_range")
end

function frost_boss_pull:Spawn()
	if not self.pull_list then
		self.pull_list = {}
	end
end

function frost_boss_pull:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Lich.SinisterGaze.Cast")
	return true
end

function frost_boss_pull:OnSpellStart()
	if not IsServer() then return end			
	self.start_radius = self:GetSpecialValueFor("width")
	self.end_radius = self:GetSpecialValueFor("width")
	self.gap = self:GetSpecialValueFor("projectile_gap")
	self.count = self:GetSpecialValueFor("projectile_count")
	self.speed = self:GetSpecialValueFor("speed")

	local vDirection = self:GetCaster():GetOrigin() - self:GetCursorPosition()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	vPos = self:GetCaster():GetAbsOrigin() - vDirection * self:GetSpecialValueFor("start_range")

	self.dir = vDirection


	local fRangeToTarget =  ( self:GetCaster():GetOrigin() - vPos ):Length2D() + 150 -- so the projectile doesnt stop directly underneath caster	

	local info = {
		EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
		Ability = self,
		vSpawnOrigin = vPos, 
		fStartRadius = self.start_radius,
		fEndRadius = self.end_radius,
		vVelocity = vDirection * self.speed,
		fDistance = fRangeToTarget,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO,		
	}	

	local to_right = Vector(vDirection.y, -1 * vDirection.x, vDirection.z)

	local proj_pos = vPos - to_right * self.gap * ((self.count / 2) - 0.5)
	for i=1,self.count do		
		info.vSpawnOrigin = proj_pos
		self.pull_list[ProjectileManager:CreateLinearProjectile( info )] = {}
		proj_pos = proj_pos + to_right * self.gap
	end	
	self.dest = self:GetCaster():GetAbsOrigin()
end

function frost_boss_pull:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
	if not IsServer() then return end	

	if hTarget then		
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_frost_boss_pull", {proj = iProjectileHandle})		
		table.insert(self.pull_list[iProjectileHandle], hTarget)
		self:GetCaster():EmitSound("Hero_Lich.ChainFrostImpact.Hero")
	end
end

function frost_boss_pull:OnProjectileThinkHandle(iProjectileHandle)		
	if (ProjectileManager:GetLinearProjectileLocation(iProjectileHandle) - self.dest):Length2D() < self.gap * ((self.count / 2)) then
		for _,target in pairs(self.pull_list[iProjectileHandle]) do
			target:RemoveModifierByName("modifier_frost_boss_pull")
			if not target:IsMagicImmune() then
				target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("end_stun")})		
			end
		end
	end


	for _,target in pairs(self.pull_list[iProjectileHandle]) do
		local base_loc = GetGroundPosition(  ProjectileManager:GetLinearProjectileLocation(iProjectileHandle), target )
		local wall_radius = 50
		local search_loc = GetGroundPosition( base_loc + self.dir * wall_radius, target )
		if search_loc.z - base_loc.z > 10 and (not GridNav:IsTraversable( search_loc )) then
			target:RemoveModifierByName("modifier_frost_boss_pull")
			if not target:IsMagicImmune() then
				target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("end_stun")})		
			end
		end	
	end
end


----------------------------------------------------------------------

modifier_frost_boss_pull = class({})
modifier_frost_boss_pull								= class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return true end,		
	IsStunDebuff	  		= function(self) return true end,	
})

function modifier_frost_boss_pull:IsMotionController()  return true end
function modifier_frost_boss_pull:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_frost_boss_pull:OnCreated(table) 	
	if IsServer() then		
		-- try apply
		self.proj = table.proj
		if self:ApplyHorizontalMotionController() == false then
			self:SafeDestroy()
		end
	end	
end

function modifier_frost_boss_pull:OnDestroy()
	if not IsServer() then return end
	-- Compulsory interrupt
	self:GetParent():InterruptMotionControllers( false )
	FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), true )
	
end

function modifier_frost_boss_pull:OnRemove()
	if not IsServer() then return end
	-- Compulsory interrupt
	self:GetParent():InterruptMotionControllers( false )
	FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), true )
end

-- Modifier Effects
function modifier_frost_boss_pull:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_frost_boss_pull:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function modifier_frost_boss_pull:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

-- Motion Effects
function modifier_frost_boss_pull:UpdateHorizontalMotion( me, dt )
	-- move parent to projectile location
	if self.proj then		
		self:GetParent():SetAbsOrigin( ProjectileManager:GetLinearProjectileLocation(self.proj) )
	else
		print("no proj")
	end
end

function modifier_frost_boss_pull:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:SafeDestroy()
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------

frost_boss_passive = class({})
function frost_boss_passive:GetIntrinsicModifierName()
	return "modifier_frost_boss_passive"
end


modifier_frost_boss_passive = class({})

modifier_frost_boss_passive								= class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,		
})

function modifier_frost_boss_passive:CheckState() 
	-- if self:GetParent():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("rage_threshold") then
	-- 	return {	
	-- 			[MODIFIER_STATE_FLYING] = true,
	-- 			[MODIFIER_STATE_UNSLOWABLE] = true,
	-- 	 }
	-- else
	return {	
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_UNSLOWABLE] = true,
		}
	-- end
end

function modifier_frost_boss_passive:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		-- MODIFIER_EVENT_ON_DEATH,
		
	}	
	return decFuncs
end

function modifier_frost_boss_passive:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("rage_speed_bonus")
end

function modifier_frost_boss_passive:GetActivityTranslationModifiers()
	if self:GetParent():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("rage_threshold") then
		return "hunter_night"
	end
end

function modifier_frost_boss_passive:OnCreated(table)
	if not IsServer() then return end
	self:GetParent():SetShouldDoFlyHeightVisual(false)	
	-- self:StartIntervalThink(3)
end

-- function modifier_frost_boss_passive:OnDeath(params)
-- 	if not IsServer() then return end
-- 	if params.unit:GetTeamNumber() ~= self:GetAbility():GetCaster():GetTeamNumber() then
-- 		local szLines = 
-- 		{
-- 			"night_stalker_nstalk_inthebag_01",
-- 			"night_stalker_nstalk_kill_02",
-- 			"night_stalker_nstalk_kill_03",
-- 			"night_stalker_nstalk_kill_04",
-- 			"night_stalker_nstalk_kill_05",
-- 			"night_stalker_nstalk_kill_07",
-- 			"night_stalker_nstalk_kill_08",
-- 			"night_stalker_nstalk_kill_09",
-- 			"night_stalker_nstalk_kill_10",
-- 			"night_stalker_nstalk_kill_11",
-- 			"night_stalker_nstalk_kill_12",		
-- 			"night_stalker_nstalk_killspecial_02",		
-- 		}

-- 		EmitGlobalSound(szLines[ RandomInt( 1, #szLines ) ])
-- 	end
-- end

-- function modifier_frost_boss_passive:OnIntervalThink()
-- 	local szLines = 
-- 	{
-- 		"night_stalker_nstalk_deny_03",
-- 		"night_stalker_nstalk_deny_09",
-- 		"night_stalker_nstalk_happy_04",
-- 		"night_stalker_nstalk_laugh_06",
-- 		"night_stalker_nstalk_laugh_05",
-- 		"night_stalker_nstalk_laugh_07",
-- 		"night_stalker_nstalk_laugh_09",
-- 		"night_stalker_nstalk_laugh_10",
-- 		"night_stalker_nstalk_laugh_06",
-- 		"night_stalker_nstalk_level_01",
-- 		"night_stalker_nstalk_attack_02",
-- 		"night_stalker_nstalk_attack_03",
-- 		"night_stalker_nstalk_attack_04",
-- 		"night_stalker_nstalk_attack_05",
-- 		"night_stalker_nstalk_attack_06",
-- 		"night_stalker_nstalk_attack_07",
-- 		"night_stalker_nstalk_attack_08",
-- 		"night_stalker_nstalk_attack_09",
-- 		"night_stalker_nstalk_attack_11",
-- 		"night_stalker_nstalk_attack_12",
-- 		"night_stalker_nstalk_rare_01",
-- 		"night_stalker_nstalk_rare_02",

-- 	}
-- 	if RandomInt(1,100) < 33 then 
-- 		EmitGlobalSound(szLines[ RandomInt( 1, #szLines ) ])
-- 	end
-- end

function modifier_frost_boss_passive:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_wm16_dire.vpcf"
end

function modifier_frost_boss_passive:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA + 1000000
end
