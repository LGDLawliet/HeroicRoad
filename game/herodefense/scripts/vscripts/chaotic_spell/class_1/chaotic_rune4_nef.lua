chaotic_rune4_nef = class({})
LinkLuaModifier("modifier_chaotic_rune4_nef", "chaotic_spell/class_1/chaotic_rune4_nef", LUA_MODIFIER_MOTION_NONE)

function chaotic_rune4_nef:GetIntrinsicModifierName()
	return "modifier_chaotic_rune4_nef"
end
--------------------------------------------------------
modifier_chaotic_rune4_nef = advanced_modifier({})

function modifier_chaotic_rune4_nef:IsDebuff() return false end
function modifier_chaotic_rune4_nef:IsPurgable()	return false end
function modifier_chaotic_rune4_nef:RemoveOnDeath() return false end
function modifier_chaotic_rune4_nef:IsPurgeException() return false end
function modifier_chaotic_rune4_nef:IsHidden() return true end

function modifier_chaotic_rune4_nef:OnCreated(keys)
    self.bonus_block = self:GetAbility():GetSpecialValueFor("bonus_block")
    self.bonus_block_lvl = self:GetAbility():GetSpecialValueFor("bonus_block_lvl")
    self._3X4_health_regen = self:GetAbility():GetSpecialValueFor("3X4_health_regen")
    self._3X4_mana_regen = self:GetAbility():GetSpecialValueFor("3X4_mana_regen")
    self:StartIntervalThink(1)
end
function modifier_chaotic_rune4_nef:OnRefresh(keys)
    self.bonus_block = self:GetAbility():GetSpecialValueFor("bonus_block")
    self.bonus_block_lvl = self:GetAbility():GetSpecialValueFor("bonus_block_lvl")
    self._3X4_health_regen = self:GetAbility():GetSpecialValueFor("3X4_health_regen")
    self._3X4_mana_regen = self:GetAbility():GetSpecialValueFor("3X4_mana_regen")
end
function modifier_chaotic_rune4_nef:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
        -- MODIFIER_EVENT_ON_LEARN_NEW_SPELL = {self:GetParent(),nil},
		-- MODIFIER_EVENT_ON_Sell_SPELL = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,-- = "AdvancedGetModifierConstantHealthRegen", --生命恢复 常数
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,-- = "AdvancedGetModifierConstantManaRegen", --魔法恢复 常数
	}


    if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
	end
	if self:GetAbility():GetRuneType()==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE)
	end
	if self:GetAbility():GetRuneType()==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
	end
    return funcs
end

function modifier_chaotic_rune4_nef:OnIntervalThink()
    if self:GetParent():HasModifier("modifier_chaotic_rune3_tir") then
        self.bonus_enable = true
    else
        self.bonus_enable = false
    end
end


function modifier_chaotic_rune4_nef:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	
	local parent = self:GetParent()
	if parent:PassivesDisabled() then
		return
	end
	
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


	return self.bonus_block + self.bonus_block_lvl*self:GetParent():GetLevel()
end


-- function modifier_chaotic_rune4_nef:AdvancedOnLearnNewSpell(keys)
-- 	if keys.unit==self:GetParent() then
-- 		local ability = keys.ability
--         if ability:GetAbilityName()=="chaotic_rune3_tir" then
--             self.bonus_enable = true
--         end
-- 	end
-- end

-- function modifier_chaotic_rune4_nef:AdvancedOnSellSpell(keys)
-- 	if keys.unit==self:GetParent() then
-- 		local ability_name = keys.ability_name
--         if ability_name=="chaotic_rune3_tir" then
--             self.bonus_enable = false
--         end
-- 	end
-- end



function modifier_chaotic_rune4_nef:AdvancedGetModifierConstantHealthRegen()
    if self:GetParent():PassivesDisabled() then
        return
    end
    if  self.bonus_enable then
        return self._3X4_health_regen
    end
	return 0
end

function modifier_chaotic_rune4_nef:AdvancedGetModifierConstantManaRegen()
    if self:GetParent():PassivesDisabled() then
        return
    end
    if  self.bonus_enable then
        return self._3X4_mana_regen
    end
	return 0
end

function modifier_chaotic_rune4_nef:Advanced_GetModifierBonusStats_Strength()
    if self:GetParent():PassivesDisabled() then
        return
    end

	return self:GetAbility():GetSpecialValueFor("rune_1_atb")
end
function modifier_chaotic_rune4_nef:Advanced_GetModifierHealReceiveAMP_Percentage()
    if self:GetParent():PassivesDisabled() then
        return
    end

	return self:GetAbility():GetSpecialValueFor("rune_2_rheal_amp")
end
function modifier_chaotic_rune4_nef:Advanced_GetModifierPhysicalArmorBonus()
    if self:GetParent():PassivesDisabled() then
        return
    end

	return self:GetAbility():GetSpecialValueFor("rune_3_armor")
end