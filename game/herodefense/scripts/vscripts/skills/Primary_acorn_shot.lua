


Primary_acorn_shot = Primary_acorn_shot or class({})
LinkLuaModifier( "modifier_Primary_acorn_shot", "skills/Primary_acorn_shot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_acorn_shot_thinker", "skills/Primary_acorn_shot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_acorn_shot_debuff", "skills/Primary_acorn_shot", LUA_MODIFIER_MOTION_NONE )

function Primary_acorn_shot:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_slow.vpcf", context )
end

function Primary_acorn_shot:Spawn()
	if not IsServer() then return end
end


function Primary_acorn_shot:GetCastRange( vLocation, hTarget )
	return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor( "bonus_range" )
end

function Primary_acorn_shot:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	-- local point = self:GetCursorPosition()
	if caster:HasAbility("heroTalent_npc_dota_hero_hoodwink_3") then
		local sound = {
			"hoodwink_hoodwink_acorn_en_07",
			"hoodwink_hoodwink_acorn_en_08",
		}
		caster:EmitSound(sound[RandomInt(1, #sound)])
	end


	-- create thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_acorn_shot_thinker", -- modifier name
		{ duration = 30 }, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local mod = thinker:FindModifierByName( "modifier_Primary_acorn_shot_thinker" )
	if mod then
		mod:InitCast(caster,target)
	end
	mod.source = caster
	mod.target = target

	-- play effects
	local sound_cast = "Hero_Hoodwink.AcornShot.Cast"
	EmitSoundOn( sound_cast, caster )
end


function Primary_acorn_shot:OnProjectileHit_ExtraData( target, location, ExtraData )
	local caster = self:GetCaster()
	local thinker = EntIndexToHScript( ExtraData.thinker )
	local mod = thinker:FindModifierByName( "modifier_Primary_acorn_shot_thinker" )
	if not mod then return end
	if not target then
		mod:Destroy()
		return
	end
	-- bounce
	thinker:SetOrigin( location )
	mod:Bounce()
	if ExtraData.first==1 then
		if target:TriggerSpellAbsorb( self ) then
			mod:Destroy()
			return
		end
	end
	local duration = self:GetSpecialValueFor( "debuff_duration" )

	-- attack enemy
	local mod = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_acorn_shot", -- modifier name
		{duration = 0.1} -- kv
	)
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}

	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack( target, true, true, true, true, false, false, true )
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	if mod then
		mod:Destroy()
	end
	

	-- debuff
	if not target:IsMagicImmune() then
		duration = duration * caster:GetModifierStatusNegativeGainIndex(1) * target:GetHDStatusResistanceIndex()
		if duration>0 then
			target:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_Primary_acorn_shot_debuff", -- modifier name
				{ duration = duration } -- kv
			)
		end
	

		-- play effects
		local sound_slow = "Hero_Hoodwink.AcornShot.Slow"
		EmitSoundOn( sound_slow, target )
	end

	-- play effects
	local sound_target = "Hero_Hoodwink.AcornShot.Target"
	EmitSoundOn( sound_target, target )
end




modifier_Primary_acorn_shot_thinker = modifier_Primary_acorn_shot_thinker or  class({})
function modifier_Primary_acorn_shot_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.projectile_name = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf"

	self.projectile_speed = self.ability:GetSpecialValueFor( "projectile_speed" )
	self.bounces = self.ability:GetSpecialValueFor( "bounce_count" )+1
	self.damage = self.ability:GetSpecialValueFor( "bonus_damage" )
	self.delay = self.ability:GetSpecialValueFor( "bounce_delay" )
	self.range = self.ability:GetSpecialValueFor( "bounce_range" )

	if not IsServer() then return end


	local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_hoodwink_3")
	if ability then
		self.bounces = self.bounces + ability:GetSpecialValueFor("bonus_bounce")
	end
	-- ability properties
	self.abilityDamageType = self.ability:GetAbilityDamageType()
	self.abilityTargetTeam = self.ability:GetAbilityTargetTeam()
	self.abilityTargetType = self.ability:GetAbilityTargetType()
	self.abilityTargetFlags = self.ability:GetAbilityTargetFlags()

	-- precache projectile
	self.info = {
		-- Target = self.target,
		-- Source = self.parent,
		Ability = self.ability,	
		
		EffectName = self.projectile_name,
		iMoveSpeed = self.projectile_speed,
		bDodgeable = true,                           -- Optional
	
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,

		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 400,                              -- Optional
		iVisionTeamNumber = self.caster:GetTeamNumber(),        -- Optional
		ExtraData = {
			thinker = self.parent:entindex()
		}
	}

	-- Start bounce in next frame
	self:StartIntervalThink( 0 )
