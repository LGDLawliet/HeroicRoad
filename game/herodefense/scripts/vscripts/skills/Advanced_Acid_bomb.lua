Advanced_Acid_bomb = class({})
--特效优化 √
LinkLuaModifier( "modifier_Advanced_Acid_bomb_thinker", "skills/Advanced_Acid_bomb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Acid_bomb_debuff", "skills/Advanced_Acid_bomb", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_Acid_bomb_turret", "skills/Advanced_Acid_bomb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Acid_bomb_unlock3", "skills/Advanced_Acid_bomb", LUA_MODIFIER_MOTION_NONE )
function Advanced_Acid_bomb:Precache( context )
	PrecacheResource( "particle", "particles/new_effect/unit/brain_worm/acid_bomb/acid_bombsnapfire_lizard_blobs_arced.vpcf", context )
	PrecacheResource( "particle", "particles/new_effect/unit/brain_worm/acid_bomb/impact.vpcf", context )
	PrecacheResource( "particle", "particles/new_effect/unit/brain_worm/acid_bomb/imate_linger.vpcf", context )
	PrecacheResource( "particle", "particles/ui_mouseactions/range_finder_tp_dest.vpcf", context )
end

function Advanced_Acid_bomb:CheckKV(key)
	local table = {
		damage = 10,
		bonus_damage = 0.08,
	}
	local value = table[key] or -1
	return value

end

function Advanced_Acid_bomb:UnlockFirstCore(key)
	if self:GetAutoCastState() then
		self:ToggleAutoCast()
	end
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_Acid_bomb:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Acid_bomb:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Acid_bomb_unlock3",{})
	return true

end
function Advanced_Acid_bomb:GetBehavior()

	if self:GetCaster():HasModifier("modifier_Advanced_Acid_bomb_unlock3") then
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	if self:GetSpecialValueFor("advanced_level")>=20 then
		if self:GetUnlock(1)==1 then
			return DOTA_ABILITY_BEHAVIOR_POINT +DOTA_ABILITY_BEHAVIOR_AOE
	
		end
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST+DOTA_ABILITY_BEHAVIOR_AOE
	end
	return self.BaseClass.GetBehavior(self)

end



function Advanced_Acid_bomb:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Advanced_Acid_bomb:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator_new"
end




function Advanced_Acid_bomb:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end



	if not IsServer() then return end

	return UF_SUCCESS
end


function Advanced_Acid_bomb:CreateCustomIndicator()

	local particle_cast = "particles/ui_mouseactions/range_finder_tp_dest.vpcf"
	local count = 2
	if self:GetSpecialValueFor("advanced_level")>=5 then
		count = 4
	end
	self.particle_table ={}
	local radius = self:GetSpecialValueFor("radius")
	for i = 1, count, 1 do
		local particle = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( particle, 3, Vector(radius,0,0))
		table.insert(self.particle_table,particle)
	end
	-- self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	-- self.effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	-- local radius = self:GetSpecialValueFor("radius")
	-- ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(radius,0,0))
	-- ParticleManager:SetParticleControl( self.effect_cast2, 3, Vector(radius,0,0))
end


function Advanced_Acid_bomb:UpdateCustomIndicator( loc )
	-- get data

	local radius = self:GetSpecialValueFor( "radius" )
	local origin = loc + Vector(radius*2,0,0)

	local time = -self.custom_indicator:GetRemainingTime()
	-- print(time)
	local angle = time*20%360
	-- print(angle)
	
	local angle_per_particle = 360/#self.particle_table
	for i, particle in ipairs(self.particle_table) do
		local newpos = RotatePosition(loc, QAngle(0, angle+angle_per_particle*i, 0), origin)
		ParticleManager:SetParticleControl(particle, 2, newpos)
		ParticleManager:SetParticleControl(particle, 7, newpos)
	end


end

