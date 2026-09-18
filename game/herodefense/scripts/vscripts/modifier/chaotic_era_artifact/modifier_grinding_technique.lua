
modifier_grinding_technique = advanced_modifier({})

function modifier_grinding_technique:IsHidden()return true end
function modifier_grinding_technique:IsDebuff()return false end
function modifier_grinding_technique:IsPurgable()return false end
function modifier_grinding_technique:IsPurgeException() 	return false end
function modifier_grinding_technique:RemoveOnDeath() return false end
function modifier_grinding_technique:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_grinding_technique:GetTexture() return self.texture end

function modifier_grinding_technique:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.armor_ignore = GetChaticEra_Artifact_Special(self,"armor_ignore")
    self.interval = GetChaticEra_Artifact_Special(self,"interval")
    self.lose = GetChaticEra_Artifact_Special(self,"lose")
    self:SetStackCount(self.armor_ignore)
    self:StartIntervalThink(self.interval)
  end
end
function modifier_grinding_technique:OnIntervalThink()
  self:SetStackCount(math.max(0,self:GetStackCount()-self.lose))
end


function modifier_grinding_technique:ADDeclareFunctions()
  return 
  {
    MODIFIER_EVENT_ON_Wave_Start = {},
    advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
  }
end


function modifier_grinding_technique:OnWaveStart(table)
	self:SetStackCount(self.armor_ignore)
end

function modifier_grinding_technique:Advanced_GetModifierAttackArmor_Ignore() 
  return self:GetStackCount() 
end

