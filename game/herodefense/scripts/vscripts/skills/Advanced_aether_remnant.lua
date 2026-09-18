--特效优化 √
Advanced_aether_remnant = class({})
LinkLuaModifier( "modifier_Advanced_aether_remnant", "skills/Advanced_aether_remnant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_aether_remnant_thinker", "skills/Advanced_aether_remnant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_Advanced_aether_remnant_passive", "skills/Advanced_aether_remnant", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Ability Phase Start
function Advanced_aether_remnant:OnAbilityPhaseInterrupted()

end
function Advanced_aether_remnant:OnAbilityPhaseStart()
	if not self:CheckVectorTargetPosition() then return false end
	SendToConsole("-dota_ability_execute")  --由于ntV蛇不知道改了什么东西需要手动取消施法状态
	return true 
end
function Advanced_aether_remnant:CheckKV(key)
	local table = {
		damage = 15,
		damage_index = 0.1,


	}
	local value = table[key] or -1
	return value

end
function Advanced_aether_remnant:UnlockFirstCore(key)
	return true
end
function Advanced_aether_remnant:UnlockSecondCore(key)
	return true
end
function Advanced_aether_remnant:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_aether_remnant_passive",{})
	return true
end
function Advanced_aether_remnant:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/aether_remnant/unlock2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf", context )

end

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_aether_remnant:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	if self.unlock3 then
		local pos = self:GetCursorPosition()
		local dir =( caster:GetAbsOrigin() - pos):Normalized()
		CreateModifierThinker(caster, self, "modifier_Advanced_aether_remnant_thinker", 
		{
			dir_x =dir.x,
			dir_y = dir.y,
		}, pos,caster:GetTeamNumber(),false)
		local sound_cast = "Hero_VoidSpirit.AetherRemnant.Cast"
		EmitSoundOn( sound_cast, caster )
		return
	end
	local targets = self:GetVectorTargetPosition()

	-- create thinker
	CreateModifierThinker(caster, self, "modifier_Advanced_aether_remnant_thinker", 
		{
			dir_x = targets.direction.x,
			dir_y = targets.direction.y,
		}, targets.init_pos,caster:GetTeamNumber(),false)
	if self.advanced_level>=15 then
		CreateModifierThinker(caster, self, "modifier_Advanced_aether_remnant_thinker", 
		{
			dir_x = targets.direction.x*(-1),
			dir_y = targets.direction.y*(-1),
		}, targets.init_pos,caster:GetTeamNumber(),false)
	end

	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Cast"
	EmitSoundOn( sound_cast, caster )


	-- self:StaticEffect(caster:GetAbsOrigin())
end


function Advanced_aether_remnant:StaticEffect(location)
	local pos =location
	pos.z = pos.z +256
	local caster = self:GetCaster()
	local ability = self
	for i = 1, 10, 1 do
		Timers:CreateTimer(i*0.2+RandomFloat(0.05, 0.15), function()
			local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/aether_remnant/unlock2/effect.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( effect_cast, 0, pos)
			ParticleManager:ReleaseParticleIndex( effect_cast )
		end)

	end
	Timers:CreateTimer(2, function()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, pos)
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(500,500,500))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		HdEmitSoundOnLocation(caster,pos,"Hero_Invoker.EMP.Discharge",2)
		-- print("pass0")
		-- print(ability:IsNull())
		if ability and not ability:IsNull() then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil,  400,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
		   	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
			local damage = 0
			for _, unit in ipairs(units) do
				damage = damage + unit:GetHealthPercent()
			end
			damage = damage / #units *0.003
			local damageTable = {
				-- victim = enemy,
				attacker = caster,
				damage = damage * caster:GetMaxMana(),
				damage_type =ability:GetAbilityDamageType(),
				ability = ability, --Optional.
			}
			for _, unit in ipairs(units) do
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end
			
		end
	end)
end


