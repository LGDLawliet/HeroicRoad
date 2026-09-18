------
---鞭策光环
creeps_spell_Spur_On = class({})

LinkLuaModifier("modifier_creeps_spell_Spur_On_passive", "creeps_spell/creeps_spell_Spur_On", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Spur_On_effect", "creeps_spell/creeps_spell_Spur_On", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Spur_On:GetIntrinsicModifierName() return "modifier_creeps_spell_Spur_On_passive" end

modifier_creeps_spell_Spur_On_passive = class({})

function modifier_creeps_spell_Spur_On_passive:IsHidden() return true end
function modifier_creeps_spell_Spur_On_passive:IsAura() return true end
function modifier_creeps_spell_Spur_On_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Spur_On_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Spur_On_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Spur_On_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Spur_On_passive:GetModifierAura() return "modifier_creeps_spell_Spur_On_effect" end
function modifier_creeps_spell_Spur_On_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_Spur_On_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Spur_On_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_Spur_On_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
modifier_creeps_spell_Spur_On_effect = class({})

function modifier_creeps_spell_Spur_On_effect:IsDebuff()			    return false end
function modifier_creeps_spell_Spur_On_effect:IsHidden() 			return false end
function modifier_creeps_spell_Spur_On_effect:IsPurgable() 		    return false end
function modifier_creeps_spell_Spur_On_effect:IsPurgeException() 	return false end

function modifier_creeps_spell_Spur_On_effect:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end

function modifier_creeps_spell_Spur_On_effect:GetModifierAttackSpeedBonus_Constant() 
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    if self.attack ==nil then
        return  50
    else 
        return self.attack
    end
end

function modifier_creeps_spell_Spur_On_effect:OnCreated(table)
    if not IsServer() then
        return
    end
    self.attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
end
