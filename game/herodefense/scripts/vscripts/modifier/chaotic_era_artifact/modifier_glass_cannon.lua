
modifier_glass_cannon = advanced_modifier({})

function modifier_glass_cannon:IsHidden()return false end
function modifier_glass_cannon:IsDebuff()return false end
function modifier_glass_cannon:IsPurgable()return false end
function modifier_glass_cannon:IsPurgeException() 	return false end
function modifier_glass_cannon:RemoveOnDeath() return false end
function modifier_glass_cannon:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_glass_cannon:GetTexture() return "chaotic_era_spell/glass_cannon" end

function modifier_glass_cannon:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  self.bonus_damage = GetChaticEra_Artifact_Special(self,"bonus_damage")
  self.stack = GetChaticEra_Artifact_Special(self,"stack")

  self:SetStackCount(self.stack)
end

function modifier_glass_cannon:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
  }
end

function modifier_glass_cannon:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
  return self.bonus_damage*self:GetStackCount()
end

function modifier_glass_cannon:Advanced_GetModifierIncomingDamage_Percentage(keys)
  return self.bonus_damage*self:GetStackCount()
end

function modifier_glass_cannon:OnDeath(keys)
	if IsClient() then
		return
	end
	if keys.unit == self:GetParent() then
      self:SetStackCount(math.max(self:GetStackCount()-1,0))
	end
end

function modifier_glass_cannon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_glass_cannon:OnTooltip() 
  self._tooltip = (self._tooltip or 0) % 1 + 1
  if self._tooltip == 1 then
      return self.bonus_damage*self:GetStackCount()
  end
end






