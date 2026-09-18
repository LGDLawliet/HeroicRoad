Primary_onslaught = class({})

LinkLuaModifier( "modifier_Primary_onslaught_charge", "skills/Primary_onslaught", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_onslaught", "skills/Primary_onslaught", LUA_MODIFIER_MOTION_NONE )

function Primary_onslaught:Precache( context )
	-- PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "particle", "particles/rebuild/spell/onslaught/effect_charge_active.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/onslaught_chargeup/effect.vpcf", context )
	PrecacheResource( "particle", "particles/indicator/primal_beast_onslaught_range_finder/effect.vpcf", context )
end


function Primary_onslaught:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	-- local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "chargeup_time" )

	-- add modifier
	local mod = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_onslaught_charge", -- modifier name
		{ duration = duration } -- kv
	)

end

function Primary_onslaught:OnChargeFinish( interrupt )
	-- unit identifier
	local caster = self:GetCaster()


	-- load data
	local max_duration = self:GetSpecialValueFor( "chargeup_time" )
	local max_distance = self:GetSpecialValueFor( "max_distance" )
	local speed = self:GetSpecialValueFor( "charge_speed" )

	-- find charge modifier
	local charge_duration = max_duration
	local mod = caster:FindModifierByName( "modifier_Primary_onslaught_charge" )
	if mod then
		charge_duration = mod:GetElapsedTime()

		mod.charge_finish = true
		mod:Destroy()
	end

	local distance = max_distance * charge_duration/max_duration
	local duration = distance/speed

	-- cancel if interrupted
	if interrupt then return end

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_onslaught", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	EmitSoundOn( "Hero_PrimalBeast.Onslaught", caster )
end





modifier_Primary_onslaught_charge = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_onslaught_charge:IsHidden()	return false end
function modifier_Primary_onslaught_charge:IsDebuff()	return false end
function modifier_Primary_onslaught_charge:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_onslaught_charge:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.speed = self.ability:GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self.ability:GetSpecialValueFor( "turn_rate" )

	if not IsServer() then return end
	if self.parent:HasAbility("heroTalent_npc_dota_hero_primal_beast_2") then
		self.turn_speed = self.turn_speed *3
	end

	self.origin = self.parent:GetOrigin()
	self.charge_finish = false

	-- turning data
	self.target_angle = self.parent:GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	-- Start interval
	self:StartIntervalThink( FrameTime() )

	-- order filter using library
	self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )

	-- play effect
	self:PlayEffects1()
	self:PlayEffects2()
end


function modifier_Primary_onslaught_charge:OnRemoved()
	if not IsServer() then return end

	-- stop effects
	local sound_cast = "Hero_PrimalBeast.Onslaught.Channel"
	EmitSoundOn( sound_cast, self.parent )

	if not self.charge_finish then
		self.ability:OnChargeFinish( false )
	end

	-- remove filter
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end


function modifier_Primary_onslaught_charge:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end



function modifier_Primary_onslaught_charge:GetOverrideAnimation()
	if self:GetParent():GetUnitName()=="npc_dota_hero_primal_beast" then
		return ACT_DOTA_IDLE
	end
	return ACT_DOTA_GENERIC_CHANNEL_1
end
function modifier_Primary_onslaught_charge:GetActivityTranslationModifiers()
	return "onslaught_windup"
end
function modifier_Primary_onslaught_charge:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- point right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		-- set facing
		self:SetDirection( params.new_pos )

	-- targetted right click
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		-- set facing
		self:SetDirection( params.target:GetOrigin() )
	
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self.ability:OnChargeFinish( false )
	end	
end

function modifier_Primary_onslaught_charge:SetDirection( location )
	local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_Primary_onslaught_charge:GetModifierMoveSpeed_Limit()
	return 0.1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Primary_onslaught_charge:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Filter
