LinkLuaModifier("modifier_item_chaotic_book_of_torture", "items/item_chaotic_book_of_torture", LUA_MODIFIER_MOTION_NONE)
item_chaotic_book_of_torture = class({})

function item_chaotic_book_of_torture:GetIntrinsicModifierName()
    return "modifier_item_chaotic_book_of_torture"
end

---------------------------------------------------------------------
modifier_item_chaotic_book_of_torture = advanced_modifier({})

function modifier_item_chaotic_book_of_torture:IsHidden()return true end
function modifier_item_chaotic_book_of_torture:IsPurgable()return false end

function modifier_item_chaotic_book_of_torture:OnCreated()
    self.outgoing_add = self:GetAbility():GetSpecialValueFor("outgoing_add")
end

function modifier_item_chaotic_book_of_torture:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_item_chaotic_book_of_torture:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self.outgoing_add
end




