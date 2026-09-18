creeps_spell_Swift = class({})

LinkLuaModifier("modifier_creeps_spell_Swift", "creeps_spell/creeps_spell_Swift", LUA_MODIFIER_MOTION_NONE)



function creeps_spell_Swift:IsHiddenWhenStolen() 		return false end
function creeps_spell_Swift:IsRefreshable() 			return true end
function creeps_spell_Swift:IsStealable() 				return true end
function creeps_spell_Swift:IsNetherWardStealable()		return true end
function creeps_spell_Swift:GetIntrinsicModifierName() return "modifier_creeps_spell_Swift" end



modifier_creeps_spell_Swift = class({})

function modifier_creeps_spell_Swift:IsDebuff()			return false end
function modifier_creeps_spell_Swift:IsHidden() 			return false end
function modifier_creeps_spell_Swift:IsPurgable() 		    return false end
function modifier_creeps_spell_Swift:IsPurgeException() 	return false end

function modifier_creeps_spell_Swift:OnCreated()   
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)

end


function modifier_creeps_spell_Swift:OnIntervalThink()   
    if not IsServer() then
        return
    end
    if self:GetParent():IsInNightTime() and not self:GetParent():PassivesDisabled() then
        self.stack = self:GetAbility():GetSpecialValueFor("bonus_night")
    else
        self.stack = -self:GetAbility():GetSpecialValueFor("bonus_day")
    end
    -- self:SetStackCount(1)
    self:SetStackCount(self.stack)
end

function modifier_creeps_spell_Swift:DeclareFunctions() return 
    {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2} end

function modifier_creeps_spell_Swift:GetModifierAttackSpeedBonus_Constant() 
    return self:GetStackCount()
end


function modifier_creeps_spell_Swift:OnTooltip2()
    return (self:GetAbility():GetSpecialValueFor("bonus_night"))
end

function modifier_creeps_spell_Swift:OnTooltip()
    return (self:GetAbility():GetSpecialValueFor("bonus_day"))
end
