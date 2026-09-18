creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY = class({})
LinkLuaModifier("modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain", "creeps_spell/creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY", LUA_MODIFIER_MOTION_NONE)

-- require("internal/timers")
--Abilities
function creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY:IsHiddenWhenStolen() 		return false end
function creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY:IsRefreshable() 			return true end
function creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY:IsStealable() 				return true end
function creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY:IsNetherWardStealable()		return true end
function creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY:GetIntrinsicModifierName() return "modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain" end



modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain = advanced_modifier({})
function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:IsHidden() return true end
function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:IsDebuff() return false end
function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:IsPurgable() return false end
function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:IsPurgeException() return false end
function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:IsStunDebuff() return false end
function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:AllowIllusionDuplicate() return true end
-- function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:OnCreated()
--     local unit = self:GetParent()

--     if not IsServer() then
--         return
--     end


-- end


-- function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:GetModifierTotalDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:Advanced_GetModifierIncomingDamage_Percentage() return -self:GetAbility():GetSpecialValueFor("bonus_damage_reduce") end



function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY_gain:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end


