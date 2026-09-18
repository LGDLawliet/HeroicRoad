item_hd_ogre_axe = class({})

LinkLuaModifier("modifier_item_hd_ogre_axe", "items/item_hd_ogre_axe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ogre_axe_active", "items/item_hd_ogre_axe", LUA_MODIFIER_MOTION_NONE)

function item_hd_ogre_axe:GetIntrinsicModifierName()
	return "modifier_item_hd_ogre_axe"
end

modifier_item_hd_ogre_axe = advanced_modifier({})

function modifier_item_hd_ogre_axe:IsDebuff() return false end
function modifier_item_hd_ogre_axe:IsHidden() return true end
function modifier_item_hd_ogre_axe:IsPurgable() return false end

function modifier_item_hd_ogre_axe:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_hd_ogre_axe:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
end

function modifier_item_hd_ogre_axe:Advanced_GetModifierBonusStats_Strength()	return self.bonus_str end

function modifier_item_hd_ogre_axe:OnTakeDamage(keys)
	if IsServer() and keys.attacker:GetTeamNumber() ~= keys.unit:GetTeamNumber() then
		self:GetParent():AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_ogre_axe_active", {duration = self.duration})
	end
end

--------

modifier_item_hd_ogre_axe_active = advanced_modifier({})

function modifier_item_hd_ogre_axe_active:IsDebuff() return false end
function modifier_item_hd_ogre_axe_active:IsHidden() return true end
function modifier_item_hd_ogre_axe_active:IsPurgable() return false end

function modifier_item_hd_ogre_axe_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.active = self.ability:GetSpecialValueFor("active")
end

function modifier_item_hd_ogre_axe_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

function modifier_item_hd_ogre_axe_active:Advanced_GetModifierHealReceiveAMP_Percentage()	return self.active end
function modifier_item_hd_ogre_axe_active:Advanced_GetModifierBonusStats_Strength()	return self.active end