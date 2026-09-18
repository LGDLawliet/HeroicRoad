item_hd_pupils_gift = class({})
-- LinkLuaModifier("modifier_item_hd_pupils_gift_arua", "items/item_hd_pupils_gift", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_pupils_gift_arua_effect", "items/item_hd_pupils_gift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_pupils_gift", "items/item_hd_pupils_gift", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_pupils_gift_active", "items/item_hd_pupils_gift", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_pupils_gift_active_effect", "items/item_hd_pupils_gift", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_item_hd_pupils_gift_active_standby", "items/item_hd_pupils_gift", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_pupils_gift_active_debuff", "items/item_hd_pupils_gift", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_pupils_gift:GetIntrinsicModifierName()
	return "modifier_item_hd_pupils_gift"
end



-- function item_hd_pupils_gift:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_pupils_gift_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_pupils_gift_arua = class({})

-- function modifier_item_hd_pupils_gift_arua:IsHidden() return true end
-- function modifier_item_hd_pupils_gift_arua:IsAura() return true end
-- function modifier_item_hd_pupils_gift_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_pupils_gift_arua:GetModifierAura() return "modifier_item_hd_pupils_gift_arua_effect" end
-- function modifier_item_hd_pupils_gift_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_pupils_gift_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_pupils_gift_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_pupils_gift_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_pupils_gift = class({})

function modifier_item_hd_pupils_gift:IsDebuff() return false end
function modifier_item_hd_pupils_gift:IsHidden() return true end
function modifier_item_hd_pupils_gift:IsPurgable() return false end
-- function modifier_item_hd_pupils_gift:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_pupils_gift:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_item_hd_pupils_gift:IsAura() return true end
-- function modifier_item_hd_pupils_gift:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_pupils_gift:GetModifierAura() return "modifier_item_hd_pupils_gift_active" end
-- function modifier_item_hd_pupils_gift:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_pupils_gift:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_pupils_gift:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
-- function modifier_item_hd_pupils_gift:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



function modifier_item_hd_pupils_gift:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.PrimaryAttribute =parent:GetPrimaryAttribute()
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
	-- self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	-- self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

	-- self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	-- self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	-- self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_damage_per = self.ability:GetSpecialValueFor("bonus_damage_per")
	-- self.bonus_armor = -self.ability:GetSpecialValueFor("bonus_armor")
	-- self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	-- self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	-- self.bonus_casttime = self.ability:GetSpecialValueFor("bonus_casttime")
	-- self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
	-- self.bonus_heal_receive_amplification = self.ability:GetSpecialValueFor("bonus_heal_receive_amplification")
	-- self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")
	-- self.bonus_summon_time = self.ability:GetSpecialValueFor("bonus_summon_time")


    if IsServer() then

	end
end


function modifier_item_hd_pupils_gift:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_item_hd_pupils_gift:GetModifierBonusStats_Strength()	return self.PrimaryAttribute~=0 and self.bonus_str end
function modifier_item_hd_pupils_gift:GetModifierBonusStats_Intellect()	return self.PrimaryAttribute~=2 and self.bonus_int end
function modifier_item_hd_pupils_gift:GetModifierBonusStats_Agility()	return self.PrimaryAttribute~= 1 and self.bonus_agi end
