--特效优化 √
Advanced_mist_coil = class({})

--------------------------------------------------------------------------------
-- Ability Start
LinkLuaModifier("modifier_Advanced_mist_coil_active", "skills/Advanced_mist_coil", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_mist_coil_unlock1", "skills/Advanced_mist_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_mist_coil_unlock2", "skills/Advanced_mist_coil", LUA_MODIFIER_MOTION_NONE)



function Advanced_mist_coil:CheckKV(key)
	local table = {

	


		spell_damage = 15,
		str_index = 0.15,





	}
	local value = table[key] or -1
	return value

end

function Advanced_mist_coil:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_mist_coil_unlock1",{})
	return true
end
function Advanced_mist_coil:UnlockSecondCore(key)
	local caster = self:GetCaster()
	if caster:GetUnitName()~="npc_dota_hero_abaddon" or not caster:HasAbility("heroTalent_npc_dota_hero_abaddon") then
		self.CoreUnlock = false
		self.unlock2 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	caster:AddNewModifier(caster,self,"modifier_Advanced_mist_coil_unlock2",{})
	return true
end
function Advanced_mist_coil:UnlockThirdCore(key)

	return true
end



function Advanced_mist_coil:GetCooldown(iLevel)
	if self:GetUnlock(3)==3 then
		return 3.5
	end


	return self.BaseClass.GetCooldown(self,iLevel)

end



function Advanced_mist_coil:CastFilterResultTarget(target)
	-- check nohammer
	if IsClient() then
		return
	end
	if target==self:GetCaster() then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end
function Advanced_mist_coil:GetBehavior()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	--LV5解锁范围施法
	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
function Advanced_mist_coil:GetAOERadius() 
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	--LV5解锁范围施法
	if advanced_level>=20 then
		return 350
	end

	 
end
function Advanced_mist_coil:GetCustomCastErrorTarget(target)
	if IsClient() then
		return
	end
	return "#Spells_CustomCastError_NOT_SELF"
end
function Advanced_mist_coil:GetCastRange(vLocation, hTarget)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	local radius =2500
	--LV10解锁灵魂追迹
	if advanced_level>=10 then
		radius = 99999
	end
	return radius
end


function Advanced_mist_coil:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local self_damage = self:GetSpecialValueFor("self_damage") * (self:GetSpecialValueFor("spell_damage") +(self:GetSpecialValueFor("str_index"))*caster:GetStrength())*0.01

	local projectile_speed = 1000
	local projectile_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"

	-- logic
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
	}
	--LV20解锁范围施法
	if self.advanced_level>=20 then
		local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,target in pairs(enemies) do
			if target~=caster then
				info.Target = target
				ProjectileManager:CreateTrackingProjectile(info)
			end

		
		end
	else
		ProjectileManager:CreateTrackingProjectile(info)
	end
	--LV15解锁两极反转
	if self.advanced_level>=15 then
		local healing = HealWithGain(self_damage*0.4,caster,caster,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)
	else
		local damageTable = {
			victim = caster,
			attacker = caster,
			damage = self_damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --不致死与不触发吸血，技能伤害
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
	end




	-- Play effects
	self:PlayEffects()
end


function Advanced_mist_coil:CastToASingleTarget(target)
	local projectile_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"

	-- logic
	local info = {
		Target = target,
		Source = self:GetCaster(),
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = 1000,
		bDodgeable = true,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
--------------------------------------------------------------------------------
-- Projectile
function Advanced_mist_coil:OnProjectileHit( target, location )
	-- check if enemy or ally
	local ally = false
	if not target then
		return
	end
	if target:GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		ally = true
	end
	local ability = self
	local caster = self:GetCaster()
	self.advanced_level = ability.advanced_level
	local damage = ability:GetSpecialValueFor("spell_damage") +(ability:GetSpecialValueFor("str_index"))*caster:GetStrength()

	if ally then
		if self.unlock3 then
			local ability = caster:FindAbilityByName("Advanced_aphotic_shield")
			if ability and not ability.unlock3 then
				ability:PlayerEffect(target)
			end
		end
		-- ally logic
		--迷雾缠身效果 对友计算正面状态增强
		local gain = caster:GetModifierDurationGainIndex(1)
		local duration = 5
		--LV5解锁迷雾缠身+
		if self.advanced_level>=5 then
			duration = duration +3
		end
		local healing = HealWithGain(damage,caster,target,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
		
		target:AddNewModifier(caster, self, "modifier_Advanced_mist_coil_active", {duration = duration*gain})




	else
		-- enemy logic
		-- cancel if linken
		if target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
			return
		end

		--迷雾缠身效果 对敌计算状态抗性与负面状态增强
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self, "modifier_Advanced_mist_coil_active", {duration = 5*StatusResistance})
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)

	end

	-- Play effects
	local sound_target = "Hero_Abaddon.DeathCoil.Target"
	EmitSoundOn( sound_target, target )
end

--------------------------------------------------------------------------------
function Advanced_mist_coil:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_abaddon/abaddon_death_coil_abaddon.vpcf"
	local sound_cast = "Hero_Abaddon.DeathCoil.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end




modifier_Advanced_mist_coil_active = advanced_modifier({})

function modifier_Advanced_mist_coil_active:IsDebuff() return self.isDebuff end
function modifier_Advanced_mist_coil_active:IsHidden() return false end
function modifier_Advanced_mist_coil_active:IsPurgable() return true end

function modifier_Advanced_mist_coil_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end



function modifier_Advanced_mist_coil_active:OnCreated(keys)
	self.isDebuff = self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
    self.ability = self:GetAbility()
	self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_regeneration_amplification = -25
	if parent:GetTeamNumber()==self.ability:GetCaster():GetTeamNumber() then
		self.bonus_regeneration_amplification = 30
	end

end



-- advanced_modifier
function modifier_Advanced_mist_coil_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_Advanced_mist_coil_active:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self.bonus_regeneration_amplification
end





modifier_Advanced_mist_coil_unlock1 = class({})

function modifier_Advanced_mist_coil_unlock1:IsDebuff()			return false end
function modifier_Advanced_mist_coil_unlock1:IsHidden() 			return true end
function modifier_Advanced_mist_coil_unlock1:IsPurgable() 		return false end
function modifier_Advanced_mist_coil_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_mist_coil_unlock1:RemoveOnDeath() return false end










modifier_Advanced_mist_coil_unlock2 = class({})

function modifier_Advanced_mist_coil_unlock2:IsDebuff()			return false end
function modifier_Advanced_mist_coil_unlock2:IsHidden() 			return true end
function modifier_Advanced_mist_coil_unlock2:IsPurgable() 		return false end
function modifier_Advanced_mist_coil_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_mist_coil_unlock2:RemoveOnDeath() return false end