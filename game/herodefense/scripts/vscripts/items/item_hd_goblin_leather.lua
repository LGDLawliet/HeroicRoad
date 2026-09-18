item_hd_goblin_leather = class({})
-- LinkLuaModifier("modifier_item_hd_goblin_leather_arua", "items/item_hd_goblin_leather", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_goblin_leather_arua_effect", "items/item_hd_goblin_leather", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_goblin_leather", "items/item_hd_goblin_leather", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_goblin_leather_active", "items/item_hd_goblin_leather", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_goblin_leather_active_standby", "items/item_hd_goblin_leather", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_goblin_leather_active_debuff", "items/item_hd_goblin_leather", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_goblin_leather:GetIntrinsicModifierName()
	return "modifier_item_hd_goblin_leather"
end



-- function item_hd_goblin_leather:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_goblin_leather_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_goblin_leather_arua = class({})

-- function modifier_item_hd_goblin_leather_arua:IsHidden() return true end
-- function modifier_item_hd_goblin_leather_arua:IsAura() return true end
-- function modifier_item_hd_goblin_leather_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_goblin_leather_arua:GetModifierAura() return "modifier_item_hd_goblin_leather_arua_effect" end
-- function modifier_item_hd_goblin_leather_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_goblin_leather_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_goblin_leather_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_goblin_leather_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_goblin_leather = advanced_modifier({})

function modifier_item_hd_goblin_leather:IsDebuff() return false end
function modifier_item_hd_goblin_leather:IsHidden() return true end
function modifier_item_hd_goblin_leather:IsPurgable() return false end
function modifier_item_hd_goblin_leather:OnCreated(keys)
	self.ability = self:GetAbility()
	self.reduce = self.ability:GetSpecialValueFor("damage_reduce")
	self:StartIntervalThink(1)
end

function modifier_item_hd_goblin_leather:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_reactive_armor") or self:GetCaster():FindAbilityByName("Middle_reactive_armor") or self:GetCaster():FindAbilityByName("Advanced_reactive_armor") then
		self.reduce = self.ability:GetSpecialValueFor("damage_reduce") + self.ability:GetSpecialValueFor("damage_reduce_extra")
	else
		self.reduce = self.ability:GetSpecialValueFor("damage_reduce")
	end
end
--function modifier_item_hd_goblin_leather:Advanced_GetModifierIncomingDamage_Percentage(keys)
--	if not IsServer() then
--		return
--	end
--	local parent = self:GetParent()
--	if keys.damage_category==0 or  keys.damage >=  150 then  --伤害是技能伤害或大于150
--		return 0
--	end
--	return -5
--end

function modifier_item_hd_goblin_leather:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -self.reduce
end

function modifier_item_hd_goblin_leather:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

    }
end









