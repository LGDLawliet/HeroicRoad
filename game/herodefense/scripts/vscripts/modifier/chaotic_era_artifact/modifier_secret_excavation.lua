
modifier_secret_excavation = advanced_modifier({})

function modifier_secret_excavation:IsHidden()return false end
function modifier_secret_excavation:IsDebuff()return false end
function modifier_secret_excavation:IsPurgable()return false end
function modifier_secret_excavation:IsPurgeException() 	return false end
function modifier_secret_excavation:RemoveOnDeath() return false end
function modifier_secret_excavation:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_secret_excavation:GetTexture() return self.texture end

function modifier_secret_excavation:OnCreated(keys)
  -- self.rune_level3 = GetChaticEra_Artifact_Special(self,"rune_level3")
  if IsServer() then
    local parent = self:GetParent()
    local coreID = RandomInt(1, 3)
    if coreID== 1 then
      parent:AddItemByName("item_hd_the_first_core")
    elseif coreID== 2 then
      parent:AddItemByName("item_hd_the_second_core")
    else
      parent:AddItemByName("item_hd_the_third_core")
    end
    local rune_level3 = GetChaticEra_Artifact_Special(self,"rune_level3")*100
    local rune_level4 = GetChaticEra_Artifact_Special(self,"rune_level4")*100
    local rune_level5 = GetChaticEra_Artifact_Special(self,"rune_level5")*100

    local level = -1
    if rune_level5>=RandomInt(1, 10000) then
      level = 5
      local gameEvent = {}
      gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
      gameEvent["teamnumber"] = -1
      gameEvent["locstring_value"] = "#secret_excavation"
      gameEvent["message"] = "#GetRune_info3"
      FireGameEvent( "dota_combat_event_message", gameEvent )
    elseif rune_level4>=RandomInt(1, 10000) then
      local gameEvent = {}
      gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
      gameEvent["teamnumber"] = -1
      gameEvent["message"] = "#GetRune_info2"
      gameEvent["locstring_value"] = "#secret_excavation"
      FireGameEvent( "dota_combat_event_message", gameEvent )
      level = 4
    elseif rune_level3>=RandomInt(1, 10000) then
      local gameEvent = {}
      gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
      gameEvent["teamnumber"] = -1
      gameEvent["message"] = "#GetRune_info1"
      gameEvent["locstring_value"] = "#secret_excavation"
      FireGameEvent( "dota_combat_event_message", gameEvent )
      level = 3
    end
    if level~=-1 then
      chaotic_era_spawner:AddRuneCount(level)
    end

    self:Destroy()
 

  end
end
