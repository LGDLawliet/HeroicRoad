LinkLuaModifier("modifier_item_chaotic_ogre_axe", "items/item_chaotic_ogre_axe", LUA_MODIFIER_MOTION_NONE)
item_chaotic_ogre_axe = class({})

function item_chaotic_ogre_axe:GetIntrinsicModifierName()
    return "modifier_item_chaotic_ogre_axe"
end

---------------------------------------------------------------------
modifier_item_chaotic_ogre_axe = advanced_modifier({})

function modifier_item_chaotic_ogre_axe:IsHidden()return true end
function modifier_item_chaotic_ogre_axe:IsPurgable()return false end

function modifier_item_chaotic_ogre_axe:OnCreated()
    self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_beheal_amp = self:GetAbility():GetSpecialValueFor("bonus_beheal_amp")
end

function modifier_item_chaotic_ogre_axe:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS
    }
end

function modifier_item_chaotic_ogre_axe:AdvancedGetModifierHealthBonus()
    return  self.bonus_hp
end
function modifier_item_chaotic_ogre_axe:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_chaotic_ogre_axe:Advanced_GetModifierHealReceiveAMP_Percentage()
    return self.bonus_beheal_amp
end



