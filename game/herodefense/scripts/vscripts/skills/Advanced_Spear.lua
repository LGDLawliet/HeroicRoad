--特效优化 √
--------------------------------------------------------------------------------
Advanced_Spear = class({})

LinkLuaModifier( "modifier_Advanced_Spear", "skills/Advanced_Spear", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_Advanced_Spear_War_ghost", "skills/Advanced_Spear", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Spear_aftermove", "skills/Advanced_Spear", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function Advanced_Spear:CheckKV(key)
	local table = {
		damage=11,
		bonus_damage=0.11,
	}
	local value = table[key] or -1
	return value

end
function Advanced_Spear:UnlockFirstCore(key)
	return true
end
function Advanced_Spear:UnlockSecondCore(key)
	return true
end
function Advanced_Spear:UnlockThirdCore(key)
	return false
end
function Advanced_Spear:GetCastAnimation()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_mars" then
		return ACT_DOTA_CAST_ABILITY_5
	end
	return ACT_DOTA_ATTACK
end
function Advanced_Spear:Precache( context )
	PrecacheResource( "model", "models/heroes/mars/mars_spear.vmdl", context )
	PrecacheResource( "model", "models/items/mars/mars_arena_champion_legs/mars_arena_champion_legs.vmdl", context )
	PrecacheResource( "model", "models/items/mars/mars_blackstone_ares_off_hand/mars_blackstone_ares_off_hand.vmdl", context )
	PrecacheResource( "particle", "particles/econ/items/mars/mars_blackstone_ares/mars_blackstone_ares_shield.vpcf", context )
	PrecacheResource( "model", "models/items/mars/mars_arena_champion_armor/mars_arena_champion_armor.vmdl", context )
	PrecacheResource( "particle", "particles/econ/items/mars/mars_fall20_arena_champion/mars_fall20_arena_champion_armor_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/ui_mouseactions/range_finder_tp_dest.vpcf", context )
end

function Advanced_Spear:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function Advanced_Spear:CreateCustomIndicator()
	local radius = self:GetSpecialValueFor("radius")
	local particle_cast = "particles/ui_mouseactions/range_finder_tp_dest.vpcf"
	self.particle = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.particle, 3, Vector(radius,0,0))
end


function Advanced_Spear:UpdateCustomIndicator( loc )
	-- local radius = 400
	local origin = self:GetCaster():GetAbsOrigin()
	local distance = self:GetSpecialValueFor("spear_range")

	-- get direction
	local direction = loc - origin
	direction.z = 0
	direction = direction:Normalized()
	local newpos = origin + direction*distance
	ParticleManager:SetParticleControl( self.particle, 2, newpos)
	ParticleManager:SetParticleControl( self.particle, 7, newpos)


end

function Advanced_Spear:DestroyCustomIndicator()
	ParticleManager:DestroyParticle(  self.particle, true ) 
	ParticleManager:ReleaseParticleIndex(  self.particle )
end

