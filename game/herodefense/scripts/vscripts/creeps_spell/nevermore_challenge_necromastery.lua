nevermore_challenge_necromastery = class({})

LinkLuaModifier("modifier_nevermore_challenge_necromastery", "creeps_spell/nevermore_challenge_necromastery", LUA_MODIFIER_MOTION_NONE)

function nevermore_challenge_necromastery:IsHiddenWhenStolen() 		return false end
function nevermore_challenge_necromastery:IsRefreshable() 			return true end
function nevermore_challenge_necromastery:IsStealable() 				return true end
function nevermore_challenge_necromastery:IsNetherWardStealable()		return true end
function nevermore_challenge_necromastery:GetIntrinsicModifierName() return "modifier_nevermore_challenge_necromastery" end

-- require('internal/timers')

modifier_nevermore_challenge_necromastery = advanced_modifier({})

function modifier_nevermore_challenge_necromastery:IsDebuff()			 return false end
function modifier_nevermore_challenge_necromastery:IsHidden() 		     return false end
function modifier_nevermore_challenge_necromastery:IsPurgable() 		 return false end
function modifier_nevermore_challenge_necromastery:IsPurgeException() 	 return false end
function modifier_nevermore_challenge_necromastery:RemoveOnDeath()       return false end 
function modifier_nevermore_challenge_necromastery:OnCreated(table)
	self.kill_attack = self:GetAbility():GetSpecialValueFor("kill_attack")
	self.kill_model = self:GetAbility():GetSpecialValueFor("kill_model")
	self.kill_range = self:GetAbility():GetSpecialValueFor("kill_range")

	self.kill_hero = self:GetAbility():GetSpecialValueFor("kill_hero")
	self.kill_basic = self:GetAbility():GetSpecialValueFor("kill_basic")
end

function modifier_nevermore_challenge_necromastery:ADDeclareFunctions()	
	local decFuncs = {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,	
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE,
	}
	return decFuncs	
end

function modifier_nevermore_challenge_necromastery:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return decFuncs	
end


function modifier_nevermore_challenge_necromastery:OnDeath(keys)
	if IsServer() then
		if keys.attacker==self:GetParent() then
			if keys.unit:IsRealHero() then
				if keys.attacker:PassivesDisabled() then
					self:SetStackCount(self:GetStackCount()+self.kill_hero*0.2)
				else
					self:SetStackCount(self:GetStackCount()+self.kill_hero)
				end
			else
				if keys.attacker:PassivesDisabled() then
					self:SetStackCount(self:GetStackCount())
				else
					self:SetStackCount(self:GetStackCount()+self.kill_basic)
				end
			end
		end
	end
end
function modifier_nevermore_challenge_necromastery:Advanced_GetModifierBaseDamageOutgoing_Percentage() return self.kill_attack*self:GetStackCount() end
function modifier_nevermore_challenge_necromastery:Advanced_GetModifierAttackRangeBonusPercentage() return self.kill_range*self:GetStackCount() end
function modifier_nevermore_challenge_necromastery:GetModifierModelScale() return math.min(self.kill_model*self:GetStackCount(),100) end
