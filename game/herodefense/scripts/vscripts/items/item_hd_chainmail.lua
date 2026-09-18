item_hd_chainmail = class({})
-- LinkLuaModifier("modifier_item_hd_chainmail_arua", "items/item_hd_chainmail", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_chainmail_arua_effect", "items/item_hd_chainmail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_chainmail", "items/item_hd_chainmail", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_chainmail_active", "items/item_hd_chainmail", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_chainmail_active_standby", "items/item_hd_chainmail", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_chainmail_active_debuff", "items/item_hd_chainmail", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_chainmail:GetIntrinsicModifierName()
	return "modifier_item_hd_chainmail"
end



-- function item_hd_chainmail:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_chainmail_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_chainmail_arua = class({})

-- function modifier_item_hd_chainmail_arua:IsHidden() return true end
-- function modifier_item_hd_chainmail_arua:IsAura() return true end
-- function modifier_item_hd_chainmail_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_chainmail_arua:GetModifierAura() return "modifier_item_hd_chainmail_arua_effect" end
-- function modifier_item_hd_chainmail_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_chainmail_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_chainmail_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_chainmail_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_chainmail = advanced_modifier({})

function modifier_item_hd_chainmail:IsDebuff() return false end
function modifier_item_hd_chainmail:IsHidden() return true end
function modifier_item_hd_chainmail:IsPurgable() return false end

function modifier_item_hd_chainmail:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
    self:StartIntervalThink(1)
end

function modifier_item_hd_chainmail:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_dragon_blood") or self:GetCaster():FindAbilityByName("Middle_dragon_blood") or self:GetCaster():FindAbilityByName("Advanced_dragon_blood") then
		self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor") + self.ability:GetSpecialValueFor("bonus_armor_extra")
    else
        self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
    end
end

function modifier_item_hd_chainmail:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_chainmail:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end