
Primary_chaos_form = class({})

LinkLuaModifier("modifier_Primary_chaos_form_transform", "skills/Primary_chaos_form", LUA_MODIFIER_MOTION_NONE)



function Primary_chaos_form:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	local duration = ability:GetSpecialValueFor("duration")	
	
	-- Start transformation gesture
	-- caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

	-- Play cast sound
	EmitSoundOn("Hero_ShadowDemon.Disruption", caster)

	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Primary_chaos_form_transform"

	local gain = caster:GetModifierDurationGainIndex(0.3)
	caster:AddNewModifier(caster, ability, "modifier_Primary_chaos_form_transform", {duration = duration*gain})

	local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)


end



modifier_Primary_chaos_form_transform = advanced_modifier({})
function modifier_Primary_chaos_form_transform:IsHidden()	return false end
function modifier_Primary_chaos_form_transform:IsPurgable()	return false end
function modifier_Primary_chaos_form_transform:IsDebuff()	return false end
function modifier_Primary_chaos_form_transform:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_10.vpcf" end
-- function modifier_item_hd_soul_of_balnock_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_chaos_form_transform:StatusEffectPriority() return 1000 end

function modifier_Primary_chaos_form_transform:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,         --技能伤害
			-- MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,        --施法距离
		}
		
		return decFuncs	
end
function modifier_Primary_chaos_form_transform:GetModifierModelScale() 
    return 30
end

function modifier_Primary_chaos_form_transform:GetModifierModelChange()
	return "models/items/warlock/golem/warlock_the_infernal_master_golem/warlock_the_infernal_master_golem.vmdl"
end

function modifier_Primary_chaos_form_transform:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()



	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")

    -- if IsServer() then
    -- end
end

-- function modifier_Primary_chaos_form_transform:OnDestroy()
--     if IsServer() then    	

	
    	
 	
--     end
-- end




function modifier_Primary_chaos_form_transform:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Primary_chaos_form_transform:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Primary_chaos_form_transform:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_Primary_chaos_form_transform:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification end

function modifier_Primary_chaos_form_transform:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_Primary_chaos_form_transform:Advanced_GetModifierCastRangeBonusStacking(keys)
	return (self.bonus_spell_range)
end
