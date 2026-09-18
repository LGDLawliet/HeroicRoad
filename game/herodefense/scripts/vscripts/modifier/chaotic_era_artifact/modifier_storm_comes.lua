
modifier_storm_comes = advanced_modifier({})

function modifier_storm_comes:IsHidden()return false end
function modifier_storm_comes:IsDebuff()return false end
function modifier_storm_comes:IsPurgable()return false end
function modifier_storm_comes:IsPurgeException() 	return false end
function modifier_storm_comes:RemoveOnDeath() return false end
function modifier_storm_comes:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_storm_comes:DestroyOnExpire() return false end
function modifier_storm_comes:GetTexture() return "zuus_cloud" end

function modifier_storm_comes:OnCreated(keys)
  
    self.stack = GetChaticEra_Artifact_Special(self,"stack")
    self.stack_max = GetChaticEra_Artifact_Special(self,"stack_max")
    self.outgoing = GetChaticEra_Artifact_Special(self,"outgoing")
    self.duration = GetChaticEra_Artifact_Special(self,"duration")
  if IsServer() then
    self:SetStackCount(0)
    self:StartIntervalThink(1)
  end
end

function modifier_storm_comes:OnIntervalThink()
    self:SetStackCount(math.min(self:GetStackCount() + self.stack, self.stack_max))
end

function modifier_storm_comes:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end

function modifier_storm_comes:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = self:GetCaster()
	local target = keys.target
	if IsLightningDamage(keys) and self:GetStackCount() >= 1 and self:GetRemainingTime() < 0 then
    self.outgoing_f = self.outgoing*self:GetStackCount()
    self:SetDuration(self.duration, true)
    self:SetStackCount(0)
	end

  if IsLightningDamage(keys) and self:GetRemainingTime() >= 0 then
    return self.outgoing_f
  end
end