creep_special_gain_super = class({})

LinkLuaModifier("modifier_creep_special_gain_super", "special_gain/creep_special_gain_super", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_super_active", "special_gain/creep_special_gain_super", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_super:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_super"
end
----------------------------------------------------------
modifier_creep_special_gain_super = advanced_modifier({})

function modifier_creep_special_gain_super:IsHidden() return false end
function modifier_creep_special_gain_super:IsPurgable() return false end
function modifier_creep_special_gain_super:IsDebuff() return false end
function modifier_creep_special_gain_super:GetEffectName() return "particles/rebuild/particle_effect/attach_92/effect_lv2_buff_beams.vpcf" end
function modifier_creep_special_gain_super:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creep_special_gain_super:OnCreated()
	self.bonus_hp_max = self:GetAbility():GetSpecialValueFor("bonus_hp_max")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_magic_res = self:GetAbility():GetSpecialValueFor("bonus_magic_res")
	self.move_down = self:GetAbility():GetSpecialValueFor("move_down")
	self.death_gold = self:GetAbility():GetSpecialValueFor("death_gold")
	self.bonus_death_gold = self:GetAbility():GetSpecialValueFor("bonus_death_gold")
	self:GetParent():GameTimer(0.3,function ()
		if not self:GetParent():HasAbility("creep_special_gain_enraged") then
			local ability = self:GetParent():AddAbility("creep_special_gain_enraged")
			ability:SetLevel(1)
		end
		if not self:GetParent():HasAbility("creep_special_gain_Perseverance") then
			local ability = self:GetParent():AddAbility("creep_special_gain_Perseverance")
			ability:SetLevel(1)
		end
		if not self:GetParent():HasAbility("creep_special_gain_heal_death_delay") then
			local ability = self:GetParent():AddAbility("creep_special_gain_heal_death_delay")
			ability:SetLevel(1)
		end
	end)
	
end
function modifier_creep_special_gain_super:CheckState()
	return{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_creep_special_gain_super:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_creep_special_gain_super:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end
function modifier_creep_special_gain_super:AdvancedGetModifierExtraHealthPercentage()
	return self.bonus_hp_max
end
function modifier_creep_special_gain_super:Advanced_GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
function modifier_creep_special_gain_super:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_res
end
function modifier_creep_special_gain_super:GetModifierMoveSpeedBonus_Percentage()
	return -self.move_down
end
function modifier_creep_special_gain_super:GetModifierModelScale()
	return 100
end

function modifier_creep_special_gain_super:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit ~= self:GetParent() then
		return
	end
	local heroes = GetAllRealHeroes()
	for _, hero in pairs(heroes)do
		hero:ModifyGoldFiltered(self.death_gold,true,DOTA_ModifyGold_CreepKill)  --金币奖励
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,hero, self.death_gold, nil)
	end
end


--------------------------------
