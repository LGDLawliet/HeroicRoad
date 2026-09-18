--特效优化 √
LinkLuaModifier("modifier_Advanced_berserkers_blood", "skills/Advanced_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_berserkers_blood_start", "skills/Advanced_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_berserkers_blood_active", "skills/Advanced_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_berserkers_blood_auto", "skills/Advanced_berserkers_blood", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_berserkers_blood_debuff", "skills/Advanced_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_berserkers_blood_unlock1", "skills/Advanced_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_berserkers_blood_unlock3", "skills/Advanced_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
-----------------------------
Advanced_berserkers_blood = class({})

function Advanced_berserkers_blood:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", context )
end

function Advanced_berserkers_blood:GetIntrinsicModifierName()
	return "modifier_Advanced_berserkers_blood"
end

function Advanced_berserkers_blood:CheckKV(key)
	local table = {
		attack = 0.05,
	}
	local value = table[key] or -1
	return value
end

function Advanced_berserkers_blood:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_berserkers_blood_unlock1",{})
	return true
end
function Advanced_berserkers_blood:UnlockSecondCore(key)
	return false
end
function Advanced_berserkers_blood:UnlockThirdCore(key)
	return true
end
function Advanced_berserkers_blood:OnAdvancedUpgrade()
	self:SetLevel(0)
	self:SetLevel(1)
end
function Advanced_berserkers_blood:OnSpellStart()
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_berserkers_blood")
	modifier:OnWaveStart()
	
	self:GetCaster():Purge(false, true, false, true, true)  --强驱散
	local hp_lock = self:GetSpecialValueFor("hp_lock")
	--lv20
	if self:GetSpecialValueFor("advanced_level") >= 20 then
		hp_lock = 1
	end
	local active_duration = self:GetSpecialValueFor("active_duration")
	--lv15
	if self:GetSpecialValueFor("advanced_level") >= 15 then
		active_duration = 10
	end
	if self:GetCaster():GetHealthPercent() < hp_lock then
		self:GetCaster():SetHealth(self:GetCaster():GetMaxHealth() * hp_lock*0.01)
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_berserkers_blood_active", {duration = active_duration, hp_lock = hp_lock})
end
-----------------
modifier_Advanced_berserkers_blood = advanced_modifier({})

function modifier_Advanced_berserkers_blood:IsHidden()	return self:GetStackCount()==0 end
function modifier_Advanced_berserkers_blood:IsPurgable() 		return false end
function modifier_Advanced_berserkers_blood:IsPurgeException() 	return false end
function modifier_Advanced_berserkers_blood:RemoveOnDeath()  return false end
function modifier_Advanced_berserkers_blood:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()

	self.attack	= self.ability:GetSpecialValueFor("attack")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.advanced_level = self.ability:GetSpecialValueFor("advanced_level")

	self.unlock3_timer = 0
	if not IsServer() then return end
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	-- 奥义3
	if self.ability.unlock3 then
		self:StartIntervalThink(0.3)
	end
end


function modifier_Advanced_berserkers_blood:OnRefresh()
	self.attack	= self.ability:GetSpecialValueFor("attack")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.advanced_level = self.ability:GetSpecialValueFor("advanced_level")
end

function modifier_Advanced_berserkers_blood:OnIntervalThink()
	self:OnRefresh()
	local ability = self:GetAbility()
	if not IsServer() then return end
	
	if ability.unlock3 then
		if self.parent:GetHealthPercent()<=50 then
			self.unlock3_timer = self.unlock3_timer + 0.3
			if self.unlock3_timer>=10 and self:GetStackCount()<10 then
				local caster = self:GetCaster()
				self.unlock3_timer = self.unlock3_timer - 10
				self:SetStackCount(math.min(self:GetStackCount()+1,10))
				local pfx_name = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf"
				local sound_name = "Hero_Sven.GodsStrength"
				caster:EmitSound(sound_name)
				local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, caster)

				ParticleManager:SetParticleControl( pfx, 0, caster:GetOrigin() )
				ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)
			end
		else
			self.unlock3_timer = 0
			self:SetStackCount(0)
		end
	end
end


function modifier_Advanced_berserkers_blood:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_Advanced_berserkers_blood:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,-- 攻速
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, -- 变红
	}
	return funcs
end

function modifier_Advanced_berserkers_blood:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,-- 基础攻
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end

function modifier_Advanced_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
	local lost = 100 - self:GetParent():GetHealthPercent()
	--lv10
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 and not self:GetCaster():IsRangedAttacker() then
		lost = lost*1.1
	end
	if self:GetCaster():PassivesDisabled() then
		lost = lost*0.5
	end
	if self:GetCaster():IsRangedAttacker() then
		lost = lost*0.5
	end
	return lost*self.attack_speed
end

