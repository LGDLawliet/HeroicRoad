

--特效优化 √
Advanced_acorn_shot = Advanced_acorn_shot or class({})
LinkLuaModifier( "modifier_Advanced_acorn_shot", "skills/Advanced_acorn_shot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_acorn_shot_thinker", "skills/Advanced_acorn_shot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_acorn_shot_debuff", "skills/Advanced_acorn_shot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_acorn_shot_debuff2", "skills/Advanced_acorn_shot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_acorn_shot_lv20", "skills/Advanced_acorn_shot", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function Advanced_acorn_shot:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_slow.vpcf", context )
end
function Advanced_acorn_shot:CheckKV(key)
	local table = {
		bonus_damage = 8,
	}
	local value = table[key] or -1
	return value
end

function Advanced_acorn_shot:UnlockFirstCore(key)
	return true
end
function Advanced_acorn_shot:UnlockSecondCore(key)
	return true
end
function Advanced_acorn_shot:UnlockThirdCore(key)
	return true
end



function Advanced_acorn_shot:GetBehavior()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end


	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	
end



function Advanced_acorn_shot:Spawn()
	if not IsServer() then return end
end

function Advanced_acorn_shot:OnAdvancedUpgrade()
	if self.advanced_level>=20 then
		local caster = self:GetCaster()
		if not caster:HasModifier("modifier_Advanced_acorn_shot_lv20") then
			caster:AddNewModifier(caster, self, "modifier_Advanced_acorn_shot_lv20", {}) 
		end
	end
end
function Advanced_acorn_shot:GetCastRange( vLocation, hTarget )
	return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor( "bonus_range" )
end

function Advanced_acorn_shot:OnSpellStart()
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
	self:HDCastToTarget(target)

	-- play effects
	local sound_cast = "Hero_Hoodwink.AcornShot.Cast"
	EmitSoundOn( sound_cast, caster )
end
function Advanced_acorn_shot:HDCastToTarget(target)
	local caster = self:GetCaster()
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_acorn_shot_thinker", -- modifier name
		{ duration = 30 }, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local mod = thinker:FindModifierByName( "modifier_Advanced_acorn_shot_thinker" )
	if mod then
		mod:InitCast(caster,target)
	end
	mod.source = caster
	mod.target = target
end

function Advanced_acorn_shot:OnProjectileHit_ExtraData( target, location, ExtraData )
	-- local caster = self:GetCaster()
	local thinker = EntIndexToHScript( ExtraData.thinker )
	if not thinker then
		self:ApplyAttack(target,0)
		return
	end
	local mod = thinker:FindModifierByName( "modifier_Advanced_acorn_shot_thinker" )
	if not mod then return end
	if not target then
		mod:Destroy()
		return
	end
	-- bounce
	thinker:SetOrigin( location )
	Timers:CreateTimer(self:GetSpecialValueFor( "bounce_delay" ), function()
		if not mod:IsNull() then
			mod:OnIntervalThink()
		end
		
	end)
	
	if ExtraData.first==1 then
		if target:TriggerSpellAbsorb( self ) then
			mod:Destroy()
			return
		end
	end
	local unlock1_bonus =  mod:GetUnlock1Bonus()
	self:ApplyAttack(target,unlock1_bonus)
end

function Advanced_acorn_shot:ApplyAttack(target,unlock1_bonus)
	if not target then
		return
	end
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "debuff_duration" )


	-- attack enemy
	local bonus_mod = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_acorn_shot", -- modifier name
		{duration = 0.1,unlock1_bonus=unlock1_bonus} -- kv
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
	if bonus_mod then
		bonus_mod:Destroy()
	end
	

	-- debuff


	if target:IsAlive() then
		if not target:IsMagicImmune() then
			duration = duration * caster:GetModifierStatusNegativeGainIndex(1) * target:GetHDStatusResistanceIndex()
			if duration>0 then
				target:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_acorn_shot_debuff", -- modifier name
					{ duration = duration } -- kv
				)
			end
		
	
			-- play effects
			local sound_slow = "Hero_Hoodwink.AcornShot.Slow"
			EmitSoundOn( sound_slow, target )
		end
		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_acorn_shot_debuff2", -- modifier name
			{} -- kv
		)
	end

	-- play effects
	local sound_target = "Hero_Hoodwink.AcornShot.Target"
	EmitSoundOn( sound_target, target )
