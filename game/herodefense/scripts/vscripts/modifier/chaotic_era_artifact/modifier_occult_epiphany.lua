
modifier_occult_epiphany = advanced_modifier({})

function modifier_occult_epiphany:IsHidden()return true end
function modifier_occult_epiphany:IsDebuff()return false end
function modifier_occult_epiphany:IsPurgable()return false end
function modifier_occult_epiphany:IsPurgeException() 	return false end
function modifier_occult_epiphany:RemoveOnDeath() return false end
function modifier_occult_epiphany:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_occult_epiphany:GetTexture() return self.texture end

function modifier_occult_epiphany:OnCreated(keys)
  if IsServer() then
    self.value1 = GetChaticEra_Artifact_Special(self,"value1")
    self.value2 = GetChaticEra_Artifact_Special(self,"value2")
  end
end

function modifier_occult_epiphany:ADDeclareFunctions()
  return 
  {
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },

  }
end



function modifier_occult_epiphany:OnAbilityFullyCast(keys)
	if keys.unit ~= self:GetParent() then 
		return 
	end
	local mana_cast = keys.ability:GetManaCost(keys.ability:GetLevel())
	if mana_cast < 1 then
		return
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel())<self.value1 then
		return
	end
  keys.unit:GiveMana(self.value2)
  SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, keys.unit, self.value2, nil)
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, keys.unit)
  ParticleManager:SetParticleControlEnt(particle, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_attack1", keys.unit:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(particle, 1, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(particle, 1, keys.unit:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle) 
end