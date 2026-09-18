chaotic_era_buffskill_6 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_6", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_6", LUA_MODIFIER_MOTION_NONE)

function chaotic_era_buffskill_6:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_6"
end

modifier_chaotic_era_buffskill_6 = advanced_modifier({})

function modifier_chaotic_era_buffskill_6:IsDebuff() return false end
function modifier_chaotic_era_buffskill_6:IsHidden() return false end
function modifier_chaotic_era_buffskill_6:IsPurgable() return false end
function modifier_chaotic_era_buffskill_6:GetEffectName() return "particles/units/heroes/hero_morphling/morphling_ambient_new_.vpcf" end
function modifier_chaotic_era_buffskill_6:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_era_buffskill_6:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.speed = self.ability:GetSpecialValueFor("speed")
end

function modifier_chaotic_era_buffskill_6:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
	}
	return funcs
end

function modifier_chaotic_era_buffskill_6:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_6:Advanced_GetModifierAttackSpeedPercentage()
    return self.speed
end
function modifier_chaotic_era_buffskill_6:GetModifierMoveSpeedBonus_Percentage()
    return self.speed
end


function modifier_chaotic_era_buffskill_6:CheckState()
    return{
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end