end


modifier_Advanced_acorn_shot_thinker = modifier_Advanced_acorn_shot_thinker or  class({})
function modifier_Advanced_acorn_shot_thinker:OnCreated( kv )

	if not IsServer() then return end
	self.effected_target = {}
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if self.ability.unlock1 then
		self.unlock1 = true
		self.unlock1_bonus_damage = 100
	end
	local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_hoodwink_3")
	if self.ability.unlock2 then
		self.unlock2 = true
		self.bonus_bounces = 3
		self.bonus_bounce_chance = 6
		
		if ability then
			self.bonus_bounce_chance = self.bonus_bounce_chance * (1+0.01*ability:GetSpecialValueFor("bonus_chance"))
		end
	end

	-- references
	self.projectile_name = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf"

	self.projectile_speed = self.ability:GetSpecialValueFor( "projectile_speed" )
	self.bounces = self.ability:GetSpecialValueFor( "bounce_count" )+1

	self.damage = self.ability:GetSpecialValueFor( "bonus_damage" )
	self.delay = self.ability:GetSpecialValueFor( "bounce_delay" )
	self.range = self.ability:GetSpecialValueFor( "bounce_range" )

	local max = 6
	if self.ability.advanced_level>=5 then
		max = 10
	end
	local bonus_bounces = math.min(self.caster:GetDamageMax()/75,max)
	self.bounces = self.bounces + math.max(bonus_bounces,0)
	if ability then
		self.bounces = self.bounces + ability:GetSpecialValueFor("bonus_bounce")
	end
	if self.ability.unlock3 then
		self.bounces = 2
		if ability then
			self.unlock3_bounce = self.unlock3_bounce + ability:GetSpecialValueFor("bonus_bounce")
		end
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

function modifier_Advanced_acorn_shot_thinker:InitCast( caster,target )
	self.source = caster
	self.target = target
end


function modifier_Advanced_acorn_shot_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_Advanced_acorn_shot_thinker:OnIntervalThink()
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
		if self.target:IsNull() then
			self:SafeDestroy()
			return
		end
		if self.unlock1 then
			self.unlock1_bonus_damage = self.unlock1_bonus_damage +8
			self.projectile_speed = self.projectile_speed + 300
		end
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
			if self:GetAbility().advanced_level>=15 then
				if self.target:IsAlive() then
					if self:GetTargetCount(self.target)<3 then
						self:BounceSameTarget(self.target)
						next_target = self.target
					end
				end
			end
			if not next_target then
				self:Destroy()
				return
			end
			
		end
		self.target = next_target

		self.info.iMoveSpeed = self.projectile_speed
	end

	-- launch projectile
	self.info.Source = self.source
	self.info.Target = self.target
	self.info.ExtraData.first = first
	ProjectileManager:CreateTrackingProjectile( self.info )

	-- play effects
	local sound_cast = "Hero_Hoodwink.AcornShot.Bounce"
	EmitSoundOn( sound_cast, self.source )

	if self.unlock2 then
		if self.bonus_bounces>0 and self.bonus_bounce_chance>=RandomInt(1, 100) then
			self.bonus_bounces = self.bonus_bounces - 1
			self.bonus_bounce_chance = 6
			self.bounces = math.floor(self.bounces *1.7)
			self:OnIntervalThink()
		else
			self.bonus_bounce_chance = self.bonus_bounce_chance + 6
		end
	end
end

function modifier_Advanced_acorn_shot_thinker:Bounce()
	self:StartIntervalThink( self.delay )
end


function modifier_Advanced_acorn_shot_thinker:GetTargetCount(target)
	if not self.effected_target[target] then
		self.effected_target[target] = 0
	end
	return self.effected_target[target]
end

function modifier_Advanced_acorn_shot_thinker:BounceSameTarget(target)
	if not self.effected_target[target] then
		self.effected_target[target] = 0
	end
	self.effected_target[target] = self.effected_target[target] + 1
end

function modifier_Advanced_acorn_shot_thinker:GetUnlock1Bonus()
	if self.unlock1 then
		return self.unlock1_bonus_damage
	end
	return 0
end





modifier_Advanced_acorn_shot = modifier_Advanced_acorn_shot or  class({})