function Advanced_aether_remnant:GetBehavior()


	if self:GetCaster():HasModifier("modifier_Advanced_aether_remnant_passive") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
		
	end

	return  self.BaseClass.GetBehavior(self)
end



modifier_Advanced_aether_remnant = class({})
function modifier_Advanced_aether_remnant:IsHidden()	return false end
function modifier_Advanced_aether_remnant:IsDebuff()	return true end
function modifier_Advanced_aether_remnant:IsStunDebuff()	return true end
function modifier_Advanced_aether_remnant:IsPurgable()	return true end
function modifier_Advanced_aether_remnant:OnCreated( kv )


	if not IsServer() then return end
	self.advanced_level = self:GetAbility().advanced_level
	self.target = Vector( kv.pos_x, kv.pos_y, 0 )

	local dist = (self:GetParent():GetOrigin()-self.target):Length2D()
	self.speed = kv.pull/200*dist/kv.duration



	-- issue a move command
	self:GetParent():MoveToPosition( self.target )

	if self.effect_cast then
		return
	end
	local pos = Vector( kv.pos_x, kv.pos_y, kv.pos_z )
	local parent = self:GetParent()
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf"
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Triggered"
	local sound_target = "Hero_VoidSpirit.AetherRemnant.Target"
	local direction = parent:GetOrigin()-pos
	direction.z = 0
	direction = -direction:Normalized()
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, pos)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, direction )
	ParticleManager:SetParticleControl( effect_cast, 3, pos )
	self.effect_cast = effect_cast
	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_target, parent )

	if kv.triggerOFF then
		return
	end

	self.bonus_count = 1
	--LV10解锁连结+
	if self.advanced_level>=20 then
		self.bonus_count = 2
	end
	local count = 0

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  700,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
	   self.damage = self:GetAbility():GetSpecialValueFor("damage")+(self:GetAbility():GetSpecialValueFor("damage_index"))*self:GetCaster():GetIntellect(false)
	   local duration = self:GetAbility():GetSpecialValueFor("duration")
	   --LV15解锁多维
	   if self.advanced_level>=15 and not self:GetAbility().unlock3 then
		   self.damage = self.damage *0.5
		   duration = duration*0.5
	   end

	for _, unit in pairs(units) do
		if not unit:FindModifierByName("modifier_Advanced_aether_remnant") then
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
			local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		
		
			local pull_duration = duration*StatusResistance
			
			local damageTable = {
				victim = unit,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility(), --Optional.
			}
			ApplyDamage(damageTable)
			unit:AddNewModifier(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_Advanced_aether_remnant", -- modifier name
				{
					duration = pull_duration,
					pos_x = self.target.x,
					pos_y = self.target.y,
					pull = 300,
					pos_z = self.target.z,
					triggerOFF = true,
				} -- kv
			)

			count = count +1
		end
		if count>=self.bonus_count then
			break
		end
	end

	








end

function modifier_Advanced_aether_remnant:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Advanced_aether_remnant:OnDestroy( kv )
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		
	end
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_aether_remnant:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end

function modifier_Advanced_aether_remnant:GetModifierMoveSpeed_Absolute()
	if IsServer() then return self.speed end
end

function modifier_Advanced_aether_remnant:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_TAUNTED] = true,
	}

	return state
end


function modifier_Advanced_aether_remnant:GetStatusEffectName()	return "particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf" end
function modifier_Advanced_aether_remnant:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end



modifier_Advanced_aether_remnant_thinker = class({})
local STATE_RUN = 1
local STATE_DELAY = 2
local STATE_WATCH = 3
local STATE_PULL = 4

