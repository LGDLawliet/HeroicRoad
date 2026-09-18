
modifier_out_of_nothing = advanced_modifier({})

function modifier_out_of_nothing:IsHidden()return false end
function modifier_out_of_nothing:IsDebuff()return false end
function modifier_out_of_nothing:IsPurgable()return false end
function modifier_out_of_nothing:IsPurgeException() 	return false end
function modifier_out_of_nothing:RemoveOnDeath() return false end
function modifier_out_of_nothing:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_out_of_nothing:GetTexture() return self.texture end

function modifier_out_of_nothing:OnCreated(keys)
  -- self.rune_level3 = GetChaticEra_Artifact_Special(self,"rune_level3")
  if IsServer() then
    local parent = self:GetParent()
    if true then
      local count = GetChaticEra_Artifact_Special(self,"count1")
      for i=1, count do
        chaotic_era_shop:GenetateArtifactForPlayer(self:GetParent():GetPlayerOwnerID(),false)
      end
    end
    if true then
      local count = GetChaticEra_Artifact_Special(self,"count2")
      for i=1, count do
        chaotic_era:GenerateSpellList_Genaral(self:GetParent():GetPlayerOwnerID())
      end
    end
    if true then
      local count = GetChaticEra_Artifact_Special(self,"count3")
      for i=1, count do
        chaotic_era_shop:AddEvoluteionChance(self:GetParent():GetPlayerOwnerID())
      end
    end


    self:Destroy()
 

  end
end
