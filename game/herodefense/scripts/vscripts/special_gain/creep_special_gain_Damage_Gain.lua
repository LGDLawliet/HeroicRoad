creep_special_gain_Damage_Gain = class({})

LinkLuaModifier("modifier_creep_special_gain_Damage_Gain", "special_gain/creep_special_gain_Damage_Gain", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Damage_Gain:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Damage_Gain"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_Damage_Gain = class({})

function modifier_creep_special_gain_Damage_Gain:IsDebuff() return false end
function modifier_creep_special_gain_Damage_Gain:IsHidden() return false end
function modifier_creep_special_gain_Damage_Gain:IsPurgable() return false end
function modifier_creep_special_gain_Damage_Gain:GetEffectName() return "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_body_ambient.vpcf" end
function modifier_creep_special_gain_Damage_Gain:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_Damage_Gain:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	

	
end


function modifier_creep_special_gain_Damage_Gain:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
		

	}
end




function modifier_creep_special_gain_Damage_Gain:GetModifierBaseDamageOutgoing_Percentage() 	return self.ability:GetSpecialValueFor("bonus_damage") end
