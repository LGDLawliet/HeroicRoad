item_set_asasin_blade = class({})
LinkLuaModifier("modifier_item_set_asasin_blade", "items/item_set_asasin_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_set_asasin_blade_already", "items/item_set_asasin_blade", LUA_MODIFIER_MOTION_NONE)
function item_set_asasin_blade:GetIntrinsicModifierName()
	return "modifier_item_set_asasin_blade"
end


modifier_item_set_asasin_blade = advanced_modifier({})

function modifier_item_set_asasin_blade:IsDebuff() return false end
function modifier_item_set_asasin_blade:IsHidden() return true end
function modifier_item_set_asasin_blade:IsPurgable() return false end

function modifier_item_set_asasin_blade:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_set_asasin_blade:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil}
    }
end

function modifier_item_set_asasin_blade:Advanced_GetModifierPreAttack_BonusDamage()return self.bonus_attack end

function modifier_item_set_asasin_blade:OnAttack(keys)
    if not IsServer() then
        return
    end
    if not self:GetAbility() then return end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if not IsValid(keys.target) then
        return
    end
    if keys.target and keys.target:HasModifier("modifier_item_set_asasin_blade_already") then
        return
    end
    keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_stunned", {duration = self.duration})
    keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_set_asasin_blade_already", {duration = 10000})
end


------
modifier_item_set_asasin_blade_already = advanced_modifier({})

function modifier_item_set_asasin_blade_already:IsDebuff() return true end
function modifier_item_set_asasin_blade_already:IsHidden() return true end
function modifier_item_set_asasin_blade_already:IsPurgable() return false end