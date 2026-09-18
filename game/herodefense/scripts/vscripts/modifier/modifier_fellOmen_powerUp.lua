bonusTable = {
    0.5,
    0.6,
    0.7,
    0.85,
    1,
    1,
    1,
    1,
}
modifier_fellOmen_powerUp = modifier_fellOmen_powerUp or advanced_modifier({})

function modifier_fellOmen_powerUp:IsDebuff() return false end
function modifier_fellOmen_powerUp:IsHidden() return true end
function modifier_fellOmen_powerUp:IsPurgable() return false end
function modifier_fellOmen_powerUp:IsPurgeException() return false end
function modifier_fellOmen_powerUp:RemoveOnDeath() return false end
function modifier_fellOmen_powerUp:OnCreated(keys)

    local NetTable_key = "fellOmenPlayerNumber"
    local playerCount = CustomNetTables:GetTableValue( "common", NetTable_key).value
    --根据人数进行削减
    self.bonus_index = bonusTable[playerCount] or 0

    if IsServer() then
        self:SetStackCount(_G.GAME_Reincarnation_Wave)
    end

end

--
function modifier_fellOmen_powerUp:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,                 
	}
end



function modifier_fellOmen_powerUp:AdvancedGetModifierExtraHealthPercentage()	return self:GetStackCount()*5*self.bonus_index end
function modifier_fellOmen_powerUp:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount()*5*self.bonus_index end



function modifier_fellOmen_powerUp:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end
