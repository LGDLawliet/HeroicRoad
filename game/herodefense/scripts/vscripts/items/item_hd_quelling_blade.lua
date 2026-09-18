item_hd_quelling_blade = class({})
LinkLuaModifier("modifier_item_hd_quelling_blade", "items/item_hd_quelling_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_quelling_blade_active", "items/item_hd_quelling_blade", LUA_MODIFIER_MOTION_NONE)

function item_hd_quelling_blade:GetIntrinsicModifierName()
	return "modifier_item_hd_quelling_blade"
end
-------------------------------------------------------------------

modifier_item_hd_quelling_blade = class({})

function modifier_item_hd_quelling_blade:IsDebuff() return false end
function modifier_item_hd_quelling_blade:IsHidden() return true end
function modifier_item_hd_quelling_blade:IsPurgable() return false end

function modifier_item_hd_quelling_blade:OnCreated(keys)
    self.ability = self:GetAbility()
	local parent = self:GetParent()
	self.damage_deal = self.ability:GetSpecialValueFor("damage_deal")
    if IsServer() then
		self.prop_chance = self.ability:GetSpecialValueFor("prop_chance")
	end
	self:StartIntervalThink(1)
end

function modifier_item_hd_quelling_blade:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_Focus_Fire") or self:GetCaster():FindAbilityByName("Middle_Focus_Fire") or self:GetCaster():FindAbilityByName("Advanced_Focus_Fire") or self:GetCaster():FindAbilityByName("Primary_overpower") or self:GetCaster():FindAbilityByName("Middle_overpower") or self:GetCaster():FindAbilityByName("Advanced_overpower")then
		self.prop_chance = self.ability:GetSpecialValueFor("prop_chance_override")
	else
		self.prop_chance = self.ability:GetSpecialValueFor("prop_chance")
	end
end

function modifier_item_hd_quelling_blade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, --额外物理伤害
	}
end


function modifier_item_hd_quelling_blade:GetModifierPreAttack_BonusDamagePostCrit(params) 
	if self:GetCaster():GetRandomEffect(self.prop_chance,INT_TYPE,1) >=RandomInt(1, 100) then
		return self.damage_deal
	end
	return 0
end




