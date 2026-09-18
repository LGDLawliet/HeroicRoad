item_hd_spy_gadget = class({})
-- LinkLuaModifier("modifier_item_hd_spy_gadget_arua", "items/item_hd_spy_gadget", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_spy_gadget_arua_effect", "items/item_hd_spy_gadget", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_spy_gadget", "items/item_hd_spy_gadget", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_spy_gadget_active", "items/item_hd_spy_gadget", LUA_MODIFIER_MOTION_NONE)




-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_spy_gadget:GetIntrinsicModifierName()
	return "modifier_item_hd_spy_gadget"
end




modifier_item_hd_spy_gadget = class({})

function modifier_item_hd_spy_gadget:IsDebuff() return false end
function modifier_item_hd_spy_gadget:IsHidden() return true end
function modifier_item_hd_spy_gadget:IsPurgable() return false end
-- function modifier_item_hd_spy_gadget:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_spy_gadget:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_spy_gadget:IsAura() return true end
function modifier_item_hd_spy_gadget:GetAuraDuration() return 0.5 end
function modifier_item_hd_spy_gadget:GetModifierAura() return "modifier_item_hd_spy_gadget_active" end
function modifier_item_hd_spy_gadget:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_spy_gadget:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_spy_gadget:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_spy_gadget:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_item_hd_spy_gadget:CheckState()
-- 	local state = {}
	
-- 	if self.pierce_proc then   --几率穿刺（无视闪避）
-- 		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
-- 	end

-- 	return state
-- end


function modifier_item_hd_spy_gadget:OnCreated(keys)
    self.ability = self:GetAbility()


	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


end


function modifier_item_hd_spy_gadget:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	
	}
end


function modifier_item_hd_spy_gadget:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_spy_gadget:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_spy_gadget:GetModifierBonusStats_Agility()	return self.bonus_agi end


modifier_item_hd_spy_gadget_active = advanced_modifier({})

function modifier_item_hd_spy_gadget_active:IsDebuff() return false end
function modifier_item_hd_spy_gadget_active:IsHidden() return false end
function modifier_item_hd_spy_gadget_active:IsPurgable() return false end
function modifier_item_hd_spy_gadget_active:GetTexture()return "item_spy_gadget" end


function modifier_item_hd_spy_gadget_active:Advanced_GetModifierAttackRangeBonus() return  self:GetParent():IsRangedAttacker() and 150 or 0 end

function modifier_item_hd_spy_gadget_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
end
function modifier_item_hd_spy_gadget_active:Advanced_GetModifierCastRangeBonusStacking(keys)

	return 200
end

