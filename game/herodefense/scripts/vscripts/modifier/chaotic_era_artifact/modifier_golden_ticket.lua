
modifier_golden_ticket = advanced_modifier({})

function modifier_golden_ticket:IsHidden()return false end
function modifier_golden_ticket:IsDebuff()return false end
function modifier_golden_ticket:IsPurgable()return false end
function modifier_golden_ticket:IsPurgeException() 	return false end
function modifier_golden_ticket:RemoveOnDeath() return false end
function modifier_golden_ticket:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_golden_ticket:GetTexture() return "chaotic_era_spell/golden_ticket" end
function modifier_golden_ticket:DestroyOnExpire() return false end


function modifier_golden_ticket:OnCreated(keys)
  -- self.bonus_move =  GetChaticEra_Artifact_Special(self,"bonus_move")
  -- self.bonus_incoming_damage = GetChaticEra_Artifact_Special(self,"bonus_incoming_damage")
  -- self.bonus_flame_damage = GetChaticEra_Artifact_Special(self,"bonus_flame_damage")
  if IsServer() then
    self:SetStackCount(GetChaticEra_Artifact_Special(self,"count"))
    self.gold_reduction = GetChaticEra_Artifact_Special(self,"gold_reduction")
  end
end

function modifier_golden_ticket:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_Shop_Discount,
  }
end



function modifier_golden_ticket:Advanced_GetShop_Discount(keys)
	if IsServer() then
    self:DecrementStackCount()
    if self:GetStackCount()<=0 then
      self:Destroy()
    end
    return self.gold_reduction
	end
	return 0
end


