
modifier_super_ice = advanced_modifier({})

function modifier_super_ice:IsHidden()return true end
function modifier_super_ice:IsDebuff()return false end
function modifier_super_ice:IsPurgable()return false end
function modifier_super_ice:IsPurgeException() 	return false end
function modifier_super_ice:RemoveOnDeath() return false end
function modifier_super_ice:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_super_ice:DestroyOnExpire() return false end

function modifier_super_ice:OnCreated(keys)
  if IsServer() then
    self.ice_outgoing = GetChaticEra_Artifact_Special(self,"ice_outgoing")
    self.line = GetChaticEra_Artifact_Special(self,"line")
    self.ice_outgoing_plus = GetChaticEra_Artifact_Special(self,"ice_outgoing_plus")
  end
end

function modifier_super_ice:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end
function modifier_super_ice:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = self:GetCaster()
	local target = keys.target
	if IsIceDamage(keys) then
        if target:GetMoveSpeedModifier(target:GetBaseMoveSpeed(), false) < self.line then
            return self.ice_outgoing_plus
        end
        return self.ice_outgoing
	end
end