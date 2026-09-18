--特效优化 √
Advanced_assassinate = class({})
LinkLuaModifier( "modifier_Advanced_assassinate", "skills/Advanced_assassinate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_assassinate_effect", "skills/Advanced_assassinate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_assassinate_unlock1", "skills/Advanced_assassinate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_assassinate_unlock1_buff", "skills/Advanced_assassinate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_assassinate_unlock3", "skills/Advanced_assassinate", LUA_MODIFIER_MOTION_NONE )
function Advanced_assassinate:CheckKV(key)
	local table = {
		damage = 40,
		bonus_damage = 0.15,




	}
	local value = table[key] or -1
	return value

end
function Advanced_assassinate:UnlockFirstCore(key)

	return true
end
function Advanced_assassinate:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_assassinate:UnlockThirdCore(key)
	local caster = self:GetCaster()
	self.unlock3_modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_assassinate_unlock3",{})
	return true

end

-- function Advanced_assassinate:GetAbilityTextureName()

-- 	if self:GetSpecialValueFor("advanced_level")>=20 then
-- 		local caster = self:GetCaster()
-- 		if caster then
-- 			local modifier = caster:FindModifierByName("modifier_Advanced_assassinate_effect")
-- 			if modifier and modifier:GetRemainingTime()<=0 then
-- 				return "sniper_fall20_assassinate"
-- 			end
-- 		end
		
		
-- 	end
-- 	return "sniper_assassinate"
-- end

function Advanced_assassinate:GetPlaybackRateOverride()
	if self:GetSpecialValueFor("advanced_level")>=15 then
		if self:GetUnlock(1)==1 then
			return 20
		end
		return 2
	end
	return 1
end
function Advanced_assassinate:GetCastPoint()
	if self:GetSpecialValueFor("advanced_level")>=15 then
		if self:GetUnlock(1)==1 then
			return 0.1
		end
		return 1
	end
	return 2
end

function Advanced_assassinate:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", context )
	PrecacheResource( "particle", "particles/units/unit_greevil/loot_greevil_death.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_assassinate.vpcf", context )


	PrecacheResource( "particle", "particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_blood_bulk.vpcf", context )

	
end
function Advanced_assassinate:GetCooldown(iLevel)
	if self:GetUnlock(1)==1 then
		return 7
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end
function Advanced_assassinate:GetIntrinsicModifierName()
	return "modifier_Advanced_assassinate_effect"
end

function Advanced_assassinate:GetCastAnimation()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_sniper" then
		return ACT_DOTA_CAST_ABILITY_4
	end
	return ACT_DOTA_ATTACK
end
function Advanced_assassinate:GetAOERadius()
	return 400
end

function Advanced_assassinate:OnAbilityPhaseInterrupted()
	if self.modifier then
		self.modifier:SafeDestroy()
		self.modifier = nil
	end
end

function Advanced_assassinate:OnAbilityPhaseStart()
	if self.modifier then
		self.modifier:SafeDestroy()
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local debuff_duration = 4

	self.modifier = target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_assassinate", -- modifier name
		{ duration = debuff_duration } -- kv
	)

	-- play effects
	local sound_cast = "Ability.AssassinateLoad"
	caster:EmitSound(sound_cast)

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_assassinate:OnSpellStart()
	if self.modifier then
		self.modifier:SafeDestroy()
		self.modifier = nil
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	-- local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
	local projectile_speed = 3000

	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
		ExtraData = {powerful = 0}
	}
	local powerful = 0
	if self.advanced_level>=20 then
		local modifier = caster:FindModifierByName("modifier_Advanced_assassinate_effect")
		if modifier and modifier:GetRemainingTime()<=0 then
			modifier:SetDuration(20, true)
			info = {
				Target = target,
				Source = caster,
				Ability = self,	
				
				EffectName = "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_assassinate.vpcf",
				iMoveSpeed = projectile_speed,
				bDodgeable = false,                           -- Optional
				ExtraData = {powerful = 1}
			}
			powerful = 1
		elseif self.unlock3_modifier and self.unlock3_modifier:GetStackCount()>=1 then
			self.unlock3_modifier:DecrementStackCount()
			info = {
				Target = target,
				Source = caster,
				Ability = self,	
				
				EffectName = "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_assassinate.vpcf",
				iMoveSpeed = projectile_speed,
				bDodgeable = false,                           -- Optional
				ExtraData = {powerful = 1}
			}
			powerful = 1
		end
		if powerful==1 and self.unlock3 then
			if self:GetCooldownTimeRemaining()>3 then
				self:EndCooldown()
				self:StartCooldown(1)
			end
		end
		
		if self.unlock2 then
			info.ExtraData.unlock2_count = 3
		end
	end
	local id = ProjectileManager:CreateTrackingProjectile(info)
	self.modifier = nil

	-- effects
	local sound_cast = "Ability.Assassinate"
	EmitSoundOn( sound_cast, caster )
	local sound_target = "Hero_Sniper.AssassinateProjectile"
	EmitSoundOn( sound_target, target )


	if self.unlock1 then
		local modifier = caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_assassinate_unlock1", -- modifier name
			{powerful=powerful} -- kv
		)
		--不能放到modifier里一起传 因为数值太大了传不过去
		if modifier then
			modifier.projectile_id = id
		end
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_assassinate_unlock1_buff", -- modifier name
			{duration = 0.5} -- kv
		)

		
	end
