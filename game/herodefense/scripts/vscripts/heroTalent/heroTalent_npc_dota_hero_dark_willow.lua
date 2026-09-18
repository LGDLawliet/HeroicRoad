heroTalent_npc_dota_hero_dark_willow = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_dark_willow", "heroTalent/heroTalent_npc_dota_hero_dark_willow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_dark_willow_attack", "heroTalent/heroTalent_npc_dota_hero_dark_willow", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_dark_willow:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_dark_willow:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_dark_willow:IsStealable() 				return true end
function heroTalent_npc_dota_hero_dark_willow:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_dark_willow:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_dark_willow" end

function heroTalent_npc_dota_hero_dark_willow:OnProjectileHit_ExtraData( target, location, ExtraData )


	if not target then return end

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = (self:GetCaster():GetIntellect(false)+self:GetCaster():GetStrength()+self:GetCaster():GetAgility())*self:GetSpecialValueFor("atb_damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
end
modifier_heroTalent_npc_dota_hero_dark_willow = class({})

function modifier_heroTalent_npc_dota_hero_dark_willow:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_dark_willow:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_dark_willow:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_dark_willow:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dark_willow:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_dark_willow:AllowIllusionDuplicate() return false end


function modifier_heroTalent_npc_dota_hero_dark_willow:OnCreated( kv )
	if not self:GetParent():IsRealHero() then
		return
	end
	self.parent = self:GetParent()
	self.zero = Vector(0,0,0)

	-- references
	self.revolution = 2
	self.rotate_radius = 400

	if not IsServer() then return end

	-- init data
	self.interval = 0.03
	self.base_facing = Vector(0,1,0)
	self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
	self.rotate_delta = 360/self.revolution * self.interval

	-- set init location
	self.position = self.parent:GetOrigin() + self.relative_pos
	self.rotation = 0
	self.facing = self.base_facing

	-- create wisp
	self.wisp = CreateUnitByName(
		"npc_dota_dark_willow_creature",
		self.position,
		true,
		self.parent,
		self.parent:GetOwner(),
		self.parent:GetTeamNumber()
	)
	self.wisp:SetForwardVector( self.facing )
	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_wisp_ambient", -- modifier name
		{} -- kv
	)

	-- add attack modifier
	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_heroTalent_npc_dota_hero_dark_willow_attack", -- modifier name
		{  } -- kv
	)

	-- Start interval
	self:StartIntervalThink( self.interval )


end


function modifier_heroTalent_npc_dota_hero_dark_willow:OnDestroy()
	if not IsServer() then return end


	UTIL_Remove( self.wisp )

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_heroTalent_npc_dota_hero_dark_willow:OnIntervalThink()
	-- update position
	self.rotation = self.rotation + self.rotate_delta
	local origin = self.parent:GetOrigin()
	self.position = RotatePosition( origin, QAngle( 0, -self.rotation, 0 ), origin + self.relative_pos )
	self.facing = RotatePosition( self.zero, QAngle( 0, -self.rotation, 0 ), self.base_facing )

	-- update wisp
	self.wisp:SetOrigin( self.position )
	self.wisp:SetForwardVector( self.facing )
end











modifier_heroTalent_npc_dota_hero_dark_willow_attack = class({})


function modifier_heroTalent_npc_dota_hero_dark_willow_attack:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_dark_willow_attack:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dark_willow_attack:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dark_willow_attack:IsPurgable()	return false end

function modifier_heroTalent_npc_dota_hero_dark_willow_attack:OnCreated( kv )

	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end
	local model = self:GetCaster():FirstMoveChild()
	-- self.modelName = self.hero:GetModelName()
	while model ~= nil do
		if model:GetClassname() == "dota_item_wearable" then
			if model:GetModelName()=="models/items/dark_willow/dw_2021_immortal/dw_2021_immortal.vmdl" then
				self:SetStackCount(1)
				break
			end

		end
		model = model:NextMovePeer()
	end

	local projectile_name = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf"
	local projectile_speed = 1400
	
	self.info = {
		-- Target = target,
		-- Source = self:GetParent(),
		vSourceLoc = self:GetParent():GetAbsOrigin(),
		Ability = self:GetAbility(),	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
		-- bIsAttack = false,                                -- Optional

		ExtraData = {
			
		}
	}

	-- Start interval
	self:StartIntervalThink( self.interval )

	self:PlayEffects()
end



--------------------------------------------------------------------------------
-- Interval Effects
function modifier_heroTalent_npc_dota_hero_dark_willow_attack:OnIntervalThink()
	if not self:GetCaster():IsAlive() then
		return
	end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- create projectile effect
		-- local effect = self:PlayEffects1( enemy, self.info.iMoveSpeed )

		-- launch attack
		self.info.vSourceLoc = self:GetParent():GetAbsOrigin()
		self.info.Target = enemy
		-- self.info.ExtraData.effect = effect

		ProjectileManager:CreateTrackingProjectile( self.info )

		-- play effects
		local sound_cast = "Hero_DarkWillow.WillOWisp.Damage"
		EmitSoundOn( sound_cast, self:GetParent() )

		-- only on first unit
		break
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_heroTalent_npc_dota_hero_dark_willow_attack:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe.vpcf"
	local sound_cast = "Hero_DarkWillow.WispStrike.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 300, 300, 300 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)


	local particle_cast = "particles/rebuild/spell/herotalent_npc_dota_hero_dark_willow/dark_willowdw_2021_willow_wisp_terrorize_trail.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)



	EmitSoundOn( sound_cast, self:GetParent() )
end


function modifier_heroTalent_npc_dota_hero_dark_willow_attack:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end


function modifier_heroTalent_npc_dota_hero_dark_willow_attack:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,

	}
end

function modifier_heroTalent_npc_dota_hero_dark_willow_attack:GetOverrideAnimation(params)
	
	if self:GetStackCount()==0 then
		return ACT_DOTA_IDLE
	end


	return ACT_DOTA_CAST_ABILITY_5
end