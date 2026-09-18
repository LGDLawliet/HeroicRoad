modifier_super_dark = advanced_modifier({})

function modifier_super_dark:IsHidden()return true end
function modifier_super_dark:IsDebuff()return false end
function modifier_super_dark:IsPurgable()return false end
function modifier_super_dark:IsPurgeException() 	return false end
function modifier_super_dark:RemoveOnDeath() return false end
function modifier_super_dark:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_super_dark:OnCreated(keys)
  if IsServer() then
    self.dark_damage = GetChaticEra_Artifact_Special(self,"dark_damage")
    self.outgoing = GetChaticEra_Artifact_Special(self,"outgoing")
  end
end

function modifier_super_dark:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
  }
end

function modifier_super_dark:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    local outgoing = self.outgoing
    if IsDarkDamage(keys) then
        outgoing = outgoing + self.dark_damage
    end
    return outgoing
end
