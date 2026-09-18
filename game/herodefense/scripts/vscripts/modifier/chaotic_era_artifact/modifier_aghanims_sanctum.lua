
modifier_aghanims_sanctum = advanced_modifier({})

function modifier_aghanims_sanctum:IsHidden()return true end
function modifier_aghanims_sanctum:IsDebuff()return false end
function modifier_aghanims_sanctum:IsPurgable()return false end
function modifier_aghanims_sanctum:IsPurgeException() 	return false end
function modifier_aghanims_sanctum:RemoveOnDeath() return false end
function modifier_aghanims_sanctum:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_aghanims_sanctum:DestroyOnExpire() return false end
function modifier_aghanims_sanctum:GetTexture() return "chaotic_era_spell/aghanims_sanctum" end
function modifier_aghanims_sanctum:OnCreated(keys)
  self.bonus_level = GetChaticEra_Artifact_Special(self,"bonus_level")
  if IsServer() then
    local levelUp = GetChaticEra_Artifact_Special(self,"level_upgrade")
    for i=0, self:GetParent():GetAbilityCount() - 1 do
      local Ability = self:GetParent():GetAbilityByIndex(i)
      if Ability ~= nil then
        if Ability:GetSpecialValueFor("advanced_level")>=1 then
          for i = 1, levelUp, 1 do
            skillshop:UpgradeAbilitiesPassLV25AndExp(Ability,25)
          end
        end
      end
    end
  end
end

function modifier_aghanims_sanctum:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS
  }
end


function modifier_aghanims_sanctum:Advanced_GetAdvancedLevelBonus(keys)
  return self.bonus_level
end


-- function modifier_aghanims_sanctum:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOOLTIP,
-- 	}
-- end


-- function modifier_aghanims_sanctum:OnTooltip()
-- 	self._tooltip = (self._tooltip or 0) % 1 + 1
-- 	if self._tooltip == 1 then
-- 		return  self:Advanced_GetModifierIncomingDamage_Percentage()
-- 	end
-- end
