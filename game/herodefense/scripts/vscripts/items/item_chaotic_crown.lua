item_chaotic_crown = class({})
LinkLuaModifier("modifier_item_chaotic_crown", "items/item_chaotic_crown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_crown_invalid", "items/item_chaotic_crown", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_crown:GetIntrinsicModifierName()
	return "modifier_item_chaotic_crown"
end
---------------------------------
modifier_item_chaotic_crown = advanced_modifier({})
function modifier_item_chaotic_crown:IsDebuff() return false end
function modifier_item_chaotic_crown:IsHidden() return self:GetStackCount() ~= 0 end
function modifier_item_chaotic_crown:IsPurgable() return false end

function modifier_item_chaotic_crown:OnCreated(keys)
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
	self.bonus_outgoing_mult = self.ability:GetSpecialValueFor("bonus_outgoing_mult")
    self.atb = self.ability:GetSpecialValueFor("atb")

    if self.parent:HasModifier("modifier_item_chaotic_crown_invalid") then
        self:SetStackCount(1)
    else
        self:SetStackCount(0)
    end
end
function modifier_item_chaotic_crown:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_RESPAWN, -- 新增监听复活
	}
end
function modifier_item_chaotic_crown:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
        return self:Advanced_GetModifierBonusStats_Strength()
    end
end
function modifier_item_chaotic_crown:ADDeclareFunctions()
	return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()}
	}
end
function modifier_item_chaotic_crown:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self.bonus_outgoing_mult
end
function modifier_item_chaotic_crown:Advanced_GetModifierBonusStats_Strength()
    if self:GetStackCount() == 0 then
        return self.atb*self.parent:GetLevel()
    end
    return 0
end
function modifier_item_chaotic_crown:Advanced_GetModifierBonusStats_Agility()
    if self:GetStackCount() == 0 then
        return self.atb*self.parent:GetLevel()
    end
    return 0
end
function modifier_item_chaotic_crown:Advanced_GetModifierBonusStats_Intellect()
    if self:GetStackCount() == 0 then
        return self.atb*self.parent:GetLevel()
    end
    return 0
end

function modifier_item_chaotic_crown:OnDeath(keys)
    if not IsServer() then return end
    local unit = keys.unit

    if unit == self.parent then
        if not self.parent:HasModifier("modifier_item_chaotic_crown_invalid") then
            self.parent._need_chaotic_crown_invalid = true
        end
        self:SetStackCount(1)
    end
end

function modifier_item_chaotic_crown:OnRespawn(keys)
    if not IsServer() then return end
    local unit = keys.unit

    if unit == self.parent and self.parent._need_chaotic_crown_invalid then
        if not self.parent:HasModifier("modifier_item_chaotic_crown_invalid") then
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_crown_invalid", {})
        end
        self.parent._need_chaotic_crown_invalid = nil
        self:SetStackCount(1)
    end
end

modifier_item_chaotic_crown_invalid = class({})
function modifier_item_chaotic_crown_invalid:IsHidden() return true end
function modifier_item_chaotic_crown_invalid:IsPurgable() return false end
function modifier_item_chaotic_crown_invalid:RemoveOnDeath() return false end