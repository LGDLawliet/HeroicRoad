item_chaotic_vanguard = class({})

LinkLuaModifier("modifier_item_chaotic_vanguard", "items/item_chaotic_vanguard", LUA_MODIFIER_MOTION_NONE)


function item_chaotic_vanguard:GetIntrinsicModifierName()
	return "modifier_item_chaotic_vanguard"
end

--------------------------------------------------------
modifier_item_chaotic_vanguard = advanced_modifier({})

function modifier_item_chaotic_vanguard:IsDebuff() return false end
function modifier_item_chaotic_vanguard:IsHidden() return true end
function modifier_item_chaotic_vanguard:IsPurgable() return false end

function modifier_item_chaotic_vanguard:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_hp = self.ability:GetSpecialValueFor("bonus_hp")
	self.block = self.ability:GetSpecialValueFor("block")
end

function modifier_item_chaotic_vanguard:AdvancedGetModifierHealthBonus()	return self.bonus_hp end

function modifier_item_chaotic_vanguard:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

function modifier_item_chaotic_vanguard:Advanced_GetModifierTotalBlockConstantMaximum(keys)
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