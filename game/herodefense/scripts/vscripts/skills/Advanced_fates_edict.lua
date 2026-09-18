--特效优化 √
Advanced_fates_edict = class({})

--------------------------------------------------------------------------------
-- Ability Start

LinkLuaModifier("modifier_Advanced_fates_edict_buff", "skills/Advanced_fates_edict", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fates_edict_debuff", "skills/Advanced_fates_edict", LUA_MODIFIER_MOTION_NONE)



LinkLuaModifier("modifier_Advanced_fates_edict_unlock2", "skills/Advanced_fates_edict", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fates_edict_unlock3", "skills/Advanced_fates_edict", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_fates_edict_unlock2_effect", "skills/Advanced_fates_edict", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fates_edict_unlock3_effect", "skills/Advanced_fates_edict", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能


function Advanced_fates_edict:CheckKV(key)
	local table = {


		duration = 0.15,


	}
	local value = table[key] or -1
	return value

end

function Advanced_fates_edict:UnlockFirstCore(key)
	return true
end
function Advanced_fates_edict:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_fates_edict_unlock2",{})
	return true
end
function Advanced_fates_edict:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_fates_edict_unlock3",{})
	return true
end


function Advanced_fates_edict:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/fates_edict/unlock1/effect.vpcf", context )

end










function Advanced_fates_edict:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:GetTeamNumber()~=caster:GetTeamNumber() then
		if target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
			return
		end
	end
	local duration = self:GetSpecialValueFor("duration")

	if target:GetTeamNumber()==caster:GetTeamNumber() then

		local StatusResistance = target:GetHDStatusResistanceIndex(1)
		local gain = 0
		--LV15解锁真言
		if self.advanced_level>=15 and caster:GetModifierDurationGainIndex(1)>0 then
			gain = caster:GetModifierDurationGainIndex(1)
		else
			gain = caster:GetModifierDurationGainIndex(0.5)
		end
		

		--LV20解锁无我
		if self.advanced_level<20 then
			target:AddNewModifier(caster, self, "modifier_Advanced_fates_edict_debuff", {duration = duration*StatusResistance})
		end
		target:AddNewModifier(caster, self, "modifier_Advanced_fates_edict_buff", {duration = duration*gain})
		target:Purge(false, true, false, true, true) --可移除眩晕的强驱散
		

	else
		local ModifierStatusNegativeGain = 0
		--LV15解锁真言
		if self.advanced_level>=15 and caster:GetModifierStatusNegativeGainIndex(1)>1 then
			
			ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1.4)
		else
			ModifierStatusNegativeGain =caster:GetModifierStatusNegativeGainIndex(0.7)
		end
		local StatusResistance =  target:GetHDStatusResistanceIndex(0.7)*ModifierStatusNegativeGain
		--LV20解锁无我
		if self.advanced_level<20 then
			target:AddNewModifier(caster, self, "modifier_Advanced_fates_edict_buff", {duration = duration})
		end
		target:AddNewModifier(caster, self, "modifier_Advanced_fates_edict_debuff", {duration = duration*StatusResistance})

	end

	target:EmitSound("Hero_Oracle.FatesEdict.Cast")
	

end



modifier_Advanced_fates_edict_buff = advanced_modifier({})

function modifier_Advanced_fates_edict_buff:IsDebuff() return false end
function modifier_Advanced_fates_edict_buff:IsHidden() return false end
function modifier_Advanced_fates_edict_buff:IsPurgable() return true end
function modifier_Advanced_fates_edict_buff:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
function modifier_Advanced_fates_edict_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_fates_edict_buff:OnCreated(table)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local advanced_level = ability:GetSpecialValueFor("advanced_level")

	self.SPELL_AMPLIFY_PERCENTAGE = 0
	self.bonus_damage = 0
	if self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		self.SPELL_AMPLIFY_PERCENTAGE = 35
		self.bonus_damage = 120
		--LV5解锁启示+
		if advanced_level>=5 then
			self.SPELL_AMPLIFY_PERCENTAGE = self.SPELL_AMPLIFY_PERCENTAGE*1.5
			self.bonus_damage = self.bonus_damage*1.5
		end
	end
	if self:GetAbility():GetUnlock(1)==1 and self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() and self:GetParent()~=self:GetCaster() then
		self.unlock1 = true

	end
end
function modifier_Advanced_fates_edict_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}

	return funcs
end



function modifier_Advanced_fates_edict_buff:GetModifierMagicalResistanceBonus() return 100 end
function modifier_Advanced_fates_edict_buff:GetModifierBaseAttack_BonusDamage() return self.bonus_damage end
function modifier_Advanced_fates_edict_buff:Advanced_GetModifierSpellAmplifyBonus(keys)
	-- local ability = self:GetAbility()
	if self.unlock1 then
		if IsClient() then
			return
		end
		
	
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then
			return 0
		end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
		if not keys.inflictor then
			return
		end
		if keys.damage<=0 then
			return 0
		end
		if IsEnemy(keys.target,keys.attacker) then
			local damageTable = {
				victim = keys.target,
				attacker = self:GetCaster(),
				damage = keys.damage*1.3,
				damage_type = keys.damage_type,
				damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT,
				ability = self:GetAbility(), --Optional.
			}
			ApplyDamage(damageTable)
			self:PlayEffects(keys.attacker,keys.target)
			return -10000
		end
	

	else
		return self.SPELL_AMPLIFY_PERCENTAGE
	end
	

end


