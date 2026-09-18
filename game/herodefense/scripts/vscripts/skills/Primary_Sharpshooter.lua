Primary_Sharpshooter = class({})
LinkLuaModifier("modifier_generic_arc_lua", "modifier/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_Primary_Sharpshooter", "skills/Primary_Sharpshooter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Sharpshooter_debuff", "skills/Primary_Sharpshooter", LUA_MODIFIER_MOTION_NONE)





function Primary_Sharpshooter:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/sharpshooter/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_target.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/force_staff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_debuff_model.vpcf", context )

	
end

function Primary_Sharpshooter:Spawn()
	if not IsServer() then return end
end


function Primary_Sharpshooter:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = 8
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Sharpshooter", -- modifier name
		{
			duration = duration,
			x = point.x,
			y = point.y,
		} -- kv
	)
end


function Primary_Sharpshooter:OnProjectileThink_ExtraData( location, ExtraData )
	local sound = EntIndexToHScript( ExtraData.sound )
	if not sound or sound:IsNull() then return end
	sound:SetOrigin( location )
end

function Primary_Sharpshooter:OnProjectileHit_ExtraData( target, location, ExtraData )
	-- stop projectile sound
	local sound = EntIndexToHScript( ExtraData.sound )
	if not target then 
		if sound and not sound:IsNull() then
			local sound_projectile = "Hero_Hoodwink.Sharpshooter.Projectile"
			StopSoundOn( sound_projectile, sound )
			UTIL_Remove( sound )
		end
		return 
	end

	if not target then return end
	local caster = self:GetCaster()

	local chance = 0
	local damage = ExtraData.damage
	if caster:HasAbility("heroTalent_npc_dota_hero_hoodwink_2") then
		chance = 40
		damage = damage *1.4
	end
	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)

	-- modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Sharpshooter_debuff", -- modifier name
		{
			duration = ExtraData.duration,
			x = ExtraData.x,
			y = ExtraData.y
		} -- kv
	)

	-- overhead damage info
	SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		target,
		ExtraData.damage,
		self:GetCaster():GetPlayerOwner()
	)

	-- Vision
	AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetOrigin(), 300, 4, false)

	-- play effects
	local direction = Vector( ExtraData.x, ExtraData.y, 0 ):Normalized()
	self:PlayEffects( target, direction )

	if caster:GetRandomEffect(chance,INT_TYPE,0.5)  > RandomInt(1, 100) then
		return false
	end

	if sound and not sound:IsNull() then
		local sound_projectile = "Hero_Hoodwink.Sharpshooter.Projectile"
		StopSoundOn( sound_projectile, sound )
		UTIL_Remove( sound )
	end

	return true
end


function Primary_Sharpshooter:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf"
	local sound_cast = "Hero_Hoodwink.Sharpshooter.Target"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

modifier_Primary_Sharpshooter = class({})

function modifier_Primary_Sharpshooter:IsHidden()	return false end
function modifier_Primary_Sharpshooter:IsDebuff()	return false end
function modifier_Primary_Sharpshooter:IsPurgable()	return false end
function modifier_Primary_Sharpshooter:OnCreated( kv )
	-- references
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.team = self.parent:GetTeamNumber()

	self.charge = self.ability:GetSpecialValueFor( "max_charge_time" ) 
	self.damage = self.ability:GetSpecialValueFor( "max_damage" ) + self.ability:GetSpecialValueFor( "max_bonus_damage" ) * self.caster:GetDamageMax()
	self.duration = self.ability:GetSpecialValueFor( "max_slow_debuff_duration" )
	self.turn_rate = 60

	self.recoil_distance = 350
	self.recoil_duration = 0.4
	self.recoil_height = 75

	-- set interval on both cl and sv
	self.interval = 0.03 
	self:StartIntervalThink( self.interval )

	if not IsServer() then return end

	-- references
	self.projectile_speed = 2200
	self.projectile_range = 3000
	self.projectile_width = 125
	local projectile_vision = 350
	local projectile_name = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf"

	-- init turn logic
	local vec = Vector( kv.x, kv.y, 0 )
	self:SetDirection( vec )
	self.current_dir = self.target_dir
	self.face_target = true
	self.parent:SetForwardVector( self.current_dir )
	self.turn_speed = self.interval*self.turn_rate

	-- precache projectile
	self.info = {
		Source = self.parent,
		Ability = self.ability,
		-- vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

	    EffectName = projectile_name,
	    fDistance = self.projectile_range,
	    fStartRadius = self.projectile_width,
	    fEndRadius = self.projectile_width,
		-- vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = self.caster:GetTeamNumber()
	}


	-- play effects
	self:PlayEffects1()
	self:PlayEffects2()
