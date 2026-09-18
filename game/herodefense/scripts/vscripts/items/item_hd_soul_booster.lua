item_hd_soul_booster = class({})

LinkLuaModifier("modifier_item_hd_soul_booster", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)

function item_hd_soul_booster:GetIntrinsicModifierName()
	return "modifier_item_hd_soul_booster"
end

-------------------------------------------------------------
modifier_item_hd_soul_booster = advanced_modifier({})

function modifier_item_hd_soul_booster:IsDebuff() return false end
function modifier_item_hd_soul_booster:IsHidden() return true end
function modifier_item_hd_soul_booster:IsPurgable() return false end

function modifier_item_hd_soul_booster:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()

	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.str_mana = self.ability:GetSpecialValueFor("str_mana") + self.bonus_mana
	self.agi_hp = self.ability:GetSpecialValueFor("agi_hp") + self.bonus_health
	self.agi_mana = self.ability:GetSpecialValueFor("agi_mana")+ self.bonus_mana
	self.int_hp = self.ability:GetSpecialValueFor("int_hp") + self.bonus_health
	self.all_hp = self.ability:GetSpecialValueFor("all_hp") + self.bonus_health
	self.all_mana = self.ability:GetSpecialValueFor("all_mana")+ self.bonus_mana

    if IsServer() then
		self.PrimaryAttribute =parent:GetPrimaryAttribute()
		self:SetStackCount(self.PrimaryAttribute)
	end
end

function modifier_item_hd_soul_booster:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_MANA_BONUS,
    }
end


function modifier_item_hd_soul_booster:AdvancedGetModifierHealthBonus()	

	local main = self:GetStackCount()
	if main==DOTA_ATTRIBUTE_STRENGTH  then
		return self.bonus_health
	end
	if main==DOTA_ATTRIBUTE_AGILITY  then
		return self.agi_hp
	end
	if main==DOTA_ATTRIBUTE_INTELLECT  then
		return self.int_hp
	end
	if main==DOTA_ATTRIBUTE_ALL  then
		return self.all_hp
	end
	return 
end

function modifier_item_hd_soul_booster:AdvancedGetModifierManaBonus()	
	local main = self:GetStackCount()
	if main==DOTA_ATTRIBUTE_STRENGTH  then
		return self.str_mana
	end
	if main==DOTA_ATTRIBUTE_AGILITY  then
		return self.agi_mana
	end
	if main==DOTA_ATTRIBUTE_INTELLECT  then
		return self.bonus_mana
	end
	if main==DOTA_ATTRIBUTE_ALL  then
		return self.all_mana
	end
	return 
end

