item_hd_boots = class({})

LinkLuaModifier("modifier_item_hd_boots", "items/item_hd_boots", LUA_MODIFIER_MOTION_NONE)

function item_hd_boots:GetIntrinsicModifierName()
	return "modifier_item_hd_boots"
end



modifier_item_hd_boots = advanced_modifier({})

function modifier_item_hd_boots:IsDebuff() return false end
function modifier_item_hd_boots:IsHidden() return true end
function modifier_item_hd_boots:IsPurgable() return false end


function modifier_item_hd_boots:OnCreated(keys)
    self.ability = self:GetAbility()

    local parent = self:GetParent()
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self:StartIntervalThink(1)
end

function modifier_item_hd_boots:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_bulldoze") or self:GetCaster():FindAbilityByName("Middle_bulldoze") or self:GetCaster():FindAbilityByName("Advanced_bulldoze") then
		self.bonus_move = self.ability:GetSpecialValueFor("bonus_move") + self.ability:GetSpecialValueFor("bonus_move_extra")
	else
		self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	end
end

function modifier_item_hd_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	}
end


function modifier_item_hd_boots:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end

