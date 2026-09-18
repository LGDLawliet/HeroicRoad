LinkLuaModifier("modifier_Middle_berserkers_blood", "skills/Middle_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_berserkers_blood_start", "skills/Middle_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_berserkers_blood_active", "skills/Middle_berserkers_blood", LUA_MODIFIER_MOTION_NONE)

Middle_berserkers_blood = class({})

function Middle_berserkers_blood:GetIntrinsicModifierName()
	return "modifier_Middle_berserkers_blood"
end
function Middle_berserkers_blood:OnSpellStart()
	local modifier = self:GetCaster():FindModifierByName("modifier_Middle_berserkers_blood")
	modifier:OnWaveStart()
	
	self:GetCaster():Purge(false, true, false, true, true)  --强驱散
	local hp_lock = self:GetSpecialValueFor("hp_lock")
	local active_duration = self:GetSpecialValueFor("active_duration")

	if self:GetCaster():GetHealthPercent() < hp_lock then
		self:GetCaster():SetHealth(self:GetCaster():GetMaxHealth() * hp_lock*0.01)
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Middle_berserkers_blood_active", {duration = active_duration, hp_lock = hp_lock})
end
---------------

modifier_Middle_berserkers_blood = advanced_modifier({})

function modifier_Middle_berserkers_blood:IsHidden()	return true end
function modifier_Middle_berserkers_blood:IsPurgable() 		return false end
function modifier_Middle_berserkers_blood:IsPurgeException() 	return false end
function modifier_Middle_berserkers_blood:RemoveOnDeath()  return false end
function modifier_Middle_berserkers_blood:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()

	self.attack	= self.ability:GetSpecialValueFor("attack")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
	if not IsServer() then return end
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
end

function modifier_Middle_berserkers_blood:OnRefresh()
	self.attack	= self.ability:GetSpecialValueFor("attack")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_Middle_berserkers_blood:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_Middle_berserkers_blood:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,-- 攻速
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, -- 变红
	}
	return funcs
end

function modifier_Middle_berserkers_blood:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,-- 基础攻
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end

function modifier_Middle_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
	local lost = 100 - self:GetParent():GetHealthPercent()
	if self:GetCaster():PassivesDisabled() then
		lost = lost*0.5
	end
	if self:GetCaster():IsRangedAttacker() then
		lost = lost*0.5
	end
	return lost*self.attack_speed
end

function modifier_Middle_berserkers_blood:Advanced_GetModifierBaseAttack_BonusDamage()
	local lost = 100 - self:GetParent():GetHealthPercent()
	if self:GetCaster():PassivesDisabled() then
		lost = lost*0.5
	end
	if self:GetCaster():IsRangedAttacker() then
		lost = lost*0.5
	end
	return lost*self.attack
end

function modifier_Middle_berserkers_blood:GetActivityTranslationModifiers()
	return "berserkers_blood"
end

function modifier_Middle_berserkers_blood:OnWaveStart()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_berserkers_blood_start", {duration = self.duration})
end

-- 启动
modifier_Middle_berserkers_blood_start = advanced_modifier({})

function modifier_Middle_berserkers_blood_start:IsHidden()	return false end
function modifier_Middle_berserkers_blood_start:IsPurgable() 		return false end
function modifier_Middle_berserkers_blood_start:IsPurgeException() 	return false end
function modifier_Middle_berserkers_blood_start:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
end
function modifier_Middle_berserkers_blood_start:Advanced_GetModifier_StatusResistance()
	return self:GetAbility():GetSpecialValueFor("status")
end

-- 锁血
modifier_Middle_berserkers_blood_active = advanced_modifier({})

function modifier_Middle_berserkers_blood_active:IsHidden()	return false end
function modifier_Middle_berserkers_blood_active:IsPurgable() 		return false end
function modifier_Middle_berserkers_blood_active:IsPurgeException() 	return false end
function modifier_Middle_berserkers_blood_active:OnCreated(kv)
	if not IsServer() then return end
	self.hp_lock = kv.hp_lock or self:GetAbility():GetSpecialValueFor("hp_lock")
	self.min = self:GetCaster():GetMaxHealth() * self.hp_lock*0.01

	if self:GetCaster():GetHealthPercent() < self.hp_lock then
		self:GetCaster():SetHealth(self.min)
	end
end
function modifier_Middle_berserkers_blood_active:OnRefresh(kv)
	if not IsServer() then return end
	self.hp_lock = kv.hp_lock or self:GetAbility():GetSpecialValueFor("hp_lock")
	self.min = self:GetCaster():GetMaxHealth() * self.hp_lock*0.01

	if self:GetCaster():GetHealthPercent() < self.hp_lock then
		self:GetCaster():SetHealth(self.min)
	end
end
function modifier_Middle_berserkers_blood_active:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_Middle_berserkers_blood_active:GetMinHealth()
    return self.min
end