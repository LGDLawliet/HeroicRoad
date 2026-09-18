chaotic_attack_to_defend = class({})
LinkLuaModifier("modifier_chaotic_attack_to_defend", "chaotic_spell/class_8/chaotic_attack_to_defend", LUA_MODIFIER_MOTION_NONE)

function chaotic_attack_to_defend:GetIntrinsicModifierName() return "modifier_chaotic_attack_to_defend" end


modifier_chaotic_attack_to_defend = advanced_modifier({})

function modifier_chaotic_attack_to_defend:IsDebuff()			return false end
function modifier_chaotic_attack_to_defend:IsHidden() 		return true end
function modifier_chaotic_attack_to_defend:IsPurgable() 		return false end
function modifier_chaotic_attack_to_defend:IsPurgeException() return false end

function modifier_chaotic_attack_to_defend:ADDeclareFunctions()
    local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    if self:GetAbility():GetRuneType()==1 then
        --table.insert(funcs,advanced_MODIFIER_PROPERTY_DISABLE)
        table.insert(funcs,advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS)
        table.insert(funcs,advanced_MODIFIER_PROPERTY_Summon_Intensity)
    end
    return funcs
    
end

function modifier_chaotic_attack_to_defend:OnCreated()

    self.increased_damage = self:GetAbility():GetSpecialValueFor("increased_damage")
	self.crit_bonus = self:GetAbility():GetSpecialValueFor("crit_bonus")
	self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
    if self:GetAbility():GetRuneType()==1 then
        self.bonus_attack_damage = self.bonus_attack_damage + self:GetAbility():GetSpecialValueFor("rune_1_bonus")
    end
end

function modifier_chaotic_attack_to_defend:OnRefresh() 
    self.increased_damage = self:GetAbility():GetSpecialValueFor("increased_damage")
	self.crit_bonus = self:GetAbility():GetSpecialValueFor("crit_bonus")
	self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
    if self:GetAbility():GetRuneType()==1 then
        self.bonus_attack_damage = self.bonus_attack_damage + self:GetAbility():GetSpecialValueFor("rune_1_bonus")
    end
end

function modifier_chaotic_attack_to_defend:Advanced_GetModifierIncomingDamage_Percentage( keys )
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    return self.increased_damage
end

function modifier_chaotic_attack_to_defend:Advanced_GetModifier_PhysicalCriticalAmp(keys)
    if self:GetParent():PassivesDisabled() then
        return 0
    end
	return self.crit_bonus
end

function modifier_chaotic_attack_to_defend:Advanced_GetModifierBaseAttack_BonusDamage(keys)
    if self:GetParent():PassivesDisabled() then
        return 0
    end
	return self.bonus_attack_damage
end

function modifier_chaotic_attack_to_defend:Advanced_GetModifierSpellAmplifyBonus(keys)
    if self:GetParent():PassivesDisabled() then
        return 0
    end
	return -self.rune_1_down
end

function modifier_chaotic_attack_to_defend:Advanced_GetModifier_Summon_Intensity(keys)
    if self:GetParent():PassivesDisabled() then
        return 0
    end
	return -self.rune_1_down
end
-- function modifier_chaotic_attack_to_defend:Advanced_GetModifierPhysicalArmorDisable(keys)
-- 	return 1
-- end