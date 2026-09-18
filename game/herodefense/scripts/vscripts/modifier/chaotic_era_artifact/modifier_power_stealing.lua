LinkLuaModifier("modifier_power_stealing_buff", "modifier/chaotic_era_artifact/modifier_power_stealing", LUA_MODIFIER_MOTION_NONE)

modifier_power_stealing = advanced_modifier({})

function modifier_power_stealing:IsHidden()return true end
function modifier_power_stealing:IsDebuff()return false end
function modifier_power_stealing:IsPurgable()return false end
function modifier_power_stealing:IsPurgeException() 	return false end
function modifier_power_stealing:RemoveOnDeath() return false end
function modifier_power_stealing:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_power_stealing:DestroyOnExpire() return false end
-- function modifier_power_stealing:GetTexture() return "omni_knight/ti8_immortal_head/omniknight_repel_immortal" end




function modifier_power_stealing:OnCreated(keys)
  if IsServer() then
    self.bonus_damage = GetChaticEra_Artifact_Special(self,"bonus_damage")*0.01
    self.reduction_max = GetChaticEra_Artifact_Special(self,"reduction_max")*0.01
    self.bonus_rate = GetChaticEra_Artifact_Special(self,"bonus_rate")*0.01
    self.duration = GetChaticEra_Artifact_Special(self,"duration")
  end
end

function modifier_power_stealing:OnIntervalThink()
  if self:GetRemainingTime()<=0 then
    ParticleManager:DestroyParticle(self.particle, true)
    self:StartIntervalThink(-1)
  end
end



function modifier_power_stealing:ADDeclareFunctions()
  return 
  {
    MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData,
  }
end
-- [MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData] = "AdvancedModifyChaoticEraSpwnData",



function modifier_power_stealing:AdvancedModifyChaoticEraSpwnData(attribute,unit)
	local parent = self:GetParent()
	local  damage_reduction = math.min(self.bonus_damage*parent:GetAverageTrueAttackDamage(nil),self.reduction_max*parent:GetDamageMax())
	attribute.attackDamage = math.max(attribute.attackDamage - damage_reduction,1)
	local gain = self:GetParent():GetModifierDurationGainIndex(1)
	parent:AddNewModifier(parent, nil, "modifier_power_stealing_buff", {duration=self.duration*gain,stack_time=self.duration*gain,bonus_damage=math.floor(damage_reduction*self.bonus_rate)})

  
  return 0
end









modifier_power_stealing_buff = advanced_modifier({})

function modifier_power_stealing_buff:IsHidden()return false end
function modifier_power_stealing_buff:IsDebuff()return false end
function modifier_power_stealing_buff:IsPurgable()return false end
function modifier_power_stealing_buff:IsPurgeException() 	return false end
function modifier_power_stealing_buff:RemoveOnDeath() return false end
function modifier_power_stealing_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_power_stealing_buff:GetTexture() return "vengefulspirit_wave_of_terror" end

function modifier_power_stealing_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { 
      dieTime = self:GetDieTime(),
      stack = keys.bonus_damage,
    })
		self:SetStackCount(self:GetStackCount()+keys.bonus_damage)
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_power_stealing_buff:OnRefresh(keys)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+keys.stack_time

    table.insert(self.tData, { 
      dieTime =dieTime,
      stack = keys.bonus_damage,
    })
		self:SetStackCount(self:GetStackCount()+keys.bonus_damage)
	end
end

function modifier_power_stealing_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
        self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end



function modifier_power_stealing_buff:ADDeclareFunctions()
	local funcs = {
	}
  table.insert(funcs,advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE)
  return funcs
end
function modifier_power_stealing_buff:Advanced_GetModifierPreAttack_BonusDamage()	
	return self:GetStackCount()
end


function modifier_power_stealing_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_power_stealing_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPreAttack_BonusDamage()
	end
end
