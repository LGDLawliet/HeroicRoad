LinkLuaModifier( "modifier_chaotic_stealth", "chaotic_spell/class_1/chaotic_stealth.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_stealth_buff", "chaotic_spell/class_1/chaotic_stealth.lua", LUA_MODIFIER_MOTION_NONE )


chaotic_stealth = class({})


function chaotic_stealth:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stealth_duration")
	caster:AddNewModifier(caster, self, "modifier_chaotic_stealth", {duration = duration})
end

---------------------------------------------------------------------


modifier_chaotic_stealth = advanced_modifier({})


function modifier_chaotic_stealth:OnCreated(params)
	if IsServer() then
		self.stealth_duration = self:GetAbility():GetSpecialValueFor("stealth_duration")
		self.buff_duration = self:GetAbility():GetSpecialValueFor("buff_duration")
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_stealth:OnIntervalThink()
	if IsServer() then
		local modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hd_backstab", {duration = -1})
		modifier:SetStackCount(modifier:GetStackCount()+self:GetAbility():GetSpecialValueFor("backstab_stack"))
	end
end

function modifier_chaotic_stealth:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_chaotic_stealth:GetModifierInvisibilityLevel()
	return 1
end

function modifier_chaotic_stealth:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
	}
end

function modifier_chaotic_stealth:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chaotic_stealth_buff", {duration = self.buff_duration})
			self:Destroy()
		end
	end
end

modifier_chaotic_stealth_buff = advanced_modifier({})
function modifier_chaotic_stealth_buff:IsHidden() return false end
function modifier_chaotic_stealth_buff:IsDebuff() return false end
function modifier_chaotic_stealth_buff:IsPurgable() return false end

function modifier_chaotic_stealth_buff:OnCreated(params)
	self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
function modifier_chaotic_stealth_buff:OnRefresh(params)
	self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
function modifier_chaotic_stealth_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_chaotic_stealth_buff:GetModifierPreAttack_BonusDamage()
	return self.bonus_attack_damage
end

function modifier_chaotic_stealth_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

