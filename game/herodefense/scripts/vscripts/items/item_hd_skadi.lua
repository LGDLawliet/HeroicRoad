item_hd_skadi = class({})
-- LinkLuaModifier("modifier_item_hd_skadi_arua", "items/item_hd_skadi", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_skadi_arua_effect", "items/item_hd_skadi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_skadi", "items/item_hd_skadi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_skadi_active", "items/item_hd_skadi", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_skadi_active_standby", "items/item_hd_skadi", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_skadi_active_debuff", "items/item_hd_skadi", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_skadi:GetIntrinsicModifierName()
	return "modifier_item_hd_skadi"
end



-- function item_hd_skadi:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_skadi_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_skadi_arua = class({})

-- function modifier_item_hd_skadi_arua:IsHidden() return true end
-- function modifier_item_hd_skadi_arua:IsAura() return true end
-- function modifier_item_hd_skadi_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_skadi_arua:GetModifierAura() return "modifier_item_hd_skadi_arua_effect" end
-- function modifier_item_hd_skadi_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_skadi_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_skadi_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_skadi_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_skadi = class({})

function modifier_item_hd_skadi:IsDebuff() return false end
function modifier_item_hd_skadi:IsHidden() return true end
function modifier_item_hd_skadi:IsPurgable() return false end
-- function modifier_item_hd_skadi:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_skadi:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_skadi:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
    if IsServer() then

	end
end

function modifier_item_hd_skadi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
		MODIFIER_PROPERTY_HEALTH_BONUS,                   --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                     --魔法值

		MODIFIER_EVENT_ON_ATTACK,                         --攻击事件

	}
end


function modifier_item_hd_skadi:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_skadi:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_skadi:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_skadi:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_skadi:GetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_skadi:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() and not params.target:IsMagicImmune() then
		local ModifierStatusNegativeGain = params.attacker:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = params.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		local duration = math.max(5*StatusResistance,0.3)
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_item_hd_skadi_active", {duration = duration})		
		end
	end
end


modifier_item_hd_skadi_active = advanced_modifier({})

function modifier_item_hd_skadi_active:IsDebuff() return true end
function modifier_item_hd_skadi_active:IsHidden() return false end
function modifier_item_hd_skadi_active:IsPurgable() return true end
function modifier_item_hd_skadi_active:IsPurgeException() return true end
function modifier_item_hd_skadi_active:GetTexture()return "item_skadi" end



function modifier_item_hd_skadi_active:GetEffectName()	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end
function modifier_item_hd_skadi_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_skadi_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_item_hd_skadi_active:GetModifierAttackSpeedBonus_Constant()	return -30 end
function modifier_item_hd_skadi_active:GetModifierMoveSpeedBonus_Constant()	return -180 end
function modifier_item_hd_skadi_active:AdvancedGetModifierConstantHealthRegenAmpPercentage()	return -30 end


-- advanced_modifier
function modifier_item_hd_skadi_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance,
    }
end
function modifier_item_hd_skadi_active:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -30
end


function modifier_item_hd_skadi_active:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -30
end




function modifier_item_hd_skadi_active:Advanced_GetModifier_StatusResistance(keys)
	return -30
end

