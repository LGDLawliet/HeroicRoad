Primary_unrivaled = class({})
LinkLuaModifier( "modifier_Primary_unrivaled", "skills/Primary_unrivaled", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function Primary_unrivaled:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_Sven.SignetLayer")

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local gain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_Primary_unrivaled", {duration = self:GetSpecialValueFor("duration")*gain})

end


modifier_Primary_unrivaled = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_unrivaled:IsHidden()	return false end
function modifier_Primary_unrivaled:IsDebuff()	return false end
function modifier_Primary_unrivaled:IsPurgable()	return false end
function modifier_Primary_unrivaled:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end



function modifier_Primary_unrivaled:GetEffectName()
	return "particles/rebuild/spell/unrivaled/unrivaled_ambient.vpcf"
end

function modifier_Primary_unrivaled:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Primary_unrivaled:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,


	}
end


function modifier_Primary_unrivaled:GetActivityTranslationModifiers()	return "haste" end

function modifier_Primary_unrivaled:Advanced_GetModifierAttackSpeedPercentage()	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_Primary_unrivaled:GetModifierMoveSpeedBonus_Percentage()	return  self:GetAbility():GetSpecialValueFor("bonus_move_speed") end

function modifier_Primary_unrivaled:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end
