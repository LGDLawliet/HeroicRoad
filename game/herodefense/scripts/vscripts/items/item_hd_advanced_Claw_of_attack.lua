item_hd_advanced_Claw_of_attack = class({})

LinkLuaModifier("modifier_item_hd_advanced_Claw_of_attack", "items/item_hd_advanced_Claw_of_attack", LUA_MODIFIER_MOTION_NONE)

function item_hd_advanced_Claw_of_attack:GetIntrinsicModifierName()
	return "modifier_item_hd_advanced_Claw_of_attack"
end


modifier_item_hd_advanced_Claw_of_attack = class({})

function modifier_item_hd_advanced_Claw_of_attack:IsDebuff() return false end
function modifier_item_hd_advanced_Claw_of_attack:IsHidden() return true end
function modifier_item_hd_advanced_Claw_of_attack:IsPurgable() return false end
function modifier_item_hd_advanced_Claw_of_attack:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end



function modifier_item_hd_advanced_Claw_of_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
	
	}
end


function modifier_item_hd_advanced_Claw_of_attack:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