function modifier_Advanced_aether_remnant_thinker:OnCreated( kv )
	self.ability = self:GetAbility()
	-- references
	self.interval = 0.1
	self.delay = self.ability:GetSpecialValueFor("delay")
	self.speed = 1000

	self.width = 200
	self.distance = 500
	self.watch_vision = 500
	self.duration = self.ability:GetSpecialValueFor("watch_duration")

	
	self.pull_duration = self.ability:GetSpecialValueFor("duration")
	self.pull = 300
	self.count = 0
	self.max_count = 2

	if not IsServer() then return end
	self.advanced_level = self:GetAbility().advanced_level
	self.damage = self.ability:GetSpecialValueFor("damage")+(self.ability:GetSpecialValueFor("damage_index"))*self:GetCaster():GetIntellect(false)
	--LV15解锁多维
	if self.advanced_level>=15 and not self:GetAbility().unlock3 then
		self.damage = self.damage *0.5
		self.pull_duration = self.pull_duration*0.6
	end
	--LV5解锁残能+
	if self.advanced_level>=5 then
		self.max_count = self.max_count+1
	end
	--LV20解锁守望者
	if self.advanced_level>=20 then
		self.duration = self.duration+10
	end
	if self.ability.unlock1 then
		self.duration = self.duration * 2
	end
	self.effect_list = {}
	-- ability properties
	self.abilityDamageType = self.ability:GetAbilityDamageType()
	self.abilityTargetTeam = self.ability:GetAbilityTargetTeam()
	self.abilityTargetType = self.ability:GetAbilityTargetType()
	self.abilityTargetFlags = self.ability:GetAbilityTargetFlags()

	-- get direction & target
	self.origin = self:GetParent():GetOrigin()
	self.direction = Vector( kv.dir_x, kv.dir_y, 0 )
	self.target = GetGroundPosition( self.origin + self.direction * self.distance, nil )
	local run_dist = (self.origin-self:GetCaster():GetOrigin()):Length2D()
	local run_delay = run_dist/self.speed
	self.state = STATE_RUN
	self:StartIntervalThink( run_delay )
	self:PlayEffects1()
	self.timer = 0
end

function modifier_Advanced_aether_remnant_thinker:OnRefresh( kv )
	if not IsServer() then return end
	self.state = kv.state
end

function modifier_Advanced_aether_remnant_thinker:OnRemoved()
end

function modifier_Advanced_aether_remnant_thinker:OnDestroy()
	if not IsServer() then return end
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"
	StopSoundOn( sound_cast, self:GetParent() )
	self:PlayEffects5()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_aether_remnant_thinker:OnIntervalThink()
	if self.state == STATE_RUN then
		-- change state
		self.state = STATE_DELAY
		self:StartIntervalThink( self.delay )

		-- play delay effects
		self:PlayEffects2()
		return
	elseif self.state == STATE_DELAY then
		-- change state
		self.state = STATE_WATCH
		self:StartIntervalThink( self.interval )
		self:SetDuration( self.duration, false )
		self:PlayEffects3()
		return
	elseif self.state == STATE_WATCH then
		self.timer = self.timer +self.interval
		--LV20解锁守望者
		if self.advanced_level>=20 then
			self.timer = self.timer +self.interval
			if self.timer>=10 then
				self.timer = 0
				self.max_count = self.max_count + 1
			end
		end
		self:WatchLogic()
	else -- self.state == STATE_PULL
		-- stop looping
		self:StartIntervalThink( -1 )
		

	end
end

