item_chaotic_blink_agi = class({})
LinkLuaModifier("modifier_item_chaotic_blink_agi", "items/item_chaotic_blink_agi", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_blink_agi:GetIntrinsicModifierName()
    return "modifier_item_chaotic_blink_agi"
end
---------------------------------
modifier_item_chaotic_blink_agi = advanced_modifier({})
function modifier_item_chaotic_blink_agi:IsDebuff() return false end
function modifier_item_chaotic_blink_agi:IsHidden() return true end
function modifier_item_chaotic_blink_agi:IsPurgable() return false end
function modifier_item_chaotic_blink_agi:GetPriority() return 499 end
function modifier_item_chaotic_blink_agi:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
    self.cd = self.ability:GetSpecialValueFor("cd")*0.01
    self.change = self.ability:GetSpecialValueFor("change")*0.01

    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end
function modifier_item_chaotic_blink_agi:OnIntervalThink(keys)
    if not self:GetAbility() then self:Destroy() return end
    if self.parent:HasModifier("modifier_item_chaotic_blink_str") then self:SetStackCount(self.bonus_agi) return end
    self:SetStackCount((self.parent:GetStrength() + self.parent:GetIntellect(false))*self.change + self.bonus_agi)
end
function modifier_item_chaotic_blink_agi:OnDestroy(keys)
    self:SetStackCount(0)
end
function modifier_item_chaotic_blink_agi:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_AGI,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS
    }
end
function modifier_item_chaotic_blink_agi:Advanced_GetModifier_PrimaryAttributeOverride_Agi()
    return 1
end
function modifier_item_chaotic_blink_agi:Advanced_GetModifierBonusStats_Agility()
    if not self:GetAbility() then self:Destroy() return 0 end
	return self:GetStackCount()
end
