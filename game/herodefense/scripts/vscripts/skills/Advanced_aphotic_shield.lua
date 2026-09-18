
Advanced_aphotic_shield = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_aphotic_shield", "skills/Advanced_aphotic_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_aphotic_shield_unlock2_aura", "skills/Advanced_aphotic_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_aphotic_shield_unlock2_aura_effect", "skills/Advanced_aphotic_shield", LUA_MODIFIER_MOTION_NONE)
function Advanced_aphotic_shield:IsHiddenWhenStolen() 		return false end
function Advanced_aphotic_shield:IsRefreshable() 			return true end
function Advanced_aphotic_shield:IsStealable() 				return true end
function Advanced_aphotic_shield:IsNetherWardStealable()	return true end
function Advanced_aphotic_shield:GetBehavior()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	-- local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if self:GetCaster():HasModifier("modifier_Advanced_aphotic_shield_unlock2_aura") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end

	--LV5解锁范围施法
	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
function Advanced_aphotic_shield:GetAOERadius() 
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	--LV5解锁范围施法
	if advanced_level>=20 then
		return 350
	end

end

function Advanced_aphotic_shield:GetCustomCastErrorTarget(target)
	
	if self:GetUnlock(3)==3 then
		local caster = self:GetCaster()
		if caster:GetTeamNumber()~=target:GetTeamNumber() then
			return ""
		end
		return "#Spells_CustomCastError_NOT_Friendly"
	end

	return self.BaseClass.GetCustomCastErrorTarget(self,target)
end

function Advanced_aphotic_shield:CastFilterResultTarget(target)
	if self:GetUnlock(3)==3 then
		local caster = self:GetCaster()
		if caster:GetTeamNumber()~=target:GetTeamNumber() then
			return UF_SUCCESS
		end
		return UF_FAIL_CUSTOM
	end
	return self.BaseClass.CastFilterResultTarget(self,target)
end


function Advanced_aphotic_shield:OnSpellStart()
	local target = self:GetCursorTarget()
	
	--LV20解锁范围施法
	if self.advanced_level>=20 then
		local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for i,target_unit in pairs(units) do
			if self.unlock3 then
				self:PlayerEffectUnlock3(target_unit)
			else
				self:PlayerEffect(target_unit)
			end
		
			if i>=3 then
				break
			end
		end
	else
		self:PlayerEffect(target)
	end
	
end
function Advanced_aphotic_shield:PlayerEffect(target)
	local buff = target:FindModifierByName("modifier_Advanced_aphotic_shield")
	if buff then
		buff:SetStackCount(0)
		buff:SafeDestroy()
	end
	local duration = self:GetSpecialValueFor("duration")

	-- 生命转化伤害
	local damage = target:GetMaxHealth()*0.1
	local shiel_index = 2
	--LV10解锁生命转化
	if self.advanced_level>=10 then
		shiel_index = 4
	end

	if self.unlock1 then
		duration = duration *2 
		damage = damage *2
		shiel_index = 15

	end
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --不致死与不触发吸血，技能伤害
		ability = self, --Optional.
	}

	ApplyDamage(damageTable)
	local ModifierStatusGain = self:GetCaster():GetModifierDurationGainIndex(1)


	target:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_aphotic_shield", {duration = duration*ModifierStatusGain,bonus_shield = damage*shiel_index})
	target:Purge(false, true, false, true, false)
end


function Advanced_aphotic_shield:PlayerEffectUnlock3(target)
	local buff = target:FindModifierByName("modifier_Advanced_aphotic_shield")
	if buff then
		buff:SetStackCount(0)
		buff:SafeDestroy()
	end
	local duration = self:GetSpecialValueFor("duration")

	local caster = self:GetCaster()
	-- 生命转化伤害
	local damage = caster:GetMaxHealth()*0.1
	local shiel_index = 4



	local damageTable = {
		victim = caster,
		attacker =caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --不致死与不触发吸血，技能伤害
		ability = self, --Optional.
	}

	ApplyDamage(damageTable)
	local ModifierStatusGain = self:GetCaster():GetModifierDurationGainIndex(1)


	target:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_aphotic_shield", {duration = duration*ModifierStatusGain,bonus_shield = damage*shiel_index})
	target:Purge(false, true, false, true, false)
end

function Advanced_aphotic_shield:CheckKV(key)
	local table = {
		spell_sheild = 2,
		str_index = 0.1,
		spell_damage = 1,
		str_damage = 0.05,



	}
	local value = table[key] or -1
	return value

end

function Advanced_aphotic_shield:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock1",{})
	return true
end
function Advanced_aphotic_shield:UnlockSecondCore(key)	
    local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_aphotic_shield_unlock2_aura",{})
	return true
end
function Advanced_aphotic_shield:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock3",{})
	return true
end



function Advanced_aphotic_shield:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/aphotic_shield/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/aphotic_shield/unlock3/effect_explosion.vpcf", context )

end


modifier_Advanced_aphotic_shield = advanced_modifier({})

function modifier_Advanced_aphotic_shield:IsDebuff()			return false end
function modifier_Advanced_aphotic_shield:IsHidden() 			return false end
function modifier_Advanced_aphotic_shield:IsPurgable() 			return true end
function modifier_Advanced_aphotic_shield:IsPurgeException() 	return true end

