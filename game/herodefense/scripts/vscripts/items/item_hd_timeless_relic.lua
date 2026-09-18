item_hd_timeless_relic = class({})

LinkLuaModifier("modifier_item_hd_timeless_relic", "items/item_hd_timeless_relic", LUA_MODIFIER_MOTION_NONE)

function item_hd_timeless_relic:GetIntrinsicModifierName()
	return "modifier_item_hd_timeless_relic"
end





modifier_item_hd_timeless_relic = advanced_modifier({})

function modifier_item_hd_timeless_relic:IsDebuff() return false end
function modifier_item_hd_timeless_relic:IsHidden() return true end
function modifier_item_hd_timeless_relic:IsPurgable() return false end


function modifier_item_hd_timeless_relic:OnCreated(keys)
    self.ability = self:GetAbility()
	local parent = self:GetParent()

 
	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.bonus_StatusNegativeGain = self.ability:GetSpecialValueFor("bonus_StatusNegativeGain")


    if IsServer() then

	end
end



function modifier_item_hd_timeless_relic:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification end



-- advanced_modifier
function modifier_item_hd_timeless_relic:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_NegativeDurationGain,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_timeless_relic:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.bonus_StatusNegativeGain
end
