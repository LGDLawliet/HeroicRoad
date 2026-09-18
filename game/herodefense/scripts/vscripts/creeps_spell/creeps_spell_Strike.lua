creeps_spell_Strike = class({})

LinkLuaModifier("modifier_creeps_spell_Strike", "creeps_spell/creeps_spell_Strike", LUA_MODIFIER_MOTION_NONE)



function creeps_spell_Strike:IsHiddenWhenStolen() 		return false end
function creeps_spell_Strike:IsRefreshable() 			return true end
function creeps_spell_Strike:IsStealable() 				return true end
function creeps_spell_Strike:IsNetherWardStealable()		return true end
function creeps_spell_Strike:GetIntrinsicModifierName() return "modifier_creeps_spell_Strike" end



modifier_creeps_spell_Strike = class({})

function modifier_creeps_spell_Strike:IsDebuff()			return false end
function modifier_creeps_spell_Strike:IsHidden() 			return false end
function modifier_creeps_spell_Strike:IsPurgable() 		    return false end
function modifier_creeps_spell_Strike:IsPurgeException() 	return false end

function modifier_creeps_spell_Strike:OnCreated()   
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)

end


function modifier_creeps_spell_Strike:OnIntervalThink()   
    if not IsServer() then
        return
    end
    -- self:SetStackCount(1)
    if self:GetParent():IsInNightTime() and not self:GetParent():PassivesDisabled() then
        self.stack = self:GetAbility():GetSpecialValueFor("bonus_night")
    else
        self.stack = -self:GetAbility():GetSpecialValueFor("bonus_day")
    end

    self:SetStackCount(self.stack)
end

function modifier_creeps_spell_Strike:DeclareFunctions() return 
    {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2} end

function modifier_creeps_spell_Strike:GetModifierBaseDamageOutgoing_Percentage() 
    return self:GetStackCount()
end


function modifier_creeps_spell_Strike:OnTooltip2()
    return (self:GetAbility():GetSpecialValueFor("bonus_night"))
end

function modifier_creeps_spell_Strike:OnTooltip()
    return (self:GetAbility():GetSpecialValueFor("bonus_day"))
end
