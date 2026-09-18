modifier_super_attack = advanced_modifier({})

function modifier_super_attack:IsHidden()return true end
function modifier_super_attack:IsDebuff()return false end
function modifier_super_attack:IsPurgable()return false end
function modifier_super_attack:IsPurgeException() 	return false end
function modifier_super_attack:RemoveOnDeath() return false end
function modifier_super_attack:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_super_attack:OnCreated(keys)
  if IsServer() then
    self.bonus_attack = GetChaticEra_Artifact_Special(self,"bonus_attack")
    self.bonus_attack_pct = GetChaticEra_Artifact_Special(self,"bonus_attack_pct")
    self:SetHasCustomTransmitterData( true )-- 同步cy
  end
end

function modifier_super_attack:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
  }
end

function modifier_super_attack:Advanced_GetModifierBaseAttack_BonusDamage(keys)

    return self.bonus_attack
end
function modifier_super_attack:Advanced_GetModifierDamageOutgoing_Percentage(keys)
    return self.bonus_attack_pct
end

function modifier_super_attack:AddCustomTransmitterData( )
	return
	{
		bonus_attack_pct = self.bonus_attack_pct,
		bonus_attack = self.bonus_attack,
	}
end

function modifier_super_attack:HandleCustomTransmitterData( data )
	self.bonus_attack_pct = data.bonus_attack_pct
	self.bonus_attack = data.bonus_attack
end
