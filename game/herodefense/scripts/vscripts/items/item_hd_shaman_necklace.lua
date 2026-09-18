item_hd_shaman_necklace = class({})
-- LinkLuaModifier("modifier_item_hd_shaman_necklace_arua", "items/item_hd_shaman_necklace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shaman_necklace_arua_effect", "items/item_hd_shaman_necklace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shaman_necklace", "items/item_hd_shaman_necklace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shaman_necklace_active", "items/item_hd_shaman_necklace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shaman_necklace_active_standby", "items/item_hd_shaman_necklace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shaman_necklace_active_debuff", "items/item_hd_shaman_necklace", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_shaman_necklace:GetIntrinsicModifierName()
	return "modifier_item_hd_shaman_necklace"
end



-- function item_hd_shaman_necklace:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_shaman_necklace_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_shaman_necklace_arua = class({})

-- function modifier_item_hd_shaman_necklace_arua:IsHidden() return true end
-- function modifier_item_hd_shaman_necklace_arua:IsAura() return true end
-- function modifier_item_hd_shaman_necklace_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_shaman_necklace_arua:GetModifierAura() return "modifier_item_hd_shaman_necklace_arua_effect" end
-- function modifier_item_hd_shaman_necklace_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_shaman_necklace_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_shaman_necklace_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_shaman_necklace_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_shaman_necklace = advanced_modifier({})

function modifier_item_hd_shaman_necklace:IsDebuff() return false end
function modifier_item_hd_shaman_necklace:IsHidden() return true end
function modifier_item_hd_shaman_necklace:IsPurgable() return false end
-- function modifier_item_hd_shaman_necklace:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_shaman_necklace:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_shaman_necklace:OnCreated(keys)
    -- self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    -- local parent = self:GetParent()
	
	self.bonus_summon_time = self:GetAbility():GetSpecialValueFor("bonus_summon_time")

end



-- advanced_modifier
function modifier_item_hd_shaman_necklace:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
    }
end
function modifier_item_hd_shaman_necklace:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self.bonus_summon_time
end



