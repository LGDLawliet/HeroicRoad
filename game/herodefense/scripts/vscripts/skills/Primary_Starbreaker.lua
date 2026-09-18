Primary_Starbreaker = class({})
LinkLuaModifier( "modifier_Primary_Starbreaker", "skills/Primary_Starbreaker", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifier/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

function Primary_Starbreaker:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

function Primary_Starbreaker:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			-- register cursor position
			self.custom_indicator:Register( vLoc )
			-- print("diao yong")
		end
	end
	if not IsServer() then return end
	return UF_SUCCESS
end

function Primary_Starbreaker:CreateCustomIndicator()
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/hero_dawnbreaker_combo_strike_range_finder_aoe.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function Primary_Starbreaker:UpdateCustomIndicator( loc )
	-- get data
	local origin = self:GetCaster():GetAbsOrigin()
	local radius = self:GetSpecialValueFor( "smash_radius" )
	local speed = self:GetSpecialValueFor( "movement_speed" )
	local duration = self:GetSpecialValueFor( "duration" )
	local delta = self:GetSpecialValueFor( "smash_distance_from_hero" )
	local distance = speed * duration + delta

	-- get direction
	local direction = loc - origin
	direction.z = 0
	direction = direction:Normalized()

	ParticleManager:SetParticleControl( self.effect_cast, 0, origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, origin + direction*distance )
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector( radius, 0, 0 ) )
end

function Primary_Starbreaker:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

function Primary_Starbreaker:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- get direction
	local direction = point-caster:GetOrigin()
	if direction:Length2D()<1 then
		direction = caster:GetForwardVector()
	else
		direction.z = 0
		direction = direction:Normalized()
	end

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Starbreaker", -- modifier name
		{
			duration = duration,
			x = direction.x,
			y = direction.y,
		} -- kv
	)


end



function Primary_Starbreaker:TalentEffect(target)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Starbreaker", -- modifier name
		{
			duration = 0.01,
		}
	)
	if modifier then
		modifier:InitTalent(target)
	end
end

modifier_Primary_Starbreaker = class({})

require("internal/timers")

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Starbreaker:IsHidden()return true end
function modifier_Primary_Starbreaker:IsDebuff()return false end
function modifier_Primary_Starbreaker:IsPurgable()return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Starbreaker:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

	self.swipe_radius = self.ability:GetSpecialValueFor( "swipe_radius" )
	self.swipe_attack = self.ability:GetSpecialValueFor( "swipe_attack" )
	self.smash_radius = self.ability:GetSpecialValueFor( "smash_radius" )
	self.smash_attack = self.ability:GetSpecialValueFor( "smash_attack" )
	self.smash_duration = self.ability:GetSpecialValueFor( "smash_stun_duration" )
	self.smash_distance = self.ability:GetSpecialValueFor( "smash_distance_from_hero" )

	self.selfstun = self.ability:GetSpecialValueFor( "self_stun_duration" )
	self.speed = self.ability:GetSpecialValueFor( "movement_speed" )

	self.tree_radius = 100
	self.arc_height = 90
	self.arc_duration = 0.4

	if not IsServer() then return end
	if self.parent:HasAbility("heroTalent_npc_dota_hero_dawnbreaker_2") then
		self.smash_attack = self.smash_attack*1.3
		self.swipe_attack = self.swipe_attack*1.3

		self.dawn_talent  = true
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, nil, self.caster:GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, true, false )
	end
	self.attacks = self.ability:GetSpecialValueFor( "total_attacks" ) 
	self.attacks = math.min( 6, self.attacks )
	if self.dawn_talent then
		self.attacks = self.attacks + 1
	end

	if not kv.x then
		self.forward = self.caster:GetForwardVector()
		self.bonus = 0
		self.ctr = 0
		self.animation_rate = 1
		return
	end
	self.forward = Vector( kv.x, kv.y, 0 )
	self.bonus = 0
	self.ctr = 0
	local interval = self:GetDuration()/(self.attacks-1)-FrameTime()
	self.animation_rate = self:GetDuration()/interval

	self:ApplyHorizontalMotionController()
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end
function modifier_Primary_Starbreaker:InitTalent(target)
	self:Smash(target:GetOrigin())
	self:SafeDestroy()
end

function modifier_Primary_Starbreaker:GetOverrideAnimationRate()
	return self.animation_rate
end

function modifier_Primary_Starbreaker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SUPPRESS_CLEAVE,  --抑制分裂攻击
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function modifier_Primary_Starbreaker:GetModifierPreAttack_BonusDamage()
	if not IsServer() then return 0 end

	return self.bonus
end

