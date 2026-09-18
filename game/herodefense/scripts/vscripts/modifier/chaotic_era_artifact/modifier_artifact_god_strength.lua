LinkLuaModifier("modifier_artifact_god_strength_buff", "modifier/chaotic_era_artifact/modifier_artifact_god_strength", LUA_MODIFIER_MOTION_NONE)

modifier_artifact_god_strength = advanced_modifier({})

function modifier_artifact_god_strength:IsHidden()return true end
function modifier_artifact_god_strength:IsDebuff()return false end
function modifier_artifact_god_strength:IsPurgable()return false end
function modifier_artifact_god_strength:IsPurgeException() 	return false end
function modifier_artifact_god_strength:RemoveOnDeath() return false end
function modifier_artifact_god_strength:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_artifact_god_strength:GetTexture() return self.texture end
function modifier_artifact_god_strength:IsAura() return not self:GetParent():PassivesDisabled() end
function modifier_artifact_god_strength:GetModifierAura()	return "modifier_artifact_god_strength_buff" end
function modifier_artifact_god_strength:GetAuraRadius()	return self.radius end
function modifier_artifact_god_strength:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_artifact_god_strength:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_artifact_god_strength:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_artifact_god_strength:GetAuraEntityReject(hEntity)
	if hEntity == self:GetParent() then
		return true
	end
	return false
end
function modifier_artifact_god_strength:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.radius = GetChaticEra_Artifact_Special(self,"radius")
    -- self.bonus_damage = GetChaticEra_Artifact_Special(self,"bonus_damage")
  end
end


-- function modifier_artifact_god_strength:ADDeclareFunctions()
--   return 
--   {
--     MODIFIER_EVENT_ON_Wave_Start = {},
--     advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
--   }
-- end


-- function modifier_artifact_god_strength:OnWaveStart(table)
-- 	self:SetStackCount(self.armor_ignore)
-- end

-- function modifier_artifact_god_strength:Advanced_GetModifierAttackArmor_Ignore() 
--   return self:GetStackCount() 
-- end

modifier_artifact_god_strength_buff = advanced_modifier({})

function modifier_artifact_god_strength_buff:IsHidden()return false end
function modifier_artifact_god_strength_buff:IsDebuff()return false end
function modifier_artifact_god_strength_buff:IsPurgable()return false end
function modifier_artifact_god_strength_buff:IsPurgeException() 	return false end
function modifier_artifact_god_strength_buff:RemoveOnDeath() return false end
function modifier_artifact_god_strength_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_artifact_god_strength_buff:GetTexture() return "sven/cyclopean_marauder_ability_icons/sven_gods_strength" end
function modifier_artifact_god_strength_buff:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  self.bonus_max = GetChaticEra_Artifact_Special("artifact_god_strength","bonus_max")

  self.bonus_damage = GetChaticEra_Artifact_Special("artifact_god_strength","bonus_damage")*0.01 
 
end


function modifier_artifact_god_strength_buff:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
  }
end


function modifier_artifact_god_strength_buff:Advanced_GetModifierPreAttack_BonusDamage() 
  return math.min(self.bonus_max,self:GetAuraOwner():GetStrength()*self.bonus_damage)
end

function modifier_artifact_god_strength_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_artifact_god_strength_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPreAttack_BonusDamage()
	end
end
