item_hd_demon_edge = class({})

LinkLuaModifier("modifier_item_hd_demon_edge", "items/item_hd_demon_edge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_demon_edge_active", "items/item_hd_demon_edge", LUA_MODIFIER_MOTION_NONE)

function item_hd_demon_edge:GetIntrinsicModifierName()
	return "modifier_item_hd_demon_edge"
end

modifier_item_hd_demon_edge = advanced_modifier({})

function modifier_item_hd_demon_edge:IsDebuff() return false end
function modifier_item_hd_demon_edge:IsHidden() return true end
function modifier_item_hd_demon_edge:IsPurgable() return false end

function modifier_item_hd_demon_edge:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_no_armor = self.ability:GetSpecialValueFor("bonus_no_armor")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	
end

function modifier_item_hd_demon_edge:Advanced_GetModifierAttackArmor_Ignore() return self.bonus_no_armor end

function modifier_item_hd_demon_edge:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,  --攻击忽略护甲
    }
end