function modifier_Advanced_aether_remnant_thinker:WatchLogic()
	if self.count>=self.max_count then
		if self.ability.unlock1 then
			return
		else
			self.state = STATE_PULL
			self:SetDuration( self.pull_duration, false )
		end
	
	end
	-- provides vision
	AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin, self.watch_vision, 0.1, true)
	AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin + self.direction*self.distance/2, self.watch_vision, 0.1, true)
	AddFOWViewer( self:GetParent():GetTeamNumber(), self.target, self.watch_vision, 0.1, true)

	-- find units in line
	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self.origin,	-- point, center point
		self.target,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.width,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self.abilityTargetTeam,	-- int, team filter
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags	-- int, flag filter
	)

	if #enemies==0 then return end

	local enemy 
	--检测无该状态的人
	for _, unit in ipairs(enemies) do
		if not unit:FindModifierByName("modifier_Advanced_aether_remnant") and not IsInTable(unit,self.effect_list) then
			
			enemy = unit
		end
	end
	if not enemy then
		return
	end

	self.count = self.count +1
	table.insert(self.effect_list,enemy)
	enemy:EmitSound( "Hero_VoidSpirit.AetherRemnant.Target")
	-- damage
	local damageTable = {
		victim = enemy,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
	}
	ApplyDamage(damageTable)

	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
	local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain


	self.pull_duration = self.pull_duration*StatusResistance

	-- add debuff
	enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self.ability, -- ability source
		"modifier_Advanced_aether_remnant", -- modifier name
		{
			duration = self.pull_duration,
			pos_x = self.origin.x,
			pos_y = self.origin.y,
			pull = self.pull,

			pos_z = self.origin.z,
		} -- kv
	)

	if self.ability.unlock2 then
		self.ability:StaticEffect(Vector(self.origin.x,self.origin.y,self.origin.z))
	end




	if self.count>=self.max_count then
	
		if self.ability.unlock1 then
			return
		else
			self.state = STATE_PULL
			self:SetDuration( self.pull_duration, false )
		end
	end

	

	-- provides pull vision
	-- local direction = enemy:GetOrigin()-self.origin
	-- local dist = direction:Length2D()
	-- direction.z = 0
	-- direction = direction:Normalized()
	-- AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin, self.watch_vision, self.pull_duration, true)
	-- AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin + direction*dist/2, self.watch_vision, self.pull_duration, true)
	-- AddFOWViewer( self:GetParent():GetTeamNumber(), enemy:GetOrigin(), self.watch_vision, self.pull_duration, true)


end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_aether_remnant_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf"
	local sound_cast = "Hero_VoidSpirit.AetherRemnant"

	-- get data
	local direction = self.origin-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, direction * self.speed )
	ParticleManager:SetParticleControlForward( effect_cast, 0, -direction )
	ParticleManager:SetParticleShouldCheckFoW( effect_cast, false )

	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_Advanced_aether_remnant_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pre.vpcf"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
		ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleShouldCheckFoW( effect_cast, false )

	-- store for later use
	self.effect_cast = effect_cast
end

function modifier_Advanced_aether_remnant_thinker:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf"
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControlForward( effect_cast, 2, self.direction )

	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end



function modifier_Advanced_aether_remnant_thinker:PlayEffects5()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_flash.vpcf"
	local sound_target = "Hero_VoidSpirit.AetherRemnant.Destroy"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 3, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end


modifier_Advanced_aether_remnant_passive = class({})

function modifier_Advanced_aether_remnant_passive:IsDebuff()			return false end
function modifier_Advanced_aether_remnant_passive:IsHidden() 			return self:GetStackCount()<1 end
function modifier_Advanced_aether_remnant_passive:IsPurgable() 		return false end
function modifier_Advanced_aether_remnant_passive:IsPurgeException() 	return false end
function modifier_Advanced_aether_remnant_passive:RemoveOnDeath() return false end
function modifier_Advanced_aether_remnant_passive:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_aether_remnant_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function modifier_Advanced_aether_remnant_passive:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then	

		local ability = self:GetAbility()
		local caster = self:GetParent()
		if not caster:IsApplyModifier() then
			return
		end

		if not ability or ability:IsNull() or not ability:IsCooldownReady() then
			self:IncrementStackCount()
			return
		end

		local target = keys.target
		if not target or target:IsNull() then
			return
		end
		self:IncrementStackCount()

		if self:GetStackCount()>=5 then
			self:SetStackCount(0)
			ability:StartCooldown(1)
			self:GetCaster():SetCursorPosition(target:GetAbsOrigin())
			ability:OnSpellStart()
		end
		

		
	
		
	end
end
