
modifier_arcane_mark = advanced_modifier({})

function modifier_arcane_mark:IsHidden()return true end
function modifier_arcane_mark:IsDebuff()return false end
function modifier_arcane_mark:IsPurgable()return false end
function modifier_arcane_mark:IsPurgeException() 	return false end
function modifier_arcane_mark:RemoveOnDeath() return false end
function modifier_arcane_mark:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_arcane_mark:GetTexture() return self.texture end

function modifier_arcane_mark:OnCreated(keys)
  self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  -- if IsServer() then
  --   self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  --   -- self.value2 = GetChaticEra_Artifact_Special(self,"value2")
  -- end
end

function modifier_arcane_mark:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN,  

  }
end

function modifier_arcane_mark:Advanced_GetModifier_ChaoticSpellEffectGain(keys)

	if keys.ability then
		if keys.ability:GetChaoticSpellType()=="HUD_Evocation_spell" then
			return self.value1
		end
	end
	return 0
end

