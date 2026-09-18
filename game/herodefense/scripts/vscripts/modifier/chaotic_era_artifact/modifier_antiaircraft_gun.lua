
modifier_antiaircraft_gun = advanced_modifier({})

function modifier_antiaircraft_gun:IsHidden()return true end
function modifier_antiaircraft_gun:IsDebuff()return false end
function modifier_antiaircraft_gun:IsPurgable()return false end
function modifier_antiaircraft_gun:IsPurgeException() 	return false end
function modifier_antiaircraft_gun:RemoveOnDeath() return false end
function modifier_antiaircraft_gun:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_antiaircraft_gun:GetTexture() return self.texture end
function modifier_antiaircraft_gun:DestroyOnExpire() return false end
function modifier_antiaircraft_gun:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then

    
    self.value2 = GetChaticEra_Artifact_Special(self,"value2")
    self.value3 = GetChaticEra_Artifact_Special(self,"value3")

  end
end

function modifier_antiaircraft_gun:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)	
	if IsServer() and keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK then
		if self:GetParent():IsRangedAttacker() then
      -- print()
      local dis = CalculateDistance(self:GetParent(),keys.target)/self.value2
      -- print("dis=",dis)
      if dis>=1 then
        local bonus = math.floor(dis)*self.value3
        -- print("bonus",bonus)
        return bonus
      end
      
    end

	end
	return 0
end
function modifier_antiaircraft_gun:ADDeclareFunctions()
    return 
    {
      advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
      advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

    }
end

function modifier_antiaircraft_gun:Advanced_GetModifierAttackRangeBonus()
 if self:GetParent():IsRangedAttacker() then
  return self.value1
 end
 return 0
end





