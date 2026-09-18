item_hd_holy_locket = advanced_modifier({})

LinkLuaModifier("modifier_item_hd_holy_locket", "items/item_hd_holy_locket", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_holy_locket_active", "items/item_hd_holy_locket", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
function item_hd_holy_locket:GetIntrinsicModifierName()
	return "modifier_item_hd_holy_locket"
end
----------------------

modifier_item_hd_holy_locket = advanced_modifier({})

function modifier_item_hd_holy_locket:IsDebuff() return false end
function modifier_item_hd_holy_locket:IsHidden() return true end
function modifier_item_hd_holy_locket:IsPurgable() return false end

function modifier_item_hd_holy_locket:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
    self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
    self.duration = self.ability:GetSpecialValueFor("duration")
end

-- advanced_modifier
function modifier_item_hd_holy_locket:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_item_hd_holy_locket:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
		if keys.target==self:GetParent() then
			return
		end
        if not keys.target:IsRealHero() then
            return
        end
        if keys.target:GetTeamNumber() ~= keys.unit:GetTeamNumber() then
            return
        end

        local modifier = keys.target:FindModifierByName("modifier_item_hd_holy_locket_active")
		if modifier then
			modifier:ForceRefresh()
			modifier:SetDuration(self.duration,true)
		else
			keys.target:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_holy_locket_active", {duration = self.duration})
		end
	end
end

function modifier_item_hd_holy_locket:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end

function modifier_item_hd_holy_locket:Advanced_GetModifierBonusStats_Strength(keys)
	return self.bonus_atb 
end
function modifier_item_hd_holy_locket:Advanced_GetModifierBonusStats_Agility(keys)
	return self.bonus_atb 
end
function modifier_item_hd_holy_locket:Advanced_GetModifierBonusStats_Intellect(keys)
	return self.bonus_atb 
end
---------------
modifier_item_hd_holy_locket_active = advanced_modifier({})

function modifier_item_hd_holy_locket_active:IsDebuff() return false end
function modifier_item_hd_holy_locket_active:IsHidden() return true end
function modifier_item_hd_holy_locket_active:IsPurgable() return false end
function modifier_item_hd_holy_locket_active:GetEffectName() return "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_bloom_ambient.vpcf" end
function modifier_item_hd_holy_locket_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_holy_locket_active:OnCreated(keys)
	if not IsServer() then
		return
	end
    
    self.ability = self:GetAbility()
	self.active_agi = self.ability:GetSpecialValueFor("active_atb")*0.01 *self:GetCaster():GetBaseAgility()
    self.active_int = self.ability:GetSpecialValueFor("active_atb")*0.01 *self:GetCaster():GetBaseIntellect()
    self.active_str = self.ability:GetSpecialValueFor("active_atb")*0.01 *self:GetCaster():GetBaseStrength()

end
function modifier_item_hd_holy_locket_active:OnRefresh(keys)
	if not IsServer() then
		return
	end
    
    self.ability = self:GetAbility()
	self.active_agi = self.ability:GetSpecialValueFor("active_atb")*0.01 *self:GetCaster():GetBaseAgility()
    self.active_int = self.ability:GetSpecialValueFor("active_atb")*0.01 *self:GetCaster():GetBaseIntellect()
    self.active_str = self.ability:GetSpecialValueFor("active_atb")*0.01 *self:GetCaster():GetBaseStrength()

end

function modifier_item_hd_holy_locket_active:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_item_hd_holy_locket_active:Advanced_GetModifierBonusStats_Strength()
    return self.active_str
end
function modifier_item_hd_holy_locket_active:Advanced_GetModifierBonusStats_Agility()
    return self.active_agi
end
function modifier_item_hd_holy_locket_active:Advanced_GetModifierBonusStats_Intellect()
    return self.active_int
end
