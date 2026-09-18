creep_special_gain_Shrink = class({})

LinkLuaModifier("modifier_creep_special_gain_Shrink", "special_gain/creep_special_gain_Shrink", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Shrink:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Shrink"
end



require('internal/timers')   --计时器功能
modifier_creep_special_gain_Shrink = advanced_modifier({})

function modifier_creep_special_gain_Shrink:IsDebuff() return false end
function modifier_creep_special_gain_Shrink:IsHidden() return false end
function modifier_creep_special_gain_Shrink:IsPurgable() return false end
-- function modifier_creep_special_gain_Shrink:GetEffectName() return "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_body_ambient.vpcf" end
-- function modifier_creep_special_gain_Shrink:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_Shrink:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_armor = 0
	self.bonus_move = 0
	Timers:CreateTimer(0.3, function()
		self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		self.bonus_move = -self.ability:GetSpecialValueFor("bonus_move")
	end)	
	
end


function modifier_creep_special_gain_Shrink:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度

	}
end


function modifier_creep_special_gain_Shrink:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_creep_special_gain_Shrink:Advanced_GetModifierPhysicalArmorBonus() 	return self.bonus_armor end

function modifier_creep_special_gain_Shrink:GetModifierMoveSpeedBonus_Constant() 	return self.bonus_move end
