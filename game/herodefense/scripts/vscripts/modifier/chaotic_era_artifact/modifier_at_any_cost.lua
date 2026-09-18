
modifier_at_any_cost = advanced_modifier({})

function modifier_at_any_cost:IsHidden()return true end
function modifier_at_any_cost:IsDebuff()return false end
function modifier_at_any_cost:IsPurgable()return false end
function modifier_at_any_cost:IsPurgeException() 	return false end
function modifier_at_any_cost:RemoveOnDeath() return false end
function modifier_at_any_cost:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_at_any_cost:GetTexture() return "lina_flame_cloak" end
function modifier_at_any_cost:DestroyOnExpire() return false end


function modifier_at_any_cost:OnCreated(keys)
  -- self.bonus_move =  GetChaticEra_Artifact_Special(self,"bonus_move")
  self.bonus_incoming_damage = GetChaticEra_Artifact_Special(self,"bonus_incoming_damage")
  self.bonus_flame_damage = GetChaticEra_Artifact_Special(self,"bonus_flame_damage")
end

function modifier_at_any_cost:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,

  }
end



function modifier_at_any_cost:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if IsServer() then
    if DamageFilter(keys.record,HD_DAMAGE_FLAG_FIRE_DAMAGE) then
      return self.bonus_flame_damage
    end
	end
	return 0
end
function modifier_at_any_cost:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return self.bonus_incoming_damage
end
-- function modifier_at_any_cost:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOOLTIP,
-- 	}
-- end


-- function modifier_at_any_cost:OnTooltip()
-- 	self._tooltip = (self._tooltip or 0) % 1 + 1
-- 	if self._tooltip == 1 then
-- 		return self.bonus_damage*self:GetStackCount()
-- 	end
-- end



