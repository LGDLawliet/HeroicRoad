  
item_hd_gloves = class({})
LinkLuaModifier("modifier_item_hd_gloves", "items/item_hd_gloves", LUA_MODIFIER_MOTION_NONE)

function item_hd_gloves:GetIntrinsicModifierName()
	return "modifier_item_hd_gloves"
end

-------------加速手套lua-------------------------

modifier_item_hd_gloves = advanced_modifier({})

function modifier_item_hd_gloves:IsDebuff() return false end
function modifier_item_hd_gloves:IsHidden() return true end
function modifier_item_hd_gloves:IsPurgable() return false end


function modifier_item_hd_gloves:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")

	self:StartIntervalThink(1)
end

function modifier_item_hd_gloves:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_Blood_grudge_Dagger") or self:GetCaster():FindAbilityByName("Middle_Blood_grudge_Dagger") or self:GetCaster():FindAbilityByName("Advanced_Blood_grudge_Dagger") or self:GetCaster():FindAbilityByName("Primary_Poison_Sting") or self:GetCaster():FindAbilityByName("Middle_Poison_Sting") or self:GetCaster():FindAbilityByName("Advanced_Poison_Sting") then
		self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed") +self.ability:GetSpecialValueFor("bonus_attack_speed_extra")
	else
		self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_item_hd_gloves:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end

function modifier_item_hd_gloves:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end