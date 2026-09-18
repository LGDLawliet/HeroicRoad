
modifier_soul_devouring = advanced_modifier({})

function modifier_soul_devouring:IsHidden()return true end
function modifier_soul_devouring:IsDebuff()return false end
function modifier_soul_devouring:IsPurgable()return false end
function modifier_soul_devouring:IsPurgeException() 	return false end
function modifier_soul_devouring:RemoveOnDeath() return false end
function modifier_soul_devouring:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_soul_devouring:GetTexture() return self.texture end

function modifier_soul_devouring:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.bonus_damage = GetChaticEra_Artifact_Special(self,"bonus_damage")
    self.bonus_max = GetChaticEra_Artifact_Special(self,"bonus_max")
    self.boss_gain = GetChaticEra_Artifact_Special(self,"boss_gain")
    -- self.time_require = GetChaticEra_Artifact_Special(self,"time_require")
    -- self.value2 = GetChaticEra_Artifact_Special(self,"value2")
    self.unit_record = {}

  end
end


function modifier_soul_devouring:ADDeclareFunctions()
  return 
  {
    MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
    advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
  }
end

function modifier_soul_devouring:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)

	if IsServer() then
		if self.unit_record[keys.target:GetUnitName()] then
			return self.unit_record[keys.target:GetUnitName()] 
		end
	end
	return 0
end

function modifier_soul_devouring:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker
		if attacker and IsEnemy(unit,attacker) then
			if attacker:PassivesDisabled() then
				return
			end
			local unit_name = unit:GetUnitName()
      if not self.unit_record[unit_name] then
        self.unit_record[unit_name] = 0
      end
      local factor = 1
      if unit:IsChaoticEraElite() then
        factor = factor*self.boss_gain
      end
      self.unit_record[unit_name] = math.min(self.unit_record[unit_name] + self.bonus_damage*factor,self.bonus_max)
		end
	end
end

