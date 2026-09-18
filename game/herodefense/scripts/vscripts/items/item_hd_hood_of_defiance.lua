item_hd_hood_of_defiance = class({})

LinkLuaModifier("modifier_item_hd_hood_of_defiance", "items/item_hd_hood_of_defiance", LUA_MODIFIER_MOTION_NONE)


function item_hd_hood_of_defiance:GetIntrinsicModifierName()
	return "modifier_item_hd_hood_of_defiance"
end

modifier_item_hd_hood_of_defiance = advanced_modifier({})

function modifier_item_hd_hood_of_defiance:IsDebuff() return false end
function modifier_item_hd_hood_of_defiance:IsHidden() return true end
function modifier_item_hd_hood_of_defiance:IsPurgable() return false end
function modifier_item_hd_hood_of_defiance:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.incoming_down = -self.ability:GetSpecialValueFor("incoming_down")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
end

function modifier_item_hd_hood_of_defiance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end

function modifier_item_hd_hood_of_defiance:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end


function modifier_item_hd_hood_of_defiance:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return
	end
	if keys.damage_type==DAMAGE_TYPE_MAGICAL and self:GetAbility():IsCooldownReady() and self.chance>=RandomInt(1, 100)   then
		self:GetAbility():StartCooldown(5)
		return self.incoming_down
	end
	return 0
end

function modifier_item_hd_hood_of_defiance:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

