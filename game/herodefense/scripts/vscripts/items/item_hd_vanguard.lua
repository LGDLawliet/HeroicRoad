item_hd_vanguard = class({})

LinkLuaModifier("modifier_item_hd_vanguard", "items/item_hd_vanguard", LUA_MODIFIER_MOTION_NONE)


function item_hd_vanguard:GetIntrinsicModifierName()
	return "modifier_item_hd_vanguard"
end




modifier_item_hd_vanguard = advanced_modifier({})

function modifier_item_hd_vanguard:IsDebuff() return false end
function modifier_item_hd_vanguard:IsHidden() return true end
function modifier_item_hd_vanguard:IsPurgable() return false end

function modifier_item_hd_vanguard:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.block = self.ability:GetSpecialValueFor("block")
end

function modifier_item_hd_vanguard:AdvancedGetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_vanguard:AdvancedGetModifierConstantManaRegen()	return self.bonus_health_regeneration end

function modifier_item_hd_vanguard:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS
	}
end
function modifier_item_hd_vanguard:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return 0
	end

	return self.block
end