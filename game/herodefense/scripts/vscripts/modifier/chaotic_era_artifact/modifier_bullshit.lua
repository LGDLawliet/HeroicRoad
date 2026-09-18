LinkLuaModifier("modifier_bullshit_buff", "modifier/chaotic_era_artifact/modifier_bullshit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bullshit_debuff", "modifier/chaotic_era_artifact/modifier_bullshit", LUA_MODIFIER_MOTION_NONE)


modifier_bullshit = advanced_modifier({})

function modifier_bullshit:IsHidden()return true end
function modifier_bullshit:IsDebuff()return false end
function modifier_bullshit:IsPurgable()return false end
function modifier_bullshit:IsPurgeException() 	return false end
function modifier_bullshit:RemoveOnDeath() return false end
function modifier_bullshit:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_bullshit:GetTexture() return self.texture end
function modifier_bullshit:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", context )

end

function modifier_bullshit:OnCreated(keys)
  self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  self.value2 = GetChaticEra_Artifact_Special(self,"value2")
  self.value3 = GetChaticEra_Artifact_Special(self,"value3")
  self.value4 = GetChaticEra_Artifact_Special(self,"value4")
  self.value5 = GetChaticEra_Artifact_Special(self,"value5")
  if IsServer() then
    local gameEvent = {}
    gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#HUD_Bullshit_info"
    FireGameEvent( "dota_combat_event_message", gameEvent )
  end
end

function modifier_bullshit:ADDeclareFunctions()
  return 
  {
    MODIFIER_EVENT_ON_Chat={self:GetParent(),nil}, -- AdvancedOnChat


  }
end

function modifier_bullshit:AdvancedOnChat(keys)
  if keys.unit==self:GetParent() then
    

    local heroes = GetAllRealHeroes()
    local caster = self:GetParent()
    for _, unit in ipairs(heroes) do
      local modifier = unit:FindModifierByName("modifier_bullshit_buff")
      if modifier then
        -- 已经存在buff了则直接刷新
        modifier:ForceRefresh()
        modifier:OnRefresh()
      else
        if unit.GetPlayerOwnerID and caster.GetPlayerOwnerID  then
          if PlayerResource:IsDisableHelpSetForPlayerID(unit:GetPlayerOwnerID(),caster:GetPlayerOwnerID()) then
            goto continue
          end
          local modifier_debuff = unit:FindModifierByName("modifier_bullshit_debuff")
          if modifier_debuff and modifier_debuff:GetStackCount()>=self.value5 then
            goto continue
          end
          -- 添加buff
          unit:AddNewModifier(unit, nil, "modifier_bullshit_buff", {duration=self.value2})

          local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_POINT_FOLLOW, caster)
          ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
          ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
          ParticleManager:ReleaseParticleIndex(particle)
          caster:EmitSound("Hero_Beastmaster.Primal_Roar.ti7")
          
        end

      end
      ::continue::
     
    end

  end

end



modifier_bullshit_buff = advanced_modifier({})

function modifier_bullshit_buff:IsHidden()return false end
function modifier_bullshit_buff:IsDebuff()return false end
function modifier_bullshit_buff:IsPurgable()return false end
function modifier_bullshit_buff:IsPurgeException() 	return false end
function modifier_bullshit_buff:RemoveOnDeath() return false end
function modifier_bullshit_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_bullshit_buff:GetTexture() return "beastmaster_primal_roar" end
function modifier_bullshit_buff:OnCreated(params)
  self.value1 = GetChaticEra_Artifact_Special("bullshit","value1")
	if IsServer() then
    self.value3 = GetChaticEra_Artifact_Special("bullshit","value3")
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_bullshit_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= (self.value3) then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })
		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_bullshit_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_bullshit_buff:OnDestroy()
  if IsServer() then
    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_bullshit_debuff", {})

  end
end
function modifier_bullshit_buff:ADDeclareFunctions()
	local funcs = {
	}
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
  return funcs
end
function modifier_bullshit_buff:Advanced_GetModifierBonusStats_Strength()	
	return self.value1 * self:GetStackCount()
end
function modifier_bullshit_buff:Advanced_GetModifierBonusStats_Agility()	
	return self.value1 * self:GetStackCount()
end

function modifier_bullshit_buff:Advanced_GetModifierBonusStats_Intellect()	
	return self.value1 * self:GetStackCount()
end








modifier_bullshit_debuff = advanced_modifier({})

function modifier_bullshit_debuff:IsHidden()return false end
function modifier_bullshit_debuff:IsDebuff()return true end
function modifier_bullshit_debuff:IsPurgable()return false end
function modifier_bullshit_debuff:IsPurgeException() 	return false end
function modifier_bullshit_debuff:RemoveOnDeath() return false end
function modifier_bullshit_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_bullshit_debuff:GetTexture() return "magnataur/forgemaster_icons/magnataur_reverse_polarity" end
function modifier_bullshit_debuff:OnCreated(params)
  self.value4 = -GetChaticEra_Artifact_Special("bullshit","value4")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_bullshit_debuff:OnRefresh(params)
	if IsServer() then
    self:IncrementStackCount()
	end
end

function modifier_bullshit_debuff:ADDeclareFunctions()
	local funcs = {
	}
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
  return funcs
end
function modifier_bullshit_debuff:Advanced_GetModifierBonusStats_Strength()	
	return self.value4 * self:GetStackCount()
end
function modifier_bullshit_debuff:Advanced_GetModifierBonusStats_Agility()	
	return self.value4 * self:GetStackCount()
end

function modifier_bullshit_debuff:Advanced_GetModifierBonusStats_Intellect()	
	return self.value4 * self:GetStackCount()
end

