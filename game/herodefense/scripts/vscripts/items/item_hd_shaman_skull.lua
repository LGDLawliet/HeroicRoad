item_hd_shaman_skull = class({})
-- LinkLuaModifier("modifier_item_hd_shaman_skull_arua", "items/item_hd_shaman_skull", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shaman_skull_arua_effect", "items/item_hd_shaman_skull", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shaman_skull", "items/item_hd_shaman_skull", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shaman_skull_active", "items/item_hd_shaman_skull", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shaman_skull_active_standby", "items/item_hd_shaman_skull", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shaman_skull_active_debuff", "items/item_hd_shaman_skull", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_shaman_skull:GetIntrinsicModifierName()
	return "modifier_item_hd_shaman_skull"
end



-- function item_hd_shaman_skull:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_shaman_skull_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_shaman_skull_arua = class({})

-- function modifier_item_hd_shaman_skull_arua:IsHidden() return true end
-- function modifier_item_hd_shaman_skull_arua:IsAura() return true end
-- function modifier_item_hd_shaman_skull_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_shaman_skull_arua:GetModifierAura() return "modifier_item_hd_shaman_skull_arua_effect" end
-- function modifier_item_hd_shaman_skull_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_shaman_skull_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_shaman_skull_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_shaman_skull_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_shaman_skull = advanced_modifier({})

function modifier_item_hd_shaman_skull:IsDebuff() return false end
function modifier_item_hd_shaman_skull:IsHidden() return true end
function modifier_item_hd_shaman_skull:IsPurgable() return false end
-- function modifier_item_hd_shaman_skull:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_shaman_skull:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_shaman_skull:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()

	self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")
	-- self.bonus_summon_time = self.ability:GetSpecialValueFor("bonus_summon_time")


    if IsServer() then

	end
end

function modifier_item_hd_shaman_skull:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_shaman_skull:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity
end

