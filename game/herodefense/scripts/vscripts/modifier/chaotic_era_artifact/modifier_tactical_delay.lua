
modifier_tactical_delay = advanced_modifier({})

function modifier_tactical_delay:IsHidden()return true end
function modifier_tactical_delay:IsDebuff()return false end
function modifier_tactical_delay:IsPurgable()return false end
function modifier_tactical_delay:IsPurgeException() 	return false end
function modifier_tactical_delay:RemoveOnDeath() return false end
function modifier_tactical_delay:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_tactical_delay:GetTexture() return self.texture end
function modifier_tactical_delay:DestroyOnExpire() return false end
function modifier_tactical_delay:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then

    self.delay = GetChaticEra_Artifact_Special(self,"delay")
    self.bonus_gain = GetChaticEra_Artifact_Special(self,"bonus_gain")*0.01

  end
end

function modifier_tactical_delay:OnRefresh(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then

    self:IncrementStackCount()

  end
end


function modifier_tactical_delay:Advanced_Chaotic_Era_Fail_CountDown(keys)	
	return self.delay * (1+self:GetStackCount()*self.bonus_gain)
end
function modifier_tactical_delay:ADDeclareFunctions()
    return 
    {
      advanced_MODIFIER_PROPERTY_Chaotic_Era_Fail_CountDown,

    }
end

