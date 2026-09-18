LinkLuaModifier("modifier_item_chaotic_nether_shawl", "items/item_chaotic_nether_shawl", LUA_MODIFIER_MOTION_NONE)
item_chaotic_nether_shawl = class({})

function item_chaotic_nether_shawl:GetIntrinsicModifierName()
    return "modifier_item_chaotic_nether_shawl"
end

---------------------------------------------------------------------
modifier_item_chaotic_nether_shawl = advanced_modifier({})

function modifier_item_chaotic_nether_shawl:IsHidden()return true end
function modifier_item_chaotic_nether_shawl:IsPurgable()return false end

function modifier_item_chaotic_nether_shawl:OnCreated()
    self.outgoing_add = self:GetAbility():GetSpecialValueFor("outgoing_add")
    self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
end

function modifier_item_chaotic_nether_shawl:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end


function modifier_item_chaotic_nether_shawl:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return  self.outgoing_add
end
function modifier_item_chaotic_nether_shawl:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end