-- NOTE: Filter is required because right-clicking faces the unit to target position, RESPECTING the terrain, so the target point may be different
function modifier_Primary_onslaught_charge:OrderFilter( data )
	-- only filter right-clicks
	if data.order_type~=DOTA_UNIT_ORDER_MOVE_TO_POSITION and
		data.order_type~=DOTA_UNIT_ORDER_MOVE_TO_TARGET and
		data.order_type~=DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		return true
	end

	-- filter orders given to parent
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==self.parent then
			found = true
		end
	end
	if not found then return true end

	-- set order to move to direction
	data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION

	-- if there is target, set position to its origin
	if data.entindex_target~=0 then
		local pos = EntIndexToHScript( data.entindex_target ):GetOrigin()
		data.position_x = pos.x
		data.position_y = pos.y
		data.position_z = pos.z
	end

	return true
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_onslaught_charge:OnIntervalThink()
	-- cancel logic
	if self.parent:IsRooted() or self.parent:IsStunned() or self.parent:IsSilenced() or
		self.parent:IsCurrentlyHorizontalMotionControlled() or self.parent:IsCurrentlyVerticalMotionControlled()
	then
		self.ability:OnChargeFinish( true )
	end

	-- turning logic
	self:TurnLogic( FrameTime() )

	-- set particles
	self:SetEffects()
end

function modifier_Primary_onslaught_charge:TurnLogic( dt )
	-- only rotate when target changed
	if self.face_target then return end

	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		-- end rotating
		self.current_angle = self.target_angle
		self.face_target = true
	else
		-- rotate current angle
		self.current_angle = self.current_angle + sign*turn_speed
	end

	-- turn the unit
	local angles = self.parent:GetAnglesAsVector()
	self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_onslaught_charge:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/indicator/primal_beast_onslaught_range_finder/effect.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast,60, Vector(135,0,0) )
	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self.effect_cast = effect_cast
	self:SetEffects()
end

function modifier_Primary_onslaught_charge:SetEffects()
	local target_pos = self.origin + self.parent:GetForwardVector() * self.speed * self:GetElapsedTime()
	ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )
end

function modifier_Primary_onslaught_charge:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/onslaught_chargeup/effect.vpcf"
	local sound_cast = "Hero_PrimalBeast.Onslaught.Channel"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
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

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end







modifier_Primary_onslaught = advanced_modifier({})


function modifier_Primary_onslaught:IsHidden()	return true end
function modifier_Primary_onslaught:IsDebuff()	return false end
function modifier_Primary_onslaught:IsPurgable()	return false end
function modifier_Primary_onslaught:IsMotionController() return true end
function modifier_Primary_onslaught:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_Primary_onslaught:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.speed = self.ability:GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self.ability:GetSpecialValueFor( "turn_rate" )

	self.radius = self.ability:GetSpecialValueFor( "knockback_radius" )
	self.distance = self.ability:GetSpecialValueFor( "knockback_distance" )
	self.duration = self.ability:GetSpecialValueFor( "knockback_duration" )
	self.stun = self.ability:GetSpecialValueFor( "stun_duration" )
	local damage = self.ability:GetSpecialValueFor( "damage" )+self.ability:GetSpecialValueFor( "bonus_damage" )*self.parent:GetDamageMax()

	self.tree_radius = 100
	self.height = 50
	self.duration = 0.3 -- kv above is a lie

	if not IsServer() then return end
	if self.parent:HasAbility("heroTalent_npc_dota_hero_primal_beast_2") then
		self.turn_speed = self.turn_speed *3
		damage = damage + self.parent:GetAverageTrueAttackDamage(nil)*0.5
	end
	-- ability properties
	self.abilityDamageType = self.ability:GetAbilityDamageType()
	self.abilityTargetTeam = self.ability:GetAbilityTargetTeam()
	self.abilityTargetType = self.ability:GetAbilityTargetType()
	self.abilityTargetFlags = self.ability:GetAbilityTargetFlags()

	-- turning data
	self.target_angle = self.parent:GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	-- knockback data
	self.knockback_units = {}
	self.knockback_units[self.parent] = true

	-- if not self:ApplyHorizontalMotionController() then
	-- 	self:Destroy()
	-- 	return
	-- end

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
	}
	self.start_pos = self.parent:GetOrigin()
	self:StartIntervalThink(FrameTime()) 
