--特效优化 √
Advanced_Sharpshooter = class({})
LinkLuaModifier("modifier_generic_arc_lua", "modifier/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_Advanced_Sharpshooter", "skills/Advanced_Sharpshooter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Sharpshooter_debuff", "skills/Advanced_Sharpshooter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Sharpshooter_second", "skills/Advanced_Sharpshooter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Sharpshooter_unlock3", "skills/Advanced_Sharpshooter", LUA_MODIFIER_MOTION_NONE)


function Advanced_Sharpshooter:CheckKV(key)
	local table = {
		max_damage=80,
		max_bonus_damage = 0.2,



	}
	local value = table[key] or -1
	return value

end

function Advanced_Sharpshooter:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_Sharpshooter:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Sharpshooter:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Sharpshooter_unlock3",{})
	return true

end


function Advanced_Sharpshooter:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/sharpshooter/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_target.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/force_staff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_debuff_model.vpcf", context )

	
end

function Advanced_Sharpshooter:Spawn()
	if not IsServer() then return end
end


function Advanced_Sharpshooter:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = 8
	if self.unlock1 then
		duration = 0.02
	end
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Sharpshooter", -- modifier name
		{
			duration = duration,
			x = point.x,
			y = point.y,
		} -- kv
	)
end


function Advanced_Sharpshooter:OnProjectileThink_ExtraData( location, ExtraData )
	local sound = EntIndexToHScript( ExtraData.sound )
	if not sound or sound:IsNull() then return end
	sound:SetOrigin( location )
end

function Advanced_Sharpshooter:OnProjectileHit_ExtraData( target, location, ExtraData )
	-- stop projectile sound
	local sound = EntIndexToHScript( ExtraData.sound )

	-- if not sound or sound:IsNull() then return end
	if not target then 
		if sound and not sound:IsNull() then
			local sound_projectile = "Hero_Hoodwink.Sharpshooter.Projectile"
			StopSoundOn( sound_projectile, sound )
			UTIL_Remove( sound )
		end
		return 
	end
	local caster = self:GetCaster()
	-- self.ability:GetSpecialValueFor( "max_damage" ) + self.ability:GetSpecialValueFor( "max_bonus_damage" ) * self.caster:GetDamageMax()
	local damage_index =  self:GetSpecialValueFor( "max_bonus_damage" )
	local bonus_damage_index_all = ExtraData.bonus_damage
	if self.advanced_level>=5 then
		bonus_damage_index_all = ExtraData.bonus_damage+0.2
	end
	bonus_damage_index_all =  math.min(math.max(bonus_damage_index_all,0),1)
	local bonus_damage_index = damage_index * (1-bonus_damage_index_all)
	local damage = self:GetSpecialValueFor( "max_damage" ) + bonus_damage_index* caster:GetDamageMax() + caster:GetAverageTrueAttackDamage(nil)*damage_index*bonus_damage_index_all
	local chance = 0

	local chance = 0
	if caster:HasAbility("heroTalent_npc_dota_hero_hoodwink_2") then
		chance = 40
		damage = damage *1.4
		if self.advanced_level>=15 then
			chance = 80
		end
	end

	

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage*ExtraData.damage_pct,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)

	-- modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Sharpshooter_debuff", -- modifier name
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
		damage*ExtraData.damage_pct,
		self:GetCaster():GetPlayerOwner()
	)

	-- Vision
	AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetOrigin(), 300, 4, false)

	-- play effects
	local direction = Vector( ExtraData.x, ExtraData.y, 0 ):Normalized()
	self:PlayEffects( target, direction )




	if self.unlock1 then
		return false
	end
	if ExtraData.second==1 then
		chance = chance *0.5
		if chance>=RandomInt(1, 100) then
			return false
		end
	else
		if caster:GetRandomEffect(chance,INT_TYPE,0.5)  > RandomInt(1, 100) then
			return false
		end
	end
	if sound and not sound:IsNull() then
		local sound_projectile = "Hero_Hoodwink.Sharpshooter.Projectile"
		StopSoundOn( sound_projectile, sound )
		UTIL_Remove( sound )
	end

	return true
end


