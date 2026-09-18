LinkLuaModifier("modifier_item_hd_madstone_bundle", "items/item_hd_madstone_bundle", LUA_MODIFIER_MOTION_NONE)
item_hd_madstone_bundle = class({})

function item_hd_madstone_bundle:GetIntrinsicModifierName()
    return "modifier_item_hd_madstone_bundle"
end

---------------------------------------------------------------------
modifier_item_hd_madstone_bundle = advanced_modifier({})

function modifier_item_hd_madstone_bundle:IsHidden()return true end
function modifier_item_hd_madstone_bundle:IsPurgable()return false end

function modifier_item_hd_madstone_bundle:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.atb = self.ability:GetSpecialValueFor("atb")
    self.profic = self.ability:GetSpecialValueFor("profic")
end

-- function modifier_item_hd_madstone_bundle:DeclareFunctions()
--     return{
--         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
--     }
-- end

function modifier_item_hd_madstone_bundle:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN
    }
end

function modifier_item_hd_madstone_bundle:Advanced_GetModifierBonusStats_Strength()
    return self.atb
end
function modifier_item_hd_madstone_bundle:Advanced_GetModifierBonusStats_Agility()
    return  self.atb
end
function modifier_item_hd_madstone_bundle:Advanced_GetModifierBonusStats_Intellect()
    return self.atb
end
function modifier_item_hd_madstone_bundle:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end



