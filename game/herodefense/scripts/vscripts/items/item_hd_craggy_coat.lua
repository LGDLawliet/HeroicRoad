item_hd_craggy_coat = class({})
-- LinkLuaModifier("modifier_item_hd_craggy_coat_arua", "items/item_hd_craggy_coat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_craggy_coat_arua_effect", "items/item_hd_craggy_coat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_craggy_coat", "items/item_hd_craggy_coat", LUA_MODIFIER_MOTION_NONE)


function item_hd_craggy_coat:GetIntrinsicModifierName()
	return "modifier_item_hd_craggy_coat"
end




modifier_item_hd_craggy_coat = advanced_modifier({})

function modifier_item_hd_craggy_coat:IsDebuff() return false end
function modifier_item_hd_craggy_coat:IsHidden() return true end
function modifier_item_hd_craggy_coat:IsPurgable() return false end



function modifier_item_hd_craggy_coat:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_attack_speed = -self.ability:GetSpecialValueFor("bonus_attack_speed")

	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")

end


function modifier_item_hd_craggy_coat:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end


function modifier_item_hd_craggy_coat:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end


function modifier_item_hd_craggy_coat:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_craggy_coat:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end