
modifier_thunder = advanced_modifier({})

function modifier_thunder:IsHidden()return true end
function modifier_thunder:IsDebuff()return false end
function modifier_thunder:IsPurgable()return false end
function modifier_thunder:IsPurgeException() 	return false end
function modifier_thunder:RemoveOnDeath() return false end
function modifier_thunder:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_thunder:GetTexture() return self.texture end
function modifier_thunder:DestroyOnExpire() return false end
function modifier_thunder:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then

    self.value2 = GetChaticEra_Artifact_Special(self,"value2")
    self.value3 = GetChaticEra_Artifact_Special(self,"value3")
    self.value4 = 1-GetChaticEra_Artifact_Special(self,"value4")*0.01
    self.value5 = 1/GetChaticEra_Artifact_Special(self,"value5")
    -- self.value2 = GetChaticEra_Artifact_Special(self,"value2")
  end
end

function modifier_thunder:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)	
	if IsServer() and DamageFilter(keys.record,HD_DAMAGE_FLAG_LIGHTING_DAMAGE) then
		if self:GetRemainingTime()>=1 then
      return
    end
    if keys.inflictor and keys.inflictor:GetCooldownTimeRemaining()>=self.value2 then
      local caster = self:GetCaster()
      if caster:RollRandom(self.value3,1)  then
				local new_cooldown = keys.inflictor:GetCooldownTimeRemaining()*self.value4
        keys.inflictor:EndCooldown()
        keys.inflictor:StartCooldown(new_cooldown)
        if self:GetRemainingTime() < 0 then
          self:SetDuration(0,false)
        end
        self:SetDuration(self:GetRemainingTime()+self.value5, false)
			end
    end

	end
	return 0
end
function modifier_thunder:ADDeclareFunctions()
    return 
    {
      advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,

    }
end

