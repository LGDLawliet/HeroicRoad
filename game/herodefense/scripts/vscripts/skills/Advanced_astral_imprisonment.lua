--特效优化 √
Advanced_astral_imprisonment = class({})
require('internal/timers')   --计时器功能
LinkLuaModifier( "modifier_Advanced_astral_imprisonment", "skills/Advanced_astral_imprisonment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_astral_imprisonment_buff", "skills/Advanced_astral_imprisonment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_astral_imprisonment_debuff", "skills/Advanced_astral_imprisonment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_astral_imprisonment_unlock1", "skills/Advanced_astral_imprisonment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_astral_imprisonment_unlock2", "skills/Advanced_astral_imprisonment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_astral_imprisonment_unlock3", "skills/Advanced_astral_imprisonment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_astral_imprisonment_debuff_unlock3", "skills/Advanced_astral_imprisonment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3", "heroTalent/heroTalent_npc_dota_hero_obsidian_destroyer_3", LUA_MODIFIER_MOTION_NONE )
function Advanced_astral_imprisonment:CheckKV(key)
	local table = {
		bonus_damage = 0.16,





	}
	local value = table[key] or -1
	return value

end


function Advanced_astral_imprisonment:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_astral_imprisonment:UnlockSecondCore(key)
	local caster = self:GetCaster()
	self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_astral_imprisonment_unlock2",{})
	return true
end
function Advanced_astral_imprisonment:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_astral_imprisonment_unlock3",{})
	return true

end
function Advanced_astral_imprisonment:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_end.vpcf" , context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf" , context )
end

function Advanced_astral_imprisonment:Spawn()
	self.talent_damage = 0
end

function Advanced_astral_imprisonment:GetAOERadius() 
	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local max_radius = 500
	if advanced_level>=10 then
		max_radius = 750
	end
	return self:GetSpecialValueFor("radius") +math.min(self:GetCaster():GetMana()*0.1,max_radius)
end

function Advanced_astral_imprisonment:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if advanced_level>=15 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AOE+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AOE
	end
end

function Advanced_astral_imprisonment:GetCustomCastErrorTarget(target)
	return "#Spells_CustomCastError_NOT_Enemy"
end

function Advanced_astral_imprisonment:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if self:GetAutoCastState() and target:GetTeamNumber()~=caster:GetTeamNumber() then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end





