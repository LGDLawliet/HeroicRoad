heroTalent_npc_dota_hero_bloodseeker = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_bloodseeker", "heroTalent/heroTalent_npc_dota_hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_bloodseeker_buff", "heroTalent/heroTalent_npc_dota_hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_bloodseeker:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_bloodseeker"
end

modifier_heroTalent_npc_dota_hero_bloodseeker = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bloodseeker:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_bloodseeker:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.self_line = self.ability:GetSpecialValueFor("self_line")
	self.line = self.ability:GetSpecialValueFor("line")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.bonus_outgoing = self.ability:GetSpecialValueFor("bonus_outgoing")
	self.final_outgoing = self.outgoing + self.parent:GetLevel()*self.bonus_outgoing
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.heal = self.ability:GetSpecialValueFor("heal")

	self.talentgain1 = self.ability:GetTalentGain(0.1)
	self.talentgain2 = self.ability:GetTalentGain(0.3)
	self.line_t = self.line * self.talentgain1
	self.attack_speed_t = self.attack_speed * self.talentgain1
	self.final_outgoing_t = self.final_outgoing*self.talentgain2
end
function modifier_heroTalent_npc_dota_hero_bloodseeker:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_bloodseeker:OnTooltip()
	self.talentgain1 = self.ability:GetTalentGain(0.1)
	self.talentgain2 = self.ability:GetTalentGain(0.3)
	self.final_outgoing = self.outgoing + self.parent:GetLevel()*self.bonus_outgoing
	self.line_t = self.line * self.talentgain1
	self.attack_speed_t = self.attack_speed * self.talentgain1
	self.final_outgoing_t = self.final_outgoing*self.talentgain2

	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.line_t
    end
    if self._tooltip == 2 then
        return self.final_outgoing_t
    end
    if self._tooltip == 3 then
        return self.attack_speed_t
    end
end
function modifier_heroTalent_npc_dota_hero_bloodseeker:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_heroTalent_npc_dota_hero_bloodseeker:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if attacker ~= self.parent then return end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end
	if not attacker:IsAlive() then return end

	self.talentgain1 = self.ability:GetTalentGain(0.1)
	self.line_t = self.line * self.talentgain1
	if target:GetHealthPercent() > self.line_t then return end

	self.talentgain2 = self.ability:GetTalentGain(0.3)
	self.attack_speed_t = self.attack_speed * self.talentgain1
	self.final_outgoing = self.outgoing + self.parent:GetLevel()*self.bonus_outgoing
	self.final_outgoing_t = self.final_outgoing*self.talentgain2

	if attacker:GetHealthPercent() < self.self_line then
		local healing = self.heal*self.parent:GetLevel()
		attacker:Heal(healing, self.ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, attacker, healing, nil)
	end

	local buff = attacker:FindModifierByName("modifier_heroTalent_npc_dota_hero_bloodseeker_buff")
	if buff then
		buff:ForceRefresh()
		buff:SetStackCount(self.attack_speed_t)
		buff:SetDuration(self.duration, true)
	else
		local newbuff = attacker:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_bloodseeker_buff", {duration = self.duration})
		if newbuff then
			newbuff:SetStackCount(self.attack_speed_t)
		end
	end

	return self.final_outgoing_t
end


modifier_heroTalent_npc_dota_hero_bloodseeker_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bloodseeker_buff:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_buff:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_bloodseeker_buff:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_buff:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_buff:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf" end
function modifier_heroTalent_npc_dota_hero_bloodseeker_buff:GetActivityTranslationModifiers() return "thirst" end

function modifier_heroTalent_npc_dota_hero_bloodseeker_buff:ADDeclareFunctions()
	return {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
	}
end

function modifier_heroTalent_npc_dota_hero_bloodseeker_buff:Advanced_GetModifierAttackSpeedPercentage()
	return self:GetStackCount()
end

