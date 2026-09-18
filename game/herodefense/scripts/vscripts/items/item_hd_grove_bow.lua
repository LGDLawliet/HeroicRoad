item_hd_grove_bow = class({})
-- LinkLuaModifier("modifier_item_hd_grove_bow_arua", "items/item_hd_grove_bow", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_grove_bow_arua_effect", "items/item_hd_grove_bow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_grove_bow", "items/item_hd_grove_bow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_grove_bow_active", "items/item_hd_grove_bow", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_grove_bow_active_standby", "items/item_hd_grove_bow", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_grove_bow_active_debuff", "items/item_hd_grove_bow", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_grove_bow:GetIntrinsicModifierName()
	return "modifier_item_hd_grove_bow"
end




modifier_item_hd_grove_bow = advanced_modifier({})

function modifier_item_hd_grove_bow:IsDebuff() return false end
function modifier_item_hd_grove_bow:IsHidden() return true end
function modifier_item_hd_grove_bow:IsPurgable() return false end


function modifier_item_hd_grove_bow:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_hd_grove_bow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_EVENT_ON_ATTACKED,                         --被攻击事件
	}
end

function modifier_item_hd_grove_bow:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end
function modifier_item_hd_grove_bow:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.bonus_attack_range or 0 end


function modifier_item_hd_grove_bow:OnAttacked(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local modifier = keys.target:FindModifierByName("modifier_item_hd_grove_bow_active")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(self.duration,true)
			else
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_grove_bow_active", {duration = self.duration})
			end
		end
	end
end

function modifier_item_hd_grove_bow:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,	
    }
end


modifier_item_hd_grove_bow_active = advanced_modifier({})

function modifier_item_hd_grove_bow_active:IsDebuff() return true end
function modifier_item_hd_grove_bow_active:IsHidden() return false end
function modifier_item_hd_grove_bow_active:IsPurgable() return true end
function modifier_item_hd_grove_bow_active:GetTexture()return "item_grove_bow" end
function modifier_item_hd_grove_bow_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_item_hd_grove_bow_active:Advanced_GetModifierIncomingDamage_Percentage()
	if not self:GetAbility() then self:Destroy() return end
	if self:GetAbility() then
    	return self:GetAbility():GetSpecialValueFor("incoming")
	end
end