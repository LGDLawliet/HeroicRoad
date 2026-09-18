LinkLuaModifier("modifier_item_chaotic_secret_of_summon", "items/item_chaotic_secret_of_summon", LUA_MODIFIER_MOTION_NONE)
item_chaotic_secret_of_summon = class({})

function item_chaotic_secret_of_summon:GetIntrinsicModifierName()
    return "modifier_item_chaotic_secret_of_summon"
end

---------------------------------------------------------------------
modifier_item_chaotic_secret_of_summon = advanced_modifier({})

function modifier_item_chaotic_secret_of_summon:IsHidden()return true end
function modifier_item_chaotic_secret_of_summon:IsPurgable()return false end

function modifier_item_chaotic_secret_of_summon:OnCreated()
    self.bonus_summon = self:GetAbility():GetSpecialValueFor("bonus_summon")
end

function modifier_item_chaotic_secret_of_summon:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end

function modifier_item_chaotic_secret_of_summon:Advanced_GetModifier_Summon_Intensity()
    return self.bonus_summon
end



