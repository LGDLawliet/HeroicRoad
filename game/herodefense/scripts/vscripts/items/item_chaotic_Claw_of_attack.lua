item_chaotic_Claw_of_attack = class({})

LinkLuaModifier("modifier_item_chaotic_Claw_of_attack", "items/item_chaotic_Claw_of_attack", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_Claw_of_attack:GetIntrinsicModifierName()
	return "modifier_item_chaotic_Claw_of_attack"
end


modifier_item_chaotic_Claw_of_attack = advanced_modifier({})

function modifier_item_chaotic_Claw_of_attack:IsDebuff() return false end
function modifier_item_chaotic_Claw_of_attack:IsHidden() return true end
function modifier_item_chaotic_Claw_of_attack:IsPurgable() return false end

function modifier_item_chaotic_Claw_of_attack:OnCreated(keys)
	self.bonus_base_attack = self:GetAbility():GetSpecialValueFor("bonus_base_attack")
end

function modifier_item_chaotic_Claw_of_attack:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end
function modifier_item_chaotic_Claw_of_attack:Advanced_GetModifierBaseAttack_BonusDamage()
	return self.bonus_base_attack
end