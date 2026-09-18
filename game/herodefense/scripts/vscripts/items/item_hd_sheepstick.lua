item_hd_sheepstick = class({})
-- LinkLuaModifier("modifier_item_hd_sheepstick_arua", "items/item_hd_sheepstick", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sheepstick_arua_effect", "items/item_hd_sheepstick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sheepstick", "items/item_hd_sheepstick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sheepstick_active", "items/item_hd_sheepstick", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sheepstick_active_standby", "items/item_hd_sheepstick", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sheepstick_active_debuff", "items/item_hd_sheepstick", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_sheepstick:GetIntrinsicModifierName()
	return "modifier_item_hd_sheepstick"
end



function item_hd_sheepstick:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb(self) then	return 	end
	target:EmitSound("DOTA_Item.Sheepstick.Activate")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local duration = math.min(3*StatusResistance,6)
	duration = math.max(duration,3)
	target:AddNewModifier(caster, self, "modifier_item_hd_sheepstick_active", {duration = duration})
end


-- modifier_item_hd_sheepstick_arua = class({})

-- function modifier_item_hd_sheepstick_arua:IsHidden() return true end
-- function modifier_item_hd_sheepstick_arua:IsAura() return true end
-- function modifier_item_hd_sheepstick_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_sheepstick_arua:GetModifierAura() return "modifier_item_hd_sheepstick_arua_effect" end
-- function modifier_item_hd_sheepstick_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_sheepstick_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_sheepstick_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_sheepstick_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_sheepstick = advanced_modifier({})

function modifier_item_hd_sheepstick:IsDebuff() return false end
function modifier_item_hd_sheepstick:IsHidden() return true end
function modifier_item_hd_sheepstick:IsPurgable() return false end
-- function modifier_item_hd_sheepstick:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_sheepstick:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_sheepstick:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	-- self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
    if IsServer() then

	end
end


function modifier_item_hd_sheepstick:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷


	}
end


function modifier_item_hd_sheepstick:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_sheepstick:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_sheepstick:GetModifierBonusStats_Agility()	return self.bonus_agi end


function modifier_item_hd_sheepstick:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end

function modifier_item_hd_sheepstick:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end

modifier_item_hd_sheepstick_active = class({})

function modifier_item_hd_sheepstick_active:IsDebuff() return true end
function modifier_item_hd_sheepstick_active:IsHidden() return false end
function modifier_item_hd_sheepstick_active:IsPurgable() return false end
function modifier_item_hd_sheepstick_active:IsPurgeException() return true end
function modifier_item_hd_sheepstick_active:GetTexture()return "item_sheepstick" end
function modifier_item_hd_sheepstick_active:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_item_hd_sheepstick_active:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_hd_sheepstick_active:CheckState()
	local state = 
	{
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
}
	return state
end



function modifier_item_hd_sheepstick_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end

function modifier_item_hd_sheepstick_active:GetModifierMoveSpeedOverride()return 140 end

function modifier_item_hd_sheepstick_active:GetModifierModelChange()	return "models/props_gameplay/pig.vmdl" end