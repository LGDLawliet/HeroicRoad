
modifier_curse_of_decline = advanced_modifier({})

function modifier_curse_of_decline:IsHidden()return true end
function modifier_curse_of_decline:IsDebuff()return false end
function modifier_curse_of_decline:IsPurgable()return false end
function modifier_curse_of_decline:IsPurgeException() 	return false end
function modifier_curse_of_decline:RemoveOnDeath() return false end
function modifier_curse_of_decline:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_curse_of_decline:GetTexture() return "zuus_thundergods_wrath" end

function modifier_curse_of_decline:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.health_reduction = GetChaticEra_Artifact_Special(self,"health_reduction")
  end
end

function modifier_curse_of_decline:OnRefresh(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.health_reduction = SubtractionMultiplicationPercentage(self.health_reduction, GetChaticEra_Artifact_Special(self,"health_reduction"))
  end
end


-- function modifier_curse_of_decline:ModifyTaskData(data)
--   if IsChaoticEraElite(data.id) then
--     data.attribute.bonusHealth = data.attribute.bonusHealth*(1-self.health_reduction*0.01)
--   end
-- end


function modifier_curse_of_decline:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_Chaotic_Era___Spawn_Health_Percentage_Reduction_Mul,
  }
end



function modifier_curse_of_decline:Advanced_GetChaotic_Era___Spawn_Health_Reduction_Percentage(keys)
  if keys.unit and keys.unit:IsChaoticEraElite() then
    return self.health_reduction
  end
  return 0
end
