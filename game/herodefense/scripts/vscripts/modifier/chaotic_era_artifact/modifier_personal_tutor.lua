


modifier_personal_tutor = advanced_modifier({})

function modifier_personal_tutor:IsHidden()return false end
function modifier_personal_tutor:IsDebuff()return false end
function modifier_personal_tutor:IsPurgable()return false end
function modifier_personal_tutor:IsPurgeException() 	return false end
function modifier_personal_tutor:RemoveOnDeath() return false end
function modifier_personal_tutor:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_personal_tutor:GetTexture() return "chaotic_era_spell/personal_tutor" end

function modifier_personal_tutor:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  self.bonus_rune= GetChaticEra_Artifact_Special(self,"bonus_rune")
  if IsServer() then
    if keys.stack then
      self:SetStackCount(keys.stack)
      local gameEvent = {}
      gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
      gameEvent["teamnumber"] = -1
      gameEvent["message"] = "#HUD_personal_tutor_info2"
      FireGameEvent( "dota_combat_event_message", gameEvent )
    else
      self:InitEffect()
    end
  end
end

function modifier_personal_tutor:OnRefresh(keys)
  if IsServer() then
    self:InitEffect()
  end
end

function modifier_personal_tutor:InitEffect()
  local stack = GetChaticEra_Artifact_Special(self,"count")
  self:SetStackCount(stack)
  local heroess = GetAllRealHeroes()
  local accountID = {}
  local nPlayerID = self:GetParent():GetPlayerOwnerID()
  for _, unit in ipairs(heroess) do
    if unit:GetPlayerOwnerID()~=nPlayerID then
      table.insert(accountID,  tostring(PlayerResource:GetSteamAccountID(nPlayerID)))
    end
  end
  if #accountID>=1 then
    local target = accountID[RandomInt(1, #accountID)]
    customDataManager:ModifySingleCustomData_Override_AndSendData(self:GetParent():GetPlayerOwnerID(),"personal_tutor",json.encode(target),stack)
    print("个人导师 记录dota2ID 完成")
    local gameEvent = {}
    gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
    gameEvent["player_name2"] = self:GetParent():GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#HUD_personal_tutor_info"
    FireGameEvent( "dota_combat_event_message", gameEvent )
  end
end


function modifier_personal_tutor:ADDeclareFunctions()
  return 
  {
  advanced_MODIFIER_PROPERTY_Chaotic_Era_RunePorgressBonus,
  }
end


function modifier_personal_tutor:Advanced_GetChaotic_Era_RunePorgressBonus()
  return self.bonus_rune
end

function modifier_personal_tutor:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_TOOLTIP,
  }
end

function modifier_personal_tutor:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus_rune 
	end
end


