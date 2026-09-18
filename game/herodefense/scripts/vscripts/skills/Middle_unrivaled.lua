Middle_unrivaled = class({})
LinkLuaModifier( "modifier_Middle_unrivaled", "skills/Middle_unrivaled", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function Middle_unrivaled:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_Sven.SignetLayer")

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local gain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_Middle_unrivaled", {duration = self:GetSpecialValueFor("duration")*gain})

end


modifier_Middle_unrivaled = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_unrivaled:IsHidden()	return false end
function modifier_Middle_unrivaled:IsDebuff()	return false end
function modifier_Middle_unrivaled:IsPurgable()	return false end
function modifier_Middle_unrivaled:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end



function modifier_Middle_unrivaled:GetEffectName()
	return "particles/rebuild/spell/unrivaled/unrivaled_ambient.vpcf"
end

function modifier_Middle_unrivaled:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Middle_unrivaled:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	
		

	}
end

function modifier_Middle_unrivaled:OnCreated()
	if IsServer() then
		self.bonus_damage = false
		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_sven_3") then
			self.bonus_damage = true
			return
		end
		self:StartIntervalThink(1)
	end
end

function modifier_Middle_unrivaled:OnIntervalThink()
	local caster =self:GetParent()
	if not caster:IsAlive() then
		return
	end
	
	local uints = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, 
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)


	if #uints>1 then
		self.bonus_damage = false
	else
		self.bonus_damage = true
	end


	


end

function modifier_Middle_unrivaled:GetActivityTranslationModifiers()	return "haste" end

-- function modifier_Middle_unrivaled:GetModifierTotalDamageOutgoing_Percentage(keys)	
--     if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK and self.bonus_damage  then
--         return 30
--     end
--     return 0
-- end

function modifier_Middle_unrivaled:Advanced_GetModifierAttackSpeedPercentage()	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_Middle_unrivaled:GetModifierMoveSpeedBonus_Percentage()	return  self:GetAbility():GetSpecialValueFor("bonus_move_speed") end



-- advanced_modifier
function modifier_Middle_unrivaled:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
    }

	return funcs

end
function modifier_Middle_unrivaled:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK and self.bonus_damage  then
        return 30
    end
    return 0
end
