LinkLuaModifier( "modifier_chaotic_backstab_mastery", "chaotic_spell/class_2/chaotic_backstab_mastery.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_backstab_mastery_buff", "chaotic_spell/class_2/chaotic_backstab_mastery.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_backstab_mastery = class({})


function chaotic_backstab_mastery:GetIntrinsicModifierName()
	return "modifier_chaotic_backstab_mastery"
end
---------------------------------------------------------------------

modifier_chaotic_backstab_mastery = advanced_modifier({})

function modifier_chaotic_backstab_mastery:IsHidden() return true end
function modifier_chaotic_backstab_mastery:IsPurgable() return false end

function modifier_chaotic_backstab_mastery:OnCreated(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_chaotic_backstab_mastery:OnRefresh(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_chaotic_backstab_mastery:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_chaotic_backstab_mastery:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and self:GetParent():IsAlive() then
			local backstab_modifier = self:GetParent():FindModifierByName("modifier_hd_backstab")
			if backstab_modifier then
				if backstab_modifier:IsBackstab(params.attacker, params.target) then
					self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_chaotic_backstab_mastery_buff",{duration = self.duration})
				end
			else
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hd_backstab", {})
			end
		end
	end
end
--------------------------

modifier_chaotic_backstab_mastery_buff = advanced_modifier({})
function modifier_chaotic_backstab_mastery_buff:IsHidden() return false end
function modifier_chaotic_backstab_mastery_buff:IsDebuff() return false end
function modifier_chaotic_backstab_mastery_buff:IsPurgable() return false end

function modifier_chaotic_backstab_mastery_buff:OnCreated(params)
	self.move_speed = self:GetAbility():GetSpecialValueFor("move_speed")
	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
end
function modifier_chaotic_backstab_mastery_buff:OnRefresh(params)
	self.move_speed = self:GetAbility():GetSpecialValueFor("move_speed")
	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
end
function modifier_chaotic_backstab_mastery_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_chaotic_backstab_mastery_buff:GetModifierMoveSpeedBonus_Constant()
	return self.move_speed
end

function modifier_chaotic_backstab_mastery_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end