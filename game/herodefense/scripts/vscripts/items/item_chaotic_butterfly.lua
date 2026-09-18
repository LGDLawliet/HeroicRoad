item_chaotic_butterfly = class({})
LinkLuaModifier("modifier_item_chaotic_butterfly", "items/item_chaotic_butterfly", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_butterfly:GetIntrinsicModifierName()
    return "modifier_item_chaotic_butterfly"
end
---------------------------------
modifier_item_chaotic_butterfly = advanced_modifier({})
function modifier_item_chaotic_butterfly:IsDebuff() return false end
function modifier_item_chaotic_butterfly:IsHidden() return false end
function modifier_item_chaotic_butterfly:IsPurgable() return false end

function modifier_item_chaotic_butterfly:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
    self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
    self.eva_attack = self.ability:GetSpecialValueFor("eva_attack")
    self.eva_attack_speed = self.ability:GetSpecialValueFor("eva_attack_speed")

    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end
function modifier_item_chaotic_butterfly:OnIntervalThink()
    self:SetStackCount(self.parent:GetEvasion()*100)
end

function modifier_item_chaotic_butterfly:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_chaotic_butterfly:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end
function modifier_item_chaotic_butterfly:Advanced_GetModifierPreAttack_BonusDamage()
    return self.bonus_damage + self:GetStackCount()*self.eva_attack
end
function modifier_item_chaotic_butterfly:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack + self:GetStackCount()*self.eva_attack_speed
end
function modifier_item_chaotic_butterfly:GetModifierEvasion_Constant()
    return self.bonus_evasion
end
function modifier_item_chaotic_butterfly:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierPreAttack_BonusDamage()
    end
    if self._tooltip == 2 then
        return self:GetModifierAttackSpeedBonus_Constant()
    end
end