function modifier_Advanced_acorn_shot:IsHidden()	return true end
function modifier_Advanced_acorn_shot:IsPurgable()	return false end
function modifier_Advanced_acorn_shot:OnCreated( kv )
	if not IsServer() then return end
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.unlock1_bonus = kv.unlock1_bonus
end
function modifier_Advanced_acorn_shot:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_Advanced_acorn_shot:GetModifierPreAttack_BonusDamage()
	return self.bonus
end
function modifier_Advanced_acorn_shot:GetModifierDamageOutgoing_Percentage()
	return self.unlock1_bonus
end


modifier_Advanced_acorn_shot_debuff = modifier_Advanced_acorn_shot_debuff or  class({})
function modifier_Advanced_acorn_shot_debuff:IsHidden()	return false end
function modifier_Advanced_acorn_shot_debuff:IsDebuff()	return true end
function modifier_Advanced_acorn_shot_debuff:IsStunDebuff()	return false end
function modifier_Advanced_acorn_shot_debuff:IsPurgable()	return true end
function modifier_Advanced_acorn_shot_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "slow" )
	if not IsServer() then return end
end

function modifier_Advanced_acorn_shot_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end


function modifier_Advanced_acorn_shot_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_Advanced_acorn_shot_debuff:GetModifierMoveSpeedBonus_Constant()	return self.slow end
function modifier_Advanced_acorn_shot_debuff:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_slow.vpcf"
end
function modifier_Advanced_acorn_shot_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end











modifier_Advanced_acorn_shot_debuff2 = advanced_modifier({})

function modifier_Advanced_acorn_shot_debuff2:IsDebuff() return true end
function modifier_Advanced_acorn_shot_debuff2:IsHidden() return false end
function modifier_Advanced_acorn_shot_debuff2:IsPurgable() return false end
-- function modifier_Advanced_acorn_shot_debuff2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_acorn_shot_debuff2:OnCreated(keys)
	if IsServer() then
		local armor = self:GetParent():GetPhysicalArmorValue(false)
		if armor>0 then

			local index = 0.18
			if self:GetAbility().advanced_level>=10 then
				index = 0.27
			end
			armor = armor *index
			if self:GetStackCount()<armor then
				self:SetStackCount(armor)
			end
		end
	end
end
function modifier_Advanced_acorn_shot_debuff2:OnRefresh(keys)
	if IsServer() then
		self:OnCreated(keys)
	end
end


function modifier_Advanced_acorn_shot_debuff2:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_acorn_shot_debuff2:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_acorn_shot_debuff2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_acorn_shot_debuff2:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()
end












modifier_Advanced_acorn_shot_lv20 = class({})

function modifier_Advanced_acorn_shot_lv20:IsDebuff()			return false end
function modifier_Advanced_acorn_shot_lv20:IsHidden() 			return false end
function modifier_Advanced_acorn_shot_lv20:IsPurgable() 		return false end
function modifier_Advanced_acorn_shot_lv20:IsPurgeException() 	return false end
function modifier_Advanced_acorn_shot_lv20:RemoveOnDeath() return false end
function modifier_Advanced_acorn_shot_lv20:DestroyOnExpire() return false end
function modifier_Advanced_acorn_shot_lv20:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_acorn_shot_lv20:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_Advanced_acorn_shot_lv20:OnCreated(keys)
	if IsServer() then
		self.bonus_chance_index = 1
		local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_hoodwink_3")
		if ability then
			self.bonus_chance_index = self.bonus_chance_index * (1+0.01*ability:GetSpecialValueFor("bonus_chance"))
		end
	end
end

function modifier_Advanced_acorn_shot_lv20:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() or keys.attacker:PassivesDisabled() then
		return
	end
	local caster = self:GetCaster()
	if not caster:IsApplyModifier() then
		return
	end
	if caster:IsInSpecialAttack() then
		return
	end

	local time = self:GetRemainingTime()

	if time>=3 then
		return
	end
	local chance = 5
	local time_add = 1
	local ability = self:GetAbility()
	if ability.unlock3 then
		chance = 25
		time_add = 0.15
	end

	if self:GetCaster():GetRandomEffect(chance*self.bonus_chance_index,INT_TYPE,0.4) >=RandomInt(1, 100) then
		self:SetDuration(math.max(time+time_add,time_add), true)
		if keys.target and keys.target:IsAlive() and IsEnemy(keys.target,caster) then
			self:GetAbility():HDCastToTarget(keys.target)
		end

	end

	
end