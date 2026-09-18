
modifier_fat_rat = advanced_modifier({})

function modifier_fat_rat:IsHidden()return true end
function modifier_fat_rat:IsDebuff()return false end
function modifier_fat_rat:IsPurgable()return false end
function modifier_fat_rat:IsPurgeException() 	return false end
function modifier_fat_rat:RemoveOnDeath() return false end
function modifier_fat_rat:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_fat_rat:OnCreated(keys)
  if IsServer() then
    self.bonus_gold = GetChaticEra_Artifact_Special(self,"bonus_gold")
    -- self.unit_record = {}
  end
end

function modifier_fat_rat:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus,
  }
end

function modifier_fat_rat:Advanced_GetChaotic_Era_BountyBonus()
  -- print("self.bonus_gold=",self.bonus_gold)
  return self.bonus_gold
end