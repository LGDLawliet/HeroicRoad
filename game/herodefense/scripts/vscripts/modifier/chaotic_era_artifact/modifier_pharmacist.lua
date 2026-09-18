
modifier_pharmacist = advanced_modifier({})

function modifier_pharmacist:IsHidden()return true end
function modifier_pharmacist:IsDebuff()return false end
function modifier_pharmacist:IsPurgable()return false end
function modifier_pharmacist:IsPurgeException() 	return false end
function modifier_pharmacist:RemoveOnDeath() return false end
function modifier_pharmacist:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_pharmacist:GetTexture() return self.texture end
function modifier_pharmacist:DestroyOnExpire() return false end
function modifier_pharmacist:OnCreated(keys)
  self.bonus_gain = GetChaticEra_Artifact_Special(self,"bonus_gain")
  self.cost_reduction = GetChaticEra_Artifact_Special(self,"cost_reduction")
end

function modifier_pharmacist:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_Chaotic_Era_POTION_EFFECT,
    advanced_MODIFIER_PROPERTY_Chaotic_Era_POTION_COST_REDUCTION,
  

  }
end

function modifier_pharmacist:Advanced_Chaotic_Era_PotionEffect()
  return self.bonus_gain
end


function modifier_pharmacist:Advanced_Chaotic_Era_PotionCostReduction()
  return self.cost_reduction
end