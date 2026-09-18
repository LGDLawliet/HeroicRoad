Middle_aether_remnant = class({})
LinkLuaModifier( "modifier_Middle_aether_remnant", "skills/Middle_aether_remnant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_aether_remnant_thinker", "skills/Middle_aether_remnant", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Phase Start
function Middle_aether_remnant:OnAbilityPhaseInterrupted()

end
function Middle_aether_remnant:OnAbilityPhaseStart()
	if not self:CheckVectorTargetPosition() then return false end
	SendToConsole("-dota_ability_execute")  --由于ntV蛇不知道改了什么东西需要手动取消施法状态
	return true 
end

--------------------------------------------------------------------------------
-- Ability Start
function Middle_aether_remnant:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local targets = self:GetVectorTargetPosition()

	-- create thinker
	CreateModifierThinker(caster, self, "modifier_Middle_aether_remnant_thinker", 
		{
			dir_x = targets.direction.x,
			dir_y = targets.direction.y,
		}, targets.init_pos,caster:GetTeamNumber(),false)

	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Cast"
	EmitSoundOn( sound_cast, caster )
end





modifier_Middle_aether_remnant = class({})
function modifier_Middle_aether_remnant:IsHidden()	return false end
function modifier_Middle_aether_remnant:IsDebuff()	return true end
function modifier_Middle_aether_remnant:IsStunDebuff()	return true end
function modifier_Middle_aether_remnant:IsPurgable()	return true end
function modifier_Middle_aether_remnant:OnCreated( kv )


	if not IsServer() then return end
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






end

function modifier_Middle_aether_remnant:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Middle_aether_remnant:OnDestroy( kv )
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		
	end
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_aether_remnant:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end

function modifier_Middle_aether_remnant:GetModifierMoveSpeed_Absolute()
	if IsServer() then return self.speed end
end

function modifier_Middle_aether_remnant:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_TAUNTED] = true,
	}

	return state
end


function modifier_Middle_aether_remnant:GetStatusEffectName()	return "particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf" end
function modifier_Middle_aether_remnant:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end



modifier_Middle_aether_remnant_thinker = class({})
local STATE_RUN = 1
local STATE_DELAY = 2
local STATE_WATCH = 3
local STATE_PULL = 4

function modifier_Middle_aether_remnant_thinker:OnCreated( kv )
	self.ability = self:GetAbility()
	-- references
	self.interval = 0.1
	self.delay = self.ability:GetSpecialValueFor("delay")
	self.speed = 1000

	self.width = 200
	self.distance = 500
	self.watch_vision = 500
	self.duration = self.ability:GetSpecialValueFor("watch_duration")

	self.damage = self.ability:GetSpecialValueFor("damage")+self.ability:GetSpecialValueFor("damage_index")*self:GetCaster():GetIntellect(false)
	self.pull_duration = self.ability:GetSpecialValueFor("duration")
	self.pull = 300
	self.count = 0
	self.max_count = 2

	if not IsServer() then return end
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
end

function modifier_Middle_aether_remnant_thinker:OnRefresh( kv )
	if not IsServer() then return end
	self.state = kv.state
end

function modifier_Middle_aether_remnant_thinker:OnRemoved()
end

function modifier_Middle_aether_remnant_thinker:OnDestroy()
	if not IsServer() then return end
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"
	StopSoundOn( sound_cast, self:GetParent() )
	self:PlayEffects5()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_aether_remnant_thinker:OnIntervalThink()
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
		self:WatchLogic()
	else -- self.state == STATE_PULL
		-- stop looping
		self:StartIntervalThink( -1 )
		

	end
end

function modifier_Middle_aether_remnant_thinker:WatchLogic()
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
		if not unit:FindModifierByName("modifier_Middle_aether_remnant") and not IsInTable(unit,self.effect_list) then
			
			enemy = unit
		end
	end
	if not enemy then
		return
	end

	self.count = self.count +1
	table.insert(self.effect_list,enemy)

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
		"modifier_Middle_aether_remnant", -- modifier name
		{
			duration = self.pull_duration,
			pos_x = self.origin.x,
			pos_y = self.origin.y,
			pull = self.pull,

			pos_z = self.origin.z,
		} -- kv
	)




	if self.count>=self.max_count then
		self.state = STATE_PULL
		self:SetDuration( self.pull_duration, false )
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
function modifier_Middle_aether_remnant_thinker:PlayEffects1()
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

function modifier_Middle_aether_remnant_thinker:PlayEffects2()
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

function modifier_Middle_aether_remnant_thinker:PlayEffects3()
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



function modifier_Middle_aether_remnant_thinker:PlayEffects5()
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