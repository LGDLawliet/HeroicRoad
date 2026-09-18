item_chaotic_blink_str = class({})
LinkLuaModifier("modifier_item_chaotic_blink_str", "items/item_chaotic_blink_str", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_blink_str:GetIntrinsicModifierName()
    return "modifier_item_chaotic_blink_str"
end
---------------------------------
modifier_item_chaotic_blink_str = advanced_modifier({})
function modifier_item_chaotic_blink_str:IsDebuff() return false end
function modifier_item_chaotic_blink_str:IsHidden() return true end
function modifier_item_chaotic_blink_str:IsPurgable() return false end
function modifier_item_chaotic_blink_str:GetPriority() return 500 end
function modifier_item_chaotic_blink_str:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
    self.cd = self.ability:GetSpecialValueFor("cd")*0.01
    self.change = self.ability:GetSpecialValueFor("change")*0.01

    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end
function modifier_item_chaotic_blink_str:OnIntervalThink(keys)
    if not self:GetAbility() then self:Destroy() return end
    self:SetStackCount((self.parent:GetAgility() + self.parent:GetIntellect(false))*self.change + self.bonus_str)
end
function modifier_item_chaotic_blink_str:OnDestroy(keys)
    self:SetStackCount(0)
end
function modifier_item_chaotic_blink_str:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_STR,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
end
function modifier_item_chaotic_blink_str:Advanced_GetModifier_PrimaryAttributeOverride_Str()
    return 1
end
function modifier_item_chaotic_blink_str:Advanced_GetModifierBonusStats_Strength()
    if not self:GetAbility() then self:Destroy() return 0 end
	return self:GetStackCount()
end
