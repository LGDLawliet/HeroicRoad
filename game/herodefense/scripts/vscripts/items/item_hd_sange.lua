item_hd_sange = class({})

LinkLuaModifier("modifier_item_hd_sange", "items/item_hd_sange", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sange_active", "items/item_hd_sange", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_sange:GetIntrinsicModifierName()
	return "modifier_item_hd_sange"
end



modifier_item_hd_sange = advanced_modifier({})

function modifier_item_hd_sange:IsDebuff() return false end
function modifier_item_hd_sange:IsHidden() return true end
function modifier_item_hd_sange:IsPurgable() return false end

function modifier_item_hd_sange:OnCreated(keys)
    local ability = self:GetAbility()
	self.duration = ability:GetSpecialValueFor("duration")
	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_status_resistance = ability:GetSpecialValueFor("bonus_status_resistance")
	self.incoming_down = -ability:GetSpecialValueFor("incoming_down")

end

function modifier_item_hd_sange:Advanced_GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_item_hd_sange:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end
function modifier_item_hd_sange:Advanced_GetModifierIncomingDamage_Percentage()
	return self.incoming_down
end

function modifier_item_hd_sange:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
	return funcs
end

function modifier_item_hd_sange:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and keys.unit:IsAttacking() then
			local modifier = keys.unit:FindModifierByName("modifier_item_hd_sange_active")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(self.duration, true)
			else
				keys.unit:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_sange_active", {duration = self.duration})
			end
		end
	end

end

---------------------------

modifier_item_hd_sange_active = advanced_modifier({})

function modifier_item_hd_sange_active:IsDebuff() return false end
function modifier_item_hd_sange_active:IsHidden() return true end
function modifier_item_hd_sange_active:IsPurgable() return false end

function modifier_item_hd_sange_active:OnCreated(keys)
    local ability = self:GetAbility()
	self.active = ability:GetSpecialValueFor("active")*0.01*(self:GetParent():GetMaxHealth()-self:GetParent():GetHealth())
end

function modifier_item_hd_sange_active:OnRefresh(keys)
    local ability = self:GetAbility()
	self.active = ability:GetSpecialValueFor("active")*0.01*(self:GetParent():GetMaxHealth()-self:GetParent():GetHealth())
end

function modifier_item_hd_sange_active:AdvancedGetModifierConstantHealthRegen()
	return self.active
end

function modifier_item_hd_sange_active:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end
