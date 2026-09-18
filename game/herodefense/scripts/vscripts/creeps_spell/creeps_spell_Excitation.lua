------
---激励光环
creeps_spell_Excitation = class({})

LinkLuaModifier("modifier_creeps_spell_Excitation_passive", "creeps_spell/creeps_spell_Excitation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Excitation_effect", "creeps_spell/creeps_spell_Excitation", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Excitation:GetIntrinsicModifierName() return "modifier_creeps_spell_Excitation_passive" end

modifier_creeps_spell_Excitation_passive = class({})

function modifier_creeps_spell_Excitation_passive:IsHidden() return true end
function modifier_creeps_spell_Excitation_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Excitation_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Excitation_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Excitation_passive:IsAura() return true end
function modifier_creeps_spell_Excitation_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Excitation_passive:GetModifierAura() return "modifier_creeps_spell_Excitation_effect" end
function modifier_creeps_spell_Excitation_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_Excitation_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Excitation_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_Excitation_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
modifier_creeps_spell_Excitation_effect = class({})

function modifier_creeps_spell_Excitation_effect:IsDebuff()			    return false end
function modifier_creeps_spell_Excitation_effect:IsHidden() 			return false end
function modifier_creeps_spell_Excitation_effect:IsPurgable() 		    return false end
function modifier_creeps_spell_Excitation_effect:IsPurgeException() 	return false end

function modifier_creeps_spell_Excitation_effect:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_creeps_spell_Excitation_effect:GetModifierMoveSpeedBonus_Percentage() 
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    if self.move ==nil then
        return  5
    else 
        return self.move
    end
end
function modifier_creeps_spell_Excitation_effect:GetModifierAttackSpeedBonus_Constant() 
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    if self.attack ==nil then
        return  15
    else 
        return self.attack
    end
end

function modifier_creeps_spell_Excitation_effect:OnCreated(table)
    if not IsServer() then
        return
    end
    self.move = self:GetAbility():GetSpecialValueFor("bonus_move")
    self.attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
end
