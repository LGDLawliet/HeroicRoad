item_hd_shadow_amulet = class({})
-- LinkLuaModifier("modifier_item_hd_shadow_amulet_arua", "items/item_hd_shadow_amulet", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_shadow_amulet", "items/item_hd_shadow_amulet", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shadow_amulet_active", "items/item_hd_shadow_amulet", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_shadow_amulet:GetIntrinsicModifierName()
	return "modifier_item_hd_shadow_amulet"
end



modifier_item_hd_shadow_amulet = advanced_modifier({})

function modifier_item_hd_shadow_amulet:IsDebuff() return false end
function modifier_item_hd_shadow_amulet:IsHidden() return true end
function modifier_item_hd_shadow_amulet:IsPurgable() return false end
-- function modifier_item_hd_shadow_amulet:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_shadow_amulet:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_shadow_amulet:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
    if IsServer() then
		self:StartIntervalThink(0.3)
	end
end
function modifier_item_hd_shadow_amulet:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsInNightTime() then
			self:SetStackCount(2)
		else
			self:SetStackCount(1)
		end
	end
end


function modifier_item_hd_shadow_amulet:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷


	}
end


function modifier_item_hd_shadow_amulet:Advanced_GetModifierBonusStats_Strength()	return self.bonus_atb*self:GetStackCount() end
function modifier_item_hd_shadow_amulet:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_atb*self:GetStackCount() end
function modifier_item_hd_shadow_amulet:Advanced_GetModifierBonusStats_Agility()	return self.bonus_atb*self:GetStackCount() end
