LinkLuaModifier( "modifier_chaotic_tornado", "chaotic_spell/class_5/chaotic_tornado.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_tornado_fly", "chaotic_spell/class_5/chaotic_tornado.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_tornado_slow", "chaotic_spell/class_5/chaotic_tornado.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_tornado = class({})

function chaotic_tornado:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado.vpcf", context )
end
--指示器
function chaotic_tornado:GetCastRange()
	if IsServer() then return 30000 end
	if IsClient() then return self:GetSpecialValueFor("length") end
end
function chaotic_tornado:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_tornado:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function chaotic_tornado:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function chaotic_tornado:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()
	local distance = self:GetSpecialValueFor("range")
	local target_pos = caster_loc + direction* distance

	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(200,200,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_tornado:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end
--
function chaotic_tornado:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()
	if target then
		point = target:GetOrigin()
	end
	if point == caster:GetAbsOrigin() then
		point = point + caster:GetForwardVector()
	end

	local projectile_name = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
	local projectile_distance = self:GetSpecialValueFor("range")
	local projectile_speed = self:GetSpecialValueFor("speed")
	local projectile_start_radius = 300
	local projectile_end_radius = 300

	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
	    bDeleteOnHit = false,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		bProvidesVision = true,
	}
	ProjectileManager:CreateLinearProjectile(info)

	local sound_cast = "Hero_Invoker.Tornado.Cast"
	local sound_projectile = "Hero_Invoker.Tornado"
	EmitSoundOn( sound_cast, self:GetCaster() )
	self:GetCaster():EmitSoundParams(sound_projectile, 0, 0.5, 0)
end

function chaotic_tornado:OnProjectileHitHandle( target, location, projectile )
	if not target then return end
	if not self then return end
	local caster = self:GetCaster()
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()

	local elecshocking = self:GetSpecialValueFor("elecshocking")
	target:AddNewModifier(caster, self, "modifier_chaotic_tornado_fly", {duration = self:GetSpecialValueFor("fly_duration")})
	
	if self:GetRuneType() == 1 then
		target:Freezing(caster, self, self:GetSpecialValueFor("rune_1_freezing")*caster:HDGetPrimaryStatValue())
		if target:HasModifier("modifier_hd_freezing_frozen") then
			elecshocking = elecshocking*(1+self:GetSpecialValueFor("rune_1_bonus")*0.01)
		end
	end
	target:Elecshocking(caster, self, elecshocking)
end

---
modifier_chaotic_tornado_fly = advanced_modifier({})

function modifier_chaotic_tornado_fly:IsDebuff()				return true end
function modifier_chaotic_tornado_fly:IsHidden() 			return true end
function modifier_chaotic_tornado_fly:IsPurgable() 			return false end
function modifier_chaotic_tornado_fly:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_chaotic_tornado_fly:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_chaotic_tornado_fly:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_chaotic_tornado_fly:OnRefresh(keys) self:OnCreated(keys) end
function modifier_chaotic_tornado_fly:IsMotionController() return true end
function modifier_chaotic_tornado_fly:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_chaotic_tornado_fly:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_tornado_fly:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
	self.slow = self.ability:GetSpecialValueFor("slow")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self.parent:GetAbsOrigin()):Length2D()
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self.parent:GetName() ~= "npc_dota_thinker" then
				self:SafeDestroy()
			end
		end

		self.damageTable = {
			victim = self.parent,
			attacker = self.caster,
			damage = self.damage + self.bonus_damage*self.caster:HDGetPrimaryStatValue(),
			ability = self.ability,
			damage_type = self.ability:GetAbilityDamageType(),
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		}
	end
end
function modifier_chaotic_tornado_fly:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 200
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self.parent:SetOrigin(next_pos)
end

function modifier_chaotic_tornado_fly:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
		self.pos = nil
		self.distance = nil 

		if IsValid (self:GetAbility()) and self.parent:IsAlive() then
			ApplyDamage(self.damageTable)
			if self.parent:IsAlive() then
				self.parent:AddNewModifier(self.caster, self.ability, "modifier_chaotic_tornado_slow", {duration = self.slow_duration, slow = self.slow})
			end
		end
	end
end
---
modifier_chaotic_tornado_slow = advanced_modifier({})

function modifier_chaotic_tornado_slow:IsDebuff()			return true end
function modifier_chaotic_tornado_slow:IsHidden() 			return false end
function modifier_chaotic_tornado_slow:IsPurgable() 		return false end
function modifier_chaotic_tornado_slow:IsPurgeException() 	return false end
function modifier_chaotic_tornado_slow:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.slow)
	end
end	
function modifier_chaotic_tornado_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,} 
end
function modifier_chaotic_tornado_slow:GetModifierMoveSpeedBonus_Constant() 
	local remaining = self:GetRemainingTime()
	local duration = self:GetDuration()
	local max_slow = self:GetStackCount()
	return -max_slow * (remaining / duration)
end
