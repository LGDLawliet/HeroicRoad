item_set_rbone_bow = class({})
LinkLuaModifier("modifier_item_set_rbone_bow", "items/item_set_rbone_bow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_set_rbone_active", "items/item_set_rbone_bow", LUA_MODIFIER_MOTION_NONE)

function item_set_rbone_bow:GetIntrinsicModifierName()
	return "modifier_item_set_rbone_bow"
end


modifier_item_set_rbone_bow = advanced_modifier({})

function modifier_item_set_rbone_bow:IsDebuff() return false end
function modifier_item_set_rbone_bow:IsHidden() return true end
function modifier_item_set_rbone_bow:IsPurgable() return false end

function modifier_item_set_rbone_bow:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
    self.duration = self.ability:GetSpecialValueFor("duration")
    
end


function modifier_item_set_rbone_bow:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
    }
end

function modifier_item_set_rbone_bow:Advanced_GetModifierPreAttack_BonusDamage()return self.bonus_attack end
function modifier_item_set_rbone_bow:Advanced_GetModifierAttackRangeBonus()	
    if self:GetParent():IsRangedAttacker() then 
        return self.bonus_attack_range 
    end
    return 0 
end

function modifier_item_set_rbone_bow:OnAttack(keys)  
    if not IsServer() then
        return
    end
    if not self:GetAbility() then return end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if not keys.attacker:HasModifier("modifier_item_set_rbone_quiver") then
        return
    end
    if not keys.target:IsAlive() then
        return
    end
    keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_set_rbone_active", {duration = self.duration})
end



---
modifier_item_set_rbone_active = advanced_modifier({})

function modifier_item_set_rbone_active:IsDebuff() return true end
function modifier_item_set_rbone_active:IsHidden() return false end
function modifier_item_set_rbone_active:IsPurgable() return false end

function modifier_item_set_rbone_active:OnCreated(keys)
    self.ability = self:GetAbility()
    self.armor_down = self.ability:GetSpecialValueFor("armor_down")
    self.hp_regen_down = self.ability:GetSpecialValueFor("hp_regen_down")
end


function modifier_item_set_rbone_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
    }
end

function modifier_item_set_rbone_active:Advanced_GetModifierPhysicalArmorBonus() return -self.armor_down end

function modifier_item_set_rbone_active:AdvancedGetModifierConstantHealthRegenAmpPercentage()  return -self.hp_regen_down end