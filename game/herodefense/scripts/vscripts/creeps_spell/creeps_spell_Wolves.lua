creeps_spell_Wolves = class({})

LinkLuaModifier("modifier_creeps_spell_Wolves", "creeps_spell/creeps_spell_Wolves", LUA_MODIFIER_MOTION_NONE)



function creeps_spell_Wolves:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wolves:IsRefreshable() 			return true end
function creeps_spell_Wolves:IsStealable() 				return true end
function creeps_spell_Wolves:IsNetherWardStealable()		return true end
function creeps_spell_Wolves:GetIntrinsicModifierName() return "modifier_creeps_spell_Wolves" end



modifier_creeps_spell_Wolves = advanced_modifier({})

function modifier_creeps_spell_Wolves:IsDebuff()			return false end
function modifier_creeps_spell_Wolves:IsHidden() 			return true end
function modifier_creeps_spell_Wolves:IsPurgable() 		    return false end
function modifier_creeps_spell_Wolves:IsPurgeException() 	return false end

function modifier_creeps_spell_Wolves:OnCreated(table)
    self.res_bonus = -self:GetAbility():GetSpecialValueFor("bonus_day")
    if not IsServer()  then
        return
    end
    self:StartIntervalThink(0.5)

end


function modifier_creeps_spell_Wolves:OnIntervalThink()
    if not IsServer()  then
        return
    end
    if self:GetParent():IsInDayTime() or self:GetParent():PassivesDisabled() then
        self:SetStackCount(1)
    else
        self:SetStackCount(0)
    end
    if self:GetParent():IsInNightTime() and not self:GetParent():PassivesDisabled() then
        self.night = self:GetAbility():GetSpecialValueFor("bonus_night")
    end
    

end





function modifier_creeps_spell_Wolves:DeclareFunctions() return 
    {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
 } end


function modifier_creeps_spell_Wolves:GetModifierAttackSpeedBonus_Constant() 
    return self.night
end

function modifier_creeps_spell_Wolves:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wolves:Advanced_GetModifier_StatusResistance(keys)
	return self:GetStackCount()==1 and self.res_bonus or 0
end
