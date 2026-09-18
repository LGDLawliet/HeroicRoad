item_hd_vambrace_str = class({})
-- LinkLuaModifier("modifier_item_hd_vambrace_str_arua", "items/item_hd_vambrace_str", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_str_arua_effect", "items/item_hd_vambrace_str", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_vambrace_str", "items/item_hd_vambrace_str", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_str_active", "items/item_hd_vambrace_str", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_str_active_standby", "items/item_hd_vambrace_str", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_str_active_debuff", "items/item_hd_vambrace_str", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_vambrace_str:GetIntrinsicModifierName()
	return "modifier_item_hd_vambrace_str"
end



-- function item_hd_vambrace_str:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_vambrace_str_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_vambrace_str_arua = class({})

-- function modifier_item_hd_vambrace_str_arua:IsHidden() return true end
-- function modifier_item_hd_vambrace_str_arua:IsAura() return true end
-- function modifier_item_hd_vambrace_str_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_vambrace_str_arua:GetModifierAura() return "modifier_item_hd_vambrace_str_arua_effect" end
-- function modifier_item_hd_vambrace_str_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_vambrace_str_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_vambrace_str_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_vambrace_str_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_vambrace_str = class({})

function modifier_item_hd_vambrace_str:IsDebuff() return false end
function modifier_item_hd_vambrace_str:IsHidden() return true end
function modifier_item_hd_vambrace_str:IsPurgable() return false end
-- function modifier_item_hd_vambrace_str:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_vambrace_str:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_vambrace_str:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")

    if IsServer() then

	end
end
function modifier_item_hd_vambrace_str:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性

		

	}
end


function modifier_item_hd_vambrace_str:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_vambrace_str:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_vambrace_str:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_vambrace_str:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end

