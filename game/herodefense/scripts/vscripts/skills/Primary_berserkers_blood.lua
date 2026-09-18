LinkLuaModifier("modifier_Primary_berserkers_blood", "skills/Primary_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_berserkers_blood_start", "skills/Primary_berserkers_blood", LUA_MODIFIER_MOTION_NONE)

Primary_berserkers_blood = class({})

function Primary_berserkers_blood:GetIntrinsicModifierName()
	return "modifier_Primary_berserkers_blood"
end

---------------

modifier_Primary_berserkers_blood = advanced_modifier({})

function modifier_Primary_berserkers_blood:IsHidden()	return true end
function modifier_Primary_berserkers_blood:IsPurgable() 		return false end
function modifier_Primary_berserkers_blood:IsPurgeException() 	return false end
function modifier_Primary_berserkers_blood:RemoveOnDeath()  return false end
function modifier_Primary_berserkers_blood:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()

	self.attack	= self.ability:GetSpecialValueFor("attack")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
	if not IsServer() then return end
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
end

function modifier_Primary_berserkers_blood:OnRefresh()
	self.attack	= self.ability:GetSpecialValueFor("attack")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_Primary_berserkers_blood:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_Primary_berserkers_blood:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,-- 攻速
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, -- 变红
	}
	return funcs
end

function modifier_Primary_berserkers_blood:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,-- 基础攻
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end

function modifier_Primary_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
	local lost = 100 - self:GetParent():GetHealthPercent()
	if self:GetCaster():PassivesDisabled() then
		lost = lost*0.5
	end
	if self:GetCaster():IsRangedAttacker() then
		lost = lost*0.5
	end
	return lost*self.attack_speed
end

function modifier_Primary_berserkers_blood:Advanced_GetModifierBaseAttack_BonusDamage()
	local lost = 100 - self:GetParent():GetHealthPercent()
	if self:GetCaster():PassivesDisabled() then
		lost = lost*0.5
	end
	if self:GetCaster():IsRangedAttacker() then
		lost = lost*0.5
	end
	return lost*self.attack
end

function modifier_Primary_berserkers_blood:GetActivityTranslationModifiers()
	return "berserkers_blood"
end

function modifier_Primary_berserkers_blood:OnWaveStart()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Primary_berserkers_blood_start", {duration = self.duration})
end

-- 启动
modifier_Primary_berserkers_blood_start = advanced_modifier({})

function modifier_Primary_berserkers_blood_start:IsHidden()	return false end
function modifier_Primary_berserkers_blood_start:IsPurgable() 		return false end
function modifier_Primary_berserkers_blood_start:IsPurgeException() 	return false end
function modifier_Primary_berserkers_blood_start:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
end
function modifier_Primary_berserkers_blood_start:Advanced_GetModifier_StatusResistance()
	return self:GetAbility():GetSpecialValueFor("status")
end

