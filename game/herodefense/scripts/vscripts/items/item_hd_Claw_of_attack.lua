item_hd_Claw_of_attack = class({})

LinkLuaModifier("modifier_item_hd_Claw_of_attack", "items/item_hd_Claw_of_attack", LUA_MODIFIER_MOTION_NONE)

function item_hd_Claw_of_attack:GetIntrinsicModifierName()
	return "modifier_item_hd_Claw_of_attack"
end


modifier_item_hd_Claw_of_attack = advanced_modifier({})

function modifier_item_hd_Claw_of_attack:IsDebuff() return false end
function modifier_item_hd_Claw_of_attack:IsHidden() return true end
function modifier_item_hd_Claw_of_attack:IsPurgable() return false end

function modifier_item_hd_Claw_of_attack:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_damage_extra =self:GetAbility():GetSpecialValueFor("bonus_damage_extra")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_item_hd_Claw_of_attack:OnIntervalThink(keys)
	if self:GetCaster():HasAbility("Primary_enchant_totem") or self:GetCaster():HasAbility("Middle_enchant_totem") or self:GetCaster():HasAbility("Advanced_enchant_totem") then
		self:SetStackCount(1)
		-- self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage") + self:GetAbility():GetSpecialValueFor("bonus_damage_extra")
	else
		self:SetStackCount(0)
		-- self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_hd_Claw_of_attack:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end
function modifier_item_hd_Claw_of_attack:Advanced_GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage + self:GetStackCount()*self.bonus_damage_extra
end