function modifier_Advanced_aphotic_shield:OnCreated(keys)
	if IsServer() then


		local ability = self:GetAbility()
		if ability.unlock3 then
			self.unlock3 = true
		end
		local caster = self:GetCaster()
		local parent = self:GetParent()
		self.advanced_level = ability.advanced_level
		local shield = ability:GetSpecialValueFor("spell_sheild")+(ability:GetSpecialValueFor("str_index"))*caster:GetStrength()
		self:SetStackCount(shield+keys.bonus_shield)

		EmitSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
		EmitSoundOn("Hero_Abaddon.AphoticShield.Cast", parent)

		local particle_name = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf"
		if ability.unlock1 then
			particle_name = "particles/rebuild/spell/aphotic_shield/unlock1/effect.vpcf"
		end
		local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		local ex = parent:GetModelScale() * 100
		ParticleManager:SetParticleControl(pfx, 1, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 2, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 4, Vector(ex,ex,ex))
		self:AddParticle(pfx, false, false, 15, false, false)

		self.damage_absorb =30
		self.total_damage_absorb_chance = 15
		--LV5解锁能量吸收
		if self.advanced_level>=5 then
			self.damage_absorb = 60
			self.total_damage_absorb_chance = 22
		end
	end
end




function modifier_Advanced_aphotic_shield:OnDestroy()

	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		if ability.unlock3 then
			
			local particle_name ="particles/rebuild/spell/aphotic_shield/unlock3/effect_explosion.vpcf"
			local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, self:GetParent())
			local pos = self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment("attach_hitloc"))
			ParticleManager:SetParticleControl(pfx, 0, pos)
			ParticleManager:SetParticleControl(pfx, 5, pos)
			ParticleManager:ReleaseParticleIndex(pfx)
			parent:EmitSound("Hero_Spectre.Arcana.AltRun")

		end
	


	
		local caster = self:GetCaster()

		local damage = ability:GetSpecialValueFor("spell_damage")+(ability:GetSpecialValueFor("str_damage"))*caster:GetStrength()
		if ability.unlock3 then
			damage =damage * 4
		end
		StopSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
		EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", parent)

	
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											parent:GetAbsOrigin(),
											nil,
											ability:GetSpecialValueFor("radius"),
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
		for i, enemy in pairs(enemies) do

			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = damage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end
	end
end


function modifier_Advanced_aphotic_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_Advanced_aphotic_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end


	--过滤低伤害
	if keys.damage<=self.damage_absorb  then
		return keys.damage
	end

	--几率抵消所有伤害
	if self.total_damage_absorb_chance>=RandomInt(1, 100) and keys.damage<self:GetParent():GetMaxHealth()*0.5 then

		return keys.damage
	end

	if self.advanced_level>=15 then
		-- LV15 每点伤害仅消耗0.75护盾值
		local reduce = keys.damage*0.75
		if reduce >  stack then
			stack = stack /0.75
			self:SetStackCount(0)
		else
			self:SetStackCount(stack- math.max(0, reduce))
			stack=keys.damage
		end

	else
		if keys.damage >  stack then
			self:SetStackCount(0)
		else
			self:SetStackCount(stack- math.max(0, keys.damage))
			stack=keys.damage
		end
		
	end


	return stack
end















modifier_Advanced_aphotic_shield_unlock2_aura = class({})

function modifier_Advanced_aphotic_shield_unlock2_aura:IsDebuff()			return false end
function modifier_Advanced_aphotic_shield_unlock2_aura:IsHidden() 			return false end
function modifier_Advanced_aphotic_shield_unlock2_aura:IsPurgable() 		return false end
function modifier_Advanced_aphotic_shield_unlock2_aura:IsPurgeException() 	return false end
function modifier_Advanced_aphotic_shield_unlock2_aura:RemoveOnDeath() return false end
function modifier_Advanced_aphotic_shield_unlock2_aura:IsAura()
	if not self:GetParent():IsAlive() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_aphotic_shield_unlock2_aura:GetModifierAura()	return "modifier_Advanced_aphotic_shield_unlock2_aura_effect" end
function modifier_Advanced_aphotic_shield_unlock2_aura:GetAuraRadius()	return -1  end
function modifier_Advanced_aphotic_shield_unlock2_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_aphotic_shield_unlock2_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_aphotic_shield_unlock2_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end








modifier_Advanced_aphotic_shield_unlock2_aura_effect = class({})

function modifier_Advanced_aphotic_shield_unlock2_aura_effect:IsDebuff()			return false end
function modifier_Advanced_aphotic_shield_unlock2_aura_effect:IsHidden() 			return true end
function modifier_Advanced_aphotic_shield_unlock2_aura_effect:IsPurgable() 		return false end
function modifier_Advanced_aphotic_shield_unlock2_aura_effect:IsPurgeException() 	return false end
function modifier_Advanced_aphotic_shield_unlock2_aura_effect:OnCreated()
	if IsServer() then
		self.time = GameRules:GetGameTime() +10
		local ability = self:GetAbility()
		ability:PlayerEffect(self:GetParent())
		self:StartIntervalThink(0.2)
	end
end



function modifier_Advanced_aphotic_shield_unlock2_aura_effect:OnIntervalThink()
	if GameRules:GetGameTime()>=self.time then
		local ability = self:GetAbility()
		ability:PlayerEffect(self:GetParent())
		self.time = GameRules:GetGameTime() + 10
	end
end






function modifier_Advanced_aphotic_shield_unlock2_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_Advanced_aphotic_shield_unlock2_aura_effect:OnTakeDamage(keys)
    if IsServer() then  

		if keys.unit == self:GetParent() then
			if keys.damage<=0 then
				return
			end
			self.time = GameRules:GetGameTime() + 10

		end
    end 
end
