------
---该技能可直接复制作为可以多重叠加的光环技能 但可能单位死亡后会丢失图标
creeps_spell_Frozen_Soil = class({})

LinkLuaModifier("modifier_creeps_spell_Frozen_Soil_passive", "creeps_spell/creeps_spell_Frozen_Soil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Frozen_Soil_effect", "creeps_spell/creeps_spell_Frozen_Soil", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_Frozen_Soil_effect_forzen", "creeps_spell/creeps_spell_Frozen_Soil", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Frozen_Soil:GetIntrinsicModifierName() return "modifier_creeps_spell_Frozen_Soil_passive" end

modifier_creeps_spell_Frozen_Soil_passive = class({})

function modifier_creeps_spell_Frozen_Soil_passive:IsHidden() return true end
function modifier_creeps_spell_Frozen_Soil_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Frozen_Soil_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Frozen_Soil_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Frozen_Soil_passive:IsAura() return true end
function modifier_creeps_spell_Frozen_Soil_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Frozen_Soil_passive:GetModifierAura() return "modifier_creeps_spell_Frozen_Soil_effect" end
function modifier_creeps_spell_Frozen_Soil_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_Frozen_Soil_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Frozen_Soil_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creeps_spell_Frozen_Soil_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_creeps_spell_Frozen_Soil_effect = advanced_modifier({})

function modifier_creeps_spell_Frozen_Soil_effect:IsDebuff()			return true end
function modifier_creeps_spell_Frozen_Soil_effect:IsHidden() 			return false end
function modifier_creeps_spell_Frozen_Soil_effect:IsPurgable() 			return false end
function modifier_creeps_spell_Frozen_Soil_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_Frozen_Soil_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_creeps_spell_Frozen_Soil_effect:OnCreated()
    self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    if IsServer() then

        self.chance = self:GetAbility():GetSpecialValueFor("chance")
        
        self:StartIntervalThink(0.5)
    end
end

function modifier_creeps_spell_Frozen_Soil_effect:OnRefresh()
    self:OnCreated()
end

function modifier_creeps_spell_Frozen_Soil_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		

	}
end

function modifier_creeps_spell_Frozen_Soil_effect:OnTooltip()	
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end

function modifier_creeps_spell_Frozen_Soil_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_creeps_spell_Frozen_Soil_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)
    return self.damage


end












function modifier_creeps_spell_Frozen_Soil_effect:OnIntervalThink()
	if self.chance ~=nil then
        if RandomInt(1, 100)<self.chance then
            local ModifierStatusNegativeGain =self:GetAbility():GetCaster():GetModifierStatusNegativeGainIndex(1)
            local StatusResistance = self:GetParent():GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
            self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Frozen_Soil_effect_forzen", {duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance})
        end
    end
end
modifier_creeps_spell_Frozen_Soil_effect_forzen  = class({})

function modifier_creeps_spell_Frozen_Soil_effect_forzen:IsHidden()return false end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:IsDebuff()return true end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:IsPurgable()return true end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:IsPurgeException()return true end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:IsStunDebuff()    return false end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:AllowIllusionDuplicate()return false end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:GetStatusEffectName()    return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:StatusEffectPriority()    return 10 end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:GetEffectName()    return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:GetEffectAttachType()    return PATTACH_CENTER_FOLLOW end
function modifier_creeps_spell_Frozen_Soil_effect_forzen:CheckState()
    return {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end