end

function modifier_Primary_onslaught:OnDestroy()
	if not IsServer() then return end
	-- self.parent:RemoveHorizontalMotionController(self)
	FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )
end


function modifier_Primary_onslaught:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_Primary_onslaught:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- point right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		ExecuteOrderFromTable({
			UnitIndex = self.parent:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION,
			Position = params.new_pos,
		})
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		-- set facing
		self:SetDirection( params.new_pos )

	-- targetted right click
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		-- set facing
		self:SetDirection( params.target:GetOrigin() )
	
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_Primary_onslaught:GetModifierDisableTurning()
	return 1
end

function modifier_Primary_onslaught:SetDirection( location )
	local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_Primary_onslaught:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_Primary_onslaught:GetActivityTranslationModifiers()
	return "onslaught_movement"
end



function modifier_Primary_onslaught:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	if self.parent:IsRooted() or self.parent:IsStunned() then
		self:Destroy()
		return
	end

	self:HitLogic()

	-- local forward = self.parent:GetForwardVector()
	self:TurnLogic( FrameTime() )

	local nextpos = self.parent:GetOrigin() + self.parent:GetForwardVector() * self.speed*FrameTime()
	nextpos = GetGroundPosition(nextpos, nil)
	-- self.no_Interrupted = true
	-- FindClearSpaceForUnit( self.parent, nextpos, true )
	-- self.update_count = self.update_count + 1
	if CalculateDistance(self.start_pos,self.parent:GetOrigin())>=2000 then
		self.start_pos = self.parent:GetOrigin()
		FindClearSpaceForUnit( self.parent, nextpos, true )
	else
		self.parent:SetOrigin(nextpos)  --Sets the location of this entity
	end
	
	-- self.no_Interrupted = false
end

function modifier_Primary_onslaught:TurnLogic( dt )
	-- only rotate when target changed
	if self.face_target then return end

	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		-- end rotating
		self.current_angle = self.target_angle
		self.face_target = true
	else
		-- rotate current angle
		self.current_angle = self.current_angle + sign*turn_speed
	end

	-- turn the unit
	local angles = self.parent:GetAnglesAsVector()
	self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_Primary_onslaught:HitLogic()
	-- destroy trees
	-- GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.tree_radius, false )

	local units = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,unit in pairs(units) do
		-- only knockback once
		if not self.knockback_units[unit] then
			self.knockback_units[unit] = true

			local is_enemy = unit:GetTeamNumber()~=self.parent:GetTeamNumber()

			if is_enemy or not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
				-- knockback data
				local direction = unit:GetOrigin()-self.parent:GetOrigin()
				direction.z = 0
				direction = direction:Normalized()

				-- create arc
				unit:AddNewModifier(
					self.parent, -- player source
					self.ability, -- ability source
					"modifier_generic_arc_lua_not_remove_on_death", -- modifier name
					{
						dir_x = direction.x,
						dir_y = direction.y,
						duration = self.duration,
						distance = self.distance,
						height = self.height,
						activity = ACT_DOTA_FLAIL,
					} -- kv
				)
			end
			-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			
			-- damage and stun
			if is_enemy then
				local enemy = unit

				-- damage
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)
				-- stun
				enemy:AddNewModifier(
					self.parent, -- player source
					self.ability, -- ability source
					"modifier_stunned", -- modifier name
					{ duration = self.stun*StatusResistance } -- kv
				)
			end


			-- play effects
			self:PlayEffects( unit, self.radius )
		end
	end
end


function modifier_Primary_onslaught:GetEffectName()
	return "particles/rebuild/spell/onslaught/effect_charge_active.vpcf"
end

function modifier_Primary_onslaught:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Primary_onslaught:PlayEffects( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf"
	local sound_cast = "Hero_PrimalBeast.Onslaught.Hit"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end


function modifier_Primary_onslaught:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
	
end

function modifier_Primary_onslaught:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_Primary_onslaught:Advanced_GetModifier_FlyingPathing()	
	return 1
end