function Advanced_astral_imprisonment:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb(self) then
		return
	end
	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	local StatusResistance = 1

	if IsEnemy(caster,target) then
		StatusResistance = target:GetHDStatusResistanceIndex(1)
	end


	--自动施法队友
	if self:GetAutoCastState()  then
		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_astral_imprisonment_buff", -- modifier name
			{ duration = 4 } -- kv
		)
		self:StartCooldown(13)
		local timer = 0
		--固定15秒冷却 且5秒后再进入冷却
		Timers:CreateTimer(0.1, function()
			timer = timer+0.1
			if not self:IsCooldownReady() then
				self:StartCooldown(13)
				if timer<=5 then
					return 0.1
				end
			end
			
		end)
	else
		
		--天体囚牢
		if self.advanced_level>=20 and IsEnemy(caster,target) then
			local radius = self:GetSpecialValueFor("radius") +math.min(self:GetCaster():GetMana()*0.1,750)
			local duration = self:GetSpecialValueFor("duration")
			local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
			ParticleManager:SetParticleControl( effect_cast, 1, Vector(duration+0.2,0,0) )
			ParticleManager:SetParticleControl( effect_cast, 61, Vector(radius/200,0,0) )
			ParticleManager:SetParticleControl( effect_cast, 62, Vector(radius/100,0,0) )
			local caster = self:GetCaster()
			EmitSoundOnLocationWithCaster( caster:GetOrigin(), "Hero_ObsidianDestroyer.AstralImprisonment",caster )

			Timers:CreateTimer(duration, function()
		
				local effect_cast_damage = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", PATTACH_WORLDORIGIN, nil )
				ParticleManager:SetParticleControl( effect_cast_damage, 0, target:GetOrigin() )
				ParticleManager:SetParticleControl( effect_cast_damage, 1, Vector(radius,0,0) )
				ParticleManager:ReleaseParticleIndex(effect_cast_damage)
				StopSoundOn( "Hero_ObsidianDestroyer.AstralImprisonment", caster )
				EmitSoundOnLocationWithCaster(target:GetOrigin(), "Hero_ObsidianDestroyer.AstralImprisonment.End", caster )
				Timers:CreateTimer(0.2, function()
					ParticleManager:DestroyParticle(effect_cast, false)
					ParticleManager:ReleaseParticleIndex(effect_cast)
				end)

				
			end)
			local time = 0
			local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for i,target_unit in pairs(units) do
				StatusResistance = target_unit:GetHDStatusResistanceIndex(1)
				local true_duration = duration*StatusResistance 
				true_duration = math.max(true_duration,0.1)
				target_unit:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_Advanced_astral_imprisonment_debuff", -- modifier name
				{ duration = true_duration })
				time = time + true_duration
			end
			if self.unlock1 and time>0 then
				local unlock1_duration = time*caster:GetModifierDurationGainIndex(1)
				unlock1_duration = math.max(unlock1_duration,0.1)
				caster:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_astral_imprisonment_unlock1", -- modifier name
					{ duration = unlock1_duration,stack_time=unlock1_duration})
			end
		else
			--普通对敌
			local single_duration = math.max( duration*StatusResistance,0.1)
			target:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_Advanced_astral_imprisonment", -- modifier name
				{ duration = single_duration } -- kv
			)
		end
	end

	-- play effects
	local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.Cast"
	EmitSoundOn( sound_cast, caster )
end

function Advanced_astral_imprisonment:CreateSingleEffect(target)

	local duration = self:GetSpecialValueFor( "duration" )
	local StatusResistance = target:GetHDStatusResistanceIndex(1)

	duration = math.max( duration*StatusResistance,0.1)
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_Advanced_astral_imprisonment_debuff_unlock3", -- modifier name
		{ duration = duration } -- kv
	)
end


function Advanced_astral_imprisonment:GetTalent()
	if not self.talentAbility then
		
		local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_obsidian_destroyer_3")
		if ability then
			self.talentAbility = ability
		end
	end

	return self.talentAbility
end
function Advanced_astral_imprisonment:TalentRecord(damage)
	self.talent_damage = self.talent_damage + damage
	local bonus = math.floor(self.talent_damage /1000)
	if bonus>=1 then
		self.talent_damage = self.talent_damage - bonus * 1000
		self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self.talentAbility,
			"modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3", {duration=60,stack=bonus*10}
		)
	end

end


modifier_Advanced_astral_imprisonment = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_astral_imprisonment:IsHidden()	return false end
function modifier_Advanced_astral_imprisonment:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_Advanced_astral_imprisonment:IsStunDebuff()	return true end
function modifier_Advanced_astral_imprisonment:IsPurgable()	return true end
function modifier_Advanced_astral_imprisonment:RemoveOnDeath()	return false end
function modifier_Advanced_astral_imprisonment:GetStatusEffectName() return "particles/status_fx/status_effect_vengeful_venge_image.vpcf" end
function modifier_Advanced_astral_imprisonment:StatusEffectPriority() return 100 end

function modifier_Advanced_astral_imprisonment:OnCreated( kv )

	if IsClient() then
		return
	end
	self.advanced_level = self:GetAbility().advanced_level
	local max_bonus_radius = 500
	local damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	local bonus_damgage = self:GetCaster():GetMana()*0.25
	if self.advanced_level>=5 and self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		bonus_damgage = self:GetCaster():GetMana()*0.5
		if self.advanced_level>=10 then
			max_bonus_radius = 750
		end
	end
	damage = damage +bonus_damgage
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )+math.min(self:GetCaster():GetMana()*0.1,max_bonus_radius)


	local ability = self:GetAbility():GetTalent()
	if ability then
		damage = damage + ability:GetBonusDamage(self:GetAbility():GetAbilityName())
		self.talentAbility = ability
	end
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}


	-- play effects
	if self:GetAbility().advanced_level>=5 and self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		--do nothing
	else
		self:GetParent():AddNoDraw()
	end
	self:PlayEffects()