function Advanced_Acid_bomb:DestroyCustomIndicator()
	for i, particle in ipairs(self.particle_table) do
		-- local newpos = RotatePosition(loc, QAngle(0, angle+angle_per_particle*i, 0), origin)
		-- ParticleManager:SetParticleControl( self.effect_cast, 2, newpos)
		-- ParticleManager:SetParticleControl( self.effect_cast, 7, newpos)
		ParticleManager:DestroyParticle( particle, true ) 
	
		ParticleManager:ReleaseParticleIndex( particle )
	end
	-- ParticleManager:DestroyParticle( self.effect_cast, true ) 
	
	-- ParticleManager:ReleaseParticleIndex( self.effect_cast )
	-- ParticleManager:DestroyParticle( self.effect_cast2, true ) 
	
	-- ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
end



function Advanced_Acid_bomb:OnSpellStart()

	local loc = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "radius" )
	self:CastBomb(loc)
	local time = -self.custom_indicator:GetRemainingTime()
	local angle = time*20%360
	-- print(time)
	local origin = loc + Vector(radius*2,0,0)
	-- direction = direction:Normalized()
	local count = 2
	if self.advanced_level>=5 then
		count = 4
	end
	local angle_per_particle = 360/count
	-- for i, particle in ipairs(self.particle_table) do
	-- 	local newpos = RotatePosition(loc, QAngle(0, angle+angle_per_particle*i, 0), origin)
	-- 	ParticleManager:SetParticleControl(particle, 2, newpos)
	-- 	ParticleManager:SetParticleControl(particle, 7, newpos)
	-- end
	for i = 1, count, 1 do
		local newpos = RotatePosition(loc, QAngle(0, angle+angle_per_particle*i, 0), origin)
		self:CastBomb( newpos)
	end
	if self.advanced_level>=15 then
		local caster = self:GetCaster()
		local duration = 2 
		if self:GetAutoCastState() or self.unlock2 then
			duration = 4
		end
		-- if self.unlock1 then
		-- 	duration = -1
		-- end
		local modifier = caster:AddNewModifier(caster, self, "modifier_Advanced_Acid_bomb_turret", {
			duration = duration
		})
		modifier.target_pos = loc
	end

end

--------------------------------------------------------------------------------
-- Projectile
function Advanced_Acid_bomb:OnProjectileHit_ExtraData( target, location,ExtraData )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*self:GetSpecialValueFor("bonus_damage")
	damage = damage * (ExtraData.damage_index or 1)
	local duration =5
	if self.advanced_level>=10 then
		duration = 6.5
	end
	local impact_radius = self:GetSpecialValueFor("radius")


	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		impact_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end
	if self.unlock2 then
		duration = 1
	end

	-- start aura on thinker
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_Advanced_Acid_bomb_thinker", -- modifier name
		{
			duration = duration,
			damage_index = ExtraData.damage_index or 1,
		} -- kv
	)



	-- play effects
	self:PlayEffects( target:GetOrigin(),duration )
end

--------------------------------------------------------------------------------
function Advanced_Acid_bomb:PlayEffects( loc,duration )
	-- Get Resources
	local particle_cast = "particles/new_effect/unit/brain_worm/acid_bomb/impact.vpcf"
	local particle_cast2 = "particles/new_effect/unit/brain_worm/acid_bomb/imate_linger.vpcf"
	
	-- local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, duration, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(duration,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end


function Advanced_Acid_bomb:CastBomb(point,sub)
	local caster = self:GetCaster()
	local casterPos = caster:GetAbsOrigin()
	local vec = point-casterPos
	

	local travel_time = (vec:Length2D())/2000+0.3
	local speed= vec:Length2D()/travel_time

	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Acid_bomb_thinker", -- modifier name
		{ travel_time =travel_time }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	
	

	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))

	local damage_index = 1
	if sub then
		damage_index = 0.5
	end
	local info = {
		-- Target = target,
		-- vSpawnOrigin = attack_lock,
		-- Source = unit,

		Ability = self,	
		EffectName = "particles/new_effect/unit/brain_worm/acid_bomb/acid_bombsnapfire_lizard_blobs_arced.vpcf",
		iMoveSpeed = speed,
		bDodgeable = false,                           -- Optional
		Target = thinker,
		vSourceLoc = attack_lock,                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
		ExtraData =
		{
			damage_index = damage_index,
		}
	}

	local sound_cast = "Hero_Snapfire.MortimerBlob.Launch"
	EmitSoundOn( sound_cast, caster )

	-- launch projectile
	ProjectileManager:CreateTrackingProjectile( info )
