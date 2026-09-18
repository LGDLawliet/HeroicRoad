
modifier_payday = advanced_modifier({})

function modifier_payday:IsHidden()return true end
function modifier_payday:IsDebuff()return false end
function modifier_payday:IsPurgable()return false end
function modifier_payday:IsPurgeException() 	return false end
function modifier_payday:RemoveOnDeath() return false end
function modifier_payday:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_payday:DestroyOnExpire() return false end
function modifier_payday:GetTexture() return "chaotic_era_spell/aghanims_sanctum" end
function modifier_payday:OnCreated(keys)

  if IsServer() then
    local bonus = GetChaticEra_Artifact_Special(self,"bonus")-1
    local gold = math.floor(self:GetParent():GetGold()*bonus)
    chaotic_era_spawner:PlayerGetGoldBounty(self:GetParent(),gold,nil)
    SendOverheadEventMessage( PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD  ,self:GetParent(), gold, nil)
    self:Destroy()
  end
end

