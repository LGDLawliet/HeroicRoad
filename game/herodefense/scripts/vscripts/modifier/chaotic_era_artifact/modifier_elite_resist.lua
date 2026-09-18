
modifier_elite_resist = advanced_modifier({})

function modifier_elite_resist:IsHidden()return true end
function modifier_elite_resist:IsDebuff()return false end
function modifier_elite_resist:IsPurgable()return false end
function modifier_elite_resist:IsPurgeException() 	return false end
function modifier_elite_resist:RemoveOnDeath() return false end
function modifier_elite_resist:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_elite_resist:DestroyOnExpire() return false end

function modifier_elite_resist:OnCreated(keys)
  if IsServer() then
    self.incoming = GetChaticEra_Artifact_Special(self,"incoming")
    self.attack = GetChaticEra_Artifact_Special(self,"attack")
    self.duration = GetChaticEra_Artifact_Special(self,"duration")
  end
end

function modifier_elite_resist:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_elite_resist:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if attacker:IsChaoticEraElite() then
        self:SetDuration(self.duration, true)
        return  -self.incoming
	end
end
function modifier_elite_resist:Advanced_GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	if self:GetRemainingTime() >= 0 then
       return self.attack 
    end
    return 
end