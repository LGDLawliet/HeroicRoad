
modifier_the_omexe_arena = advanced_modifier({})

function modifier_the_omexe_arena:IsHidden()return false end
function modifier_the_omexe_arena:IsDebuff()return false end
function modifier_the_omexe_arena:IsPurgable()return false end
function modifier_the_omexe_arena:IsPurgeException() 	return false end
function modifier_the_omexe_arena:RemoveOnDeath() return false end
function modifier_the_omexe_arena:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_the_omexe_arena:DestroyOnExpire() return false end
function modifier_the_omexe_arena:GetTexture() return "chaotic_era_spell/the_omexe_arena" end
function modifier_the_omexe_arena:OnCreated(keys)
  self.bonus_attribute = GetChaticEra_Artifact_Special(self,"bonus_attribute")
  if IsServer() then
    local interval = GetChaticEra_Artifact_Special(self,"interval")
	self:StartIntervalThink(interval)
  end
end
function modifier_the_omexe_arena:OnIntervalThink()
	if Game_State:IsInBattle() then
		self:IncrementStackCount()
	end
	
end
function modifier_the_omexe_arena:ADDeclareFunctions()
  	local funcs = {}
  	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
	table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
	funcs["MODIFIER_EVENT_ON_DEATH"] = {nil, self:GetParent()}
  	return funcs
end


function modifier_the_omexe_arena:Advanced_GetModifierBonusStats_Strength()	
	return self.bonus_attribute * self:GetStackCount()
end
function modifier_the_omexe_arena:Advanced_GetModifierBonusStats_Agility()	
	return self.bonus_attribute* self:GetStackCount()
end

function modifier_the_omexe_arena:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus_attribute* self:GetStackCount()
end

function modifier_the_omexe_arena:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_the_omexe_arena:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Strength()
	end
end



function modifier_the_omexe_arena:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker
		if unit==self:GetParent() then
			self:SetStackCount(0)
		end
	end
end