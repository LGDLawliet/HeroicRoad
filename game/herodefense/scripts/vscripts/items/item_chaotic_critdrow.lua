item_chaotic_critdrow = class({})

LinkLuaModifier("modifier_item_chaotic_critdrow", "items/item_chaotic_critdrow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_critdrow_active", "items/item_chaotic_critdrow", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_critdrow:GetIntrinsicModifierName()
    return "modifier_item_chaotic_critdrow"
end

--------------------------------------------------------------------------------
modifier_item_chaotic_critdrow = advanced_modifier({})

function modifier_item_chaotic_critdrow:IsDebuff() return false end
function modifier_item_chaotic_critdrow:IsHidden() return true end
function modifier_item_chaotic_critdrow:IsPurgable() return false end

function modifier_item_chaotic_critdrow:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
    self.crit_mult = self.ability:GetSpecialValueFor("crit_mult")
    self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_chaotic_critdrow:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_critdrow:Advanced_GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_item_chaotic_critdrow:Advanced_GetModifierCriticalStrike(keys)
    if not IsServer() then return end
    if keys.attacker ~= self.parent then return end
    local target = keys.target
    local random = math.random

    if self.crit_chance >= random(1, 100) then
        EmitSoundOn( "Hero_Juggernaut.BladeDance", target )
        return self.crit_mult
    end
end

function modifier_item_chaotic_critdrow:AdvancedOnCriticalStrikeTrigger(keys)
    if not IsServer() then return end
    if keys.attacker ~= self.parent then return end
    -- 致命一击时获得攻强buff
    local modifier = self.parent:FindModifierByName("modifier_item_chaotic_critdrow_active")
    if modifier then
        modifier:ForceRefresh()
        modifier:SetDuration(self.duration, true)
    else
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_critdrow_active", { duration = self.duration })
    end
end

--------------------------------------------------------------------------------
modifier_item_chaotic_critdrow_active = advanced_modifier({})

function modifier_item_chaotic_critdrow_active:IsDebuff() return false end
function modifier_item_chaotic_critdrow_active:IsHidden() return false end
function modifier_item_chaotic_critdrow_active:IsPurgable() return true end

function modifier_item_chaotic_critdrow_active:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.attack = self.ability:GetSpecialValueFor("attack")
end

function modifier_item_chaotic_critdrow_active:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_item_chaotic_critdrow_active:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.attack
end


