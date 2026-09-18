item_hd_gauntlets = class({})
-- LinkLuaModifier("modifier_item_hd_gauntlets_arua", "items/item_hd_gauntlets", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_gauntlets_arua_effect", "items/item_hd_gauntlets", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_gauntlets", "items/item_hd_gauntlets", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_gauntlets_active", "items/item_hd_gauntlets", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_gauntlets_active_standby", "items/item_hd_gauntlets", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_gauntlets_active_debuff", "items/item_hd_gauntlets", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_gauntlets:GetIntrinsicModifierName()
	return "modifier_item_hd_gauntlets"
end





modifier_item_hd_gauntlets = advanced_modifier({})

function modifier_item_hd_gauntlets:IsDebuff() return false end
function modifier_item_hd_gauntlets:IsHidden() return true end
function modifier_item_hd_gauntlets:IsPurgable() return false end
-- function modifier_item_hd_gauntlets:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_gauntlets:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_gauntlets:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self:StartIntervalThink(1)
end

function modifier_item_hd_gauntlets:OnIntervalThink(keys)
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str") - self.ability:GetSpecialValueFor("bonus_str_eachlvl")*self:GetParent():GetLevel()
end

function modifier_item_hd_gauntlets:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end


function modifier_item_hd_gauntlets:Advanced_GetModifierBonusStats_Strength(keys)
	return self.bonus_str
end