end



function Advanced_Acid_bomb:CastBombUnlock2(point)
	self:CastBomb(point)
	local radius = self:GetSpecialValueFor( "radius" )
	local time = -self.custom_indicator:GetRemainingTime()
	local angle = time*20%360
	-- print(time)
	local origin = point + Vector(radius*2,0,0)

	local count = 4
	local angle_per_particle = 360/count
	-- for i, particle in ipairs(self.particle_table) do
	-- 	local newpos = RotatePosition(loc, QAngle(0, angle+angle_per_particle*i, 0), origin)
	-- 	ParticleManager:SetParticleControl(particle, 2, newpos)
	-- 	ParticleManager:SetParticleControl(particle, 7, newpos)
	-- end
	for i = 1, count, 1 do
		local newpos = RotatePosition(point, QAngle(0, angle+angle_per_particle*i, 0), origin)
		self:CastBomb( newpos)
	end
	local caster = self:GetCaster()
	if self:GetAutoCastState() then
		self:StartCooldown(self:GetCooldownTimeRemaining()+2)
		return
	end
	if caster:GetMana()>=200 then
		caster:SpendMana( 200, self )
	else
		self:StartCooldown(self:GetCooldownTimeRemaining()+2)
	end
end




modifier_Advanced_Acid_bomb_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Acid_bomb_thinker:OnCreated( kv )
	-- references
	self.max_travel = kv.travel_time
	self.radius =self:GetAbility():GetSpecialValueFor("radius")
	self.linger =self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end
	self:GetParent().damage_index = kv.damage_index or 1
	-- dont start aura right off
	self.start = false

	-- create aoe finder particle
	-- self:PlayEffects( kv.travel_time )
end

function modifier_Advanced_Acid_bomb_thinker:OnRefresh( kv )
	-- references
	self.max_travel= kv.travel_time
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.linger =self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end

	self:GetParent().damage_index = kv.damage_index or 1

	-- start aura
	self.start = true

	-- stop aoe finder particle
	-- self:StopEffects()
end

function modifier_Advanced_Acid_bomb_thinker:OnRemoved()
end

function modifier_Advanced_Acid_bomb_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_Advanced_Acid_bomb_thinker:IsAura()	return self.start end
function modifier_Advanced_Acid_bomb_thinker:GetModifierAura()	return "modifier_Advanced_Acid_bomb_debuff" end
function modifier_Advanced_Acid_bomb_thinker:GetAuraRadius()	return self.radius end
function modifier_Advanced_Acid_bomb_thinker:GetAuraDuration()	return self.linger end
function modifier_Advanced_Acid_bomb_thinker:GetAuraDuration() return 0.1 end
function modifier_Advanced_Acid_bomb_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Acid_bomb_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end




modifier_Advanced_Acid_bomb_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Acid_bomb_debuff:IsHidden()	return false end
function modifier_Advanced_Acid_bomb_debuff:IsDebuff()	return true end
function modifier_Advanced_Acid_bomb_debuff:IsStunDebuff()	return false end
function modifier_Advanced_Acid_bomb_debuff:IsPurgable()	return false end
function modifier_Advanced_Acid_bomb_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Acid_bomb_debuff:OnCreated( kv )
	-- references\
	if not self:GetAbility() then
		self.slow = 0
		return
	end
	local interval = 0.5
	local ability = self:GetAbility()
	self.slow = -ability:GetSpecialValueFor("move_slow")
	-- self.dps = ability:GetSpecialValueFor("damage_delay")*self:GetCaster():GetDamageMax()*interval
	local damage = ability:GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")

	if not IsServer() then return end
	local damage_index = self:GetAuraOwner().damage_index or 1
	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage*interval*damage_index*ability:GetSpecialValueFor("damage_per_tick")*0.01,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Acid_bomb_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_Acid_bomb_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Acid_bomb_debuff:OnIntervalThink()
	-- apply damage
	ApplyDamage( self.damageTable )

	-- play overhead
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_Acid_bomb_debuff:GetEffectName()
	return "particles/new_effect/unit/brain_worm/acid_bomb/hero_snapfire_burn_debuff.vpcf"
