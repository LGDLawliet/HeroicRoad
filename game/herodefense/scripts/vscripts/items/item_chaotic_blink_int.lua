item_chaotic_blink_int = class({})
LinkLuaModifier("modifier_item_chaotic_blink_int", "items/item_chaotic_blink_int", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_blink_int:GetIntrinsicModifierName()
    return "modifier_item_chaotic_blink_int"
end
---------------------------------
modifier_item_chaotic_blink_int = advanced_modifier({})
function modifier_item_chaotic_blink_int:IsDebuff() return false end
function modifier_item_chaotic_blink_int:IsHidden() return true end
function modifier_item_chaotic_blink_int:IsPurgable() return false end
function modifier_item_chaotic_blink_int:GetPriority() return 498 end
function modifier_item_chaotic_blink_int:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
    self.cd = self.ability:GetSpecialValueFor("cd")*0.01
    self.change = self.ability:GetSpecialValueFor("change")*0.01

    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end
function modifier_item_chaotic_blink_int:OnIntervalThink(keys)
    if not self:GetAbility() then self:Destroy() return end
    if self.parent:HasModifier("modifier_item_chaotic_blink_str") then self:SetStackCount(self.bonus_int) return end
    if self.parent:HasModifier("modifier_item_chaotic_blink_agi") then self:SetStackCount(self.bonus_int) return end
    self:SetStackCount((self.parent:GetStrength() + self.parent:GetAgility())*self.change + self.bonus_int)
end
function modifier_item_chaotic_blink_int:OnDestroy(keys)
    self:SetStackCount(0)
end
function modifier_item_chaotic_blink_int:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_INT,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end
function modifier_item_chaotic_blink_int:Advanced_GetModifier_PrimaryAttributeOverride_Int()
    return 1
end
function modifier_item_chaotic_blink_int:Advanced_GetModifierBonusStats_Intellect()
    if not self:GetAbility() then self:Destroy() return 0 end
	return self:GetStackCount()
end
