LinkLuaModifier("modifier_domination_helmet_buff", "modifier/chaotic_era_artifact/modifier_domination_helmet", LUA_MODIFIER_MOTION_NONE)

modifier_domination_helmet = advanced_modifier({})

function modifier_domination_helmet:IsHidden()return true end
function modifier_domination_helmet:IsDebuff()return false end
function modifier_domination_helmet:IsPurgable()return false end
function modifier_domination_helmet:IsPurgeException() 	return false end
function modifier_domination_helmet:RemoveOnDeath() return false end
function modifier_domination_helmet:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_domination_helmet:OnCreated(keys)
  if IsServer() then
    self.summon_gain = GetChaticEra_Artifact_Special(self,"summon_gain")
    -- self.unit_record = {}
  end
end

function modifier_domination_helmet:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_Summon_Intensity, --召唤增强
    MODIFIER_EVENT_ON_SUMMON = {self:GetCaster(), nil},  
  }
end

function modifier_domination_helmet:Advanced_GetModifier_Summon_Intensity()
  return self.summon_gain
end


function modifier_domination_helmet:AdvancedOnSummon(keys)
	if IsServer() then
		local unit = keys.target
    if IsValid(unit) then
      unit:AddNewModifier(self:GetParent(), nil, "modifier_domination_helmet_buff", {})
    end

	end
end






modifier_domination_helmet_buff = advanced_modifier({})

function modifier_domination_helmet_buff:IsHidden()return true end
function modifier_domination_helmet_buff:IsDebuff()return false end
function modifier_domination_helmet_buff:IsPurgable()return false end
function modifier_domination_helmet_buff:IsPurgeException() 	return false end
function modifier_domination_helmet_buff:RemoveOnDeath() return false end
function modifier_domination_helmet_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_domination_helmet_buff:GetTexture() return self.texture end

function modifier_domination_helmet_buff:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.armor_ignore = GetChaticEra_Artifact_Special("domination_helmet","armor_ignore")

    self:SetStackCount(self.armor_ignore)
  end
end

function modifier_domination_helmet_buff:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
  }
end



function modifier_domination_helmet_buff:Advanced_GetModifierAttackArmor_Ignore() 
  return self:GetStackCount() 
end



function modifier_domination_helmet_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_domination_helmet_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierAttackArmor_Ignore()
	end
end