end

function modifier_Advanced_Acid_bomb_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_Advanced_Acid_bomb_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	-- [MODIFIER_STATE_SILENCED] = true
}

	return state
end



modifier_Advanced_Acid_bomb_turret = class({})

function modifier_Advanced_Acid_bomb_turret:IsDebuff() return false end
function modifier_Advanced_Acid_bomb_turret:IsHidden() return false end
function modifier_Advanced_Acid_bomb_turret:IsPurgable() return false end
function modifier_Advanced_Acid_bomb_turret:DestroyOnExpire() return not self.unlock1 end
function modifier_Advanced_Acid_bomb_turret:GetPriority() return 100000 end
function modifier_Advanced_Acid_bomb_turret:OnCreated(keys)
	local interval = 0.5
	if self:GetRemainingTime()>2 then
		interval = 0.4
		self.silence = true
	end
	if IsServer() then

		self:StartIntervalThink(interval)

	end
end

function modifier_Advanced_Acid_bomb_turret:OnIntervalThink()
	if not self.target_pos then
		return
	end
	local parnet = self:GetParent()
	local ability = self:GetAbility()
	parnet:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 3)
	if ability.unlock2 then
		ability:CastBombUnlock2( self.target_pos+Vector(RandomInt(-700, 700),RandomInt(-700, 700),0))
	else

		ability:CastBomb( self.target_pos+Vector(RandomInt(-700, 700),RandomInt(-700, 700),0),true)
	end

	

end

function modifier_Advanced_Acid_bomb_turret:CheckState()
	if self.unlock1 then
		return  {

			[MODIFIER_STATE_SILENCED] = true,

		}
	end
	if self.silence then
		return  {
			-- [MODIFIER_STATE_PASSIVES_DISABLED] = true,
			[MODIFIER_STATE_SILENCED] = true
		}
		
	end
	
	return {
		-- [MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
end

function modifier_Advanced_Acid_bomb_turret:DeclareFunctions()
	local funcs = {
	
	}
	if self:GetAbility():GetUnlock(1)==1 then
		self.unlock1 = true
		table.insert(funcs,MODIFIER_EVENT_ON_ORDER)
		table.insert(funcs,MODIFIER_PROPERTY_MOVESPEED_LIMIT)
	end
	return funcs
end
function modifier_Advanced_Acid_bomb_turret:OnOrder(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() then

		if 	keys.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
			self.target_pos= keys.new_pos 
		elseif 
			keys.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
			keys.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
		then
			self.target_pos=  keys.target:GetOrigin() 
		end
		if keys.order_type==DOTA_UNIT_ORDER_HOLD_POSITION or keys.order_type==DOTA_UNIT_ORDER_STOP   then
			self:SafeDestroy()
			return
		end


	end
end
function modifier_Advanced_Acid_bomb_turret:GetModifierMoveSpeed_Limit()
	return 0.1
end



modifier_Advanced_Acid_bomb_unlock3 = class({})


function modifier_Advanced_Acid_bomb_unlock3:IsHidden()	return true end
function modifier_Advanced_Acid_bomb_unlock3:IsDebuff()	return false end
function modifier_Advanced_Acid_bomb_unlock3:IsStunDebuff()	return false end
function modifier_Advanced_Acid_bomb_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_Acid_bomb_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_Acid_bomb_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Acid_bomb_unlock3:IsPurgeException() 	return false end

function modifier_Advanced_Acid_bomb_unlock3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Acid_bomb_unlock3:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local caster = self:GetParent()
	if not caster:IsRangedAttacker() then
		return
	end
	if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
		return
	end
	if not keys.target or keys.target:IsNull() then
		return
	end
	if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
		return
	end
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
	if ability:GetAutoCastState() then
		if caster:GetMana()>=300 then
			caster:SpendMana( 300, self )
			ability:CastBomb(keys.target:GetOrigin(),false)
			ability:StartCooldown(0.4)
			return
		end
	end
	if self:GetCaster():GetRandomEffect(10,INT_TYPE,1)  > RandomInt(1, 100) then
		ability:CastBomb(keys.target:GetOrigin(),false)
		ability:StartCooldown(0.4)

	end

	
end