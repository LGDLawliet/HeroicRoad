item_hd_arcane_bow = class({})

LinkLuaModifier("modifier_item_hd_arcane_bow", "items/item_hd_arcane_bow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_arcane_bow_active", "items/item_hd_arcane_bow", LUA_MODIFIER_MOTION_NONE)

function item_hd_arcane_bow:GetIntrinsicModifierName()
	return "modifier_item_hd_arcane_bow"
end


modifier_item_hd_arcane_bow = advanced_modifier({})

function modifier_item_hd_arcane_bow:IsDebuff() return false end
function modifier_item_hd_arcane_bow:IsHidden() return true end
function modifier_item_hd_arcane_bow:IsPurgable() 		return false end
function modifier_item_hd_arcane_bow:IsPurgeException() 	return false end
function modifier_item_hd_arcane_bow:RemoveOnDeath()  return false end

function modifier_item_hd_arcane_bow:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	self.duration = self.ability:GetSpecialValueFor("duration")
end


function modifier_item_hd_arcane_bow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_EVENT_ON_ATTACKED,                         --被攻击事件
		

	}
end


function modifier_item_hd_arcane_bow:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end
function modifier_item_hd_arcane_bow:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.bonus_attack_range or 0 end


function modifier_item_hd_arcane_bow:OnAttacked(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local modifier = keys.attacker:FindModifierByName("modifier_item_hd_arcane_bow_active")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(self.duration, true)
			else
				keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_arcane_bow_active", {duration = self.duration})
			end
		end
	end
end

function modifier_item_hd_arcane_bow:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end



modifier_item_hd_arcane_bow_active = advanced_modifier({})

function modifier_item_hd_arcane_bow_active:IsDebuff() return false end
function modifier_item_hd_arcane_bow_active:IsHidden() return true end
function modifier_item_hd_arcane_bow_active:IsPurgable() return true end

function modifier_item_hd_arcane_bow_active:ADDeclareFunctions()
	return {

		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 

	}
end

function modifier_item_hd_arcane_bow_active:Advanced_GetModifierTotalDamageOutgoing_Percentage() 
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("active") 
	end

end