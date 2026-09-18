
--------------------------------------------------------------------------------
Middle_Spear = class({})

LinkLuaModifier( "modifier_Middle_Spear", "skills/Middle_Spear", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_Middle_Spear_War_God", "skills/Middle_Spear", LUA_MODIFIER_MOTION_HORIZONTAL )

function Middle_Spear:IsHiddenWhenStolen()return false end
function Middle_Spear:IsStealable()return true end
function Middle_Spear:IsNetherWardStealable()return true end
function Middle_Spear:IsRefreshable()return true end

function Middle_Spear:GetIntrinsicModifierName()
	return "modifier_Middle_Spear_War_God"
end

function Middle_Spear:Precache( context )
	PrecacheResource( "particle", "particles/ui_mouseactions/range_finder_tp_dest.vpcf", context )
end
function Middle_Spear:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function Middle_Spear:CreateCustomIndicator()

	local radius = self:GetSpecialValueFor("radius")
	local particle_cast = "particles/ui_mouseactions/range_finder_tp_dest.vpcf"
	self.particle = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.particle, 3, Vector(radius,0,0))
end


function Middle_Spear:UpdateCustomIndicator( loc )
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

function Middle_Spear:DestroyCustomIndicator()
	ParticleManager:DestroyParticle(  self.particle, true ) 
	ParticleManager:ReleaseParticleIndex(  self.particle )
end

--------------------------------------------------------------------------------
-- Ability Start
function Middle_Spear:OnSpellStart()
	

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if point==caster_loc then
		point = point +caster:GetForwardVector()
	end
	-- load data
	local projectile_name = "particles/units/heroes/hero_mars/mars_spear.vpcf"
	local projectile_distance = self:GetSpecialValueFor("spear_range")
	local projectile_speed = self:GetSpecialValueFor("spear_speed")
	local projectile_radius = self:GetSpecialValueFor("spear_width")
	self.bonus_hp_damage = 0

	-- calculate direction
	local direction = point - caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	self.casterorigin = caster:GetOrigin()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),

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
	--DeepPrintTable(info)  --看看里面都有啥

	-- play effects
	local sound_cast = "Hero_Mars.Spear.Cast"
	EmitSoundOn( sound_cast, caster )
	local sound_cast = "Hero_Mars.Spear"
	EmitSoundOn( sound_cast, caster )

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
	local radius = self[projectileID].ability:GetSpecialValueFor("radius")
	local stun_duration = self[projectileID].ability:GetSpecialValueFor("stun_duration")
	
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
			damage = self[projectileID].ability:GetSpecialValueFor("fire_damage")*self[projectileID].caster:GetBaseDamageMax(),
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
		ParticleManager:SetParticleControl(pfx, 1, Vector(300,300,300))
		ParticleManager:SetParticleControl(pfx, 3, self[projectileID].location)
		-- ParticleManager:SetParticleControl(pfx, 61, Vector(300,300,300))
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitAnnouncerSoundForTeamOnLocation("Hero_Snapfire.Shotgun.Fire",self[projectileID].caster:GetTeamNumber(), self[projectileID].location)
	    self[projectileID] = nil
end
Middle_Spear.projectiles = mars_projectiles

-- projectile hit
function Middle_Spear:OnProjectileHitHandle( target, location, iProjectileHandle )
	-- init in case it isn't initialized from below (if projectile launched very close to target)
	if not self.projectiles[iProjectileHandle] then
		self.projectiles:Init( iProjectileHandle )
	end

	if not target then
		-- destroy data
		self.projectiles:Destroy( iProjectileHandle )
		return
	end
	local damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetBaseDamageMax() + self.bonus_hp_damage 
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


	-- add modifier to skewered unit
	local modifier = target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_Middle_Spear", -- modifier name
		{
			projectile = iProjectileHandle,
		} -- kv
	)
	self.projectiles[iProjectileHandle].unit = target
	self.projectiles[iProjectileHandle].modifier = modifier
	self.projectiles[iProjectileHandle].active = false

	-- play effects
	local sound_cast = "Hero_Mars.Spear.Target"
	EmitSoundOn( sound_cast, target )
end

-- projectile think
function Middle_Spear:OnProjectileThinkHandle( iProjectileHandle ) --重设置记录在self.projectiles[iProjectileHandle]中的location 用于击退
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

	-- if (self.casterorigin - data.location):Length2D() > 2500 and iProjectileHandle then 
	-- 	ProjectileManager:DestroyLinearProjectile( iProjectileHandle ) 
	-- end --尝试避免出现矛不消失的情况

	-- check skewered unit, and dragged (caught unit not necessarily dragged)
	-- if not data.unit then return end
	-- if not data.active then
	-- 	-- check distance, mainly to avoid being pinned while behind the tree/cliffs
	-- 	local difference = (data.unit:GetOrigin()-data.init_pos):Length2D() - (data.location-data.init_pos):Length2D()
	-- 	if difference>0 then return end
	-- 	data.active = true
	-- end
end




--------------------------------------------------------------------------------
modifier_Middle_Spear = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Spear:IsHidden()return false end
function modifier_Middle_Spear:IsDebuff()return true end
function modifier_Middle_Spear:IsStunDebuff()return true end
function modifier_Middle_Spear:IsPurgable()return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Spear:OnCreated( kv )
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

function modifier_Middle_Spear:OnRefresh( kv )

end

function modifier_Middle_Spear:OnRemoved()
	if not IsServer() then return end
	-- Compulsory interrupt
	self:GetParent():InterruptMotionControllers( false )

end

function modifier_Middle_Spear:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_phased", {duration=0.1}) --提供相位，防止卡位
	end

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_Spear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_Middle_Spear:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_Middle_Spear:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_Spear:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_Middle_Spear:UpdateHorizontalMotion( me, dt )
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

function modifier_Middle_Spear:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:SafeDestroy()
	end
end


modifier_Middle_Spear_War_God = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Spear_War_God:IsHidden()return true end
function modifier_Middle_Spear_War_God:IsDebuff()return false end
function modifier_Middle_Spear_War_God:IsStunDebuff()return false end
function modifier_Middle_Spear_War_God:IsPurgable()return false end
function modifier_Middle_Spear_War_God:IsPurgeException() return false end

function modifier_Middle_Spear_War_God:OnCreated( kv )
	self:GetAbility().custom_indicator = self
end

function modifier_Middle_Spear_War_God:OnIntervalThink()
	if IsClient() then
		self:StartIntervalThink(-1)
		local ability = self:GetAbility()
		if self.init and ability.DestroyCustomIndicator then
			self.init = nil
			ability:DestroyCustomIndicator()
		end
	end
end

function modifier_Middle_Spear_War_God:Register( loc )
	local ability = self:GetAbility()
	if (not self.init) and ability.CreateCustomIndicator then
		self.init = true
		ability:CreateCustomIndicator()
	end

	if ability.UpdateCustomIndicator then
		ability:UpdateCustomIndicator( loc )
	end
	self:StartIntervalThink( 0.1 )
end