function modifier_Primary_Starbreaker:GetSuppressCleave()
	return 1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Primary_Starbreaker:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,  --忽略指令
	}
	if self.dawn_talent then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	end

	return state
end

function modifier_Primary_Starbreaker:OnIntervalThink()
	-- if stunned, destroy
	if self.parent:IsStunned() then
		self:SafeDestroy()
		return
	end

	self.ctr = self.ctr + 1
	-- print("self.ctr ="..self.ctr .." self.attacks= "..self.attacks)
	if self.ctr>=self.attacks then
		self:Smash()
	else
		self:Swipe()
	end

	

	if self.ctr == self.attacks - 2 then
		-- self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		self:GetParent():StartGesture(ACT_DOTA_ATTACK)
	elseif self.ctr < self.attacks - 2 then
		self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	end

	-- if self.ctr==self.attacks then
	-- 	self:SafeDestroy()
	-- end

end

function modifier_Primary_Starbreaker:Swipe()
	if self.dawn_talent then
		self:Smash()
		return
	end
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.swipe_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}

	local attackEffectRecord =self.parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
	for _,enemy in pairs(enemies) do
		-- attack
		self.bonus = self.swipe_attack --额外伤害
		
		self.parent:PerformAttack( enemy, true, true, true, true, false, false, true )
	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	if #enemies>0 then
		local mod1 = self.parent:FindModifierByName( "modifier_Advanced_Luminosity" )
		local mod2 = self.parent:FindModifierByName( "modifier_Advanced_Luminosity_buff" )

		if mod2 then
			mod2:SafeDestroy()
		elseif mod1 then
			mod1:Increment()
		end
	end

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_Primary_Starbreaker:Smash(location)
	self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	local center = self.parent:GetOrigin() + self.forward*self.smash_distance
	if location then
		center = location
	end


	local search_radius = self.smash_radius
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		center,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		search_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}

	local attackEffectRecord =self.parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
	for _,enemy in pairs(enemies) do
		-- attack
		self.bonus = self.smash_attack
		self.parent:PerformAttack( enemy, true, true, true, true, false, false, true )
		if not enemy:IsMagicImmune() then
			--眩晕buff 调用了dota2内置的modifier
	
			local StatusResistance = enemy:GetHDStatusResistanceIndex(0.7) *ModifierStatusNegativeGain
			enemy:AddNewModifier(
				self.parent, -- player source
				self:GetAbility(), -- ability source
				"modifier_stunned", -- modifier name
				{ duration = self.smash_duration * StatusResistance } -- kv
			)
			--敌人浮空 
			enemy:AddNewModifier(
				self.parent, -- player source
				self:GetAbility(), -- ability source
				"modifier_generic_arc_lua", -- modifier name
				{
					duration = self.arc_duration,   --浮空时间 这里是0.4秒
					height = self.arc_height,       --浮空高度 这里是90
					activity = ACT_DOTA_FLAIL,      --复写的动作
				} -- kv
			)

		end
	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	if #enemies>0 then
		local mod1 = self.parent:FindModifierByName( "modifier_Advanced_Luminosity" )
		local mod2 = self.parent:FindModifierByName( "modifier_Advanced_Luminosity_buff" )

		if mod2 then
			mod2:SafeDestroy()
		elseif mod1 then
			mod1:Increment()
		end
	end

	self:PlayEffects3( center )
end

function modifier_Primary_Starbreaker:UpdateHorizontalMotion( me, dt )
	-- get forward pos
	local pos = me:GetOrigin() + self.forward * self.speed * dt

	-- if not traversable, stop
	if not GridNav:IsTraversable( pos ) then return end

	-- destroy trees
	GridNav:DestroyTreesAroundPoint( me:GetOrigin(), self.tree_radius, true )

	pos = GetGroundPosition( pos, me )
	me:SetOrigin( pos )
end

function modifier_Primary_Starbreaker:OnHorizontalMotionInterrupted()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_Starbreaker:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	DestroyParticleByDelay(effect_cast,3)
end

function modifier_Primary_Starbreaker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Fire_Wreath.Sweep"

	-- Get Data
	local forward = RotatePosition( Vector(0,0,0), QAngle( 0, -120, 0 ), self.forward )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 0, forward )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	EmitSoundOn( sound_cast, self.parent )
	DestroyParticleByDelay(effect_cast,3)
end

function modifier_Primary_Starbreaker:PlayEffects3( center )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_smash.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Fire_Wreath.Smash"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, center )
	DestroyParticleByDelay(effect_cast,8)

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )	
	self:GetParent():StartGestureFadeWithSequenceSettings(ACT_DOTA_CAST_ABILITY_1_END)


end

