item_chaotic_mysterious_hat = class({})
-- LinkLuaModifier("modifier_item_chaotic_mysterious_hat_arua", "items/item_chaotic_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_chaotic_mysterious_hat_arua_effect", "items/item_chaotic_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_mysterious_hat", "items/item_chaotic_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_chaotic_mysterious_hat_active", "items/item_chaotic_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_chaotic_mysterious_hat_active_standby", "items/item_chaotic_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_chaotic_mysterious_hat_active_debuff", "items/item_chaotic_mysterious_hat", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_chaotic_mysterious_hat:GetIntrinsicModifierName()
	return "modifier_item_chaotic_mysterious_hat"
end



-- function item_chaotic_mysterious_hat:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetchaoticStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_chaotic_mysterious_hat_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_chaotic_mysterious_hat_arua = class({})

-- function modifier_item_chaotic_mysterious_hat_arua:IsHidden() return true end
-- function modifier_item_chaotic_mysterious_hat_arua:IsAura() return true end
-- function modifier_item_chaotic_mysterious_hat_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_chaotic_mysterious_hat_arua:GetModifierAura() return "modifier_item_chaotic_mysterious_hat_arua_effect" end
-- function modifier_item_chaotic_mysterious_hat_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_chaotic_mysterious_hat_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_chaotic_mysterious_hat_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_chaotic_mysterious_hat_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_chaotic_mysterious_hat = advanced_modifier({})

function modifier_item_chaotic_mysterious_hat:IsDebuff() return false end
function modifier_item_chaotic_mysterious_hat:IsHidden() return true end
function modifier_item_chaotic_mysterious_hat:IsPurgable() return false end




function modifier_item_chaotic_mysterious_hat:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.mana_cost_down = self.ability:GetSpecialValueFor("mana_cost_down")
end


function modifier_item_chaotic_mysterious_hat:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,            --技能魔法消耗

	}
end
function modifier_item_chaotic_mysterious_hat:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end


function modifier_item_chaotic_mysterious_hat:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_amp end
function modifier_item_chaotic_mysterious_hat:GetModifierPercentageManacostStacking()   return self.mana_cost_down end