end
-- function Advanced_assassinate:CreateID(id)
-- 	if not self.projectileID then
-- 		self.projectileID = {}
-- 		self.count = 1
-- 	end
-- 	self.projectileID[self.count] = id
-- 	return self.projectileID
-- end
-- function Advanced_assassinate:GetProjectileID()

-- end
--------------------------------------------------------------------------------
-- Projectile
function Advanced_assassinate:OnProjectileHit_ExtraData( target, location, extradata )
	-- cancel if gone
	if (not target) or target:IsInvulnerable() or target:IsOutOfGame() or target:TriggerSpellAbsorb( self ) then
		return
	end
	local radius = 400
	local pos = target:GetAbsOrigin()
	local caster = self:GetCaster()

	local stun_duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
	local pfx = ParticleManager:CreateParticle( "particles/units/unit_greevil/loot_greevil_death.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( pfx, 0, pos  )
	ParticleManager:SetParticleControl( pfx, 1, pos  )
	ParticleManager:ReleaseParticleIndex(pfx)


	-- apply damage
	local damage = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetDamageMax()
	if extradata.powerful == 1 then
		damage = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetAverageTrueAttackDamage(nil)
		stun_duration = stun_duration *10
	end
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_sniper_2") then
		damage = damage + caster:GetAverageTrueAttackDamage(nil)
	end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	target:Interrupt()
	local units = FindUnitsInRadius(caster:GetTeamNumber(),pos, nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local index = 0.5
	if self.advanced_level>=5 then
		index = 0.8
	end
	damageTable.damage = damage *index
	for _, unit in ipairs(units) do
		if unit~=target then
			damageTable.victim = unit
			ApplyDamage(damageTable)
			if extradata.powerful == 1 then
				unit:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
			end
		end

	end
	-- effects
	local sound_cast = "Hero_Sniper.AssassinateDamage"
	EmitSoundOn( sound_cast, target )

	if extradata.unlock2_count and extradata.unlock2_count>0 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(),pos, nil, 800,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
		for _, unit in ipairs(units) do
			local info = {
				Target = unit,
				Source = target,
				Ability = self,	
				
				EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
				iMoveSpeed = 3000,
				bDodgeable = false,                           -- Optional
				ExtraData = {powerful = extradata.powerful,unlock2_count = extradata.unlock2_count-1}
			}
			if extradata.powerful == 1 then
				info.EffectName = "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_assassinate.vpcf"
			end
			ProjectileManager:CreateTrackingProjectile(info)
			local sound_cast = "Ability.Assassinate"
			EmitSoundOn( sound_cast, target )
			local sound_target = "Hero_Sniper.AssassinateProjectile"
			EmitSoundOn( sound_target, unit )
			break
		end
	end
end













modifier_Advanced_assassinate = class({})

function modifier_Advanced_assassinate:IsHidden()	return true end
function modifier_Advanced_assassinate:IsDebuff()	return false end
function modifier_Advanced_assassinate:IsPurgable()	return false end
function modifier_Advanced_assassinate:RemoveOnDeath() return false end

function modifier_Advanced_assassinate:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_Advanced_assassinate:OnCreated( kv )
	if IsServer() then
		self:PlayEffects()
	end
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_assassinate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end
function modifier_Advanced_assassinate:GetModifierProvidesFOWVision()
	return true
end


function modifier_Advanced_assassinate:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end


function modifier_Advanced_assassinate:PlayEffects()

	local particle_cast = "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf"
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber() )
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		true
	)
end










modifier_Advanced_assassinate_effect = class({})

function modifier_Advanced_assassinate_effect:IsHidden()	return self:GetAbility():GetSpecialValueFor("advanced_level")<20 end
function modifier_Advanced_assassinate_effect:IsDebuff()	return false end
function modifier_Advanced_assassinate_effect:IsPurgable()	return false end
function modifier_Advanced_assassinate_effect:IsPurgeException() return false end
function modifier_Advanced_assassinate_effect:RemoveOnDeath() return false end
function modifier_Advanced_assassinate_effect:DestroyOnExpire()	return false end
function modifier_Advanced_assassinate_effect:GetTexture() return "sniper_fall20_assassinate" end

