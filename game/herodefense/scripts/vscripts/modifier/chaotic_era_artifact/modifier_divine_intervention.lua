
modifier_divine_intervention = advanced_modifier({})

function modifier_divine_intervention:IsHidden()return false end
function modifier_divine_intervention:IsDebuff()return false end
function modifier_divine_intervention:IsPurgable()return false end
function modifier_divine_intervention:IsPurgeException() 	return false end
function modifier_divine_intervention:RemoveOnDeath() return false end
function modifier_divine_intervention:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_divine_intervention:DestroyOnExpire() return false end
function modifier_divine_intervention:GetTexture() return "omni_knight/ti8_immortal_head/omniknight_repel_immortal" end




function modifier_divine_intervention:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  self.damage_reduction_active = -GetChaticEra_Artifact_Special(self,"damage_reduction_active")
  self.damage_reduction = -GetChaticEra_Artifact_Special(self,"damage_reduction")
  if IsServer() then
    self:SetDuration( GetChaticEra_Artifact_Special(self,"duration"), true)

    local parent = self:GetParent()
    parent:EmitSound("Hero_Omniknight.Purification.Wingfall")
    self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		self:AddParticle(self.particle, false, false, -1, false, false)
    self:StartIntervalThink(0.1)
    
  end
end

function modifier_divine_intervention:OnIntervalThink()
  if self:GetRemainingTime()<=0 then
    ParticleManager:DestroyParticle(self.particle, true)
    self:StartIntervalThink(-1)
  end
end


function modifier_divine_intervention:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  }
end


function modifier_divine_intervention:Advanced_GetModifierIncomingDamage_Percentage(keys)
  if self:GetRemainingTime()>0 then
    return self.damage_reduction_active
  end
  return self.damage_reduction
end


function modifier_divine_intervention:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_divine_intervention:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierIncomingDamage_Percentage()
	end
end
