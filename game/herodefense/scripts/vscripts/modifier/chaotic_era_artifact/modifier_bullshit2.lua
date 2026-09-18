LinkLuaModifier("modifier_bullshit2_target_debuff", "modifier/chaotic_era_artifact/modifier_bullshit2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bullshit2_debuff", "modifier/chaotic_era_artifact/modifier_bullshit2", LUA_MODIFIER_MOTION_NONE)


modifier_bullshit2 = advanced_modifier({})

function modifier_bullshit2:IsHidden()return false end
function modifier_bullshit2:IsDebuff()return false end
function modifier_bullshit2:IsPurgable()return false end
function modifier_bullshit2:IsPurgeException() 	return false end
function modifier_bullshit2:RemoveOnDeath() return false end
function modifier_bullshit2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_bullshit2:GetTexture() return self.texture end
function modifier_bullshit2:GetTexture() return "magnataur/forgemaster_icons/magnataur_reverse_polarity" end
function modifier_bullshit2:DestroyOnExpire() return false end
function modifier_bullshit2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", context )

end

function modifier_bullshit2:OnCreated(keys)
  self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  self.value2 = GetChaticEra_Artifact_Special(self,"value2")
  self.value3 = GetChaticEra_Artifact_Special(self,"value3")
  self.value4 = GetChaticEra_Artifact_Special(self,"value4")
  self.value5 = GetChaticEra_Artifact_Special(self,"value5")
  self.value6 = GetChaticEra_Artifact_Special(self,"value6")
  if IsServer() then
    local gameEvent = {}
    gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#HUD_Bullshit2_info"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    self:SetDuration(self.value4,true)
    self:StartIntervalThink(0.1)
  end
end
function modifier_bullshit2:OnIntervalThink()
  if self:GetRemainingTime()<=0 then
    self:SetDuration(self.value4,true)
    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_bullshit2_debuff", {})

    local gameEvent = {}
    gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#HUD_Bullshit2_info2"
    FireGameEvent( "dota_combat_event_message", gameEvent )
  end
end

function modifier_bullshit2:ADDeclareFunctions()
  return 
  {
    MODIFIER_EVENT_ON_Chat={self:GetParent(),nil}, -- AdvancedOnChat


  }
end

function modifier_bullshit2:AdvancedOnChat(keys)
  if keys.unit==self:GetParent() then
    

    -- local heroes = GetAllRealHeroes()
    local caster = self:GetParent()
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.value6, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    self:SetDuration(self.value4,true)
    for _, unit in ipairs(units) do
      local modifier = unit:FindModifierByName("modifier_bullshit2_target_debuff")
      if modifier then
        -- 已经存在buff了则直接刷新
        modifier:ForceRefresh()
        modifier:OnRefresh()
      else
    
        -- 添加buff
        unit:AddNewModifier(unit, nil, "modifier_bullshit2_target_debuff", {duration=self.value2})
      end
      ::continue::
    end

  end

end



modifier_bullshit2_target_debuff = advanced_modifier({})

function modifier_bullshit2_target_debuff:IsHidden()return false end
function modifier_bullshit2_target_debuff:IsDebuff()return false end
function modifier_bullshit2_target_debuff:IsPurgable()return false end
function modifier_bullshit2_target_debuff:IsPurgeException() 	return false end
function modifier_bullshit2_target_debuff:RemoveOnDeath() return false end
function modifier_bullshit2_target_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_bullshit2_target_debuff:GetTexture() return "magnataur/forgemaster_icons/magnataur_reverse_polarity" end
function modifier_bullshit2_target_debuff:OnCreated(params)
  self.value1 = GetChaticEra_Artifact_Special("bullshit2","value1")
	if IsServer() then
    self.value3 = GetChaticEra_Artifact_Special("bullshit2","value3")
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_bullshit2_target_debuff:OnRefresh(params)
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

function modifier_bullshit2_target_debuff:OnIntervalThink()
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


function modifier_bullshit2_target_debuff:ADDeclareFunctions()
	local funcs = {
	}
  table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)-- 最终全伤害提升
  return funcs
end
function modifier_bullshit2_target_debuff:Advanced_GetModifierIncomingDamage_Percentage()	
	return self.value1 * self:GetStackCount()
end






modifier_bullshit2_debuff = advanced_modifier({})

function modifier_bullshit2_debuff:IsHidden()return false end
function modifier_bullshit2_debuff:IsDebuff()return true end
function modifier_bullshit2_debuff:IsPurgable()return false end
function modifier_bullshit2_debuff:IsPurgeException() 	return false end
function modifier_bullshit2_debuff:RemoveOnDeath() return false end
function modifier_bullshit2_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_bullshit2_debuff:GetTexture() return "magnataur/forgemaster_icons/magnataur_reverse_polarity" end
function modifier_bullshit2_debuff:OnCreated(params)
  self.value5 = -GetChaticEra_Artifact_Special("bullshit2","value5")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_bullshit2_debuff:OnRefresh(params)
	if IsServer() then
    self:IncrementStackCount()
	end
end

function modifier_bullshit2_debuff:ADDeclareFunctions()
	local funcs = {
	}
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
  return funcs
end
function modifier_bullshit2_debuff:Advanced_GetModifierBonusStats_Strength()	
	return self.value5 * self:GetStackCount()
end
function modifier_bullshit2_debuff:Advanced_GetModifierBonusStats_Agility()	
	return self.value5 * self:GetStackCount()
end

function modifier_bullshit2_debuff:Advanced_GetModifierBonusStats_Intellect()	
	return self.value5 * self:GetStackCount()
end

