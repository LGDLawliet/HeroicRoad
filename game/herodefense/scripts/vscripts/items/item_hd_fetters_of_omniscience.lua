item_hd_fetters_of_omniscience = class({})
-- LinkLuaModifier("modifier_item_hd_fetters_of_omniscience_arua", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_fetters_of_omniscience_arua_effect", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_fetters_of_omniscience", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_fetters_of_omniscience_active", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_fetters_of_omniscience_effect", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_fetters_of_omniscience_effect2", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_fetters_of_omniscience_active_standby", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_fetters_of_omniscience_debuff", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_fetters_of_omniscience_thinker", "items/item_hd_fetters_of_omniscience", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_fetters_of_omniscience:GetIntrinsicModifierName()
	return "modifier_item_hd_fetters_of_omniscience"
end


function item_hd_fetters_of_omniscience:OnSpellStart()

	local caster    =   self:GetCaster()
	-- local target = self:GetCursorTarget()
	caster:AddNewModifier(caster, self, "modifier_item_hd_fetters_of_omniscience_effect", {duration = 12})
	caster:EmitSound("Hero_Sven.GodsStrength")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

end



modifier_item_hd_fetters_of_omniscience = advanced_modifier({})

function modifier_item_hd_fetters_of_omniscience:IsDebuff() return false end
function modifier_item_hd_fetters_of_omniscience:IsHidden() return true end
function modifier_item_hd_fetters_of_omniscience:IsPurgable() return false end


function modifier_item_hd_fetters_of_omniscience:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	
	self.bonus_StatusGain = self.ability:GetSpecialValueFor("bonus_StatusGain")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")

end


function modifier_item_hd_fetters_of_omniscience:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力

	}
end


function modifier_item_hd_fetters_of_omniscience:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_fetters_of_omniscience:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_fetters_of_omniscience:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_fetters_of_omniscience:Advanced_GetModifier_DurationGain(keys)
	return self.bonus_StatusGain
end

function modifier_item_hd_fetters_of_omniscience:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


modifier_item_hd_fetters_of_omniscience_effect = advanced_modifier({})

function modifier_item_hd_fetters_of_omniscience_effect:IsDebuff()			return false end
function modifier_item_hd_fetters_of_omniscience_effect:IsHidden() 			return false end
function modifier_item_hd_fetters_of_omniscience_effect:IsPurgable() 		    return false end
function modifier_item_hd_fetters_of_omniscience_effect:IsPurgeException() 	return false end
function modifier_item_hd_fetters_of_omniscience_effect:RemoveOnDeath()       return false end
function modifier_item_hd_fetters_of_omniscience_effect:GetTexture()return "item_fetters_of_omniscience" end
-- function modifier_item_hd_fetters_of_omniscience_effect:GetStatusEffectName() return "particles/status_fx/status_effect_swiftslash.vpcf" end
-- function modifier_item_hd_fetters_of_omniscience_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_fetters_of_omniscience_effect:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_06.vpcf" end
function modifier_item_hd_fetters_of_omniscience_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_fetters_of_omniscience_effect:DeclareFunctions() return 
	{
	MODIFIER_PROPERTY_MODEL_SCALE
} end

function modifier_item_hd_fetters_of_omniscience_effect:GetModifierModelScale() 
    return 30
end

-- advanced_modifier
function modifier_item_hd_fetters_of_omniscience_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_DurationGain
    }
end
function modifier_item_hd_fetters_of_omniscience_effect:Advanced_GetModifierHealAMP_Percentage(keys)
	return 50
end

function modifier_item_hd_fetters_of_omniscience_effect:Advanced_GetModifier_DurationGain(keys)
	return 50
end