end



function modifier_Primary_Sharpshooter:OnDestroy()
	if not IsServer() then return end
	if not self.caster:IsAlive() or self.ability:IsNull() then
		return
	end
	-- calculate direction
	local direction = self.current_dir

	-- calculate percentage
	local pct = math.min( self:GetElapsedTime(), self.charge )/self.charge

	-- Launch projectile
	self.info.vSpawnOrigin = self.parent:GetOrigin()
	self.info.vVelocity = direction * self.projectile_speed

	-- Create thinker for sound
	local sound = CreateModifierThinker(
		self.caster, -- player source
		self, -- ability source
		"", -- modifier name
		{}, -- kv
		self.caster:GetOrigin(),
		self.team,
		false
	)
	local sound_cast = "Hero_Hoodwink.Sharpshooter.Projectile"
	EmitSoundOn( sound_cast, sound )

	self.info.ExtraData = {
		damage = self.damage * pct,
		duration = self.duration * pct,
		x = direction.x,
		y = direction.y,
		sound = sound:entindex(),
	}
	ProjectileManager:CreateLinearProjectile( self.info )
	local target_pos = self.caster:GetOrigin() - direction*350
	local ani = ACT_DOTA_FLAIL
	if self.caster:GetModelName()=="models/heroes/hoodwink/hoodwink.vmdl" then
		ani = ACT_DOTA_CAST_ABILITY_4
	end
	local arc = self.caster:AddNewModifier(
		self.caster, -- player source
        self.ability, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			target_x = target_pos.x,
			target_y = target_pos.y,
			distance = CalculateDistance(self.caster,target_pos),
			duration =self.recoil_duration,
			height = self.recoil_height,
			fix_end = false,
			-- isForward = true,
            activity = ani,
			-- isRestricted = true,
		} -- kv
	)

	if arc then
		arc:SetEndCallback(function()
			if self.caster:GetModelName()=="models/heroes/hoodwink/hoodwink.vmdl" then
				self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
			else
				self.caster:StartGesture(ACT_DOTA_TELEPORT_END)
			end
	
		end)
	
		self:PlayEffects4( arc )
	end

end
-- Modifier Effects
function modifier_Primary_Sharpshooter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		-- MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end


function modifier_Primary_Sharpshooter:GetOverrideAnimation(params)
	if self:GetParent():GetUnitName()=="npc_dota_hero_hoodwink" then
		return ACT_DOTA_CHANNEL_ABILITY_6
	end
	return ACT_DOTA_GENERIC_CHANNEL_1
end
-- function modifier_Primary_Einherjar_ghost:GetActivityTranslationModifiers()	
-- 	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then
-- 		return "haste"
-- 	end

-- 	return "run_fast" 
-- end

function modifier_Primary_Sharpshooter:OnOrder( params )
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
		
		self:SetDirection( params.target:GetOrigin() )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:SafeDestroy()
	end
end

function modifier_Primary_Sharpshooter:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_Primary_Sharpshooter:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end

function modifier_Primary_Sharpshooter:GetModifierDisableTurning()
	return 1
end

-- Status Effects
function modifier_Primary_Sharpshooter:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

-- Interval Effects
function modifier_Primary_Sharpshooter:OnIntervalThink()
	if not IsServer() then
		-- client only code
		self:UpdateStack()
		return
	end

	-- turning logic
	self:TurnLogic()

	-- vision
	-- NOTE: Can be optimized if there's a way to move vision provider dynamically
	local startpos = self.parent:GetOrigin()
	local visions = self.projectile_range/self.projectile_width
	local delta = self.parent:GetForwardVector() * self.projectile_width
	for i=1,visions do
		AddFOWViewer( self.team, startpos, self.projectile_width, 0.1, false )
		startpos = startpos + delta
	end

	-- max charge sound
	if not self.charged and self:GetElapsedTime()>self.charge then
		self.charged = true

		-- play effects
		local sound_cast = "Hero_Hoodwink.Sharpshooter.MaxCharge"
		EmitSoundOnClient( sound_cast, self.parent:GetPlayerOwner() )
	end

	-- timer particle
	local remaining = self:GetRemainingTime()
	local seconds = math.ceil( remaining )
	local isHalf = (seconds-remaining)>0.5
	if isHalf then seconds = seconds-1 end

	if self.half~=isHalf then
		self.half = isHalf

		-- play effects
		self:PlayEffects3( seconds, isHalf )
	end

	-- update paticle
	self:UpdateEffect()
