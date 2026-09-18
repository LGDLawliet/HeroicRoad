Primary_reincarnation = class({})
LinkLuaModifier("modifier_Primary_reincarnation", "skills/Primary_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_reincarnation_debuff", "skills/Primary_reincarnation", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function Primary_reincarnation:GetIntrinsicModifierName()
	return "modifier_Primary_reincarnation"
end
----------------------------------------------
modifier_Primary_reincarnation = modifier_Primary_reincarnation or advanced_modifier({})

function modifier_Primary_reincarnation:OnCreated()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()    
	self.caster.now_reincarnation = "modifier_Primary_reincarnation"  --设置当前的重生名
	self.particle_death = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	self.reincarnate_delay = self.ability:GetSpecialValueFor("reincarnate_delay")
	if IsServer() then

	end
end

function modifier_Primary_reincarnation:OnRefresh()
	self:OnCreated()
end

function modifier_Primary_reincarnation:IsHidden() return true end
function modifier_Primary_reincarnation:IsPurgable() 		return false end
function modifier_Primary_reincarnation:IsPurgeException() 	return false end
function modifier_Primary_reincarnation:RemoveOnDeath()  return false end
function modifier_Primary_reincarnation:IsDebuff() return false end

function modifier_Primary_reincarnation:ADDeclareFunctions()
    return 
    {
		MODIFIER_SPECIAL_Reincarnate = {nil,self:GetParent()},
		MODIFIER_EVENT_ON_Wave_End = {}
    }
end
function modifier_Primary_reincarnation:OnWaveEnd()
	if not IsServer() then
		return
	end
	if not self:GetAbility():IsCooldownReady() then
		self:GetAbility():EndCooldown()	
	end
end

function modifier_Primary_reincarnation:AdvancedGetModifierReincarnate(keys)
	if self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() then
		self.reincarnation_weak = false
		local data = {
			modifier = self,
			time = self.reincarnate_delay,
			priority = 10,
			invulnerable_time = 2,
		}
		return data
	end
	return nil
end

function modifier_Primary_reincarnation:OnReincarnateTrigger(keys)
	local unit = keys.unit
	self.ability:UseResources(false, false, true,true)
	local particle_death_fx = ParticleManager:CreateParticle(self.particle_death, PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleAlwaysSimulate(particle_death_fx)
	ParticleManager:SetParticleControl(particle_death_fx, 0, unit:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_death_fx, 1, Vector(self.reincarnate_delay, 0, 0))
	ParticleManager:SetParticleControl(particle_death_fx, 11, Vector(200, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_death_fx)
	-- unit:AddNewModifier(unit, self.ability, "modifier_Primary_reincarnation_debuff", {duration = self.ability:GetSpecialValueFor("duration")})
	self.reincarnation_weak = true


	local table = {
		mulEffect = true,
		multiTrigger = true,
		unit = self:GetParent(),
		modifier = self,
		ability = self:GetAbility()
	}
	FireDeathAgainEvent(table)

end

------------------------------------------------------------------------

modifier_Primary_reincarnation_debuff = class({})

function modifier_Primary_reincarnation_debuff:IsDebuff() return true end
function modifier_Primary_reincarnation_debuff:IsHidden() return false end
function modifier_Primary_reincarnation_debuff:IsPurgable() return false end
function modifier_Primary_reincarnation_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_str = -self.ability:GetSpecialValueFor("bonus_str") * parent:GetStrength()*0.01
	self.bonus_agi = -self.ability:GetSpecialValueFor("bonus_str") *parent:GetAgility()*0.01
	self.bonus_int = -self.ability:GetSpecialValueFor("bonus_str")*parent:GetIntellect(false)*0.01
end

function modifier_Primary_reincarnation_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end

function modifier_Primary_reincarnation_debuff:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Primary_reincarnation_debuff:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Primary_reincarnation_debuff:GetModifierBonusStats_Agility()	return self.bonus_agi end