function Advanced_Sharpshooter:PlayEffects( target, direction )
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

modifier_Advanced_Sharpshooter = class({})

function modifier_Advanced_Sharpshooter:IsHidden()	return false end
function modifier_Advanced_Sharpshooter:IsDebuff()	return false end
function modifier_Advanced_Sharpshooter:IsPurgable()	return false end
function modifier_Advanced_Sharpshooter:OnCreated( kv )
	-- references
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.team = self.parent:GetTeamNumber()

	self.charge = self.ability:GetSpecialValueFor( "max_charge_time" ) 
	if self.ability:GetSpecialValueFor("advanced_level")>=20 then
		self.charge = self.charge *0.5
		self.lv20 = true
		if self.ability:GetUnlock(1)==1 then
			self.charge = 0.01
			self.unlock1 = true
		end
	
	end
	-- self.damage = self.ability:GetSpecialValueFor( "max_damage" ) + self.ability:GetSpecialValueFor( "max_bonus_damage" ) * self.caster:GetDamageMax()
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



function modifier_Advanced_Sharpshooter:OnDestroy()
	if not IsServer() then return end

	if not self.caster:IsAlive() or self.ability:IsNull() then
		return
	end
	-- calculate direction
	local direction = self.current_dir

	-- calculate percentage
	local bonus_damage = (self:GetElapsedTime()-self:GetElapsedTime()%1)*0.06
	if self.lv20 then
		bonus_damage =  math.min((self:GetElapsedTime()-self:GetElapsedTime()%1)*0.12,0.48)
	end
	if self.unlock1 then
		bonus_damage = 0.48
	end
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
		damage_pct = pct,
		bonus_damage = bonus_damage,
		duration = self.duration * pct,
		x = direction.x,
		y = direction.y,
		sound = sound:entindex(),
		second = 0,
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
	
			if self.caster:IsAlive() and not self.unlock1 then
				local second_modifier = self.caster:AddNewModifier(
					self.caster,
					self.ability,
					"modifier_Advanced_Sharpshooter_second",
					{
						duration = 3
					} 
				)
				if second_modifier then
					second_modifier:InitEffect(direction,pct,bonus_damage)
				end
			end
		end)
	
		self:PlayEffects4( arc )
	end
	
end
-- Modifier Effects
function modifier_Advanced_Sharpshooter:DeclareFunctions()
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


function modifier_Advanced_Sharpshooter:GetOverrideAnimation(params)
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

function modifier_Advanced_Sharpshooter:OnOrder( params )
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

function modifier_Advanced_Sharpshooter:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_Advanced_Sharpshooter:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end

function modifier_Advanced_Sharpshooter:GetModifierDisableTurning()
	return 1
end

-- Status Effects
function modifier_Advanced_Sharpshooter:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

