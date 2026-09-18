LinkLuaModifier("modifier_item_chaotic_magic_wand", "items/item_chaotic_magic_wand", LUA_MODIFIER_MOTION_NONE)
item_chaotic_magic_wand = class({})

function item_chaotic_magic_wand:GetIntrinsicModifierName()
    return "modifier_item_chaotic_magic_wand"
end

---------------------------------------------------------------------
modifier_item_chaotic_magic_wand = advanced_modifier({})

function modifier_item_chaotic_magic_wand:IsHidden()return true end
function modifier_item_chaotic_magic_wand:IsPurgable()return false end

function modifier_item_chaotic_magic_wand:OnCreated()
    self.bonus_cd = self:GetAbility():GetSpecialValueFor("bonus_cd")
    self.bonus_heal_amp = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
end

function modifier_item_chaotic_magic_wand:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE
    }
end

function modifier_item_chaotic_magic_wand:Advanced_GetModifierCooldownReduction()
    return self.bonus_cd
end
function modifier_item_chaotic_magic_wand:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end