function modifier_Advanced_fates_edict_buff:PlayEffects( source,target )
	local particle_cast = "particles/rebuild/spell/fates_edict/unlock1/effect.vpcf"
	local caster = self:GetCaster()
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  source)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:ReleaseParticleIndex(particle_return_fx)
	DestroyParticleByDelay(particle_return_fx,1.5)

	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  caster)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)
	DestroyParticleByDelay(particle_return_fx,1.5)
	
end

function modifier_Advanced_fates_edict_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
modifier_Advanced_fates_edict_debuff = advanced_modifier({})

function modifier_Advanced_fates_edict_debuff:IsDebuff() return true end
function modifier_Advanced_fates_edict_debuff:IsHidden() return false end
function modifier_Advanced_fates_edict_debuff:IsPurgable() return true end
function modifier_Advanced_fates_edict_debuff:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
function modifier_Advanced_fates_edict_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_fates_edict_debuff:OnCreated(table)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.SPELL_AMPLIFY_PERCENTAGE = 0
	self.bonus_damage = 0
	if self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
		self.SPELL_AMPLIFY_PERCENTAGE = -30
		self.bonus_damage = -150
		--LV10解锁揭示+
		if advanced_level>=10 then
			self.SPELL_AMPLIFY_PERCENTAGE  = self.SPELL_AMPLIFY_PERCENTAGE *1.5
			self.bonus_damage = self.bonus_damage*1.5
		end
	end
end
function modifier_Advanced_fates_edict_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end

function modifier_Advanced_fates_edict_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end



function modifier_Advanced_fates_edict_debuff:Advanced_GetModifierSpellAmplifyBonus() return self.SPELL_AMPLIFY_PERCENTAGE end
function modifier_Advanced_fates_edict_debuff:GetModifierBaseAttack_BonusDamage() return self.bonus_damage end


function modifier_Advanced_fates_edict_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end










modifier_Advanced_fates_edict_unlock2 = class({})

function modifier_Advanced_fates_edict_unlock2:IsDebuff()			return false end
function modifier_Advanced_fates_edict_unlock2:IsHidden() 			return true end
function modifier_Advanced_fates_edict_unlock2:IsPurgable() 		return false end
function modifier_Advanced_fates_edict_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_fates_edict_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_fates_edict_unlock2:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_fates_edict_unlock2:GetModifierAura()	return "modifier_Advanced_fates_edict_unlock2_effect" end
function modifier_Advanced_fates_edict_unlock2:GetAuraRadius()	
	return 1500
end
function modifier_Advanced_fates_edict_unlock2:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_fates_edict_unlock2:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end






modifier_Advanced_fates_edict_unlock2_effect = advanced_modifier({})

function modifier_Advanced_fates_edict_unlock2_effect:IsDebuff() return false end
function modifier_Advanced_fates_edict_unlock2_effect:IsHidden() return false end
function modifier_Advanced_fates_edict_unlock2_effect:IsPurgable() return false end
function modifier_Advanced_fates_edict_unlock2_effect:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
function modifier_Advanced_fates_edict_unlock2_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_fates_edict_unlock2_effect:OnCreated(table)
	self.SPELL_AMPLIFY_PERCENTAGE = 52.5
	self.bonus_damage = 180

end
function modifier_Advanced_fates_edict_unlock2_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}

	return funcs
end


function modifier_Advanced_fates_edict_unlock2_effect:GetModifierMagicalResistanceBonus() return 30 end
function modifier_Advanced_fates_edict_unlock2_effect:Advanced_GetModifierSpellAmplifyBonus() return self.SPELL_AMPLIFY_PERCENTAGE end
function modifier_Advanced_fates_edict_unlock2_effect:GetModifierBaseAttack_BonusDamage() return self.bonus_damage end



function modifier_Advanced_fates_edict_unlock2_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end








modifier_Advanced_fates_edict_unlock3 = class({})

function modifier_Advanced_fates_edict_unlock3:IsDebuff()			return false end
function modifier_Advanced_fates_edict_unlock3:IsHidden() 			return true end
function modifier_Advanced_fates_edict_unlock3:IsPurgable() 		return false end
function modifier_Advanced_fates_edict_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_fates_edict_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_fates_edict_unlock3:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_fates_edict_unlock3:GetModifierAura()	return "modifier_Advanced_fates_edict_unlock3_effect" end
function modifier_Advanced_fates_edict_unlock3:GetAuraRadius()	
	return 1000
end
function modifier_Advanced_fates_edict_unlock3:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_fates_edict_unlock3:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end




modifier_Advanced_fates_edict_unlock3_effect = advanced_modifier({})

function modifier_Advanced_fates_edict_unlock3_effect:IsDebuff() return true end
function modifier_Advanced_fates_edict_unlock3_effect:IsHidden() return false end
function modifier_Advanced_fates_edict_unlock3_effect:IsPurgable() return false end
-- function modifier_Advanced_fates_edict_unlock3_effect:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
-- function modifier_Advanced_fates_edict_unlock3_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_fates_edict_unlock3_effect:OnCreated(table)

	self.SPELL_AMPLIFY_PERCENTAGE = -45
	self.bonus_damage = -225
	
end


function modifier_Advanced_fates_edict_unlock3_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_Advanced_fates_edict_unlock3_effect:Advanced_GetModifierSpellAmplifyBonus() return self.SPELL_AMPLIFY_PERCENTAGE end
function modifier_Advanced_fates_edict_unlock3_effect:GetModifierBaseAttack_BonusDamage() return self.bonus_damage end


function modifier_Advanced_fates_edict_unlock3_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