end

function modifier_Advanced_astral_imprisonment:OnRefresh( kv )
	self.advanced_level = self:GetAbility().advanced_level
	local max_bonus_radius = 500
	local damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	local bonus_damgage = self:GetCaster():GetMana()*0.25
	if self.advanced_level>=5 and self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		bonus_damgage = self:GetCaster():GetMana()*0.5
		if self.advanced_level>=10 then
			max_bonus_radius = 750
		end
	end
	damage = damage +bonus_damgage
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )+math.min(self:GetCaster():GetMana()*0.1,max_bonus_radius)


	local ability = self:GetAbility():GetTalent()
	if ability then
		self.talentAbility = ability
		damage = damage + ability:GetBonusDamage(self:GetAbility():GetAbilityName())
	end
	self.damageTable.damage = damage
end



function modifier_Advanced_astral_imprisonment:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local totalDamage = 0
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		totalDamage = totalDamage  + ApplyDamage( self.damageTable )
	end
	if self.talentAbility then
		self:GetAbility():TalentRecord(totalDamage)
	end
	local effect_cast_damage = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast_damage, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast_damage, 1, Vector(self.radius,0,0) )
	ParticleManager:ReleaseParticleIndex(effect_cast_damage)
	-- play effects
	self:GetParent():RemoveNoDraw()
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	StopSoundOn( sound_loop, self:GetCaster() )

	local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.End"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_astral_imprisonment:CheckState()
	if not IsServer() then
		return
	end
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	if self:GetAbility().advanced_level>=5 and self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		state = {
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_HEXED] = true,
			[MODIFIER_STATE_DISARMED] = true,
		}
	end
	

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_astral_imprisonment:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf"
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	
	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_loop, self:GetCaster() )
end







modifier_Advanced_astral_imprisonment_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_astral_imprisonment_buff:IsHidden()	return false end
function modifier_Advanced_astral_imprisonment_buff:IsDebuff()	return false end

function modifier_Advanced_astral_imprisonment_buff:IsStunDebuff()	return true end
function modifier_Advanced_astral_imprisonment_buff:IsPurgable()	return true end
function modifier_Advanced_astral_imprisonment_buff:RemoveOnDeath()	return false end
function modifier_Advanced_astral_imprisonment_buff:GetStatusEffectName() return "particles/status_fx/status_effect_vengeful_venge_image.vpcf" end
function modifier_Advanced_astral_imprisonment_buff:StatusEffectPriority() return 100 end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_astral_imprisonment_buff:OnCreated( kv )

	if IsClient() then
		return
	end
	self.advanced_level = self:GetAbility().advanced_level
	local max_bonus_radius = 750
	local damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	local bonus_damgage = self:GetCaster():GetMana()*0.5
	damage = damage +bonus_damgage
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )+math.min(self:GetCaster():GetMana()*0.1,max_bonus_radius)


	local ability = self:GetAbility():GetTalent()
	if ability then
		self.talentAbility = ability
		damage = damage + ability:GetBonusDamage(self:GetAbility():GetAbilityName())
	end
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	
	self:PlayEffects()
end

function modifier_Advanced_astral_imprisonment_buff:OnRefresh( kv )
	self.advanced_level = self:GetAbility().advanced_level
	local max_bonus_radius = 750
	local damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	local bonus_damgage = self:GetCaster():GetMana()*5
	damage = damage +bonus_damgage
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )+math.min(self:GetCaster():GetMana()*0.1,max_bonus_radius)


	local ability = self:GetAbility():GetTalent()
	if ability then
		self.talentAbility = ability
		damage = damage + ability:GetBonusDamage(self:GetAbility():GetAbilityName())
	end
	self.damageTable.damage = damage
