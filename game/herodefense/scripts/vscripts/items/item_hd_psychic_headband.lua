item_hd_psychic_headband = class({})

LinkLuaModifier("modifier_item_hd_psychic_headband", "items/item_hd_psychic_headband", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_psychic_headband_active", "items/item_hd_psychic_headband", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_psychic_headband_already", "items/item_hd_psychic_headband", LUA_MODIFIER_MOTION_NONE)

function item_hd_psychic_headband:GetIntrinsicModifierName()
	return "modifier_item_hd_psychic_headband"
end

--------------------------
modifier_item_hd_psychic_headband = advanced_modifier({})

function modifier_item_hd_psychic_headband:IsDebuff() return false end
function modifier_item_hd_psychic_headband:IsHidden() return true end
function modifier_item_hd_psychic_headband:IsPurgable() return false end

function modifier_item_hd_psychic_headband:OnCreated(keys)
    self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
end

function modifier_item_hd_psychic_headband:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_MANA_BONUS,
    }
end
function modifier_item_hd_psychic_headband:AdvancedGetModifierManaBonus(keys)
	return self.bonus_mana 
end
function modifier_item_hd_psychic_headband:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus_int 
end


function modifier_item_hd_psychic_headband:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_item_hd_psychic_headband:OnAttackStart(keys)
	if not IsServer() then return end
	
    if self.parent == keys.target and not keys.attacker:IsOther() and keys.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then
		if not keys.attacker:HasModifier("modifier_item_hd_psychic_headband_already") then
        	keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_item_hd_psychic_headband_active", {duration = self.ability:GetSpecialValueFor("duration")})
			keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_item_hd_psychic_headband_already", {duration = 8})
		end
    end
end

--------------------------
modifier_item_hd_psychic_headband_active = advanced_modifier({})

function modifier_item_hd_psychic_headband_active:IsDebuff() return false end
function modifier_item_hd_psychic_headband_active:IsHidden() return true end
function modifier_item_hd_psychic_headband_active:IsPurgable() return false end

function modifier_item_hd_psychic_headband_active:OnCreated(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.attack_down = self.ability:GetSpecialValueFor("attack_down") 
end
function modifier_item_hd_psychic_headband_active:OnRefresh(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.attack_down = self.ability:GetSpecialValueFor("attack_down") 
end
function modifier_item_hd_psychic_headband_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_item_hd_psychic_headband_active:Advanced_GetModifierBaseDamageOutgoing_Percentage(keys)
	return -self.attack_down 
end
--------------------------
modifier_item_hd_psychic_headband_already = advanced_modifier({})

function modifier_item_hd_psychic_headband_already:IsDebuff() return true end
function modifier_item_hd_psychic_headband_already:IsHidden() return true end
function modifier_item_hd_psychic_headband_already:IsPurgable() return false end