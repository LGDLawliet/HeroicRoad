item_hd_mysterious_hat = class({})
-- LinkLuaModifier("modifier_item_hd_mysterious_hat_arua", "items/item_hd_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mysterious_hat_arua_effect", "items/item_hd_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mysterious_hat", "items/item_hd_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mysterious_hat_active", "items/item_hd_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mysterious_hat_active_standby", "items/item_hd_mysterious_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mysterious_hat_active_debuff", "items/item_hd_mysterious_hat", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_mysterious_hat:GetIntrinsicModifierName()
	return "modifier_item_hd_mysterious_hat"
end



-- function item_hd_mysterious_hat:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_mysterious_hat_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_mysterious_hat_arua = class({})

-- function modifier_item_hd_mysterious_hat_arua:IsHidden() return true end
-- function modifier_item_hd_mysterious_hat_arua:IsAura() return true end
-- function modifier_item_hd_mysterious_hat_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_mysterious_hat_arua:GetModifierAura() return "modifier_item_hd_mysterious_hat_arua_effect" end
-- function modifier_item_hd_mysterious_hat_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_mysterious_hat_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_mysterious_hat_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_mysterious_hat_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_mysterious_hat = advanced_modifier({})

function modifier_item_hd_mysterious_hat:IsDebuff() return false end
function modifier_item_hd_mysterious_hat:IsHidden() return true end
function modifier_item_hd_mysterious_hat:IsPurgable() return false end
-- function modifier_item_hd_mysterious_hat:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_mysterious_hat:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_mysterious_hat:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.bonus_manacost_per = self.ability:GetSpecialValueFor("bonus_manacost_per")
	self:StartIntervalThink(1)
end

function modifier_item_hd_mysterious_hat:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_magic_blessing") or self:GetCaster():FindAbilityByName("Middle_magic_blessing") or self:GetCaster():FindAbilityByName("Advanced_magic_blessing") then
		self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification") + self.ability:GetSpecialValueFor("bonus_spell_damage_amplification_extra")
		self.bonus_manacost_per = self.ability:GetSpecialValueFor("bonus_manacost_per") + self.ability:GetSpecialValueFor("bonus_manacost_per_extra")
	else
		self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
		self.bonus_manacost_per = self.ability:GetSpecialValueFor("bonus_manacost_per")
	end
end

function modifier_item_hd_mysterious_hat:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,            --技能魔法消耗

	}
end



function modifier_item_hd_mysterious_hat:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_mysterious_hat:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification end
function modifier_item_hd_mysterious_hat:GetModifierPercentageManacost()   return self.bonus_manacost_per end
function modifier_item_hd_mysterious_hat:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end