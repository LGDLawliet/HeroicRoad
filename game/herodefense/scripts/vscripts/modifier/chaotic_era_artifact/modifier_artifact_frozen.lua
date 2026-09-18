
modifier_artifact_frozen = advanced_modifier({})

function modifier_artifact_frozen:IsHidden()return true end
function modifier_artifact_frozen:IsDebuff()return false end
function modifier_artifact_frozen:IsPurgable()return false end
function modifier_artifact_frozen:IsPurgeException() 	return false end
function modifier_artifact_frozen:RemoveOnDeath() return false end
function modifier_artifact_frozen:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_artifact_frozen:GetTexture() return self.texture end
function modifier_artifact_frozen:DestroyOnExpire() return false end
function modifier_artifact_frozen:OnCreated(keys)
  self.maga_regen = GetChaticEra_Artifact_Special(self,"value1")*0.01
  self.cd = GetChaticEra_Artifact_Special(self,"value2")
  if IsServer() then
    --self.timer = GameRules:GetGameTime()
    self:StartIntervalThink(2)
  end
end

function modifier_artifact_frozen:OnIntervalThink()
  local parent = self:GetParent()
  self:SetStackCount(GetIceSpellCount(parent))
end
function modifier_artifact_frozen:ADDeclareFunctions()
  return{
    advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
  }
end
function modifier_artifact_frozen:Advanced_GetModifierCooldownReduction()
  return self:GetStackCount()*self.cd
end
function modifier_artifact_frozen:AdvancedGetModifierConstantManaRegen()
  local parent = self:GetParent()
  return self:GetStackCount()*self.maga_regen*parent:GetMaxMana()
end

-- function modifier_artifact_frozen:OnIntervalThink()
--   local parent = self:GetParent()
--   local count = 0
--   for i=0, self:GetParent():GetAbilityCount() - 1 do
--     local Ability = parent:GetAbilityByIndex(i)
--     if Ability ~= nil and Ability:IsRefreshable() and Ability:IsChaoticEraSpell() and Ability:IsIceSpell() then
--       Ability:SetFrozenCooldown(true)
--       count = count + 1
--     end
--   end
--   for i=0, self:GetParent():GetAbilityCount() - 1 do
--     local Ability = parent:GetAbilityByIndex(i)
--     if Ability ~= nil and Ability:IsRefreshable() and Ability:IsChaoticEraSpell() and Ability:IsIceSpell() then
--       if not Ability:IsCooldownReady() then
--         local time = GameRules:GetGameTime()-self.timer 
       
--         local cooldown_time = Ability:GetCooldownTimeRemaining() - time - (count-1)*time*self.value1
--         Ability:EndCooldown()
--         if cooldown_time>0 then
--           Ability:StartCooldown(cooldown_time)
--         end
--         break
--       end
--     end
--   end
--   self.timer = GameRules:GetGameTime()
-- end

