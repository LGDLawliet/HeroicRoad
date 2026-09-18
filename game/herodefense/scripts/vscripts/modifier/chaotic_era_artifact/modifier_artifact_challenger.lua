
modifier_artifact_challenger = advanced_modifier({})

function modifier_artifact_challenger:IsHidden()return true end
function modifier_artifact_challenger:IsDebuff()return false end
function modifier_artifact_challenger:IsPurgable()return false end
function modifier_artifact_challenger:IsPurgeException() 	return false end
function modifier_artifact_challenger:RemoveOnDeath() return false end
function modifier_artifact_challenger:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_artifact_challenger:DestroyOnExpire() return false end
-- function modifier_artifact_challenger:GetTexture() return "chaotic_era_spell/the_omexe_arena" end
function modifier_artifact_challenger:OnCreated(keys)
  if IsServer() then
    self.bonus_damage = GetChaticEra_Artifact_Special(self,"bonus_damage")
  	self.damage_reduction = -GetChaticEra_Artifact_Special(self,"damage_reduction")
  end
end

function modifier_artifact_challenger:ADDeclareFunctions()
  	local funcs = {}
  	table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL)
  	return funcs
end

function modifier_artifact_challenger:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)	
	if keys.target then
		if keys.target:IsChaoticEraElite() or keys.target:IsChaoticEraBoss() then
			return  self.bonus_damage
		end
		return  self.damage_reduction
	end
	return 0
end


-- function modifier_artifact_challenger:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOOLTIP,
-- 	}
-- end


-- function modifier_artifact_challenger:OnTooltip()
-- 	self._tooltip = (self._tooltip or 0) % 1 + 1
-- 	if self._tooltip == 1 then
-- 		return  self:Advanced_GetModifierBonusStats_Strength()
-- 	end
-- end



