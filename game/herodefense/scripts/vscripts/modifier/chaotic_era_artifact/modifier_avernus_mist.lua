LinkLuaModifier("modifier_avernus_mist_shield", "modifier/chaotic_era_artifact/modifier_avernus_mist", LUA_MODIFIER_MOTION_NONE)

modifier_avernus_mist = advanced_modifier({})

function modifier_avernus_mist:IsHidden()return true end
function modifier_avernus_mist:IsDebuff()return false end
function modifier_avernus_mist:IsPurgable()return false end
function modifier_avernus_mist:IsPurgeException() 	return false end
function modifier_avernus_mist:RemoveOnDeath() return false end
function modifier_avernus_mist:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_avernus_mist:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/artifact/avernus_mist/effect_shield/effect.vpcf", context )

end








function modifier_avernus_mist:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.shield_index = GetChaticEra_Artifact_Special(self,"shield_index")*0.01
    -- self.bonus_damage = GetChaticEra_Artifact_Special(self,"bonus_damage")
  end
end



function modifier_avernus_mist:ADDeclareFunctions()
  return 
  {
    MODIFIER_EVENT_ON_Wave_Start = {},
    advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
  }
end


function modifier_avernus_mist:OnWaveStart(table)
	local heroes = GetAllRealHeroes()
  local parent = self:GetParent()
  local stack = parent:GetMaxHealth()*self.shield_index
  for _, unit in ipairs(heroes) do
    unit:AddNewModifier(parent, nil, "modifier_avernus_mist_shield", {stack=stack})

  end
end



modifier_avernus_mist_shield = advanced_modifier({})

function modifier_avernus_mist_shield:IsHidden()return true end
function modifier_avernus_mist_shield:IsDebuff()return false end
function modifier_avernus_mist_shield:IsPurgable()return false end
function modifier_avernus_mist_shield:IsPurgeException() 	return false end
function modifier_avernus_mist_shield:RemoveOnDeath() return false end
function modifier_avernus_mist_shield:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_avernus_mist_shield:GetTexture() return "sven/cyclopean_marauder_ability_icons/sven_gods_strength" end
function modifier_avernus_mist_shield:OnCreated(keys)
  if IsServer() then
    self:SetStackCount(keys.stack)
    local parent = self:GetParent()
    EmitSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
		EmitSoundOn("Hero_Abaddon.AphoticShield.Cast", parent)

		local particle_name = "particles/rebuild/artifact/avernus_mist/effect_shield/effect.vpcf"
		local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		local ex = parent:GetModelScale() * 100
		ParticleManager:SetParticleControl(pfx, 1, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 2, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 4, Vector(ex,ex,ex))
		self:AddParticle(pfx, false, false, 15, false, false)

  end
end
function modifier_avernus_mist_shield:OnRefresh(keys)
  if IsServer() then
    self:SetStackCount(keys.stack)
  end
end



function modifier_avernus_mist_shield:OnDestroy()

	if IsServer() then
		-- local ability = self:GetAbility()
		local parent = self:GetParent()
		StopSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
		EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", parent)
	end
end


function modifier_avernus_mist_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_avernus_mist_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end
  if keys.damage >  stack then
    self:SetStackCount(0)
  else
    self:SetStackCount(stack- math.max(0, keys.damage))
    stack=keys.damage
  end
  
	


	return stack
end