end

function modifier_Primary_acorn_shot_thinker:InitCast( caster,target )
	self.source = caster
	self.target = target
end


function modifier_Primary_acorn_shot_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_Primary_acorn_shot_thinker:OnIntervalThink()
	self.bounces = self.bounces-1
	if self.bounces<0 then
		self:Destroy()
		return
	end

	self:StartIntervalThink(-1)

	local first = 0
	if not self.first then
		self.first = true
		first = 1
		self.info.iMoveSpeed = self.projectile_speed
	else
		self.source = self.target

		-- Find enemies
		local enemies = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	-- int, your team number
			self.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		if #enemies<1 then
			self:Destroy()
			return
		end

		local next_target
		for _,enemy in pairs(enemies) do
			if enemy~=self.target then
				next_target = enemy
				break
			end
		end
		if not next_target then
			self:Destroy()
			return
		end
		self.target = next_target

		self.info.iMoveSpeed = self.caster:GetProjectileSpeed()
	end

	-- launch projectile
	self.info.Source = self.source
	self.info.Target = self.target
	self.info.ExtraData.first = first
	ProjectileManager:CreateTrackingProjectile( self.info )

	-- play effects
	local sound_cast = "Hero_Hoodwink.AcornShot.Bounce"
	EmitSoundOn( sound_cast, self.source )
end

function modifier_Primary_acorn_shot_thinker:Bounce()
	self:StartIntervalThink( self.delay )
end












modifier_Primary_acorn_shot = modifier_Primary_acorn_shot or  class({})

function modifier_Primary_acorn_shot:IsHidden()	return true end
function modifier_Primary_acorn_shot:IsPurgable()	return false end
function modifier_Primary_acorn_shot:OnCreated( kv )
	if not IsServer() then return end
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end
function modifier_Primary_acorn_shot:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_Primary_acorn_shot:GetModifierPreAttack_BonusDamage()
	return self.bonus
end

-- function modifier_Primary_acorn_shot:GetModifierProcAttack_Feedback( params )
-- 	SendOverheadEventMessage(
-- 		nil,
-- 		OVERHEAD_ALERT_DAMAGE,
-- 		params.target,
-- 		params.damage,
-- 		self:GetCaster():GetPlayerOwner()
-- 	)
-- end




modifier_Primary_acorn_shot_debuff = modifier_Primary_acorn_shot_debuff or  class({})
function modifier_Primary_acorn_shot_debuff:IsHidden()	return false end
function modifier_Primary_acorn_shot_debuff:IsDebuff()	return true end
function modifier_Primary_acorn_shot_debuff:IsStunDebuff()	return false end
function modifier_Primary_acorn_shot_debuff:IsPurgable()	return true end
function modifier_Primary_acorn_shot_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "slow" )
	if not IsServer() then return end
end

function modifier_Primary_acorn_shot_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end


function modifier_Primary_acorn_shot_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_Primary_acorn_shot_debuff:GetModifierMoveSpeedBonus_Constant()	return self.slow end
function modifier_Primary_acorn_shot_debuff:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_slow.vpcf"
end
function modifier_Primary_acorn_shot_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end