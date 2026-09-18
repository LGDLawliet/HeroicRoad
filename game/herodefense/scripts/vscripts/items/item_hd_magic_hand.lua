item_hd_magic_hand = class({})
-- LinkLuaModifier("modifier_item_hd_magic_hand_arua", "items/item_hd_magic_hand", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_magic_hand_arua_effect", "items/item_hd_magic_hand", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_magic_hand", "items/item_hd_magic_hand", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_magic_hand_active", "items/item_hd_magic_hand", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_magic_hand_active_standby", "items/item_hd_magic_hand", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_magic_hand_active_debuff", "items/item_hd_magic_hand", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_magic_hand:GetIntrinsicModifierName()
	return "modifier_item_hd_magic_hand"
end



-- funct


modifier_item_hd_magic_hand = advanced_modifier({})

function modifier_item_hd_magic_hand:IsDebuff() return false end
function modifier_item_hd_magic_hand:IsHidden() return true end
function modifier_item_hd_magic_hand:IsPurgable() return false end
-- function modifier_item_hd_magic_hand:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_magic_hand:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_magic_hand:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_casttime = self.ability:GetSpecialValueFor("bonus_casttime")
	self:StartIntervalThink(1)
end

function modifier_item_hd_magic_hand:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_split_earth") or self:GetCaster():FindAbilityByName("Middle_split_earth") or self:GetCaster():FindAbilityByName("Advanced_split_earth") then
		self.bonus_casttime = self.ability:GetSpecialValueFor("bonus_casttime") + self.ability:GetSpecialValueFor("bonus_casttime_extra")
    else
        self.bonus_casttime = self.ability:GetSpecialValueFor("bonus_casttime")
    end
end

function modifier_item_hd_magic_hand:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_CastPoint

    }

	return funcs

end

function modifier_item_hd_magic_hand:Advanced_GetModifier_CastPoint() return self.bonus_casttime end

