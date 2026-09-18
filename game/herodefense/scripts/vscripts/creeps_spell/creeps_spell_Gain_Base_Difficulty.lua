creeps_spell_Gain_Base_Difficulty = class({})
LinkLuaModifier("modifier_creeps_spell_Gain_Base_Difficulty_gain", "creeps_spell/creeps_spell_Gain_Base_Difficulty", LUA_MODIFIER_MOTION_NONE)

require("internal/timers")
--Abilities
function creeps_spell_Gain_Base_Difficulty:IsHiddenWhenStolen() 		return false end
function creeps_spell_Gain_Base_Difficulty:IsRefreshable() 			return true end
function creeps_spell_Gain_Base_Difficulty:IsStealable() 				return true end
function creeps_spell_Gain_Base_Difficulty:IsNetherWardStealable()		return true end
function creeps_spell_Gain_Base_Difficulty:GetIntrinsicModifierName() return "modifier_creeps_spell_Gain_Base_Difficulty_gain" end



modifier_creeps_spell_Gain_Base_Difficulty_gain = advanced_modifier({})
function modifier_creeps_spell_Gain_Base_Difficulty_gain:IsHidden() return false end
function modifier_creeps_spell_Gain_Base_Difficulty_gain:IsDebuff() return false end
function modifier_creeps_spell_Gain_Base_Difficulty_gain:IsPurgable() return false end
function modifier_creeps_spell_Gain_Base_Difficulty_gain:IsPurgeException() return false end
function modifier_creeps_spell_Gain_Base_Difficulty_gain:IsStunDebuff() return false end
function modifier_creeps_spell_Gain_Base_Difficulty_gain:AllowIllusionDuplicate() return true end

function modifier_creeps_spell_Gain_Base_Difficulty_gain:OnCreated()
    local unit = self:GetParent()

    if unit.difficulty_gain then
        return
    end
    self.ability  = self:GetAbility()
    self.health = self.ability:GetSpecialValueFor("health")
    self.cooldown = self.ability:GetSpecialValueFor("cooldown")

    if not IsServer() then
        return
    end
    Timers:CreateTimer(0.2, function()
        local bonus_damage = 1+self:GetAbility():GetSpecialValueFor("bonus_damage")
        -- print("bonus_damage"..bonus_damage)
        -- print("bonus_damage"..self:GetAbility():GetSpecialValueFor("bonus_damage"))
        -- local max = unit:GetBaseDamageMax()*bonus_damage
        -- max = max- max%1
        -- local min = unit:GetBaseDamageMin()*bonus_damage
        -- min = min- min%1
        unit:SetBaseDamageMax(unit:GetBaseDamageMax()*bonus_damage)
        unit:SetBaseDamageMin(unit:GetBaseDamageMin()*bonus_damage)
    end)

    unit.difficulty_gain = true
end

function modifier_creeps_spell_Gain_Base_Difficulty_gain:DeclareFunctions() return
    {
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
} 
end
function modifier_creeps_spell_Gain_Base_Difficulty_gain:AdvancedGetModifierExtraHealthPercentage() return self.health end

function modifier_creeps_spell_Gain_Base_Difficulty_gain:GetModifierPercentageCooldown() return (self.cooldown) end

function modifier_creeps_spell_Gain_Base_Difficulty_gain:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end