function Advanced_Spear:IsHiddenWhenStolen()return false end
function Advanced_Spear:IsStealable()return true end
function Advanced_Spear:IsNetherWardStealable()return true end
function Advanced_Spear:IsRefreshable()return true end
--------------------------------------------------------------------------------
-- Ability Start
function Advanced_Spear:OnSpellStart()
	if not IsServer() then
		return
	end
	self.auto = 0
	if self:GetAutoCastState() then
		self.auto = 1
	end
	-- unit identifier
	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	local point = self:GetCursorPosition()
	if point==caster_loc then
		point = point +caster:GetForwardVector()
	end
	point.z = caster_loc.z
	-- load data
	local projectile_name = "particles/units/heroes/hero_mars/mars_spear.vpcf"
	local projectile_distance = self:GetSpecialValueFor("spear_range") 
	local projectile_speed = self:GetSpecialValueFor("spear_speed") + self:GetSpecialValueFor("spear_speed")*(self:GetSpecialValueFor("length_up_auto")*0.01-1)*self.auto
	local projectile_radius = self:GetSpecialValueFor("spear_width")
	self.bonus_hp_damage = 0


	-- calculate direction
	local direction = point - caster_loc
	direction.z = 0
	direction = direction:Normalized()


	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster_loc,

	    bDeleteOnHit = false,

	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius =projectile_radius,
		vVelocity = direction * projectile_speed,

		bHasFrontalCone = false,
		bReplaceExisting = false,
		-- fExpireTime = GameRules:GetGameTime() + 10.0,

		bProvidesVision = true,
		iVisionRadius = true,
		fVisionDuration = 10,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	ProjectileManager:CreateLinearProjectile(info)

	--LV15解锁喜加一
	--新LV15轻灵连掷
	if self.advanced_level>=15 then
		Timers:CreateTimer(0.15, function()
			ProjectileManager:CreateLinearProjectile(info)
			--DeepPrintTable(info)  --看看里面都有啥
			-- play effects
			local sound_cast = "Hero_Mars.Spear.Cast"
			EmitSoundOn( sound_cast, caster )
			local sound_cast = "Hero_Mars.Spear"
			EmitSoundOn( sound_cast, caster )
		end)
		local ability = self:GetCaster():FindAbilityByName("Default_Move")
		if not ability:IsCooldownReady() then
			ability:EndCooldown()
		end
	end
	if self.unlock1 then
		-- local direction 	= (point - caster_loc):Normalized()
		local new_caster_pos1 = RotatePosition(caster_loc, QAngle(0, 90, 0), point) 
		local new_caster_pos2 = RotatePosition(caster_loc, QAngle(0, -90, 0), point) 
		local new_dir_1 = (new_caster_pos1 - caster_loc):Normalized()
		local new_dir_2 = (new_caster_pos2 - caster_loc):Normalized()
		for i = 1, 3, 1 do
			local new_pos = caster_loc+new_dir_1 * i*projectile_radius
			-- local new_target_pos = new_pos + direction * projectile_distance
			-- local new_dir = (new_target_pos - new_pos):Normalized()
			-- self:SpawnMars(new_pos,new_dir)
			info.vSpawnOrigin = new_pos
			ProjectileManager:CreateLinearProjectile(info)
			
		end
		for i = 1, 3, 1 do
			local new_pos = caster_loc+new_dir_2 * i*projectile_radius
			-- local new_target_pos = new_pos + direction * projectile_distance
			-- local new_dir = (new_target_pos - new_pos):Normalized()
			-- self:SpawnMars(new_pos,new_dir)
			info.vSpawnOrigin = new_pos
			ProjectileManager:CreateLinearProjectile(info)
			
		end
	end
	info.vSpawnOrigin = caster_loc

	if self.unlock2 then
		Timers:CreateTimer(1.15, function()
			self:Unlock2Effect(caster_loc,direction,2)
		end)
	end


end

function Advanced_Spear:Unlock2Effect(pos,dir,count)
	local projectile_distance = self:GetSpecialValueFor("spear_range")

	local new_pos = pos + dir * projectile_distance
	local ability = self
	local unit = self:SpawnMars(new_pos,-dir)
	Timers:CreateTimer(0.25, function()
		local projectile_radius = ability:GetSpecialValueFor("spear_width")
		local projectile_name = "particles/units/heroes/hero_mars/mars_spear.vpcf"
		local info = {
			Source = ability:GetCaster(),
			Ability = ability,
			vSpawnOrigin = new_pos,
	
			bDeleteOnHit = false,
	
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	
			EffectName = projectile_name,
			fDistance = projectile_distance,
			fStartRadius = projectile_radius,
			fEndRadius =projectile_radius,
			vVelocity = -dir * ability:GetSpecialValueFor("spear_speed"),
	
			bHasFrontalCone = false,
			bReplaceExisting = false,
			-- fExpireTime = GameRules:GetGameTime() + 10.0,
	
			bProvidesVision = true,
			iVisionRadius = true,
			fVisionDuration = 10,

		}

	
		ProjectileManager:CreateLinearProjectile(info)
		local sound_cast = "Hero_Mars.Spear.Cast"
		EmitSoundOn( sound_cast,  unit)
		local sound_cast = "Hero_Mars.Spear"
		EmitSoundOn( sound_cast, unit )
		if count>0 then
			Timers:CreateTimer(0.8, function()
				ability:Unlock2Effect(new_pos,-dir,count-1)
			end)
		end
	end)
end



