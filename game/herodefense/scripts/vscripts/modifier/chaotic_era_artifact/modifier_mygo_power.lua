
modifier_mygo_power = advanced_modifier({})

function modifier_mygo_power:IsHidden()return true end
function modifier_mygo_power:IsDebuff()return false end
function modifier_mygo_power:IsPurgable()return false end
function modifier_mygo_power:IsPurgeException() 	return false end
function modifier_mygo_power:RemoveOnDeath() return false end
function modifier_mygo_power:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_mygo_power:GetTexture() return self.texture end
function modifier_mygo_power:DestroyOnExpire() return false end
function modifier_mygo_power:OnCreated(keys)
    self.atb = GetChaticEra_Artifact_Special(self,"atb")
    self.hp = GetChaticEra_Artifact_Special(self,"hp")
    self.mp = GetChaticEra_Artifact_Special(self,"mp")
    self.attack = GetChaticEra_Artifact_Special(self,"attack")
    self.spell = GetChaticEra_Artifact_Special(self,"spell")
    self.stack = GetChaticEra_Artifact_Special(self,"stack")
    if IsServer() then
        self:SetStackCount(100+self.stack*2)
        self:StartIntervalThink(1)
    end
end

function modifier_mygo_power:OnIntervalThink()
    local parent = self:GetParent()
    self:SetStackCount(100+self.stack*2)
    for i=0, parent:GetAbilityCount() - 1 do
        local Ability = parent:GetAbilityByIndex(i)
        if Ability ~= nil and Ability:GetAbilityName() ~= "Default_Move"  then
            self:SetStackCount(math.max(self:GetStackCount() - self.stack, 0))
        end
    end
end

function modifier_mygo_power:ADDeclareFunctions()
  return{
    advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
    advanced_MODIFIER_PROPERTY_MANA_BONUS,
  }
end

function modifier_mygo_power:Advanced_GetModifierBonusStats_Strength()
  return self.atb*self:GetStackCount()*0.01
end
function modifier_mygo_power:Advanced_GetModifierBonusStats_Agility()
  return self.atb*self:GetStackCount()*0.01
end
function modifier_mygo_power:Advanced_GetModifierBonusStats_Intellect()
  return self.atb*self:GetStackCount()*0.01
end
function modifier_mygo_power:Advanced_GetModifierPreAttack_BonusDamage()
    return self.attack*self:GetStackCount()*0.01
end
function modifier_mygo_power:Advanced_GetModifierSpellAmplifyBonus()
    return self.spell*self:GetStackCount()*0.01
end
function modifier_mygo_power:AdvancedGetModifierHealthBonus()
    return self.hp*self:GetStackCount()*0.01
end
function modifier_mygo_power:AdvancedGetModifierManaBonus()
    return self.mp*self:GetStackCount()*0.01
end
