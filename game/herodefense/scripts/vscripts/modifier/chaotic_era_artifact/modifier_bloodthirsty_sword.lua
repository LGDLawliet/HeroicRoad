
modifier_bloodthirsty_sword = advanced_modifier({})

function modifier_bloodthirsty_sword:IsHidden()return false end
function modifier_bloodthirsty_sword:IsDebuff()return false end
function modifier_bloodthirsty_sword:IsPurgable()return false end
function modifier_bloodthirsty_sword:IsPurgeException() 	return false end
function modifier_bloodthirsty_sword:RemoveOnDeath() return false end
function modifier_bloodthirsty_sword:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_bloodthirsty_sword:DestroyOnExpire() return false end
function modifier_bloodthirsty_sword:GetTexture() return "chaotic_era_spell/bloodthirsty_sword" end
function modifier_bloodthirsty_sword:OnCreated(keys)
  self.bonus_attribute = GetChaticEra_Artifact_Special(self,"bonus_attribute")
  self.bonus_max = GetChaticEra_Artifact_Special(self,"bonus_max")
  self.current_bonus = 0
  if IsServer() then
	self:SetHasCustomTransmitterData( true )
  end
end

function modifier_bloodthirsty_sword:ADDeclareFunctions()
	local funcs = {}
	table.insert(funcs,advanced_MODIFIER_PROPERTY_LifeSteal_Disable)
	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
	funcs["MODIFIER_EVENT_ON_DEATH"] = {self:GetParent(), nil}
  	return funcs
end
function modifier_bloodthirsty_sword:Advanced_GetModifier_LifeSteal_Disable()	
	if self.current_bonus>=self.bonus_max then
		return 0
	end
	return 1
end

function modifier_bloodthirsty_sword:Advanced_GetModifierBonusStats_Strength()	
	return self.current_bonus
end
function modifier_bloodthirsty_sword:Advanced_GetModifierBonusStats_Agility()	
	return self.current_bonus
end

function modifier_bloodthirsty_sword:Advanced_GetModifierBonusStats_Intellect()	
	return self.current_bonus
end
function modifier_bloodthirsty_sword:AddCustomTransmitterData()
	return
	{
		current_bonus = self.current_bonus,
	}
end
function modifier_bloodthirsty_sword:HandleCustomTransmitterData(data)
	self.current_bonus = data.current_bonus
end




function modifier_bloodthirsty_sword:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_bloodthirsty_sword:OnDeath(keys)
	if IsServer() then
		if self.current_bonus>=self.bonus_max then
			return 
		end
		local unit = keys.unit
		local attacker = keys.attacker
		if IsEnemy(unit,attacker) then
			self.current_bonus =  math.min(self.bonus_max,self.current_bonus+self.bonus_attribute)
			self:SendBuffRefreshToClients()
		end
	end
end


function modifier_bloodthirsty_sword:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Strength()
	end
end
