item_hd_siltbreaker_rhyzik_eye = class({})

LinkLuaModifier("modifier_item_hd_siltbreaker_rhyzik_eye", "items/item_hd_siltbreaker_rhyzik_eye", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_siltbreaker_rhyzik_eye_active", "items/item_hd_siltbreaker_rhyzik_eye", LUA_MODIFIER_MOTION_NONE)

function item_hd_siltbreaker_rhyzik_eye:GetIntrinsicModifierName()
	return "modifier_item_hd_siltbreaker_rhyzik_eye"
end

function item_hd_siltbreaker_rhyzik_eye:OnSpellStart()

	local caster  =  self:GetCaster()
	self:StartCooldown(3)
	local modifier = caster:FindAllModifiersByName("modifier_item_hd_siltbreaker_rhyzik_eye_active")
	if #modifier>0 then
		modifier[1]:SafeDestroy()
		return
	end

	caster:AddNewModifier(caster, self, "modifier_item_hd_siltbreaker_rhyzik_eye_active", {})
end
-------------------------------------------------------------------------------

modifier_item_hd_siltbreaker_rhyzik_eye = advanced_modifier({})

function modifier_item_hd_siltbreaker_rhyzik_eye:IsDebuff() return false end
function modifier_item_hd_siltbreaker_rhyzik_eye:IsHidden() return true end
function modifier_item_hd_siltbreaker_rhyzik_eye:IsPurgable() return false end
function modifier_item_hd_siltbreaker_rhyzik_eye:IsPurgeException() return false end
function modifier_item_hd_siltbreaker_rhyzik_eye:RemoveOnDeath() return false end

function modifier_item_hd_siltbreaker_rhyzik_eye:OnCreated(keys)
	self.bonus_all_attribute = self:GetAbility():GetSpecialValueFor("bonus_attribute")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_resist = self:GetAbility():GetSpecialValueFor("bonus_resist")
end

function modifier_item_hd_siltbreaker_rhyzik_eye:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷     

	}
end
function modifier_item_hd_siltbreaker_rhyzik_eye:GetModifierBonusStats_Strength()return self.bonus_all_attribute end
function modifier_item_hd_siltbreaker_rhyzik_eye:GetModifierBonusStats_Intellect()return self.bonus_all_attribute end
function modifier_item_hd_siltbreaker_rhyzik_eye:GetModifierBonusStats_Agility()return self.bonus_all_attribute end

function modifier_item_hd_siltbreaker_rhyzik_eye:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end
function modifier_item_hd_siltbreaker_rhyzik_eye:AdvancedGetModifierConstantHealthRegen()return self.bonus_health_regen end
function modifier_item_hd_siltbreaker_rhyzik_eye:AdvancedGetModifierConstantManaRegen()return self.bonus_mana_regen end
function modifier_item_hd_siltbreaker_rhyzik_eye:Advanced_GetModifierIncomingDamage_Percentage()return -self.bonus_resist end
function modifier_item_hd_siltbreaker_rhyzik_eye:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys) return self.bonus_damage end

function modifier_item_hd_siltbreaker_rhyzik_eye:OnDestroy()
	if IsServer() then
		local modifier = self:GetParent():FindAllModifiersByName("modifier_item_hd_siltbreaker_rhyzik_eye_active")
		if #modifier>0 then
			modifier[1]:SafeDestroy()
			return
		end
	end
end

------------------------------------------------------------------------------------------------------
modifier_item_hd_siltbreaker_rhyzik_eye_active = advanced_modifier({})

function modifier_item_hd_siltbreaker_rhyzik_eye_active:IsDebuff() return false end
function modifier_item_hd_siltbreaker_rhyzik_eye_active:IsHidden() return false end
function modifier_item_hd_siltbreaker_rhyzik_eye_active:IsPurgable() return false end

function modifier_item_hd_siltbreaker_rhyzik_eye_active:OnCreated(keys)
	self.bonus_damage_2 = self:GetAbility():GetSpecialValueFor("bonus_damage_2")
	self.bonus_resist_2 = self:GetAbility():GetSpecialValueFor("bonus_resist_2")

end

function modifier_item_hd_siltbreaker_rhyzik_eye_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

    }
end
function modifier_item_hd_siltbreaker_rhyzik_eye_active:Advanced_GetModifierIncomingDamage_Percentage()
	return self.bonus_resist_2 
end
function modifier_item_hd_siltbreaker_rhyzik_eye_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys) return self.bonus_damage_2 end