function modifier_Advanced_berserkers_blood:Advanced_GetModifierBaseAttack_BonusDamage()
	local lost = 100 - self:GetParent():GetHealthPercent()
	--lv10
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 and not self:GetCaster():IsRangedAttacker() then
		lost = lost*1.1
	end
	if self:GetCaster():PassivesDisabled() then
		lost = lost*0.5
	end
	if self:GetCaster():IsRangedAttacker() then
		lost = lost*0.5
	end
	return lost*self.attack
end

function modifier_Advanced_berserkers_blood:AdvancedGetModifierExtraHealthPercentage() 
	return self:GetStackCount()*10 

end

function modifier_Advanced_berserkers_blood:GetActivityTranslationModifiers()
	return "berserkers_blood"
end

function modifier_Advanced_berserkers_blood:OnWaveStart()
	if not IsServer() then return end
	if self:GetAbility():GetAutoCastState() then
		self.auto = true
	else	
		self.auto = false
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_berserkers_blood_start", {duration = self.duration, auto = self.auto})
	print(self.auto)
end

-- 启动
modifier_Advanced_berserkers_blood_start = advanced_modifier({})

function modifier_Advanced_berserkers_blood_start:IsHidden()	return false end
function modifier_Advanced_berserkers_blood_start:IsPurgable() 		return false end
function modifier_Advanced_berserkers_blood_start:IsPurgeException() 	return false end
function modifier_Advanced_berserkers_blood_start:OnCreated(kv)
	if not IsServer() then return end
	self.auto = kv.auto
	--print("实际是"..self.auto)
	if self.auto == 1 then
		--print("正常触发了")
		local hp_up = self:GetAbility():GetSpecialValueFor("hp_up")
		local max = self:GetCaster():GetMaxHealth() * hp_up*0.01
		if self:GetCaster():GetHealthPercent() > hp_up then
			self:GetCaster():SetHealth(max)
		end
		self:StartIntervalThink(0.1)

		if not self:GetCaster():IsRangedAttacker() then
			local auto_duration = self:GetAbility():GetSpecialValueFor("auto_duration")
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Advanced_berserkers_blood_auto",{duration = auto_duration})
		end
	end
end

function modifier_Advanced_berserkers_blood_start:OnRefresh(kv)
	if not IsServer() then return end
	self.auto = kv.auto
	--print("实际是"..self.auto)
	if self.auto == 1 then
		--print("正常触发了")
		local hp_up = self:GetAbility():GetSpecialValueFor("hp_up")
		local max = self:GetCaster():GetMaxHealth() * hp_up*0.01
		if self:GetCaster():GetHealthPercent() > hp_up then
			self:GetCaster():SetHealth(max)
		end
		self:StartIntervalThink(0.1)

		if not self:GetCaster():IsRangedAttacker() then
			local auto_duration = self:GetAbility():GetSpecialValueFor("auto_duration")
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Advanced_berserkers_blood_auto",{duration = auto_duration})
		end
	end
end


function modifier_Advanced_berserkers_blood_start:OnIntervalThink()
	local hp_up = self:GetAbility():GetSpecialValueFor("hp_up")
	local max = self:GetCaster():GetMaxHealth() * hp_up*0.01
	if self:GetCaster():GetHealthPercent() > hp_up then
		self:GetCaster():SetHealth(max)
	end
end

function modifier_Advanced_berserkers_blood_start:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
end

function modifier_Advanced_berserkers_blood_start:Advanced_GetModifier_StatusResistance()
	return self:GetAbility():GetSpecialValueFor("status")
end

-- 高阶近战减伤
modifier_Advanced_berserkers_blood_auto = advanced_modifier({})

function modifier_Advanced_berserkers_blood_auto:IsHidden()	return false end
function modifier_Advanced_berserkers_blood_auto:IsPurgable() 		return false end
function modifier_Advanced_berserkers_blood_auto:IsPurgeException() 	return false end
function modifier_Advanced_berserkers_blood_auto:OnCreated(kv)
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	--lv10
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 then
		self.incoming = 60
	end
end
function modifier_Advanced_berserkers_blood_auto:OnRefresh(kv)
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	--lv10
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 then
		self.incoming = 60
	end
end
function modifier_Advanced_berserkers_blood_auto:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_Advanced_berserkers_blood_auto:Advanced_GetModifierIncomingDamage_Percentage()
	return -self.incoming
end

-- 锁血
modifier_Advanced_berserkers_blood_active = advanced_modifier({})

function modifier_Advanced_berserkers_blood_active:IsHidden()	return false end
function modifier_Advanced_berserkers_blood_active:IsPurgable() 		return false end
function modifier_Advanced_berserkers_blood_active:IsPurgeException() 	return false end
function modifier_Advanced_berserkers_blood_active:OnCreated(kv)
	if not IsServer() then return end
	self.hp_lock = kv.hp_lock or self:GetAbility():GetSpecialValueFor("hp_lock")
	--lv20
	if self:GetAbility().advanced_level >= 20 then
		self.hp_lock = 1
	end
	self.min = self:GetCaster():GetMaxHealth() * self.hp_lock*0.01

	if self:GetCaster():GetHealthPercent() < self.hp_lock then
		self:GetCaster():SetHealth(self.min)
	end