--储存投掷物
local mars_projectiles = {}
function mars_projectiles:Init( projectileID )
	self[projectileID] = {}

	-- set location
	self[projectileID].location = ProjectileManager:GetLinearProjectileLocation( projectileID ) 
	self[projectileID].init_pos = self[projectileID].location  --储存当前坐标

	-- set direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectileID )
	direction.z = 0
	direction = direction:Normalized()
	self[projectileID].direction = direction  --储存当前方向
end

function mars_projectiles:Destroy( projectileID ) --移除投掷物

	if not IsServer() then
		return
	end
	--新LV10战神步伐
	local modifier_lv10 = self[projectileID].ability:GetCaster():FindModifierByName("modifier_Advanced_Spear_aftermove")
	if self[projectileID].ability.advanced_level>=10 and modifier_lv10 then
		self[projectileID].ability:GetCaster():RemoveModifierByName("modifier_Advanced_Spear_aftermove")
	end
	--新高阶效果：自动铁矛
	if self[projectileID].ability:GetAutoCastState() then
		return
	end
		local damage = self[projectileID].ability:GetSpecialValueFor("fire_damage")
		local radius = self[projectileID].ability:GetSpecialValueFor("radius")
		local stun_duration = self[projectileID].ability:GetSpecialValueFor("stun_duration")

		--LV5解锁淬火烈矛+
		--新LV5烈性火矛+
		if self[projectileID].ability.advanced_level>=5 then
			damage = damage + 2
		end
		local enemies = FindUnitsInRadius(
		    self[projectileID].caster:GetTeamNumber(),	-- int, your team number
			self[projectileID].location,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE 用了everywhere就是全图单位
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter 或者从远到近，或者随机单位
			false	-- bool, can grow cache
		)
		local damageTable = {
			-- victim = target,
			attacker = self[projectileID].caster,
			damage = damage*self[projectileID].caster:GetStrength(),
			damage_type = self[projectileID].ability:GetAbilityDamageType(),
			ability = self[projectileID].ability, --Optional.
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		}
		-- print("damage= "..damageTable.damage)
		for _, unit in ipairs(enemies) do
			damageTable.victim = unit
			ApplyDamage( damageTable)
			
			local ModifierStatusNegativeGain = self[projectileID].caster:GetModifierStatusNegativeGainIndex()
			local StatusResistance = unit:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
			unit:AddNewModifier(
			self[projectileID].caster, -- player source
			self[projectileID].ability, -- ability source
			"modifier_stunned", -- modifier name
			{
				duration = stun_duration*StatusResistance,
			} -- kv
			)
		end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self[projectileID].location)
		-- ParticleManager:SetParticleControl(pfx, 60, Vector(8,229,96))
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius,radius,radius))
		ParticleManager:SetParticleControl(pfx, 3, self[projectileID].location)
		-- ParticleManager:SetParticleControl(pfx, 61, Vector(300,300,300))
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitAnnouncerSoundForTeamOnLocation("Hero_Snapfire.Shotgun.Fire",self[projectileID].caster:GetTeamNumber(), self[projectileID].location)
	    self[projectileID] = nil
end
Advanced_Spear.projectiles = mars_projectiles

-- projectile hit
function Advanced_Spear:OnProjectileHitHandle( target, location, iProjectileHandle )
	-- init in case it isn't initialized from below (if projectile launched very close to target)
	if not self.projectiles[iProjectileHandle] then
		self.projectiles:Init( iProjectileHandle )
	end

	if not target then
		-- destroy data
		self.projectiles:Destroy( iProjectileHandle )
		return
	end
	local damage = self:GetSpecialValueFor("damage")+ (self:GetSpecialValueFor("bonus_damage"))*self:GetCaster():GetBaseDamageMax() + self.bonus_hp_damage 
	--新高阶效果：自动铁矛
	
	if self:GetAutoCastState() then
		local turn_damage =  self:GetSpecialValueFor("fire_damage")*self:GetSpecialValueFor("turn_auto")*0.01
		if self.advanced_level>=5 then
			turn_damage = turn_damage*2
		end

		damage = self:GetSpecialValueFor("damage")+ (self:GetSpecialValueFor("bonus_damage"))*self:GetCaster():GetBaseDamageMax() + self.bonus_hp_damage + turn_damage*self:GetCaster():GetBaseDamageMax()
	end
	--新LV10战神步伐
	local modifier_lv10 = self:GetCaster():FindModifierByName("modifier_Advanced_Spear_aftermove")
	if self.advanced_level>=10 and modifier_lv10 then
		damage = damage * 1.35
	end
	-----------------------------------------------------------------------------------------------------------------------
	-- 先造成伤害
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)

	if not self:GetAutoCastState() then
		-- add modifier to skewered unit
		local modifier = target:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_Advanced_Spear", -- modifier name
			{
				projectile = iProjectileHandle,
			} -- kv
		)
	end
	self.projectiles[iProjectileHandle].unit = target
	self.projectiles[iProjectileHandle].modifier = modifier
	self.projectiles[iProjectileHandle].active = false
	-- play effects
	local sound_cast = "Hero_Mars.Spear.Target"
	EmitSoundOn( sound_cast, target )
