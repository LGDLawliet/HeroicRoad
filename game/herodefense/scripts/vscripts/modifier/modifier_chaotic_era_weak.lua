
LinkLuaModifier("modifier_chaotic_era_weak2", "modifier/modifier_chaotic_era_weak", LUA_MODIFIER_MOTION_NONE) --狂暴
LinkLuaModifier("modifier_chaotic_era_weak3", "modifier/modifier_chaotic_era_weak", LUA_MODIFIER_MOTION_NONE) --狂暴



--------------------------------------------------------------------------------
modifier_chaotic_era_weak = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_era_weak:IsHidden()return false end
function modifier_chaotic_era_weak:IsDebuff()return true end
function modifier_chaotic_era_weak:IsStunDebuff()return false end
function modifier_chaotic_era_weak:IsPurgable()return false end
function modifier_chaotic_era_weak:GetTexture() return "chaotic_era_spell/chaotic_weak" end
function modifier_chaotic_era_weak:IsPurgeException() 	return false end
function modifier_chaotic_era_weak:RemoveOnDeath() return false end
function modifier_chaotic_era_weak:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

function modifier_chaotic_era_weak:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_chaotic_era_weak:Advanced_GetModifierCooldownReduction(keys)
    return self.cooldown_reduction*self:GetStackCount()
end



function modifier_chaotic_era_weak:OnCreated()
	self.move_speed_slow = -7
	self.cooldown_reduction = -3
	if IsServer() then
		self:StartIntervalThink(5)
	end
end



function modifier_chaotic_era_weak:OnIntervalThink()
	self:IncrementStackCount()
	if self:GetStackCount()>=10 then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_chaotic_era_weak2", {}) 
		if self:GetStackCount()>=25 then
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_chaotic_era_weak3", {}) 
		end
	end
end

function modifier_chaotic_era_weak:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end
function modifier_chaotic_era_weak:GetModifierMoveSpeedBonus_Constant()	return self.move_speed_slow*self:GetStackCount() end

function modifier_chaotic_era_weak:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierCooldownReduction()
	elseif self._tooltip == 2 then
		return self:GetModifierMoveSpeedBonus_Constant()
	end	
end














--------------------------------------------------------------------------------
modifier_chaotic_era_weak2 = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_era_weak2:IsHidden()return false end
function modifier_chaotic_era_weak2:IsDebuff()return true end
function modifier_chaotic_era_weak2:IsStunDebuff()return false end
function modifier_chaotic_era_weak2:IsPurgable()return false end
function modifier_chaotic_era_weak2:GetTexture() return "chaotic_era_spell/chaotic_weak" end
function modifier_chaotic_era_weak2:IsPurgeException() 	return false end
function modifier_chaotic_era_weak2:RemoveOnDeath() return false end
function modifier_chaotic_era_weak2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_chaotic_era_weak2:Advanced_GetModifierBonusStats_Strength()	
	return self.all_attribute_reduction * self:GetStackCount()
end
function modifier_chaotic_era_weak2:Advanced_GetModifierBonusStats_Agility()	
	return self.all_attribute_reduction * self:GetStackCount()
end

function modifier_chaotic_era_weak2:Advanced_GetModifierBonusStats_Intellect()	
	return self.all_attribute_reduction * self:GetStackCount()
end
function modifier_chaotic_era_weak2:OnCreated()
	self.all_attribute_reduction = -2
	if IsServer() then
		self:StartIntervalThink(4)
	end
end

function modifier_chaotic_era_weak2:OnIntervalThink()
	self:IncrementStackCount()
end

function modifier_chaotic_era_weak2:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_chaotic_era_weak2:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierBonusStats_Strength()
	end	
end



















--------------------------------------------------------------------------------
modifier_chaotic_era_weak3 = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_era_weak3:IsHidden()return false end
function modifier_chaotic_era_weak3:IsDebuff()return true end
function modifier_chaotic_era_weak3:IsStunDebuff()return false end
function modifier_chaotic_era_weak3:IsPurgable()return false end
function modifier_chaotic_era_weak3:GetTexture() return "chaotic_era_spell/chaotic_weak" end
function modifier_chaotic_era_weak3:IsPurgeException() 	return false end
function modifier_chaotic_era_weak3:RemoveOnDeath() return false end
function modifier_chaotic_era_weak3:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_Zero_Override,
		-- advanced_MODIFIER_PROPERTY_HEALTH_REGEN_Zero_Override, --生命恢复归零
	

    }
end
function modifier_chaotic_era_weak3:AdvancedGetModifierConstantManaRegen_Zero_Override()	
	return 1
end
-- function modifier_chaotic_era_weak3:AdvancedGetModifierConstantHealthRegen_Zero_Override()	
-- 	return 1
-- end
function modifier_chaotic_era_weak3:DeclareFunctions()
	return {
		
		-- MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		
	}
end
function modifier_chaotic_era_weak3:GetDisableHealing(keys)
	return 1
end