-- Interval Effects
function modifier_Advanced_Sharpshooter:OnIntervalThink()
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
function modifier_Advanced_Sharpshooter:SetDirection( vec )
	self.target_dir = ((vec-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.face_target = false
end

function modifier_Advanced_Sharpshooter:TurnLogic()
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

function modifier_Advanced_Sharpshooter:UpdateStack()
	-- only update stack percentage on client to reduce traffic
	local pct = math.min( self:GetElapsedTime(), self.charge )/self.charge
	pct = math.floor( pct*100 )
	self:SetStackCount( pct )
end

-- Filter
function modifier_Advanced_Sharpshooter:OrderFilter( data )
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
function modifier_Advanced_Sharpshooter:PlayEffects1()
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

function modifier_Advanced_Sharpshooter:PlayEffects2()
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

function modifier_Advanced_Sharpshooter:PlayEffects3( seconds, half )
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

function modifier_Advanced_Sharpshooter:PlayEffects4( modifier )
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

function modifier_Advanced_Sharpshooter:UpdateEffect()
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.current_dir * self.projectile_range

	ParticleManager:SetParticleControl( self.effect_cast, 0, startpos )
	ParticleManager:SetParticleControl( self.effect_cast, 1, endpos )
end








modifier_Advanced_Sharpshooter_debuff = class({})

function modifier_Advanced_Sharpshooter_debuff:IsHidden()	return false end
function modifier_Advanced_Sharpshooter_debuff:IsDebuff()	return true end
function modifier_Advanced_Sharpshooter_debuff:IsStunDebuff()	return false end
function modifier_Advanced_Sharpshooter_debuff:IsPurgable()	return true end
function modifier_Advanced_Sharpshooter_debuff:OnCreated( kv )
	-- references
	self.parent = self:GetParent()

	self.slow = -self:GetAbility():GetSpecialValueFor( "slow_move_pct" )

	if not IsServer() then return end
	
	-- play effects
	local direction = Vector( kv.x, kv.y, 0 ):Normalized()
	self:PlayEffects( direction )
end



function modifier_Advanced_Sharpshooter_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_Sharpshooter_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end

function modifier_Advanced_Sharpshooter_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end

function modifier_Advanced_Sharpshooter_debuff:PlayEffects( direction )
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










modifier_Advanced_Sharpshooter_second = class({})

function modifier_Advanced_Sharpshooter_second:IsHidden()	return true end
function modifier_Advanced_Sharpshooter_second:IsDebuff()	return false end
function modifier_Advanced_Sharpshooter_second:IsPurgable()	return false end
function modifier_Advanced_Sharpshooter_second:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Sharpshooter_second:InitEffect( direction,pct,bonus_damage,unlock3 )
	if not IsServer() then return end
	self.dir = direction
	self.pct = pct
	self.bonus_damage = bonus_damage
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not self.ability then
		return
	end
	self.team = self.parent:GetTeamNumber()

	self.charge = self.ability:GetSpecialValueFor( "max_charge_time" ) 
	self.duration = self.ability:GetSpecialValueFor( "max_slow_debuff_duration" )
	self:StartIntervalThink( 0.1 )
	-- references
	self.projectile_speed = 2200
	self.projectile_range = 3000
	self.projectile_width = 125
	local projectile_vision = 350
	local projectile_name = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf"
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

	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = self.caster:GetTeamNumber()
	}
	self.count = 2
	self.dispersed = 300
	self.distance_back = 170
	self.delay_duration = 0.2
	self.height = 128
	if self.ability.advanced_level>=10 then
		self.count = 3
		if self.ability.unlock2 then
			self.count = 8
			self.distance_back = 75
			self.height = 50
			self.delay_duration = 0.1
		end
	end
	if unlock3 then
		self.distance_back = 34
		self.height = 36
		self.delay_duration = 0.05
		self:StartIntervalThink( 0.03 )
	end
end


function modifier_Advanced_Sharpshooter_second:OnIntervalThink()
	if not self.caster:IsAlive() or self.ability:IsNull() then
		return
	end
	self:StartIntervalThink(-1)
	self.count = self.count - 1
	local direction =self.dir
	local new_target_pos = self.caster:GetOrigin()+direction*2200 + Vector(RandomInt(-self.dispersed, self.dispersed),RandomInt(-self.dispersed, self.dispersed),0)
	direction = -CalculateDirection(self.caster:GetOrigin(),new_target_pos)
	local pct = self.pct
	local bonus_damage = self.bonus_damage
	local second_pct = 0.3
	if self.ability.unlock2 then
		second_pct = 0.5
	end
	pct = pct * second_pct
	
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
		damage_pct = pct,
		bonus_damage = bonus_damage,
		duration = self.duration * pct,
		x = direction.x,
		y = direction.y,
		second = 1,
		sound = sound:entindex(),
	}
	ProjectileManager:CreateLinearProjectile( self.info )
	local target_pos = self.caster:GetOrigin() - direction*self.distance_back
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
			duration =self.delay_duration,
			height = self.height,
			fix_end = false,
            activity = ani,
		} 
	)

	if arc then
		arc:SetEndCallback(function()
			if self.caster:GetModelName()=="models/heroes/hoodwink/hoodwink.vmdl" then
				self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
			else
				self.caster:StartGesture(ACT_DOTA_TELEPORT_END)
			end
			if self.count>=1 then
				self:OnIntervalThink()
			end
	
		end)
	end
	


end















modifier_Advanced_Sharpshooter_unlock3 = class({})


