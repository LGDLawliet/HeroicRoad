creeps_spell_Competing_For_Nutrients1 = class({})

LinkLuaModifier("modifier_creeps_spell_Competing_For_Nutrients1", "creeps_spell/creeps_spell_Competing_For_Nutrients1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_refresh", "creeps_spell/creeps_spell_Competing_For_Nutrients1", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Competing_For_Nutrients1:IsHiddenWhenStolen() 		return false end
function creeps_spell_Competing_For_Nutrients1:IsRefreshable() 			return true end
function creeps_spell_Competing_For_Nutrients1:IsStealable() 				return true end
function creeps_spell_Competing_For_Nutrients1:IsNetherWardStealable()		return true end
function creeps_spell_Competing_For_Nutrients1:GetIntrinsicModifierName() return "modifier_creeps_spell_Competing_For_Nutrients1" end


modifier_creeps_spell_Competing_For_Nutrients1 = advanced_modifier({})

function modifier_creeps_spell_Competing_For_Nutrients1:IsDebuff()			return false end
function modifier_creeps_spell_Competing_For_Nutrients1:IsHidden() 			return false end
function modifier_creeps_spell_Competing_For_Nutrients1:IsPurgable() 		    return false end
function modifier_creeps_spell_Competing_For_Nutrients1:IsPurgeException() 	return false end
function modifier_creeps_spell_Competing_For_Nutrients1:RemoveOnDeath()       return false end

function modifier_creeps_spell_Competing_For_Nutrients1:OnCreated(table)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(4)
end

function modifier_creeps_spell_Competing_For_Nutrients1:OnIntervalThink(table)
    if not IsServer() then
        return
    end
    if self:GetParent():PassivesDisabled() then
        return
    end
    if self:GetParent():IsInDayTime() then
        self.stack = self:GetAbility():GetSpecialValueFor("bonus_day")
    else 
        self.stack = self:GetAbility():GetSpecialValueFor("bonus_night")
    end
    local caster = self:GetParent()
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,
    1000,
     DOTA_UNIT_TARGET_TEAM_FRIENDLY,
      DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
    local index = 0
    for _, unit in ipairs(units) do
        if unit:GetUnitName() == "npc_monster_wave_13_1" then
            index = index + 1
        end
    end
    index = index * 5
    if index > 100 then
        return
    end
    self.stack = self.stack * (100-index)/10
    self:SetStackCount(self:GetStackCount()+self.stack)
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_refresh", {duration=0.1})
end



function modifier_creeps_spell_Competing_For_Nutrients1:DeclareFunctions()
    return 
    
    {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    
    MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_creeps_spell_Competing_For_Nutrients1:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()*0.1
end


function modifier_creeps_spell_Competing_For_Nutrients1:AdvancedGetModifierExtraHealthPercentage()
	return self:GetStackCount()*0.1
end

function modifier_creeps_spell_Competing_For_Nutrients1:OnTooltip()
    return self:GetStackCount()*0.1
end


function modifier_creeps_spell_Competing_For_Nutrients1:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end





modifier_creeps_spell_refresh = class({})

function modifier_creeps_spell_refresh:IsDebuff()			return false end
function modifier_creeps_spell_refresh:IsHidden() 			return true end
