item_chaotic_amulet = class({})

LinkLuaModifier("modifier_item_chaotic_amulet", "items/item_chaotic_amulet", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_amulet:GetIntrinsicModifierName()
	return "modifier_item_chaotic_amulet"
end





modifier_item_chaotic_amulet = advanced_modifier({})

function modifier_item_chaotic_amulet:IsDebuff() return false end
function modifier_item_chaotic_amulet:IsHidden() return true end
function modifier_item_chaotic_amulet:IsPurgable() 		return false end
function modifier_item_chaotic_amulet:IsPurgeException() 	return false end
function modifier_item_chaotic_amulet:RemoveOnDeath()  return false end

function modifier_item_chaotic_amulet:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_cd  = self.ability:GetSpecialValueFor("bonus_cd")
end

function modifier_item_chaotic_amulet:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_item_chaotic_amulet:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cd
end






