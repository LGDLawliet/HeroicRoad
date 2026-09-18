heroTalent_npc_dota_hero_tinker = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tinker", "heroTalent/heroTalent_npc_dota_hero_tinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tinker_buff", "heroTalent/heroTalent_npc_dota_hero_tinker", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_tinker:IsRefreshable()	return false end
function heroTalent_npc_dota_hero_tinker:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_tinker"
end
function heroTalent_npc_dota_hero_tinker:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")*caster:GetModifierDurationGainIndex(0.4)
	caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_tinker_buff", {duration = duration})
	caster:EmitSound("Hero_Tinker.Rearm")
end
modifier_heroTalent_npc_dota_hero_tinker_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tinker_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_tinker_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tinker_buff:IsPurgable()	return false end

modifier_heroTalent_npc_dota_hero_tinker = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tinker:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_tinker:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tinker:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_tinker:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tinker:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_tinker:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.interval = 0.5
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.cds = self.ability:GetSpecialValueFor("cds")*0.01*self.interval

	self.talentgain = self.ability:GetTalentGain(0.6)
	self.outgoing_t = self.outgoing * self.talentgain
	self.cds_t = self.cds * self.talentgain

	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_heroTalent_npc_dota_hero_tinker:OnIntervalThink()
	if not self.parent:IsAlive() then return end
	self.talentgain = self.ability:GetTalentGain(0.6)
	self.outgoing_t = self.outgoing * self.talentgain
	self.cds_t = self.cds * self.talentgain
	--print(self:GetParent():GetCooldownReduction())--冷却缩减的输出方式是0.45~1

	if self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_tinker_buff") then
		local hero = self:GetParent()
		for i=0, 11 do
			local Ability = hero:GetAbilityByIndex(i)
			if Ability ~= nil and (not Ability:IsCooldownReady()) and Ability:IsRefreshable() then
				if Ability ~= self:GetAbility()	then
					local new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - self.cds_t,0)
					Ability:EndCooldown()
					Ability:StartCooldown(new_cooldown)
				end
			end
		end
	end
end
function modifier_heroTalent_npc_dota_hero_tinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP, 
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_tinker:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.6)
	self.outgoing_t = self.outgoing * self.talentgain
	self.cds_t = self.cds * self.talentgain

	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.cds_t*100/self.interval
    elseif self._tooltip == 2 then
        return self.outgoing_t
	elseif self._tooltip == 3 then
        return self:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    end
end
function modifier_heroTalent_npc_dota_hero_tinker:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL, 
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_tinker:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return math.max(self.outgoing_t*math.floor(100 - self.parent:GetCooldownReduction()*100 ), 0)
end
