
modifier_artifact_prescient = advanced_modifier({})

function modifier_artifact_prescient:IsHidden()return true end
function modifier_artifact_prescient:IsDebuff()return false end
function modifier_artifact_prescient:IsPurgable()return false end
function modifier_artifact_prescient:IsPurgeException() 	return false end
function modifier_artifact_prescient:RemoveOnDeath() return false end
function modifier_artifact_prescient:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end




function modifier_artifact_prescient:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.count = GetChaticEra_Artifact_Special(self,"count")
    for i = 1, self.count, 1 do
      chaotic_era:GenerateSpellList_Genaral(self:GetParent():GetPlayerOwnerID())
    end
    self:Destroy()
  end
end


