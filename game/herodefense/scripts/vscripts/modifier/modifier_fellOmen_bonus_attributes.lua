
modifier_fellOmen_bonus_attributes = advanced_modifier({})
function modifier_fellOmen_bonus_attributes:IsHidden()return false end
function modifier_fellOmen_bonus_attributes:IsDebuff()return false end
function modifier_fellOmen_bonus_attributes:IsStunDebuff()return false end
function modifier_fellOmen_bonus_attributes:IsPurgable()return false end
function modifier_fellOmen_bonus_attributes:GetTexture() return "brewmaster_primal_split_cancel" end
function modifier_fellOmen_bonus_attributes:IsPurgeException() 	return false end
function modifier_fellOmen_bonus_attributes:RemoveOnDeath() return false end
function modifier_fellOmen_bonus_attributes:OnCreated(keys)
	local hero = self:GetParent()
	local nPlayerID = hero:GetPlayerOwnerID()
	-- local NetTable_key = tostring(nPlayerID).."_bonus_attribute"
	-- local data = CustomNetTables:GetTableValue( "fellOmenInfo", NetTable_key).value
	
	if IsServer() then
		if  keys.ability_point then
			local abilityPoints = hero:GetAbilityPoints() + keys.ability_point
        	hero:SetAbilityPoints(abilityPoints)

		end
		
	    
		self.bonus_str = keys.str
		self.bonus_agi = keys.agi
		self.bonus_int = keys.int
		self.bonus_spell_damage = keys.spell_damage
		self.health = keys.health
		self.mana = keys.mana
		self.armor = keys.armor
		self.attack_damage = keys.attack_damage

		self:SetHasCustomTransmitterData( true )
	end
end
function modifier_fellOmen_bonus_attributes:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		MODIFIER_PROPERTY_TOOLTIP

	}
end



function modifier_fellOmen_bonus_attributes:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_fellOmen_bonus_attributes:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_fellOmen_bonus_attributes:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_fellOmen_bonus_attributes:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage end
function modifier_fellOmen_bonus_attributes:GetModifierBaseAttack_BonusDamage()   return self.attack_damage end
function modifier_fellOmen_bonus_attributes:GetModifierHealthBonus()   return self.health end
function modifier_fellOmen_bonus_attributes:GetModifierManaBonus()   return self.mana end

function modifier_fellOmen_bonus_attributes:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end

function modifier_fellOmen_bonus_attributes:AddCustomTransmitterData()
	return
	{
		bonus_str = self.bonus_str,
		bonus_agi = self.bonus_agi,
		bonus_int = self.bonus_int,
		bonus_spell_damage = self.bonus_spell_damage,
		health = self.health,
		mana = self.mana,
		armor = self.armor,
		attack_damage = self.attack_damage,
	}
end

function modifier_fellOmen_bonus_attributes:HandleCustomTransmitterData(data)
	self.bonus_str = data.bonus_str
	self.bonus_agi = data.bonus_agi
	self.bonus_int = data.bonus_int
	self.bonus_spell_damage = data.bonus_spell_damage
	
	self.health = data.health
	self.mana = data.mana
	self.armor = data.armor
	self.attack_damage = data.attack_damage
end



function modifier_fellOmen_bonus_attributes:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 8 + 1
	if self._tooltip == 1 then
		return  self:GetModifierBonusStats_Strength()
	elseif self._tooltip == 2 then
		return  self:GetModifierBonusStats_Agility()
	elseif self._tooltip == 3 then
		return  self:GetModifierBonusStats_Intellect()
	elseif self._tooltip == 4 then
		return  self:GetModifierHealthBonus()
	elseif self._tooltip == 5 then
		return  self:GetModifierManaBonus()
	elseif self._tooltip == 6 then
		return  self:Advanced_GetModifierPhysicalArmorBonus()
	elseif self._tooltip == 7 then
		return  self:GetModifierBaseAttack_BonusDamage()
	elseif self._tooltip ==8 then
		return  self:Advanced_GetModifierSpellAmplifyBonus()
	end

end




function modifier_fellOmen_bonus_attributes:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor
end