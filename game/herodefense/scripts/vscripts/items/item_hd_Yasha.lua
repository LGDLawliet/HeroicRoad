item_hd_Yasha = class({})

LinkLuaModifier("modifier_item_hd_Yasha", "items/item_hd_Yasha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Yasha_active", "items/item_hd_Yasha", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_Yasha:GetIntrinsicModifierName()
	return "modifier_item_hd_Yasha"
end



modifier_item_hd_Yasha = advanced_modifier({})

function modifier_item_hd_Yasha:IsDebuff() return false end
function modifier_item_hd_Yasha:IsHidden() return true end
function modifier_item_hd_Yasha:IsPurgable() return false end

function modifier_item_hd_Yasha:OnCreated(keys)
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_agi = ability:GetSpecialValueFor("bonus_agi")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move = ability:GetSpecialValueFor("bonus_move")
	self.duration = ability:GetSpecialValueFor("duration")
end


function modifier_item_hd_Yasha:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK

	}
end
function modifier_item_hd_Yasha:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end

function modifier_item_hd_Yasha:OnAttack(keys)
	if keys.attacker == self:GetParent() and self:GetAbility() then
		local modifier = keys.target:FindModifierByName("modifier_item_hd_Yasha_active")
		if modifier then
			modifier:ForceRefresh()
			modifier:SetDuration(self.duration, true)
		else
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_Yasha_active", {duration = self.duration})
		end
	end
end
function modifier_item_hd_Yasha:Advanced_GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_item_hd_Yasha:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_item_hd_Yasha:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move
end
------
modifier_item_hd_Yasha_active = advanced_modifier({})

function modifier_item_hd_Yasha_active:IsDebuff() return true end
function modifier_item_hd_Yasha_active:IsHidden() return false end
function modifier_item_hd_Yasha_active:IsPurgable() return false end
function modifier_item_hd_Yasha_active:GetTexture() return "item_yasha" end
function modifier_item_hd_Yasha_active:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_armor_break = -ability:GetSpecialValueFor("active_break")
end

function modifier_item_hd_Yasha_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_item_hd_Yasha_active:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then self:Destroy() return end
	return self.bonus_armor_break
end