end

-- Helper
function modifier_Primary_Sharpshooter:SetDirection( vec )
	self.target_dir = ((vec-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.face_target = false
end

function modifier_Primary_Sharpshooter:TurnLogic()
	-- only rotate when target changed
	if self.face_target then return end

	local current_angle = VectorToAngles( self.current_dir ).y
	local target_angle = VectorToAngles( self.target_dir ).y
	local angle_diff = AngleDiff( current_angle, target_angle )

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*self.turn_speed then
		-- end rotating
		self.current_dir = self.target_dir
		self.face_target = true
	else
		-- rotate
		self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign*self.turn_speed, 0), self.current_dir )
	end

	-- set facing when not motion controlled
	local a = self.parent:IsCurrentlyHorizontalMotionControlled()
	local b = self.parent:IsCurrentlyVerticalMotionControlled()
	if not (a or b) then
		self.parent:SetForwardVector( self.current_dir )
	end
end

function modifier_Primary_Sharpshooter:UpdateStack()
	-- only update stack percentage on client to reduce traffic
	local pct = math.min( self:GetElapsedTime(), self.charge )/self.charge
	pct = math.floor( pct*100 )
	self:SetStackCount( pct )
end

-- Filter
function modifier_Primary_Sharpshooter:OrderFilter( data )
	if #data.units>1 then return true end

	local unit
	for _,id in pairs(data.units) do
		unit = EntIndexToHScript( id )
	end
	if unit~=self.parent then return true end

	if data.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	elseif data.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET or data.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		local pos = EntIndexToHScript( data.entindex_target ):GetOrigin()

		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
		data.position_x = pos.x
		data.position_y = pos.y
		data.position_z = pos.z
	end

	return true
end

-- Graphics & Animations
function modifier_Primary_Sharpshooter:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/sharpshooter/effect.vpcf"
	local sound_cast = "Hero_Hoodwink.Sharpshooter.Channel"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self.parent:GetOrigin(), -- unknown
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

function modifier_Primary_Sharpshooter:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_range_finder.vpcf"
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.parent:GetForwardVector() * self.projectile_range
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 0, startpos )
	ParticleManager:SetParticleControl( effect_cast, 1, endpos )
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	self.effect_cast = effect_cast
end

function modifier_Primary_Sharpshooter:PlayEffects3( seconds, half )
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf"
	local mid = 1
	if half then mid = 8 end

	local len = 2
	if seconds<1 then
		len = 1
		if not half then return end
	end
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, seconds, mid ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( len, 0, 0 ) )
end

function modifier_Primary_Sharpshooter:PlayEffects4( modifier )
	local particle_cast = "particles/items_fx/force_staff.vpcf"
	local sound_channel = "Hero_Hoodwink.Sharpshooter.Channel"
	local sound_cast = "Hero_Hoodwink.Sharpshooter.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )

	modifier:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	StopSoundOn( sound_channel, self.caster )
	EmitSoundOn( sound_cast, self.caster )
end

function modifier_Primary_Sharpshooter:UpdateEffect()
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.current_dir * self.projectile_range

	ParticleManager:SetParticleControl( self.effect_cast, 0, startpos )
	ParticleManager:SetParticleControl( self.effect_cast, 1, endpos )
end








modifier_Primary_Sharpshooter_debuff = class({})

function modifier_Primary_Sharpshooter_debuff:IsHidden()	return false end
function modifier_Primary_Sharpshooter_debuff:IsDebuff()	return true end
function modifier_Primary_Sharpshooter_debuff:IsStunDebuff()	return false end
function modifier_Primary_Sharpshooter_debuff:IsPurgable()	return true end
function modifier_Primary_Sharpshooter_debuff:OnCreated( kv )
	-- references
	self.parent = self:GetParent()

	self.slow = -self:GetAbility():GetSpecialValueFor( "slow_move_pct" )

	if not IsServer() then return end
	
	-- play effects
	local direction = Vector( kv.x, kv.y, 0 ):Normalized()
	self:PlayEffects( direction )
end



function modifier_Primary_Sharpshooter_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Primary_Sharpshooter_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end

function modifier_Primary_Sharpshooter_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end

function modifier_Primary_Sharpshooter_debuff:PlayEffects( direction )
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_debuff_model.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self.parent:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, direction )

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