end

-- projectile think
function Advanced_Spear:OnProjectileThinkHandle( iProjectileHandle ) --重设置记录在self.projectiles[iProjectileHandle]中的location 用于击退
	-- init for the first time
	if not self.projectiles[iProjectileHandle] then
		self.projectiles:Init( iProjectileHandle )
	end

	local data = self.projectiles[iProjectileHandle]


	-- save location
	local location = ProjectileManager:GetLinearProjectileLocation( iProjectileHandle )
	data.location = location
	data.caster = self:GetCaster()
	data.ability = self

end

function Advanced_Spear:OnAbilityPhaseStart()
	-- play Advanced_empower
	if self:GetUnlock(1)==1 then
		self.mars = {}
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local target_pos =  self:GetCursorPosition()
		local radius = self:GetSpecialValueFor("spear_width")
		local projectile_distance = self:GetSpecialValueFor("spear_range")
		if target_pos==caster_loc then
			target_pos = target_pos +caster:GetForwardVector()
		end
		target_pos.z = caster_loc.z
		local direction 	= (target_pos - caster_loc):Normalized()

		

		local new_caster_pos1 = RotatePosition(caster_loc, QAngle(0, 90, 0), target_pos) 
		local new_caster_pos2 = RotatePosition(caster_loc, QAngle(0, -90, 0), target_pos) 
		local new_dir_1 = (new_caster_pos1 - caster_loc):Normalized()
		local new_dir_2 = (new_caster_pos2 - caster_loc):Normalized()
		for i = 1, 3, 1 do
			local new_pos = caster_loc+new_dir_1 * i*radius
			local new_target_pos = new_pos + direction * projectile_distance
			local new_dir = (new_target_pos - new_pos):Normalized()
			local illusion = self:SpawnMars(new_pos,new_dir)
			table.insert(self.mars,illusion)
			
		end
		for i = 1, 3, 1 do
			local new_pos = caster_loc+new_dir_2 * i*radius
			local new_target_pos = new_pos + direction * projectile_distance
			local new_dir = (new_target_pos - new_pos):Normalized()
			-- self:SpawnMars(new_pos,new_dir)
			local illusion = self:SpawnMars(new_pos,new_dir)
			table.insert(self.mars,illusion)
		end
		-- print(#self.mars)
	end
	

	return true -- if success
end

function Advanced_Spear:SpawnMars(pos,dir)
	local hCaster = self:GetCaster()
	local illusion =	CreateUnitByName( "npc_hd_mars_spear", pos, true, nil, nil, hCaster:GetTeamNumber() )
	illusion:SetOrigin(pos)
	illusion:AddNewModifier(hCaster, self, "modifier_Advanced_Spear_War_ghost", {duration=3.5})

	illusion:StartGesture(ACT_DOTA_CAST_ABILITY_5)
	illusion:SetForwardVector(dir)
	illusion.isThinker = true
	return illusion
end

function Advanced_Spear:OnAbilityPhaseInterrupted()
	-- self:StopEffects( true )
	for _, unit in ipairs(self.mars) do
		-- print("remove")
		UTIL_Remove( unit)
	end
	self.mars = {}
end


--------------------------------------------------------------------------------
modifier_Advanced_Spear = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Spear:IsHidden()return false end
function modifier_Advanced_Spear:IsDebuff()return true end
function modifier_Advanced_Spear:IsStunDebuff()return true end
function modifier_Advanced_Spear:IsPurgable()return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Spear:OnCreated( kv )
	-- references
	self.ability = self:GetAbility()

	if IsServer() then
		self.projectile = kv.projectile

		-- face towards
		self:GetParent():SetForwardVector( self:GetAbility().projectiles[kv.projectile].direction )
		self:GetParent():FaceTowards( self.ability.projectiles[self.projectile].init_pos )

		-- try apply
		if self:ApplyHorizontalMotionController() == false then
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_Spear:OnRefresh( kv )

end

function modifier_Advanced_Spear:OnRemoved()
	if not IsServer() then return end
	-- Compulsory interrupt
	self:GetParent():InterruptMotionControllers( false )

end

function modifier_Advanced_Spear:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_phased", {duration=0.1}) --提供相位，防止卡位
	end

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Spear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_Advanced_Spear:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_Spear:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Spear:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_Advanced_Spear:UpdateHorizontalMotion( me, dt )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	-- check projectile data
	if not self.ability.projectiles[self.projectile] then
		self:SafeDestroy()
		return
	end

	-- get location
	local data = self.ability.projectiles[self.projectile]

	-- if not data.active then return end

	-- move parent to projectile location
	self:GetParent():SetOrigin( data.location + data.direction*60 )
end

function modifier_Advanced_Spear:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:SafeDestroy()
	end
end





modifier_Advanced_Spear_War_ghost = modifier_Advanced_Spear_War_ghost or class({})
function modifier_Advanced_Spear_War_ghost:IsHidden()	return true end
function modifier_Advanced_Spear_War_ghost:IsDebuff()	return false end
function modifier_Advanced_Spear_War_ghost:IsPurgable()	return false end
function modifier_Advanced_Spear_War_ghost:IsPurgeException()	return false end
function modifier_Advanced_Spear_War_ghost:IsStunDebuff()	return false end
function modifier_Advanced_Spear_War_ghost:AllowIllusionDuplicate()	return false end
function modifier_Advanced_Spear_War_ghost:OnCreated(params)
	if IsServer() then
		self.state = 0
		local parent = self:GetParent()
		parent:SetModelScale(0.9)
		local model = parent:FirstMoveChild()
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" then
				-- print(model:GetModelName())
				if model:GetModelName()=="models/heroes/mars/mars_spear.vmdl" then
					self.lastModel = model
					self:StartIntervalThink(0.25)
					break
				end
				
			end
			model = model:NextMovePeer()
		
		end
	end
end

function modifier_Advanced_Spear_War_ghost:OnIntervalThink()
	if self.state==2 then
		local parent = self:GetParent()
		parent:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		parent:SetOrigin(parent:GetOrigin()-self.forward*10 + Vector(0,0,-3))
		return
	end
	if self.state==0 then
		self.state = 1
		if self.lastModel then
			self.lastModel:AddEffects(EF_NODRAW)
		end
		self:StartIntervalThink(1)
		return
	end
	if self.state==1 then
		self:StartIntervalThink(0.01)
		self.forward = self:GetParent():GetForwardVector()
		self.state = 2
		return
	end

end


function modifier_Advanced_Spear_War_ghost:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		UTIL_Remove( self:GetParent() )
	end
end
function modifier_Advanced_Spear_War_ghost:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
-- function modifier_Advanced_Spear_War_ghost:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_MODEL_CHANGE,
-- 		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
-- 		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
-- 	}
-- end
-- function modifier_Advanced_Spear_War_ghost:GetModifierModelChange(params)
-- 	if IsServer() then
-- 		return self:GetCaster().origin_model_name
-- 	end
-- end
-- function modifier_Advanced_Spear_War_ghost:GetOverrideAnimation(params)

-- 	return ACT_DOTA_CAST_ABILITY_5
-- end
-- function modifier_Advanced_Spear_War_ghost:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_02.vpcf" end
-- function modifier_Advanced_Spear_War_ghost:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


modifier_Advanced_Spear_aftermove = advanced_modifier({})
function modifier_Advanced_Spear_aftermove:IsHidden()	return true end
function modifier_Advanced_Spear_aftermove:IsDebuff()	return false end
function modifier_Advanced_Spear_aftermove:IsPurgable()	return false end
function modifier_Advanced_Spear_aftermove:IsPurgeException()	return false end
