item_hd_paw_of_lucius = class({})
-- LinkLuaModifier("modifier_item_hd_paw_of_lucius_arua", "items/item_hd_paw_of_lucius", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_paw_of_lucius_arua_effect", "items/item_hd_paw_of_lucius", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_paw_of_lucius", "items/item_hd_paw_of_lucius", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_paw_of_lucius_active", "items/item_hd_paw_of_lucius", LUA_MODIFIER_MOTION_NONE)

function item_hd_paw_of_lucius:GetIntrinsicModifierName()
	return "modifier_item_hd_paw_of_lucius"
end


modifier_item_hd_paw_of_lucius = advanced_modifier({})

function modifier_item_hd_paw_of_lucius:IsDebuff() return false end
function modifier_item_hd_paw_of_lucius:IsHidden() return true end
function modifier_item_hd_paw_of_lucius:IsPurgable() return false end

function modifier_item_hd_paw_of_lucius:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_hd_paw_of_lucius:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end
function modifier_item_hd_paw_of_lucius:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end

function modifier_item_hd_paw_of_lucius:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_paw_of_lucius:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then

			local modifier = keys.target:FindModifierByName("modifier_item_hd_paw_of_lucius_active")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(self.duration, true)
			else
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_paw_of_lucius_active", {duration = self.duration})
			end
			self:GetAbility():UseResources(true, true, true, true)

		end
	end
end

modifier_item_hd_paw_of_lucius_active = advanced_modifier({})

function modifier_item_hd_paw_of_lucius_active:IsDebuff() return true end
function modifier_item_hd_paw_of_lucius_active:IsHidden() return true end
function modifier_item_hd_paw_of_lucius_active:IsPurgable() return true end
function modifier_item_hd_paw_of_lucius_active:GetTexture()return "item_paw_of_lucius" end
function modifier_item_hd_paw_of_lucius_active:GetEffectName() return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf" end
function modifier_item_hd_paw_of_lucius_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_paw_of_lucius_active:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.heal_index = self.ability:GetSpecialValueFor("maxhp_heal_pct")*0.01
	end
end

function modifier_item_hd_paw_of_lucius_active:OnRefresh()
	if not self:GetAbility() then self:Destroy() return end
	self:OnCreated()
end

function modifier_item_hd_paw_of_lucius_active:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil,self:GetParent()},
	}
end

function modifier_item_hd_paw_of_lucius_active:OnAttackLanded(keys)
	if not self:GetAbility() then self:Destroy() return end
	if IsServer() then
		if keys.target == self:GetParent() and keys.attacker ~= nil then
			local heal = self.heal_index * keys.attacker:GetMaxHealth()
			local fhealing =  HealWithGain(heal,keys.attacker,keys.attacker,self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,keys.attacker, fhealing, nil)
		end
	end
end