function modifier_Advanced_assassinate_effect:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_Advanced_assassinate_effect:OnAttackLanded(keys)
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end

	if not self:GetAbility():IsCooldownReady() then
		local index = 0.95
		if self:GetAbility().advanced_level>=10 then
			index = 0.925
		end
		local cooldown = self:GetAbility():GetCooldownTimeRemaining()
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(cooldown*index)
		return
	end

end







modifier_Advanced_assassinate_unlock1 = class({})

function modifier_Advanced_assassinate_unlock1:IsHidden()	return true end
function modifier_Advanced_assassinate_unlock1:IsDebuff()	return false end
function modifier_Advanced_assassinate_unlock1:IsPurgable()	return false end
function modifier_Advanced_assassinate_unlock1:IsPurgeException() return false end
function modifier_Advanced_assassinate_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_assassinate_unlock1:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_Advanced_assassinate_unlock1:DestroyOnExpire()	return false end
function modifier_Advanced_assassinate_unlock1:OnCreated(keys)
	if IsServer() then
		-- print("keys.id="..keys.projectile_id)
		-- self.id = keys.projectile_id
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*caster:GetDamageMax()
		if keys.powerful == 1 then
			damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*caster:GetAverageTrueAttackDamage(nil)
		end
		self.damageTable = {
			-- victim = target,
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
		}
		

		self.effectUnits = {}
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_Advanced_assassinate_unlock1:OnIntervalThink()
	if not self.projectile_id then
		return
	end
	if not ProjectileManager:IsValidProjectile( self.projectile_id ) then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	local location = ProjectileManager:GetTrackingProjectileLocation( self.projectile_id )
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	
		location,
		nil,
		200,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_CLOSEST,	
		false
	)
	local sound_cast = "Hero_Sniper.AssassinateDamage"
	-- particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_blood_bulk.vpcf
	local caster_poos =caster:GetAbsOrigin()
	for _, unit in ipairs(enemies) do
		if not self.effectUnits[unit] then
			self.effectUnits[unit] = true
			self.damageTable.victim = unit
			EmitSoundOn( sound_cast, unit )
			ApplyDamage(self.damageTable)
			local pos = unit:GetAbsOrigin()
			local pfx_min = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_blood_bulk.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx_min, 0, pos+Vector(0,0,64))
			local dir = CalculateDirection(pos,caster_poos)
			ParticleManager:SetParticleControlForward(pfx_min, 1, dir)  --方向
			ParticleManager:ReleaseParticleIndex(pfx_min)
		end
	end

end









modifier_Advanced_assassinate_unlock1_buff = class({})


function modifier_Advanced_assassinate_unlock1_buff:IsHidden()	return true end
function modifier_Advanced_assassinate_unlock1_buff:IsDebuff()	return false end
function modifier_Advanced_assassinate_unlock1_buff:IsStunDebuff()	return false end
function modifier_Advanced_assassinate_unlock1_buff:RemoveOnDeath()	return false end
-- function modifier_Advanced_assassinate_unlock1_buff:DestroyOnExpire()	return false end
function modifier_Advanced_assassinate_unlock1_buff:IsPurgable() 		return false end
function modifier_Advanced_assassinate_unlock1_buff:IsPurgeException() 	return false end

function modifier_Advanced_assassinate_unlock1_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_assassinate_unlock1_buff:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	-- local caster = self:GetParent()
	if ability:GetCooldownTimeRemaining()>3.5 then
		ability:EndCooldown()
		ability:StartCooldown(3.5)
	end


	
end











modifier_Advanced_assassinate_unlock3 = class({})


function modifier_Advanced_assassinate_unlock3:IsHidden()	return false end
function modifier_Advanced_assassinate_unlock3:IsDebuff()	return false end
function modifier_Advanced_assassinate_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_assassinate_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_assassinate_unlock3:IsPurgable() 		return false end
function modifier_Advanced_assassinate_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_assassinate_unlock3:GetTexture() return "sniper_fall20_assassinate" end
function modifier_Advanced_assassinate_unlock3:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_assassinate_unlock3:OnIntervalThink()

	if self:GetRemainingTime()<=0 then
		local stack = self:GetStackCount()
		if stack>=10 then
			return
		end
		self:SetDuration(5, true)
		self:SetStackCount(stack+1)
	end
end

function modifier_Advanced_assassinate_unlock3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
	}
end



function modifier_Advanced_assassinate_unlock3:OnAttack(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end

	self:SetDuration(5, true)

	
end

