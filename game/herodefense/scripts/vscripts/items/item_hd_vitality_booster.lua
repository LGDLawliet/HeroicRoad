item_hd_vitality_booster = advanced_modifier({})

LinkLuaModifier("modifier_item_hd_vitality_booster", "items/item_hd_vitality_booster", LUA_MODIFIER_MOTION_NONE)
function item_hd_vitality_booster:GetIntrinsicModifierName()
	return "modifier_item_hd_vitality_booster"
end



modifier_item_hd_vitality_booster = advanced_modifier({})

function modifier_item_hd_vitality_booster:IsDebuff() return false end
function modifier_item_hd_vitality_booster:IsHidden() return true end
function modifier_item_hd_vitality_booster:IsPurgable() return false end



function modifier_item_hd_vitality_booster:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")

end


function modifier_item_hd_vitality_booster:AdvancedGetModifierHealthBonus()	return self.bonus_health end



function modifier_item_hd_vitality_booster:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end
