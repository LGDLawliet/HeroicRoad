item_hd_belt_of_strength = class({})
-- LinkLuaModifier("modifier_item_hd_belt_of_strength_arua", "items/item_hd_belt_of_strength", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_belt_of_strength_arua_effect", "items/item_hd_belt_of_strength", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_belt_of_strength", "items/item_hd_belt_of_strength", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_belt_of_strength_active", "items/item_hd_belt_of_strength", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_belt_of_strength_active_standby", "items/item_hd_belt_of_strength", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_belt_of_strength_active_debuff", "items/item_hd_belt_of_strength", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_belt_of_strength:GetIntrinsicModifierName()
	return "modifier_item_hd_belt_of_strength"
end



-- function item_hd_belt_of_strength:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_belt_of_strength_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_belt_of_strength_arua = class({})

-- function modifier_item_hd_belt_of_strength_arua:IsHidden() return true end
-- function modifier_item_hd_belt_of_strength_arua:IsAura() return true end
-- function modifier_item_hd_belt_of_strength_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_belt_of_strength_arua:GetModifierAura() return "modifier_item_hd_belt_of_strength_arua_effect" end
-- function modifier_item_hd_belt_of_strength_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_belt_of_strength_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_belt_of_strength_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_belt_of_strength_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_belt_of_strength = class({})

function modifier_item_hd_belt_of_strength:IsDebuff() return false end
function modifier_item_hd_belt_of_strength:IsHidden() return true end
function modifier_item_hd_belt_of_strength:IsPurgable() return false end
-- function modifier_item_hd_belt_of_strength:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_belt_of_strength:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_belt_of_strength:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	-- self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")

	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	-- self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
    if IsServer() then

	end
end



function modifier_item_hd_belt_of_strength:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性


	}
end
