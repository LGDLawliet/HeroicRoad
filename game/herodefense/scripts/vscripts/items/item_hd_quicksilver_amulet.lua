item_hd_quicksilver_amulet = class({})

LinkLuaModifier("modifier_item_hd_quicksilver_amulet", "items/item_hd_quicksilver_amulet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_quicksilver_amulet_active", "items/item_hd_quicksilver_amulet", LUA_MODIFIER_MOTION_NONE)

-- require('internal/timers')   --计时器功能
function item_hd_quicksilver_amulet:GetIntrinsicModifierName()
	return "modifier_item_hd_quicksilver_amulet"
end

modifier_item_hd_quicksilver_amulet = advanced_modifier({})

function modifier_item_hd_quicksilver_amulet:IsDebuff() return false end
function modifier_item_hd_quicksilver_amulet:IsHidden() return true end
function modifier_item_hd_quicksilver_amulet:IsPurgable() return false end
function modifier_item_hd_quicksilver_amulet:IsPurgeException() return false end
function modifier_item_hd_quicksilver_amulet:RemoveOnDeath() return false end


function modifier_item_hd_quicksilver_amulet:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
end


function modifier_item_hd_quicksilver_amulet:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_EVENT_ON_ATTACK,
	}
end


function modifier_item_hd_quicksilver_amulet:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_quicksilver_amulet:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		if self:GetParent() == attacker and self:GetAbility():IsCooldownReady() then
			local modifier = attacker:FindModifierByName("modifier_item_hd_quicksilver_amulet_active")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(self.duration, true)
			else
				attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_quicksilver_amulet_active", {duration = self.duration})
			end
		end
	end
end
---------


if modifier_item_hd_quicksilver_amulet_active == nil then
	modifier_item_hd_quicksilver_amulet_active = advanced_modifier({})
end
function modifier_item_hd_quicksilver_amulet_active:IsHidden()return true end
function modifier_item_hd_quicksilver_amulet_active:IsDebuff()return false end
function modifier_item_hd_quicksilver_amulet_active:IsPurgable()return false end
function modifier_item_hd_quicksilver_amulet_active:IsPurgeException()return false end
function modifier_item_hd_quicksilver_amulet_active:AllowIllusionDuplicate()return false end
function modifier_item_hd_quicksilver_amulet_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
end
function modifier_item_hd_quicksilver_amulet_active:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	self.bonus =  self:GetAbility():GetSpecialValueFor("active")
end
function modifier_item_hd_quicksilver_amulet_active:GetModifierEvasion_Constant()
	if not self:GetAbility() then self:Destroy() return end
	return self.bonus
end


