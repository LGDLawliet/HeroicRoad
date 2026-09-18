
modifier_excessive_consumption = advanced_modifier({})

function modifier_excessive_consumption:IsHidden()return false end
function modifier_excessive_consumption:IsDebuff()return false end
function modifier_excessive_consumption:IsPurgable()return false end
function modifier_excessive_consumption:IsPurgeException() 	return false end
function modifier_excessive_consumption:RemoveOnDeath() return false end
function modifier_excessive_consumption:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_excessive_consumption:DestroyOnExpire() return false end
-- function modifier_excessive_consumption:GetTexture() return "chaotic_era_spell/bloodthirsty_sword" end
function modifier_excessive_consumption:OnCreated(keys)

  if IsServer() then
	self.bonus_gold = GetChaticEra_Artifact_Special(self,"bonus_gold")
	local parent = self:GetParent()
	local rate = GetChaticEra_Artifact_Special(self,"gold_rate")*0.01*self.bonus_gold
	chaotic_era_spawner:PlayerGetGoldBounty(parent,self.bonus_gold,nil)
	SendOverheadEventMessage( PlayerResource:GetPlayer(parent:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD  ,self:GetParent(), self.bonus_gold, nil)

	customDataManager:ModifySingleCustomData_AndSendData( parent:GetPlayerOwnerID(),"excessive_consumption_value",rate,nil) 
	self:Destroy()
  end
end




modifier_excessive_consumption_debuff = advanced_modifier({})

function modifier_excessive_consumption_debuff:IsHidden()return false end
function modifier_excessive_consumption_debuff:IsDebuff()return true end
function modifier_excessive_consumption_debuff:IsPurgable()return false end
function modifier_excessive_consumption_debuff:IsPurgeException() 	return false end
function modifier_excessive_consumption_debuff:RemoveOnDeath() return false end
function modifier_excessive_consumption_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_excessive_consumption_debuff:DestroyOnExpire() return false end
function modifier_excessive_consumption_debuff:GetTexture() return "chaotic_era_spell/excessive_consumption" end
function modifier_excessive_consumption_debuff:OnCreated(keys)

  if IsServer() then
	self:SetStackCount(keys.stack)
	self.gold_reduction = GetChaticEra_Artifact_Special("excessive_consumption","gold_reduction")*0.01
	self:StartIntervalThink(GetChaticEra_Artifact_Special("excessive_consumption","interval"))
  end
end
function modifier_excessive_consumption_debuff:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetGold() >= 100 then
		local reduction = parent:GetGold()*self.gold_reduction
		reduction = math.min(self:GetStackCount(),reduction)
		parent:ModifyGoldFiltered(-reduction,true,DOTA_ModifyGold_AbilityCost)

		customDataManager:ModifySingleCustomData(tostring(PlayerResource:GetSteamID( parent:GetPlayerOwnerID())),"excessive_consumption_value",-reduction,nil) 


		self:SetStackCount(self:GetStackCount()-reduction)
		if self:GetStackCount()<=0 then
			self:Destroy()
		end
	end
end
