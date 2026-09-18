item_hd_poor_mans_shield = class({})
-- LinkLuaModifier("modifier_item_hd_poor_mans_shield_arua", "items/item_hd_poor_mans_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_poor_mans_shield_arua_effect", "items/item_hd_poor_mans_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_poor_mans_shield", "items/item_hd_poor_mans_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_poor_mans_shield_active", "items/item_hd_poor_mans_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_poor_mans_shield_active_standby", "items/item_hd_poor_mans_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_poor_mans_shield_active_debuff", "items/item_hd_poor_mans_shield", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_poor_mans_shield:GetIntrinsicModifierName()
	return "modifier_item_hd_poor_mans_shield"
end



-- function item_hd_poor_mans_shield:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_poor_mans_shield_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_poor_mans_shield_arua = class({})

-- function modifier_item_hd_poor_mans_shield_arua:IsHidden() return true end
-- function modifier_item_hd_poor_mans_shield_arua:IsAura() return true end
-- function modifier_item_hd_poor_mans_shield_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_poor_mans_shield_arua:GetModifierAura() return "modifier_item_hd_poor_mans_shield_arua_effect" end
-- function modifier_item_hd_poor_mans_shield_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_poor_mans_shield_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_poor_mans_shield_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_poor_mans_shield_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_poor_mans_shield = advanced_modifier({})

function modifier_item_hd_poor_mans_shield:IsDebuff() return false end
function modifier_item_hd_poor_mans_shield:IsHidden() return true end
function modifier_item_hd_poor_mans_shield:IsPurgable() return false end


function modifier_item_hd_poor_mans_shield:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_item_hd_poor_mans_shield:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_category ==DOTA_DAMAGE_CATEGORY_SPELL then
		return 0
	end


	local parent = self:GetParent()
	if parent:GetGold()<=1000 then

		return 30

	end
	return 0
end