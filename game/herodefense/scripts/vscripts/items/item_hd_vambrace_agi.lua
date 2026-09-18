item_hd_vambrace_agi = class({})
-- LinkLuaModifier("modifier_item_hd_vambrace_agi_arua", "items/item_hd_vambrace_agi", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_agi_arua_effect", "items/item_hd_vambrace_agi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_vambrace_agi", "items/item_hd_vambrace_agi", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_agi_active", "items/item_hd_vambrace_agi", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_agi_active_standby", "items/item_hd_vambrace_agi", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_vambrace_agi_active_debuff", "items/item_hd_vambrace_agi", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_vambrace_agi:GetIntrinsicModifierName()
	return "modifier_item_hd_vambrace_agi"
end



-- function item_hd_vambrace_agi:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_vambrace_agi_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_vambrace_agi_arua = class({})

-- function modifier_item_hd_vambrace_agi_arua:IsHidden() return true end
-- function modifier_item_hd_vambrace_agi_arua:IsAura() return true end
-- function modifier_item_hd_vambrace_agi_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_vambrace_agi_arua:GetModifierAura() return "modifier_item_hd_vambrace_agi_arua_effect" end
-- function modifier_item_hd_vambrace_agi_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_vambrace_agi_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_vambrace_agi_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_vambrace_agi_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_vambrace_agi = class({})

function modifier_item_hd_vambrace_agi:IsDebuff() return false end
function modifier_item_hd_vambrace_agi:IsHidden() return true end
function modifier_item_hd_vambrace_agi:IsPurgable() return false end
-- function modifier_item_hd_vambrace_agi:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_vambrace_agi:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_vambrace_agi:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	-- self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_status_resistance")
	-- self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了
	-- self.bonus_active_life_steal = self.ability:GetSpecialValueFor("active_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了

	-- self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	-- self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	-- self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	-- self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	-- self.bonus_cooldown  = self.ability:GetSpecialValueFor("bonus_cooldown")

	-- self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	-- self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

	-- self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")

    if IsServer() then

	end
end


function modifier_item_hd_vambrace_agi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷



		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度

		

	}
end


function modifier_item_hd_vambrace_agi:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_vambrace_agi:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_vambrace_agi:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_vambrace_agi:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end
