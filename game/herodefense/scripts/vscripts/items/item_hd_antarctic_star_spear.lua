item_hd_antarctic_star_spear = class({})
-- LinkLuaModifier("item_hd_antarctic_star_spear_arua", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("item_hd_antarctic_star_spear_arua_effect", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_antarctic_star_spear", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("item_hd_antarctic_star_spear_active", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("item_hd_antarctic_star_spear_effect", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("item_hd_antarctic_star_spear_effect2", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("item_hd_antarctic_star_spear_active_standby", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("item_hd_antarctic_star_spear_debuff", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("item_hd_antarctic_star_spear_thinker", "items/item_hd_antarctic_star_spear", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_antarctic_star_spear:GetIntrinsicModifierName()
	return "modifier_item_hd_antarctic_star_spear"
end






modifier_item_hd_antarctic_star_spear = advanced_modifier({})

function modifier_item_hd_antarctic_star_spear:IsDebuff() return false end
function modifier_item_hd_antarctic_star_spear:IsHidden() return true end
function modifier_item_hd_antarctic_star_spear:IsPurgable() 		return false end
function modifier_item_hd_antarctic_star_spear:IsPurgeException() 	return false end
function modifier_item_hd_antarctic_star_spear:RemoveOnDeath()  return false end

function modifier_item_hd_antarctic_star_spear:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")

	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")

end

function modifier_item_hd_antarctic_star_spear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,  --额外魔法攻击力伤害

		

	}
end
function modifier_item_hd_antarctic_star_spear:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_antarctic_star_spear:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end
function modifier_item_hd_antarctic_star_spear:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.bonus_attack_range or 0 end


function modifier_item_hd_antarctic_star_spear:GetModifierProcAttack_BonusDamage_Magical(keys)
	if IsServer() and self:GetAbility():IsCooldownReady() then
		local caster = self:GetCaster()
		-- self:GetAbility():UseResources(true, true, true,true)
		-- self:GetAbility():StartCooldown(0.5)
		local dis= GetDistanceBetweenTwoUnit(caster,keys.target)
		local damage = dis * (caster:GetIntellect(false)) *0.005
		return damage
	end
end

function modifier_item_hd_antarctic_star_spear:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end

