
modifier_blacksmith_craftsmanship = advanced_modifier({})

function modifier_blacksmith_craftsmanship:IsHidden()return true end
function modifier_blacksmith_craftsmanship:IsDebuff()return false end
function modifier_blacksmith_craftsmanship:IsPurgable()return false end
function modifier_blacksmith_craftsmanship:IsPurgeException() 	return false end
function modifier_blacksmith_craftsmanship:RemoveOnDeath() return false end
function modifier_blacksmith_craftsmanship:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_blacksmith_craftsmanship:GetTexture() return self.texture end

function modifier_blacksmith_craftsmanship:OnCreated(keys)
    self.bonus = GetChaticEra_Artifact_Special(self,"value1")
end

function modifier_blacksmith_craftsmanship:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_Chaotic_Era_SHOP_LEVEL_BONUS,
  }
end



function modifier_blacksmith_craftsmanship:Advanced_Chaotic_Era_ShopLevelBonus()
	return self.bonus
end

