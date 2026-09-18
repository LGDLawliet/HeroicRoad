creep_special_gain_Agility_Gain = class({})

LinkLuaModifier("modifier_creep_special_gain_Agility_Gain", "special_gain/creep_special_gain_Agility_Gain", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Agility_Gain:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Agility_Gain"
end
----------------
modifier_creep_special_gain_Agility_Gain = advanced_modifier({})

function modifier_creep_special_gain_Agility_Gain:IsDebuff() return false end
function modifier_creep_special_gain_Agility_Gain:IsHidden() return false end
function modifier_creep_special_gain_Agility_Gain:IsPurgable() return false end
function modifier_creep_special_gain_Agility_Gain:GetEffectName() return "particles/new_effect/status/new_status_effect_soul_11.vpcf" end
function modifier_creep_special_gain_Agility_Gain:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_Agility_Gain:OnCreated(keys)
    self.ability = self:GetAbility()
	if IsServer() then
		self.damage = self:GetParent():GetBaseDamageMax()
	end
end

function modifier_creep_special_gain_Agility_Gain:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
	}
end
function modifier_creep_special_gain_Agility_Gain:ADDeclareFunctions()
	return {
		--advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_creep_special_gain_Agility_Gain:Advanced_GetModifierBaseAttack_BonusDamage() 	return -self.ability:GetSpecialValueFor("damage_down")*0.01 *self.damage  end
function modifier_creep_special_gain_Agility_Gain:GetModifierAttackSpeedBonus_Constant() 	return self.ability:GetSpecialValueFor("bonus_attack_speed") end
function modifier_creep_special_gain_Agility_Gain:GetModifierMoveSpeedBonus_Percentage()	return self.ability:GetSpecialValueFor("bonus_move") end
function modifier_creep_special_gain_Agility_Gain:GetModifierIgnoreMovespeedLimit()	return 1 end

