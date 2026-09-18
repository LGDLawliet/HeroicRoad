Primary_take_aim = class({})
-- LinkLuaModifier("modifier_Primary_take_aim_arua", "skills/Primary_take_aim", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_take_aim_arua_effect", "skills/Primary_take_aim", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_take_aim", "skills/Primary_take_aim", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function Primary_take_aim:GetIntrinsicModifierName()
	return "modifier_Primary_take_aim"
end




modifier_Primary_take_aim = advanced_modifier({})

function modifier_Primary_take_aim:IsDebuff() return false end
function modifier_Primary_take_aim:IsHidden() return true end
function modifier_Primary_take_aim:IsPurgable() 		return false end
function modifier_Primary_take_aim:IsPurgeException() 	return false end
function modifier_Primary_take_aim:RemoveOnDeath()  return false end



function modifier_Primary_take_aim:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

end



function modifier_Primary_take_aim:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.ability:GetSpecialValueFor("bonus_attack_range") or 0 end


function modifier_Primary_take_aim:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end