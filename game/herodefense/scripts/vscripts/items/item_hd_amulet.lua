item_hd_amulet = class({})

LinkLuaModifier("modifier_item_hd_amulet", "items/item_hd_amulet", LUA_MODIFIER_MOTION_NONE)

function item_hd_amulet:GetIntrinsicModifierName()
	return "modifier_item_hd_amulet"
end





modifier_item_hd_amulet = advanced_modifier({})

function modifier_item_hd_amulet:IsDebuff() return false end
function modifier_item_hd_amulet:IsHidden() return true end
function modifier_item_hd_amulet:IsPurgable() 		return false end
function modifier_item_hd_amulet:IsPurgeException() 	return false end
function modifier_item_hd_amulet:RemoveOnDeath()  return false end

function modifier_item_hd_amulet:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()

	self.bonus_cooldown  = self.ability:GetSpecialValueFor("bonus_cooldown")

    self:StartIntervalThink(1)

end

function modifier_item_hd_amulet:OnIntervalThink(keys)
    if self:GetCaster():FindAbilityByName("Primary_Bad_Juju") or self:GetCaster():FindAbilityByName("Middle_Bad_Juju") or self:GetCaster():FindAbilityByName("Advanced_Bad_Juju") then
        self.bonus_cooldown  = self.ability:GetSpecialValueFor("bonus_cooldown") + self.ability:GetSpecialValueFor("bonus_cooldown_extra")
    else
        self.bonus_cooldown  = self.ability:GetSpecialValueFor("bonus_cooldown")
    end
end

function modifier_item_hd_amulet:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_item_hd_amulet:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end






