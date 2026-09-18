


modifier_best_backup = advanced_modifier({})

function modifier_best_backup:IsHidden()return true end
function modifier_best_backup:IsDebuff()return false end
function modifier_best_backup:IsPurgable()return false end
function modifier_best_backup:IsPurgeException() 	return false end
function modifier_best_backup:RemoveOnDeath() return false end
function modifier_best_backup:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_best_backup:GetTexture() return self.texture end

function modifier_best_backup:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
   local heroess = GetAllRealHeroes()
   local accountID = {}
   local nPlayerID = self:GetParent():GetPlayerOwnerID()
   for _, unit in ipairs(heroess) do
    if unit:GetPlayerOwnerID()~=nPlayerID then
      table.insert(accountID,  tostring(PlayerResource:GetSteamAccountID(unit:GetPlayerOwnerID())))
    end
   end
   if #accountID>=1 then
    customDataManager:ModifySingleCustomData_Override_AndSendData(self:GetParent():GetPlayerOwnerID(),"artifact_best_backup",json.encode(accountID),nil)
    print("最佳后背 记录dota2ID 完成")
    local gameEvent = {}
    gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#HUD_best_backup_info"
    FireGameEvent( "dota_combat_event_message", gameEvent )
   end
  end
end


modifier_best_backup_bonus = advanced_modifier({})

function modifier_best_backup_bonus:IsHidden()return false end
function modifier_best_backup_bonus:IsDebuff()return false end
function modifier_best_backup_bonus:IsPurgable()return false end
function modifier_best_backup_bonus:IsPurgeException() 	return false end
function modifier_best_backup_bonus:RemoveOnDeath() return false end
function modifier_best_backup_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_best_backup_bonus:GetTexture() return "chaotic_era_spell/jull_happyhour" end
function modifier_best_backup_bonus:OnCreated(keys)
  self.bonus_attribute = GetChaticEra_Artifact_Special("best_backup","bonus_attribute")
  if IsServer() then
    local gameEvent = {}
    gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#HUD_best_backup_info2"
    FireGameEvent( "dota_combat_event_message", gameEvent )
  end
end

function modifier_best_backup_bonus:ADDeclareFunctions()
  return 
  {
    advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  }
end
function modifier_best_backup_bonus:Advanced_GetModifierBonusStats_Strength()	
return self.bonus_attribute
end
function modifier_best_backup_bonus:Advanced_GetModifierBonusStats_Agility()	
return self.bonus_attribute
end

function modifier_best_backup_bonus:Advanced_GetModifierBonusStats_Intellect()	
return self.bonus_attribute
end

function modifier_best_backup_bonus:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_TOOLTIP,
  }
end

function modifier_best_backup_bonus:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus_attribute 
	end
end

