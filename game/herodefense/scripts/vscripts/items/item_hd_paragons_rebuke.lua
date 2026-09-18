item_hd_paragons_rebuke = class({})
-- LinkLuaModifier("modifier_item_hd_paragons_rebuke_arua", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_paragons_rebuke_arua_effect", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_paragons_rebuke", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_paragons_rebuke_active", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_paragons_rebuke_effect", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_paragons_rebuke_effect2", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_paragons_rebuke_active_standby", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_paragons_rebuke_debuff", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_paragons_rebuke_thinker", "items/item_hd_paragons_rebuke", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_paragons_rebuke:GetIntrinsicModifierName()
	return "modifier_item_hd_paragons_rebuke"
end






modifier_item_hd_paragons_rebuke = advanced_modifier({})

function modifier_item_hd_paragons_rebuke:IsDebuff() return false end
function modifier_item_hd_paragons_rebuke:IsHidden() return true end
function modifier_item_hd_paragons_rebuke:IsPurgable() return false end



function modifier_item_hd_paragons_rebuke:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	
    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_paragons_rebuke_active_standby", {duration = 20})
		self:StartIntervalThink(0.2)


	end
end
function modifier_item_hd_paragons_rebuke:OnIntervalThink()
	if IsServer() then

	   if self:GetAbility():IsCooldownReady() then
		local caster = self:GetParent()
		if not caster:IsAlive() then
			return
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	   DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		  for _, unit in pairs(units) do
			  if unit:IsAlive() then
				  local heal = (100-unit:GetHealthPercent())*0.0015*unit:GetMaxHealth()
				  local healing =  HealWithGain(heal,caster,unit,self)
				  SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
				  unit:Purge(false, true, false, false,true) --强驱散
				  local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
				  unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_paragons_rebuke_active", {duration = 5*ModifierStatusGain})
				  unit:EmitSound("Hero_Omniknight.GuardianAngel.Cast")
				  self:GetAbility():UseResources(true, true, true,true)
				  self:GetAbility():StartCooldown(5)
				  break



			  end
		  end

	   end
		-- self:SetHasCustomTransmitterData(true)
	end
end



function modifier_item_hd_paragons_rebuke:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值


	}
end


function modifier_item_hd_paragons_rebuke:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_paragons_rebuke:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_paragons_rebuke:GetModifierBonusStats_Agility()	return self.bonus_agi end

-- advanced_modifier
function modifier_item_hd_paragons_rebuke:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_paragons_rebuke:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end

function modifier_item_hd_paragons_rebuke:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

modifier_item_hd_paragons_rebuke_active = advanced_modifier({})

function modifier_item_hd_paragons_rebuke_active:IsDebuff() return false end
function modifier_item_hd_paragons_rebuke_active:IsHidden() return false end
function modifier_item_hd_paragons_rebuke_active:IsPurgable() return false end
function modifier_item_hd_paragons_rebuke_active:IsPurgeException() return true end
function modifier_item_hd_paragons_rebuke_active:GetTexture()return "item_paragons_rebuke" end
function modifier_item_hd_paragons_rebuke_active:GetEffectName() return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf" end
function modifier_item_hd_paragons_rebuke_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_paragons_rebuke_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_item_hd_paragons_rebuke_active:Advanced_GetModifier_StatusResistance(keys)
	return 35
end

