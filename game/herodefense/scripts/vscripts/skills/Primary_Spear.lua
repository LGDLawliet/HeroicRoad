
--------------------------------------------------------------------------------
Primary_Spear = class({})

LinkLuaModifier( "modifier_Primary_Spear", "skills/Primary_Spear", LUA_MODIFIER_MOTION_HORIZONTAL )


function Primary_Spear:IsHiddenWhenStolen()return false end
function Primary_Spear:IsStealable()return true end
function Primary_Spear:IsNetherWardStealable()return true end
function Primary_Spear:IsRefreshable()return true end
--------------------------------------------------------------------------------
-- Ability Start
function Primary_Spear:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if point==caster_loc then
		point = point + caster:GetForwardVector()
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
	    self[projectileID] = nil
end
Primary_Spear.projectiles = mars_projectiles

-- projectile hit
function Primary_Spear:OnProjectileHitHandle( target, location, iProjectileHandle )
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
		"modifier_Primary_Spear", -- modifier name
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
function Primary_Spear:OnProjectileThinkHandle( iProjectileHandle ) --重设置记录在self.projectiles[iProjectileHandle]中的location 用于击退
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
modifier_Primary_Spear = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Spear:IsHidden()return false end
function modifier_Primary_Spear:IsDebuff()return true end
function modifier_Primary_Spear:IsStunDebuff()return true end
function modifier_Primary_Spear:IsPurgable()return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Spear:OnCreated( kv )
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

function modifier_Primary_Spear:OnRefresh( kv )

end

function modifier_Primary_Spear:OnRemoved()
	if not IsServer() then return end
	-- Compulsory interrupt
	self:GetParent():InterruptMotionControllers( false )

end

function modifier_Primary_Spear:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_phased", {duration=0.1}) --提供相位，防止卡位
	end

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_Spear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_Primary_Spear:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_Primary_Spear:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_Spear:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_Primary_Spear:UpdateHorizontalMotion( me, dt )
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

function modifier_Primary_Spear:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:SafeDestroy()
	end
end


