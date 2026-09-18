
modifier_gift_of_the_grand_mage = advanced_modifier({})

function modifier_gift_of_the_grand_mage:IsHidden()return false end
function modifier_gift_of_the_grand_mage:IsDebuff()return false end
function modifier_gift_of_the_grand_mage:IsPurgable()return false end
function modifier_gift_of_the_grand_mage:IsPurgeException() 	return false end
function modifier_gift_of_the_grand_mage:RemoveOnDeath() return false end
function modifier_gift_of_the_grand_mage:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_gift_of_the_grand_mage:GetTexture() return self.texture end

function modifier_gift_of_the_grand_mage:OnCreated(keys)
  -- self.rune_level3 = GetChaticEra_Artifact_Special(self,"rune_level3")
  if IsServer() then
    local parent = self:GetParent()
    local count = GetChaticEra_Artifact_Special(self,"count")
    for i = 1, count, 1 do
      parent:AddItemByName("item_hd_rubick_cube")
      parent:AddItemByName("item_hd_rubick_cube2")
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
      gameEvent["locstring_value"] = "#gift_of_the_grand_mage"
      gameEvent["message"] = "#GetRune_info3"
      FireGameEvent( "dota_combat_event_message", gameEvent )
    elseif rune_level4>=RandomInt(1, 10000) then
      local gameEvent = {}
      gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
      gameEvent["teamnumber"] = -1
      gameEvent["message"] = "#GetRune_info2"
      gameEvent["locstring_value"] = "#gift_of_the_grand_mage"
      FireGameEvent( "dota_combat_event_message", gameEvent )
      level = 4
    elseif rune_level3>=RandomInt(1, 10000) then
      local gameEvent = {}
      gameEvent["player_id"] = self:GetParent():GetPlayerOwnerID()
      gameEvent["teamnumber"] = -1
      gameEvent["message"] = "#GetRune_info1"
      gameEvent["locstring_value"] = "#gift_of_the_grand_mage"
      FireGameEvent( "dota_combat_event_message", gameEvent )
      level = 3
    end
    if level~=-1 then
      chaotic_era_spawner:AddRuneCount(level)
    end

    self:Destroy()
 

  end
end