function modifier_Advanced_Sharpshooter_unlock3:IsHidden()	return false end
function modifier_Advanced_Sharpshooter_unlock3:IsDebuff()	return false end
function modifier_Advanced_Sharpshooter_unlock3:IsStunDebuff()	return false end
function modifier_Advanced_Sharpshooter_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_Sharpshooter_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_Sharpshooter_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Sharpshooter_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Sharpshooter_unlock3:OnCreated()
	if IsServer() then
		self.team = self:GetParent():GetTeamNumber()
		self.projectile_speed = 2200
		local projectile_range = 3000
		local projectile_width = 125
		local projectile_vision = 350
		self.duration = self:GetAbility():GetSpecialValueFor( "max_slow_debuff_duration" )
		local projectile_name = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf"
	
		self.info = {
			Source = self:GetParent(),
			Ability = self:GetAbility(),
			-- vSpawnOrigin = caster:GetAbsOrigin(),
			
			bDeleteOnHit = true,
			
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	
			EffectName = projectile_name,
			fDistance = projectile_range,
			fStartRadius = projectile_width,
			fEndRadius = projectile_width,
			-- vVelocity = projectile_direction * projectile_speed,
		
			bHasFrontalCone = false,
			bReplaceExisting = false,
			
			bProvidesVision = true,
			iVisionRadius = projectile_vision,
			iVisionTeamNumber = self:GetParent():GetTeamNumber()
		}
	end
end
function modifier_Advanced_Sharpshooter_unlock3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Sharpshooter_unlock3:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	
	local caster = self:GetParent()
	if self:GetCaster():GetRandomEffect(3,INT_TYPE,1)  > RandomInt(1, 100) then
		if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
			return
		end
		local cooldown =self:GetRemainingTime()
		if cooldown>=3 then
			return
		end
		self:SetDuration(math.max(cooldown+0.8,0.8), true)
		local ability = self:GetAbility()



		local direction = caster:GetForwardVector()

		-- calculate percentage
		-- local bonus_damage = 8*0.06*0.4
		local bonus_damage = 0.192
		local pct = 0.4
	
		
		-- Launch projectile
		self.info.vSpawnOrigin =caster:GetOrigin()
		self.info.vVelocity = direction * self.projectile_speed
	
		-- Create thinker for sound
		local sound = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"", -- modifier name
			{}, -- kv
			caster:GetOrigin(),
			self.team,
			false
		)
		local sound_cast = "Hero_Hoodwink.Sharpshooter.Projectile"
		EmitSoundOn( sound_cast, sound )
	
		self.info.ExtraData = {
			damage_pct = pct,
			bonus_damage = bonus_damage,
			duration = self.duration * pct,
			x = direction.x,
			y = direction.y,
			sound = sound:entindex(),
			second = 0,
		}
		ProjectileManager:CreateLinearProjectile( self.info )
		local target_pos = caster:GetOrigin() - direction*64
		local ani = ACT_DOTA_FLAIL
		if caster:GetModelName()=="models/heroes/hoodwink/hoodwink.vmdl" then
			ani = ACT_DOTA_CAST_ABILITY_4
		end
		local arc = caster:AddNewModifier(
			caster, -- player source
			ability, -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				target_x = target_pos.x,
				target_y = target_pos.y,
				distance = CalculateDistance(caster,target_pos),
				duration =0.15,
				height = 64,
				fix_end = false,
				-- isForward = true,
				activity = ani,
				-- isRestricted = true,
			} -- kv
		)
	
		if arc then
			arc:SetEndCallback(function()
				if caster:GetModelName()=="models/heroes/hoodwink/hoodwink.vmdl" then
					caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4_END,3)
				else
					caster:StartGestureWithPlaybackRate(ACT_DOTA_TELEPORT_END,3)
				end
		
				if caster:IsAlive() then
					local second_modifier = caster:AddNewModifier(
						caster,
						ability,
						"modifier_Advanced_Sharpshooter_second",
						{
							duration = 3
						} 
					)
					if second_modifier then
						second_modifier:InitEffect(direction,pct,bonus_damage,true)
					end
				end
			end)
		

		end

	end

	
end