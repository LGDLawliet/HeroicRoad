creep_special_gain_last_word = class({})

LinkLuaModifier("modifier_creep_special_gain_last_word", "special_gain/creep_special_gain_last_word", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_last_word_active", "special_gain/creep_special_gain_last_word", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_last_word:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_last_word"
end

-------------------------------------
modifier_creep_special_gain_last_word = advanced_modifier({})

function modifier_creep_special_gain_last_word:IsHidden() return false end
function modifier_creep_special_gain_last_word:IsPurgable() return false end
function modifier_creep_special_gain_last_word:IsDebuff() return false end
function modifier_creep_special_gain_last_word:GetEffectName() return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6_ring_edge.vpcf" end
function modifier_creep_special_gain_last_word:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_last_word:ADDeclareFunctions()
	return {

		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
	}
end
function modifier_creep_special_gain_last_word:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		if not keys.attacker then
			return
		end
		local parent = self:GetParent()
		local modifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(0.5)
        local statusResistance = keys.attacker:GetHDStatusResistanceIndex(0.8) * modifierStatusNegativeGain
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		keys.attacker:AddNewModifier(parent, self:GetAbility(), "modifier_creep_special_gain_last_word_active", {duration = duration*statusResistance})
		keys.attacker:EmitSound("Hero_Silencer.LastWord.Target")
    end
end




modifier_creep_special_gain_last_word_active = advanced_modifier({})

function modifier_creep_special_gain_last_word_active:IsDebuff() return true end
function modifier_creep_special_gain_last_word_active:IsHidden() return false end
function modifier_creep_special_gain_last_word_active:IsPurgable() return true end
function modifier_creep_special_gain_last_word_active:GetEffectName()	return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6_ring_edge.vpcf" end
function modifier_creep_special_gain_last_word_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_last_word_active:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creep_special_gain_last_word_active:OnCreated()
	self.bonus_mp_cost = self:GetAbility():GetSpecialValueFor("bonus_mp_cost")
end
function modifier_creep_special_gain_last_word_active:OnRefresh()
	self.bonus_mp_cost = self:GetAbility():GetSpecialValueFor("bonus_mp_cost")
end
function modifier_creep_special_gain_last_word_active:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
	}
end
function modifier_creep_special_gain_last_word_active:GetModifierPercentageManacostStacking()
	return -self.bonus_mp_cost
end