end



function modifier_Advanced_astral_imprisonment_buff:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local totalDamage = 0
	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		totalDamage = totalDamage + ApplyDamage( self.damageTable )


	end
	if self.talentAbility then
		self:GetAbility():TalentRecord(totalDamage)
	end
	local effect_cast_damage = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast_damage, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast_damage, 1, Vector(self.radius,0,0) )
	ParticleManager:ReleaseParticleIndex(effect_cast_damage)
	-- play effects
	-- self:GetParent():RemoveNoDraw()
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	StopSoundOn( sound_loop, self:GetCaster() )
	local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.End"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_astral_imprisonment_buff:CheckState()
	if not IsServer() then
		return
	end
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_astral_imprisonment_buff:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf"
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"

	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )


	



	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_loop, self:GetCaster() )
end
















modifier_Advanced_astral_imprisonment_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_astral_imprisonment_debuff:IsHidden()	return false end
function modifier_Advanced_astral_imprisonment_debuff:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_Advanced_astral_imprisonment_debuff:IsStunDebuff()	return true end
function modifier_Advanced_astral_imprisonment_debuff:IsPurgable()	return true end
function modifier_Advanced_astral_imprisonment_debuff:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_astral_imprisonment_debuff:OnCreated( kv )
	if IsClient() then
		return
	end
	local damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	local bonus_damgage = self:GetCaster():GetMana()*0.25
	damage = damage +bonus_damgage

	local ability = self:GetAbility():GetTalent()
	if ability then
		self.talentAbility = ability
		damage = damage + ability:GetBonusDamage(self:GetAbility():GetAbilityName())
	end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}


	self:GetParent():AddNoDraw()

end


function modifier_Advanced_astral_imprisonment_debuff:OnDestroy()
	if not IsServer() then return end

	local damage = ApplyDamage( self.damageTable )
	if self.talentAbility then
		self:GetAbility():TalentRecord(damage)
	end
	self:GetParent():RemoveNoDraw()

	local effect_cast_damage = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_end.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast_damage, 0, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast_damage)
	
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_astral_imprisonment_debuff:CheckState()
	if not IsServer() then
		return
	end
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}


	return state
end





modifier_Advanced_astral_imprisonment_unlock1 = class({})

function modifier_Advanced_astral_imprisonment_unlock1:IsHidden()	return false end
function modifier_Advanced_astral_imprisonment_unlock1:IsDebuff()	return false end
function modifier_Advanced_astral_imprisonment_unlock1:IsPurgable()	return false end
function modifier_Advanced_astral_imprisonment_unlock1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,
	}

	return funcs
end

function modifier_Advanced_astral_imprisonment_unlock1:GetModifierExtraManaPercentage()	return 10*self:GetStackCount() end






function modifier_Advanced_astral_imprisonment_unlock1:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_astral_imprisonment_unlock1:OnRefresh(params)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+params.stack_time
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_astral_imprisonment_unlock1:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end


modifier_Advanced_astral_imprisonment_unlock2 = class({})

function modifier_Advanced_astral_imprisonment_unlock2:IsHidden()	return false end
function modifier_Advanced_astral_imprisonment_unlock2:IsDebuff()	return false end
function modifier_Advanced_astral_imprisonment_unlock2:IsPurgable()	return false end
function modifier_Advanced_astral_imprisonment_unlock2:IsPurgeException() return false end
function modifier_Advanced_astral_imprisonment_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_astral_imprisonment_unlock2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MANA_BONUS

	}

	return funcs
end

function modifier_Advanced_astral_imprisonment_unlock2:GetModifierManaBonus()
	return self:GetStackCount()*800
end



function modifier_Advanced_astral_imprisonment_unlock2:OnAbilityFullyCast( keys )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		
		local time = keys.ability:GetCooldown(keys.ability:GetLevel())
		if time < 3 then
			return
		end
	
		local gain = self:GetParent():GetModifierDurationGainIndex(1)
		local caster = self:GetParent()

		self:AddStack(14*gain)
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		caster:EmitSound("Hero_ObsidianDestroyer.EssenceFlux.Cast")

	end
