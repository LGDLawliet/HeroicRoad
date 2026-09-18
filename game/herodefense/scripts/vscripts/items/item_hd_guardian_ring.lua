item_hd_guardian_ring = class({})

LinkLuaModifier("modifier_item_hd_guardian_ring", "items/item_hd_guardian_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_guardian_ring_active", "items/item_hd_guardian_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_guardian_ring_active2", "items/item_hd_guardian_ring", LUA_MODIFIER_MOTION_NONE)



function item_hd_guardian_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_guardian_ring"
end

-----------------------------------------------------------------------------------------------------------------------
modifier_item_hd_guardian_ring = advanced_modifier({})

function modifier_item_hd_guardian_ring:IsDebuff() return false end
function modifier_item_hd_guardian_ring:IsHidden() return true end
function modifier_item_hd_guardian_ring:IsPurgable() return false end
function modifier_item_hd_guardian_ring:IsPurgeException()return false end
function modifier_item_hd_guardian_ring:RemoveOnDeath() return false end

function modifier_item_hd_guardian_ring:OnCreated()
    self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_mana_perlvl = self:GetAbility():GetSpecialValueFor("bonus_mana_perlvl")
end

function modifier_item_hd_guardian_ring:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
    }
end
function modifier_item_hd_guardian_ring:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end
function modifier_item_hd_guardian_ring:AdvancedGetModifierManaBonus()
    return self.bonus_mana_perlvl*self:GetParent():GetLevel()
end