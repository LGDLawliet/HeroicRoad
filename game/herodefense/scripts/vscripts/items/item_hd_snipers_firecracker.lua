item_hd_snipers_firecracker = class({})
LinkLuaModifier("modifier_item_hd_snipers_firecracker", "items/item_hd_snipers_firecracker", LUA_MODIFIER_MOTION_NONE)

function item_hd_snipers_firecracker:GetIntrinsicModifierName()
	return "modifier_item_hd_snipers_firecracker"
end

modifier_item_hd_snipers_firecracker = advanced_modifier({})

function modifier_item_hd_snipers_firecracker:IsDebuff() return false end
function modifier_item_hd_snipers_firecracker:IsHidden() return true end
function modifier_item_hd_snipers_firecracker:IsPurgable() return false end


function modifier_item_hd_snipers_firecracker:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()

	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
    self:StartIntervalThink(1)
end

function modifier_item_hd_snipers_firecracker:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_split_shot") or self:GetCaster():FindAbilityByName("Middle_split_shot") or self:GetCaster():FindAbilityByName("Advanced_split_shot") then
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range") +self.ability:GetSpecialValueFor("bonus_attack_range_extra")
    else
        self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
    end
end
function modifier_item_hd_snipers_firecracker:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end

function modifier_item_hd_snipers_firecracker:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.bonus_attack_range or 0 end
