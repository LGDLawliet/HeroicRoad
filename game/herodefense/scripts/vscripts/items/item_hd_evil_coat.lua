item_hd_evil_coat = class({})

LinkLuaModifier("modifier_item_hd_evil_coat", "items/item_hd_evil_coat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_evil_coat_active", "items/item_hd_evil_coat", LUA_MODIFIER_MOTION_NONE)


function item_hd_evil_coat:GetIntrinsicModifierName()
	return "modifier_item_hd_evil_coat"
end
----------------------------------------------------------------------------------

modifier_item_hd_evil_coat = advanced_modifier({})

function modifier_item_hd_evil_coat:IsDebuff() return false end
function modifier_item_hd_evil_coat:IsHidden() return true end
function modifier_item_hd_evil_coat:IsPurgable() return false end

function modifier_item_hd_evil_coat:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_armor = -self.ability:GetSpecialValueFor("bonus_armor")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.damage = self.ability:GetSpecialValueFor("damage") * 0.01 * self:GetParent():GetMaxHealth()

    self.damageTable = {
        --victim = keys.attacker,
        attacker = self:GetParent(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
        ability = nil, --Optional.     
    }
end

function modifier_item_hd_evil_coat:OnDeath(keys)
    if not IsServer() then
        return
    end
    if not self:GetAbility():IsCooldownReady() then
        return
    end

    self.damageTable = {
        victim = keys.attacker,
        attacker = self:GetParent(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
        ability = nil, --Optional.     
    }
    ApplyDamage(self.damageTable)
    keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_evil_coat_active", {duration = self.duration})
    self:GetAbility():UseResources(true, true, true, true)
   
end


function modifier_item_hd_evil_coat:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
    }
end

function modifier_item_hd_evil_coat:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_hd_evil_coat:AdvancedGetModifierHealthBonus()
    return self.bonus_health
end

----------------------------------------------------------------------------------------------------
modifier_item_hd_evil_coat_active = advanced_modifier({})

function modifier_item_hd_evil_coat_active:IsDebuff()			return true end
function modifier_item_hd_evil_coat_active:IsHidden() 			return false end
function modifier_item_hd_evil_coat_active:IsPurgable() 			return true end
function modifier_item_hd_evil_coat_active:IsPurgeException() 	return true end


function modifier_item_hd_evil_coat_active:GetTexture()
    return "item_evil_coat"
end
function modifier_item_hd_evil_coat_active:CheckState()
    return{
        [MODIFIER_STATE_DISARMED] = true
    }
end