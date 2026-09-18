item_hd_magic_wand = advanced_modifier({})

LinkLuaModifier("modifier_item_hd_magic_wand", "items/item_hd_magic_wand", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_magic_wand_active", "items/item_hd_magic_wand", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
function item_hd_magic_wand:GetIntrinsicModifierName()
	return "modifier_item_hd_magic_wand"
end
----------------------

modifier_item_hd_magic_wand = advanced_modifier({})

function modifier_item_hd_magic_wand:IsDebuff() return false end
function modifier_item_hd_magic_wand:IsHidden() return true end
function modifier_item_hd_magic_wand:IsPurgable() return false end

function modifier_item_hd_magic_wand:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
    self.bonus_cast_range = self.ability:GetSpecialValueFor("bonus_cast_range")
    self.duration = self.ability:GetSpecialValueFor("duration")
end

-- advanced_modifier
function modifier_item_hd_magic_wand:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end

function modifier_item_hd_magic_wand:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
        if not keys.target:IsRealHero() then
            return
        end
        if keys.target:GetTeamNumber() ~= keys.unit:GetTeamNumber() then
            return
        end
        if not self:GetAbility():IsCooldownReady() then
            return
        end

        local modifier = keys.target:FindModifierByName("modifier_item_hd_magic_wand_active")
		if modifier then
			modifier:ForceRefresh()
			modifier:SetDuration(self.duration, true)
		else
			keys.target:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_magic_wand_active", {duration = self.duration})
		end

        self:GetAbility():UseResources(true, true, true, true)
	end
end
function modifier_item_hd_magic_wand:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end
function modifier_item_hd_magic_wand:Advanced_GetModifierCastRangeBonusStacking(keys)
	return self.bonus_cast_range 
end

modifier_item_hd_magic_wand_active = advanced_modifier({})

function modifier_item_hd_magic_wand_active:IsDebuff() return false end
function modifier_item_hd_magic_wand_active:IsHidden() return true end
function modifier_item_hd_magic_wand_active:IsPurgable() return false end
function modifier_item_hd_magic_wand_active:GetEffectName() return "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_bloom_ambient.vpcf" end
function modifier_item_hd_magic_wand_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_magic_wand_active:OnCreated(keys)
    if not self:GetAbility() then self:Destroy() return end
    self.ability = self:GetAbility()
	self.active_agi = self.ability:GetSpecialValueFor("active_agi")
    self.active_int = self.ability:GetSpecialValueFor("active_int")
    self.active_str = self.ability:GetSpecialValueFor("active_str")

    
end
function modifier_item_hd_magic_wand_active:OnRefresh(keys)
    if not self:GetAbility() then self:Destroy() return end
    self.ability = self:GetAbility()
	self.active_agi = self.ability:GetSpecialValueFor("active_agi")
    self.active_int = self.ability:GetSpecialValueFor("active_int")
    self.active_str = self.ability:GetSpecialValueFor("active_str")

end

function modifier_item_hd_magic_wand_active:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function modifier_item_hd_magic_wand_active:Advanced_GetModifierAttackSpeedPercentage()
    if not self:GetAbility() then self:Destroy() return end
    return  self.active_agi
end
function modifier_item_hd_magic_wand_active:Advanced_GetModifierSpellAmplifyBonus()
    if not self:GetAbility() then self:Destroy() return end
    return self.active_int
end
function modifier_item_hd_magic_wand_active:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return -self.active_str
end