end



function modifier_Advanced_astral_imprisonment_unlock2:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_astral_imprisonment_unlock2:AddStack(time)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+time
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_astral_imprisonment_unlock2:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end


modifier_Advanced_astral_imprisonment_unlock3 = class({})

function modifier_Advanced_astral_imprisonment_unlock3:IsHidden()	return true end
function modifier_Advanced_astral_imprisonment_unlock3:IsDebuff()	return false end
function modifier_Advanced_astral_imprisonment_unlock3:IsPurgable()	return false end
function modifier_Advanced_astral_imprisonment_unlock3:IsPurgeException() return false end
function modifier_Advanced_astral_imprisonment_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_astral_imprisonment_unlock3:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
	end
end

function modifier_Advanced_astral_imprisonment_unlock3:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,

    }
end



function modifier_Advanced_astral_imprisonment_unlock3:OnAttackStart(keys)
	if not IsServer() then return end
	
	-- "Does not work against wards, buildings and allies."
    if self.parent == keys.target and not self.parent:PassivesDisabled() and not keys.attacker:IsOther() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then
		if keys.attacker:IsMagicImmune() then
            return
        end
		if keys.attacker:IsInvulnerable() then
			return
		end
		if self.parent:PassivesDisabled() then
			return
		end
		if not keys.attacker.astral_imprisonment_unlock3 then
			keys.attacker.astral_imprisonment_unlock3 = GameRules:GetGameTime()
		end
        if keys.attacker.astral_imprisonment_unlock3>GameRules:GetGameTime() then
			return
		end
		keys.attacker.astral_imprisonment_unlock3= GameRules:GetGameTime()+10
		self:GetAbility():CreateSingleEffect(keys.attacker)
    end
end








modifier_Advanced_astral_imprisonment_debuff_unlock3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_astral_imprisonment_debuff_unlock3:IsHidden()	return true end
function modifier_Advanced_astral_imprisonment_debuff_unlock3:IsDebuff()
	return true
end

function modifier_Advanced_astral_imprisonment_debuff_unlock3:IsStunDebuff()	return true end
function modifier_Advanced_astral_imprisonment_debuff_unlock3:IsPurgable()	return true end
function modifier_Advanced_astral_imprisonment_debuff_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_astral_imprisonment_debuff_unlock3:GetStatusEffectName() return "particles/status_fx/status_effect_vengeful_venge_image.vpcf" end
function modifier_Advanced_astral_imprisonment_debuff_unlock3:StatusEffectPriority() return 100 end
function modifier_Advanced_astral_imprisonment_debuff_unlock3:OnCreated( kv )
	if IsClient() then
		return
	end
	self.advanced_level = self:GetAbility().advanced_level
	-- local max_bonus_radius = 500
	local damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	local bonus_damgage = self:GetCaster():GetMana()*0.25

	damage = damage +bonus_damgage
	local ability = self:GetAbility():GetTalent()
	if ability then
		self.talentAbility = ability
		damage = damage + ability:GetBonusDamage(self:GetAbility():GetAbilityName())
	end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}


	self:GetParent():AddNoDraw()
	self:PlayEffects()
end




function modifier_Advanced_astral_imprisonment_debuff_unlock3:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local damage = ApplyDamage( self.damageTable )
	if self.talentAbility then
		self:GetAbility():TalentRecord(damage)
	end
	local effect_cast_damage = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast_damage, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast_damage, 1, Vector(300,0,0) )
	ParticleManager:ReleaseParticleIndex(effect_cast_damage)
	-- play effects
	self:GetParent():RemoveNoDraw()
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	StopSoundOn( sound_loop, self:GetCaster() )

	local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.End"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_astral_imprisonment_debuff_unlock3:CheckState()
	if not IsServer() then
		return
	end
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_astral_imprisonment_debuff_unlock3:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf"
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	
	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_loop, self:GetCaster() )
end