end
function modifier_Advanced_berserkers_blood_active:OnRefresh(kv)
	if not IsServer() then return end
	self.hp_lock = kv.hp_lock or self:GetAbility():GetSpecialValueFor("hp_lock")
	--lv20
	if self:GetAbility().advanced_level >= 20 then
		self.hp_lock = 1
	end
	self.min = self:GetCaster():GetMaxHealth() * self.hp_lock*0.01

	if self:GetCaster():GetHealthPercent() < self.hp_lock then
		self:GetCaster():SetHealth(self.min)
	end
end
function modifier_Advanced_berserkers_blood_active:OnDestroy(kv)
	if not IsServer() then return end
	--lv5
	if self:GetAbility().advanced_level >= 5 then
		self:GetCaster():Purge(false, true, false, true, true)  --强驱散
	end
end
function modifier_Advanced_berserkers_blood_active:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_Advanced_berserkers_blood_active:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
end
function modifier_Advanced_berserkers_blood_active:Advanced_GetModifier_StatusResistance()
	return 300
end
function modifier_Advanced_berserkers_blood_active:GetMinHealth()
    return self.min
end



-- 
modifier_Advanced_berserkers_blood_debuff = advanced_modifier({})
function modifier_Advanced_berserkers_blood_debuff:IsDebuff() return false end
function modifier_Advanced_berserkers_blood_debuff:IsHidden() return true end
function modifier_Advanced_berserkers_blood_debuff:IsPurgable() return false end
function modifier_Advanced_berserkers_blood_debuff:IsPurgeException() 	return false end
function modifier_Advanced_berserkers_blood_debuff:RemoveOnDeath() return false end

function modifier_Advanced_berserkers_blood_debuff:OnCreated( kv )
	if not IsServer() then return end
	self.pfx = ParticleManager:CreateParticle("particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:StartIntervalThink(0.1)
end
function modifier_Advanced_berserkers_blood_debuff:OnIntervalThink()
	if not IsServer() then return end
	--设置携带buff单位自动攻击任意附近单位
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 10000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST , false)
	if self:GetParent():GetHealthPercent()>20 then
		self:SafeDestroy()
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		return
	end
	if not self:GetParent():IsAttacking() then
		--print("units num:",#units,"hero not attacking")
		if #units>0 then
			--self:GetParent():SetForceAttackTarget(units[1])
			self:GetParent():MoveToTargetToAttack(units[1])
		end
	end

	
end

function modifier_Advanced_berserkers_blood_debuff:OnRemoved()
	if not IsServer() then return end
	--无论在干嘛都停下
	self:GetParent():Stop()
end


function modifier_Advanced_berserkers_blood_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
end	
function modifier_Advanced_berserkers_blood_debuff:GetModifierBaseAttackTimeConstant()
	return 0.7
end

function modifier_Advanced_berserkers_blood_debuff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Advanced_berserkers_blood_debuff:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	local parent = self:GetParent()
	local health = parent:GetMaxHealth()*0.03 --伤害大于3%最大生命值则格挡多余的伤害
	if keys.damage>=health then
		--print("incoming damage:",keys.damage,"5% of health:",health)
		
		return keys.damage - health
	end
	return 0 
end








modifier_Advanced_berserkers_blood_unlock1 = class({})

function modifier_Advanced_berserkers_blood_unlock1:IsHidden()	return false end
function modifier_Advanced_berserkers_blood_unlock1:IsDebuff()	return false end
function modifier_Advanced_berserkers_blood_unlock1:IsPurgable() 		    return false end
function modifier_Advanced_berserkers_blood_unlock1:IsPurgeException() return false end
function modifier_Advanced_berserkers_blood_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_berserkers_blood_unlock1:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		
    }

    return funcs
    
end



function modifier_Advanced_berserkers_blood_unlock1:Advanced_GetModifierBonusStats_Strength()	return 2*self:GetStackCount() end
function modifier_Advanced_berserkers_blood_unlock1:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():IsIllusion()  then
			return
		end

		if keys.target~=self:GetParent() or keys.attacker:GetTeamNumber()==keys.target:GetTeamNumber() then
			return
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
	
		local duration = 25 - self:GetStackCount()/10
		if duration>0 then
			local dieTime = GameRules:GetGameTime() +duration
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end

	end
end

function modifier_Advanced_berserkers_blood_unlock1:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		-- table.insert(self.tData, { dieTime = self:GetDieTime() })
		-- self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_berserkers_blood_unlock1:OnIntervalThink()
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






