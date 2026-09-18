item_chaotic_crown_alter = class({})
LinkLuaModifier("modifier_item_chaotic_crown_alter", "items/item_chaotic_crown_alter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_crown_alter_active", "items/item_chaotic_crown_alter", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_crown_alter:GetIntrinsicModifierName()
	return "modifier_item_chaotic_crown_alter"
end
---------------------------------
modifier_item_chaotic_crown_alter = advanced_modifier({})
function modifier_item_chaotic_crown_alter:IsDebuff() return false end
function modifier_item_chaotic_crown_alter:IsHidden() return true end
function modifier_item_chaotic_crown_alter:IsPurgable() return false end

function modifier_item_chaotic_crown_alter:OnCreated(keys)
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
	self.bonus_outgoing_add = self.ability:GetSpecialValueFor("bonus_outgoing_add")
    self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_chaotic_crown_alter:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_RESPAWN, 
	}
end

function modifier_item_chaotic_crown_alter:ADDeclareFunctions()
	return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_item_chaotic_crown_alter:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self.bonus_outgoing_add
end

function modifier_item_chaotic_crown_alter:OnRespawn(keys)
    if not IsServer() then return end
    local unit = keys.unit

    if unit == self.parent and self.ability:IsCooldownReady() then
        local duration = self.duration*unit:GetModifierDurationGainIndex(0.5)
        unit:AddNewModifier(unit, self.ability, "modifier_item_chaotic_crown_alter_active", {duration = duration}) 
        self.ability:UseResources(true, true, true, true)
    end
end

modifier_item_chaotic_crown_alter_active = advanced_modifier({})
function modifier_item_chaotic_crown_alter_active:IsHidden() return false end
function modifier_item_chaotic_crown_alter_active:IsPurgable() return false end
function modifier_item_chaotic_crown_alter_active:OnCreated(keys)
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end
function modifier_item_chaotic_crown_alter_active:ADDeclareFunctions()
	return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end

function modifier_item_chaotic_crown_alter_active:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then self:Destroy() return end
    return self.outgoing
end