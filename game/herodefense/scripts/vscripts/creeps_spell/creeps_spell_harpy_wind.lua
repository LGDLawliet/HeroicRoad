
--------------------------------------------------------------------------------
creeps_spell_harpy_wind = class({})

LinkLuaModifier( "modifier_creeps_spell_harpy_wind", "skills/creeps_spell_harpy_wind", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_creeps_spell_harpy_wind_debuff", "creeps_spell/creeps_spell_harpy_wind", LUA_MODIFIER_MOTION_NONE )

function creeps_spell_harpy_wind:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/harpy_chain_lightning.vpcf", context )

end

function creeps_spell_harpy_wind:IsHiddenWhenStolen()return false end
function creeps_spell_harpy_wind:IsStealable()return true end
function creeps_spell_harpy_wind:IsNetherWardStealable()return true end
function creeps_spell_harpy_wind:IsRefreshable()return true end
function creeps_spell_harpy_wind:Spawn()
	self.projectiles = {}
	self.projectiles_thinker = {}
end
--------------------------------------------------------------------------------
-- Ability Start
function creeps_spell_harpy_wind:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
	local projectile_distance = 1500
	local projectile_speed = 150
	local projectile_radius = 250
	self.bonus_hp_damage = 0



	-- calculate direction
	local direction = point - caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	self.casterorigin = caster:GetOrigin()
    caster:EmitSound("Hero_Invoker.Tornado")

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
		fExpireTime = GameRules:GetGameTime() + 15.0,

		bProvidesVision = true,
		iVisionRadius = 0,
		fVisionDuration = 10,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	local tornado_dummy_unit =  CreateModifierThinker(caster, self, nil, {},caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	self.projectiles[projectile] = GameRules:GetGameTime() +1
	self.projectiles_thinker[projectile] = tornado_dummy_unit

end


function creeps_spell_harpy_wind:OnProjectileHitHandle( target, location, iProjectileHandle )

	if not target then
		local unit = self.projectiles_thinker[iProjectileHandle]
		if not unit:IsNull() then
			UTIL_Remove(unit)
		end
		
		return
	end
	local damage = self:GetSpecialValueFor("wind_damage") *self:GetCaster():GetBaseDamageMax()
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

end

-- projectile think
function creeps_spell_harpy_wind:OnProjectileThinkHandle( iProjectileHandle ) --重设置记录在self.projectiles[iProjectileHandle]中的location 用于击退

	local thinker = self.projectiles_thinker[iProjectileHandle]

	if thinker:IsNull() then
		return
	end
	local location = ProjectileManager:GetLinearProjectileLocation( iProjectileHandle )
	thinker:SetOrigin(Vector(location.x,location.y,location.z+256))

	if  GameRules:GetGameTime()>=self.projectiles[iProjectileHandle] then

		self.projectiles[iProjectileHandle] = GameRules:GetGameTime() + 1

		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for _, unit in pairs(units) do
			unit:EmitSound("Hero_Zuus.ArcLightning.Target")
			local lightning_particle = ParticleManager:CreateParticle("particles/neutral_fx/harpy_chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, thinker)
			-- ParticleManager:SetParticleControl(lightning_particle, 0, location)  
			ParticleManager:SetParticleControlEnt(lightning_particle, 0, thinker, PATTACH_POINT_FOLLOW, nil, thinker:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(lightning_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	
			ParticleManager:ReleaseParticleIndex(lightning_particle)
			local damageTable = {
				victim = unit,
				attacker = self:GetCaster(),
				damage = self:GetSpecialValueFor("lighning_damage") *self:GetCaster():GetBaseDamageMax(),
				damage_type = self:GetAbilityDamageType(),
				ability = self, --Optional.
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			}
			ApplyDamage(damageTable)
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			unit:AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_harpy_wind_debuff", {duration = 0.5*StatusResistance})
	
			
			break
		end
	end


end




modifier_creeps_spell_harpy_wind_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_harpy_wind_debuff:IsHidden()	return false end
function modifier_creeps_spell_harpy_wind_debuff:IsDebuff()	return true end
function modifier_creeps_spell_harpy_wind_debuff:IsStunDebuff()	return false end
function modifier_creeps_spell_harpy_wind_debuff:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creeps_spell_harpy_wind_debuff:OnCreated( kv )
	-- references\
	if not self:GetAbility() then
		self.slow = 0
		return
	end

	self.slow = -self:GetAbility():GetSpecialValueFor("slow")

end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creeps_spell_harpy_wind_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_creeps_spell_harpy_wind_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end