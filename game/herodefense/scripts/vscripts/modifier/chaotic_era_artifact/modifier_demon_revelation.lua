
modifier_demon_revelation = advanced_modifier({})

function modifier_demon_revelation:IsHidden()return false end
function modifier_demon_revelation:IsDebuff()return false end
function modifier_demon_revelation:IsPurgable()return false end
function modifier_demon_revelation:IsPurgeException() 	return false end
function modifier_demon_revelation:RemoveOnDeath() return false end
function modifier_demon_revelation:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_demon_revelation:DestroyOnExpire() return false end
function modifier_demon_revelation:GetTexture() return "terrorblade_conjure_image_alt1" end
function modifier_demon_revelation:OnCreated(keys)
  self.attribute_reduction = -GetChaticEra_Artifact_Special(self,"attribute_reduction")
  if IsServer() then
    local count = GetChaticEra_Artifact_Special(self,"count")
    for i=1, count do
      chaotic_era_shop:GenetateArtifactForPlayer(self:GetParent():GetPlayerOwnerID(),false)
    end
  end
end

function modifier_demon_revelation:ADDeclareFunctions()
	local funcs = {}
	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
  return funcs
end


function modifier_demon_revelation:Advanced_GetModifierBonusStats_Strength()	
	return self.attribute_reduction
end
function modifier_demon_revelation:Advanced_GetModifierBonusStats_Agility()	
	return self.attribute_reduction
end

function modifier_demon_revelation:Advanced_GetModifierBonusStats_Intellect()	
	return self.attribute_reduction
end

function modifier_demon_revelation:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_demon_revelation:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Strength()
	end
end
