LinkLuaModifier("modifier_item_chaotic_jack_the_rippers_claw", "items/item_chaotic_jack_the_rippers_claw.lua", LUA_MODIFIER_MOTION_NONE)
item_chaotic_jack_the_rippers_claw = class({})

function item_chaotic_jack_the_rippers_claw:GetIntrinsicModifierName()
    return "modifier_item_chaotic_jack_the_rippers_claw"
end

-------------------
modifier_item_chaotic_jack_the_rippers_claw = advanced_modifier({})

function modifier_item_chaotic_jack_the_rippers_claw:OnCreated(table)
    self.steal = self:GetAbility():GetSpecialValueFor("steal")
    self.outgoing_add = self:GetAbility():GetSpecialValueFor("outgoing_add")
end

function modifier_item_chaotic_jack_the_rippers_claw:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
    }
end
function modifier_item_chaotic_jack_the_rippers_claw:IsHidden()
    return true
end

function modifier_item_chaotic_jack_the_rippers_claw:IsPurgable()
    return false
end

function modifier_item_chaotic_jack_the_rippers_claw:Advanced_GetModifier_LifeSteal_AttackDamage()
    return self.steal
end
function modifier_item_chaotic_jack_the_rippers_claw:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self.outgoing_add
end
