creeps_spell_breathe_fire = class({})
LinkLuaModifier( "modifier_creeps_spell_breathe_fire", "creeps_spell/creeps_spell_breathe_fire", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function creeps_spell_breathe_fire:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- unit target just indicates point
	if target then point = target:GetAbsOrigin()() end
	if point==caster:GetAbsOrigin() then
		point = point+caster:GetForwardVector()
	end


	
	-- load projectile
	local projectile_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "range" )
	local projectile_start_radius = 100
	local projectile_end_radius = 400
	local projectile_speed = 500
	local projectile_direction = point - caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}
	ProjectileManager:CreateLinearProjectile(info)

	-- play effects
	local sound_cast = "Hero_DragonKnight.BreathFire"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function creeps_spell_breathe_fire:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetBaseDamageMax()
	local duration = self:GetSpecialValueFor( "duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- debuff
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_creeps_spell_breathe_fire", -- modifier name
		{ duration = duration } -- kv
	)
end








modifier_creeps_spell_breathe_fire = class({})


function modifier_creeps_spell_breathe_fire:IsHidden()	return false end
function modifier_creeps_spell_breathe_fire:IsDebuff()	return true end
function modifier_creeps_spell_breathe_fire:IsStunDebuff()	return false end
function modifier_creeps_spell_breathe_fire:IsPurgable()	return false end
function modifier_creeps_spell_breathe_fire:IsPurgeException()	return false end
function modifier_creeps_spell_breathe_fire:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_creeps_spell_breathe_fire:OnCreated( kv )
	-- references
	self.reduction = -self:GetAbility():GetSpecialValueFor( "damage_reduce" )
end

function modifier_creeps_spell_breathe_fire:OnRefresh( kv )
	-- references
	self.reduction = -self:GetAbility():GetSpecialValueFor( "damage_reduce" )	
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creeps_spell_breathe_fire:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_creeps_spell_breathe_fire:GetModifierDamageOutgoing_Percentage()
	return self.reduction
end