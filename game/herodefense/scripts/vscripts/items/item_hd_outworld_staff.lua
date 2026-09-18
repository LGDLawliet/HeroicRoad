LinkLuaModifier("modifier_item_hd_outworld_staff", "items/item_hd_outworld_staff", LUA_MODIFIER_MOTION_NONE)
item_hd_outworld_staff = class({})

function item_hd_outworld_staff:GetIntrinsicModifierName()
    return "modifier_item_hd_outworld_staff"
end

---------------------------------------------------------------------
modifier_item_hd_outworld_staff = advanced_modifier({})

function modifier_item_hd_outworld_staff:IsHidden()return true end
function modifier_item_hd_outworld_staff:IsPurgable()return false end

function modifier_item_hd_outworld_staff:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.line = self.ability:GetSpecialValueFor("line")
    self.profic = self.ability:GetSpecialValueFor("profic")
    self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
    self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")
    self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
    self.mana = self.ability:GetSpecialValueFor("mana")
    self.mana_cost = self.ability:GetSpecialValueFor("mana_cost")*0.01

    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end

function modifier_item_hd_outworld_staff:OnIntervalThink()
    self:SetStackCount(0)
    if self.parent:GetManaPercent() >= self.line then
        self.parent:Script_ReduceMana(self.parent:GetMana()*self.mana_cost, self.ability)
        self:SetStackCount(1)
    end
end

function modifier_item_hd_outworld_staff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN
    }
end

function modifier_item_hd_outworld_staff:AdvancedGetModifierManaBonus(keys)
	return self.mana
end
function modifier_item_hd_outworld_staff:Advanced_GetModifierSpellAmplifyBonus()
    return self.spell_amp + self.bonus_spell_amp*self:GetStackCount()
end
function modifier_item_hd_outworld_staff:Advanced_GetModifier_TalentEffectGain()
    return self.profic + self.bonus_profic*self:GetStackCount()
end


