item_hd_Sange_and_Yasha = class({})

LinkLuaModifier("modifier_item_hd_Sange_and_Yasha", "items/item_hd_Sange_and_Yasha", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function item_hd_Sange_and_Yasha:GetIntrinsicModifierName()
	return "modifier_item_hd_Sange_and_Yasha"
end



modifier_item_hd_Sange_and_Yasha = advanced_modifier({})

function modifier_item_hd_Sange_and_Yasha:IsDebuff() return false end
function modifier_item_hd_Sange_and_Yasha:IsHidden() return true end
function modifier_item_hd_Sange_and_Yasha:IsPurgable() return false end
-- function modifier_item_hd_Sange_and_Yasha:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_Sange_and_Yasha:OnCreated(keys)
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = ability:GetSpecialValueFor("bonus_agi")
	self.bonus_status_resistance = ability:GetSpecialValueFor("bonus_status_resistance")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move = ability:GetSpecialValueFor("bonus_move")
	self.bonus_regeneration_amplification = ability:GetSpecialValueFor("bonus_regeneration_amplification")

 

end



function modifier_item_hd_Sange_and_Yasha:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_item_hd_Sange_and_Yasha:GetModifierBonusStats_Strength()
	return self.bonus_str
end


function modifier_item_hd_Sange_and_Yasha:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_item_hd_Sange_and_Yasha:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_item_hd_Sange_and_Yasha:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move
end
function modifier_item_hd_Sange_and_Yasha:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return self.bonus_regeneration_amplification
end




-- advanced_modifier
function modifier_item_hd_Sange_and_Yasha:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end
function modifier_item_hd_Sange_and_Yasha:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return self.bonus_regeneration_amplification
end
function modifier_item_hd_Sange_and_Yasha:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end
