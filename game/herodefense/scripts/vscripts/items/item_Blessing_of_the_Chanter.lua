
LinkLuaModifier("modifier_item_Blessing_of_the_Chanter_buff", "items/item_Blessing_of_the_Chanter", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")


item_Blessing_of_the_Chanter=class({})
function item_Blessing_of_the_Chanter:GetIntrinsicModifierName() 
    return "modifier_item_Blessing_of_the_Chanter_buff" 
end




modifier_item_Blessing_of_the_Chanter_buff=advanced_modifier({})

function modifier_item_Blessing_of_the_Chanter_buff:IsPassive()			return true end
function modifier_item_Blessing_of_the_Chanter_buff:IsHidden() 		return true end
function modifier_item_Blessing_of_the_Chanter_buff:IsPurgable() 		return false end
function modifier_item_Blessing_of_the_Chanter_buff:IsPurgeException() return false end

function modifier_item_Blessing_of_the_Chanter_buff:RemoveOnDeath()  return false end
function modifier_item_Blessing_of_the_Chanter_buff:AllowIllusionDuplicate() return false end
function modifier_item_Blessing_of_the_Chanter_buff:OnCreated()

    self.ability=self:GetAbility()

    self.bonus_StatusNegativeGain = self.ability:GetSpecialValueFor("bonus_StatusNegativeGain")
    self.bonus_StatusGain = self.ability:GetSpecialValueFor("bonus_StatusGain")
    if IsClient() then
        return
    end

end




-- advanced_modifier
function modifier_item_Blessing_of_the_Chanter_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
        advanced_MODIFIER_PROPERTY_NegativeDurationGain
    }
end
function modifier_item_Blessing_of_the_Chanter_buff:Advanced_GetModifier_DurationGain(keys)
	return self.bonus_StatusGain
end



function modifier_item_Blessing_of_the_Chanter_buff:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.bonus_StatusNegativeGain
end


