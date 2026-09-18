item_hd_the_leveller = class({})
LinkLuaModifier("modifier_item_hd_the_leveller", "items/item_hd_the_leveller", LUA_MODIFIER_MOTION_NONE)

function item_hd_the_leveller:GetIntrinsicModifierName()
	return "modifier_item_hd_the_leveller"
end

function item_hd_the_leveller:OnSpellStart()
	local target = self:GetCaster()
	local equip = self
	local cost = self:GetSpecialValueFor("upgrade_cost")
	local max_lvl = self:GetSpecialValueFor("max_lvl")
	
	if self:GetCaster():GetGold() < cost then return end
	EquipUpgrade(target,equip,cost,max_lvl)
end

modifier_item_hd_the_leveller = advanced_modifier({})

function modifier_item_hd_the_leveller:IsDebuff() return false end
function modifier_item_hd_the_leveller:IsHidden() return true end
function modifier_item_hd_the_leveller:IsPurgable() return false end
function modifier_item_hd_the_leveller:OnCreated(keys)
    self.ability = self:GetAbility()
end
function modifier_item_hd_the_leveller:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end
function modifier_item_hd_the_leveller:GetModifierAttackSpeedBonus_Constant() 	return self.ability:GetSpecialValueFor("bonus_attack_speed") end

