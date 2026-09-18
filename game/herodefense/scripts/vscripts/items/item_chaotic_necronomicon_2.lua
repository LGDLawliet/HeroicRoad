item_chaotic_necronomicon_2 = class({})

LinkLuaModifier("modifier_item_chaotic_necronomicon_2", "items/item_chaotic_necronomicon_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_necronomicon_2_summon", "items/item_chaotic_necronomicon_2", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_necronomicon_2:GetIntrinsicModifierName()
    return "modifier_item_chaotic_necronomicon_2"
end

modifier_item_chaotic_necronomicon_2 = advanced_modifier({})

function modifier_item_chaotic_necronomicon_2:IsDebuff() return false end
function modifier_item_chaotic_necronomicon_2:IsHidden() return true end
function modifier_item_chaotic_necronomicon_2:IsPurgable() return false end

function modifier_item_chaotic_necronomicon_2:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.bonus_summon_time_intensity = self.ability:GetSpecialValueFor("bonus_summon_time_intensity")
end

function modifier_item_chaotic_necronomicon_2:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
        MODIFIER_EVENT_ON_SUMMON = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_necronomicon_2:Advanced_GetModifier_SummonTime_Intensity()
    return self.bonus_summon_time_intensity
end

function modifier_item_chaotic_necronomicon_2:AdvancedOnSummon(keys)
    if not IsServer() then return end
    if keys.unit ~= self.parent then return end
    if not IsValid(keys.target) then return end
    -- 给召唤物附加后卫强化效果
    keys.target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_necronomicon_2_summon", {})
end

--------------------------------------------------------------------------------
-- 召唤物效果：造成伤害增加；第一次攻击命中时对目标施加一次弱驱散
modifier_item_chaotic_necronomicon_2_summon = advanced_modifier({})

function modifier_item_chaotic_necronomicon_2_summon:IsDebuff() return false end
function modifier_item_chaotic_necronomicon_2_summon:IsHidden() return true end
function modifier_item_chaotic_necronomicon_2_summon:IsPurgable() return false end
function modifier_item_chaotic_necronomicon_2_summon:RemoveOnDeath() return false end

function modifier_item_chaotic_necronomicon_2_summon:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()

    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_necronomicon_2_summon:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_necronomicon_2_summon:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.outgoing
end

function modifier_item_chaotic_necronomicon_2_summon:OnAttackLanded(keys)
    if not IsServer() then return end
    if not self:GetAbility() then self:Destroy() return end
    
    if keys.attacker ~= self.parent then return end
    local target = keys.target
    if not IsValid(target) then return end
    if target.first_hit_done then return end

    target:Purge(true, false, false, false, false)
    target.first_hit_done = true
end


