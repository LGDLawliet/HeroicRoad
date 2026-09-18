--特效优化 √
LinkLuaModifier("modifier_Advanced_Heart_Stopper_Aura", "skills/Advanced_Heart_Stopper_Aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Heart_Stopper_Aura_damage", "skills/Advanced_Heart_Stopper_Aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Heart_Stopper_Aura_active", "skills/Advanced_Heart_Stopper_Aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff", "skills/Advanced_Heart_Stopper_Aura", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

Advanced_Heart_Stopper_Aura = Advanced_Heart_Stopper_Aura or class({})
function Advanced_Heart_Stopper_Aura:GetIntrinsicModifierName()return "modifier_Advanced_Heart_Stopper_Aura" end
function Advanced_Heart_Stopper_Aura:GetAbilityTextureName()return "necrolyte_heartstopper_aura" end
function Advanced_Heart_Stopper_Aura:CheckKV(key)
	local table = {

		damage_max =0.06,
		middle_poison = 0.01,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Heart_Stopper_Aura:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/heart_stopper_aura/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/heart_stopper_aura/unlock2/debuff_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/heart_stopper_aura/unlock2_death/effect/arcana/earthshaker_arcana_totem_cast_ti6_combined_v2.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf", context )
end

function Advanced_Heart_Stopper_Aura:GetCastRange(vLocation, hTarget)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local radius = self:GetSpecialValueFor("radius")
	return radius - self:GetCaster():GetCastRangeBonus()
end

function Advanced_Heart_Stopper_Aura:UnlockFirstCore(key)
	return false
end
function Advanced_Heart_Stopper_Aura:UnlockSecondCore(key)
	return true
end
function Advanced_Heart_Stopper_Aura:UnlockThirdCore(key)
	return true
end

function Advanced_Heart_Stopper_Aura:GetBehavior()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	--if coreUnlockKV then
	--	if coreUnlockKV.coreUnlock ==1 then
	--		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	--	end
	--end
	--return self.BaseClass.GetBehavior(self)
end

function Advanced_Heart_Stopper_Aura:Spawn()
	self.unlock1_bonus = 0
end

function Advanced_Heart_Stopper_Aura:SetBonusDamage(damage)
	self.unlock1_bonus = damage
end

function Advanced_Heart_Stopper_Aura:OnProjectileHit_ExtraData(target, location, keys)
	if not IsServer() then
		return
	end
	if not target or target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()
	local poison = caster:FindModifierByName("modifier_hd_poison")
	if poison then
		self.stack = math.min(poison:GetStackCount()*0.1,20000)
		target:Poison(caster,self,self.stack)
	end
	
end
------------------------------------------------------------------------
modifier_Advanced_Heart_Stopper_Aura = advanced_modifier({})


function modifier_Advanced_Heart_Stopper_Aura:GetAuraEntityReject(target)
	return false
end
function modifier_Advanced_Heart_Stopper_Aura:GetAttributes()return MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_Advanced_Heart_Stopper_Aura:IsHidden()return true end
function modifier_Advanced_Heart_Stopper_Aura:IsPurgable() 		return false end
function modifier_Advanced_Heart_Stopper_Aura:IsPurgeException() 	return false end
function modifier_Advanced_Heart_Stopper_Aura:RemoveOnDeath()  return false end
function modifier_Advanced_Heart_Stopper_Aura:GetEffectName()return "particles/auras/aura_heartstopper.vpcf" end
function modifier_Advanced_Heart_Stopper_Aura:GetEffectAttachType()return PATTACH_POINT_FOLLOW end

function modifier_Advanced_Heart_Stopper_Aura:GetAuraRadius()return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_Advanced_Heart_Stopper_Aura:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Heart_Stopper_Aura:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Heart_Stopper_Aura:GetAuraSearchType()return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Heart_Stopper_Aura:GetModifierAura()return "modifier_Advanced_Heart_Stopper_Aura_damage" end

function modifier_Advanced_Heart_Stopper_Aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end
function modifier_Advanced_Heart_Stopper_Aura:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Heart_Stopper_Aura:OnIntervalThink()
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(1)
		self.damage_max = self:GetAbility():GetSpecialValueFor("damage_max")*self:GetCaster():HDGetPrimaryStatValue()
		self.middle_poison = self:GetAbility():GetSpecialValueFor("middle_poison")*self:GetCaster():HDGetPrimaryStatValue()
			self.auto_self_index = self:GetAbility():GetSpecialValueFor("auto_self_index")*0.01
			--新LV5郁毒灵气+
			if self:GetAbility().advanced_level >= 5 then
				self.middle_poison = self.middle_poison * 1.2
			end
		self:GetCaster():Poison(self:GetCaster(),self:GetAbility(),self.auto_self_index*self.middle_poison)
	else
		self:SetStackCount(0)
	end
	--新LV20瘟疫扩散
	if self:GetAbility().advanced_level >= 20 then
		self:LV20project()
	end
end

function modifier_Advanced_Heart_Stopper_Aura:LV20project(keys)
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),
		nil,	
		self:GetAbility():GetSpecialValueFor("radius"),	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,	
		FIND_CLOSEST,	
		false	
	)
	local target = nil
	for _,enemy in pairs(enemies) do
		target = enemy
		break
	end
	if not target then return end

	local info = 
	{
		Target = target,
		-- Source = self:GetParent(),
		-- SourceAttachment = nil,
		Ability = self:GetAbility(),	
		EffectName = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
		iMoveSpeed = 1800,
		vSourceLoc= self:GetParent():GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function modifier_Advanced_Heart_Stopper_Aura:ADDeclareFunctions()
	local funcs = {
	advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
	advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end
--新LV10暂缓
function modifier_Advanced_Heart_Stopper_Aura:Advanced_GetModifierIncomingPoisonDamagePercentage()
	if self:GetAbility().advanced_level < 10 then
		return 0
	end
	return -20*self:GetStackCount()
end
function modifier_Advanced_Heart_Stopper_Aura:AdvancedGetModifierConstantHealthRegenPercentage()
	if self:GetAbility().advanced_level < 10 then
		return 0
	end
	return 1*(1-self:GetStackCount())
end

--原奥义1，禁用
--function modifier_Advanced_Heart_Stopper_Aura:OnIntervalThink()
--	if IsServer() then
--		local ability = self:GetAbility()
--		local advanced_level = ability.advanced_level
--		self.radius = ability:GetSpecialValueFor("radius")
--		--LV20解锁领域扩展
--		if advanced_level >=20 then
--			self.radius = self.radius + self:GetCaster():GetIntellect(false)*1.5
--		end
--		local caster = self:GetCaster()
--		if not caster:IsAlive() then
--			return
--		end
--		local modifier = caster:FindModifierByName("modifier_Advanced_Heart_Stopper_Aura_active")
--		local mana_reduce_index = 2
--		if advanced_level>=10 then
--			mana_reduce_index = 3
--		end
--		if modifier then
--			if caster:GetManaPercent()<=10 then
--				modifier:SafeDestroy()
--				return
--			end
--			self.radius = self.radius *2
--
---			caster:SpendMana(caster:GetIntellect(false)*mana_reduce_index,ability)
--
--		end
--		if ability:GetAutoCastState() then
--			local health = caster:GetHealth()
--			local mana = caster:GetMana() *0.08
--			caster:SpendMana( mana, ability )
--			caster:ModifyHealth(health*0.9,nil,false,0)
--			ability:SetBonusDamage((health*0.1+mana)*3)
--			local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/heart_stopper_aura/unlock1/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
--			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
--			ParticleManager:SetParticleControl( nFXIndex, 2, Vector(500,1,1) )
--
--			self:AddParticle( nFXIndex, false, false, -1, true, false )
--			Timers:CreateTimer(0.7, function()
--				ParticleManager:DestroyParticle(nFXIndex,false)
--				ParticleManager:ReleaseParticleIndex(nFXIndex)
--			end)
--		else
--			ability:SetBonusDamage(0)
--		end
---	end
--end
----------------------------------------------------------------------------------------------------
modifier_Advanced_Heart_Stopper_Aura_damage = advanced_modifier({})


function modifier_Advanced_Heart_Stopper_Aura_damage:IsHidden() return false end
function modifier_Advanced_Heart_Stopper_Aura_damage:IsDebuff()return true end
function modifier_Advanced_Heart_Stopper_Aura_damage:IsPurgable()return false end
function modifier_Advanced_Heart_Stopper_Aura_damage:GetAttributes()return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Heart_Stopper_Aura_damage:OnCreated()
	if IsServer() then
		self.level = self:GetAbility().advanced_level
		self.parent	= self:GetParent()
		self.tick_rate	= self:GetAbility():GetSpecialValueFor("tick_rate")
		self.damage_max = self:GetAbility():GetSpecialValueFor("damage_max")*self:GetCaster():HDGetPrimaryStatValue()
		if not self.timer then
			self:StartIntervalThink(self.tick_rate)
			self.timer = true
		end
		if self:GetAbility().unlock2 then
			local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/heart_stopper_aura/unlock2/debuff_effect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			-- ParticleManager:SetParticleControl( nFXIndex, 2, Vector(500,1,1) )

			self:AddParticle( nFXIndex, false, false, -1, true, false )
		end
	end
end

function modifier_Advanced_Heart_Stopper_Aura_damage:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		if not caster:PassivesDisabled() then
			local ability = self:GetAbility()
			if not ability then
				return
			end
			self.damage_max = self:GetAbility():GetSpecialValueFor("damage_max")*self:GetCaster():HDGetPrimaryStatValue()
			local damage_table = {
				victim = self.parent,
				attacker = caster,
				ability = self:GetAbility(),
				--damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				hd_flags = HD_DAMAGE_FLAG_DOT + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
			}
			damage_table.damage = math.max(math.min(self:GetAbility():GetSpecialValueFor("damage")*self.parent:GetMaxHealth()*0.01 ,self.damage_max),20)

			--if ability:GetAutoCastState() then
			--	damage_table.damage = damage_table.damage + ability.unlock1_bonus
			--end
			ApplyDamage(damage_table)

			self.middle_poison = self:GetAbility():GetSpecialValueFor("middle_poison")*self:GetCaster():HDGetPrimaryStatValue()
			self.auto_enemy_index = self:GetAbility():GetSpecialValueFor("auto_enemy_index")*0.01 + 1
			--新LV5郁毒灵气+
			if self.level >= 5 then
				self.middle_poison = self.middle_poison * 1.2
			end
			--新LV15稠化剧毒+
			if self.level >= 15 then
				self.auto_enemy_index = 2
			end
			if ability:GetAutoCastState() then
				self.parent:Poison(caster,self:GetAbility(),self.auto_enemy_index*self.middle_poison)
			else
				self.parent:Poison(caster,self:GetAbility(),self.middle_poison)
			end
			

			if self.parent:IsAlive() and ability.unlock3 then
				if caster:GetRandomEffect(2,INT_TYPE,1)  > RandomInt(1, 100) then
					local ability = caster:FindAbilityByName("Advanced_Reapers_Scythe")
					if ability then
						caster:SetCursorCastTarget(self.parent)
						ability:OnSpellStart()						
					end
				end
			end
		end
	end
end



function modifier_Advanced_Heart_Stopper_Aura_damage:DeclareFunctions() 
	local funcs = {}
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_EVENT_ON_DEATH)
		table.insert(funcs,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE)
	end
	return funcs
end

function modifier_Advanced_Heart_Stopper_Aura_damage:GetModifierMoveSpeedBonus_Percentage()
	return -50
end
function modifier_Advanced_Heart_Stopper_Aura_damage:OnDeath(keys)
    if not IsServer() then
        return
    end
	
    if keys.unit == self:GetParent() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor("radius")+ caster:GetIntellect(false)*1.5
		if not caster:IsAlive() then
			return
		end
		caster:EmitSound("Hero_Lich.IceAge")
		local modifier = caster:FindModifierByName("modifier_Advanced_Heart_Stopper_Aura_active")
		if modifier then
			radius = radius * 2
		end
		local name = "particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf"
		local pfx = ParticleManager:CreateParticle(name, PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		local name = "particles/rebuild/spell/heart_stopper_aura/unlock2_death/effect/arcana/earthshaker_arcana_totem_cast_ti6_combined_v2.vpcf"

		local pfx = ParticleManager:CreateParticle(name, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for i, enemy in pairs(enemies) do
			
			enemy:AddNewModifier(caster, ability, "modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff", {})
			if i>=10 then
				break
			end
		end
	end


end
----------------------------------
modifier_Advanced_Heart_Stopper_Aura_active = modifier_Advanced_Heart_Stopper_Aura_active or advanced_modifier({})


function modifier_Advanced_Heart_Stopper_Aura_active:IsHidden() return false end
-- function modifier_Advanced_Heart_Stopper_Aura_damage:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_Advanced_Heart_Stopper_Aura_active:IsDebuff()return false end
function modifier_Advanced_Heart_Stopper_Aura_active:IsPurgable()return false end

function modifier_Advanced_Heart_Stopper_Aura_active:OnWaveEnd()
    self:SafeDestroy()
    return 1
end
function modifier_Advanced_Heart_Stopper_Aura_active:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end


modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff = modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff or advanced_modifier({})


function modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff:IsHidden() return false end
function modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff:IsDebuff()return true end
function modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff:IsPurgable()return false end
function modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff:OnCreated()
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff:OnRefresh()
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1,60))
	end
end

function modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff:Advanced_GetModifierIncomingDamage_Percentage()
	return self:GetStackCount()*5
end

function modifier_Advanced_Heart_Stopper_Aura_unlock2_debuff:ADDeclareFunctions()

	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


