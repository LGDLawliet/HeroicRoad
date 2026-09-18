
modifier_roller_compacted = advanced_modifier({})

function modifier_roller_compacted:IsHidden()return true end
function modifier_roller_compacted:IsDebuff()return false end
function modifier_roller_compacted:IsPurgable()return false end
function modifier_roller_compacted:IsPurgeException() 	return false end
function modifier_roller_compacted:RemoveOnDeath() return false end
function modifier_roller_compacted:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_roller_compacted:OnCreated(keys)
  if IsServer() then
    self.bonus_damage = GetChaticEra_Artifact_Special(self,"bonus_damage")
    self.unit_record = {}
  end
end


function modifier_roller_compacted:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
  }
end

function modifier_roller_compacted:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)

	if IsServer() then
    local unitName = keys.target:GetUnitName()
    if not self.unit_record[unitName] then
      self.unit_record[unitName] = 0
      if not keys.target:IsChaoticEraElite() then
        self.unit_record[unitName] = self.bonus_damage
      end
    end
    return self.unit_record[unitName]
	end
	return 0
end

