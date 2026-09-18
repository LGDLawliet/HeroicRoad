item_hd_cloak = class({})
-- LinkLuaModifier("modifier_item_hd_cloak_arua", "items/item_hd_cloak", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_cloak_arua_effect", "items/item_hd_cloak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_cloak", "items/item_hd_cloak", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_cloak_active", "items/item_hd_cloak", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_cloak_active_standby", "items/item_hd_cloak", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_cloak_active_debuff", "items/item_hd_cloak", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_cloak:GetIntrinsicModifierName()
	return "modifier_item_hd_cloak"
end



-- function item_hd_cloak:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_cloak_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_cloak_arua = class({})

-- function modifier_item_hd_cloak_arua:IsHidden() return true end
-- function modifier_item_hd_cloak_arua:IsAura() return true end
-- function modifier_item_hd_cloak_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_cloak_arua:GetModifierAura() return "modifier_item_hd_cloak_arua_effect" end
-- function modifier_item_hd_cloak_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_cloak_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_cloak_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_cloak_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_cloak = class({})

function modifier_item_hd_cloak:IsDebuff() return false end
function modifier_item_hd_cloak:IsHidden() return true end
function modifier_item_hd_cloak:IsPurgable() return false end
-- function modifier_item_hd_cloak:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_cloak:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_cloak:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()

	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")


    if IsServer() then


	end
end


function modifier_item_hd_cloak:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,       --魔法抗性


	}
end



function modifier_item_hd_cloak:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end


