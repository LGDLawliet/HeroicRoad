item_hd_medallion_of_courage = class({})

LinkLuaModifier("modifier_item_hd_medallion_of_courage", "items/item_hd_medallion_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_medallion_of_courage_active", "items/item_hd_medallion_of_courage", LUA_MODIFIER_MOTION_NONE)

function item_hd_medallion_of_courage:GetIntrinsicModifierName()
	return "modifier_item_hd_medallion_of_courage"
end
function item_hd_medallion_of_courage:GetCastRange()
	return self:GetSpecialValueFor("radius")
end


modifier_item_hd_medallion_of_courage = advanced_modifier({})

function modifier_item_hd_medallion_of_courage:IsDebuff() return false end
function modifier_item_hd_medallion_of_courage:IsHidden() return true end
function modifier_item_hd_medallion_of_courage:IsPurgable() return false end


function modifier_item_hd_medallion_of_courage:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.duration = self.ability:GetSpecialValueFor("duration")

    if IsServer() then
		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_medallion_of_courage:OnIntervalThink()
	if IsServer() then
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

	   if #units == 0 then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_medallion_of_courage_active", {duration = self.duration})
	   end
	end
end



function modifier_item_hd_medallion_of_courage:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
		

	}
end

function modifier_item_hd_medallion_of_courage:Advanced_GetModifierPreAttack_BonusDamage() 	return self.bonus_damage end

-----

modifier_item_hd_medallion_of_courage_active = advanced_modifier({})

function modifier_item_hd_medallion_of_courage_active:IsDebuff() return false end
function modifier_item_hd_medallion_of_courage_active:IsHidden() return true end
function modifier_item_hd_medallion_of_courage_active:IsPurgable() return false end


function modifier_item_hd_medallion_of_courage_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_damage_percent = self.ability:GetSpecialValueFor("bonus_damage_percent")
end

function modifier_item_hd_medallion_of_courage_active:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.bonus_damage_percent = self.ability:GetSpecialValueFor("bonus_damage_percent")
end

function modifier_item_hd_medallion_of_courage_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_item_hd_medallion_of_courage_active:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage_percent
end