item_hd_demons_heart_02 = class({})

LinkLuaModifier("modifier_item_hd_demons_heart_02", "items/item_hd_demons_heart_02", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_demons_heart_02_active", "items/item_hd_demons_heart_02", LUA_MODIFIER_MOTION_NONE)

function item_hd_demons_heart_02:GetIntrinsicModifierName()
	return "modifier_item_hd_demons_heart_02"
end

modifier_item_hd_demons_heart_02 = advanced_modifier({})

function modifier_item_hd_demons_heart_02:IsDebuff() return false end
function modifier_item_hd_demons_heart_02:IsHidden() return true end
function modifier_item_hd_demons_heart_02:IsPurgable() return false end


function modifier_item_hd_demons_heart_02:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_regeneration = self.ability:GetSpecialValueFor("bonus_regeneration")*0.01 * self:GetParent():GetMaxHealth()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self:StartIntervalThink(1)
end
function modifier_item_hd_demons_heart_02:OnIntervalThink(keys)
	if IsServer() and self:GetAbility():IsCooldownReady() then
		local healing = HealWithGain(self.bonus_regeneration,self:GetCaster(),self:GetParent() ,self:GetAbility())
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), healing, nil)
	end

end

function modifier_item_hd_demons_heart_02:AdvancedGetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_hd_demons_heart_02:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if unit~=self:GetParent() then
			return
		end
		if keys.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		self:GetAbility():UseResources(true, true, true, true)
    end 
end

function modifier_item_hd_demons_heart_02:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
	return funcs
end
