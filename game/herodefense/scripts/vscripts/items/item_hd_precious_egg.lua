item_hd_precious_egg = class({})

LinkLuaModifier("modifier_item_hd_precious_egg", "items/item_hd_precious_egg", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_precious_egg_active", "items/item_hd_precious_egg", LUA_MODIFIER_MOTION_NONE)

function item_hd_precious_egg:GetIntrinsicModifierName()
	return "modifier_item_hd_precious_egg"
end

modifier_item_hd_precious_egg = advanced_modifier({})

function modifier_item_hd_precious_egg:IsDebuff() return false end
function modifier_item_hd_precious_egg:IsHidden() return true end
function modifier_item_hd_precious_egg:IsPurgable() return false end

function modifier_item_hd_precious_egg:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
	self.duration = self.ability:GetSpecialValueFor("duration")

end


function modifier_item_hd_precious_egg:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},                       --受到伤害事件

	}
end


function modifier_item_hd_precious_egg:Advanced_GetModifierBonusStats_Strength()	return self.bonus_atb end
function modifier_item_hd_precious_egg:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_atb end
function modifier_item_hd_precious_egg:Advanced_GetModifierBonusStats_Agility()		return self.bonus_atb end


function modifier_item_hd_precious_egg:OnTakeDamage(keys)
    if IsServer() then  
		if keys.unit == self:GetParent() then
			if keys.damage<=0 or not self:GetAbility():IsCooldownReady() then	return	end
			if keys.unit:GetHealth() <= 0 then
				keys.unit:SetHealth(1)
				keys.unit:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_precious_egg_active", {duration = self.duration})
				self:GetAbility():UseResources(true, true, true, true)
			end
		end
    end 
end



modifier_item_hd_precious_egg_active = advanced_modifier({})

function modifier_item_hd_precious_egg_active:IsDebuff() return false end
function modifier_item_hd_precious_egg_active:IsHidden() return true end
function modifier_item_hd_precious_egg_active:IsPurgable() return false end
function modifier_item_hd_precious_egg_active:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return decFuncs	
end
function modifier_item_hd_precious_egg_active:CheckState()	
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] =true
	}
end
function modifier_item_hd_precious_egg_active:GetModifierModelScale() 
    return 50
end
function modifier_item_hd_precious_egg_active:GetModifierModelChange()
	return "models/props_winter/egg.vmdl"
end
function modifier_item_hd_precious_egg_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_item_hd_precious_egg_active:Advanced_GetModifierIncomingDamage_Percentage()
	return -100
end